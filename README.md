[![Build Status](https://travis-ci.org/ruivieira/nim-slimdown.svg?branch=master)](https://travis-ci.org/ruivieira/nim-slimdown)
# nim-slimdown

## About

A simple pattern-based markdown parser based on Johnny Broadway's (<johnny@johnnybroadway.com>) [PHP Slimdown](https://gist.github.com/jbroadway/2836900).

## Building

Clone and run:

```
nimble build
nimble install
```

## Usage

```{nim}
import slimdown

let markdown = """
# Examples

##Bold

This is a markdown *example*
"""

let html = slimdown.md(markdown)

# <h1>Examples</h1>
#
# <h2>Bold</h2>
#
# This is a markdown <em>example</em>
```