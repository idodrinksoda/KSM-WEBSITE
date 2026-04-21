# Dev Branch — Pending Changes

Everything below is on `dev` and has **not** been merged to `main`.

---

## Discography Section Overhaul

- JS-driven release system — add new releases by appending to the `releases` array in the inline script in `index.html`
- Featured release displayed at top with Bandcamp embed + platform icons
- Clicking any previous tile swaps it into the featured slot
- "New Song!" glitch badge on index 0 (newest release)
- Previous releases grid capped at **6 tiles on desktop**, **2 tiles on mobile**
- "Show more" / "Show less" toggle button for overflow tiles
- Auto-collapses back to default cap when a tile is clicked
- 8 placeholder entries (Release 3–10) added for layout testing — **remove before going live**
- SYKE placeholder entry — swap `embedSrc` and platform links when SYKE releases

---

## Mobile Nav — Hamburger Menu

- On mobile (`≤ 640px`) the sticky nav only shows **Shows** and **Discography**
- A hamburger (`☰`) button sits inline to the right of Discography
- Tapping opens a dropdown with: **Videos**, **Gallery**, **Press**, **Contact**, **Mailing List**
- Tapping "Mailing List" opens the signup modal
- Tapping a link or anywhere outside closes the dropdown
- Hamburger is hidden on desktop — all four nav links remain visible as normal

---

## Mailing List Toast

- Slides up from the bottom **5 seconds** after page load
- Shows: *"Get notified when new music drops."* + **Sign up** button (with animated ↓ arrows) + **×** dismiss
- **Sign up** → opens the Mailchimp modal → sets `ksm_toast_signedup` in `localStorage` → **never shows again**
- **×** or auto-dismiss (after 10s) → sets `ksm_toast_snoozed` with a 3-day expiry → shows again after 3 days
- Uses the existing Mailchimp form action — no new integrations needed
- To test locally: delete `ksm_toast_signedup` and `ksm_toast_snoozed` from DevTools → Application → Local Storage

---

## Notes for Going Live

1. Remove the 8 test placeholder releases (Release 3–10) from the `releases` array
2. Update the SYKE placeholder with real Bandcamp embed URL and platform links once it releases
3. Update toast copy to match current release when going live (e.g. *"SYKE is out now — join the list for what's next"*)
