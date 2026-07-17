# KSM-WEBSITE

Static website for Kama Sutra Murder. Framework-free: plain HTML, CSS, and a touch of JS. Deployed via GitHub Pages with a custom domain.

## Project structure
- `index.html` — Main page with all sections, inline JS (shows carousel, tape decor, music releases, gallery, modal).
- `styles.css` — Base styles, CSS tokens in `:root`, utilities, embeds, modal, tape/video-backdrop plumbing.
- `zine.css` — Punk/zine skin layer 1 (loaded after `styles.css`): display/mono typefaces, tilted cards, grain, poster framing.
- `zine-final.css` — Zine skin layer 2 (loaded last): stamp headings, sticker nav/buttons, handwritten annotations, poster wear, misregistration hover, About layout.
- `script.js` — Legacy helpers (not referenced by `index.html`).
- `scripts/sync-show-schema.js` — Regenerates MusicEvent JSON-LD from show cards (runs in pre-commit).
- `assets/` — Images and icons, organized by type:
  - `assets/gallery/` — manifest.json only; images served from Cloudinary
  - `assets/icons/` — favicon and app icons
  - Show posters: served from Cloudinary (`ksm-shows/current-shows/` and `ksm-shows/previous-shows/`) — no local copies.
- Hero image, gallery photos, show posters, tape cutouts (`ksm-site/tape/`), gallery video, and background texture are hosted on Cloudinary (cloud: dgxgi8bga).
- `CNAME` — Custom domain mapping to `kamasutramurder.com` (do not remove).

The three stylesheets are layered intentionally: `styles.css` is structure, the two `zine*.css` files are a visual skin. Cache-bust query params (`?v=N`) on all three `<link>` tags in `index.html` — bump them when shipping style changes.

## Local preview
Any static HTTP server works; no build step.

```bash
# Option A (Python 3)
python3 -m http.server 8000
# Option B (Node, if installed)
npx serve . -p 8000
```
Then open http://localhost:8000.

## Deploy
Push/merge to `main`. GitHub Pages serves the repo root with `CNAME` → `kamasutramurder.com`.

## Key sections and patterns
- Hero: background image served from Cloudinary via `.hero.has-image::before` in `styles.css`.
- Music: rendered by `initMusicSection()` from the `releases` array in `index.html` (see below).
- Shows: cards inside `#shows .shows-grid`; enter ISO dates (`YYYY-MM-DD`) in the `<time>` content/`datetime`, the inline JS formats them to `Sat Mar 21, 2026` in UTC. The soonest upcoming show is lifted into a featured slot above the scroller; past shows are auto-classified and dimmed.
- Tape decor: every show poster (and the About photo) is "taped to the wall" with cutouts of real tape photographed on paper, hosted at Cloudinary `ksm-site/tape/` (public IDs `ksm-tape-*`). `initTapeDecor()` in `index.html` places them deterministically per show (seeded by card id, stable across visits): the featured poster always gets 4 silver corners, a 2nd live show gets cream, further live shows get seed-picked distinct colors, past shows get 2-4 mixed pieces.
- Gallery: photo grid fetched from Cloudinary by tag (`gallery`), with a muted looping moshpit video backdrop behind the photos (`.gallery-bg-video`, edge-masked to fade into the page). The video is desktop/tablet-only — `initGalleryVideoBg()` removes the element under 640px or with reduced motion, so phones never download it.
- Videos: `youtube-nocookie` iframe inside `.video-embed`.
- Mailchimp modal: `#mcModal` with `[data-open-mc]` and `[data-close-mc]` controls (footer button + nav dropdown; there is intentionally no auto-popup).

### Add a show
Append an `article.show-card` to `#shows .shows-grid`:

```html
<article class="show-card" aria-labelledby="show-id">
  <figure class="show-media">
    <a href="https://tickets.example" target="_blank" rel="noopener">
      <img src="https://res.cloudinary.com/dgxgi8bga/image/upload/f_auto,q_auto,w_640/ksm-shows/current-shows/POSTER_PUBLIC_ID" alt="Poster — Event" loading="lazy" width="400" height="600">
    </a>
  </figure>
  <div class="show-meta">
    <time datetime="YYYY-MM-DD" id="show-id">YYYY-MM-DD</time>
    <span>Venue – City, ST</span>
    <span>Doors X · Show Y · 19+</span>
  </div>
  <div class="show-actions">
    <a class="btn-tickets" href="https://tickets.example" target="_blank" rel="noopener">Tickets</a>
    <a class="btn-map btn" href="https://maps.example" target="_blank" rel="noopener">Map</a>
  </div>
</article>
```

### Music: add a release
The Discography section renders from the `releases` array at the top of `initMusicSection()` in `index.html` — don't edit the section markup by hand. To ship a new single, copy the commented `EXAMPLE` template in that array, fill in `title`, `embedSrc` (Bandcamp track id), `art` (Cloudinary public ID), and platform URLs, and paste it as the first entry. With one release the layout is a single card; the moment a 2nd entry exists it auto-upgrades to featured + "Previous Releases" grid + "Listen now" badge. Platform icons use the Simple Icons CDN, e.g. `https://cdn.simpleicons.org/spotify/1DB954`.

## Mailchimp modal rules
- Modal id: `mcModal`. Input id: `mce-EMAIL-modal`. Response id: `mce-success-response-modal`.
- JS observes success text and auto-closes after ~1.5s — keep the id suffixes `-modal` intact.
- Do not change the form `action` unless the Mailchimp list changes.

## How to add a new release (JSON‑LD)
Structured data lives in the `<head>` of `index.html` as JSON‑LD. Update this for each new single/album so search engines and link previews get correct info.

1) Open `index.html` and find the block:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "MusicRecording",
  "name": "Debut Single",
  "byArtist": { "@type": "MusicGroup", "name": "Kama Sutra Murder" },
  "datePublished": "2025-11-15",
  "inAlbum": { "@type": "MusicAlbum", "name": "Single" },
  "image": "https://res.cloudinary.com/dgxgi8bga/image/upload/f_auto,q_auto,w_1200/hero_tot2cm",
  "url": "/"
}
</script>
```

2) Update the fields for the new release:
- `name`: Release title (track or album name).
- `datePublished`: YYYY-MM-DD release date.
- `image`: Path to an OG image (store under `assets/`, ~1200×630 ideal).
- `url`: Canonical URL for the release (Bandcamp/Spotify page or site page).
- If it’s part of an album, keep `inAlbum` with `@type: MusicAlbum` and set its `name`.

3) Singles vs albums (choose one):
- Single: keep `@type: MusicRecording` with `inAlbum` pointing to a single/EP as needed.
- Album: switch to `@type: MusicAlbum` and include `byArtist`, `datePublished`, `image`, and an optional `track` list.

Example (single):

```json
{
  "@context": "https://schema.org",
  "@type": "MusicRecording",
  "name": "Smile-Thru",
  "byArtist": { "@type": "MusicGroup", "name": "Kama Sutra Murder" },
  "datePublished": "2025-12-06",
  "inAlbum": { "@type": "MusicAlbum", "name": "Single" },
  "image": "https://res.cloudinary.com/dgxgi8bga/image/upload/f_auto,q_auto,w_1200/hero_tot2cm",
  "url": "https://kamasutramurder.bandcamp.com/track/smile-thru"
}
```

Optional (multiple releases): use `@graph` with an array of items — list the latest first.

```json
{
  "@context": "https://schema.org",
  "@graph": [
    { "@type": "MusicRecording", "name": "New Single", "byArtist": {"@type": "MusicGroup", "name": "Kama Sutra Murder"}, "datePublished": "2025-12-06", "image": "https://res.cloudinary.com/dgxgi8bga/image/upload/f_auto,q_auto,w_1200/hero_tot2cm", "url": "https://…" },
    { "@type": "MusicRecording", "name": "Previous Single", "byArtist": {"@type": "MusicGroup", "name": "Kama Sutra Murder"}, "datePublished": "2025-11-15", "image": "https://res.cloudinary.com/dgxgi8bga/image/upload/f_auto,q_auto,w_1200/hero_tot2cm", "url": "https://…" }
  ]
}
```

## Asset conventions
- Keep filenames lowercased and hyphenated (e.g., `smile-thru-og.jpg`).
- Show poster images are hosted on Cloudinary (cloud: dgxgi8bga, folder: `ksm-shows/`). Active shows go in `ksm-shows/current-shows/`, expired in `ksm-shows/previous-shows/`. Upload the highest-quality source file; Cloudinary handles format (`f_auto`) and resize (`w_640`) via URL params.
- Gallery images are hosted on Cloudinary (cloud: dgxgi8bga, tag: gallery). Upload new images to the KSM-Gallery folder with the ksm-gallery-auto preset to auto-tag and serve them.
- Avoid spaces in new filenames; prefer kebab-case.

Tips
- Reuse the existing `byArtist` block; only update fields that change per release.
- Validate JSON (e.g., copy into a linter) and test with Google’s Rich Results Test.

## Accessibility
- Provide meaningful `alt` on posters; keep `aria-label` and `rel="noopener"` for external links.

## Notes
- Keep things framework-free and lightweight. If you introduce JS beyond the modal/year, prefer inline scripts at the end of `index.html`.

## Asset quality checks
The repo includes a lightweight asset audit and pre-commit guard.

- `scripts/audit-assets.sh`
  - Verifies all `assets/...` references in repo text files resolve to real files.
  - Optional checks for spaces in staged asset paths or all asset filenames.

- `.githooks/pre-commit`
  - Runs the audit before each commit.
  - Blocks commit if staged asset paths contain spaces.

- GitHub Actions workflow: `.github/workflows/asset-audit.yml`
  - Runs on pull requests and manually via workflow dispatch.
  - Enforces missing-reference checks in CI.
  - Fails PRs that introduce new `assets/` paths containing spaces.

### One-time setup

```bash
./scripts/install-githooks.sh
```

### Run manually

```bash
./scripts/audit-assets.sh
./scripts/audit-assets.sh --missing-only
./scripts/audit-assets.sh --spaces-only
./scripts/audit-assets.sh --spaces-all
```
