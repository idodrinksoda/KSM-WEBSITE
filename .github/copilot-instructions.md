# Copilot instructions for KSM-WEBSITE

Use these project-specific rules to be productive immediately. Keep changes minimal and stick to the current static-site approach (no build tools).

## Big picture
- Static site: `index.html` + `styles.css` + optional `script.js` + assets in `assets/`.
- Deployed via GitHub Pages with custom domain (`CNAME` → kamasutramurder.com). Keep `CNAME` at repo root.
- No build, bundler, or framework; ship plain HTML/CSS/JS.

## Architecture and patterns
- Sections in `index.html`: hero, `#music` (Bandcamp + platform icons), `#shows` (card grid), `#videos` (YouTube), socials, footer, Mailchimp modal.
- Styling uses CSS tokens in `:root` (e.g., `--bg`, `--fg`, `--accent`). Reuse existing utilities: `.container`, `.card`, `.platform-icons`, `.btn`, `.cta`.
- Hero background comes from `assets/hero.jpg` via `.hero.has-image::before`.
- Inline JS in `index.html` is the source of truth (modal + year + smooth scroll). `script.js` exists but is currently not referenced by `index.html` and may contain legacy helpers.

## Developer workflow
- Local preview: serve statically (any simple HTTP server). No build step.
- Deployment: commit to `main`; Pages will serve root. Do not remove/rename `CNAME`.
- Asset paths are relative (e.g., `assets/KW.jpg`). Optimize images offline; keep widths appropriate for layout.

## Shows section pattern
- Add shows by appending an `article.show-card` inside `#shows .shows-grid` following the existing structure:
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

## Music and platforms
- Bandcamp embed lives in `#music .bandcamp-embed` with fixed dimensions; keep CSS selectors.
- Streaming icons: use `.platform-icons` with external icons from Simple Icons CDN (e.g., `https://cdn.simpleicons.org/spotify/1DB954`). Provide `aria-label` and `data-tooltip` for tooltips.

## Video embeds
- Use `youtube-nocookie` iframe inside `.video-embed`. Keep `allow` attributes and `loading="lazy"`.

## Mailchimp modal (important)
- Modal markup is in `index.html` with id `mcModal`; buttons with `[data-open-mc]` open it; `[data-close-mc]` or backdrop closes it; Escape key supported.
- Keep the “-modal” suffix for email input and response ids (e.g., `mce-EMAIL-modal`, `mce-success-response-modal`). JS observes success text and auto-closes after 1.5s—preserve ids if changing copy.
- Do not alter the `action` URL structure unless updating the list in Mailchimp.

## JavaScript conventions
- Prefer keeping small scripts inline at the end of `index.html` for this site. If extracting to `script.js`, add `<script src="script.js" defer></script>` before `</body>` and preserve selectors and behavior (`openMcModal()`, `closeMcModal()`).

## SEO/metadata
- Update `<title>` and meta description in `index.html` as needed.
- JSON-LD placeholder for `MusicRecording` exists in `<head>`; update fields (`name`, `datePublished`, `image`, `url`) for releases.

## Accessibility and UX
- Always provide meaningful `alt` on posters; keep `aria-*` labels on platform links.
- Use `target="_blank" rel="noopener"` for external links.

## When adding features
- Stay framework-free; reuse tokens/utilities; keep section ids stable for anchors.
- Favor lazy, responsive media; keep tooltips and icon sizing consistent with `.platform-icons` rules.
