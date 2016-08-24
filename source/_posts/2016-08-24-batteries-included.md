---
layout: post
title: "Batteries included"
date: 2016-08-24
comments: true
categories: [libraries, composability, usability, configuration ]
---


<span style="font-style: italic;">
  <span style="font-weight: bold;">tl;dr</span>
  The JavaScript community is doing a great job in creating an ecosystem of highly  composable, configurable, and extensible components. Unfortunately, this has complicated usage of these components. It is time to focus on the user again. Deliver components with a good default configuration which matches the typical use cases, and ensure a gradual learning curve for more advanced usage of a component.
</span>


Latest years I see a trend in software libraries and frameworks that make me really happy: libraries have become more and more composable. npm modules in particular have always been small and composable. They support extension and customization via plugins. It's what makes it possible to combine tools like Gulp, WebPack, Browserify, Rollup, Babel, Mocha, Ava, React, Redux, Angular and many more in *so* many different combinations and configurations. This is awesome.

At the same time I see another trend that concerns me. In order to achieve this high level of composability and extensibility, libraries sacrifice easy of use. Before you can use a tool, you need to gain a deep understanding of the tool's configuration and ecosystem of plugins. Figure out how the configuration applies to your use case and how to combine it with other tools you're already using. The learning curve of tools are steepening. An example is [Babel](https://babeljs.io/): version 5 "just worked" right out of the box, but version 6 requires you to install and configure "presets" before the tool will actually do something. Another example is React, which is known for requiring a complicated setup before you can actually use it in your application (there is [hope](https://github.com/facebookincubator/create-react-app) though).

## Configurability does not necessarily yield a steep learning curve

Now you may think that more complicated setups are simply a consequence of the tools becoming more extensive. I challenge you to rethink this. I believe it's possible to make a library both flexible as well as easy to use.

How?

The first step is to come up with a flexible, low level API for the library. The second step is to think deeply about the typical use cases for the library, and provide the library with the right default configuration, matching the needs of the largest part of your user base so that they don't even have to do any configuration at all. The last step is to make it easy to update/extend the default configuration without having to write the configuration from scratch.

Libraries *can* work seamlessly out of the box. For example, Browserify automatically replaces node.js specific libraries with equivalents which work in the browser, you won't even notice that you have node.js specific dependencies which do not naturally work in the browser. And Webpack will bundle code containing dependencies using different module systems (commonJS, AMD, UMD, ES6 modules, ...) without the blink of an eye. Rollup on the other hand only supports ES6 modules out of the box, and is harder to use in a mixed environment. To be able to use CommonJS dependencies for example, you have to install and configure [a couple of plugins](https://github.com/rollup/rollup-plugin-commonjs#usage). I think this is an extremely common use case, and hope that Rollup will support this automatically some day in the future. From a purist point of view you may say that it's not a good idea to use mixed module systems and environments. But from a real world perspective it's just that way it works in practice, so you may better accommodate for it. If you don't, you saddle up a large portion of your users with the task to figure out how to solve this, again and again.


## Boilerplates are no solution

To relief us from configuration pains, we've seen a lot of boilerplates and generators popping up last year. We all do it: once we have a configuration that works, we copy it for a next project so we don't have to reinvent the wheel again. If we have a nice base setup, we can share it in the form of a boilerplate.

The problem with boilerplates is that they don't really solve the issue. They only postpone it. In first instance you have a working setup without any effort, but as soon as you have to change something or need to upgrade dependencies, you will still need to gain a full understanding of the setup *and* you have to understand why of the creator of the boilerplate did certain configuration in specific ways. This may be even worse than starting from scratch. My experience is that it's better to swallow the bitter pil immediately, just learn to understand the tools, and set up everything yourself.


## Configuration done right

A strong example of a library which got configurability right is [hammer.js](http://hammerjs.github.io/), a touch library for the browser. It comes with batteries included. Typically you don't have to do any configuration to get going. From [the hammer.js docs](http://hammerjs.github.io/getting-started/#usage):

> It’s easy to use, just include the library and create a new instance.
>
>     var hammertime = new Hammer(myElement, myOptions);
>     hammertime.on('pan', function(ev) {
>       console.log(ev);
>     });
>
> By default it adds a set of `tap`, `doubletap`, `press`, horizontal `pan` and `swipe`, and the multi-touch `pinch` and `rotate` recognizers.

This default configuration will probably serve 80% of the use cases, and these users do not need deep knowledge of the library before being able to use it.

If you have to make slight changes to the configuration, you can do so without losing the default configuration:

> The pinch and rotate recognizers are disabled by default because they would make the element blocking, but you can enable them by calling:
>
>     hammertime.get('pinch').set({ enable: true });
>     hammertime.get('rotate').set({ enable: true });
>
>  Enabling vertical or all directions for the pan and swipe recognizers:
>
>     hammertime.get('pan').set({ direction: Hammer.DIRECTION_ALL });
>     hammertime.get('swipe').set({ direction: Hammer.DIRECTION_VERTICAL });

Now we've caught say 90% of the use cases, and the users still have to do hardly any configuration for it, nor do they need to gain a deep understanding of the library.

If needed, you *can* go deeper and do advanced configuration or completely replace the default configuration:

> You can setup your own set of recognizers for your instance. This requires a bit more code, but it gives you more control about the gestures that are being recognized.
>
>     var mc = new Hammer.Manager(myElement, myOptions);
>
>     mc.add( new Hammer.Pan({ direction: Hammer.DIRECTION_ALL, threshold: 0 }) );
>     mc.add( new Hammer.Tap({ event: 'quadrupletap', taps: 4 }) );
>
>     mc.on("pan", handlePan);
>     mc.on("quadrupletap", handleTaps);

This ultimate configurability serves 100% of all use cases. It requires more effort and knowledge of the library, but gives you all flexibility you may ever need.


## Conclusion

Today's tools do a great job in offering flexible and configurable API's. This is not a matter of course, and I have great respect for the people managing to build such versatile tools working so nicely together in so many different environments.

I think though that we can go a step further in reaching out to the user. We have to provide a seamless out of the box experience for the typical use cases, without sacrificing configurability or flexibility. The API of a library should be "layered" and offer a gradual learning curve rather than a steep one:

- For typical use cases you can use the library right out of the box without having to do configuration.
- Applying some basic configuration should be easy and should not require to gain a deep knowledge of the library.
- For advanced use, the library allows to configure it's low level components as desired.

When writing a library, try to understand typical use cases of the library and streamline the API for these cases. Listen to feedback of users on how they actually use the library and what their needs and concerns are. Make life as easy as possible for the users of your library. Don't forget: without them your library has no reason to exist.
