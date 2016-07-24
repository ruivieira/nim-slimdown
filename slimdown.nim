# Slimdown - A simple pattern-based Markdown parser.
# Based on Johnny Broadway's <johnny@johnnybroadway.com>
# Slimdown (https://gist.github.com/jbroadway/2836900)

import tables, nre, strutils, sequtils, future

proc paragraph(line: string): string =
  let trimmed = line.strip()
  result = ""
  if trimmed.contains(re"^<\/?(ul|ol|li|h|p|bl)"):
    result &= "\n$1\n" % [line]
  result &= "\n<p>$1</p>\n" % [trimmed];

# def ul_list(match_obj):
# 	item = match_obj.group(1);
# 	return "\n<ul>\n\t<li>{}</li>\n</ul>".format(item.strip());
#
# def ol_list(match_obj):
# 	item = match_obj.group(1);
# 	return "\n<ol>\n\t<li>{}</li>\n</ol>".format(item.strip());
#
# def blockquote(match_obj):
# 	item = match_obj.group(2);
# 	return "\n<blockquote>{}</blockquote>".format(item.strip());
#


# rules[r''] = r'<' # quote
# rules[r'\n\*(.*)'] = ul_list # ul lists
# rules[r'\n[0-9]+\.(.*)'] = ol_list # ol lists
# rules[r'\n(&gt;|\>)(.*)'] = blockquote # blockquotes
#paragraph # add paragraphs
# rules[r'<\/ul>\s?<ul>'] = r'' # fix extra ul
# rules[r'<\/ol>\s?<ol>'] = r'' # fix extra ol
# rules[r'<\/blockquote><blockquote>'] = r"\n" # fix extra blockquote

proc bold(text: string): string =
  let matcher = re"(\*\*|__)(.*?)\1"
  nre.replace(text, matcher,
    (m: RegexMatch) => r"<strong>$1</strong>" % [m.captures[1]])

proc emphasis(text: string): string =
  let matcher = re"(\*|_)(.*?)\1"
  nre.replace(text, matcher,
    (m: RegexMatch) => r"<em>$1</em>" % [m.captures[1]])

proc strike(text: string): string =
  let matcher = re"\~\~(.*?)\~\~"
  nre.replace(text, matcher,
    (m: RegexMatch) => r"<del>$1</del>" % [m.captures[0]])

## horizontal rule
proc hr(text: string): string =
  let matcher = re"\n-{5,}" # horizontal rule
  nre.replace(text, matcher, "\n<hr />")

proc links(text: string): string =
  let matcher = re"\[([^\[]+)\]\(([^\)]+)\)"
  nre.replace(text, matcher,
    (m: RegexMatch) => "<a href='$2'>$1</a>" % [m.captures[0], m.captures[1]])

## Inline code
proc code(text: string): string =
  let matcher = re"`(.*?)`"
  nre.replace(text, matcher,
    (m: RegexMatch) => r"<code>$1</code>" % [m.captures[0]])

## headers
proc header(text: string): string =
  proc replacer(m: RegexMatch): string =
    let level = m.captures[0].len()
    let title = m.captures[1].strip()
    r"<h$1>$2</h$1>" % [intToStr(level), title]
  let matcher = re"(#+)(.*)"
  nre.replace(text, matcher, replacer)

proc md*(text: string): string =
  result = bold(text)
  result = emphasis(result)
  result = strike(result)
  result = hr(result)
  result = links(result)
  result = code(result)
  result = header(result)
