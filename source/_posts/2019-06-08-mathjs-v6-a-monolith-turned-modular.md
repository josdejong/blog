---
layout: post
title: "mathjs v6: a monolith turned modular"
date: 2019-06-08
comments: true
categories: [mathjs, es6, refactor, modular, monolith, dependency injection, tree shaking]
---

In this article, I share with you the journey and the struggles of turning a large, monolithic JavaScript mathematics library, [`mathjs`](https://mathjs.org), into a modular one embracing ES6 modules and functional programming. Because of the heavily intertwined nature of the functionality this was a huge and unique challenge.

## Why?

Math.js is a popular JavaScript library that brings advanced mathematics to the web browser and server. The unique value of math.js lies in offering an integrated solution to work with different types of data like complex numbers and matrices, and offering a math-friendly syntax that allows expressing mathematics in a readable, intuitive way.

The library contains about 200 functions, each of them having support for  numbers, bignumbers, fractions, complex numbers, units, and matrices. All data types and functions together weighted about 137 kB when minified and gzipped. For browsers, this is quite large to "just" send over the wire. And loading the library on slower, mobile devices can take a noticable time. This is a waste if you only use a small portion of the library. The functions and data types where highly coupled. With some work, it was possible to pick only the functions you needed from the library, but since every function implemented and depended on all data types, this still gave a large bundle.

It was a long time wish to bring the code of mathjs, which was written in ES5 and commonjs, to the next level. Make it more modular. Allow mixing and matching functions and data types. Embrace ES6 modules and tree shaking. The goal was to be able to just pick the functions you need, but also, get an light-weight implementation of all functions for just a single datatype instead of all.


## Challenges

Making mathjs modular wasn't a matter of replacing node.js `require` with ES6 `import`. Though well structured, the library was built as single object, growing more and more functionality around it. Management of dependency injection and configuration where the core difficulties that needed to be sorted.

###Central core with a "plugin" based API

Everything was built around a central core. There was a relatively complicated dependency injection mechanism in place, allowing you to import a function into mathjs and utilize it's internals, like access other functions, configuration settings, etcetera:

```js
// file log.js
// can be instantiated using math.import() or the injected function load()
exports.name = 'log'
exports.factory = function (type, config, load, typed) {
  const divideScalar = load(require('./divideScalar'))
  // data types like Complex are available via type.Complex

  // create and return function log
  return function log () { ... }
}
```

Sort of a plugin-based system. Because of this, the functionality was intertwined. There where circular dependencies here and there, which starts to be an issue as soon as you start pulling functionality apart. This had to be turned upside down.

### Dependency injection

Each function depended on all of the data types (BigNumber, Unit, Matrix, ...). Many functions had dependencies on other functions too, and optionally on configuration. How can you turn this into a modular solution where you can mix and match?

### Configuration

Many functions depended on configuration which is managed centrally. The configuration can be changed runtime, altering the behavior of the functions and the values of some constants. It was possible to listen for changes in the configuration.

I wanted to move towards a more functional approach, pure functions, less magic, more plain and simple JavaScript. That was a tough challenge. Because of the dependency injection and configuration, it's not possible to export a flat list with static functions like, say, `lodash` does. You need to work with factory functions. But you can't put the burden of hooking up factory functions and instantiating them to the average user, this is far to cumbersome. And in the end, we do want to have tree-shaking working out of the box too. Lastly, don't forget to try to keep the library backward compatible to enable a smooth transition. A lot of requirements, many of them conflicting with each other.


## Approach

I did a lot of trial-and-error. I tried various approaches for different types of dependency injection. I went to extremes trying to turn functionality into pure functions. I tried out ideas like currying on factory functions. Sometimes you really have to explore and try things out to really get a grasp on whether the solution works, and if not, where it fails.

The solution that we came up with is as follows.

### Simple factory functions as basic building blocks

The basis is to take individual, standalone factory functions as lowest level building blocks. The factory functions use a plain and simple dependency injection mechanism, and can import dependencies and configuration:

```js
// factory function for function log:
export const createLog = factory(
  'log',
  ['config', 'typed', 'divideScalar', 'Complex'],
  function ({ typed, config, divideScalar, Complex }) {
    // create and return function log
    return function log () { ... }
  }
)

// create the function log:
export const log = createLog({ typed, config, divideScalar, Complex })

// use the function log:
console.log(log(10)) // 2.302585092994046
```

The function `factory` here creates a lightweight wrapper around the actual factory function, checking for missing dependencies and attaching the function's name and dependencies as properties on the factory function.

The power here lies in that you can inject any implementation of the dependencies. You can inject the function `divideScalar` of mathjs, which supports many data types. Or you could inject a light-weight, number-only implementation created yourself. This isn't something new: it is plain and simple dependency injection. It required turning the mathjs library upside down though to get to the point where we can actually use this mechanism and can split functions in stand alone pieces of code.


### Function creator

Having to resolve the dependencies of all factory functions yourself is very cumbersome. To make it easy to create functions from the factory functions, a helper function `create` was implemented. Easiest is to simply import _all_ factory functions and have the function `create` resolve the dependencies:

```js
import { create, all } from 'mathjs'

const config = { ... }
const math = create(all, config)
```

Here, `all` is an object containing all factory functions. In the basis, the function `create` just creates functions from factories. Additionally, it holds the configuration, and exposes some utility functions like `import()` and `config()`.

### Dependency collections

To make it easy to create a single function without having to figure out the dependencies that this function requires, mathjs provides ready-made _dependency collections_. For example, the dependency collection `logDependencies` contains all dependencies you need to create the function log:

```js
import { create, logDependencies } from 'mathjs'

const config = { ... }
const { log } = create({ logDependencies }, config)
```

The dependency collections are automatically generated given the factory functions.

### Default functions

A common use case is to just use the default configuration of mathjs, and just use a few functions of the library. To accommodate for this use case, default function implementations are exported from the library. Like the dependency collections, the exported default functions are automatically generated.

```js
import { log, sqrt } from 'mathjs'

console.log(log(10)) // 2.302585092994046
console.log(sqrt(-4).toString()) // 2i
```

When using ES6 modules and a bundler like Webpack, tree-shaking will be working out of the box, which is really awesome.


### Number only implementations

An important requirement was to be able to create lightweight functions that for example only support numbers instead of all known data types. To achieve this, a number of things must be put in place.

First, for low level functions like `add`, `subtract`, `multiply`, and `divide`, light-weight number-only implementations must be created.

Second, it must be possible to inject these light-weight implementations in higher level functions like `log` and `hypot`, which have these lower level functions like `divide` as dependency. This is enabled by the new dependency injection mechanism explained above.

Last, the light-weight functions must be hooked up and exposed to the user in an easy way. Right now, the mathjs library offers default functions and  dependency collections for number only implementations of all relevant functions. In the future, this can be extended for other data types if we want.

Usage of number only functions is quite easy:

```js
import { log, sqrt } from 'mathjs/number'

console.log(log(10)) // 2.302585092994046
console.log(sqrt(4)) // 2
console.log(sqrt(-4)) // NaN, Complex numbers not supported...
```

Of course, tree-shaking works out of the box again.


## Livesavers

First, though I did most of the refactoring on my own in my spare time, all the feedback and thumbs-up from collaborators and enthusiasts really helped me keep going and stay motivated. Their feedback on many proposals really helped shape the final API. Thanks!

Because this migration was so large, it was essential to have a setup where we could migrate the code piece by piece, function by function, whilst keeping the library fully working. You need quick feedback on whether a migrated piece of code still works, see if there are regressions in both functionality as well as performance. The refactoring took more than half a year, and it's impossible to work on it for months without knowing whether it will actually work.

[Webpack](https://webpack.js.org/) turned out to be a live saver during the refactor, since it happily works with a code base containing mixed commonjs code and ES6 import/export. Even when having a mix within a single file! We used [Lebab](https://github.com/lebab/lebab) to automatically convert commonjs code to ES6, that saved a lot of manual work. The [WebStorm IDE](https://www.jetbrains.com/webstorm/specials/webstorm/webstorm.html) was very helpful thanks to its strong intellisense. And [standardjs](https://standardjs.com/) helped finding unused imports and styling issues.

I was really glad that library is heavily unit tested. I think I wouldn't have started this undertaking otherwise. This was essential in order not to lose or break existing features that I sometimes simply had forgotten about existed. Surprisingly enough, I didn't really miss that the library is not typed using for example [TypeScript](https://www.typescriptlang.org/). It's plain JavaScript. Many "simple" issues where already pointed out by Webstorm's intellisense and the standardjs linter. The serious issues I encountered did trigger failing unit tests, and many of them wouldn't be solved by adding types. In maths, it really isn't enough to type check that `sqrt(4)` returns a number, you really want to double check that the value of the number is correct. The idea "it compiles thus it works" really doesn't hold ;)


## Enjoy

I'm really happy with the result. I think this allows `mathjs` to grow further. It makes the library more powerful and easier to extend and customize. I see the future of `mathjs` as being an integrated environment for mathematics in JavaScript: a "hub" merging a lot of different data types together (matrices, units, complex number, ...), and an expression parser making it convenient to work with mathematics in JavaScript. Many of the data types are already served by external libraries ([`decimal.js`](https://github.com/MikeMcl/decimal.js/), [`complex.js`](https://github.com/infusion/Complex.js/), [`fraction.js`](https://github.com/infusion/Fraction.js)). Moving support for units into a separate library [`unitmath`](https://github.com/ericman314/UnitMath) is currently being worked on (thanks Eric for taking ownership!). These steps help mathjs to stay focused, and prevents it from growing into a huge monolith. We aren't there yet. For example, I would like to make it easier to integrate a new data type to `mathjs`. But that's for the next episode :)

Now, to try it out, install the latest version via npm, and [get started](https://mathjs.org/docs/getting_started.html):

```
npm install mathjs
```

Enjoy!

