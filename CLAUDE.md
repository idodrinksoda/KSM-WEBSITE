# CLAUDE.md — KSM-WEBSITE

This file is loaded by Claude at the start of every session. Read it fully before making any changes.

---

## What this project is

Static band website for **Kama Sutra Murder** (kamasutramurder.com).
No build step, no framework — plain HTML, CSS, and a small amount of inline JS.
Deployed via **Cloudflare Pages**, connected to this GitHub repo — pushing/merging to `main` triggers an automatic build and deploy. DNS for kamasutramurder.com points at Cloudflare.

**Live URL:** https://kamasutramurder.com
**Deploy source:** Cloudflare Pages project, production branch `main`
**CNAME:** legacy GitHub Pages artifact (repo was on GitHub Pages before the Cloudflare switch). GitHub Pages is still separately enabled in repo settings and technically "built" from `main`, but DNS no longer points to it — Cloudflare is what actually serves the site. Leave the file in place unless GitHub Pages is formally disabled for this repo.

---

## Design philosophy

Bold, minimal, and immersive. Built to impress fans, labels, and booking agents.

- Mobile-first, dark theme
- Performance-first: lazy loading, minimal dependencies, fast load times
- Semantic HTML + accessibility (ARIA, alt text, `rel="noopener"`)
- Smooth but lightweight animations
- Strong typography and spacing
- Framework-free. If you add JS, keep it inline at the bottom of `index.html` unless it's substantial enough to warrant `script.js`.

---

## File map

```
KSM-WEBSITE/
├── index.html          # Single-page site — all sections live here
├── styles.css          # Global styles; CSS tokens in :root
├── script.js           # LEGACY — not referenced by index.html; do not delete yet
├── manifest.json       # PWA manifest
├── robots.txt
├── sitemap.xml
├── CNAME               # → kamasutramurder.com (DO NOT REMOVE)
├── assets/
│   ├── gallery/        # manifest.json only; all gallery images served from Cloudinary
│   ├── icons/          # favicon + PWA icons (favicon.ico, favicon-16/32.png, icon-192/512.png)
│   └── manifest.json   # (duplicate — check which is canonical)
├── scripts/
│   ├── audit-assets.sh         # Checks for broken asset references + space-in-filenames
│   └── install-githooks.sh     # One-time setup: installs pre-commit hook
├── .githooks/
│   └── pre-commit      # Blocks commits with space-in-filename assets
├── .github/
│   ├── copilot-instructions.md  # Mirrors key rules for GitHub Copilot
│   └── workflows/
│       └── asset-audit.yml      # CI: runs audit on PRs
├── docs/
│   └── design-brief.md  # Design goals and brand voice reference
├── CLAUDE.md            # ← you are here
├── TASKS.md             # Ongoing task tracker
└── README.md            # Human-readable setup and pattern docs
```

---

## Sections in index.html

| Section      | Selector                   | Notes |
|-------------|----------------------------|-------|
| Hero         | `.hero`                    | Background image via `.hero.has-image::before` in CSS; served from Cloudinary |
| Music        | `#music`                   | Bandcamp embed + `.platform-icons` (Simple Icons CDN) |
| Shows        | `#shows .shows-grid`       | `article.show-card` cards; dates in ISO format in `<time datetime="">` |
| Videos       | `#videos`                  | `youtube-nocookie` iframe inside `.video-embed` |
| Social       | footer / socials section   | External links with `aria-label` + `rel="noopener"` |
| Mailchimp    | `#mcModal`                 | Opened by `[data-open-mc]`, closed by `[data-close-mc]` or Escape |

---

## CSS tokens (defined in `:root`)

Reuse these — do not hardcode values:
- `--bg` — background color
- `--fg` — foreground/text color
- `--accent` — accent/highlight color

Reuse existing utility classes: `.container`, `.card`, `.platform-icons`, `.btn`, `.cta`

---

## Cloudinary

Cloud name: **dgxgi8bga**

| Asset type    | Cloudinary folder                         | URL pattern |
|--------------|-------------------------------------------|-------------|
| Hero image   | root (e.g., `hero_tot2cm`)                | `https://res.cloudinary.com/dgxgi8bga/image/upload/f_auto,q_auto,w_1200/hero_tot2cm` |
| Current shows | `ksm-shows/current-shows/`               | `f_auto,q_auto,w_640` |
| Past shows   | `ksm-shows/previous-shows/`              | `f_auto,q_auto,w_640` |
| Gallery      | `KSM-Gallery/` (tag: `gallery`)           | `f_auto,q_auto` |

Always use `f_auto` (format) and `q_auto` (quality). Add `w_` for size hints. Never hardcode `.jpg` or `.webp` in Cloudinary URLs.

---

## Common tasks

### Add a show
Append inside `#shows .shows-grid`:
```html
<article class="show-card" aria-labelledby="show-UNIQUE-ID">
  <figure class="show-media">
    <a href="TICKET_URL" target="_blank" rel="noopener">
      <img src="https://res.cloudinary.com/dgxgi8bga/image/upload/f_auto,q_auto,w_640/ksm-shows/current-shows/POSTER_PUBLIC_ID"
           alt="Poster — Venue, City" loading="lazy" width="400" height="600">
    </a>
  </figure>
  <div class="show-meta">
    <time datetime="YYYY-MM-DD" id="show-UNIQUE-ID">YYYY-MM-DD</time>
    <span>Venue – City, ST</span>
    <span>Doors X:00 · Show Y:00 · 19+</span>
  </div>
  <div class="show-actions">
    <a class="btn-tickets" href="TICKET_URL" target="_blank" rel="noopener">Tickets</a>
    <a class="btn-map btn" href="MAPS_URL" target="_blank" rel="noopener">Map</a>
  </div>
</article>
```
The inline JS auto-formats ISO dates to `Sat Mar 21, 2026` using UTC — just write `YYYY-MM-DD` in both `datetime` and the element content.

**MusicEvent JSON-LD is auto-generated.** `scripts/sync-show-schema.js` runs in the pre-commit hook and regenerates the `<!-- AUTO:SHOWS -->` block in `<head>` from upcoming `.show-card` markup (dates ≥ today only). Don't edit MusicEvent schema by hand — paste the card, commit, schema appears. CI re-runs the script with `--check` to catch drift.

If the venue is new, add it to the `VENUES` table at the top of `scripts/sync-show-schema.js` (needs address + Google Maps URL). The script errors loudly until you do.

Per-card overrides (optional):
- `data-show-start="19:00"` — non-default start time (default is 20:00 / 8 PM)

### Move a show to past
Move the Cloudinary asset: `ksm-shows/current-shows/` → `ksm-shows/previous-shows/`
Update the `src` URL in `index.html` accordingly. Or simply remove the card.

### Update music
- Bandcamp: update the iframe `src` in `#music .bandcamp-embed`
- Streaming links: update `.platform-icons` anchor hrefs; icon colors via Simple Icons CDN

### Add/update a release (JSON-LD)
Find the `<script type="application/ld+json">` block in `<head>` of `index.html`.
Update: `name`, `datePublished`, `image`, `url`. Use `@graph` array for multiple releases (latest first).

### Update hero image
Change the Cloudinary URL in `.hero.has-image::before` inside `styles.css`.

### Add gallery images
Upload to Cloudinary `KSM-Gallery/` with preset `ksm-gallery-auto` (auto-tags as `gallery`).
The inline gallery JS fetches by tag — no code change needed.

---

## Asset conventions

- Filenames: **lowercase kebab-case** (e.g., `smile-thru-og.jpg`) — no spaces, no uppercase
- Show posters: upload highest-quality source to Cloudinary; let `f_auto`/`w_640` handle delivery
- Local `assets/`: favicons and PWA icons only — no full-size images stored in the repo
- Pre-commit hook blocks assets with spaces in filenames (run `./scripts/install-githooks.sh` once)

---

## Git workflow

### Branches
| Branch | Purpose |
|--------|---------|
| `main` | **Production.** Cloudflare Pages auto-deploys this branch live. Merge only tested, reviewed changes. |
| `dev`  | Integration branch. Work here, then PR to `main`. |
| `feature/short-description` | New features (e.g., `feature/add-merch-section`) |
| `fix/short-description`     | Bug fixes (e.g., `fix/mobile-show-card-overflow`) |
| `content/short-description` | Content-only updates (e.g., `content/add-april-shows`) |

### Workflow
```
# Start new work
git checkout dev
git pull origin dev
git checkout -b content/add-may-shows

# Work, then commit
git add .
git commit -m "content: add May 2026 show cards"

# Open PR → dev, then dev → main when ready
```

### Commit message conventions
```
feat: add merch section with grid layout
fix: correct show date formatting on mobile
content: add May 2026 show cards
style: tighten hero section spacing on mobile
chore: update sitemap with new pages
docs: update CLAUDE.md with gallery workflow
```

### Never
- Push directly to `main` for anything beyond a 1-line hotfix
- Commit with spaces in asset filenames (pre-commit hook will block it)
- Remove or rename `CNAME`

---

## Local preview

No build step needed:
```bash
# Python
python3 -m http.server 8000

# Node
npx serve . -p 8000
```
Then open http://localhost:8000.

---

## What NOT to do

- **No frameworks.** No React, Vue, bundlers, or npm packages added to the repo.
- **No inline styles** unless there is a strong, documented reason.
- **No hardcoded hex values** in CSS — use the `:root` tokens.
- **No `script.js` references** added to `index.html` without testing; it contains legacy code.
- **No spaces in new filenames** — ever.
- **No changes to the Mailchimp form `action` URL** unless the list itself changes.
- **No removal of `-modal` id suffixes** on `mce-EMAIL-modal` / `mce-success-response-modal`.

---

## Accessibility checklist (for any change)

- [ ] Images have meaningful `alt` text
- [ ] External links have `rel="noopener"` and `target="_blank"`
- [ ] Interactive elements have `aria-label` where there's no visible text label
- [ ] Color contrast meets WCAG AA (use existing `--accent`/`--fg` tokens)

---

## CI / hooks

- **Pre-commit:** blocks commits with space-in-path assets (`./scripts/install-githooks.sh` to install)
- **GitHub Actions (`asset-audit.yml`):** runs on PRs — checks for broken `assets/` references and filenames with spaces
- **Run manually:** `./scripts/audit-assets.sh`
