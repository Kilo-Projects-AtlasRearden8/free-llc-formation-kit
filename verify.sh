#!/usr/bin/env bash
# verify.sh — repeatable verification for the Free LLC Formation Kit.
# Exits 0 if everything checks out, nonzero otherwise.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

PASS=0
FAIL=0

note() { echo "  - $1"; }
ok()   { PASS=$((PASS+1)); echo "  [ok] $1"; }
fail() { FAIL=$((FAIL+1)); echo "  [fail] $1"; echo "  $1" >> "$ROOT/.verify_errors"; }

: > "$ROOT/.verify_errors"

echo "== Free LLC Formation Kit verification =="
echo

# 1. Expected files present
echo "[1/5] Expected files present"
expected=(
  LICENSE
  README.md
  docs/01-name-search-checklist.md
  docs/02-articles-of-organization.md
  docs/03-operating-agreement-outline.md
  docs/04-ein-application.md
  docs/05-annual-filing-calendar.md
  print/style.css
  print/index.html
  print/name-search-checklist.html
  print/articles-of-organization.html
  print/operating-agreement.html
  print/ein-application.html
  print/annual-filing-calendar.html
)
for f in "${expected[@]}"; do
  if [[ -f "$f" ]]; then ok "$f"; else fail "missing: $f"; fi
done

# 2. LICENSE exact copyright line
echo "[2/5] LICENSE"
if grep -qxF 'Copyright (c) 2026 Asdale Dynamics, LLC' LICENSE; then ok "exact copyright line present"; else fail "LICENSE missing exact copyright line"; fi
if grep -qi 'MIT License' LICENSE; then ok "MIT License header present"; else fail "LICENSE missing MIT License header"; fi

# 3. README credit
echo "[3/5] README.md"
if grep -q 'Asdale Dynamics, LLC' README.md; then ok "credits Asdale Dynamics, LLC"; else fail "README missing Asdale Dynamics, LLC credit"; fi

# 4. HTML validity + links
echo "[4/5] HTML structure and links"
if ! command -v python3 >/dev/null 2>&1; then
  fail "python3 not available; skipping HTML checks"
else
  python3 - "$ROOT" <<'PYEOF'
import html.parser, os, re, sys

root = sys.argv[1]
VOID = {"area","base","br","col","embed","hr","img","input","link","meta","param","source","track","wbr"}
errors = []

class Checker(html.parser.HTMLParser):
    def __init__(self, path):
        super().__init__(); self.path = path; self.errors = []; self.stack = []
    def handle_starttag(self, tag, attrs):
        if tag not in VOID: self.stack.append(tag)
    def handle_endtag(self, tag):
        if tag in VOID: return
        if self.stack and self.stack[-1] == tag:
            self.stack.pop()
        elif tag in self.stack:
            while self.stack and self.stack[-1] != tag:
                self.stack.pop()
            if self.stack: self.stack.pop()
        else:
            self.errors.append(f"{self.path}: unexpected close </{tag}> (open: {self.stack[-6:]})")
    def finish(self):
        if self.stack:
            self.errors.append(f"{self.path}: unclosed tags at EOF: {self.stack}")

html_files = [
    "print/index.html",
    "print/name-search-checklist.html",
    "print/articles-of-organization.html",
    "print/operating-agreement.html",
    "print/ein-application.html",
    "print/annual-filing-calendar.html",
]
for rel in html_files:
    path = os.path.join(root, rel)
    text = open(path).read()
    c = Checker(path); c.feed(text); c.finish()
    for e in c.errors: errors.append(e)
    for m in re.finditer(r'href="([^"]+)"', text):
        href = m.group(1)
        if href.startswith(("http://","https://","mailto:")): continue
        target = href.split("#")[0]
        tpath = os.path.normpath(os.path.join(os.path.dirname(path), target))
        if not os.path.isfile(tpath):
            errors.append(f"{rel}: broken link -> {href}")

for e in errors:
    print(f"  [fail] {e}")
sys.exit(1 if errors else 0)
PYEOF
  if [[ $? -eq 0 ]]; then ok "all HTML files valid; all internal links resolve"; else fail "HTML/link errors above"; fi
fi

# 5. No secrets / workflows
echo "[5/5] Hygiene checks"
if [[ -d .github/workflows ]]; then fail ".github/workflows present (not allowed)"; else ok "no .github/workflows"; fi
if grep -rilE 'sk_live|sk_test|AKIA[0-9A-Z]{16}|github_pat_|api_key\s*=|[0-9a-f]{40,}|[0-9]{3}-[0-9]{2}-[0-9]{4}' --exclude-dir=.git --exclude=verify.sh . 2>/dev/null | grep -v '^./.verify_errors$'; then
  fail "possible secrets or personal data found"
else
  ok "no secrets, API keys, or personal data detected"
fi

echo
echo "== Summary: $PASS passed, $FAIL failed =="
if [[ -f "$ROOT/.verify_errors" && -s "$ROOT/.verify_errors" ]]; then
  echo "Failures:"
  cat "$ROOT/.verify_errors"
  rm -f "$ROOT/.verify_errors"
  exit 1
fi
rm -f "$ROOT/.verify_errors"
exit 0
