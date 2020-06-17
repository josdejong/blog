---
categories:
- isomorphic
- api
- cross environment
comments: true
date: "2015-03-28T00:00:00Z"
title: A broader view on isomorphic JavaScript
url: "blog/2015/03/28/a-broader-view-on-isomorphic-javascript/"
---

_**tl;dr** In order to ease full stack JavaScript development, we need to take away the hurdles keeping these worlds separated. We need unified, isomorphic solutions for common functionality like module loading, networking, background processes, logging, and others._


Ever had to use statements like the following?

```js
if (typeof window !== 'undefined') {
  // browser
}
else {
  // node.js
}
```

It's a simple check to see whether a script is being executed in in a browser, and if not, assume that it's a node.js process. I noticed that I need them more and more. I mostly develop libraries. As soon as I need functionality which is not standard available in both browser and node.js, like fetching urls, I have to create two different implementations and switch depending on the environment. It's annoying and I don't yet have a seamless solution for dealing with environment specific code.

There has been quite some some discussion lately about isomorphic JavaScript. Most discussion focuses on client or server side rendering, spurred by the recent popularity of React. Isomorphic JavaScript however is a much broader topic. It's basically about writing code which can run in different environments such as the browser and node.js. In this article we will have a look at isomorphic JavaScript in a broader sense, and explore ways to deal with environment specific code in a seamless way.


## Types of isomorphic code

JavaScript can run in different environments. One can think of client-side in the browser, server-side with node.js, on mobile devices using Cordova or PhoneGap, and on microcontrollers using Espruino. These environments have in common that they all support the JavaScript language. What they don't have in common is environment specific functionality like the DOM and AJAX calls in the browsers, http servers and disk access in node.js, and access to mobile phone sensors in Cordova.

Spike Brehm distinguishes two types of isomorphic modules in this talk [Master Class: Isomorphic JavaScript](http://www.slideshare.net/spikebrehm/a-28174727): environment agnostic or shimmed per environment.

- Environment agnostic modules.
  These modules use only pure JavaScript functionality, and no environment specific properties like `window` and `process`. Examples are [lodash](https://lodash.com/), [async](https://github.com/caolan/async), [moment.js](http://momentjs.com/), [numeral.js](http://numeraljs.com/), and [math.js](http://mathjs.org/).
- Modules shimmed per environment.
  They offer a single API, and different implementations per environment. For example [superagent](https://github.com/visionmedia/superagent), [socket.io](http://socket.io/), [debug](https://github.com/visionmedia/debug), and [pubnub](https://github.com/pubnub/javascript).


Environment agnostic modules just work fine everywhere. Shimmed modules however require selecting the right implementation depending on the current environment. This is no problem when the module is consumed by an application. In that case it's clear in which environment the application will run, like server side or client side. But when the module is consumed by another module, this choice can't be made. For example a library for currency conversion (which makes network requests to a REST API), or a library using a proper debug library. The consuming module will have to distribute implementations for the different environments too. This results in a cascading effect, forcing all modules down the chain to create builds for various environments.


## Shimmable functionality

In the previous section we discussed isomorphic modules offering a single API and different implementations per environment. This is only possible when the underlying functionality is available on each of the targeted environments. Let's for now focus on the browser and node.js. In both, networking is a core functionality: the browser offers AJAX technology, and node.js has HTTP (and other protocols) in it's genes. Both environments offer similar functionality, but with totally different API's.

The following table shows an (incomplete) list with similar functionality available on both browser and node.js:

Functionality         | Browser               | Node.js
--------------------- | --------------------- | -------------------
Module system         | none                  | [CommonJS](https://blog.risingstack.com/node-js-at-scale-module-system-commonjs-require/)
HTTP requests         | [XMLHttpRequest (AJAX)](https://developer.mozilla.org/en/docs/AJAX)             | [http](https://nodejs.org/docs/latest/api/http.html)
Sockets               | [WebSocket](http://www.html5rocks.com/en/tutorials/websockets/basics/)          | [net](https://nodejs.org/docs/latest/api/net.html)
WebRTC                | [WebRTC](http://www.webrtc.org/web-apis), [peer.js](http://peerjs.com/)         | [node-webrtc](https://github.com/js-platform/node-webrtc)
Background processes  | [Web Worker](http://www.html5rocks.com/en/tutorials/workers/basics/)            | [child_process](https://nodejs.org/docs/latest/api/child_process.html)
Rendering             | [DOM](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model)   | [React](http://facebook.github.io/react/), [jsdom](https://github.com/tmpvar/jsdom), [PhantomJS](http://phantomjs.org/)
Debugging             | Web Console: [Chrome](https://developer.chrome.com/devtools/docs/console), [FireFox](https://developer.mozilla.org/en/docs/Tools/Web_Console) | [console](https://nodejs.org/docs/latest/api/console.html), [Winston](https://github.com/winstonjs/winston), [Bunyan](https://github.com/trentm/node-bunyan)

JavaScript land still lacks de facto abstractions on top of these overlapping functionalities, allowing to use the same API's in both browser and node.js environments.

Notable here is the approach of browserify, which offers [browser shims](https://github.com/substack/node-browserify#compatibility) for many node.js specific modules like `http` and `console`. In practice though, the size of these shims can be quite large, which can be a serious problem for browser applications.

The browser and node.js worlds are currently still largely separated. There is a lot of room to bring them together on multiple levels, easing full stack JavaScript development. One step in the right direction is taken by [npm](https://www.npmjs.com/) for example, which encourages us to [use npm for both front-end and back-end](http://blog.npmjs.org/post/91303926460/npm-cli-roadmap-a-periodic-update) development, instead of using different package managers for different environments. An other important step is a universal module system for JavaScript, available in both node.js and the browser: [ES6 modules](https://github.com/lukehoban/es6features#modules). The third step is up to us module developers: build more isomorphic libraries which can be used in both browser and node.js without any hassle.


## How to distribute isomorphic libraries?

There are basically two ways for distributing isomorphic libraries:

1. Distribute different implementations per environment. The library consumer will have to select the right implementation depending on the environment.
2. Distribute a single, universal implementation, which automatically detects the environment at runtime and loads the needed environment specific code.

The problem with the first approach is that it does not solve the problem but passes it on to the library consumer. This is fine when consumed by an application, but not when consumed by an other library. This library in turn has to check the environment, load the correct implementation of the consumed library, and has to distribute multiple versions of itself too. This results in a cascading effect.

The problem with the second approach is that the isomorphic library will contain the code for *all* supported environments. For node.js modules this is no big deal, but for the browser it's important to minimize the amount of bundled code. It's simply not acceptable to send precious kB's over the wire containing unused, node.js specific code.

The only scalable, long term solution here is the second one. The exposure of environment specific code should be minimized. Library consumers should not have to bother about which implementation to pick, nor should they be bothered with distributing their own library in an isomorphic way due to isomorphic dependencies. This means we have to tackle the problem of distributing bloated application code containing code for multiple environments. We need build tools which can strip away non-relevant, environment specific code, like removing node.js specific code when bundling a browser app.


## Tooling and conventions

In order to facilitate universally usable isomorphic libraries, two things are needed:

- Tooling to detect the current environment at runtime.
- Tooling to strip node.js specific code from application bundles when redundant.

### Environment detection

In order to be able to let an isomorphic library switch to the right implementation, the library needs a way to detect in which environment it is running. This does not need to be very complicated. There may exist already exist solutions for this without me knowing it. We need detection and handling of environments. It could look like:

```js
environment.isBrowser = function () {
  return typeof window !== 'undefined';
};
environment.isNode = function () {
  return typeof window === 'undefined' && typeof process !== 'undefined';
};
environment.isWebWorker = function () {
  return typeof self !== 'undefined' && typeof postMessage === 'function';
};
// ... detect whether running in a node.js child_process
// ... detect whether running a native web application like Cordova
// ... detect whether running on desktop or on a mobile device
// ... detect what type of browser (Chrome, FF, IE, ...)
// ... detect the browser version or node version
```

This module should of course be published as an [UMD module](https://github.com/umdjs/umd). Suppose we have an http library with an implementation for the browser (`myModule.browser.js`) and node.js (`myModule.node.js`), the module could expose it's main file, `index.js`, like:

```js
module.exports = environment.isNode()
    ? require('./myModule.node.js')
    : require('./myModule.browser.js');
```


### Bundling for the browser

Suppose that modules are distributed as a single, universal implementation, containing multiple implementations for different environments. When bundling an application for use in the browser, the parts of the code not relevant for the browser (i.e. implementations for node.js) should be removed.

Tools like [browserify](http://browserify.org/), [webpack](http://webpack.github.io/), and [uglifyjs](https://github.com/mishoo/UglifyJS2) are typically used for bundling and minification of browser apps. When bundling an application, it is possible to configure specific modules to be excluded from the bundle. This mechanism could be used to exclude environment specific modules without forcing the end-user to specify them one by one. When all environment specific code uses a suffix, it would be easy to filter away these files from an application bundle. Files could be named like:

```
// apply suffixes for files only relevant for a specific environment:
myModule.node.js      // node.js, io.js
myModule.browser.js   // browsers: Chrome, FF, IE, ...
myModule.native.js    // native web apps, Cordova, PhoneGap, ...
// ... more
```

To bundle an application with browserify, all you have to do is ignore all `*.node.js` files:

```
browserify myApp.js --outfile ./dist/myApp.js --exclude **/*.node.js
```

Note that such a solution will only work if every isomorphic module uses the same environment suffixes. There is a convention needed to let this be successful.


## Conclusion

There is a lot going on in the JavaScript world. Innovation is taking place at an incredible speed. It's hard to keep up with the latest trends. With the rise of node.js, JavaScript is becoming more and more ubiquitous. Two worlds, client and server side, are both powered by JavaScript. But common functionality such as networking requires the use of environment specific modules. Code cannot just be executed in both environments, which causes a split between the two worlds.

In order to ease full stack JavaScript development, we need to take away the hurdles keeping these worlds separated. We need to come up with unified, isomorphic solutions for common functionality like module loading (ES6 to the rescue), networking, background processes, logging, and others.

There are opportunities here. JavaScript is already going full speed. Let's ignite the after burners and go crazy.

_Update 2018-01-10: Replaced a broken link to an article about the CommonJS module system._
