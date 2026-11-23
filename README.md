# tud-typst-presentation
A typst presentation template based on the corporate design of Dresden University of Technology.

The compiled example PDF can be viewed here: [example/main.pdf](https://github.com/devfix/tud-typst-presentation/blob/main/example/main.pdf)

![preview.png](https://raw.githubusercontent.com/devfix/tud-typst-presentation/refs/heads/main/example/preview.png "preview.png")

## Getting Started
- Download this repository.
- Copy the `tud-typst-presentation` directory to your local project directory.
- If you wish, copy the `example/main.typ` into your project directory as well and edit it accordingly.

## Options and Features

The template is built on [touying](https://typst.app/universe/package/touying) 0.8.0, which requires Typst 0.15 or newer.

### Minimal example

```typst
#import "template.typ": *

#show: tud-slides.with(
  title: "My Presentation",
  subtitle: "This is the subtitle",
  author: "Peter Petersen",
  organizational-unit: "Institute of Typst Technology",
  location-occasion: "Typst University",
  date: datetime(year: 2026, month: 9, day: 22),
)

#title-slide()

#outline(depth: 1, title: [Agenda])

= Section 1

== First Slide
Here is some text.

#show: appendix

= Appendix
#section-options(outlined: false, background: tud-black)

== References
- ...
```

### Presentation settings (`tud-slides`)

| Parameter | Default | Description |
|---|---|---|
| `title` | `none` | Title of the presentation (title slide, footer, PDF metadata). |
| `subtitle` | `none` | Subtitle shown on the title slide. |
| `short-title` | `none` | Shorter title for the footer; falls back to `title`. |
| `author` | `none` | Author as a string, or an array of authors (joined with " & "). |
| `short-author` | `none` | Shorter author line for the title slide and footer; falls back to `author`. |
| `organizational-unit` | `none` | Institute / chair, shown on the title slide and in the footer. |
| `location-occasion` | `none` | Place or occasion, shown next to the date. |
| `lang` | `"en"` | Text language. |
| `date` | `datetime.today()` | Date of the presentation. |
| `show-guides` | `false` | Draws red layout guide lines from the corporate design. |
| `section-background` | `tud-dark-blue` | Default background of all section slides. |
| `footer-line` | `none` | Line between the footer and the body of content slides: `none` or a stroke, e.g. `0.5pt + tud-brilliant-blue`. |
| `footer-background` | `tud-white` | Background of the footer on all slides with a footer: a fill (color, gradient, tiling), any content, or `none` for a transparent footer. |

Any further arguments are passed on to touying (e.g. `config-common(handout: true)`).

### Title slide

`#title-slide()` creates the title slide from the settings above. It has no footer.

### Section slides (`= Heading`)

Every level-1 heading creates a section slide and an entry in the outline:

```typst
= Motivation and Scope
#section-options(background: tud-split-pattern(variant: 2))
```

Put `#section-options(..)` directly after the heading. All arguments are optional:

| Option | Default | Description |
|---|---|---|
| `subtitle` | `none` | Content shown below the title. Plain text written after the heading is used as the subtitle as well. |
| `background` | `section-background` | Slide background (see [Backgrounds](#backgrounds)). |
| `outlined` | `true` | `false` keeps the section out of the outline and the PDF bookmarks, e.g. for a "Thank you" slide. The label `= Title <touying:unoutlined>` does the same. |
| `title-fill` | white | Color of the title. |
| `subtitle-fill` | semi-transparent white | Color of the subtitle. |

### Content slides (`== Heading`)

Every level-2 heading creates a content slide; everything up to the next heading is its body:

```typst
== Relevance of the Near-Field
#content-options(text-size: 18pt, title-fill: tud-blue-1)

Some text ...
```

Put `#content-options(..)` anywhere in the body (usually directly after the heading). All arguments are optional:

| Option | Default | Description |
|---|---|---|
| `background` | `none` (white) | Slide background (see [Backgrounds](#backgrounds)). |
| `text-fill` | black | Text color of the slide. |
| `text-size` | `20pt` | Text size of the body. |
| `title-fill` | `text-fill` | Color of the title. |
| `footer` | `true` | `false` hides the footer. |
| `outlined` | `false` | `true` lists the slide title in an outline with `depth: 2`. |

Note: a `#set` rule written in a slide body applies to all following slides, since the slide is not wrapped in a block. Wrap the content in `#[ ... ]` to keep the rule local to one slide.

touying's animations, such as `#pause`, work inside content slides.

### Outline / agenda slides (`#outline`)

A plain `#outline(..)` between slides becomes an agenda slide listing the sections, each linking to its slide:

```typst
#outline(depth: 1, title: [Agenda])
#outline-options(background: tud-blue-2)
```

All arguments of Typst's `outline` work as usual (`title`, `depth`, `indent`, `target`, ...). `title: auto` shows "Agenda", `title: none` shows no title. Put `#outline-options(..)` directly before or after the outline. All arguments are optional:

| Option | Default | Description |
|---|---|---|
| `background` | `none` (white) | Slide background (see [Backgrounds](#backgrounds)). |
| `text-fill` | black | Text color of the slide. |
| `text-size` | `20pt` | Text size of the entries. |
| `title-fill` | `text-fill` | Color of the title. |
| `top-space` | `3cm` | Vertical space above the title. |
| `footer` | `true` | `false` hides the footer. |

### Backgrounds

Every `background` option (in `section-options`, `content-options`, `outline-options` and `section-slide`) accepts a fill (color, gradient, tiling) or any content. `tud-split-pattern` draws the two-tone background patterns from the corporate design:

```typst
#section-options(background: tud-split-pattern(variant: 1))
#section-options(background: tud-split-pattern(variant: 4, primary: tud-blue-2, secondary: tud-blue-1))
```

| Parameter | Default | Description |
|---|---|---|
| `variant` | `3` | `1`: two triangles meeting left of the center (Rot 2 / Magenta 2)<br>`2`: two slanted bands along the top and bottom edges (Violett 1 / Magenta 1)<br>`3`: vertical split with a diagonal edge (Violett 2 / Violett 1)<br>`4`: two triangles pointing at the right third (Türkis 1 / Türkis 2) |
| `primary` | variant's color | Color of the shapes. |
| `secondary` | variant's color | Color of the remaining area. |

### Slide numbers and appendix

The footer shows `current / total`. Everything after `#show: appendix` is not counted towards the total; appendix slides are numbered separately in Roman numerals (I, II, III, ...) without a total. `#show: last-official-slide` is an alias for `#show: appendix`.

### Colors

`colors.typ` defines the corporate design colors, available after importing the template:

- Main colors: `tud-brilliant-blue`, `tud-dark-blue`, `tud-black`, `tud-gray`, `tud-white`
- Accent colors, strong: `tud-blue-1`, `tud-violet-1`, `tud-magenta-1`, `tud-red-1`, `tud-orange-1`, `tud-yellow-1`, `tud-olive-1`, `tud-green-1`, `tud-teal-1`
- Accent colors, light: `tud-blue-2`, `tud-violet-2`, `tud-magenta-2`, `tud-red-2`, `tud-orange-2`, `tud-yellow-2`, `tud-olive-2`, `tud-green-2`, `tud-teal-2`

### Explicit slide functions

For special cases and compatibility, slides can also be created by function calls:

- `#section-slide(title:, subtitle:, outlined:, background:, title-fill:, subtitle-fill:)`: same as a section heading.
- `#content-slide(title:, text-size:)[body]`: same as a content heading, but not listed in the outline.
- `#full-slide[body]`: content slide without title whose body spans the full slide width, e.g. for wide images or tables.