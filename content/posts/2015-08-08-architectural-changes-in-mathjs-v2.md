---
categories:
- mathjs
- modularization
- typed-function
comments: true
date: "2015-08-08T00:00:00Z"
title: Architectural changes in math.js v2
url: "blog/2015/08/08/architectural-changes-in-mathjs-v2/"
---


_**tl;dr** Math.js v2 has been released a week ago. It has a completely reworked, modular architecture which allows creating custom builds. All functions have been rewritten into typed-functions. This takes away a lot of overhead for type checking and type conversions. These changes create a lot of flexibility in both extending and consuming the library._


A week ago [math.js](http://mathjs.org/) v2 has been released, a big milestone! You can [download it here](http://mathjs.org/download.html). Math.js is an extensive math library for JavaScript and Node.js. It features a flexible expression parser and offers an integrated solution to work with numbers, fractions, big numbers, complex numbers, units, and matrices. It has been around for two and a half years now and has a steadily growing community around it and number of dedicated contributors.

Math.js v2 has a completely reworked architecture, and it adds support for fractions, sparse matrices, a linear equation solver, improved LaTeX support, and more. Currently there are contributors working on algebraic differentiation and derived units. A special thanks to [Favian](https://github.com/BigFav), [Max](https://github.com/FSMaxB), [Rogelio](https://github.com/rjbaucells), and [Eric](https://github.com/ericman314), who have put a lot of effort in the library lately.


## Growing pains

As you can imagine, the library is growing. The point where it becomes too large to just mindlessly bundle it with your application comes closer. You typically only need a small part of the library, and it's just a waste of CPU, memory, and KB's when you need to bundle the complete library with your application. The architecture of math.js v1 however wasn't suitable for custom bundling. It was also missing ways to optimize functions for known input types (very important for matrix operations). Lastly, dealing with new data types and conversions between data types was quite cumbersome.

For this reason the architecture of math.js v2 was drastically changed. The main architectural changes are related to modularization, dynamic type checking, and lazy loading. These changes will be covered in the in the next sections.


## Modularization

To enable custom loading and custom bundling, a modular structure and explicit dependencies are required. This wasn't trivial to achieve. Math.js does not consist of a set of isolated functions like say [lodash](https://lodash.com). There are a couple of challenges here:

-   The functions are not static but need access to a configuration object. This means that the functions need to be created via a factory function, and need to be loaded via some loader which passes the config object to the function. This makes it impossible to just reference individual functions like `mathjs/lib/arithmetic/add`: the functions must be constructed via a loader.

-   The architecture of v1 had a shared `math` namespace containing all functions. This was done for a couple of reasons: there where circular references between functions, functions needed access to a shared configuration, and some functions depended on other functions in the namespace. Problem was that this shared namespace resulted in implicit dependencies, which makes it impossible to determine dependencies when bundling a subset of the functions. In v2, this shared namespace is removed and the circular references are resolved. A function has to load it's dependencies explicitly. This allows to bundle only a subset of the available functions and data types.

-   The most difficult issue is the following. There are currently about ten different data types, and each function contains an implementation for each data type. Suppose you only need one or two of these data types, how can you exclude the other data types and exclude their implementations from all individual functions? We do not have a solution for this yet. Possible directions for solutions are:
    -    Smart dead-code elimination of bundlers/minifiers, possibly using conditional compilation.
    -    Writing a browserify transform or webpack loader which is capable of removing code related to excluded data types. This may be relatively easy because of the easily recognizable structure of `typed-functions`.
         <br><br>
-   Math.js v1 contained a couple of large helper files. If you only need one of the functions in a helper file, you need to bundle the whole file. In v2, most helper files are split into one-file-per-function. This gives a more fine grained way to define dependencies, and allows to bundle only the utility functions that are actually used.


## Dynamic type checking logic
    
Each function of math.js handles multiple data types like numbers, complex number, and matrices. In v1, these functions consisted of a single function body, which did type checking of the input types, and evaluated accordingly (see for example [exp.js of v1](https://github.com/josdejong/mathjs/blob/v1/lib/function/arithmetic/exp.js)). Problems with this approach are:
 
 - all type checking and conversion logic has to be written explicitly in the functions themselves. This gives quite some code overhead, and distracts from the actual function logic. 
 - it is also a "closed" solution: no easy way to extend existing functions with support for new data types.
- it is not possible to access low level implementations of a function handling a specific data type (like `add` for numbers). This is a necessity for performance optimizations with for example matrix operations.

In v2, functions are written as typed-functions using the [`typed-function`](https://github.com/josdejong/typed-function) library. See for example [exp.js of v2](https://github.com/josdejong/mathjs/blob/master/lib/function/arithmetic/exp.js)). Using `typed-function`, functions can be defined as a set of signatures such as a function `add` having signatures `add(number, number)` and `add(unit, unit)`. `typed-function` dynamically constructs the functions from the given signatures. Conversions from non-supported types is done automatically where applicable. Typed functions can be extended at run time with more signatures. Individual signatures can be addressed, allowing for performance optimizations when an input type is known beforehand. For example when you have a matrix containing just numbers, there is no need to type check every entry when performing an operation on the matrix.

The typed functions in v2 give us a lot of flexibility and decoupling, and ensures that when writing new functions, you only have to care about the implementation logic, not about type checking or type conversion logic.


## Lazy loading

A third chane worth mentioning is lazy loading of functions. Loading all functions and all data types in memory costs time and, well, memory. In v2, functions and data types are by default lazy loaded: only as soon as you use a function, it will be loaded. This is achieved by using Object properties which replace their value with the lazy-loaded function on the first read. The result is a much faster loading library.


## Conclusion

All in all I'm very happy with what we have achieved with v2. It was a bumpy road and a lot of boring refactoring. And there have been difficulties getting a good performance with typed-functions. But it turns out that the final v2 has even better performance than v1 in most cases, and the lazy-loading solution ensures that loading times remain limited: v2 loads about as fast as v1, whilst the library has grown considerably. It was definitely worth it.

There is still a lot of work to do regarding modularization. There is a lot to be optimized there. And while it's awesome that we can finally do custom builds, one thing I don't quite like is the need to write your own custom index file for [custom bundling](http://mathjs.org/docs/custom_loading_and_bundling.html). Ideally, users should not have to bother about custom bundles: this should be done automatically by our bundling and minifying tools. I'm following initiatives like [rollup](https://medium.com/@Rich_Harris/small-modules-it-s-not-quite-that-simple-3ca532d65de4) by Rich Harris with great interest.

Math.js v2 takes away the bottlenecks for further growth, and gives a lot of flexibility for both extending as well as consuming the library. The future looks bright.
