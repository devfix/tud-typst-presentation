#import "@preview/touying:0.8.0": *
#import "colors.typ": *

#let tud-outer-margin = 17pt
#let tud-inner-margin = 50.5pt
#let tud-top-margin = 25pt  // 85pt
#let tud-bottom-margin = 65pt

#let tud-date-format = "[month repr:long] [day], [year]"

// Joins an author string or array of authors with " & ".
#let tud-join-authors(authors) = {
  if type(authors) == array {
    for k in range(0, authors.len()) {
      if k > 0 {
        [ & ]
      }
      authors.at(k)
    }
  } else {
    authors
  }
}

// Slide numbering with an "official"/"backup" split, analogous to Beamer's
// \appendix: every slide keeps its own running number, but the grand total
// shown in the footer freezes at the count reached when the appendix starts,
// so anything after that point (appendix, backup, spare slides) doesn't
// inflate "current / total".
//
// This is touying's built-in appendix mode. Use it as a show rule, once,
// between the last slide that should count towards the total and the first
// slide that shouldn't (e.g. right before your first backup slide):
//
//   #show: appendix
//
// `#show: last-official-slide` is kept as an alias for the same thing.
//
// Slides in the appendix show their own number in Roman numerals instead,
// starting at "I" with the first appendix slide and without a total.
#let last-official-slide(body) = appendix(body)

#let tud-guides = {
  set line(
    stroke: (thickness: .5pt,
    paint: red,
    dash: "densely-dotted"),
    length: 100%
  )
  place(line(start: (0cm, .8cm)))
  place(line(start: (0cm, 60pt)))
  place(line(start: (0cm, 2.92cm)))
  place(line(start: (0cm, 14.23cm)))
  place(line(start: (0cm, 14.933cm)))
  place(line(start: (0cm, 15.424cm)))
  place(line(start: (0cm, 16.22cm)))
  set line(angle: 90deg)
  place(line(start: (60.5pt, 0cm)))
  place(line(start: (790pt, 0cm)))
}

// The footer, as a function of touying's `self` so it can read the
// presentation info (title, author, ...) configured in tud-slides().
// `line` draws a line across the full width at the top of the footer:
// `none` for no line, or a stroke such as `0.5pt + tud-brilliant-blue`.
// The footer's background is `footer-background` given to tud-slides().
#let tud-footer(self, line: none) = {
  let background = self.store.at("footer-background", default: tud-white)
  let (fill, pattern) = if type(background) == content {
    (none, background)
  } else {
    (background, none)
  }
  block(width: 100%, height: 100%, fill: fill)[
  #if pattern != none {
    place(top + left, block(width: 100%, height: 100%, clip: true, pattern))
  }
  #if line != none {
    place(top + left, std.line(length: 100%, stroke: line))
  }
  #set text(size: 8pt,  fill: tud-brilliant-blue)
  #block(width: 100%, inset: (x: tud-outer-margin, top: 11pt), // devfix-edit for layout fix
    align(
      horizon,
      grid(
        columns: (auto, 10fr, 1fr),
        gutter: 50pt,
        pad(left: 18.5pt,
          image(
            "logo-blue/TUD_Logo_RGB_horizontal_blau_en.svg", width: 3.5cm
          ),
        ),
        {
          set block(above: .35em)
          [#self.info.short-title]
          parbreak()
          [#self.store.organizational-unit / ]
          tud-join-authors(self.store.short-author)
          parbreak()
          [#self.store.location-occasion \/\/ #self.info.date.display(tud-date-format)]
        },
        align(horizon + right)[
          #context {
            let current = utils.slide-counter.get().at(0)
            let total = utils.last-slide-counter.final().at(0)
            if self.at("appendix", default: false) {
              // Appendix: its own count in Roman numerals (I, II, III, ...),
              // without a total.
              numbering("I", current - total)
            } else {
              [#current / #total]
            }
          }
        ],
      )
    )
  )
]
}

// ---------------------------------------------------------------------------
// Backgrounds
// ---------------------------------------------------------------------------
//
// Every `background:` option (section-options, content-options,
// outline-options, section-slide) accepts either a fill (a color, gradient,
// or tiling) or any content, e.g. one of the patterns below:
//
//   = Motivation and Scope
//   #section-options(background: tud-split-pattern())

// Two-tone patterns from the TUD design (the sample slides in "slide.pdf").
// Each pattern is a plain area in one color with a few large shapes in a
// second color on top. The geometry is taken from the official slide design
// (960 x 540 pt) and given in % of the page, so it scales with the slide.
//   - variant:   which pattern (1-4, as in the sample slides):
//                  1: two triangles meeting left of the center (Rot 2 / Magenta 2)
//                  2: two slanted bands along the top and bottom edges
//                     (Violett 1 / Magenta 1)
//                  3: vertical split with a diagonal edge, colors swapped on
//                     either side (Violett 2 / Violett 1)
//                  4: two triangles pointing at the right third (Türkis 1 / Türkis 2)
//                Default: 3, the pattern this function drew before.
//   - primary:   color of the shapes (default: auto, the variant's color from
//                the sample)
//   - secondary: color of the remaining area (default: auto, the variant's
//                color from the sample)
#let tud-split-patterns = (
  // page 1
  (
    primary: tud-magenta-2,
    secondary: tud-red-2,
    shapes: (
      ((0%, 0%), (2.94%, 0%), (41.45%, 68.49%), (0%, 68.49%)),
      ((100%, 100%), (59.17%, 100%), (41.45%, 68.49%), (100%, 68.49%)),
    ),
  ),
  // page 2
  (
    primary: tud-magenta-1,
    secondary: tud-violet-1,
    shapes: (
      ((6.21%, 100%), (5.24%, 90.20%), (50.47%, 90.20%), (100%, 2.13%), (100%, 100%)),
      ((0%, 0%), (49.49%, 0%), (50.46%, 9.80%), (5.23%, 9.80%), (0%, 19.11%)),
    ),
  ),
  // page 3
  (
    primary: tud-violet-1,
    secondary: tud-violet-2,
    shapes: (
      ((51.01%, 0%), (51.01%, 59.74%), (0%, 75.72%), (0%, 0%)),
      ((51.01%, 100%), (51.01%, 59.74%), (100%, 44.38%), (100%, 100%)),
    ),
  ),
  // page 4
  (
    primary: tud-teal-2,
    secondary: tud-teal-1,
    shapes: (
      ((62.48%, 100%), (0%, 100%), (0%, 0%), (34.33%, 0%), (62.48%, 50.03%)),
      ((62.49%, 0%), (100%, 0%), (100%, 100%), (90.61%, 100%), (62.49%, 50.03%)),
    ),
  ),
)

#let tud-split-pattern(variant: 3, primary: auto, secondary: auto) = {
  assert(
    variant in range(1, tud-split-patterns.len() + 1),
    message: "tud-split-pattern: variant must be 1 to " + str(tud-split-patterns.len()),
  )
  let pattern = tud-split-patterns.at(variant - 1)
  let primary = if primary == auto { pattern.primary } else { primary }
  let secondary = if secondary == auto { pattern.secondary } else { secondary }
  place(rect(width: 100%, height: 100%, fill: secondary))
  for shape in pattern.shapes {
    place(polygon(fill: primary, ..shape))
  }
}

// Turns a `background:` option into page background content.
#let tud-page-background(background) = {
  if background == none {
    none
  } else if type(background) == content {
    background
  } else {
    rect(width: 100%, height: 100%, fill: background)
  }
}

// ---------------------------------------------------------------------------
// Section slides
// ---------------------------------------------------------------------------
//
// A section slide is created by a level-1 heading:
//
//   = Motivation and Scope
//   #section-options(background: rgb("#001450"))
//
// Put `#section-options(..)` directly after the heading (before the next
// slide). All arguments are optional:
//   - subtitle:   content shown below the title (default: none)
//   - background: slide background (default: `section-background` given to
//                 tud-slides, i.e. tud-darkblue unless changed there)
//   - outlined:   false keeps the section out of the outline and
//                 the PDF bookmarks, e.g. for a "Thank you" slide (default: true)
//   - title-fill:    color of the title (default: white)
//   - subtitle-fill: color of the subtitle (default: semi-transparent white)
//
// Any other content written after the heading is used as the subtitle, so
//
//   = Thank you for your time!
//   I will be happy to answer your questions now.
//
// is the same as passing it via `subtitle:`.

#let section-options(
  subtitle: auto,
  background: auto,
  outlined: auto,
  title-fill: auto,
  subtitle-fill: auto,
) = [#metadata((
  subtitle: subtitle,
  background: background,
  outlined: outlined,
  title-fill: title-fill,
  subtitle-fill: subtitle-fill,
)) <tud-section-options>]

#let tud-section-defaults = (
  title-fill: white,
  subtitle-fill: rgb(255, 255, 255, 150),
)

// Splits `body` into the options given via `#xyz-options(..)` (metadata
// with the given label, anywhere at the top level of `body`) and the
// remaining (visible) content, with leading/trailing whitespace removed.
#let tud-split-options(body, label, trim: true) = {
  let options = (:)
  let rest = ()
  let children = if body == none {
    ()
  } else if body.func() == [].func() {
    body.children
  } else {
    (body,)
  }
  for child in children {
    if child.func() == metadata and child.at("label", default: none) == label {
      for (key, value) in child.value {
        if value != auto { options.insert(key, value) }
      }
    } else {
      rest.push(child)
    }
  }
  // Drop leading/trailing whitespace so that an empty remainder is `none`.
  if not trim { return (options, rest.join()) }
  let blank(it) = it.func() in (parbreak, linebreak) or it == [ ]
  while rest.len() > 0 and blank(rest.first()) { let _ = rest.remove(0) }
  while rest.len() > 0 and blank(rest.last()) { let _ = rest.pop() }
  (options, if rest.len() > 0 { rest.join() } else { none })
}

// The visible part of a section slide; shared by the heading-based section
// slides and the explicit section-slide() function.
#let tud-section-slide-content(
  self,
  title,
  subtitle,
  background,
  heading: none,
  title-fill: tud-section-defaults.title-fill,
  subtitle-fill: tud-section-defaults.subtitle-fill,
) = {
  // Content block
  let wrapped-body = block(
    width: 100%,
    height: 100%,
    inset: (x: tud-inner-margin),
  )[
    #heading
    #set align(horizon)
    #set text(2.5em, fill: white)
    #set block(above: .5em)
    #text(weight: "bold", fill: title-fill, title)
    #parbreak()
    #text(fill: subtitle-fill, subtitle)
  ]

  self = utils.merge-dicts(self, config-page(
    margin: (
      top: tud-top-margin,
      bottom: tud-bottom-margin,
      x: 0pt,
    ),
    footer: tud-footer,
    footer-descent: 0pt,
    background: tud-page-background(background),
  ))
  touying-slide(self: self, wrapped-body)
}

// Called by touying for every `= Heading`; `body` is the content between the
// heading and the next slide.
#let tud-new-section-slide(body) = touying-slide-wrapper(self => {
  let (options, rest) = tud-split-options(body, <tud-section-options>)
  let section = self.headings.rev().find(it => it.depth == 1)
  let unoutlined-label = section.has("label") and str(section.label) in (
    "touying:hidden",
    "touying:unoutlined",
  )
  let outlined = options.at("outlined", default: not unoutlined-label)
  let subtitle = options.at("subtitle", default: rest)
  let background = options.at("background", default: self.store.section-background)

  // touying places the heading (invisibly) on this slide; that is what the
  // outline / agenda picks up. All other headings are excluded from the
  // outline by tud-slides(), so mark this one explicitly.
  self.headings = self.headings.map(it => if it.depth == 1 {
    std.heading(level: 1, outlined: outlined, it.body)
  } else {
    it
  })

  let options = tud-section-defaults + options
  tud-section-slide-content(
    self,
    section.body,
    subtitle,
    background,
    title-fill: options.title-fill,
    subtitle-fill: options.subtitle-fill,
  )
})

// Explicit variant, kept for compatibility: creates the same slide as a
// heading would, without starting a touying section.
#let section-slide(
  title: none,
  subtitle: none,
  outlined: true,
  background: auto,
  title-fill: tud-section-defaults.title-fill,
  subtitle-fill: tud-section-defaults.subtitle-fill,
) = touying-slide-wrapper(self => {
  let background = if background == auto { self.store.section-background } else { background }
  // A heading that carries the title into the document's outline without
  // rendering anything itself.
  let hidden-heading = if title != none and outlined {
    show std.heading: none
    std.heading(title, level: 1, outlined: true)
  }
  tud-section-slide-content(
    self,
    title,
    subtitle,
    background,
    heading: hidden-heading,
    title-fill: title-fill,
    subtitle-fill: subtitle-fill,
  )
})

// ---------------------------------------------------------------------------
// Outline (agenda) slides
// ---------------------------------------------------------------------------
//
// A plain `#outline(..)` written between slides becomes an agenda slide
// listing the sections (`= Heading`), each linking to its slide:
//
//   #outline(depth: 1, title: text(fill: tud-blue-1)[Agenda])
//   #outline-options(background: tud-blue-2)
//
// All of outline()'s own arguments work as usual (`title`, `depth`, `indent`,
// `target`, ...). `title: auto` shows "Agenda", `title: none` shows no title.
//
// Put `#outline-options(..)` directly before or after the outline (before
// the next slide). All arguments are optional:
//   - background: slide background (default: none, i.e. white)
//   - text-fill:  text color of the whole slide (default: black)
//   - text-size:  text size of the entries (default: 20pt)
//   - top-space:  vertical space above the title (default: 3cm)
//   - footer:     false hides the footer (default: true)
//   - title-fill: color of the title (default: auto, i.e. text-fill)

#let outline-options(
  background: auto,
  text-fill: auto,
  text-size: auto,
  top-space: auto,
  footer: auto,
  title-fill: auto,
) = [#metadata((
  background: background,
  text-fill: text-fill,
  text-size: text-size,
  top-space: top-space,
  footer: footer,
  title-fill: title-fill,
)) <tud-outline-options>]

#let tud-outline-defaults = (
  background: none,
  text-fill: auto,
  text-size: 20pt,
  top-space: 3cm,
  footer: true,
  title-fill: auto,
)

// All elements in `it` (searched recursively) for which `pred` holds.
#let tud-find-all(it, pred) = {
  if type(it) != content { return () }
  let found = if pred(it) { (it,) } else { () }
  if it.has("children") {
    for child in it.children { found += tud-find-all(child, pred) }
  }
  if it.has("child") { found += tud-find-all(it.child, pred) }
  if it.has("body") and type(it.body) == content {
    found += tud-find-all(it.body, pred)
  }
  found
}

#let tud-outline-slide-content(self, body) = {
  let options = tud-outline-defaults
  for opts in tud-find-all(body, it => (
    it.func() == metadata and it.at("label", default: none) == <tud-outline-options>
  )) {
    for (key, value) in opts.value {
      if value != auto { options.insert(key, value) }
    }
  }

  let wrapped-body = block(
    width: 100%,
    height: 100%,
    inset: (x: tud-inner-margin),
  )[
    #set text(options.text-size)
    #set text(fill: options.text-fill) if options.text-fill != auto
    #set block(above: 1.2em)
    // Lay the outline out like the former agenda slide: space, title (as a
    // heading that is itself not listed), space, entries.
    #show outline: it => if it.at("label", default: none) == <tud-outline-entries> { it } else {
      let fields = it.fields()
      let title = fields.remove("title", default: auto)
      let _ = fields.remove("label", default: none)
      if title == auto { title = [Agenda] }
      v(options.top-space)
      if title != none {
        if options.title-fill != auto { title = text(fill: options.title-fill, title) }
        heading(level: 1, outlined: false, bookmarked: false, title)
        v(0.5cm)
      }
      [#std.outline(..fields, title: none) <tud-outline-entries>]
    }
    #body
  ]

  self = utils.merge-dicts(self, config-page(
    margin: (
      top: tud-top-margin,
      bottom: tud-bottom-margin,
      x: 0pt,
    ),
    footer: if options.footer { tud-footer } else { none },
    footer-descent: 0pt,
    background: tud-page-background(options.background),
  ))
  touying-slide(self: self, wrapped-body)
}

// ---------------------------------------------------------------------------
// Content slides
// ---------------------------------------------------------------------------
//
// A standard content slide is created by a level-2 heading; everything up to
// the next heading or slide is its body:
//
//   == Relevance of the Near-Field
//   #content-options(text-size: 18pt)
//   Some text ...
//
// Put `#content-options(..)` anywhere in the slide body (usually directly
// after the heading). All arguments are optional:
//   - background: slide background (default: none, i.e. white)
//   - text-fill:  text color of the slide (default: black)
//   - text-size:  text size of the body (default: 20pt)
//   - footer:     false hides the footer (default: true)
//   - outlined:   true lists the slide title in an outline with depth >= 2
//                 (default: false, so outlines only list the sections)
//   - title-fill: color of the title (default: auto, i.e. text-fill)

#let content-options(
  background: auto,
  text-fill: auto,
  text-size: auto,
  footer: auto,
  outlined: auto,
  title-fill: auto,
) = [#metadata((
  background: background,
  text-fill: text-fill,
  text-size: text-size,
  footer: footer,
  outlined: outlined,
  title-fill: title-fill,
)) <tud-content-options>]

#let tud-content-defaults = (
  background: none,
  text-fill: auto,
  text-size: 20pt,
  footer: true,
  outlined: false,
  title-fill: auto,
)

#let tud-content-slide-content(self, title, body, options) = {
  // Content block
  let wrapped-body = block(
    width: 100%,
    height: 100%,
    inset: (x: tud-inner-margin),
  )[
    #set text(fill: options.text-fill) if options.text-fill != auto
    #if title != none [
      #set text(30pt)
      #set block(above: .5em)
      #set text(fill: options.title-fill) if options.title-fill != auto
      #text(weight: "bold", title)
      #linebreak()
    ]
    #set text(options.text-size)
    #set block(above: 1.2em)
    #body
  ]

  self = utils.merge-dicts(self, config-page(
    margin: (
      top: tud-top-margin,
      bottom: tud-bottom-margin,
      x: 0pt,
    ),
    footer: if options.footer {
      tud-footer.with(line: self.store.at("footer-line", default: none))
    } else { none },
    footer-descent: 0pt,
    background: tud-page-background(options.background),
  ))
  touying-slide(self: self, wrapped-body)
}

// Explicit variant, kept for compatibility: `#content-slide(title: ..)[..]`
// creates the same slide as `== ..` (but adds nothing to the outline).
// `#content-options(..)` works inside its body, too.
#let content-slide(title: none, text-size: 20pt, body) = touying-slide-wrapper(self => {
  let (options, rest) = tud-split-options(body, <tud-content-options>, trim: false)
  let options = tud-content-defaults + (text-size: text-size) + options
  tud-content-slide-content(self, title, rest, options)
})

// touying's slide function, called for every `== Heading` and for loose
// content between slides:
//   - content containing an outline  -> outline (agenda) slide
//   - content following `== Heading` -> content slide titled by the heading
//   - anything else                  -> plain slide
#let tud-auto-slide(body) = touying-slide-wrapper(self => {
  let headings = self.at("headings", default: ())
  if tud-find-all(body, it => it.func() == outline).len() > 0 {
    tud-outline-slide-content(self, body)
  } else if headings.len() > 0 and headings.last().depth == 2 {
    let (options, rest) = tud-split-options(body, <tud-content-options>, trim: false)
    let options = tud-content-defaults + options
    let title = headings.last().body
    // touying places the heading (invisibly) on this slide; it only shows up
    // in an outline if requested.
    self.headings = headings.map(it => if it.depth == 2 {
      std.heading(level: 2, outlined: options.outlined, it.body)
    } else {
      it
    })
    // The body always starts in a new paragraph below the title.
    tud-content-slide-content(self, title, parbreak() + rest, options)
  } else {
    touying-slide(self: self, body)
  }
})

#let tud-slides(
  title: none,
  subtitle: none,
  short-title: none,
  author: none,
  short-author: none,
  organizational-unit: none,
  lang: "en",
  date: datetime.today(),
  location-occasion: none,
  show-guides: false,
  section-background: tud-dark-blue,
  // Line across the full width that separates the footer from the body of
  // content slides (`== Title`): none (default) or a stroke, e.g.
  // `0.5pt + tud-brilliant-blue`.
  footer-line: none,
  // Background of the footer on all slides with a footer: a fill (color,
  // gradient, tiling), any content (e.g. `tud-split-pattern(..)`), or none
  // for a transparent footer that shows the slide's own background.
  footer-background: tud-white,
  ..args,
  body
) = {
  set text(font: ("Noto Sans"), lang: lang, fill: tud-black)
  set list(marker: [---])

  // Headings are excluded from the table of contents by default. Only
  // section slides opt their (invisibly rendered) heading back in, so an
  // outline picks up exactly the sections and nothing else.
  show heading: set heading(outlined: false)

  show figure.caption: set text(size: .6em, fill: tud-black)
  show figure.caption: set text(black, size: 14pt, font: ("Noto Sans"))

  show: touying-slides.with(
    config-page(
      // seems to correspond to 297mm × 167mm (as in the indesign template)
      paper: "presentation-16-9",
      margin: 0pt,
      header: none,
      footer: none,
      foreground: if show-guides { tud-guides },
    ),
    config-common(
      // Keep plain Typst semantics: `*strong*` stays ordinary bold text and
      // headings keep the level they were written with.
      show-strong-with-alert: false,
      auto-offset-for-heading: false,
      // The footer already spans the full page width.
      zero-margin-header: false,
      zero-margin-footer: false,
      // `= Title` starts a section slide, `== Title` a content slide.
      slide-level: 2,
      // Content slides (`== Title`) and loose content between slides, e.g.
      // a plain `#outline(..)`.
      slide-fn: tud-auto-slide,
      new-section-slide-fn: tud-new-section-slide,
      // Hand the content following the heading (where `#section-options`
      // lives) to the section slide function.
      receive-body-for-new-section-slide-fn: true,
    ),
    config-info(
      title: title,
      subtitle: subtitle,
      short-title: if short-title == none { title } else { short-title },
      author: author,
      date: date,
      institution: organizational-unit,
    ),
    config-store(
      short-author: if short-author == none { author } else { short-author },
      organizational-unit: organizational-unit,
      location-occasion: location-occasion,
      section-background: section-background,
      footer-line: footer-line,
      footer-background: footer-background,
    ),
    ..args,
  )

  body
}

#let title-slide() = touying-slide-wrapper(self => {
  let content = {
    place(
      rect(fill: tud-gradient, width: 100%, height: 100%)
    )

    place(
      block(
        width: 100%,
        inset: (x: tud-inner-margin - 6.200mm*0.7, y: 0.8cm),
        image("logo-white/TUD_Logo_RGB_horizontal_weiß_en.svg", width: 77.424mm*0.7)
      )
    )

    place(
      block(
        width: 100%,
        height: 95%,
        inset: (x: tud-inner-margin),
        {
          set align(left + horizon)
          set text(fill: tud-white)
          text(
            weight: "bold",
            self.store.organizational-unit
          )
          linebreak()
          text(
            weight: "bold",
            tud-join-authors(self.store.short-author)
          )
          linebreak()
          v(1em)
          text(size: 2.5em, fill: white, weight: "bold", self.info.title)

          linebreak()

          v(0em)
          text(size: 1.5em, fill: white, weight: "bold", self.info.subtitle)
          linebreak()
          v(1em)
          [#self.store.location-occasion \/\/ #self.info.date.display(tud-date-format)]
        }
      )
    )
  }

  touying-slide(self: self, content)
})

// Like content-slide, but the body bleeds all the way to the left/right
// edges (no inner margin) — handy for full-bleed images or wide tables.
#let full-slide(body) = touying-slide-wrapper(self => {
  // Content block
  let wrapped-body = block(
    width: 100%,
    height: 100%,
  )[
    #set text(16pt)
    #set block(above: 1.2em)
    #body
  ]

  self = utils.merge-dicts(self, config-page(
    margin: (
      top: 0pt,
      bottom: tud-bottom-margin,
      x: 0pt,
    ),
    footer: tud-footer,
    footer-descent: 0pt,
  ))
  touying-slide(self: self, wrapped-body)
})