# Changelog

## [Unreleased]

### Added
- File changelog ini
- `projects.json` — single source of truth untuk project metadata
- Dashboard dual-mode (Articles / Projects) — tab system di sidebar, masing-masing punya form sendiri
- Project editor di dashboard (category dropdown, thumbnail URL, body)
- Hero image support: field **Thumbnail URL** di dashboard buat article & project, otomatis jadi gambar hero di halaman
- `article.html` support `img:` inline images (sama kaya project viewer)
- How to Add Images — tutorial lengkap di help modal
- `site-content.json` — single source of truth buat SEMUA teks di homepage
- Dashboard Content tab — edit semua teks homepage dari dashboard (Hero, About, Services, Experience, Interests, Showcase, Articles, Footer)
- `index.html` — `data-content` attribute + fetch `site-content.json` pas loading

### Changed
- `index.html` showcase section — dari hardcoded jadi fetch `projects.json`
- `showcase.html` — dari hardcoded array jadi fetch `projects.json`
- `sendmessage.html` help modal — restructure dengan section Articles, Projects, Images, Delete
- About Me deskripsi — update ke versi final: "9+ years leading F&B ops..." + closing "The function matters. The result matters more."

## [v1.0] - 2026-07

### Added
- Landing page dengan dark theme (`--background: #0e0e0e`, `--accent: #e83d2a`)
- Font stack: Bricolage Grotesque (display), DM Sans (body)
- Sidebar navigasi dengan link social (Instagram, LinkedIn)
- Scroll reveal efek fade-in + slide-up (IntersectionObserver + `.reveal`/`.visible`)
- Hero section dengan tagline "Not trying to impress"
- About Me section
- What I Do section (service cards)
- Interest section dengan photo grid + grayscale hover effect
- Experience section (render from JS data array, company logos)
- Showcase/Portfolio gallery dengan clickable cards
- Articles section (fetch dari `articles.json`, show latest 3)
- Article viewer (`article.html`) — load `.txt` via `?slug=`
- Article listing page (`articles.html`) — filter by year/month/tag
- Project detail page (`project.html`) — load `.txt` via `?slug=`, support inline images
- Dashboard (`sendmessage.html`) — prank login (passkey: `qqqq`) + article composer
- Experiences page (`experiences.html`) — work history detail dengan company logos
- SEO: meta tags, sitemap.xml, robots.txt, json-ld, lang=id
- Clock footer: `🇮🇩 WIB+7 | hh:mm:ss` (24h, Asia/Jakarta)
- Logo hover effect: grayscale(100%) → grayscale(0) + opacity 0.7 → 1

### Changed
- Semua section width diseragamkan ke **896px** (hero-body: 480px)
- Semua format tanggal ke **DD/MMM/YYYY** (e.g. `13/Jul/2026`)
- `articles.json` sebagai single source of truth untuk metadata artikel
- Penggantian placeholder logo → custom brand icons → JPG user-provided
- `dashboardpage.html` rename ke `sendmessage.html`
- Layout horizontal scroll → vertical scroll per section
- Hero font size dikecilkan
- Navbar transparan → sidebar
- Berbagai penyesuaian UI/UX (button style, tag dropdown, preview panel, dll)

### Files
- `index.html` — homepage utama
- `article.html` — viewer artikel
- `articles.html` — daftar artikel dengan filter
- `project.html` — viewer project detail
- `showcase.html` — gallery portfolio
- `experiences.html` — riwayat kerja
- `sendmessage.html` — dashboard composer
- `articles.json` — metadata artikel
- `articles/*.txt` — konten artikel
- `projects/*.txt` — konten project detail
- `logos/*.jpg` — company logo images
- `images/home.jpg` — profile photo
