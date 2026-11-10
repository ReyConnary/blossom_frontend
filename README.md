# Blossom School — UI Mockup

Non-functional Flutter mockup covering Homepage, Pengajuan (Submission), and
Penugasan (Assignment). All data is static/in-memory — no database, no API
calls. Buttons that would mutate data (submit forms, mark complete, etc.)
are disabled on purpose, labeled where relevant.

## Structure
- `lib/main.dart` — app entry, theme
- `lib/pages/home_page.dart` — dashboard + navigation
- `lib/pages/submission_page.dart` — Pengajuan list + new-submission sheet (disabled form)
- `lib/pages/assignment_page.dart` — Penugasan list
- `lib/models/mock_models.dart` — mock data matching the finalized ERD fields
- `lib/widgets/status_badge.dart` — shared status pill widget

## Run
```
flutter pub get
flutter run
```

## Next steps (when DB is ready)
- Replace `mock_models.dart` static lists with API/DB-backed state (GetX
  controllers, per your stack notes — keep controller logic out of the view
  files as usual)
- Wire up the disabled buttons (Kirim Pengajuan, Mulai Kerjakan, Tandai
  Selesai) to actual FSM transition calls
- Add auth/session to replace the hardcoded "Silentium" placeholder on Home
