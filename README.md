# Aya's Graphique — Portfolio Website (Flutter Web)

A dark, gallery-style portfolio site for **Aya's Graphique** (Illustrator &
Logo Designer), built in Flutter so it runs as a single codebase on web
(and, if you ever want it, mobile/desktop too).

The brand portrait used in the hero section is the artwork you uploaded,
with the surrounding circular logo text removed and the background kept —
so it reads as a clean illustrated profile photo rather than a logo lockup.

## What's inside

- **Hero** — full-bleed gradient backdrop, animated headline, and a
  floating 3D portrait with two counter-rotating dashed rings. The portrait
  tilts toward your cursor (perspective `Matrix4` transform).
- **About** — bio, skill chips, and a tilting stats card.
- **Work** — a filterable grid (All / Illustration / Logo design) of
  project tiles, each a `Tilt3DCard` that tilts in 3D toward the pointer on
  hover, with a lift + glow shadow.
- **Services** — three tilting capability cards.
- **Contact** — gradient call-to-action with a `mailto:` button and social
  link placeholders.
- **Scroll-reveal everywhere** — sections fade + rise into place the first
  time they scroll into view (`visibility_detector`).
- **Ambient animated background** — slow drifting blurred color orbs +
  particles behind the whole page (`CustomPainter`), running continuously.
- **Glass navbar** — frosted/blurred floating nav with an animated active
  underline, collapses to a bottom-sheet menu on mobile.

## Fonts

Loaded at runtime via `google_fonts` (no manual font files needed):

- **Bricolage Grotesque** — display/headline face (geometric, characterful)
- **Plus Jakarta Sans** — body copy
- **Space Grotesk** — small caps-style eyebrow labels / nav

## Color palette

Pulled directly from the brand artwork:

| Token        | Hex       | Source                  |
|--------------|-----------|--------------------------|
| `bgDeep`     | `#170B20` | near-black page canvas   |
| `bgPurple`   | `#4B225E` | artwork background       |
| `violetLight`| `#8B6BAE` | clothing highlight       |
| `crimson`    | `#ED1346` | hijab highlight          |
| `crimsonDeep`| `#B10637` | hijab shadow             |
| `gold`       | `#EDB945` | necklace                 |

## Running it

1. Install Flutter (3.22+): https://docs.flutter.dev/get-started/install
2. From this folder:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```
3. To build a deployable static site:
   ```bash
   flutter build web --release
   ```
   The output lands in `build/web/` — upload that folder to any static
   host (Netlify, Vercel, Firebase Hosting, GitHub Pages, etc.).

## Admin dashboard + Supabase backend

The site now has a lightweight admin dashboard at `/#/admin` for managing
the portfolio without touching code, backed by [Supabase](https://supabase.com)
(Postgres + Auth). It lets you:

- Add, edit, and delete portfolio projects (title, client, category, image URL)
- Read, mark read/unread, and delete messages sent through the contact form

The public site's "Selected Work" grid and the contact form's message
inbox are both wired to the same Supabase tables — no separate setup needed.

### 1. Create a Supabase project

Go to [supabase.com](https://supabase.com), create a free project, then open
**SQL Editor** and run everything in `supabase/schema.sql` (creates the
`projects` and `messages` tables, their Row Level Security policies, and a
few seed rows so the grid isn't empty on first load).

### 2. Connect the app

In **Project Settings → API**, copy the **Project URL** and **anon public**
key into `lib/config/supabase_config.dart`:

```dart
static const String url = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://your-project-ref.supabase.co',
);
static const String anonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: 'your-anon-key',
);
```

(Or pass them at build/run time instead of editing the file:
`flutter run -d chrome --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`)

The anon key is meant to be public in a client app — access is enforced
by the RLS policies in `schema.sql`, not by keeping this key secret.

### 3. Create your admin login

There's no public sign-up. In the Supabase dashboard, go to
**Authentication → Users → Add user**, set an email and password, and use
those to sign in at `/#/admin`.

### 4. Enable image uploads

The admin dashboard can upload artwork straight from your device. To turn
that on:

1. In the Supabase dashboard, go to **Storage → New bucket**
2. Name it `portfolio` and toggle **Public bucket** on
3. Run the "Storage" section at the bottom of `supabase/schema.sql` (also
   included if you already ran the whole file) — this lets signed-in admins
   upload/replace/delete files while everyone else can only view them

After that, the "Add project" / "Edit project" form in `/#/admin` has an
**Upload image from device** button that uploads the file and fills in its
public URL automatically. You can still paste a URL by hand instead if you
prefer (e.g. an image hosted elsewhere).

## Swapping in real project artwork

`lib/data/work_items.dart` currently uses colored gradient + icon
placeholders for each project tile (since no project images were
supplied). To use real artwork:

1. Drop image files into `assets/images/work/`.
2. Add the folder to `pubspec.yaml` under `flutter: assets:`.
3. In `lib/sections/portfolio_section.dart`, swap the gradient/icon
   `Container` inside `_WorkCard` for an `Image.asset(...)` — the
   `Tilt3DCard` 3D-hover behavior and layout stay exactly the same.

## Notes

- Update the email address and social links in
  `lib/sections/contact_section.dart`.
- Copy in `lib/sections/about_section.dart` is a starting draft — replace
  with Aya's own bio/voice.
- The 3D tilt effects respond to pointer position, so they're most visible
  on desktop/web with a mouse; touch devices get a graceful static layout.
