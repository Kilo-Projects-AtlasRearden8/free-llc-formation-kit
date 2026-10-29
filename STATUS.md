# STATUS — Free LLC Formation Kit

## What was built

A free, fillable, printable LLC formation kit (education only — not legal advice), built and published by Asdale Dynamics, LLC (Indiana, formed October 2026). No account, no signup, nothing to install.

**Files (15, all committed to git):**
- `LICENSE` — MIT License, copyright line exactly `Copyright (c) 2026 Asdale Dynamics, LLC`
- `README.md` — kit overview, contents, how to use, education-only disclaimer, Asdale Dynamics, LLC credit, license (rewritten in a warmer, beginner-friendly "like a friend would" tone)
- `verify.sh` — repeatable verification script (file presence, LICENSE line, README credit, HTML structure, internal links, hygiene/secrets check)
- `docs/01-name-search-checklist.md` — Markdown source: state business name search checklist
- `docs/02-articles-of-organization.md` — Markdown source: articles of organization filing draft
- `docs/03-operating-agreement-outline.md` — Markdown source: operating agreement outline
- `docs/04-ein-application.md` — Markdown source: free EIN application steps (IRS Form SS-4 worksheet)
- `docs/05-annual-filing-calendar.md` — Markdown source: ongoing filing calendar template
- `print/index.html` — kit landing page with links to all five documents
- `print/name-search-checklist.html` — fillable, printable name-search checklist
- `print/articles-of-organization.html` — fillable, printable articles template
- `print/operating-agreement.html` — fillable, printable operating agreement outline
- `print/ein-application.html` — fillable, printable EIN application steps + SS-4 worksheet
- `print/annual-filing-calendar.html` — fillable, printable filing calendar
- `print/style.css` — shared screen/print styles (buttons hidden on print, clean forms on paper)

**No** `.github/workflows` or any other GitHub workflow files. No secrets, API keys, or personal data in any file.

## How to run it

1. Open `print/index.html` in any web browser (double-click the file; no server needed).
2. Open any individual page in `print/` to use just that document.
3. Type into the fields on screen, or print blank (Ctrl+P / Cmd+P) and fill in by hand. Print styles hide buttons and keep forms clean on paper.
4. Edit the Markdown sources in `docs/` to adapt the kit to your state; state filing offices, forms, and fees differ.
5. Indiana-specific notes are included throughout (Asdale Dynamics, LLC's home state): INBiz name search and filing, Indiana designator rules, no annual report but a biennial report every other year (first one due October 2028 for this LLC).
6. Run `./verify.sh` to re-run the verification suite.

## Verification results

`./verify.sh` — 20 passed, 0 failed:
- All 15 expected files present
- `LICENSE` contains the exact copyright line `Copyright (c) 2026 Asdale Dynamics, LLC` and the MIT header
- `README.md` credits Asdale Dynamics, LLC
- All six HTML files parse without structural errors
- All internal links resolve (including `LICENSE` from `print/index.html`, fixed from `../../LICENSE` to `../LICENSE`)
- No `.github/workflows`
- No secrets, API keys, or personal data detected
- Git initialized, two commits on branch `master` (latest `e6b31eb`), working tree clean

## Known gaps

- State-specific: kit is written around U.S. LLC formation generally with Indiana examples; users must confirm current forms, fees, and deadlines with their own Secretary of State — no state is fully covered.
- Not a state-approved form: the Articles template is an educational outline; download the official form from the state before filing.
- No legal review: operating agreement outline is not attorney-reviewed; multi-member or regulated LLCs should consult a lawyer.
- EIN: international applicants without a U.S. SSN/ITIN must use the IRS phone path; not all paths are equally fast.
- No build step: HTML/Markdown are opened directly in a browser; nothing to compile or test beyond `./verify.sh`.
- Education only: not legal, tax, or medical advice; Asdale Dynamics, LLC is not a law firm.
