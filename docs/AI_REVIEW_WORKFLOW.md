# SAIF OS Multi-Model Review

## Purpose

Use independent Claude and Gemini reviews as a second set of eyes for pull requests. The models are reviewers, not maintainers: neither model can push commits, approve or merge a pull request, execute repository code, or change project files.

## Current design

- Trigger: manual GitHub Actions workflow dispatch only.
- Input: a pull request number.
- Source: GitHub's read-only pull request diff API.
- Reviewers: Claude Sonnet 5.5 and Gemini 3.8 Flash.
- Output: separate Markdown reports uploaded as a GitHub Actions artifact.
- Permissions: repository contents read and pull requests read.
- No automated PR comments, no write token, no code execution, and no model-controlled tools.
- The diff is treated as untrusted input. Instructions embedded in source files or comments must not be followed.

The workflow checks out the trusted `main` branch for its review script. It fetches only the selected PR diff through GitHub's read-only API, so code from the reviewed PR is never checked out or executed by this workflow.

## One-time credential setup

In the GitHub repository, open **Settings → Secrets and variables → Actions → New repository secret** and add:

| Secret name | Where to obtain it |
|---|---|
| `ANTHROPIC_API_KEY` | Anthropic Console API keys |
| `GEMINI_API_KEY` | Google AI Studio API keys |

Never commit API keys to the repository, issue comments, workflow files, or chat. Use provider-specific keys with the minimum available scope and spending limits. Rotate a key immediately if it is exposed.

## Run a review

1. Open **Actions → SAIF Multi-Model Review**.
2. Select **Run workflow** on the `main` branch.
3. Enter the pull request number and start the workflow.
4. Open the completed run and download the `saif-ai-review-pr-N` artifact.
5. Compare both reports with the actual diff and CI evidence. Only verified findings should become issues or code changes.

The workflow is intentionally manual. This avoids sending every change to paid external APIs and keeps the user in control of when source diffs are shared with external providers.

## Model and API configuration

The default model IDs are configured in `.github/workflows/ai-review.yml`:
- Claude: `claude-sonnet-5-5`
- Gemini: `gemini-3.8-flash`

The Python client uses the Anthropic Messages API with API version `2026-10-21` and Google's Gemini `generateContent` REST endpoint. Model IDs can be changed in the workflow environment without changing the review logic. The offline test workflow validates syntax, request construction, response parsing, diff truncation, and input rejection without requiring API credentials or making paid model calls.

## Limitations and safeguards

- This is static diff review, not a full repository build, boot test, penetration test, or proof of correctness.
- Diffs larger than 70,000 characters are truncated and explicitly marked. A truncated review is incomplete.
- Provider availability, API access, model availability, quotas, and billing depend on the user's provider accounts.
- Review output is untrusted advice. Resolve disagreements using source inspection, reproducible tests, and CI.
- Do not send secrets, signing keys, personal data, customer data, or confidential third-party source code to external models.
- A green AI review never overrides failed CI or release gates.

## Next stage

After the first successful review, add a structured finding schema and a third independent security-focused pass. Any automated remediation must remain a separate, explicitly approved workflow with branch isolation and tests.
