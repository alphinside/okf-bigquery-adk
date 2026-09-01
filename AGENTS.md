# Agent Harness — Open Knowledge Format with BigQuery and Agent Development Kit

This repo implements the code for one topic. The material it supports — blog, deck, tutorial, workshop — is produced elsewhere. This repo produces **working code that the material can point at**.

## The source of truth

[context/2026-08-31-okf-bigquery-adk-context.md](context/2026-08-31-okf-bigquery-adk-context.md) is a frozen context bundle produced upstream. Read it before writing anything.

It carries: the thesis, the audience, the narrative spine, canonical claims with sources, exact terminology, the technical substrate, and the directions that were already tried and rejected.

Rules:

- **Do not contradict the bundle.** If the code needs to diverge from it, that is a finding — write it down (see *Handing corrections back*), do not silently deviate.
- **Do not assert facts the bundle does not contain.** No invented version numbers, pricing, quotas, or API names in README or comments.
- **Respect the terminology table.** Exact names, exact casing. The material and the code must agree.
- **Do not revive rejected directions.** They are listed with reasons.
- The bundle is **frozen at its export date**. Anything in it may have rotted since.

## Claim tags

The bundle tags every claim:

| Tag | What it means for you |
|---|---|
| `[verified: <source>, <date>]` | Checked upstream on that date. Still re-check anything load-bearing. |
| `[decided: ...]` | An upstream judgement call, not an external fact. |
| `[assumption]` | Nobody confirmed this. Treat as a hypothesis. |
| `[UNVERIFIED]` | **Verify before relying on it.** Do not put it in a README as fact. |
| `[stale: checked <date>]` | Was true once. Re-check. |

Code is where `[UNVERIFIED]` gets resolved — you can run things, upstream could not.

## What this repo owes the material

- Code that **actually runs** on a machine that is not the author's.
- A `README.md` that gets a stranger from clone to working in the fewest honest steps.
- Pinned versions. The material will be read months after it is written.
- An escape hatch for the step most likely to break (auth, quota, a paid API).
- Honest failure behaviour. If it breaks without network or without billing, say so in the README.

## Handing corrections back

Implementing is where upstream's assumptions get tested. When you find that the bundle is wrong, append to [context/CORRECTIONS.md](context/CORRECTIONS.md):

```markdown
## YYYY-MM-DD
- **Claim:** <what the bundle says, quoted>
- **Reality:** <what actually happens, with the command or error>
- **Source:** <link or the observed behaviour>
- **Impact:** <which spine beat or claim this changes>
```

That file is the return path to the brainstorming workspace. A correction found here and never written down gets published as fact in the material.

## Boundaries

- Do not write the material here. No slide decks, no blog drafts, no lab handouts.
- Do not restructure the context bundle. It is frozen; corrections go in `CORRECTIONS.md`.
- Secrets never get committed. Use `.env` and document the required variables in the README.
