#import "tud-typst-presentation/template.typ": *

#show: tud-slides.with(
  title: "My Presentation",
  subtitle: "This is the subtitle",
  author: ("Peter Petersen"),
  organizational-unit: "Institute of Typst Technology",
  location-occasion: "Typst University",
  lang: "en",
  date: datetime(year: 2026, month: 9, day: 22),
  footer-line: none,
  footer-background: tud-white
)

#set list(marker: [•], indent: 1em)

#title-slide()

#outline(depth: 2, title: text(fill: tud-brilliant-blue)[Content])

= Section 1
#section-options(
  background: tud-split-pattern(variant: 2)
)

== First Slide

Here is some text

== Second Slide

You can read this.

#pause

Now this too.

#pause
And finally this as well.

= Section 2
#section-options(
  background: tud-split-pattern(variant: 1),
  subtitle: [This section has a subtitle.],
  title-fill: tud-brilliant-blue,
  subtitle-fill: tud-brilliant-blue,
)

== Another Slide

Hello.

= Thank you for your time!
#section-options(
  subtitle: "I will be happy to answer your questions now.",
  outlined: false,
)

#show: appendix

= Appendix
#section-options(
  background: tud-black,
  outlined: false,
)

== References


#v(1em)

#set list(spacing: 1.5em)
#[
- Wikipedia
- Wikihow
- The almighty AI
]

#v(3em)

The slide counter did change to roman numbers to avoid confusion.

= Something Interesting
#section-options(
  subtitle: [... that wasn't supposed to be in the main presentation.],
  outlined: false,
  background: tud-split-pattern(variant: 4, primary: tud-orange-1, secondary: tud-red-1),
  subtitle-fill: tud-blue-2
)


== The Very Last Slide

Tja. Everything must come to an end.
