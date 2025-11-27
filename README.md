# KSM-WEBSITE

Static website for Kama Sutra Murder. Framework-free: plain HTML, CSS, and a touch of JS. Deployed via GitHub Pages with a custom domain.

## Project structure
- `index.html` — Main page with all sections, inline JS for modal/year/scroll.
- `styles.css` — Global styles, CSS tokens in `:root`, utilities, embeds, modal.
- `script.js` — Legacy helpers (not referenced by `index.html`).
- `assets/` — Images and icons (e.g., `hero.jpg`, `KW.jpg`, `assets/icons/`).
- `CNAME` — Custom domain mapping to `kamasutramurder.com` (do not remove).

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
- Hero: background image from `assets/hero.jpg` (see `.hero.has-image::before`).
- Music: Bandcamp embed + streaming icons (`.platform-icons` use Simple Icons CDN).
- Shows: cards inside `#shows .shows-grid`.
- Videos: `youtube-nocookie` iframe inside `.video-embed`.
- Mailchimp modal: `#mcModal` with `[data-open-mc]` and `[data-close-mc]` controls.

### Add a show
Append an `article.show-card` to `#shows .shows-grid`:

```html
<article class="show-card" aria-labelledby="show-id">
  <figure class="show-media">
    <a href="https://tickets.example" target="_blank" rel="noopener">
      <img src="assets/poster.jpg" alt="Poster — Event" loading="lazy" width="400" height="600">
    </a>
  </figure>
  <div class="show-meta">
    <time datetime="YYYY-MM-DD" id="show-id">Mon DD, YYYY</time>
    <span>Venue – City, ST</span>
    <span>Doors X · Show Y · 19+</span>
  </div>
  <div class="show-actions">
    <a class="btn-tickets" href="https://tickets.example" target="_blank" rel="noopener">Tickets</a>
    <a class="btn-map btn" href="https://maps.example" target="_blank" rel="noopener">Map</a>
  </div>
</article>
```

### Music: Bandcamp + platforms
- Update the Bandcamp iframe `src` in `#music .bandcamp-embed` with the correct track/album id.
- Update `.platform-icons` links. Use Simple Icons CDN, e.g., `https://cdn.simpleicons.org/spotify/1DB954`. Keep `aria-label` and `data-tooltip`.

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
  "image": "assets/single-cover-og.jpg",
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
  "image": "assets/smile-thru-og.jpg",
  "url": "https://kamasutramurder.bandcamp.com/track/smile-thru"
}
```

Optional (multiple releases): use `@graph` with an array of items — list the latest first.

```json
{
  "@context": "https://schema.org",
  "@graph": [
    { "@type": "MusicRecording", "name": "New Single", "byArtist": {"@type": "MusicGroup", "name": "Kama Sutra Murder"}, "datePublished": "2025-12-06", "image": "assets/new-single-og.jpg", "url": "https://…" },
    { "@type": "MusicRecording", "name": "Previous Single", "byArtist": {"@type": "MusicGroup", "name": "Kama Sutra Murder"}, "datePublished": "2025-11-15", "image": "assets/prev-single-og.jpg", "url": "https://…" }
  ]
}
```

Tips
- Keep filenames lowercased and hyphenated (e.g., `smile-thru-og.jpg`).
- Reuse the existing `byArtist` block; only update fields that change per release.
- Validate JSON (e.g., copy into a linter) and test with Google’s Rich Results Test.

## Accessibility
- Provide meaningful `alt` on posters; keep `aria-label` and `rel="noopener"` for external links.

## Notes
- Keep things framework-free and lightweight. If you introduce JS beyond the modal/year, prefer inline scripts at the end of `index.html`.
