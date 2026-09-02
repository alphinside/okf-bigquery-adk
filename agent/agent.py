"""Marketplace analytics agent.

Business meaning comes from a local OKF bundle, through the one tool below.
SQL runs on Google's BigQuery MCP server. Swapping the bundle is the demo:

    OKF_BUNDLE=bundles/generated   adk run agent
    OKF_BUNDLE=bundles/marketplace adk run agent
"""

import os
import pathlib

import google.auth
import google.auth.transport.requests
from google.adk.agents import Agent
from google.adk.agents.readonly_context import ReadonlyContext
from google.adk.tools.mcp_tool import McpToolset
from google.adk.tools.mcp_tool.mcp_session_manager import StreamableHTTPConnectionParams

_REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent

# Relative to the repo root, so the command works from any directory.
OKF_BUNDLE = (_REPO_ROOT / os.environ.get("OKF_BUNDLE", "bundles/marketplace")).resolve()

# Every MCP tool call needs projectId. Leave it out and the model invents one.
PROJECT_ID = os.environ.get("PROJECT_ID") or os.environ["GOOGLE_CLOUD_PROJECT"]

BIGQUERY_SCOPE = "https://www.googleapis.com/auth/bigquery"


def read_okf_concept(path: str) -> dict:
    """Read one OKF concept document from the local bundle.

    Args:
        path: Path relative to the bundle root, for example "metrics/gmv.md".
            Call this with "index.md" first to find which concepts exist.

    Returns:
        'status', and on success 'content' with the raw markdown and frontmatter.
    """
    doc = (OKF_BUNDLE / path.lstrip("/")).resolve()
    # `path` is model-controlled. Block anything that escapes the bundle.
    if not doc.is_relative_to(OKF_BUNDLE) or not doc.is_file():
        return {"status": "error", "error": f"no concept at {path}"}
    return {"status": "success", "content": doc.read_text(encoding="utf-8")}


_credentials, _ = google.auth.default(scopes=[BIGQUERY_SCOPE])


def _bigquery_auth_header(context: ReadonlyContext) -> dict[str, str]:
    """Bearer token for the MCP server, refreshed only once it expires.

    ADK pools MCP sessions on a hash of the headers, so a fresh token string on
    every call opens a new session on every call.
    """
    if not _credentials.valid:
        _credentials.refresh(google.auth.transport.requests.Request())
    return {"Authorization": f"Bearer {_credentials.token}"}


bigquery_mcp = McpToolset(
    connection_params=StreamableHTTPConnectionParams(
        url="https://bigquery.googleapis.com/mcp",
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json, text/event-stream",
        },
        # Server kills queries at three minutes. Keep the read window wider.
        sse_read_timeout=300.0,
    ),
    # Not a static Authorization header: that freezes a token that expires.
    header_provider=_bigquery_auth_header,
    # execute_sql is the only writable tool here. tool_filter is configuration,
    # not a security boundary, so deny it in IAM as well.
    tool_filter=[
        "list_dataset_ids",
        "list_table_ids",
        "get_dataset_info",
        "get_table_info",
        "execute_sql_readonly",
    ],
)

root_agent = Agent(
    name="marketplace_analytics_agent",
    model="gemini-3.7-flash",
    description="Answers marketplace business questions over BigQuery.",
    instruction=(
        "You answer business questions about an online marketplace whose data "
        "lives in the BigQuery dataset 'marketplace'.\n"
        "Before writing any SQL: call read_okf_concept('index.md'), then read every "
        "concept the question touches: the metric, the payment status, the geography.\n"
        "Use only the filters, joins and period cuts those concepts define. "
        "Never invent a status value or a metric formula.\n"
        f"Run queries with execute_sql_readonly, passing projectId='{PROJECT_ID}'. "
        f"Fully qualify every table as `{PROJECT_ID}.marketplace.<table>`.\n"
        "Always aggregate. Results are capped at 3,000 rows and queries at three "
        "minutes, so never SELECT raw transaction rows.\n"
        "If a concept's frontmatter carries a stale_after date that has passed, say so "
        "in your answer instead of presenting the number as current.\n"
        "Show the SQL you ran, and name the concepts you relied on."
    ),
    tools=[read_okf_concept, bigquery_mcp],
)
