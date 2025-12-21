## PR Description

**PR#:** <!-- e.g., PR#3 -->
**Title:** <!-- Brief title -->

> 📋 **References:**
> - [docs/DELEGATION_RULES.md](../docs/DELEGATION_RULES.md) — Change categories & scope rules
> - [docs/PR_CHECKLIST.md](../docs/PR_CHECKLIST.md) — Full pre-merge checklist
> - [docs/CHANGELOG_DEV.md](../docs/CHANGELOG_DEV.md) — Changelog format

---

## Scope Declaration

<!-- List ALL files this PR modifies. Must match DELEGATION_RULES.md scope lock -->

**Files Changed:**
- [ ] `path/to/file1.dart` (create | update | delete)
- [ ] `path/to/file2.dart` (create | update | delete)

**Category:** <!-- 🟢 Auto-safe | 🟡 Semi-safe | 🔴 Requires Review -->

---

## Checklist

<!-- Complete before requesting merge -->

### Build & Analysis
- [ ] `flutter analyze` — 0 errors
- [ ] App launches without crash

### Scope Compliance
- [ ] Only declared files modified
- [ ] No widget/route/model changes (unless explicitly requested)
- [ ] No pubspec.yaml changes (unless explicitly requested)

### Security
- [ ] No secrets or API keys in code
- [ ] Sensitive URLs use `AppConfig`

### Documentation
- [ ] `docs/CHANGELOG_DEV.md` updated
- [ ] New files have doc comments

---

## Rollback Instructions

<!-- How to undo this PR if needed -->

```bash
# Example:
git rm path/to/new_file.dart
git commit -m "Rollback: PR#X"
```

---

## Testing Notes

<!-- What was manually verified -->

- [ ] App builds successfully
- [ ] Feature works as expected
- [ ] No UI regressions observed

---

## Related Issues

<!-- Link any related issues or PRs -->

- Closes #
- Related to #

