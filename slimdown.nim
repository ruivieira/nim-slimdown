# Slimdown - A simple pattern-based Markdown parser.
# Based on Johnny Broadway's <johnny@johnnybroadway.com>
# Slimdown (https://gist.github.com/jbroadway/2836900)

import tables, nre, strutils, sequtils, future

proc ul(m: RegexMatch): string =
  let item = m.captures[0].strip()
  "\n<ul>\n\t<li>$1</li>\n</ul>" % [item]

proc ol(m: RegexMatch): string =
  let item = m.captures[0].strip()
  "\n<ol>\n\t<li>$1</li>\n</ol>" % [item]

proc bold(m: RegexMatch): string = "<strong>$1</strong>" % [m.captures[1]]

proc emphasis(m: RegexMatch): string = "<em>$1</em>" % [m.captures[1]]

proc strike(m: RegexMatch): string = "<del>$1</del>" % [m.captures[0]]

## horizontal rule
proc hr(m: RegexMatch): string = "\n<hr />"

proc links(m: RegexMatch): string = "<a href='$2'>$1</a>" % [m.captures[0], m.captures[1]]

## Inline code
proc code(m: RegexMatch): string = "<code>$1</code>" % [m.captures[0]]

## headers
proc header(m: RegexMatch): string =
  let level = m.captures[0].len()
  let title = m.captures[1].strip()
  "<h$1>$2</h$1>" % [intToStr(level), title]

let matchers = @[
  re"\n\*(.*)", # ul
  re"(\*\*|__)(.*?)\1", # bold
  re"\n[0-9]+\.(.*)", # ol
  re"(\*|_)(.*?)\1", # emphasis
  re"\~\~(.*?)\~\~", # strike
  re"\n-{5,}", # hr
  re"\[([^\[]+)\]\(([^\)]+)\)", # links
  re"`(.*?)`", # code
  re"\n(#+)(.*)" # header
]

let replacers = @[ul, bold, ol, emphasis, strike, hr, links, code, header]

proc md*(text: string): string =
  result = text
  for processor in zip(matchers, replacers):
    let (matcher, replacer) = processor
    result = nre.replace(result, matcher, replacer)
