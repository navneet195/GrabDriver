# Cashmere Life Events — Insurance Classification

A single, read-only Databricks notebook for reviewing Cashmere profile data, extracting potential life-event statements, and optionally classifying approved public statements using Google Gemini with Google Search grounding. A configurable **Jev** adapter can serve as a fallback when implemented.

**Current notebook:** `00_cashmere_end_to_end_model_fallback_review.py`  
**Source:** `prod_builder_strategic_insights.prospect_mine.ext_lake_ext_si_cashmere`

## Features

| Feature | Behavior |
| --- | --- |
| Databricks source | Reads the configured Unity Catalog table; defaults to at most 100 rows |
| Validation | Splits records by whether `cashmere_id` is present and nonempty |
| Event extraction | Collects nonempty text from available `triggers`, `personal_recent_news`, `experiences`, `affiliations`, `philanthropy`, and `notables` columns |
| Candidate deduplication | Removes duplicate `(cashmere_id, source_field, event_text)` combinations |
| Gemini classification | Optional; classifies only approved public event statements using Google Search grounding |
| Jev fallback | Optional adapter interface; actual Jev provider integration is **not implemented** |
| No-model behavior | Returns `NOT_CLASSIFIED` without requiring Google credentials |
| Human review | All results remain `PENDING`; outreach is always `False` |
| Reporting | Prints metrics and displays status summaries and a masked review queue |
| Data writes | None: does not create, modify, or publish Databricks tables or files |

## Requirements

- Databricks notebook attached to compute with PySpark.
- `SELECT` permission on the configured source table.
- For optional Gemini use: an installed `google-genai` SDK, authorized outbound connectivity, and a Google API key in an existing Databricks secret scope.
- Organizational approval before sending **any** customer-related information to an external model.

## Run without Google credentials

1. Import `00_cashmere_end_to_end_model_fallback_review.py` into Databricks Workspace.
2. Attach your authorized compute.
3. Confirm the source table and set a suitable `ROW_LIMIT`.
4. Keep the defaults below and select **Run All**.

```python
SOURCE_TABLE = "prod_builder_strategic_insights.prospect_mine.ext_lake_ext_si_cashmere"
ROW_LIMIT = 100
USE_SYNTHETIC_DATA = False
SHOW_PERSONAL_DATA = False
ENABLE_GOOGLE_GROUNDING = False
ENABLE_JEV_FALLBACK = False
EXTERNAL_DATA_TRANSFER_APPROVED = False
PUBLIC_EVENT_TEXT_REVIEWED = False
MAX_GOOGLE_CALLS = 5
```

No API key is needed in this mode. Candidate statements are collected locally and the classification output uses:

```text
classification_status = NOT_CLASSIFIED
grounding_status = NOT_REQUESTED
human_review_status = PENDING
outreach_permitted = false
```

**Note:** A candidate is a nonempty source-field value, not a confirmed life event. The notebook does not load an approved 50-event catalogue and does not claim to classify events when both models are disabled.

## Optional Gemini grounding

Install `google-genai` on approved compute before enabling Gemini. The notebook reads the key from existing Databricks Secrets using `GOOGLE_SECRET_SCOPE` and `GOOGLE_SECRET_KEY`; do not place secrets in source code.

```python
GEMINI_MODEL = "gemini-2.5-flash"
GOOGLE_SECRET_SCOPE = "cashmere-secrets"
GOOGLE_SECRET_KEY = "google-gemini-api-key"
ENABLE_GOOGLE_GROUNDING = True
EXTERNAL_DATA_TRANSFER_APPROVED = True
PUBLIC_EVENT_TEXT_REVIEWED = True
```

The flags above should be set to `True` **only after** the relevant organizational approvals and review are complete. For real data, populate `APPROVED_PUBLIC_EVENTS` with reviewed public statements keyed by `candidate_id`; the notebook does **not** automatically send raw source event text. If approval, credentials, or reviewed text are missing, classification remains unavailable. Grounding URLs are leads for human verification, not verified proof of an event.

## Optional Jev fallback

The notebook exposes `ENABLE_JEV_FALLBACK`, `JEV_MODEL`, and `JEV_CLASSIFIER`. A working, approved callable must be supplied for `JEV_CLASSIFIER` before fallback can run. The provider, endpoint, authentication, and data-transfer policy are not defined in this project. Merely setting `ENABLE_JEV_FALLBACK = True` does not implement the integration.

## Results displayed on every run

- **Pipeline metrics:** source, valid, invalid, candidate, classified-output, not-classified, pending-review, outreach-permitted, evidence-source, and error counts.
- **Classification status:** counts grouped by `classification_status`.
- **Human review:** counts grouped by `human_review_status`.
- **Outreach:** counts grouped by `outreach_permitted`.
- **Grounding and insurance relevance:** status summaries.
- **Event sources:** candidate counts by source field.
- **Review queue:** candidate ID, source field, event classification, evidence URLs, review status, model, prompt version, and errors; customer IDs are hidden by default.

Set `SHOW_PERSONAL_DATA = True` only if authorized to view record-level information. Notebook outputs can still be visible to others with access to the workspace; do not share raw outputs outside approved channels.

## Source and validation notes

The current source schema includes `cashmere_id`, `name`, `triggers`, `personal_recent_news`, `experiences`, `affiliations`, `philanthropy`, and `notables`. Optional event-bearing fields are used only if present. Some source columns have punctuation in their names; the notebook quotes column identifiers when reading them.

Validation currently requires only a nonempty `cashmere_id`. Missing event text does not make a record invalid. Previously observed results were **100 source rows, 49 valid, 51 invalid**; counts can change with the selected sample and source updates.

## Security and limitations

- The notebook performs no Databricks writes or permission changes. It does **not** guarantee read permissions: those are controlled by the workspace administrator.
- External Gemini or Jev calls, if enabled, are a separate data-transfer action, not a Databricks write.
- AI classifications are provisional; no customer outreach, insurance eligibility, or underwriting decision is authorized by this notebook.
- Dynamic categories are **not** the approved 50-event business taxonomy.
- No-model execution produces reviewable candidates, not completed classifications.
- The notebook's smoke tests cover basic invariants; Databricks runtime, model integration, privacy compliance, and classification accuracy require separate validation.

## Suggested review sequence

Run locally with models disabled, inspect aggregate metrics, investigate invalid IDs, confirm which event-bearing fields contain usable statements, review a synthetic example, obtain external-processing approval, test a small set of explicitly approved public statements, and validate classifications with a human reviewer before broader use.
