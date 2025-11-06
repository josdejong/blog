---
title: "Projects"
date: 2025-04-14T11:24:32+02:00
draft: false
comments: false
pagination: false
url: "projects/"
---

This page gives an overview on the projects I'm working on.
These include projects I work on at work as well as in my spare time.


## JSON Editor Online

JSON Editor Online is a versatile, high quality tool to edit and process your JSON data. It is one of the best and most popular tools around and has a high user satisfaction. The editor offers all your need in one place: from formatting and beautifying your JSON data to comparing JSON documents or querying your JSON data. JSON is the most used data format between servers and browser, and JSON Editor Online is an indispensable tool for frontend and backend developers working with JSON data in their daily life.

Website: https://jsoneditoronline.org

[![JSON Editor Online](/images/projects/jsoneditoronline.png)](https://jsoneditoronline.org)


## math.js

Math.js is an extensive math library for JavaScript and Node.js.
It features a flexible expression parser and offers an integrated solution to
work with real and complex numbers, units, and matrices.
Powerful and easy to use.

Website: https://mathjs.org

[![math.js](/images/projects/mathjs.png)](https://mathjs.org)


## Math Notepad

Math Notepad is a web based editor for mathematical calculations.
It supports real and complex numbers, matrices, units,
and comes with a lot of built-in functions.
One can plot interactive graphs and define custom variables and functions.
Expressions are entered in an editable sheet,
which automatically updates results when changing an expression.

Math Notepad is the successor of [SpeQ Mathematics](https://speqmath.com),
which had a similar goal.

Website: https://mathnotepad.com

[![Math Notepad](/images/projects/mathnotepad.png)](https://mathnotepad.com)

## JSON Query

JSON Query is a small, flexible, and expandable query language. It comes with a human friendly Text Format and an easy to parse, intermediate JSON Format. At its core, JSON Query is a JSON notation to describe making a series of function calls. It has no magic syntax except for the need to be familiar with JSON, making it flexible and easy to understand. The library is extremely small thanks to smartly utilizing the native language’s functions and built-in JSON parser, requiring very little code to make the query language work.

Website: https://jsonquerylang.org

[![JSON Query](/images/projects/jsonquery.svg)](https://jsonquerylang.org)

## Tabular-JSON

Tabular-JSON is a data format. It is a superset of JSON, adding CSV-like tables. It is:

- A replacement for CSV without its ambiguities and limitation of tabular data structures
- A replacement for JSON without its verbosity with tabular data

Tabular-JSON aims to be just as simple as JSON and CSV. It combines the best of JSON and CSV, but without their drawbacks. It is human-readable, compact, and supports rich data structures and streaming. The aim of Tabular-JSON is to be a data format, not a configuration format.

Website: https://tabular-json.org/

Here is an example of Tabular-JSON data:

```text
{
  "name": "rob",
  "hobbies": [
    "swimming",
    "biking",
  ],
  "friends": ---
    "id", "name",  "address"."city", "address"."street"
    2,    "joe",   "New York",       "1st Ave"
    3,    "sarah", "Washington",     "18th Street NW"
  ---,
  "address": {
    "city": "New York",
    "street": "1st Ave",
  }
}
```

And here a table at root level (the rows are streamable):

```text
"id", "name",  "address"."city", "address"."street"
2,    "joe",   "New York",       "1st Ave"
3,    "sarah", "Washington",     "18th Street NW"
```

## tttimestamps

tttimestamps converts timestamps, ISO strings, dates, and more. You can
enter any date-like input in the main input field. Entered inputs appear
in an editable table displaying various time formats side by side.
The table columns and timezones are configurable.

Website: https://tttimestamps.com

[![tttimestamps](/images/projects/tttimestamps.png)](https://tttimestamps.com)


## vis.js

Vis.js is a dynamic, browser based visualization library.
The library is designed to be easy to use,
to handle large amounts of dynamic  data,
and to enable manipulation of the data.
The library consists of the components DataSet, Timeline, and Graph.
Vis.js is developed by Almende B.V.

Website: https://visjs.org

[![vis.js](/images/projects/vis.png)](https://visjs.org)


## Eve

Eve is a multipurpose, web based agent platform.
Eve envisions to be an open and dynamic environment where agents can live and
act anywhere: in the cloud, on smartphones, on desktops, in browsers, robots,
home automation devices, and others. Eve tries to mimic human society:
the way people interact and work together.
Eve is developed by Almende B.V.

Website: https://eve.almende.com

[![Eve](/images/projects/eve.png)](https://eve.almende.com)


## VBI

VBI is an interactive business intelligence tool aimed at startups and
small companies who want to get a grip on their business model and
financials. It starts with filling out a rough business canvas model,
and from there helps you refine into a concrete financial model
describing profit and loss, balance sheet, and cashflow.

Website: <not available anymore>

![VBI](/images/projects/vbi.png)
