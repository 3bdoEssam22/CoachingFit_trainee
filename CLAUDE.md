# CoachingFit — Trainee App (Flutter)

## Status: scaffold only

This is a fresh `flutter create` scaffold. No application code yet. The repo, branches,
and remote are set up so we can start building incrementally.

- Repo: `github.com/3bdoEssam22/CoachingFit_trainee`
- Branches: `main` ← `Development` ← `feature/trainee-mvp` (active work happens on feature)
- Initial commit: just the platform scaffolds (Android, iOS, web, windows, macos, linux)

When you start building features, **mirror the Coach App's structure** — that codebase
is fresh, proven against the same backend, and uses the same packages. Cloning its
architecture verbatim (then renaming "coach" → "trainee") is the fastest path.

---

## Build it like the Coach App

The Coach App lives at `../../Coach App/coaching_fit_coach/` (relative to this folder).
Read its `CLAUDE.md` first — it has the full pattern.

### Same packages
- `flutter_bloc` + `equatable` for state (Cubit pattern, not Bloc)
- `dio` for HTTP, with an interceptor that:
  - Adds `Authorization: Bearer <token>` from `flutter_secure_storage`
  - On 401, clears storage and forces `/login`
- `go_router` for declarative routing with auth guards
- `get_it` as the service locator
- `flutter_secure_storage` for the JWT + user fields
- `google_fonts` (Syne for headings, DM Sans for body)
- `image_picker` for profile photo
- `intl` for date formatting

### Same architecture
```
lib/
├── core/                        — constants, theme, dio setup, secure storage wrapper, router
├── data/                        — models, datasources (Dio calls), repositories
├── domain/                      — entities, repository interfaces
├── presentation/                — Cubits + pages + widgets per feature
└── main.dart                    — runs the app, sets up GetIt
```

Feature-first inside `presentation/` (e.g. `presentation/auth/`, `presentation/profile/`),
NOT layer-first. The Coach App proves this scales fine for our size.

---

## Cross-stack contract — what already exists on the backend

The Identity and User services were built generic and already support trainees.
Endpoints the Trainee App will need:

| Method | Route | Purpose |
|---|---|---|
| POST | `/api/Auth/register/trainee` | Register a trainee account |
| GET  | `/api/Auth/confirm-email?userId=&token=` | Email confirmation link target |
| POST | `/api/Auth/resend-confirmation` | Resend the email |
| POST | `/api/Auth/login` | Login (returns AuthResponse) |
| POST | `/api/Auth/refresh` | Single-use refresh-token rotation |
| POST | `/api/Auth/revoke` | Logout server-side |
| GET  | `/api/TraineeProfile/me` | Get my profile (404 if not created) |
| POST | `/api/TraineeProfile` | Create profile (multipart with photo) |
| PUT  | `/api/TraineeProfile/me` | Update profile |

**No `IsActive` gating for trainees.** Trainees are `IsActive = true` by default
(unlike coaches, who need admin approval). The pending-approval flow does NOT
apply here.

**Idempotency-Key required on:** `POST /api/Auth/register/trainee`, `POST /api/Auth/refresh`,
`POST /api/TraineeProfile`. Generate a UUID per logical action and reuse it on retries.
See Coach App's Dio setup for the exact pattern.

---

## MVP scope (first iteration)

1. Splash → routing decision based on stored auth state
2. Register trainee + confirm-email handoff (open email link → backend redirects → app deep-link or polling)
3. Login (with refresh-token rotation)
4. Create trainee profile (gender, DOB, weight, height, fitness level, goals, optional medical notes, photo)
5. Stub `/home` screen — placeholder card "Coming soon: browse coaches"
6. Logout

**Out of scope for MVP:** browsing coaches, requesting sessions, payments, chat.
Those need backend services (Catalog/Order/Chat) that don't exist yet.

---

## Gateway URL

Same as the Coach App: `Api:BaseUrl = "http://10.0.2.2:5000"` for Android emulator,
`"http://localhost:5000"` for iOS simulator, `"http://<host-LAN-IP>:5000"` for a
physical device on the same WiFi. The gateway is the **only** entry point — never
call Identity or User services directly.

---

## Don'ts

- Don't reinvent patterns the Coach App already established. Copy them.
- Don't add new top-level dependencies without checking the Coach App uses the same one.
- Don't hardcode `http://localhost:5000` anywhere outside `core/constants/`.
- Don't store the JWT outside `flutter_secure_storage`.
- Don't ship a feature that depends on backend services not yet built (Catalog, Chat, etc.).

---

## When in doubt

Read the **Coach App CLAUDE.md** — most decisions there apply here too. The
backend's CLAUDE.md describes the auth flow and refresh-token rules; both apply
identically to trainees.
