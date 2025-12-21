# PR Checklist — WorkOn Frontend

Use this checklist before merging any PR.

---

## Pre-Merge Verification

### 🔨 Build & Analysis

- [ ] `flutter pub get` completes without errors
- [ ] `flutter analyze` returns **0 errors** (warnings acceptable)
- [ ] No new linter errors in modified files
- [ ] App launches without crash (`flutter run`)

### 📁 Scope Compliance

- [ ] Only files listed in PR scope were modified
- [ ] No widget/route/model files touched (unless explicitly requested)
- [ ] No `pubspec.yaml` changes (unless explicitly requested)
- [ ] No platform folder changes (`android/`, `ios/`, `web/`)

### 🔒 Security

- [ ] No API keys, secrets, or tokens in code
- [ ] No hardcoded credentials
- [ ] No sensitive URLs exposed (use `AppConfig` instead)
- [ ] No `print()` statements with sensitive data

### 📝 Documentation

- [ ] CHANGELOG_DEV.md updated with PR entry
- [ ] New files have doc comments explaining purpose
- [ ] Complex logic has inline comments

### 🧪 Testing Notes

| Test Type | Required | Notes |
|-----------|----------|-------|
| Unit tests | ⚪ Optional | For utility functions |
| Widget tests | ⚪ Optional | For new components |
| Manual test | 🟢 Recommended | Launch app, verify no regression |
| Integration test | 🔴 Not required | For API changes only |

---

## Rollback Instructions

### For Auto-safe changes (docs, config)

```bash
# Simply delete the file
git rm docs/new_file.md
git rm lib/config/new_config.dart
git commit -m "Rollback: remove [file]"
```

### For Semi-safe changes (services, utils)

```bash
# Revert the specific commit
git log --oneline -5  # Find the commit hash
git revert <commit_hash>
git push
```

### For Emergency rollback

```bash
# Reset to last known good state
git log --oneline -10  # Find safe commit
git reset --hard <safe_commit_hash>
git push --force-with-lease
```

---

## PR Merge Protocol

1. ✅ All checklist items verified
2. ✅ CHANGELOG_DEV.md entry added
3. ✅ Scope matches DELEGATION_RULES.md
4. 🚀 Merge via squash commit
5. 🏷️ Tag if milestone reached

---

## Quick Reference

| If you changed... | Must verify... |
|-------------------|----------------|
| `lib/config/*.dart` | App launches, config values accessible |
| `lib/services/*.dart` | No import errors, methods callable |
| `lib/utils/*.dart` | Functions return expected values |
| `docs/*.md` | Markdown renders correctly |
| `assets/*` | Asset loads without error |

