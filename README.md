# okf-bigquery-adk

A BigQuery analytics agent grounded in an Open Knowledge Format bundle: generate the half of the bundle a schema can derive, hand-write the half it cannot, and let an ADK agent answer business questions over the managed BigQuery MCP server.

Reference implementation supporting an upcoming blog post. Built from a frozen context bundle in [context/](context/).

> **Status:** seeded, not implemented. Nothing here runs yet.

## What this repo has to demonstrate

The blog's central claim is a contrast, and it only counts if a reader can reproduce **both halves**:

```bash
OKF_BUNDLE=bundles/generated   <run the agent>   # confident, wrong
OKF_BUNDLE=bundles/marketplace <run the agent>   # correct, and cites its concepts
```

One word apart. That means two committed bundles, and it means `bundles/generated/` must be **untouched generator output** — the moment it is hand-edited to look worse, the demonstration is a strawman.

See *The companion repository* in the context bundle for the full design rules before laying anything out.

## What you need

| Requirement | Version | Note |
|---|---|---|
| Python | ≥ 3.11 | required by the reference agent |
| `google-adk` | pin it | must include `header_provider` on `McpToolset` — **minimum release is unconfirmed upstream, find it and pin it** |
| `reference-agent` | from git | not on PyPI: `pip install git+https://github.com/GoogleCloudPlatform/open-knowledge-format` |
| Google Cloud project | — | BigQuery API enabled; sandbox tier expected to be enough |
| IAM roles | — | `roles/mcp.toolUser`, `roles/bigquery.jobUser`, `roles/bigquery.dataViewer` |

Cost of a full run: expected to be zero on the BigQuery sandbox and Gemini API free tier — **unverified upstream, confirm it**.

## Setup

```bash
# fill in once the layout is built
```

## Run

```bash
# fill in
```

## How you know it worked

The same question, asked against both bundles, returns **different answers** — and the `bundles/marketplace` answer names the OKF concepts it relied on. If both answers agree, the seed data is not adversarial enough and the demonstration is broken. See *Open questions* in the bundle.

## Layout

```text
context/    frozen source-of-truth bundle from the upstream brainstorming workspace
            + CORRECTIONS.md — findings that contradict the bundle
```

## Notes

- Versions are pinned deliberately. This backs published material and needs to still work later.
- Nothing in the context bundle was ever executed. Its identifiers are sourced and tagged; the assembled snippets are sketches. Proving them is this repo's job.
- Found something the bundle got wrong? Append it to [context/CORRECTIONS.md](context/CORRECTIONS.md). That is the return path upstream.
