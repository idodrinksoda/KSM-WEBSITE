# TASKS — KSM-WEBSITE

Track features, fixes, and content updates here. Update this file at the start and end of every Claude session.

**Format:**
- `[ ]` pending · `[~]` in progress · `[x]` done · `[-]` cancelled

---

## 🔥 Active

<!-- Move items here when actively working on them -->

---

## 📋 Backlog

### Content
- [ ] Verify all current show cards are up to date
- [ ] Archive past show posters: move from `ksm-shows/current-shows/` → `ksm-shows/previous-shows/` on Cloudinary
- [ ] Update JSON-LD in `<head>` for latest release

### Code / Tech
- [ ] Decide fate of `script.js` — delete or integrate into `index.html`
- [ ] Review `sitemap.xml` for accuracy

### Design / UX
- [ ] (Add ideas here)

### SEO / Meta
- [ ] Verify Open Graph tags and Twitter card meta are correct
- [ ] Test JSON-LD with Google Rich Results Test

---

## ✅ Done

- [x] Set up CLAUDE.md with full project context
- [x] Set up TASKS.md
- [x] Move design brief to `docs/design-brief.md`
- [x] Document git branching workflow

---

## Notes

- Deployment is automatic on push/merge to `main` via GitHub Pages
- Cloudinary cloud: `dgxgi8bga`; use `f_auto,q_auto` on all image URLs
- Always run `./scripts/audit-assets.sh` before committing asset changes
