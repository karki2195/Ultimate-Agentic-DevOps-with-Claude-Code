# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**DMI Portfolio Website** — A static HTML/CSS portfolio site used in the **DevOps Micro Internship (DMI)** Week 1 curriculum. Students deploy this on an Ubuntu VM with Nginx to practice Linux fundamentals, web server configuration, and production-style deployments.

This is an educational artifact, not a production application. It serves as a hands-on learning tool for DevOps basics.

Will be deployed  to AWS using s3 and cloudfront , provisioned with terraform.

## Project Structure

```
├── index.html          (613 lines) — Main portfolio page (About, Services, Books, Courses, Contact)
├── style.css           (1145 lines) — All styling; mobile-first responsive design
├── privacy.html        (202 lines) — Privacy policy page
├── terms.html          (217 lines) — Terms of service page
└── images/             — Static assets (logo, profile photos, icons)
```

## Key Technical Details

### HTML/CSS Architecture
- **Pure HTML5 + CSS3** — No JavaScript, no build tools, no dependencies
- **Responsive design** — Desktop-first with breakpoints at 900px, 768px, 600px
- **Mobile menu** — Hamburger toggle for smaller screens
- **Icon library** — Font Awesome 6.5.0 loaded via CDN (https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css)
- **Smooth scrolling** — CSS scroll-behavior enabled on all elements

### Styling Structure (style.css)
- Global reset at top (* selector)
- Navbar styles (sticky positioning, responsive menu toggle)
- Section-based styles (hero, about, services, courses, books, community, contact)
- Footer with ownership proof placeholder
- Media queries for responsive breakpoints

## Important DMI Context

### Ownership Proof (Mandatory)
Students **must** add their deployment details to the footer before submission. The original footer:
```html
<p>Crafted with <span>cloud</span> excellence by Pravin Mishra</p>
```

Must be updated to include:
```html
<p><strong>Deployed by:</strong> [Student Name] | [Cohort] | [Week/Date]</p>
```

This proof must be **visually visible** in the browser when deployed — it's how DMI verifies assignment completion.

### Deployment Target
- **Host OS:** Ubuntu VM
- **Web server:** Nginx
- **Access:** Public IP of the VM
- **Requirements:** Keep site live for 24 hours after deployment
- **Proof method:** Browser screenshot showing the ownership footer

## Development Commands

```bash
# Local preview (open in browser directly)
open index.html

# Nginx local testing (if installing Nginx locally)
sudo nginx -c $(pwd)/nginx.conf
# or serve with Python (quick local server)
python3 -m http.server 8000
```

## When Making Changes

- **Content updates:** Edit index.html directly
- **Styling updates:** Modify style.css (keep responsive breakpoints intact)
- **New pages:** Add as separate .html file (e.g., portfolio.html)
- **Images:** Place in images/ directory and update image paths in HTML
- **Footer customization:** Students must edit the footer in index.html with their own details before deployment

## Deployment Checklist (for DMI students or instructors)

1. ✅ Footer contains deployment owner's name and date
2. ✅ All links work (external links open in new tab with `target="_blank"`)
3. ✅ Images load correctly from images/ directory
4. ✅ Responsive design works on mobile (test hamburger menu)
5. ✅ Site accessible via public IP when hosted on Nginx
6. ✅ Screenshot proof with footer visible for submission

## Files That Should Not Be Modified

- `privacy.html` and `terms.html` are standalone pages — avoid breaking their inline styling
- Keep images/ directory structure intact for image paths to work
- Font Awesome CDN link should remain unchanged (external dependency)

## No Build Step Required

This project requires **no compilation, bundling, or build process**. Simply serve the files as-is with Nginx or any static file server. This simplicity is intentional—it's designed for beginners learning DevOps fundamentals, not frontend complexity.
