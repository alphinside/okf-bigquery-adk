# FROZEN HANDOFF BUNDLE — Open Knowledge Format with BigQuery and Agent Development Kit

**Exported:** 2026-08-31 · **Source topic:** `okf-bigquery-adk` · **Phase at export:** `decided` → `exported`

This is a **frozen snapshot**. It is self-contained: you need no access to the workspace it came
from, and there is no way to ask it a follow-up question. Anything missing here is missing.

If the upstream context changes, a **new dated bundle** is produced — this file is never edited.

Read *Instructions for the downstream agent* at the very bottom before producing anything.

---

## Source frontmatter

```yaml
topic: Open Knowledge Format with BigQuery and Agent Development Kit
slug: okf-bigquery-adk
created: 2026-08-31
updated: 2026-08-31
phase: decided
primary_format: blog
downstream: [tutorial, repo]
audience: Backend, data and AI engineers building analytics agents on Google Cloud (global)
duration: 7-10 min read
owner: unassigned
google_cloud_products: [BigQuery, BigQuery MCP server, Agent Development Kit, Open Knowledge Format, Gemini Enterprise Agent Platform]
tags: [okf, open-knowledge-format, bigquery, bigquery-mcp, mcp, adk, agent-development-kit, text-to-sql, data-catalog, semantic-layer]
```

---

# Open Knowledge Format with BigQuery and Agent Development Kit — Source Context

> This is the source of truth for this topic. It is consumed by a downstream workspace that produces the actual material. Assume the reader has no access to the repo this came from. Every claim carries a status tag — see *Provenance* at the bottom.

## Thesis

A Text-to-SQL agent fails not on syntax but on the business decisions that were never written into the schema — so generate the derivable half of an Open Knowledge Format (OKF) bundle from your BigQuery dataset in one command, hand-write the half no generator can know, and an Agent Development Kit (ADK) agent grounds Indonesian enterprise semantics in Git rather than guessing them, with no vector database and no proprietary catalog [decided: notes.md 2026-08-31].

*Honesty constraint on the thesis:* grounding does not "eliminate hallucination" — the model can still ignore a concept it was told to read. Downstream must phrase the benefit as *grounded and auditable*, never as *guaranteed correct*, and should mention the `before_tool_callback` enforcement option [decided: notes.md 2026-08-31].

## Publishing constraints — read before writing a word

Two hard rules set by the owner on 2026-08-31 [decided: notes.md 2026-08-31]. They override anything below that contradicts them.

**1. No vendor or brand names anywhere in the data or the prose.** The payment-status vocabulary in this document was verified against a real payment gateway's public API reference (S7), and that citation stays here so the claim is auditable upstream. **The published blog, repo and dataset must not name that gateway, or any other commercial vendor.** Refer to "a payment gateway" / "the gateway's API". Google Cloud product names (BigQuery, ADK, OKF, Gemini) are the subject matter and are fine. The seeded data is synthetic and must contain no real company, merchant, or customer names.

**2. Global audience, English throughout.** The *scenario* stays an Indonesian marketplace — that is the point of it — but the *reader* is a backend, data or AI engineer anywhere. No Bahasa Indonesia in prompts, agent instructions, agent output, column values, or example questions. Everything runs and answers in English.

Rule 2 has an upside worth using deliberately: a reader in Berlin or São Paulo does not know what Jabodetabek is either. They meet the domain vocabulary with exactly the handicap the model has, which makes the argument land from inside rather than being asserted. So keep `QRIS`, `Jabodetabek` and IDR amounts — both are public standards or geography, not brands — and gloss each once, in one clause, the first time it appears.

## Decision & scope

**Making:** Two artifacts that ship together [decided: notes.md 2026-08-31]:

1. A focused 7–10 minute technical blog post structured as three acts — **generate** the OKF bundle from a BigQuery dataset with Google's reference agent, **teach** it what the generator could not know, then **consume** it with an ADK agent that answers Indonesian business questions over the BigQuery MCP server.
2. **A working repository** that the reader clones and runs end to end. The blog is the argument; the repo is the proof. Neither ships without the other.

**The three-act spine, stated once:**

| Act | Who does it | What it produces |
|---|---|---|
| Generate | `reference-agent enrich --source bq` | `datasets/`, `tables/`, auto-generated `index.md` — everything derivable from `INFORMATION_SCHEMA` [verified: S16, 2026-08-31] |
| Teach | A human, in a PR | `metrics/`, `references/` — the decisions no schema holds, carrying `verified` and `stale_after` |
| Consume | Our ADK agent + BigQuery MCP server | Correct SQL and a grounded English answer |

Act 2 is the load-bearing one. It is the answer to "who writes OKF?" — **both**, and the split between machine-derivable and human-decided *is* the article.

> Scope below is stated per artifact where the two differ. The blog and the repo do not carry the same material: anything the reader must *run* belongs to the repo, anything they must *understand* belongs to the post.

**In scope:**
- **Repo — runnable substrate:** `seed/schema.sql` and `seed/seed_data.sql` creating and populating the 2-table dataset, both committed bundles, the agent, and a README that goes clone → seed → ask. Act 1 points the reference agent at a dataset, so the repo must supply one [decided: notes.md 2026-08-31].
- **The Core Problem — correctness:** Why naive Text-to-SQL prompts and traditional Vector RAG fail against enterprise relational databases: loss of join integrity, and a missing domain glossary that no amount of schema introspection supplies [decided: notes.md 2026-08-31].
- **The Second Problem — re-derivation cost:** Even when the schema and every definition *are* available to the agent, handing it raw material means it must reason its way to the same conclusions again on every new session. That research phase costs tokens and latency on every conversation, and — worse — it is not deterministic: two sessions can read the same documents and settle on two different definitions of the same metric. OKF stores the *conclusion*, not the raw material, so the reasoning is done once and read thereafter [decided: notes.md 2026-08-31].
- **Introduction to Open Knowledge Format (OKF) v0.2:** Plain Markdown concept documents, YAML frontmatter where `type` is the only always-required key, bundle-root-absolute Markdown links, and the v0.2 trust fields (`sources`, `verified`, `stale_after`) — all living natively in Git [verified: S4, 2026-08-31].
- **The 3-Layer Architecture:** BigQuery (Data Layer) + OKF (Knowledge Layer in Git) + ADK (Action/Execution Layer) [decided: notes.md 2026-08-31].
- **Abstracted Marketplace Scenario (Indonesian domain, global reader):** A 2-table schema (`orders`, `payments`) paired with 4 OKF concept documents across `tables/`, `metrics/` and `references/`, following the directory and body conventions of the official `acme_retail` and `ga4` bundles [verified: S5, S14, S15, 2026-08-31; decided: notes.md 2026-08-31].
- **"Isn't OKF just an agent skill?":** Naming and answering the reader's most likely prior — OKF has a `type: Skill`, so a skill is one concept type inside a bundle, not a synonym for it [verified: S15, 2026-08-31].
- **ADK Python Agent Implementation:** High-level, copy-pasteable Python snippet pairing Google's **managed BigQuery MCP server** at `https://bigquery.googleapis.com/mcp` (execution, zero infrastructure) with one small custom OKF reader function tool (semantics) [verified: S10, S11, S12, 2026-08-31].
- **End-to-End Query Trace:** Demonstrating how the agent processes a natural language query (*"What was total GMV for successful QRIS payments in Jabodetabek last month?"*), inspects OKF concepts, produces valid BigQuery SQL, and returns a grounded answer that cites the concepts it used [decided: notes.md 2026-08-31].
- **GitOps for AI Knowledge:** How data and engineering teams collaborate on metrics using standard Git Pull Requests instead of hacking prompt strings [decided: notes.md 2026-08-31].

**Out of scope (deliberate):**
- Complex multi-agent supervisor/router graphs (keep to a clear, single-agent ADK setup suitable for a 7–10 min read) [decided: notes.md 2026-08-31].
- Seeding scripts **in the blog prose** — the post links to them and prints no DDL. They are *in scope for the repo*, where `seed/schema.sql` and `seed/seed_data.sql` are required: Act 1 points the reference agent at a dataset, so a dataset has to exist. Scope split, not a deferral [decided: notes.md 2026-08-31].
- Heavy DDL migrations, partitioning/clustering strategy, or anything resembling warehouse modelling advice — two tables, created once, never migrated [decided: notes.md 2026-08-31].
- Building custom frontend web UIs or deploying cloud services (focus strictly on agent architecture, OKF files, and BigQuery interaction) [decided: notes.md 2026-08-31].

## Audience

- **Who:** Backend engineers, data engineers and AI developers worldwide (mid-to-senior, Python and SQL) building analytics agents over a warehouse. No familiarity with Indonesia or its payment landscape is assumed [decided: notes.md 2026-08-31].
- **Already knows:** SQL fundamentals, basic BigQuery concepts, basic LLM prompting [assumption].
- **Gets wrong today:** Assuming that building an enterprise database chat assistant requires either fine-tuning models or chunking database documentation into high-cost vector search engines [assumption].
- **Second misconception, now explicitly targeted:** reading "Markdown with frontmatter in Git" and concluding OKF is just agent skills under another name. It is a reasonable prior — OKF even defines `type: Skill` — but it misses the declarative types, the linked graph, and the `sources` / `verified` / `stale_after` trust fields [decided: notes.md 2026-08-31; verified: S15, 2026-08-31].
- **Motivation:** Wants business users and product managers to query the warehouse in natural language without the agent hallucinating joins or miscalculating business metrics — misreading an integer status code as proof of payment, or confusing Gross Merchandise Value with net revenue [decided: notes.md 2026-08-31].
- **Why an Indonesian scenario for a global reader:** the domain vocabulary is unfamiliar *on purpose*. The reader hits `QRIS`, `Jabodetabek` and a status enum they have never seen and cannot guess — which is the model's situation exactly. Every reader has an equivalent in their own warehouse; the specificity makes the pattern transferable rather than parochial [decided: notes.md 2026-08-31].
- **Persona ref:** P1 (Evaluating Backend Dev) & P2 (Curious Data Person) [assumption].

## Narrative spine

The ordered beats for the 7–10 minute blog post:

| # | Beat | Point being made | Evidence / artifact |
|---|---|---|---|
| 1 | The Hook: The Hidden Cost of Naive SQL Agents | Naive Text-to-SQL prompts fail because LLMs know SQL syntax but not your company's unwritten business rules. Every warehouse has vocabulary no model can guess. | The payment-status trap: the gateway never returns `status = 'SUCCESS'`, and the obvious-looking `status_code = 200` is *not* proof of money received — it also covers `cancel`. Only `transaction_status = 'settlement'` is. Vocabulary mirrors a real gateway API, unnamed [verified: S7, 2026-08-31]. |
| 2 | The Semantic Gap: Why Vector RAG Isn't the Answer | Raw DDL overflows prompt limits, while chunking documentation into vector embeddings destroys the relational constraints and join rules exact SQL generation depends on. | Comparison table: Prompt Stuffing vs Vector RAG vs Structured Knowledge [assumption]. |
| 2b | "Just give the agent the docs and let it think" | The strongest counter-argument, met head-on. Give a capable model the full schema and every definition and it *will* often reason its way to the right answer — but it pays that reasoning again on every new session. Tokens and latency on every conversation, and no guarantee two sessions land on the same definition of GMV. Thinking is not free and it is not deterministic. **OKF stores the conclusion, not the raw material.** Derive once, review once, read cheaply forever. | The distinction between *context* (raw material the model must reason over) and *knowledge* (a conclusion already reached and signed off). This is also why `verified` exists: you cannot sign off on a conclusion that gets re-derived per session [decided: notes.md 2026-08-31]. |
| 3 | Enter Open Knowledge Format (OKF) v0.2 | OKF turns organizational knowledge into plain Markdown documents with YAML frontmatter, living inside Git with zero extra database infrastructure — and v0.2 makes trust a first-class field: `sources`, `verified` (who signed off, when), and `stale_after` (the instant a definition expires). | OKF v0.2 spec: `type` as the only always-required key, bundle-root-absolute links, reserved `index.md`/`log.md` [verified: S4, 2026-08-31]. |
| 4 | The 3-Layer Architecture | Production AI data assistants require a clean separation of concerns: **BigQuery** (Data), **OKF** (Semantics in Git), and **ADK** (Action/Agent Runtime). The layers are independently ownable — analysts own layer 2 without touching Python. | Architecture diagram showing data and knowledge flow [decided: notes.md 2026-08-31]. |
| 4b | "Isn't this just an agent skill?" | Answer the reader's prior before they act on it: a skill is one `type` inside OKF (`acme_retail/skills/run-on-bq.md` is literally `type: Skill`). Skills say how to act; OKF says what the words mean, who last checked, and when the answer expires. | Side-by-side comparison table [verified: S15, 2026-08-31]. |
| 5 | **Act 1 — Generate.** Point the reference agent at your dataset | You do not hand-write the boring half. Google ships an authoring agent; one command turns a BigQuery dataset into `datasets/`, `tables/` and auto-generated `index.md`, plus a browsable graph. | `reference-agent enrich --source bq --dataset PROJECT.marketplace --out bundles/okf_marketplace --no-web`, then `reference-agent visualize --bundle …`. Show the generated `tables/payments.md` [verified: S16, 2026-08-31]. |
| 6 | **Act 2 — Teach.** What the generator could not know | The turn of the article. The generated bundle is honest and still cannot answer the question: `INFORMATION_SCHEMA` has no opinion on whether `status_code = 200` means paid, on `settlement_ts` vs `order_ts`, or on which cities are Jabodetabek. A human adds `metrics/gmv.md` and `references/jabodetabek.md` — same format, same repo, one PR — carrying `verified` and `stale_after`. **Both machine and human write OKF; the split is the point.** | The two hand-written concept documents shown in full, next to the generated `tables/payments.md`. The tell is in the frontmatter, not in a diff: generated docs have no `verified` event and so read as `unverified`; the hand-written ones carry `verified` and `stale_after` [verified: S14, S16, 2026-08-31]. |
| 7 | **Act 3 — Consume.** The agent that answers | You write neither the execution layer nor a server. Google runs a **managed BigQuery MCP server** — one HTTPS endpoint, on with the BigQuery API. The only code in the whole post is a ~10-line OKF reader tool. | ADK Python agent: `McpToolset(StreamableHTTPConnectionParams(url="https://bigquery.googleapis.com/mcp", …), header_provider=…, tool_filter=[…read-only…])` + `read_okf_concept` [verified: S10, S11, S12, S13, 2026-08-31]. |
| 8 | End-to-End Query Trace in Action | Same question, two bundles, one word different on the command line. The generated-only bundle produces confident nonsense; the taught bundle produces correct SQL and names the concepts it relied on. That contrast is the proof, and both halves are committed and runnable. | Two terminal traces side by side; the `OKF_BUNDLE=bundles/generated` vs `bundles/marketplace` invocation [decided: notes.md 2026-08-31]. |
| 9 | GitOps, the Repo, and Key Takeaways | Changing a business metric is a PR on a Markdown file, not a backend redeploy — reviewable by the analyst who owns the definition, not just the engineer who owns the prompt. Deprecated definitions stay for historical reproducibility, as in Google's own `gross-margin-legacy.md`. Close on the repo: clone, seed, ask. | An illustrative diff **in the prose** on `metrics/gmv.md` bumping `verified` and `stale_after` — this is the argument, not a step the reader performs. Plus the repo link [verified: S5, 2026-08-31]. |

## Canonical claims

Every factual assertion the material may make. If it is not here, downstream must not assert it.

| Claim | Status | Source | Checked |
|---|---|---|---|
| Open Knowledge Format (OKF) is a "universal, vendor-neutral format for representing knowledge as plain markdown files with YAML frontmatter", introduced by Google Cloud and "not tied to any particular agent, framework, model provider, or serving system". | `[verified]` | S1 | 2026-08-31 |
| The current published OKF specification is **v0.2**. A bundle root `index.md` may optionally declare `okf_version: "0.2"`. | `[verified]` | S4 | 2026-08-31 |
| In OKF v0.2, `type` is "the only always-required key; a concept carrying just `type` is fully conformant". `title`, `description`, `resource`, `tags` are recommended, not required. | `[verified]` | S4 | 2026-08-31 |
| OKF `type` values are "not registered centrally" and consumers "MUST tolerate unknown types gracefully". Examples given by the spec include `BigQuery Table`, `BigQuery Dataset`, `Metric`, `Playbook`, `Reference`, `Attested Computation`. | `[verified]` | S4 | 2026-08-31 |
| An OKF bundle is "a directory tree of markdown files" and the unit of distribution; `index.md` and `log.md` are reserved names that cannot be concepts. Git is the recommended distribution channel. | `[verified]` | S4 | 2026-08-31 |
| OKF links are standard Markdown links in two forms. **SPEC.md recommends the bundle-root-absolute form** (beginning with `/`) because it survives moves; **the reference agent forbids it** — "Never start a link with `/` (that breaks GitHub rendering)" — and every published bundle uses file-relative links. This context follows the implementation. Consumers "MUST tolerate broken links". | `[verified]` | S4 vs S14, S15 | 2026-08-31 |
| Google's `src/reference_agent` is an **authoring** agent that writes OKF bundles from BigQuery metadata and web pages. It is not a consumer agent and does not answer questions from a bundle — that gap is what this post fills. | `[verified]` | S14 | 2026-08-31 |
| The reference agent ships a console script `reference-agent` with two subcommands: `enrich` (source → bundle) and `visualize` (bundle → self-contained HTML graph). A minimal run is `reference-agent enrich --source bq --dataset PROJECT.DATASET --out <bundle> --no-web`. | `[verified]` | S16 | 2026-08-31 |
| `bq` is the only source implemented (`_SOURCES = ("bq",)`). Its package name is `reference-agent`, requires Python ≥3.11 and `google-adk>=2.0`, `google-cloud-bigquery>=3.20`, `pyyaml`, `pydantic`, `markdownify`. | `[verified]` | S16 | 2026-08-31 |
| From a BigQuery dataset the reference agent emits exactly two concept types — one `BigQuery Dataset` document and one `BigQuery Table` document per table (sharded tables collapsed into a single family concept). It does **not** emit `Metric`, `Reference`, or any other type. | `[verified]` | S16 | 2026-08-31 |
| `index.md` files are machine-generated: the runner calls `regenerate_indexes(bundle_root)` after every enrich pass. | `[verified]` | S16 | 2026-08-31 |
| The optional web pass folds documentation pages into the same concept documents, bounded by `--web-max-pages` (default 100), `--web-max-depth` (default 2), and host/path allow-lists that default to seed hosts only. `--no-web` skips it. | `[verified]` | S16 | 2026-08-31 |
| `--concept tables/payments` re-enriches a single document, and `--model` defaults to `gemini-flash-latest`. | `[verified]` | S16 | 2026-08-31 |
| Therefore an OKF bundle is authored by machine and human together: the generator covers what `INFORMATION_SCHEMA` knows, and everything the schema cannot express is hand-written into the same bundle in the same format. | `[decided]` | notes.md | 2026-08-31 |
| The reference agent prescribes a table-document body shape: prose grain description, `# Schema`, `# Common query patterns` (1–3 SQL fences). Published docs add further sections, so it is a floor rather than a fixed schema. A `# Citations` section is explicitly forbidden — provenance lives in `sources`. | `[verified]` | S14, S15 | 2026-08-31 |
| Published concept documents carry **no H1 repeating the frontmatter `title`** — the body opens directly with its first real section (`# Schema`, `# Definition`). | `[verified]` | S15 | 2026-08-31 |
| `description` must be one sentence because auto-generated `index.md` files reuse it verbatim. `status` defaults to `stable` and only needs setting for `draft` or `deprecated`. Actor strings follow `<producer>/<version>`, `human:<id>`, or `process:<id>`. | `[verified]` | S14 | 2026-08-31 |
| `index.md` files in published bundles are plain heading-plus-link lists with no frontmatter, using file-relative links like `tables/index.md`. | `[verified]` | S15 | 2026-08-31 |
| The reference implementation **ignores a date-only `stale_after`** such as `2026-12-31`, because "a date-only value names a different instant in every timezone, so it is ignored rather than guessed at". An explicit UTC offset is required for staleness to be evaluated at all. | `[verified]` | S14 | 2026-08-31 |
| OKF defines `type: Skill` as one concept type among many. `bundles/acme_retail/skills/run-on-bq.md` is structured as *When to use / Preconditions / Steps / Post-conditions* — structurally indistinguishable from a Claude or Gemini agent skill. An agent skill is therefore a subset of OKF, not a synonym for it. | `[verified]` | S15 | 2026-08-31 |
| In-bundle `sources[].resource` values are bundle-root-relative **without** a leading slash (`policies/revenue-recognition.md`), while in-body links are file-relative (`../computations/revenue-ytd.md`). The two are not the same convention. | `[verified]` | S15 | 2026-08-31 |
| OKF v0.2 adds trust and freshness frontmatter: `sources` (each entry requires `resource`, with credibility signals `author`, `usage_count`, `last_modified`), `verified` (a list of `{by, at}` events), and `stale_after` (an absolute instant — "A concept is stale when `now >= stale_after`"). Credibility is inferred from signals, never stored as a score. | `[verified]` | S4 | 2026-08-31 |
| Google Cloud publishes an official sample bundle `bundles/acme_retail` in the OKF repo, grounded on BigQuery tables, with directories `tables/`, `metrics/`, `computations/`, `policies/`, `skills/`, `attesters/`. Its metrics include a deliberately retained deprecated definition (`gross-margin-legacy.md`, "kept for historical reproducibility"). | `[verified]` | S5 | 2026-08-31 |
| Agent Development Kit (ADK) is Google's multi-language framework (supporting Python, TypeScript, Go, Java, Kotlin) for building and running AI agents and multi-agent workflows. | `[verified]` | S2 | 2026-08-31 |
| Google operates a **managed, remote BigQuery MCP server** at `https://bigquery.googleapis.com/mcp`. It "is enabled when you enable the BigQuery API" — there is nothing to deploy or host. | `[verified]` | S10, S11 | 2026-08-31 |
| The BigQuery MCP server exposes exactly six tools: `list_dataset_ids`, `get_dataset_info`, `list_table_ids`, `get_table_info`, `execute_sql_readonly`, `execute_sql`. Every one requires a `projectId` argument. | `[verified]` | S11 (live `tools/list`) | 2026-08-31 |
| `execute_sql_readonly` is annotated `readOnlyHint: true` and is "restricted to only `SELECT` statements"; the server's own description says "Prefer this tool over `execute_sql` if possible". `execute_sql` is the only tool annotated `destructiveHint: true`, and per the docs it "is the only MCP tool that isn't read-only". | `[verified]` | S10, S11 | 2026-08-31 |
| Access is OAuth 2.0 + IAM with scope `https://www.googleapis.com/auth/bigquery`. Required roles: `roles/mcp.toolUser`, `roles/bigquery.jobUser`, `roles/bigquery.dataViewer`; required permissions: `mcp.tools.call`, `bigquery.jobs.create`, `bigquery.tables.getData`. | `[verified]` | S10 | 2026-08-31 |
| The MCP server has hard operational limits: queries running over three minutes "are automatically canceled", "Query results are limited to a maximum of 3,000 rows", Google Drive external tables are unsupported, and `execute_sql_readonly` rejects DML, DDL, Python UDFs and Graph Query Language (GQL). | `[verified]` | S10 | 2026-08-31 |
| "The BigQuery MCP server doesn't have its own quotas. There is no limit on the number of calls that can be made to the MCP server." Underlying BigQuery API quotas still apply, and jobs it runs are identifiable by the tag `goog-mcp-server:true`. | `[verified]` | S10 | 2026-08-31 |
| The `tools/list` JSON-RPC method on the BigQuery MCP server requires no authentication, so the tool catalogue can be inspected with a plain `curl`. | `[verified]` | S10, S11 | 2026-08-31 |
| ADK Python connects to a remote MCP server with `McpToolset(connection_params=StreamableHTTPConnectionParams(url=…, headers=…), tool_filter=[…])`, imported from `google.adk.tools.mcp_tool` and `google.adk.tools.mcp_tool.mcp_session_manager`. `tool_filter` is a parameter of `McpToolset`, not of the connection params. | `[verified]` | S12 | 2026-08-31 |
| `McpToolset` accepts a `header_provider` keyword argument: `Callable[[ReadonlyContext], dict[str, str] \| Awaitable[dict[str, str]]]`. It may be sync or async, and is called when a session is built, so a bearer token can be refreshed per request rather than frozen at startup. | `[verified]` | S13 (ADK source) | 2026-08-31 |
| `header_provider` headers are merged onto the connection params' base `headers`; headers from an exchanged auth credential are applied afterwards and win on conflict. The provider only fires when a `ReadonlyContext` is present. | `[verified]` | S13 | 2026-08-31 |
| MCP sessions are pooled on an MD5 of the merged headers, so a `header_provider` returning a *new* token string on every call opens a new session every call. Returning a token that stays stable until expiry keeps one pooled session per token lifetime. | `[verified]` | S13 | 2026-08-31 |
| `StreamableHTTPConnectionParams` also exposes `timeout` (default `5.0`s, connection establishment), `sse_read_timeout` (default `300.0`s), `terminate_on_close` and `httpx_client_factory` — none of which appear on the public docs page. | `[verified]` | S13 | 2026-08-31 |
| ADK can inject Application Default Credentials automatically for `*.googleapis.com` MCP hosts, refreshing on expiry and skipping injection if an `Authorization` header is already set. **But it only activates on the mTLS transport path** — it requires `google.auth.aio`, `GOOGLE_API_USE_CLIENT_CERTIFICATE` not set to `false`, and a client certificate that makes the channel genuinely mTLS. Without a device certificate this never fires, so it is not a substitute for explicit auth. It also requests the `cloud-platform` scope, not `bigquery`. | `[verified]` | S13 | 2026-08-31 |
| ADK Python **does** also ship a first-party `BigQueryToolset` (v1.1.0+, with `WriteMode.BLOCKED`). It is a valid alternative that this post deliberately does not use. | `[verified]` | S6 | 2026-08-31 |
| In ADK Python, a tool is a plain typed function with a docstring passed into `Agent(tools=[...])`; the agent's system prompt parameter is `instruction`. Tool parameters must be type-hinted with no default values, and tools should return a dict. | `[verified]` | S8 | 2026-08-31 |
| `gemini-3.7-flash` is the current stable Flash model, described as "our latest and most capable Flash model, built for complex coding, agentic workflows, and reliable multi-step execution". `gemini-2.5-flash` remains supported; `gemini-2.0-flash` has been shut down. | `[verified]` | S9 | 2026-08-31 |
| A major Indonesian payment gateway returns `transaction_status` as a string enum — `authorize`, `capture`, `settlement`, `pending`, `deny`, `cancel`, `expire`, `refund`, `partial_refund`, `chargeback`, `partial_chargeback`, `failure`. There is no `SUCCESS` value. Only `settlement` means funds have been credited to the merchant's account. **Do not name the gateway in published material** — see *Publishing constraints*. | `[verified]` | S7 | 2026-08-31 |
| On the same gateway, API `status_code` `200` means the request succeeded, but it spans transaction statuses `authorize`, `capture`, `settlement` **and** `cancel` — so `status_code = 200` alone does not prove money was received. `201` = pending, `202` = denied. Same naming constraint applies. | `[verified]` | S7 | 2026-08-31 |
| The status vocabulary used in the article is therefore representative of real gateway APIs rather than invented, even though the article attributes it to no vendor. Downstream may state that it "mirrors a real payment gateway's public API" but must not say which. | `[decided]` | notes.md | 2026-08-31 |
| Abstracting table schemas to essential relational keys while providing rich domain glossary files in OKF enables deterministic SQL generation without prompt token bloat. | `[decided]` | notes.md | 2026-08-31 |
| An agent given raw schema and documentation must re-derive the same semantic conclusions on every new session, paying tokens and latency each time, with no guarantee that two sessions converge on the same definition. Storing the conclusion instead of the raw material moves that cost from per-session to once. | `[decided]` | notes.md | 2026-08-31 |
| The post must not claim a measured token or latency saving. The re-derivation argument is structural, not benchmarked — no such measurement has been made here. | `[decided]` | notes.md | 2026-08-31 |
| The blog's OKF bundle should mirror the `acme_retail` directory conventions rather than invent new ones, so readers can move between the post and the official sample. | `[decided]` | notes.md | 2026-08-31 |
| The enterprise surface for model access is **Gemini Enterprise Agent Platform** (GEAP). "Vertex AI" is the former name and must not appear in published material, except where quoting a source verbatim or naming the unchanged `GOOGLE_GENAI_USE_VERTEXAI` environment variable. | `[decided]` | notes.md | 2026-08-31 |
| Other payment gateways use their own non-`SUCCESS` status vocabularies. | `[UNVERIFIED]` | — | 2026-08-31 |

## Source materials

| # | Source | Kind | Given by / on | Why it matters here | Local copy |
|---|---|---|---|---|---|
| S1 | `https://github.com/GoogleCloudPlatform/open-knowledge-format` | repo / spec | user, 2026-08-31 | Primary repository and specification for the Open Knowledge Format (OKF) | — |
| S2 | `https://adk.dev/` | doc / site | user, 2026-08-31 | Official documentation site for Agent Development Kit (ADK) | — |
| S3 | `https://github.com/google/skills/blob/main/skills/cloud/bigquery-basics` | repo / skill | user, 2026-08-31 | Google official skills repo covering BigQuery agent workflows | — |
| S4 | `https://github.com/GoogleCloudPlatform/open-knowledge-format/blob/main/SPEC.md` | spec | agent research, 2026-08-31 | The normative OKF v0.2 specification. Backs every claim about required fields, links, bundles, and the trust fields | — |
| S5 | `https://github.com/GoogleCloudPlatform/open-knowledge-format/tree/main/bundles/acme_retail` | repo / sample | agent research, 2026-08-31 | Google's official BigQuery-grounded retail sample bundle. Sets the directory conventions and the real-world frontmatter shape our bundle imitates. Also the closest prior art to this post | — |
| S6 | `https://adk.dev/integrations/bigquery/index.md` | doc | agent research, 2026-08-31 | ADK's first-party BigQuery toolset. **Rejected alternative** — kept so downstream knows it exists and why it was not chosen | — |
| S10 | `https://docs.cloud.google.com/bigquery/docs/use-bigquery-mcp` | doc (primary) | **user, 2026-08-31** | The execution layer this post uses. Endpoint, auth, IAM roles, tool set, limits, quotas | — |
| S11 | Live `tools/list` response from `https://bigquery.googleapis.com/mcp` | live API probe | agent research, 2026-08-31 | Authoritative tool names, annotations and required parameters — the reference doc page did not render them | — |
| S12 | `https://adk.dev/tools-custom/mcp-tools/index.md` | doc | agent research, 2026-08-31 | ADK-side wiring for a remote MCP server: `McpToolset`, `StreamableHTTPConnectionParams`, headers, `tool_filter`. **Incomplete — omits `header_provider` and the connection timeouts.** Trust S13 over this page | — |
| S13 | `https://github.com/google/adk-python` → `src/google/adk/tools/mcp_tool/mcp_toolset.py` and `mcp_session_manager.py` (branch `main`) | source code | **user pointed at `header_provider`, 2026-08-31** | Authoritative ADK MCP behaviour: `header_provider`, header merge order, session pooling, connection timeouts, ADC auto-injection | — |
| S14 | `https://github.com/GoogleCloudPlatform/open-knowledge-format/tree/main/src/reference_agent` | source code | **user, 2026-08-31** | Google's own OKF authoring agent. Settles body conventions, link form, required frontmatter, and what the reference implementation actually enforces | — |
| S16 | `open-knowledge-format@main` → `src/reference_agent/{cli.py, runner.py, sources/bigquery.py, __main__.py}` and `pyproject.toml` | source code | agent research, 2026-08-31 | The runnable surface of Act 1: CLI subcommands, flags, install requirements, and exactly which concept types a BigQuery dataset produces | — |
| S15 | Raw bundle documents: `bundles/acme_retail/{index.md, tables/orders.md, metrics/revenue.md, skills/index.md, skills/run-on-bq.md}`, `bundles/ga4/index.md` | repo / sample | agent research, 2026-08-31 | The real published shape of concept documents, index files, and an OKF `type: Skill` | — |
| S7 | `https://docs.midtrans.com/reference/transaction-status.md` and `https://docs.midtrans.com/reference/code-2xx.md` | doc (primary, vendor) | agent research, 2026-08-31 | Ground truth for the article's hook: the real Indonesian payment status vocabulary | — |
| S8 | ADK Python cheatsheet, `google-agents-cli-adk-code` skill (`references/adk-python.md`) | internal / skill | agent research, 2026-08-31 | Canonical ADK Python agent + function-tool authoring rules | Local skill, not public — extract carries the weight |
| S9 | `https://ai.google.dev/gemini-api/docs/models` | doc | agent research, 2026-08-31 | Current Gemini model IDs and shutdown status | — |

### Extracts

**S1 — Open Knowledge Format (OKF)**
> "OKF is an open-source, vendor-neutral specification introduced by Google Cloud to solve the context-assembly problem for AI agents and humans. An OKF knowledge base is a directory of standard Markdown (.md) files bundled together with YAML frontmatter (with 'type' as the core required field). Files interlink using standard Markdown hyperlinks, naturally mapping out a traversable knowledge graph without requiring a proprietary SDK, heavy database, or complex RAG pipeline. Because they are plain text files, OKF bundles live natively in Git repositories."

**S2 — Agent Development Kit (ADK)**
> "Agent Development Kit (ADK) is an open framework from Google to build powerful multi-agent systems and conversational agents across Python, TypeScript/JS, Go, Java, and Kotlin, supporting graph workflows, collaborative agents, tool integrations, and runtime execution."

**S3 — Google Skills (BigQuery Basics)**
> "The google/skills repository includes compact, agent-first documentation and specialized technical specifications (SKILL.md) for AI coding assistants and agent harnesses. Cloud modules include BigQuery Basics providing context-efficient, production-grade instructions for BigQuery schema design, SQL generation, and query execution."

**S4 — OKF v0.2 specification (`SPEC.md`)** — quoted phrases, Google Cloud, retrieved 2026-08-31
> On required fields: "`type` is the only always-required key; a concept carrying just `type` is fully conformant." Conformance requires every frontmatter block "contains a non-empty `type` field."
>
> On types: "Type values are **not** registered centrally." Consumers "MUST tolerate unknown types gracefully." Examples listed: "`BigQuery Table`, `BigQuery Dataset`, `API Endpoint`, `Metric`, `Playbook`, `Reference`, `Attested Computation`".
>
> On bundles: "A self-contained, hierarchical collection of knowledge documents. The unit of distribution." · "A bundle is a directory tree of markdown files." Reserved names that cannot be concepts: `index.md`, `log.md`.
>
> On `index.md`: "An `index.md` file MAY appear in any directory, including the bundle root." · "Index files contain no frontmatter, with one exception: a bundle-root `index.md` MAY carry an `okf_version` key". Consumers "MAY synthesize one on the fly when none is present."
>
> On links: "Concepts MAY link to other concepts using standard markdown links. Two forms are supported" — the absolute form "begins with `/`, interpreted relative to the bundle root" and is recommended "because it survives moves". "A link from concept A to concept B asserts a *relationship*." "Consumers MUST tolerate broken links."
>
> On trust: "`sources` records the materials a concept derives from, external or internal to the bundle." · "Credibility is *inferred* from the signals, the same way trust tiers are, not stored." · "`verified`: A list of verification events, each with `by` (an actor) and `at` (an ISO 8601 datetime)." Trust tiers: absent ⇒ unverified; non-`human:` actors only ⇒ machine-confirmed; a `human:<id>` ⇒ human-reviewed — "advisory signals, not access control."
>
> On staleness: "`stale_after`: Optional. An absolute instant. A concept is stale when `now >= stale_after`." Absolute rather than a TTL so evaluation is "a plain comparison" independent of read time. "Every timestamp-valued key in OKF is an ISO 8601 datetime with an explicit UTC offset".

**S5 — `bundles/acme_retail`, the official BigQuery-grounded sample** — Google Cloud, retrieved 2026-08-31

Directory listing:

```text
bundles/acme_retail/
├── attesters/     # code that deterministically verifies computation receipts
├── computations/  # approved SQL, packaged as "Attested Computations", one per metric
├── metrics/       # Acme Retail's key figures defined in business terms
├── policies/      # authoritative Finance policy documents — "Source-of-truth"
├── skills/        # directions for executors on how to run the attested computations
├── tables/        # the BigQuery tables the bundle uses as its grounding data source
├── index.md
├── log.md
└── viz.html
```

`metrics/` contains `revenue.md`, `gross-margin.md`, and `gross-margin-legacy.md` — the last described as a "Deprecated pre-2026 formula, kept for historical reproducibility". `tables/` contains `orders.md`, "One row per completed customer order across web, mobile, and marketplace channels."

Frontmatter of `metrics/revenue.md`, as published:

```yaml
type: Metric
title: Revenue
description: Recognized revenue for a period, per Acme's FY2026 revenue-recognition policy. Backed by an Attested Computation.
tags: [finance, revenue, headline-metric]
generated: { by: reference_agent/gemini-2.5-pro, at: 2026-06-30T14:00:00Z }
verified: { by: human:jsmith@acme, at: 2026-07-01T09:00:00Z }
status: stable
stale_after: 2026-12-31T00:00:00Z
sources:
  - id: revenue-policy
    resource: policies/revenue-recognition.md
    title: Revenue Recognition Policy (FY2026)
    author: human:jsmith@acme
    last_modified: 2026-06-15T00:00:00Z
```

Body headings: *Definition* (the conditions an order must satisfy, the FX rule tied to `order_ts`, and a note that readers "MUST run and attest that computation rather than composing their own SUM"), *Reporting cuts* (channel/category breakdowns are "approved narrations, not new metrics"), *Trust and freshness* (VP Finance sign-off dated 2026-07-01; re-check against January's reissued policy before serving after 2027-01-01), then a `[^revenue-policy]` footnote whose label is the join key into `sources`.

**S6 — ADK BigQuery integration** — adk.dev, retrieved 2026-08-31
> Available in ADK Python v1.1.0 and later. `from google.adk.tools.bigquery import BigQueryToolset, BigQueryCredentialsConfig` and `from google.adk.tools.bigquery.config import BigQueryToolConfig, WriteMode`.
>
> Packaged tools: `list_dataset_ids`, `get_dataset_info`, `list_table_ids`, `get_table_info`, `get_job_info`, `execute_sql`, `forecast`, `analyze_contribution`, `detect_anomalies`, `ask_data_insights`, `search_catalog` (semantic search over datasets/tables through Dataplex).
>
> `BigQueryToolConfig(write_mode=WriteMode.BLOCKED)` is described as a config "to block any write operations". Credentials options: ADC via `google.auth.default()`, a service-account file, an external access token, `external_access_token_key` ("the key used to look up the access token in the session state"), or interactive OAuth with `client_id`/`client_secret` under `adk web`.
>
> Note: the doc page's own example pins `GEMINI_MODEL = "gemini-2.0-flash"`, which is now shut down — see S9.

**S7 — Payment gateway status vocabulary** — vendor's public API docs, retrieved 2026-08-31

> ⚠️ **Upstream provenance only. The vendor is named in this extract so the claim can be audited; it must not appear in the blog, the repo, or the seeded data.** See *Publishing constraints*. Quote the vocabulary, attribute it to "a real payment gateway", name no one.

`transaction_status` values, quoted:
> `settlement` — "The transaction is successfully settled. Funds have been credited to your account."
> `capture` — "The transaction is successful and the card balance is captured successfully. If no action is taken by you, the transaction will be successfully settled within 24 hours… It is safe to assume a successful payment."
> `pending` — "The transaction is created and is waiting to be paid by the customer at the payment providers…"
> `deny` — "The credentials used for payment are rejected by the payment provider or Midtrans Fraud Detection System (FDS)."
> `expire` — "The transaction is not available for processing, because the payment was delayed."
> `cancel`, `refund`, `partial_refund`, `chargeback`, `partial_chargeback`, `authorize`, `failure` are the remaining values. **There is no `SUCCESS`.**

API `status_code`, quoted:
> `200` — "**Payment Card**: `Success`. Request is successfully received and processed by Midtrans. Transaction status is authorize, capture, settlement, cancel. … **Other payment methods**: `Success`. The transaction status is settlement or cancel."
> `201` — "`Pending`. Transaction is successfully made but the 3D secure process has yet to be completed…"
> `202` — "`Denied`. The transaction has been processed but is denied by payment provider or Midtrans Fraud Detection System."
> Note in the docs: "Cancel notification payload has status code 202 instead of 200."

**S8 — ADK Python agent and tool authoring rules** — internal skill `google-agents-cli-adk-code`, retrieved 2026-08-31
> Canonical agent shape: `from google.adk.agents import Agent`; `Agent(name=..., model=..., instruction=..., description=..., tools=[plain_python_function])`.
>
> Tool rules, quoted: "Use clear docstrings (sent to LLM)" · "Type hints required, NO default values" · "Return a dict (JSON-serializable)" · "Don't mention `tool_context` in docstring".
>
> Note: there is no `Tool.from_function(...)` constructor and no `system_instruction=` parameter in ADK Python. Wrapping is only needed for special cases, e.g. `FunctionTool(fn, require_confirmation=True)`.

**S10 — BigQuery MCP server** — Google Cloud docs, retrieved 2026-08-31
> It lets you "perform tasks such as running queries, getting metadata, and listing resources", and it "is enabled when you enable the BigQuery API." Remote MCP servers "Run on the service's infrastructure and offer an HTTP endpoint to AI applications."
>
> Endpoint: `https://bigquery.googleapis.com/mcp`. Transport: HTTP.
>
> Auth: the OAuth 2.0 protocol with IAM; accepted credentials are "your Google Cloud credentials, your OAuth Client ID and secret, or an agent identity and credentials". Scope `https://www.googleapis.com/auth/bigquery`. "Additional scopes might be required on the resources accessed during a tool call." Custom redirect URIs "aren't supported".
>
> Roles: `roles/mcp.toolUser`, `roles/bigquery.jobUser`, `roles/bigquery.dataViewer`. Permissions: `mcp.tools.call`, `bigquery.jobs.create`, `bigquery.tables.getData`. Billing optional — the BigQuery sandbox works.
>
> Read-only posture: "The only MCP tool that isn't read-only is `execute_sql`", which can be restricted with an IAM deny policy.
>
> Limits: no Google Drive external tables; "Queries that run longer than three minutes are automatically canceled"; "Query results are limited to a maximum of 3,000 rows"; the readonly tool blocks DML/DDL/Python UDFs and "doesn't support queries that use Graph Query Language (GQL)."
>
> Quotas: "The BigQuery MCP server doesn't have its own quotas. There is no limit on the number of calls that can be made to the MCP server." Jobs it runs carry the tag `goog-mcp-server:true`.
>
> Optional Model Armor floor settings (`--add-integrated-services=GOOGLE_MCP_SERVER`, `--google-mcp-server-enforcement-type=INSPECT_AND_BLOCK`) require enabling `modelarmor.googleapis.com`.
>
> The doc notes `tools/list` "doesn't require authentication" and shows:
> ```text
> POST /mcp HTTP/1.1
> Host: bigquery.googleapis.com
> Content-Type: application/json
>
> { "jsonrpc": "2.0", "method": "tools/list" }
> ```

**S11 — Live `tools/list` probe of `https://bigquery.googleapis.com/mcp`** — retrieved 2026-08-31

The published MCP reference page did not render its tool table, so the catalogue was read from the server itself:

```bash
curl -s -X POST https://bigquery.googleapis.com/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
```

Six tools, all requiring `projectId`:

| Tool | `readOnlyHint` | `destructiveHint` | Required args | Other params |
|---|---|---|---|---|
| `list_dataset_ids` | true | false | `projectId` | `pageSize`, `pageToken` |
| `get_dataset_info` | true | false | `projectId`, `datasetId` | — |
| `list_table_ids` | true | false | `projectId`, `datasetId` | `pageSize`, `pageToken` |
| `get_table_info` | true | false | `projectId`, `datasetId`, `tableId` | — |
| `execute_sql_readonly` | true | false | `projectId`, `query` | `dryRun`, `labels` |
| `execute_sql` | **false** | **true** | `projectId`, `query` | `dryRun`, `labels` |

Server-supplied descriptions, quoted:
> `execute_sql_readonly` — "Run a read-only SQL query in the project and return the result. Prefer this tool over `execute_sql` if possible. This tool is restricted to only `SELECT` statements. `INSERT`, `UPDATE`, and `DELETE` statements and stored procedures aren't allowed. If the query doesn't include a `SELECT` statement, an error is returned."
> `execute_sql` — "Run a SQL query in the project and return the result. Prefer the `execute_sql_readonly` tool if possible. This tool can execute any query that bigquery supports including: SQL Queries (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `CREATE`, etc.), AI/ML functions like `AI.FORECAST`, `ML.EVALUATE`, `ML.PREDICT`…"
> `list_dataset_ids` — "List BigQuery dataset IDs in a Google Cloud project. Supports pagination. Use `page_size` to limit results and `page_token` to retrieve next page." (Note the mismatch: prose says `page_size`, the schema field is `pageSize`.)

Note the tool set is **narrower than `BigQueryToolset`** — no `get_job_info`, `forecast`, `analyze_contribution`, `detect_anomalies`, `ask_data_insights` or `search_catalog`. It is discovery plus SQL, nothing more.

**S12 — ADK remote MCP wiring** — adk.dev, retrieved 2026-08-31
> `from google.adk.tools.mcp_tool import McpToolset` and `from google.adk.tools.mcp_tool.mcp_session_manager import StreamableHTTPConnectionParams`.
>
> The Google Maps example, quoted:
> ```python
> McpToolset(
>     connection_params=StreamableHTTPConnectionParams(
>         url="https://mapstools.googleapis.com/mcp",
>         headers={
>             "X-Goog-Api-Key": GOOGLE_MAPS_API_KEY,
>             "Content-Type": "application/json",
>             "Accept": "application/json, text/event-stream"
>         }
>     )
> )
> ```
> Bearer auth is shown as `headers={"Authorization": "Bearer your-auth-token"}`. `tool_filter` belongs to `McpToolset`, described as a way to "select a specific subset of tools from the MCP server".
>
> The page documents only `url` and `headers` on `StreamableHTTPConnectionParams`, and shows no per-request header hook for Python. **Both omissions are wrong — see S13.** The Kotlin section does document `headerProvider`, noting it "is suspend, so fetchToken() can await a fresh token per request".
>
> **Trap in the official docs:** the Agent Runtime example writes `headers={'Authorization': 'Bearer $(gcloud auth print-access-token)'}` inside Python. Shell command substitution does not happen in a Python string literal — copied as-is this sends the literal text `$(gcloud auth print-access-token)` as the token. Do not reproduce it.

**S13 — ADK Python MCP source** — `google/adk-python@main`, read 2026-08-31

`McpToolset.__init__` signature (`src/google/adk/tools/mcp_tool/mcp_toolset.py`), quoted:

```python
def __init__(
    self,
    *,
    connection_params: (
        StdioServerParameters
        | StdioConnectionParams
        | SseConnectionParams
        | StreamableHTTPConnectionParams
    ),
    tool_filter: ToolPredicate | list[str] | None = None,
    tool_name_prefix: str | None = None,
    tool_list_cache_ttl_seconds: float | None = None,
    errlog: TextIO = sys.stderr,
    auth_scheme: AuthScheme | None = None,
    auth_credential: AuthCredential | None = None,
    require_confirmation: bool | Callable[..., bool] = False,
    header_provider: (
        Callable[
            [ReadonlyContext],
            dict[str, str] | Awaitable[dict[str, str]],
        ]
        | None
    ) = None,
    ...
):
```

Docstring: "`header_provider`: A callable that takes a ReadonlyContext and returns a dictionary of headers to be used for the MCP session."

Merge order (`_get_headers`): provider headers first, then "Add auth headers from exchanged credential if available" via `headers.update(auth_headers)` — so an exchanged credential wins over the provider. The provider is only consulted `if self._header_provider and readonly_context`. An awaitable return is awaited (`if inspect.isawaitable(provider_headers)`).

Session pooling (`mcp_session_manager.py`): `_merge_headers` combines base connection headers with the per-call headers, then `_generate_session_key` returns `f'session_{md5(json.dumps(merged_headers, sort_keys=True))}'`. Consequence: **a distinct token string is a distinct pooled session.**

`tool_list_cache_ttl_seconds` entries are "keyed the way MCP sessions are pooled, so each `header_provider` identity gets its own", with a source comment on the cap: "Hard ceiling on cached tool lists, so a `header_provider` minting a fresh value per request cannot grow the cache without bound while entries are still unexpired." (`_MAX_TOOL_LIST_CACHE_ENTRIES = 64`.)

`StreamableHTTPConnectionParams` full field list, quoted from the model:

```python
url: str
headers: dict[str, Any] | None = None
timeout: float = 5.0
sse_read_timeout: float = 60 * 5.0
terminate_on_close: bool = True
httpx_client_factory: CheckableMcpHttpClientFactory = create_mcp_http_client
```

ADC auto-injection: `_RefreshableAsyncCredentials.before_request` attaches `headers['Authorization'] = f'Bearer {self._creds.token}'` and refreshes when `self._creds.expired or not self._creds.token`, but only for Google hosts — `_is_google_api_host` returns true when `host == 'googleapis.com' or host.endswith('.googleapis.com')` — and it bails out early if "Authorization header already present, not overwriting". It is reached only through `_get_mtls_transport()`, which returns `None` unless `google.auth.aio` is importable, `GOOGLE_API_USE_CLIENT_CERTIFICATE` is not `false`, and `auth_session.is_mtls` is true; it requests `scopes = ['https://www.googleapis.com/auth/cloud-platform']`.

**S14 — OKF reference agent** — `GoogleCloudPlatform/open-knowledge-format@main`, `src/reference_agent/`, read 2026-08-31

What it is: an **authoring** agent, not a consumer. `agent.py` builds two ADK agents — `okf_bq_reference_agent` (BigQuery metadata → concept docs) and `okf_web_ingestion_agent` (web pages → concept docs) — over five function tools: `list_concepts`, `read_concept_raw`, `sample_rows`, `read_existing_doc`, `write_concept_doc`. It writes bundles; it does not answer business questions from them. `DEFAULT_MODEL = "gemini-flash-latest"`.

`bundle/document.py`, quoted: `# OKF v0.2 §11: `type` is the only always-required frontmatter key.` / `REQUIRED_FRONTMATTER_KEYS = ("type",)`. It also ships `trust_tier()` (absent ⇒ `unverified`; non-`human:` ⇒ `machine-confirmed`; any `human:` ⇒ `human-reviewed`) and `is_stale()`, which **ignores a date-only `stale_after`**: "a date-only `2026-12-31` names a different instant in every timezone, so it is ignored rather than guessed at". Its YAML loader deliberately strips the timestamp resolver so a parse/serialize round-trip does not rewrite the author's frontmatter.

`prompts/reference_instruction.md`, quoted:
> Frontmatter: "Only `type` is strictly required; the rest are strongly recommended." · `description`: "**one sentence** explaining what this concept is. This is used verbatim in auto-generated `index.md` files, so keep it tight and informative." · `status`: "`draft` | `stable` | `deprecated`. Defaults to `stable` when omitted, so you only need to set it for a draft or deprecated concept." · Actor convention: "`<producer>/<version>` for tools, `human:<id>` for people, and `process:<id>` for automated processes."
>
> Body sections, in order: "A short prose description (1–3 paragraphs)… For tables, describe the grain (one row per X)", then "`# Schema` — a flattened, readable summary of fields", then "`# Common query patterns` — 1 to 3 short SQL snippets". And: "Do **not** add a `# Citations` section; provenance now lives in the `sources` frontmatter".
>
> **Cross-linking — contradicts SPEC.md:** "link to it using a path **relative to the current document's directory**, so the link resolves correctly when the bundle is browsed as plain files (e.g. on GitHub)." Rules: "Use file-relative paths only. **Never start a link with `/`** (that breaks GitHub rendering)" · "Only link to ids returned by `list_concepts()`. Do not invent link targets." · "Do not link from headers, fenced code blocks, or schema field-name listings."

`tools/bundle_tools.py` enforces a frontmatter key order (`type, resource, title, description, tags, status, generated, verified, stale_after, sources, usage_window`), auto-fills `generated` when unset, and refuses writes that shrink an existing doc's `# Schema` field set or `sources` list — "the web pass must augment, not replace."

`bundle/paths.py`: a concept id is slash-separated path segments matching `[A-Za-z0-9_][A-Za-z0-9_.\-]*`, mapped to `<bundle_root>/<dirs...>/<name>.md`.

**S16 — The reference agent's runnable surface** — same repo, read 2026-08-31

`pyproject.toml`: package `reference-agent` v0.1.0, `requires-python = ">=3.11"`, dependencies `google-adk>=2.0`, `google-cloud-bigquery>=3.20`, `pyyaml>=6.0`, `pydantic>=2.0`, `markdownify>=0.11`. Console script: `reference-agent = "reference_agent.cli:main"`. Not published to PyPI — install from the repo.

`cli.py` — two subcommands. `enrich` flags: `--source` (choices are `("bq",)`, the only source implemented), `--dataset` (`'project.dataset'`, required for `bq`), `--billing-project`, `--out` (bundle root, required), `--concept` (repeatable, "Enrich only this concept id (e.g. 'tables/events_')"), `--model` (default `gemini-flash-latest`), `--web-seed`, `--web-seed-file`, `--web-max-pages` (default 100), `--web-allowed-host`, `--web-allowed-path-prefix`, `--web-denied-path-substring`, `--web-max-depth` (default 2, "Seeds are depth 0"), `--no-web`, `-v/--verbose`. `visualize` flags: `--bundle` (required), `--out` (default `<bundle>/viz.html`), `--name`.

Allowed web hosts default to the seed hostnames: `allowed_hosts = {urlparse(s).netloc for s in seeds …}`, extended only by explicit `--web-allowed-host`. On success it prints `Enriched {n} concept(s) into {out}; web pass skipped` (or "used N seed(s)").

`runner.py`: `enrich_all(only=...)` runs the per-concept pass, then the optional web pass, then `Regenerating index.md files in %s` → `regenerate_indexes(self.bundle_root, model=self.model)`. Index files are therefore machine-generated, not hand-maintained.

`sources/bigquery.py`: `list_concepts()` appends one `ConceptRef(type="BigQuery Dataset")` for the dataset, then one `ConceptRef(type="BigQuery Table")` per table, collapsing date-sharded tables into a family concept keyed `("tables", prefix)`. `sample_rows()` refuses anything that is not a table. **No `Metric`, `Reference`, or `Policy` concept is ever emitted from a BigQuery source.**

**S15 — Real published bundle documents** — same repo, read 2026-08-31

`bundles/acme_retail/index.md`, verbatim and complete — note it is a plain link list, no frontmatter:

```markdown
# Subdirectories

* [tables](tables/index.md) - BigQuery tables the bundle grounds against.
* [metrics](metrics/index.md) - Business definitions of Acme Retail's headline numbers.
* [computations](computations/index.md) - Sanctioned SQL as Attested Computations for each metric.
* [policies](policies/index.md) - Source-of-truth Finance policy documents.
* [skills](skills/index.md) - Executor instructions for running Attested Computations.
* [attesters](attesters/index.md) - Deterministic verification code for computation receipts.
```

`bundles/acme_retail/tables/orders.md` — frontmatter as published, including `usage_window` which the spec lists as a sibling framing all `sources` counts:

```yaml
type: BigQuery Table
title: Customer Orders
description: One row per completed customer order across web, mobile, and marketplace channels. The grain is the order, not the line item; per-line product detail lives in `order_lines`.
resource: https://console.cloud.google.com/bigquery?p=acme&d=sales&t=orders
tags: [sales, orders, revenue]
generated: { by: reference_agent/gemini-2.5-pro, at: 2026-06-30T14:00:00Z }
verified:
  - { by: human:kliu@acme, at: 2026-07-01T16:00:00Z }
status: stable
stale_after: 2026-12-31T00:00:00Z
sources:
  - id: warehouse-schema
    resource: https://wiki.acme.internal/data/warehouse/schemas/sales
    title: Acme Retail warehouse schema — sales dataset
    author: team:data-platform
    usage_count: 1240
    last_modified: 2026-06-15T00:00:00Z
  - id: revenue-policy
    resource: policies/revenue-recognition.md
    title: Revenue Recognition Policy (FY2026)
    author: human:jsmith@acme
    last_modified: 2026-06-15T00:00:00Z
usage_window: { from: 2026-04-01T00:00:00Z, to: 2026-06-30T00:00:00Z }
```

Its body opens directly with `# Schema` — **no H1 repeating the title** — as a markdown table whose cells carry footnote markers, e.g.:
> \| `order_status` \| STRING \| One of `pending`, `paid`, `shipped`, `delivered`, `cancelled`, `refunded`. Revenue is recognized only when `order_status = 'delivered'` and the 30-day return window has closed. [^revenue-policy] \|

It then adds a `# Notes for consumers` section — evidence that the reference agent's three prescribed sections are a floor, not a fixed schema — and ends with footnote definitions whose labels are the `sources[].id` values. `bundles/ga4/index.md` shows the reference agent's own output vocabulary: `datasets/`, `references/`, `tables/`.

`bundles/acme_retail/metrics/revenue.md` body headings: `# Definition`, `# Reporting cuts`, `# Trust and freshness`, and an in-body relative link `[`computations/revenue-ytd.md`](../computations/revenue-ytd.md)`.

`bundles/acme_retail/skills/run-on-bq.md` — **OKF's own answer to "is this an agent skill?"**:
```yaml
type: Skill
title: Run an Attested Computation on BigQuery
description: "Executor skill for `Attested Computation` concepts with `runtime: bigquery`. Binds declared parameters, submits the job, and returns a receipt the attester will verify."
tags: [skill, executor, bigquery]
generated: { by: human:kliu@acme, at: 2026-06-30T14:00:00Z }
status: stable
```
Body sections: `# Skill: run on BigQuery`, `## When to use`, `## Preconditions`, `## Steps` (numbered, imperative — "Do NOT string-interpolate", "Never modify the computation"), `## Post-conditions`. Structurally indistinguishable from a Claude/Gemini agent skill.

**S9 — Gemini model IDs** — ai.google.dev, page last updated 2026-08-27, retrieved 2026-08-31
> `gemini-3.7-flash` is tagged "New Stable" and described as "Our latest and most capable Flash model, built for complex coding, agentic workflows, and reliable multi-step execution."
>
> `gemini-2.5-flash` remains listed as current ("best price-performance model for low-latency, high-volume tasks that require reasoning") and is *not* in the "Previous models" section.
>
> `gemini-2.0-flash` and `gemini-2.0-flash-lite` are flagged as shut down.

## Terminology

| Use this | Not this | Note |
|---|---|---|
| Open Knowledge Format | OpenKnowledge, OK-Format | Official naming |
| OKF bundle | OKF package / OKF DB | Unit of distribution is a bundle directory |
| Agent Development Kit (ADK) | Google ADK (when unqualified) | Use full name or ADK |
| BigQuery | Big Query, Bigquery | Standard Google Cloud casing |
| Jabodetabek | Jabotabek, JABODETABEK | The Jakarta metropolitan area — Jakarta, Bogor, Depok, Tangerang, Bekasi. **Gloss it on first use**; the reader is global |
| QRIS | Qris, Quick Response IS, "Indonesian QR code" | Quick Response Code Indonesian Standard — the national QR payment standard, a public scheme, not a company. **Gloss it on first use** |
| a payment gateway / the gateway | the vendor's name, any commercial gateway brand | Publishing constraint — see the top of this document |
| Rp / IDR | rupiah spelled out inconsistently | Keep amounts in IDR; it signals the scenario without needing translation |
| GMV | Omzet kotor (when ambiguous) | Gross Merchandise Value: total value of merchandise sold over a period |
| concept document | concept card, knowledge card | The spec's word for the unit of knowledge [verified: S4, 2026-08-31] |
| Gemini Enterprise Agent Platform (GEAP) | Vertex AI, Vertex | Current product name for the enterprise model/agent surface. **Exception: the literal env var `GOOGLE_GENAI_USE_VERTEXAI` keeps the old spelling — never "correct" it.** Quoted source extracts stay verbatim too [decided: notes.md 2026-08-31] |
| Google project vs Google Cloud service | "OKF/ADK on Google Cloud" | ADK and OKF are open-source projects published by Google; the Gemini API is `ai.google.dev`. "Made by Google" and "runs on Google Cloud" are different claims — do not blur them [verified: S1, S2, 2026-08-31] |
| context / knowledge | used interchangeably | Load-bearing distinction in beat 2b: *context* is raw material the model reasons over; *knowledge* is a conclusion already reached. OKF holds the second [decided: notes.md 2026-08-31] |
| re-derivation cost | "context bloat", "token waste" | The cost is paying for the same reasoning every session, not prompt size. Do not collapse the two — they have different fixes |
| `type: Skill` | OKF skill format, skill file | A concept type inside OKF, capitalized as published [verified: S15, 2026-08-31] |
| reference agent | OKF agent, okf-agent | Google's authoring agent in `src/reference_agent`. Always say *authoring* — it does not consume bundles [verified: S14, 2026-08-31] |
| `references/` | `geography/`, `glossary/` | Published bundle vocabulary for non-schema domain knowledge [verified: S5, S15, 2026-08-31] |
| `settlement` | `SUCCESS`, `SETTLED`, `Success` | Exact lowercase `transaction_status` value as real gateways spell it; attribute to no vendor [verified: S7, 2026-08-31] |
| Attested Computation | attested query | An OKF `type` value — capitalized as the spec writes it [verified: S4, 2026-08-31] |
| BigQuery MCP server | BigQuery MCP, BQ MCP toolset | Google's name for the managed remote server [verified: S10, 2026-08-31] |
| `execute_sql_readonly` | `execute_sql` (for this agent), read_only_sql | Exact tool name; the read-only one is the one we use [verified: S11, 2026-08-31] |
| `projectId` | `project_id`, `project` | Exact MCP argument name — camelCase [verified: S11, 2026-08-31] |
| `McpToolset` / `StreamableHTTPConnectionParams` | MCPToolset, StreamableHttpConnectionParams | Exact ADK Python class names and casing [verified: S12, 2026-08-31] |
| `header_provider` | headerProvider, header provider callback | Exact Python kwarg — snake_case. `headerProvider` is the Kotlin spelling [verified: S13, 2026-08-31] |
| `BigQueryToolset` | BigQuery tool, BQ toolset | Exact ADK class name — mentioned only as the rejected alternative [verified: S6, 2026-08-31] |
| `instruction` | `system_instruction`, system prompt | The ADK Python `Agent` parameter name [verified: S8, 2026-08-31] |
| OKF v0.2 | OKF v0.1, OKF 0.2.0 | Current published spec version [verified: S4, 2026-08-31] |

## Technical substrate

- **Execution layer:** Google's managed BigQuery MCP server, `https://bigquery.googleapis.com/mcp`. Nothing to deploy, host, or containerise — it "is enabled when you enable the BigQuery API" [verified: S10, 2026-08-31].
- **Stack / versions:** Python 3.11+, `google-adk` with MCP support, `google-auth`. **No `google-cloud-bigquery` dependency** — the agent never speaks the BigQuery API directly, only MCP [verified: S10, S12, 2026-08-31]. `header_provider` was read from `adk-python@main`; the minimum release that contains it is still unconfirmed and must be pinned before publishing [verified: S13, 2026-08-31].
- **APIs & model IDs:** `gemini-3.7-flash` via the Gemini API or Gemini Enterprise Agent Platform [verified: S9, 2026-08-31; product name decided: notes.md 2026-08-31]. Do **not** copy the ADK docs example's `gemini-2.0-flash` — it is shut down [verified: S9, 2026-08-31]. `gemini-2.5-flash` is a valid cheaper fallback [verified: S9, 2026-08-31].
- **Env requirements:** GCP project with the BigQuery API enabled; ADC via `gcloud auth application-default login`; IAM roles `roles/mcp.toolUser`, `roles/bigquery.jobUser`, `roles/bigquery.dataViewer`; OAuth scope `https://www.googleapis.com/auth/bigquery`. For Gemini Enterprise Agent Platform set `GOOGLE_CLOUD_PROJECT`, `GOOGLE_CLOUD_LOCATION`, `GOOGLE_GENAI_USE_VERTEXAI=True` — the env var still carries the old name and must **not** be renamed — otherwise set `GEMINI_API_KEY` [verified: S8, S10, 2026-08-31].
- **Safety posture:** two layers. Client-side, `tool_filter` omits `execute_sql` so the agent is only offered the five read-only tools. Server-side, an IAM deny policy on `execute_sql` is the boundary that actually holds — `tool_filter` is only agent configuration and does not constrain the credential [verified: S10, S12, 2026-08-31].
- **Hard limits to design around:** three-minute query cap, 3,000-row result cap, no Google Drive external tables, no GQL, no DML/DDL through the read-only tool [verified: S10, 2026-08-31]. The 3,000-row cap is a *feature* for this use case — an analytics agent should return aggregates, not row dumps.
- **Observability:** jobs run through the server carry the tag `goog-mcp-server:true`, so agent-driven queries are separable from human ones in `INFORMATION_SCHEMA.JOBS` [verified: S10, 2026-08-31].
- **Cost of one full run:** the MCP server "doesn't have its own quotas" and adds no charge of its own; BigQuery sandbox free tier plus Gemini API free tier is expected to cover the walkthrough [verified: S10, 2026-08-31; cost estimate: assumption].
- **Presentation format:** Clean, readable Python snippets + Markdown OKF files (no heavy raw data seed scripts) [decided: notes.md 2026-08-31]

### Example Abstracted Schema & OKF Bundle Architecture

> The schema below is illustrative but its **payment status vocabulary is real** — it mirrors a production payment gateway's public API, which this document may cite and the published article may not name [verified: S7, 2026-08-31]. That fidelity is what makes the hook land; do not "simplify" `transaction_status` back into a `SUCCESS` string. All merchant, customer and company names in the seeded data are synthetic.

#### 1. Abstracted 2-Table Marketplace Schema in BigQuery

Two tables, not three. The three-table version added a join that taught nothing; `destination_city` sits on `orders` [decided: notes.md 2026-08-31].

```sql
-- Table: orders (core transaction records)
-- order_id STRING, order_ts TIMESTAMP, customer_id STRING,
-- gross_amount NUMERIC,             -- IDR
-- order_status STRING,              -- 'created' | 'completed' | 'cancelled' | 'returned'
-- destination_city STRING           -- raw city name, e.g. 'Kota Bekasi', 'Kab. Bogor'
-- NOTE: there is deliberately NO `region` column. "Jabodetabek" exists only in
-- the OKF concept, which is exactly the kind of knowledge a schema cannot hold.

-- Table: payments (payment gateway settlement log; vocabulary mirrors a real gateway, unnamed)
-- payment_id STRING, order_id STRING,
-- payment_method STRING,            -- 'qris' | 'gopay' | 'bank_transfer' | 'cod'
-- status_code INT64,                -- 200 = request OK (settlement OR cancel!), 201 = pending, 202 = denied
-- transaction_status STRING,        -- 'settlement' | 'pending' | 'deny' | 'cancel' | 'expire' | 'refund' | ...
-- settlement_ts TIMESTAMP
```

#### 1b. Act 1 — generating the bundle

The reference agent is a console script, `reference-agent`, with two subcommands [verified: S16, 2026-08-31]:

```bash
# Install (not on PyPI — install the repo). Needs Python >=3.11, google-adk>=2.0.
pip install git+https://github.com/GoogleCloudPlatform/open-knowledge-format

# Act 1: BigQuery dataset -> OKF bundle. --no-web keeps the first run deterministic.
reference-agent enrich \
  --source bq \
  --dataset "$PROJECT_ID.marketplace" \
  --out bundles/generated \
  --no-web

# Optional: a self-contained HTML graph of the bundle.
reference-agent visualize --bundle bundles/generated
```

What comes out: one `datasets/<name>.md` (`type: BigQuery Dataset`), one `tables/<name>.md` per table (`type: BigQuery Table`), and regenerated `index.md` files throughout — the runner calls `regenerate_indexes()` after every enrich pass [verified: S16, 2026-08-31]. Sharded tables are collapsed into a single family concept rather than one document per shard.

Flags worth naming in the post: `--concept tables/payments` re-enriches exactly one document (cheap iteration); `--model` defaults to `gemini-flash-latest`; the web pass (`--web-seed`, `--web-max-depth`, `--web-allowed-host`) can fold your existing documentation into the same table docs, and is deliberately skipped on the first run so the reader sees the schema-only baseline [verified: S16, 2026-08-31].

**What it does not produce: `metrics/` or `references/`.** The BigQuery source emits dataset and table concepts only. That boundary is not a limitation to apologise for — it is Act 2's reason to exist.

#### 2. OKF Bundle File Structure

Four concept documents in three directories, each teaching a different lesson [decided: notes.md 2026-08-31]. Directory names and layout follow the published `acme_retail` and `ga4` bundles — `tables/`, `metrics/`, `references/`, `datasets/`, `policies/` are the vocabulary those bundles actually use [verified: S5, S15, 2026-08-31]. `index.md` and `log.md` are reserved names [verified: S4, 2026-08-31].

```text
bundles/marketplace/            # the finished bundle; bundles/generated/ is the Act 1 half alone
├── index.md                    # GENERATED — regenerated after every enrich pass
├── datasets/                   # GENERATED (Act 1)
│   ├── index.md
│   └── marketplace.md          # type: BigQuery Dataset
├── tables/                     # GENERATED (Act 1) — what the schema says
│   ├── index.md
│   ├── orders.md               # type: BigQuery Table
│   └── payments.md             # type: BigQuery Table — column enums documented inline
├── metrics/                    # HAND-WRITTEN (Act 2) — what the business decided
│   ├── index.md
│   └── gmv.md                  # type: Metric, with verified + stale_after
└── references/                 # HAND-WRITTEN (Act 2) — not in the warehouse at all
    ├── index.md
    └── jabodetabek.md          # type: Reference — city list; no such column exists
```

The split *is* the teaching device, and the annotations should survive into the published tree: `datasets/` and `tables/` are derivable from `INFORMATION_SCHEMA` and cost one command; `metrics/` is a decision a human made; `references/` could never be derived from the warehouse at all. A reader who sees only the generated half concludes OKF is a schema dump — which is precisely the misreading Act 2 exists to correct [decided: notes.md 2026-08-31].

Real `index.md` files are plain heading-plus-link lists with **no frontmatter**, and each entry repeats the linked concept's `description` verbatim [verified: S5, S14, 2026-08-31]:

```markdown
# Subdirectories

* [tables](tables/index.md) - BigQuery tables the agent queries.
* [metrics](metrics/index.md) - Business definitions of our headline numbers.
* [references](references/index.md) - Domain knowledge with no column in the warehouse.
```

#### 3. Sample OKF Concept Document (`metrics/gmv.md`)

Modelled line-for-line on the published `acme_retail/metrics/revenue.md` [verified: S15, 2026-08-31]; field semantics follow the v0.2 spec [verified: S4, 2026-08-31]. Note what is **absent**: no `# Title` heading duplicating the frontmatter `title`, no `# Citations` section, no explicit `status: stable` (it is the default).

```markdown
---
type: Metric
title: Gross Merchandise Value (GMV)
description: Total settled transaction value for a period, excluding cancellations and refunds.
tags: [metrics, finance, headline-metric]
generated: { by: human:analytics-lead@marketplace.id, at: 2026-08-01T09:00:00+07:00 }
verified:
  - { by: human:analytics-lead@marketplace.id, at: 2026-08-05T10:00:00+07:00 }
stale_after: 2027-01-31T00:00:00+07:00
sources:
  - id: rev-policy
    resource: policies/revenue-recognition.md
    title: Revenue Recognition Policy FY2026
    author: human:finance@marketplace.id
    last_modified: 2026-07-20T00:00:00+07:00
---

# Definition

GMV for a period is `SUM(orders.gross_amount)` over orders that (a) reached
`order_status = 'completed'`, (b) have a payment at
`transaction_status = 'settlement'`, and (c) were not later reversed
(`transaction_status NOT IN ('refund', 'partial_refund', 'chargeback',
'partial_chargeback')`). The period is cut on `payments.settlement_ts`, not
`orders.order_ts`: an order placed on the last day of the month that settles the
next day belongs to the next month. [^rev-policy]

GMV is **not** net revenue, and **not** "turnover" as the sales team uses the word —
neither of those excludes refunds. Do not filter on `payments.status_code = 200`;
see [payments](../tables/payments.md) for why that value also covers cancellations.

# Trust and freshness

- **Verified:** analytics lead sign-off on 2026-08-05.
- **Stale after 2027-01-31:** Finance reissues the revenue-recognition policy each
  January. Re-verify this definition before serving GMV for later periods.

[^rev-policy]: Revenue Recognition Policy FY2026
```

**Link form — a live conflict between the spec and Google's own tooling.** SPEC.md recommends bundle-root-absolute links (`/tables/payments.md`) because they "survive moves". The reference agent's authoring instruction forbids them outright: "Never start a link with `/` (that breaks GitHub rendering)", and every published bundle uses file-relative links such as `../computations/revenue-ytd.md`. **This context follows the implementation, not the spec** — the bundle is meant to be browsed on GitHub, which is most of its value to a reader [verified: S14, S15, 2026-08-31]. One asymmetry to keep straight: body links are *file-relative*, while `sources[].resource` for an in-bundle document is *bundle-root-relative with no leading slash* (`policies/revenue-recognition.md`) [verified: S15, 2026-08-31].

#### 3b. Table concept convention

Table documents follow a fixed body shape: prose grain description, then `# Schema` as a markdown table, then `# Common query patterns` with one to three `sql` fences [verified: S14, 2026-08-31]. Per-cell claims carry footnotes keyed to `sources[].id`. `description` must be **one sentence**, because auto-generated `index.md` files reuse it verbatim [verified: S14, 2026-08-31].

#### 3c. "Isn't this just an agent skill?" — the comparison to make explicitly

The reader's most likely prior is agent skills (Claude Skills, Gemini/ADK skills): Markdown plus frontmatter in a repo, loaded when relevant. That prior is close enough to be useful and wrong enough to mislead, so the post should name it rather than let the reader carry it silently [decided: notes.md 2026-08-31].

The precise answer: **a skill is one concept `type` inside OKF, not a synonym for it.** `bundles/acme_retail/skills/run-on-bq.md` carries `type: Skill` and reads exactly like an agent skill — *When to use*, *Preconditions*, *Steps*, *Post-conditions* [verified: S15, 2026-08-31].

| | Agent skill | OKF bundle |
|---|---|---|
| Answers | "how do I perform X" — procedural | "what does X mean here" — declarative, with skills as one type among many |
| Unit | one skill, self-contained | a linked graph of concepts with generated `index.md` navigation |
| Provenance | no standard fields | `sources` with credibility signals, `verified` events, `stale_after` [verified: S4] |
| Owner | whoever writes agent code | the analyst or finance owner, via a PR on Markdown |
| Failure it prevents | agent does the task wrong | agent computes the wrong number, confidently |

The one-line version for the post: *skills tell an agent how to act; OKF tells it what the words mean — and OKF says who last checked, and when that answer expires.*

#### 4. ADK Python Agent Implementation Snippet

> **Unverified reference.** This has not been executed. Every identifier below is checked against a primary source and tagged, but the assembled program is a sketch of the shape — downstream builds and runs it, and that is where it gets proven [decided: notes.md 2026-08-31].

Verified against the BigQuery MCP server docs [S10], its live `tools/list` response [S11], ADK's remote-MCP wiring [S12] and ADK Python tool authoring rules [S8], all 2026-08-31. Execution is a managed Google endpoint; the only custom code is the OKF reader.

```python
import os
import pathlib

import google.auth
import google.auth.transport.requests
from google.adk.agents import Agent
from google.adk.agents.readonly_context import ReadonlyContext
from google.adk.tools.mcp_tool import McpToolset
from google.adk.tools.mcp_tool.mcp_session_manager import StreamableHTTPConnectionParams

# Which bundle to ground against. The repo ships two: `bundles/generated` (Act 1
# output alone) and `bundles/marketplace` (plus the hand-written concepts). Same
# agent, one word different — that is the demonstration.
OKF_BUNDLE = pathlib.Path(os.environ.get("OKF_BUNDLE", "bundles/marketplace")).resolve()
PROJECT_ID = os.environ["PROJECT_ID"]
BIGQUERY_SCOPE = "https://www.googleapis.com/auth/bigquery"


def read_okf_concept(path: str) -> dict:
    """Read one Open Knowledge Format concept document from the local bundle.

    Args:
        path: Bundle-root-relative path, e.g. "metrics/gmv.md". Call this with
            "index.md" first to discover which concepts exist.

    Returns:
        A dict with 'status', and on success 'content' holding the raw markdown
        including its YAML frontmatter.
    """
    doc = (OKF_BUNDLE / path.lstrip("/")).resolve()
    if not doc.is_relative_to(OKF_BUNDLE) or not doc.is_file():
        return {"status": "error", "error": f"no concept at {path}"}
    return {"status": "success", "content": doc.read_text(encoding="utf-8")}


_credentials, _ = google.auth.default(scopes=[BIGQUERY_SCOPE])


def _bigquery_auth_header(context: ReadonlyContext) -> dict[str, str]:
    """Supply the BigQuery MCP bearer token, refreshing it only once it expires.

    Returning a token that stays stable until expiry matters: ADK pools MCP
    sessions on a hash of the merged headers, so minting a brand-new string per
    call would open a new session per call.
    """
    if not _credentials.valid:
        _credentials.refresh(google.auth.transport.requests.Request())
    return {"Authorization": f"Bearer {_credentials.token}"}


# Google's managed BigQuery MCP server. Nothing to deploy — it is on as soon as
# the BigQuery API is enabled on the project.
bigquery_mcp = McpToolset(
    connection_params=StreamableHTTPConnectionParams(
        url="https://bigquery.googleapis.com/mcp",
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json, text/event-stream",
        },
        # Server cancels queries at three minutes; keep the read window wider.
        sse_read_timeout=300.0,
    ),
    header_provider=_bigquery_auth_header,
    # execute_sql is the server's only non-read-only tool. Don't offer it.
    # Belt and braces: also deny it at the IAM layer.
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
        "You answer business questions about an online marketplace.\n"
        "Before writing any SQL: call read_okf_concept('index.md'), then read every "
        "concept the question touches — the metric, the payment status, the geography.\n"
        "Use only the filters, joins and period cuts those concepts define. "
        "Never invent a status value or a metric formula.\n"
        f"Run queries with execute_sql_readonly, passing projectId='{PROJECT_ID}'.\n"
        "Always aggregate. Results are capped at 3,000 rows and queries at three "
        "minutes, so never SELECT raw transaction rows.\n"
        "If a concept's frontmatter carries a stale_after date that has passed, say so "
        "in your answer instead of presenting the number as current.\n"
        "Show the SQL you ran, and name the concepts you relied on."
    ),
    tools=[read_okf_concept, bigquery_mcp],
)
```

Things downstream must not silently "improve":

- `instruction=`, not `system_instruction=`; plain functions in `tools=[]`, not a `Tool.from_function` wrapper — neither exists in ADK Python [verified: S8, 2026-08-31].
- Every BigQuery MCP tool **requires `projectId`** [verified: S11, 2026-08-31]. If the instruction does not supply it, the model will invent one or stall. This is the single most likely first-run failure.
- `tool_filter` and `header_provider` both sit on `McpToolset`, not on the connection params [verified: S13, 2026-08-31].
- Do **not** also put `Authorization` in the connection params' static `headers`. Auth belongs in `header_provider` so it can refresh; a static header just freezes a token that will expire [verified: S13, 2026-08-31].
- The path check in `read_okf_concept` is a traversal guard, not decoration — the `path` argument is model-controlled.
- The docstring is the tool's API description sent to the model; type hints are required and default values are not allowed [verified: S8, 2026-08-31].
- **Never write `headers={'Authorization': 'Bearer $(gcloud auth print-access-token)'}` in Python.** The official ADK docs contain exactly that line; shell substitution does not happen inside a Python string [verified: S12, 2026-08-31].

**Why `header_provider` and not a static header.** ADK calls the provider when it builds a session, so the token is read at request time and `_credentials.valid` triggers a refresh only once the old one expires [verified: S13, 2026-08-31]. That makes the agent correct for a long-running service, not just a demo — no hour-long expiry cliff.

The subtlety worth one sentence in the post: ADK pools MCP sessions on an MD5 of the merged headers [verified: S13, 2026-08-31]. A provider that returns a fresh token string on every call therefore opens a fresh session on every call. Holding one credentials object and refreshing only on expiry keeps a single pooled session per token lifetime — which is why the snippet checks `.valid` instead of calling `.refresh()` unconditionally.

Inspecting the server's tool catalogue needs no credentials at all [verified: S10, 2026-08-31] — a good opening move for a reader who wants to see it is real before writing any Python:

```bash
curl -s -X POST https://bigquery.googleapis.com/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
```

## The companion repository

A co-equal deliverable, not a footnote [decided: notes.md 2026-08-31]. The blog's central claim — a generated bundle answers wrongly, a taught bundle answers correctly — is only credible if a reader can reproduce both. The repo exists to make that contrast runnable.

**It is a finished example, not an exercise** [decided: notes.md 2026-08-31]. Everything is committed and working on clone. No PR step, no `git diff` step, no TODO branch, no "now you try". A reader who never types `git` gets the full result. GitOps is argued in the blog (beat 9); it is not staged as repo homework.

**The contrast ships as two committed bundles, not as a diff:**

```text
okf-bigquery-marketplace/
├── README.md                    # four commands, in order
├── pyproject.toml               # google-adk, google-auth  (no google-cloud-bigquery)
├── .env.example                 # PROJECT_ID, GEMINI_API_KEY / GEAP vars
├── seed/
│   ├── schema.sql               # CREATE TABLE orders, payments
│   └── seed_data.sql            # ~2k synthetic rows; real-shaped statuses, no brands.
│                                #   MUST include 200-but-cancelled, settled-then-refunded,
│                                #   and cross-month settlements, or beat 8 has no contrast.
├── bundles/
│   ├── generated/               # Act 1 output, committed unmodified. datasets/ + tables/ only.
│   └── marketplace/             # the finished bundle: the same generated docs,
│                                #   plus hand-written metrics/ and references/
├── agent/
│   ├── __init__.py
│   └── agent.py                 # root_agent; bundle path from $OKF_BUNDLE
└── eval/
    └── questions.md             # benchmark questions with expected SQL shape
```

**The four commands the README reduces to:**

```bash
bq mk --dataset $PROJECT_ID:marketplace && bq query --use_legacy_sql=false < seed/schema.sql
reference-agent enrich --source bq --dataset $PROJECT_ID.marketplace --out bundles/generated --no-web  # optional: reproduce Act 1
OKF_BUNDLE=bundles/generated   adk run agent    # confident, wrong
OKF_BUNDLE=bundles/marketplace adk run agent    # correct, and cites the concepts
```

The last two lines differ by one word. That is a sharper demonstration than a diff, and it survives a reader who skims.

**Design rules for the repo:**

- **Two bundles, both finished.** `bundles/generated/` is committed exactly as `reference-agent enrich` emitted it — never hand-touched, so the failure is honest rather than a strawman. `bundles/marketplace/` is that same content plus the two hand-written concept documents.
- **Act 1 stays reproducible without being required.** Running `enrich` should regenerate `bundles/generated/` to substantially the same content, so a reader can verify the claim rather than trust a screenshot — but the repo works fully without ever running it. LLM output is not byte-stable; say so in the README instead of promising a clean `git status`.
- **The bundle explains its own provenance — no diff needed.** Generated documents carry `generated: {by: reference_agent/…}` and **no `verified` event**, so their trust tier is `unverified`; the hand-written ones carry `verified: {by: human:…}` and `stale_after` [verified: S14, 2026-08-31]. A reader can tell machine-authored from human-decided by reading frontmatter in either bundle. That is OKF doing the job a `git diff` was standing in for.
- **Seed data is required.** Data-seeding is deliberately kept out of the blog prose as clutter, but the repo cannot skip it — "point the reference agent at your dataset" presumes a dataset exists [decided: notes.md 2026-08-31].
- **Assume a hostile laptop.** BigQuery sandbox, no billing, corporate proxy, no Docker. Seed data small enough to load in under a minute.
- Licence and attribution note: OKF conventions and any quoted text belong to Google under Apache-2.0.

## Worked example

**User Query:**
> *"What was total GMV for successful QRIS payments in Jabodetabek in July 2026?"*

Note how little of that a model can resolve from the schema: **GMV** is a definition someone chose, **QRIS** is Indonesia's national QR payment standard, **Jabodetabek** is the Jakarta metropolitan area and has no column, and **"successful"** is the trap. A reader outside Indonesia is in the same position — which is the point.

**What a naive agent produces (the counter-example the post opens with):**

```sql
-- WRONG on four counts
SELECT SUM(total_amount) FROM orders o JOIN payments p USING (order_id)
WHERE p.status = 'SUCCESS'            -- no such value exists in the data
  AND o.region = 'Jabodetabek'        -- no such column exists
  AND o.order_date BETWEEN '2026-07-01' AND '2026-07-31';  -- wrong date basis
```

It is syntactically perfect and returns nothing, or worse, returns a plausible number.

**Agent Execution Trace (grounded):**

0. **Discovery (optional, once):** `list_table_ids(projectId=…, datasetId="marketplace")` and `get_table_info(...)` confirm the tables exist and their column types — structure only, no semantics [verified: S11, 2026-08-31].
1. **OKF Lookup:** Agent calls `read_okf_concept("index.md")`, then `metrics/gmv.md`, `tables/payments.md`, `references/jabodetabek.md`.
2. **Knowledge Retrieved:** GMV requires `orders.order_status = 'completed'` **and** `payments.transaction_status = 'settlement'`, excluding reversals; `status_code = 200` is explicitly rejected as a success test because it also covers `cancel` [verified: S7, 2026-08-31]; the period is cut on `settlement_ts`, not `order_ts`; "Jabodetabek" has no column and must be expanded to a city-name list.
3. **Generated BigQuery SQL** — passed to `execute_sql_readonly(projectId="my-project", query=…)` [verified: S11, 2026-08-31]:
   ```sql
   SELECT
     SUM(o.gross_amount)          AS total_gmv_idr,
     COUNT(DISTINCT o.order_id)   AS settled_orders
   FROM `my_project.marketplace.orders` o
   JOIN `my_project.marketplace.payments` p ON o.order_id = p.order_id
   WHERE p.payment_method = 'qris'
     AND p.transaction_status = 'settlement'
     AND o.order_status = 'completed'
     AND o.destination_city IN (
       'Kota Jakarta Pusat', 'Kota Jakarta Utara', 'Kota Jakarta Barat',
       'Kota Jakarta Selatan', 'Kota Jakarta Timur',
       'Kota Bogor', 'Kab. Bogor', 'Kota Depok',
       'Kota Tangerang', 'Kota Tangerang Selatan', 'Kab. Tangerang',
       'Kota Bekasi', 'Kab. Bekasi'
     )
     AND p.settlement_ts >= TIMESTAMP('2026-07-01 00:00:00+07')
     AND p.settlement_ts <  TIMESTAMP('2026-08-01 00:00:00+07');
   ```
   Note the half-open interval and the explicit `+07` offset — `BETWEEN '2026-07-01' AND '2026-07-31'` silently drops the last day and reads timestamps as UTC.
4. **Agent Response:**
   > *"GMV for settled QRIS payments in Jabodetabek during July 2026 was **Rp 1,428,500,000** across **12,450 orders**. This excludes cancelled and refunded orders, and is cut on settlement date rather than order date, per `metrics/gmv.md`."*

Illustrative figures — downstream must not present the rupiah number as measured data [assumption].

## Objections & answers

| A skeptic asks | Honest answer |
|---|---|
| Why not just dump all definitions into the LLM system prompt? | Realistic enterprise metrics expand rapidly; hardcoding them into prompt strings wastes thousands of input tokens per turn, increases inference cost/latency, and prevents non-engineers from updating metrics in Git. |
| Models are cheap and getting cheaper. Why not hand the agent the full schema plus the docs and let it figure the semantics out each time? | Because you pay for that reasoning on every session, and you get a different answer each time. Three costs, in increasing order of seriousness: **tokens** — a research phase re-reads the same material every conversation; **latency** — the first useful answer arrives several tool calls late, every time; and **non-determinism** — nothing makes two sessions converge on the same definition of GMV, so the same question can produce two defensible-looking numbers on two days. Reasoning is a cost you pay per session; a written conclusion is a cost you pay once. OKF is where the conclusion goes [decided: notes.md 2026-08-31]. |
| Isn't a written conclusion just a cache that goes stale? | Yes, exactly — and OKF treats it as one, which is the point. `stale_after` is a cache expiry, `verified` is who validated the entry, and `sources` is what to re-derive from when it expires [verified: S4, 2026-08-31]. A re-deriving agent has no expiry policy because it has no cache; it simply pays full price forever and hopes today's reasoning matches yesterday's. |
| Why not use embeddings / Vector RAG over Confluence docs? | Vector similarity search retrieves chunked paragraphs that destroy relational precision, table join integrity, and explicit calculation logic needed for SQL generation. OKF provides deterministic, linked concept cards. |
| Does OKF require running a separate vector database or search server? | No. OKF is plain Markdown files in a Git repository. It has \$0 hosting cost and runs entirely on the agent's filesystem or cloud storage. |
| Is OKF tied exclusively to Google Cloud or BigQuery? | No. OKF is vendor-neutral open standard. While we showcase it with BigQuery & ADK, OKF bundles work with PostgreSQL, Snowflake, ClickHouse, or any agent framework. |
| The BigQuery MCP server already gives the model `get_table_info` and `list_table_ids` — why do I need OKF at all? | Those answer *"what data exists"*: names, types, descriptions. They cannot tell you that GMV is cut on `settlement_ts` rather than `order_ts`, that `status_code = 200` includes cancellations, or that Finance signed off on the rule in July and it expires in January. Schema introspection returns structure; OKF returns the decisions humans made about that structure. Use both [verified: S10, S11, 2026-08-31]. |
| Why the managed MCP server instead of ADK's own `BigQueryToolset`? | Both work. The MCP server is a Google-operated HTTPS endpoint — no client library, no credential plumbing inside the agent process, no framework lock-in: the same endpoint serves any MCP client, so the knowledge-plus-execution pattern transfers off ADK unchanged. Trade-off, stated honestly: the MCP server exposes six tools, while `BigQueryToolset` adds `forecast`, `ask_data_insights`, `search_catalog` and more; and it imposes a 3,000-row and three-minute ceiling. For a grounded analytics agent that returns aggregates, that ceiling is not a constraint [verified: S6, S10, S11, 2026-08-31]. |
| Doesn't routing every query through Google's endpoint mean my data leaves my project? | No. The server runs queries *as you*, in your project, under your IAM. It is a control-plane endpoint, not a data pipeline: authorization is OAuth 2.0 plus IAM with your own roles, and the jobs land in your own BigQuery history tagged `goog-mcp-server:true` [verified: S10, 2026-08-31]. |
| Google already publishes an `acme_retail` OKF sample that does BigQuery metrics. Isn't this the same post? | The sample shows the *bundle*. It does not show an agent — no ADK wiring, no tool loop, no query trace. This post carries the reader from a natural-language question to executed SQL, and uses `acme_retail` as the conventions to imitate rather than reinventing a layout [verified: S5, 2026-08-31]. |
| If the reference agent generates the bundle, why do I need to write anything by hand? | Because it generates only what `INFORMATION_SCHEMA` knows. From a BigQuery dataset it emits `BigQuery Dataset` and `BigQuery Table` documents and nothing else — no `Metric`, no `Reference` [verified: S16, 2026-08-31]. It cannot know that GMV is cut on `settlement_ts`, that `status_code = 200` also covers cancellations, or which cities count as Jabodetabek. Act 2 exists because that boundary is real, and the post proves it by running the same question against both bundles. |
| Doesn't the web pass close that gap — just point it at our Confluence? | Partly, and it is worth using: `--web-seed` folds documentation into the same concept documents [verified: S16, 2026-08-31]. But it inherits whatever your docs actually say. If the GMV definition lives in a spreadsheet, three Slack threads and one analyst's head, no crawler recovers it. Writing the concept *is* the act of deciding. |
| Why should I trust a Markdown file an LLM generated about my schema? | You should not, unmodified — which is what `verified` is for. A generated document has `generated: {by: reference_agent/…}` and no `verified` event, so its trust tier is literally `unverified` until a human signs off [verified: S14, 2026-08-31]. The format encodes the review step rather than assuming it. |
| Markdown files have no schema validation. What stops an analyst writing a broken concept? | Less than a database would, and the post should say so. OKF's own answer is deliberately loose: consumers "MUST tolerate unknown types gracefully" and "MUST tolerate broken links". The real gate is code review on the PR, plus `verified` and `stale_after` making an unreviewed or expired definition visible to the agent at read time [verified: S4, 2026-08-31]. |
| Won't the agent just skip reading the concepts if the model feels confident? | It can, and that is the honest limitation of instruction-based grounding. Mitigations worth a sentence: put the "read concepts first" rule in `instruction`, and for hard guarantees use a `before_tool_callback` that rejects an `execute_sql` call when no concept was read in the turn [verified: S8, 2026-08-31]. |

## Rejected directions

| Direction | Killed because | Revisit if |
|---|---|---|
| Data seeding scripts **in the blog prose** | Overwhelms readers in a 7–10 minute read; detracts from the core architectural message | Settled 2026-08-31 as a **scope split, not a rejection**: seeding is in scope for the repo and out of scope for the prose. Both stated in *Decision & scope*. Do not re-litigate as if the repo were still forbidden them [decided: notes.md 2026-08-31] |
| Multi-agent complex supervisor/router architectures | Adds unnecessary cognitive overhead for a high-level introductory blog post | Advanced multi-agent workshop |
| Generic toy dataset (Iris / Titanic / `bigquery-public-data`) | A dataset the model already knows cannot demonstrate knowledge the model lacks. The argument needs domain vocabulary that is genuinely unguessable — which is also why the scenario stays Indonesian even though the reader is global [decided: notes.md 2026-08-31] | Never for this topic |
| Naming the payment gateway the status vocabulary came from | Owner decision 2026-08-31: no vendor or brand names in the data or the prose. The citation stays upstream in S7 so the claim is auditable; the artifact says "a real payment gateway" [decided: notes.md 2026-08-31] | Never |
| Bahasa Indonesia prompts, agent instructions, or answers | Owner decision 2026-08-31: the reader is global. The scenario stays Indonesian; the language does not. A Bahasa prompt would gate the argument behind a language most readers do not have [decided: notes.md 2026-08-31] | A separately localized edition, if one is ever commissioned |
| Hand-rolled `google.cloud.bigquery.Client()` execution tool in the agent | Google runs a managed BigQuery MCP server; writing our own execution layer adds a dependency for nothing [verified: S10, 2026-08-31] | Never — unless demonstrating a non-BigQuery warehouse |
| ADK's first-party `BigQueryToolset` as the execution layer | Owner decision: use the managed MCP server instead. It is framework-neutral (any MCP client, not just ADK), needs no client library or in-process credential config, and keeps the post's "you deploy nothing" claim literally true. `BigQueryToolset` remains a legitimate alternative and is named as such in *Objections* [decided: notes.md 2026-08-31] | If the post ever needs `forecast`, `ask_data_insights` or `search_catalog`, or must exceed the 3,000-row / three-minute ceiling |
| Self-hosting an MCP server for BigQuery | Pointless when the managed one "is enabled when you enable the BigQuery API" and has no quotas of its own [verified: S10, 2026-08-31] | Air-gapped or non-GCP warehouses |
| Inventing our own OKF directory layout (`schemas/`, `okf-marketplace/`) | Google's `acme_retail` sample already sets conventions (`tables/`, `metrics/`, `policies/`). Diverging makes the post harder to reconcile with the official repo [verified: S5, 2026-08-31] | Never |
| Presenting `type: concept` as the OKF frontmatter type | Not a spec type. Real bundles use domain types like `Metric`, `BigQuery Table`, `Reference` [verified: S4, S5, 2026-08-31] | Never — it was factually wrong |
| Bundle-root-absolute links (`/tables/payments.md`) in concept bodies | SPEC.md recommends them, but the reference agent forbids them and no published bundle uses them: "Never start a link with `/` (that breaks GitHub rendering)" [verified: S14, S15, 2026-08-31] | If OKF tooling ever renders bundles outside GitHub as the primary experience |
| A three-table schema with a `shipping` join | The third table added a join and a file without teaching anything new. `destination_city` moved onto `orders`; the Jabodetabek lesson is unchanged because the point was always the *missing* region column [decided: notes.md 2026-08-31] | Never for this post |
| Invented directory names (`payments/`, `geography/`, `schemas/`) | Published bundles use `tables/`, `metrics/`, `references/`, `datasets/`, `policies/`. The QRIS status vocabulary belongs on `tables/payments.md` because it is a column on that table; Jabodetabek is a `references/` concept [verified: S5, S15, 2026-08-31] | Never |
| Re-implementing or forking the reference agent | **Superseded 2026-08-31.** We no longer avoid it — we *run* it as Act 1, unmodified, via its published CLI. What stays rejected is explaining its internals (ingestion passes, augmentation guards, the web crawler's bounding flags) [decided: notes.md 2026-08-31] | Never — using the tool is the point; dissecting it is a different post |
| Hand-writing `tables/` and `datasets/` concept documents | The generator produces them from `INFORMATION_SCHEMA` in one command. Hand-writing them would misrepresent the workflow and make OKF look like tedious documentation duty [verified: S16, 2026-08-31] | Never |
| Attested Computations, `computations/`, `attesters/`, receipts | Second full concept; blows the 7–10 min budget. Parked deliberately, and reconfirmed after reading `bundles/acme_retail/skills/run-on-bq.md` [decided: notes.md 2026-08-31] | Part 2 — still the strongest candidate |
| Covering OKF's Attested Computation type and the `attesters/` verification chain | Genuinely interesting (deterministic receipts for SQL results) but it is a second full concept and would blow the 7–10 min budget | Follow-up post — this is the strongest candidate for a part 2 |

## Assets

| Asset | State | Where |
|---|---|---|
| 3-Layer Architecture Diagram (User → ADK Agent → OKF in Git → BigQuery → Response) | needed | `assets/okf_adk_bigquery_architecture.png` |
| OKF Marketplace Bundle Directory Tree | needed — text version is inline in *Technical substrate*; no `assets/` directory exists yet | `assets/okf_tree.txt` |
| **Companion repository** — finished example, working on clone | needed — co-equal deliverable, not optional | public repo, URL TBD |
| `bundles/generated/` — untouched output of a real `reference-agent enrich` run | needed; must never be hand-edited | repo |
| `bundles/marketplace/` — same content plus `metrics/gmv.md` and `references/jabodetabek.md` | needed | repo |
| Seed SQL + ~2k synthetic rows — real-shaped status vocabulary, zero brand or personal names | needed | repo `seed/` |
| Terminal capture: agent against **generated-only** bundle (the wrong answer) | needed — beat 8 depends on it | `assets/trace_before.txt` |
| Terminal capture: agent against **taught** bundle (the right answer) | needed | `assets/trace_after.txt` |
| `viz.html` graph from `reference-agent visualize` | nice to have — cheap, and makes the bundle feel real | `assets/viz.png` |

## Per-format guidance

| Format | Angle to take | Length | Watch out for |
|---|---|---|---|
| Blog | Three acts — generate, teach, consume. The argument is the boundary between what a generator can derive and what only a human can decide. | 7–10 min read (~1,200–1,500 words) | Keep seeding and DDL out of the prose; link to the repo instead. Do not let Act 1 read as a product demo — it exists to set up Act 2's failure. |
| Repo | The proof, as a **finished example**. Clone → seed → ask, twice, against two committed bundles. No PR step, no exercises, no TODOs. | ~15 min to first answer | `bundles/generated/` must be untouched generator output — the moment it is hand-edited to look worse, the demonstration is a lie. Warn that regeneration is not byte-stable. Pin `google-adk` once the `header_provider` minimum is known. |
| Tutorial / codelab | Step-by-step repo walkthrough: `curl` the MCP `tools/list` to see the server is real, clone starter, populate OKF concepts, run ADK agent queries against a BigQuery sandbox. | 30–45 mins to complete | ADC setup plus the three IAM roles (`roles/mcp.toolUser`, `roles/bigquery.jobUser`, `roles/bigquery.dataViewer`) must be spelled out — a missing `mcp.toolUser` is the non-obvious one [verified: S10, 2026-08-31]. Also cover the token-expiry gotcha. |

## Open questions

- Publication platform: Medium / Dev.to / personal engineering blog? `[assumption: tech engineering blog / Medium]`
- Visuals: Inline Mermaid architecture diagram vs rendered PNG? `[assumption: both provided]`
- ~~Language of the post~~ **Resolved 2026-08-31:** English throughout, global reader, Indonesian scenario retained. See *Publishing constraints* [decided: notes.md 2026-08-31].
- **Does every domain term get glossed exactly once?** `QRIS`, `Jabodetabek`, `IDR`, `GMV` all need a one-clause gloss on first use and none after. Worth a dedicated editing pass — over-glossing patronises, under-glossing loses the reader at the hook.
- **Nothing in this document has been executed — by design.** Every identifier is verified against a primary source, but the snippets are unverified references, not tested artifacts. Downstream builds and runs them. This does **not** block export [decided: notes.md 2026-08-31].
- Are the OKF `verified` / `stale_after` fields honoured by any existing consumer tooling, or is acting on them left entirely to the agent author? The spec calls the trust tiers "advisory signals" but does not say who enforces them [verified: S4, 2026-08-31] — affects how strongly beat 3 can be pitched.
- The claim that *other* gateways also avoid `SUCCESS` is unchecked. Cut the plural or verify it — and either way, name no vendor.
- ~~Token refresh for a long-running agent.~~ **Resolved 2026-08-31** — `McpToolset(header_provider=…)` handles it; see *Technical substrate* [verified: S13].
- **Where does the repo live** — personal GitHub, employer org, or `GoogleCloudPlatform`-adjacent? Affects licence header, contribution policy, and how the post links it. Needs an owner decision `[assumption: personal or employer org]`.
- **Does `reference-agent enrich` run clean against a 2-table sandbox dataset?** Not executed here. The CLI surface is verified from source [S16], so the commands should be right — but the three-act structure assumes the run succeeds. First thing downstream should try; not an export blocker.
- **What does the generated `tables/payments.md` actually contain?** This one is a *narrative* risk, not a code risk, so it survives the code-is-unverified rule: Act 2 needs the generated document to be genuinely insufficient rather than strawmanned. Capture it from a real run and never hand-write it. **Named fallback if the generator turns out to describe `transaction_status` well:** move Act 2's example to GMV's `settlement_ts` period cut, which is a policy choice no schema can hold. Because that fallback exists, this does not block export.
- Does the BigQuery sandbox (no billing) support everything Act 1 needs — `datasets.get`, `tables.get`, and `sample_rows`' `SELECT`? Assumed yes `[assumption]`.
- **The seed data must be adversarial, and nobody has designed it yet.** Beat 8 only works if the naive query and the grounded query return *visibly different* numbers. That requires the ~2k rows to deliberately contain: orders with `status_code = 200` but `transaction_status = 'cancel'`; settled orders later `refund`ed; and orders whose `order_ts` and `settlement_ts` fall in different months. Seed the obvious happy path only and both queries agree, the contrast vanishes, and the article's central demonstration silently dies. **This is a hard requirement on `seed/seed_data.sql`, not a nice-to-have.**
- **Do the blog's figures come from the repo?** The worked example currently cites illustrative amounts (`Rp 1,428,500,000`, 12,450 orders) tagged `[assumption]`. Once the seed data exists, replace them with the numbers the repo actually returns — a post whose headline figure disagrees with its own runnable artifact is worse than one with no figure.
- **Which `google-adk` release first shipped `header_provider`?** It was read from `main`, not from a tagged release [verified: S13, 2026-08-31]. The post must pin a minimum version, and the claim is only safe once that version is confirmed.
- Does the BigQuery MCP server support OAuth on behalf of an end user (so row-level access follows the *asker*, not the service account)? The docs mention OAuth client ID/secret and agent identities [verified: S10, 2026-08-31] but the ADK-side wiring for it is unconfirmed. Matters for the enterprise reader.
- Whether the MCP path is subject to Model Armor by default or only when floor settings are configured [verified as optional: S10, 2026-08-31] — worth one sentence if the post touches prompt-injection risk.

## Provenance

**Tag key:** `[verified: source, date]` · `[decided: notes.md date]` · `[assumption]` · `[UNVERIFIED]` · `[stale: checked date]`

**Sources:** S1–S16 in *Source materials*.

**Tools used:** `view_file`, `write_to_file`, `search_web`, `WebFetch` (OKF `SPEC.md`, `acme_retail` bundle, adk.dev, ai.google.dev, docs.midtrans.com), `curl` (adk.dev `llms.txt`, Midtrans `llms.txt` + markdown pages), skill `google-agents-cli-adk-code`.

**Note on tooling:** `WebSearch` is unavailable in this workspace (blocked by an org policy on the model). Research was done by direct fetch of primary sources, which is stronger evidence but means broad prior-art sweeps are harder — treat the prior-art coverage in `refs.md` as narrower than usual.

**Changelog**

| Date | Change |
|---|---|
| 2026-08-31 | Created initial CONTEXT.md scaffold and captured primary source materials (OKF, ADK, BigQuery skills). |
| 2026-08-31 | Updated scope to 7-10 min blog post, Python ADK stack, abstracted Indonesian marketplace domain, and high-level conceptual implementation. |
| 2026-08-31 | Completed Pass 2 critique and scoring. Moved phase to `decided`. Filled narrative spine beats 1–8, canonical claims, worked example, code snippets, and rejected directions. |
| 2026-08-31 | **Pass 13 — code is an unverified reference and does not block export (owner policy).** Recorded in AGENTS.md §5 and §9, `templates/CONTEXT.md`, and `/export-context`: snippets in `CONTEXT.md` are sketches of the shape, not tested artifacts. Upstream's job is to get every identifier right and tag it; downstream builds, runs and proves it. Downgraded all three export blockers here — the agent snippet never being run, `reference-agent enrich` never being run, and the unknown content of the generated `tables/payments.md`. The last one is a *narrative* risk rather than a code risk, so it keeps a named fallback (move Act 2's example to GMV's `settlement_ts` period cut) which is what makes it safe to ship unresolved. `refs.md` *Unverified* table now has no `Yes` in the blocks-export column. |
| 2026-08-31 | **Pass 12 — Vertex AI renamed to Gemini Enterprise Agent Platform (owner).** Closes the naming open question raised in Pass 11. Updated *Technical substrate* (model access and env requirements), the repo's `.env.example` comment, added GEAP to `google_cloud_products`, and locked it with a *Terminology* row and a canonical claim. Two carve-outs recorded so nobody over-applies the rename: the literal env var `GOOGLE_GENAI_USE_VERTEXAI` still carries the old spelling and must not be "corrected", and any source extract that uses the old name must stay verbatim (none currently do). |
| 2026-08-31 | **Pass 11 — core Google products moved into frontmatter (owner).** `google_cloud_products:` is now a standard frontmatter key listing **core products only**, so it is visible at the top of the file; recorded in the AGENTS.md schema, `templates/CONTEXT.md`, and checked by `/topic-status` and `/export-context`. Here: BigQuery, BigQuery MCP server, Agent Development Kit, Open Knowledge Format. An earlier attempt at a full products *section* with depth and surface columns was built and removed the same day — too heavy. Two findings from it were kept: ADK and OKF are Google open-source projects rather than Google Cloud services (see *Terminology*), and ADK's docs call Vertex AI "Agent Platform (GEAP, formerly Vertex)", now an open question. |
| 2026-08-31 | **Pass 10 — core problem trimmed; re-derivation cost added as the second problem (owner).** Dropped "hallucinated status codes" from the *Core Problem* bullet — it duplicated the hook and overstated the failure mode (the real failure is a plausible wrong filter, not an invented column). Added a second problem the article had been ignoring: **even when the schema and definitions are all available, the agent re-derives the same conclusions every session** — paying tokens and latency each time, and with no guarantee two sessions agree on the same metric definition. Framed as the *context vs knowledge* distinction: OKF stores the conclusion, not the raw material. New beat 2b meets the "just let it think" counter-argument head-on; two new objections, including the cache framing (`stale_after` is expiry, `verified` is who validated it, `sources` is what to re-derive from). Guard claim added: the argument is structural and must **not** be presented as a measured token or latency saving — nothing has been benchmarked. |
| 2026-08-31 | **Pass 9b — scope section made per-artifact.** The *Out of scope* bullet still deferred dataset seeding "to an upcoming deep-dive tutorial", contradicting Pass 7, which made `seed/` mandatory in the repo. Rewritten as a scope **split**: seeding is in scope for the repo, out of scope for the prose. Added a matching in-scope bullet for the repo's runnable substrate and a note at the head of the section — anything the reader must *run* belongs to the repo, anything they must *understand* belongs to the post. Genuinely new exclusion added in its place: DDL migrations, partitioning/clustering and warehouse-modelling advice. Rejected-directions row reworded so the row reads as settled rather than as an open prohibition. |
| 2026-08-31 | **Pass 9 — repo is a finished example; the PR step is gone (owner decision).** Removed `git diff` from the README flow and every "now you try" framing: the repo works fully on clone, and a reader who never types `git` gets the whole result. GitOps moves entirely into blog beat 9, illustrated with a diff **in the prose** rather than a step the reader performs. Replaced the diff mechanism with **two committed bundles** — `bundles/generated/` (untouched Act 1 output) and `bundles/marketplace/` (same content plus the hand-written `metrics/` and `references/`) — so the before/after is `OKF_BUNDLE=… adk run agent` twice, one word apart. Agent snippet now reads the bundle path from `$OKF_BUNDLE`. Noted that the honest tell between machine- and human-authored concepts is already in the frontmatter (`generated` with no `verified` ⇒ trust tier `unverified`), so OKF itself does the job the diff was standing in for. Hard rule recorded: `bundles/generated/` must never be hand-edited, or the demonstration becomes a strawman; and regeneration is not byte-stable, which the README must say. |
| 2026-08-31 | **Pass 8 — audience broadened to global; all brand names removed (owner decision).** Added a *Publishing constraints* section at the top that overrides everything below it. (1) No vendor or brand names in the data or the prose: the payment-gateway citation stays in S7 for upstream auditability and is flagged not-for-publication; the article says "a real payment gateway"; seeded data carries no company, merchant or customer names. (2) English throughout — Bahasa removed from the agent `instruction`, the agent's answer, the worked-example question, the SQL alias `jumlah_transaksi` → `settled_orders`, the sample OKF card's `omzet` → "turnover" and its Bahasa source title. Audience frontmatter and persona notes rewritten for a global reader; `indonesian-developers` tag dropped, `semantic-layer` added. The Indonesian *scenario* is deliberately kept and reframed as an asset: an unfamiliar domain vocabulary puts the reader in the model's position, so `QRIS` and `Jabodetabek` stay and get a one-clause gloss on first use. Two new rejected directions record the naming and language constraints so they cannot drift back. |
| 2026-08-31 | **Pass 7 — narrative restructured into three acts; repo added as a co-equal deliverable (owner decision).** New spine: *generate* the bundle by running Google's reference agent against a BigQuery dataset → *teach* it what `INFORMATION_SCHEMA` cannot know → *consume* it with the ADK + BigQuery MCP agent. Verified the runnable surface (S16): `reference-agent enrich --source bq --dataset P.D --out <bundle> --no-web`, plus `visualize`; `bq` is the only source; it emits `BigQuery Dataset` and `BigQuery Table` documents **only**, and regenerates `index.md` after every pass — so `metrics/` and `references/` are necessarily hand-written, which is now the article's central claim rather than an aside. Bundle tree annotated GENERATED / HAND-WRITTEN. Added a companion-repository section with layout, five-command README, and design rules. Data seeding partially un-rejected: still out of the prose, now mandatory in the repo. Four new objections, including "why trust an LLM-generated doc about my schema" (answer: it has no `verified` event, so its trust tier is literally `unverified`). Assets list rebuilt around before/after traces. `downstream` now `[tutorial, repo]`. |
| 2026-08-31 | **Pass 6 — bundle design checked against Google's reference agent and simplified.** Read `src/reference_agent` (S14) and the raw published bundle documents (S15). Corrections: switched in-body links from bundle-root-absolute to file-relative (spec recommends absolute; the reference agent forbids it and no published bundle uses it — conflict now recorded); removed the H1 that duplicated the frontmatter `title`; tightened `description` to one sentence; dropped explicit `status: stable`; changed the `generated.by` actor to `human:<id>` for a hand-authored doc; replaced invented `payments/` and `geography/` directories with `tables/` and `references/`; adopted the `# Schema` / `# Common query patterns` table-doc convention. Simplification: schema cut from three tables to two, bundle cut to four concept documents in three directories, with the directory split itself carrying the argument. New beat 5b answering "isn't this just an agent skill?" — OKF defines `type: Skill`, so a skill is one type inside it. Also recorded that the reference agent is an *authoring* agent, so the consumer side this post builds is genuinely uncovered by it. |
| 2026-08-31 | **Pass 5 — `header_provider` correction (owner-flagged).** Pass 4 claimed ADK Python had no per-request header hook, based on the public docs page. Wrong: `McpToolset` takes a `header_provider` kwarg, sync or async, `(ReadonlyContext) -> dict[str, str]`. Snippet rewritten to refresh the ADC token on expiry instead of freezing it at import, closing the token-expiry open question. Reading the source also surfaced that `StreamableHTTPConnectionParams` has `timeout` / `sse_read_timeout` / `terminate_on_close` / `httpx_client_factory` (also undocumented on the page), that sessions are pooled on an MD5 of merged headers (so a rotating token string opens a session per call), and that ADK auto-injects ADC for `*.googleapis.com` but only on the mTLS transport path. Added S13 (ADK source) and downgraded S12 to "incomplete — trust S13". |
| 2026-08-31 | **Pass 4 — execution layer switched to the managed BigQuery MCP server** (owner decision). Replaced `BigQueryToolset` with `McpToolset` + `StreamableHTTPConnectionParams` against `https://bigquery.googleapis.com/mcp`. Tool catalogue read from the live server (`tools/list` needs no auth): six tools, all requiring `projectId`; `execute_sql_readonly` is the one to use, `execute_sql` is the only destructive one. Added S10–S12 with extracts. Safety model changed from `WriteMode.BLOCKED` to `tool_filter` + IAM deny policy. Recorded the 3,000-row / three-minute ceilings, `goog-mcp-server:true` job tagging, the three required IAM roles, and two new traps: every tool needs `projectId`, and the ADK docs' `'Bearer $(gcloud auth print-access-token)'` Python line does not work. New open question on token refresh — ADK Python has fixed headers only. `BigQueryToolset` retained as a documented rejected alternative. |
| 2026-08-31 | **Pass 3 — verification.** Corrected OKF v0.1 → **v0.2** and replaced the invented `type: concept` frontmatter with the real shape from Google's published `acme_retail/metrics/revenue.md`. Replaced the fabricated ADK snippet (`from adk import Agent, Tool`, `Tool.from_function`, `system_instruction=`) with the verified API, now built on the first-party `BigQueryToolset` instead of a hand-rolled BigQuery client. Upgraded the Indonesian payment-status claim from `[assumption]` to `[verified]` against Midtrans docs, and sharpened the hook: `status_code = 200` also covers `cancel`. Model ID `gemini-2.5-flash [assumption]` → `gemini-3.7-flash [verified]`; noted `gemini-2.0-flash` is shut down. Added S4–S9 with extracts, four objections, four rejected directions, and four open questions. Beats 3, 5, 6 and 8 rewritten around OKF v0.2 trust fields and the `acme_retail` conventions. |


---

# Sources ledger (inlined from the upstream `refs.md`)

Included verbatim so every claim above stays auditable without access to the origin workspace.
This is the full trail, including dead ends and searches that returned nothing.

## References — Open Knowledge Format with BigQuery and Agent Development Kit

Every source consulted, including dead ends. Gets inlined into the export bundle, so downstream can audit any claim.

**Load-bearing sources do not live here.** They go in *Source materials* in `CONTEXT.md`, with extracts. This file is the trail: everything looked at, including what was rejected.

### Provided by the user

| ID | Source | Given | Verdict | Where it landed |
|---|---|---|---|---|
| S1 | `https://github.com/GoogleCloudPlatform/open-knowledge-format` | 2026-08-31 | used | `CONTEXT.md` → Source materials (S1) |
| S2 | `https://adk.dev/` | 2026-08-31 | used | `CONTEXT.md` → Source materials (S2) |
| S3 | `https://github.com/google/skills/blob/main/skills/cloud/bigquery-basics` | 2026-08-31 | used | `CONTEXT.md` → Source materials (S3) |
| S10 | `https://docs.cloud.google.com/bigquery/docs/use-bigquery-mcp` | 2026-08-31 | used — **replaces `BigQueryToolset` as the execution layer, per owner instruction** | `CONTEXT.md` → Source materials (S10) |
| S14 | `https://github.com/GoogleCloudPlatform/open-knowledge-format/tree/main/src/reference_agent` | 2026-08-31 | used — owner asked whether our bundle design aligns with it. It did not; corrected | `CONTEXT.md` → Source materials (S14) |

### Provided, not used

Logged so the same link does not get re-litigated three chats from now.

| Source | Given | Why not used |
|---|---|---|
| _none_ | | |

### Primary docs

| Link | What it settles | Checked |
|---|---|---|
| `https://github.com/GoogleCloudPlatform/open-knowledge-format` | Repo README: OKF is "vendor-neutral", spec is at v0.2, bundles live under `bundles/<name>/` | 2026-08-31 |
| `https://github.com/GoogleCloudPlatform/open-knowledge-format/blob/main/SPEC.md` | **Normative.** v0.2. `type` is the only always-required key; types not centrally registered; bundle = directory tree; `index.md`/`log.md` reserved; root-absolute links recommended; `sources` / `verified` / `stale_after` semantics; ISO 8601 with explicit UTC offset | 2026-08-31 |
| `https://github.com/GoogleCloudPlatform/open-knowledge-format/tree/main/bundles/acme_retail` | Official BigQuery-grounded sample. Dirs: `tables/ metrics/ computations/ policies/ skills/ attesters/` + `index.md` + `log.md` + `viz.html` | 2026-08-31 |
| `.../bundles/acme_retail/metrics/revenue.md` | Real published frontmatter (`type: Metric`, `generated`, `verified`, `status`, `stale_after`, `sources` with footnote join key) and body headings | 2026-08-31 |
| `.../bundles/acme_retail/metrics/index.md` | `revenue.md`, `gross-margin.md`, `gross-margin-legacy.md` ("kept for historical reproducibility") | 2026-08-31 |
| `.../bundles/acme_retail/tables/index.md` | Single table concept `orders.md` | 2026-08-31 |
| `https://adk.dev/` | ADK agent architecture, multi-language SDKs (Python, JS/TS, Go, Java, Kotlin), tools, runtime | 2026-08-31 |
| `https://docs.cloud.google.com/bigquery/docs/use-bigquery-mcp` | **The chosen execution layer.** Endpoint `https://bigquery.googleapis.com/mcp`, enabled with the BigQuery API; OAuth 2.0 + IAM, scope `.../auth/bigquery`; roles `mcp.toolUser` + `bigquery.jobUser` + `bigquery.dataViewer`; `execute_sql` is the only non-read-only tool, restrictable by IAM deny policy; 3-min / 3,000-row caps; no own quotas; jobs tagged `goog-mcp-server:true`; `tools/list` needs no auth | 2026-08-31 |
| `https://docs.cloud.google.com/bigquery/docs/reference/mcp` | **Dead end** — page body did not render through WebFetch, only nav chrome. Tool catalogue obtained from the live server instead | 2026-08-31 |
| Live `POST https://bigquery.googleapis.com/mcp` `tools/list` | Authoritative catalogue: 6 tools, all requiring `projectId`; annotations (`readOnlyHint`, `destructiveHint`); `execute_sql_readonly` preferred over `execute_sql` by the server's own description. Narrower than `BigQueryToolset` — no forecast/insights/catalog-search | 2026-08-31 |
| `https://adk.dev/tools-custom/mcp-tools/index.md` | ADK remote-MCP wiring: `McpToolset` + `StreamableHTTPConnectionParams(url, headers)`, `tool_filter` on the toolset. Contains a broken example: `'Bearer $(gcloud auth print-access-token)'` inside a Python dict. **Incomplete — omits `header_provider` and the connection timeouts. Superseded by the source** | 2026-08-31 |
| `google/adk-python@main` → `src/google/adk/tools/mcp_tool/mcp_toolset.py`, `mcp_session_manager.py` | **Authoritative.** `McpToolset(header_provider=…)` exists: `Callable[[ReadonlyContext], dict[str,str] \| Awaitable[...]]`, sync or async. Merge order = provider then exchanged-credential (credential wins). Sessions pooled on `md5(json.dumps(merged_headers, sort_keys=True))`. `tool_list_cache_ttl_seconds` keyed the same, capped at 64. `StreamableHTTPConnectionParams` has `timeout=5.0`, `sse_read_timeout=300.0`, `terminate_on_close`, `httpx_client_factory`. ADC auto-injection for `*.googleapis.com` exists but only via `_get_mtls_transport()`, which needs a real mTLS client cert | 2026-08-31 |
| `https://adk.dev/integrations/bigquery/index.md` | Settled the old Unverified row. `BigQueryToolset` / `BigQueryCredentialsConfig` / `BigQueryToolConfig` / `WriteMode`, ADK ≥ 1.1.0, 11 packaged tools, 5 credential modes. **Now the rejected alternative** — kept for the objection answer | 2026-08-31 |
| `https://adk.dev/llms.txt` | Docs index. Confirms only three BigQuery-related pages exist (toolset, analytics plugin, environment toolsets) | 2026-08-31 |
| `https://ai.google.dev/gemini-api/docs/models` | `gemini-3.7-flash` current stable Flash; `gemini-2.5-flash` still current; `gemini-2.0-flash` shut down. Page updated 2026-08-27 | 2026-08-31 |
| `https://docs.midtrans.com/reference/transaction-status.md` | Full `transaction_status` enum. No `SUCCESS` value exists. `settlement` = "Funds have been credited to your account" | 2026-08-31 |
| `https://docs.midtrans.com/reference/code-2xx.md` | `status_code` 200 = success but spans `authorize, capture, settlement, cancel`; 201 = pending; 202 = denied; cancel notifications carry 202 | 2026-08-31 |
| `https://docs.midtrans.com/docs/transaction-status-cycle.md` | Status transition graph; corroborates the enum page | 2026-08-31 |
| `https://github.com/google/skills` | Google skills standard for agent tools and cloud operations including BigQuery | 2026-08-31 |
| Local skill `google-agents-cli-adk-code` → `references/adk-python.md` | ADK Python `Agent(...)` signature, function-tool rules (typed, no defaults, docstring is the API, return dict), callbacks incl. `before_tool_callback`. Not publicly linkable — extract inlined in CONTEXT.md S8 | 2026-08-31 |

### Prior art (existing material on this topic)

| Link | Who | Date | Format | Takeaway | Overlap risk |
|---|---|---|---|---|---|
| Google Cloud Knowledge Catalog / OKF announcement articles | Google Cloud Tech | 2025/2026 | Docs/Blog | Generic overview of OKF concepts and GA4/Bitcoin samples | Low (no Indonesian localized marketplace use cases exist) |
| General Agent Development Kit (ADK) getting started articles | Google Cloud / Community | 2026 | Docs/Blog | Basic multi-agent and tool calling patterns | Low (we pair ADK with OKF grounding + BigQuery execution) |
| **`src/reference_agent` in the OKF repo** | Google Cloud | 2026 | Reference implementation | **Authoring only.** Two ADK agents that *write* bundles from BigQuery metadata and web pages. There is no consumer agent in the repo — nothing that answers a business question from a bundle | **Low, and clarifying.** It defines the conventions our bundle must follow, and confirms the consumer side is genuinely unwritten. It is also the source of the file-relative link rule that overrides SPEC.md |
| **`bundles/acme_retail` in the OKF repo** | Google Cloud | 2026 | Sample bundle | **Closest prior art found. Already does "BigQuery + business metrics in OKF"** — `tables/orders.md` grounded on BigQuery, `metrics/revenue.md` and `gross-margin.md`, plus attested SQL computations and Finance policies. Pass 2 recorded "no localized e-commerce bundle", which was true but understated: a *retail* bundle exists | **Medium — was scored Low in Pass 2.** Mitigated: the sample ships no agent, no ADK wiring, no query trace, nothing localized. Post now cites it as the convention to imitate rather than competing with it |
| `bundles/ga4`, `bundles/stackoverflow`, `bundles/crypto_bitcoin` | Google Cloud | 2026 | Sample bundles | Other official bundles; none analytics-agent-shaped | Low |
| ADK BigQuery integration page (`adk.dev/integrations/bigquery`) | Google | 2026 | Docs | Shows a full BigQuery data-science agent already. Its own example asks natural-language questions over `bigquery-public-data` | **Medium.** A reader may conclude ADK alone is enough. The post must answer this head-on — objection added to CONTEXT.md |

### Signals (what the audience is actually asking)

| Source | Link | Signal |
|---|---|---|
> **Naming constraint, 2026-08-31:** the payment-gateway URLs below stay in this ledger so the status-vocabulary claim can be audited. The published blog, repo and seeded data must not name that vendor or any other brand. See *Publishing constraints* in `CONTEXT.md`.

| Indonesian developer community forums & meetups | Community Signal | High interest in GenAI Text-to-SQL assistants for e-commerce and retail analytics, but constant frustration with SQL hallucinations and missing localized metric context (e.g. status code mapping, payment reconciliation). |

### Searches run

| Query | Tool | Result |
|---|---|---|
| `"google/skills" "bigquery-basics" OR "bigquery" site:github.com/google/skills` | web search | Found google/skills repo structure and BigQuery skill details |
| `"GoogleCloudPlatform/open-knowledge-format" OR "open-knowledge-format" github` | web search | Found OKF specification summary: bundles, YAML frontmatter, Markdown links, Git versioning |
| `"open-knowledge-format" "GoogleCloudPlatform" github README` | web search | Detailed OKF concept overview, v0.1 spec details, enrichment agents, visualizer |
| `site:github.com/google/skills "bigquery"` | web search | Verified BigQuery skill usage and integration patterns |
| `"open knowledge format" "agent development kit" OR "ADK"` | web search | Verified OKF + ADK integration patterns, agent runtime memory layering |
| — Pass 3, 2026-08-31 — | | |
| `WebSearch` for current Gemini Flash model IDs | WebSearch | **Failed.** `400 ... Organization Policy constraint constraints/vertexai.allowedPartnerModelFeatures violated ... disallowed feature web_search`. WebSearch is unusable in this workspace; all Pass 3 research done via direct WebFetch/curl of primary sources |
| Fetch `open-knowledge-format/README.md` | WebFetch | Spec is v0.2, not v0.1. Bundles live under `bundles/<name>/`. Required-key list not in README |
| Fetch `open-knowledge-format/SPEC.md` | WebFetch | Normative answers: only `type` required, open type vocabulary, reserved `index.md`/`log.md`, root-absolute links preferred, `sources`/`verified`/`stale_after` |
| Browse `bundles/acme_retail` tree, then `index.md`, `metrics/index.md`, `metrics/revenue.md`, `tables/index.md` | WebFetch | Real directory conventions and real frontmatter. `acme_retail/index.md` itself could not be reproduced verbatim by the fetch model — only summarized |
| Fetch `https://adk.dev/tools-built-in/bigquery/` | WebFetch | **404.** Wrong path guess |
| `curl https://adk.dev/llms.txt \| grep -i bigquery` | curl | Correct path is `/integrations/bigquery/index.md` |
| Fetch `adk.dev/integrations/bigquery/index.md` | WebFetch | Full toolset API, credential modes, `WriteMode.BLOCKED`, and a stale `gemini-2.0-flash` in its own example |
| Fetch `ai.google.dev/gemini-api/docs/models` | WebFetch | Current model IDs; `gemini-2.0-flash` shut down |
| Fetch `docs.midtrans.com/reference/status-code` and `.md` | WebFetch | **Both stubs** — JS-rendered, no tables in the markdown output |
| `curl https://docs.midtrans.com/llms.txt \| grep -i status` | curl | Located the real pages |
| `curl` `reference/transaction-status.md`, `reference/code-2xx.md`, `docs/transaction-status-cycle.md` | curl | Full status vocabulary and 2xx code meanings. Upgraded the hook from `[assumption]` to `[verified]` |
| Read local skill `google-agents-cli-adk-code` + `references/adk-python.md` | Skill / Read | Correct ADK Python API; exposed that the Pass 2 snippet was fabricated |
| — Pass 4, 2026-08-31 (owner switched execution layer to BigQuery MCP) — | | |
| Fetch `docs.cloud.google.com/bigquery/docs/use-bigquery-mcp` | WebFetch | Endpoint, auth, IAM roles, limits, quotas, Model Armor. Tool names present only in a quotas table |
| Fetch `docs.cloud.google.com/bigquery/docs/reference/mcp` | WebFetch | **Dead end** — article body truncated to nav chrome; no tool definitions retrieved |
| `curl -X POST https://bigquery.googleapis.com/mcp -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'` | curl | **Worked unauthenticated.** Authoritative 6-tool catalogue with JSON schemas and annotations. Note: needs `Accept: application/json, text/event-stream` |
| `curl https://adk.dev/llms.txt \| grep -i mcp` | curl | Located `tools-custom/mcp-tools` and `mcp/` pages; also revealed dozens of third-party MCP integration pages but no BigQuery MCP page on adk.dev |
| Fetch `adk.dev/tools-custom/mcp-tools/index.md` | WebFetch | Remote-MCP wiring, header/auth patterns, `tool_filter` placement |
| `grep -n -E "auth_credential\|header_provider\|refresh" /tmp/adkmcp.md` | curl + grep | Grepped the **docs page**, found no `header_provider`, and wrongly concluded Python lacks the feature. Absence from a docs page is not absence from the API. Corrected in Pass 5 |
| — Pass 5, 2026-08-31 (owner: "they said we can use header_provider in the kwargs") — | | |
| `python3 -c "import google.adk"` / `pip show google-adk` | Bash | **Not installed** — no local package to introspect. Read GitHub source instead |
| `curl raw.githubusercontent.com/google/adk-python/main/src/google/adk/tools/mcp_tool/mcp_session_manager.py` | curl + grep | No `header_provider` here — it lives on the toolset, not the session manager. Surfaced `_RefreshableAsyncCredentials` and the mTLS/ADC path |
| `for f in mcp_toolset.py mcp_session_manager.py mcp_tool.py __init__.py; grep -i header_provider` | curl + grep | **Found it.** 8 hits in `mcp_toolset.py`, 5 in `mcp_tool.py`. Owner was right |
| Read `mcp_toolset.py` lines 140–270 and `_get_headers` | curl + sed | Exact signature, docstring, merge order, awaitable handling |
| Read `mcp_session_manager.py` `_generate_session_key` / `_merge_headers` / `create_session` | curl + sed | Sessions pooled on MD5 of merged headers — the reason a rotating token string is costly |
| Read `_get_mtls_transport` and `_RefreshableAsyncCredentials` | curl + sed | ADC auto-injection is real but gated behind a genuine mTLS channel; not a general auth path |
| — Pass 6, 2026-08-31 (owner: does our OKF design align with `src/reference_agent`?) — | | |
| `GET api.github.com/repos/.../git/trees/main?recursive=1` | curl + python | Full repo tree. `src/reference_agent` has `bundle/`, `tools/`, `sources/`, `prompts/`, `viewer/`, `web/`; bundles are `acme_retail`, `crypto_bitcoin`, `ga4`, `stackoverflow` |
| Read `src/reference_agent/agent.py` | curl | Two **authoring** agents (`okf_bq_reference_agent`, `okf_web_ingestion_agent`) over 5 function tools. `DEFAULT_MODEL = "gemini-flash-latest"`. No consumer agent anywhere in the repo |
| Read `src/reference_agent/tools/bundle_tools.py` | curl | Frontmatter key ordering, `generated` auto-fill, augmentation guards that refuse schema/sources shrinkage |
| Read `src/reference_agent/bundle/document.py` | curl | `REQUIRED_FRONTMATTER_KEYS = ("type",)`; `trust_tier()`; `is_stale()` ignores a date-only `stale_after`; YAML timestamp resolver stripped to avoid round-trip rewrites |
| Read `src/reference_agent/bundle/paths.py` | curl | Concept-id segment regex and id→path mapping |
| Read `src/reference_agent/prompts/reference_instruction.md` | curl | **The key source.** Body section order, one-sentence `description`, `status` default, actor conventions, no `# Citations`, and the file-relative link rule that contradicts SPEC.md |
| Fetch raw `bundles/acme_retail/{index.md, tables/orders.md, metrics/revenue.md, skills/index.md, skills/run-on-bq.md}` and `bundles/ga4/index.md` | curl | Real published shapes — no title H1, footnotes in schema table cells, `usage_window`, relative links, and `type: Skill` |
| — Pass 7, 2026-08-31 (owner: narrative = generate → teach → consume; ship a repo too) — | | |
| Read `src/reference_agent/cli.py` and `__main__.py` | curl | Console script `reference-agent`; subcommands `enrich` and `visualize`; full flag list; `_SOURCES = ("bq",)`; default model `gemini-flash-latest`; web allow-list defaults to seed hosts |
| Read `pyproject.toml` | curl | Package `reference-agent` 0.1.0, Python ≥3.11, `google-adk>=2.0`. Not on PyPI — install from the repo |
| Read `src/reference_agent/sources/bigquery.py` | curl | **Decisive for the narrative.** A BigQuery source emits only `BigQuery Dataset` + `BigQuery Table` concepts, collapsing sharded tables into family concepts. No `Metric` or `Reference` is ever generated |
| Read `src/reference_agent/runner.py` | curl | `enrich_all()` → per-concept pass → optional web pass → `regenerate_indexes()`. Index files are machine-generated |

### Conflicts

| Claim | Source A says | Source B says | CONTEXT.md follows | Why |
|---|---|---|---|---|
| Which Gemini model to put in the snippet | ADK BigQuery docs example pins `gemini-2.0-flash` | `ai.google.dev/gemini-api/docs/models` lists `gemini-2.0-flash` as shut down and `gemini-3.7-flash` as current stable | **B** — `gemini-3.7-flash` | The model catalogue is the primary source for model lifecycle; the ADK page's example is simply stale. Recorded so nobody "fixes" our snippet back to match the ADK docs |
| What proves a payment succeeded | An intuitive reading of `status_code = 200` as "success" | Midtrans: `200` spans `authorize, capture, settlement, cancel`; only `transaction_status = 'settlement'` means funds credited | **B** | Primary vendor doc. This conflict *is* the article's hook |
| Spec version | Pass 2 CONTEXT.md said OKF v0.1 | Repo README and `SPEC.md` both say v0.2 | **B** — v0.2 | Pass 2 was wrong, not a source conflict; logged so the v0.1 figure does not reappear |
| **Link form inside concept bodies** | `SPEC.md`: two forms supported; the bundle-root-absolute form beginning with `/` is **recommended** "because it survives moves" | `src/reference_agent/prompts/reference_instruction.md`: "Use file-relative paths only. **Never start a link with `/`** (that breaks GitHub rendering)". Every published bundle (`acme_retail`, `ga4`) uses file-relative links | **B — file-relative** | Normative spec loses to shipped implementation here: Google's own authoring agent and all four sample bundles do the opposite of what the spec recommends. The bundle's value to a blog reader is that it renders on GitHub. Flagged as a live inconsistency in the standard, worth one sentence in the post rather than being hidden |
| Where the QRIS status vocabulary lives | Our Pass 2–5 design put it in a standalone `payments/qris-status.md` reference doc | `acme_retail/tables/orders.md` documents its own `order_status` enum inline in the `# Schema` table with footnotes | **B** | It is a column on `payments`, so it belongs on that table's concept doc. Removes a file and a directory |

### Unverified

> **Code is exempt from the export gate.** Snippets and commands in `CONTEXT.md` are unverified references — downstream builds and runs them (AGENTS.md §5). Rows below track what is unproven, not what is forbidden to ship.

| Claim | Needs checking against | Blocks export? |
|---|---|---|
| ~~Exact `google-adk` Python API syntax for custom tool binding to OKF markdown loader~~ | **Resolved 2026-08-31** — `adk.dev/integrations/bigquery` + local ADK Python cheatsheet. Snippet rewritten; the Pass 2 version was fabricated | No longer blocking |
| The snippet has never been executed against a live BigQuery project | An actual run. `tools/list` was probed live; no authenticated tool call or full agent loop was run | **No** — code here is an unverified reference by policy; downstream runs it |
| `reference-agent enrich` has never been run. Act 1 is verified from source, not from output | An actual run against a 2-table sandbox dataset | **No** — but it is the first thing downstream should try, since the three-act structure assumes it succeeds |
| The real content of a generated `tables/payments.md` | Same run. Act 2's honesty depends on the generated doc being genuinely insufficient, not strawmanned | **No** — a fallback example is named in *Open questions*, so the narrative survives either outcome |
| Whether the BigQuery sandbox (no billing) supports `datasets.get`, `tables.get` and `sample_rows`' `SELECT` | A sandbox run | No — but it decides whether the repo is free to complete |
| ~~Token refresh strategy for `StreamableHTTPConnectionParams` in a long-running agent~~ | **Resolved 2026-08-31** — `McpToolset(header_provider=…)`, read from ADK source | No longer open |
| Whether `header_provider` is present in the pinned `google-adk` release the post will target, not just `main` | `pip index versions google-adk` / release notes, once a version is pinned | No, but the post must state a minimum version |
| Whether end-user OAuth (row-level access following the asker) can be wired from ADK to the BigQuery MCP server | ADK auth docs + BigQuery MCP OAuth client flow | No — but it is the enterprise reader's first question |
| Xendit and DOKU also use non-`SUCCESS` status vocabularies | Xendit / DOKU API docs | No — narrow the claim to Midtrans if unchecked at export |
| Whether any tool enforces `verified` / `stale_after`, or it is left to the agent author | OKF repo tooling (`okf` CLI, enrichment agents) | No — but it caps how strongly beat 3 can be pitched |
| Illustrative rupiah figures in the worked example | n/a — must be labelled illustrative, never presented as measured | No, if labelled |

---

# Instructions for the downstream agent

You are producing material from this bundle. It carries **truth, spine and constraints** — not format.

**Hard rules**

1. **Do not assert anything that is not in *Canonical claims*.** If you need a fact that is not there, mark it as needing verification; do not supply it from your own knowledge.
2. **Respect *Publishing constraints*.** No vendor or brand names in the data or the prose. English throughout, global reader, Indonesian scenario retained.
3. **Respect *Terminology*.** Exact names and casing. The *Not this* column is a list of things to never write.
4. **Do not revive anything in *Rejected directions*.** Each row records why it died.
5. **Keep to the *Narrative spine*.** Reshape beats into your format's shape; do not reorder the argument or drop a beat without saying so.
6. **Treat `[UNVERIFIED]`, `[assumption]` and `[stale]` as unproven.** Re-check before publication or phrase them as open. Never present them as established fact.
7. **`[verified: Sn, date]` claims were checked on that date.** Re-check anything time-sensitive — model IDs, product names, pricing, quotas, API surfaces — before publishing.

**Code in this bundle is an unverified reference.** Nothing here was executed. The identifiers
(class names, parameters, tool names, model IDs) are each checked against a primary source and
tagged; the assembled programs are sketches of the shape. **You build and run them — that is where
they get proven.** Expect to fix things, and treat a discrepancy as a bug in this bundle worth
reporting back, not as licence to redesign the approach.

**Assets:** the upstream `assets/` directory does not yet exist — every asset listed in *Assets* still
needs producing. If a future bundle ships with assets, copy that folder alongside this file.

**Known-unresolved at export** — none of these block the work, all need attention:

- `reference-agent enrich` has never been run against a real dataset. It is the first thing to try.
- The real content of a generated `tables/payments.md` is unknown. Act 2's example depends on it being genuinely insufficient; a fallback is named in *Open questions*.
- Seed data must be adversarial or the article's central before/after contrast collapses. See *Open questions*.
- The worked example's rupiah figures are placeholders and must be replaced with figures the repo actually returns.
- The minimum `google-adk` release containing `header_provider` is unconfirmed; it was read from `main`.
- Repo hosting location is undecided, which affects licence and attribution.
