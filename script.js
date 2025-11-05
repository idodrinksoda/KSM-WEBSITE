// Smooth scroll to the contact form when CTA is clicked
const joinBtn = document.getElementById('joinList');
joinBtn?.addEventListener('click', () => {
  document.getElementById('contact')?.scrollIntoView({ behavior: 'smooth' });
});

// Basic contact form UX (works with Formspree or shows a friendly error)
const form = document.getElementById('contactForm');
const statusEl = document.getElementById('formStatus');
form?.addEventListener('submit', async (e) => {
  e.preventDefault();
  statusEl.textContent = 'Sending…';
  try {
    const res = await fetch(form.action, {
      method: 'POST',
      body: new FormData(form),
      headers: { 'Accept': 'application/json' }
    });
    if (res.ok) {
      statusEl && (statusEl.textContent = "Thanks! We'll get back to you.");
      form.reset();
    } else {
      statusEl && (statusEl.textContent = 'Something went wrong. Try again or email us directly.');
    }
  } catch {
    statusEl && (statusEl.textContent = 'Network error. Please try again later.');
  }
});

// Update footer year automatically
const yearEl = document.getElementById('year');
yearEl && (yearEl.textContent = new Date().getFullYear());
