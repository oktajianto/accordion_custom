# Implementasi Plan — accordion_custom

Catatan perencanaan fitur plugin `accordion_custom` (pure-Dart, zero-dependency).
Status: ✅ selesai · 🔲 belum · 🕒 opsional/ide ke depan.

Terakhir diperbarui: 2026-08-22.

---

## 1. Inti (core)

- ✅ `AccordionCustom` slot-based (`children: [AccordionItem(...)]`)
- ✅ Constructor `AccordionCustom.builder(itemCount, itemBuilder)` (lazy dari data list)
- ✅ Enum `AccordionMode { single, multiple }`
- ✅ Widget internal `_AccordionPanel` (header + area konten beranimasi)
- ✅ Zero-dependency, jalan di semua platform Flutter

## 2. AccordionItem

- ✅ `header` (widget) **atau** `headerBuilder(context, isExpanded)` (assert salah satu)
- ✅ `content` (widget bebas, termasuk accordion lain)
- ✅ `initiallyExpanded` per item
- ✅ `enabled` per item (panel dimmed + abaikan tap)
- ✅ `semanticLabel` per item
- ✅ Override style per item: `headerStyle` / `contentStyle` (replace style level accordion)

## 3. Controller

- ✅ `AccordionController extends ChangeNotifier`
- ✅ `expand`, `collapse`, `toggle`
- ✅ `expandAll`, `collapseAll`
- ✅ `isExpanded(index)`, `expandedIndexes`
- ✅ Controller internal otomatis bila tidak disuplai; dispose yang dimiliki sendiri
- ✅ Sinkronisasi `itemCount` & `mode` + prune index stale
- 🔲 Identifikasi panel berbasis value/key `T` (saat ini berbasis index)
- 🕒 Callback `onExpansionChanged(index, isExpanded)` di level widget

## 4. Styling — AccordionHeaderStyle

- ✅ `backgroundColor`, `expandedBackgroundColor`
- ✅ `padding`
- ✅ `textStyle` (via DefaultTextStyle.merge)
- ✅ `borderColor` (fallback ke theme divider), `borderWidth`, `borderRadius`
- ✅ Ikon: `icon` custom, `iconColor`, `showIcon`, `iconPosition` (leading/trailing),
  `expandedIconTurns` (rotasi saat buka), `iconGap`
- ✅ `copyWith`

## 5. Styling — AccordionContentStyle

- ✅ `backgroundColor`
- ✅ `padding`
- ✅ `textStyle`
- ✅ Divider header/konten: `dividerColor`, `dividerWidth` (opt-in)
- ✅ `copyWith`

## 6. Layout & animasi

- ✅ `itemSpacing` (jarak antar panel)
- ✅ `animationDuration`, `animationCurve` (pakai `AnimatedSize` + `AnimatedRotation`)
- ✅ Nested accordion (konten berisi `AccordionCustom` lain)
- 🕒 Opsi tipe transisi lain (fade + size) / matikan animasi eksplisit
- 🕒 Auto scroll-to / `ensureVisible` saat panel dibuka

## 7. Aksesibilitas & input

- ✅ Navigasi keyboard ↑/↓ antar header (DirectionalFocusIntent)
- ✅ Enter/Space toggle (via InkWell focus)
- ✅ `Semantics` (button, expanded, enabled, label)
- ✅ `enableKeyboardNavigation` toggle
- 🕒 Uji & contoh RTL (EdgeInsetsDirectional sudah didukung)
- 🕒 Simpan state expanded via `PageStorage`

## 8. Kualitas & rilis

- ✅ Test widget/unit (8 test: single/multiple, controller, initiallyExpanded,
  disabled, per-item style override)
- ✅ Example gallery (semua fitur ada demonya)
- ✅ CI GitHub Actions (format, analyze, test, publish dry-run)
- ✅ README lengkap: penjelasan singkat + contoh kode tiap fitur
- ✅ GIF asli per fitur di `screenshots/` + section Preview (`all_preview.gif`)
- ✅ Halaman demo per-fitur di example (tombol → 1 fitur per layar, untuk screenshot)
- ✅ LICENSE (MIT), CHANGELOG (0.1.0), analysis_options, .gitignore/.pubignore
- ✅ Nama `accordion_custom` tersedia di pub.dev (dicek 404)
- ✅ Badge di README (pub, pub points, likes, stars, CI)
- ✅ Screenshot `thumbnail.png` untuk `screenshots:` di pubspec (thumbnail pub.dev)
- ✅ Arsip publish ramping (~66 KB): GIF dirujuk via URL raw GitHub + `.pubignore`
  hanya menyertakan `thumbnail.png`
- 🔲 Tag rilis `v0.1.0`
- 🔲 `flutter pub publish` (rilis pertama ke pub.dev)

## 9. Ide fitur ke depan (opsional)

- 🕒 `maxOpen` cap di mode multiple
- 🕒 Widget tambahan di header (badge/trailing action) tanpa headerBuilder penuh
- 🕒 Opsi divider full-width vs inset
- 🕒 Long-press / secondary action pada header
- 🕒 Tema global via `AccordionTheme` (InheritedWidget) agar tak perlu set style tiap kali
