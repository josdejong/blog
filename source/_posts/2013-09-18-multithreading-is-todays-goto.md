---
layout: post
title: "Multithreading is today's GOTO"
date: 2013-09-18
comments: true
categories: [multithreading, concurrency, asynchronousity, parallelization]
---

Ask any programmer to the worst bug he ever encountered and you will very likely hear a [terrible story](https://brendaneich.com/2007/02/threads-suck/) concerning multithreading and data locks. Or maybe an issue around memory corruption or memory leakage. Two topics which are apparently hard to master for us programmers.

The latter case, memory corruption, is becoming less and less of a problem, as most modern languages come with automatic memory management. Most people see this as a step forward: it saves us a lot of trouble and results in more robust applications. Multithreading on the other hand is seen as something obvious and essential. Even more, programming languages which don't support multithreading are seen as inferior and immature.

Why is it that we hold on so strongly to this multithreading paradigm while it gives us so much trouble? Are we too proud to acknowledge that we are not capable of taming this multithreaded beast?


## What is wrong with multithreading

I work a lot with Java. Java is very proud on the solutions it offers for concurrency, multithreading, and resource locking. And yes, they work great... if you apply them correctly and consistently everywhere in your application. And that is where the fundamental problem with multithreading lies: when you write code, it is *not* thread-safe by default. You have to take explicit actions to make your classes robust against a multithreaded environment. And when doing maintenance in a later stage, you need to be careful to keep everything thread-safe. Making a class thread safe requires extra effort and worsens performance, so there is no incentive to apply thread-safe patterns by default.

Doing multithreading right requires in-depth knowledge of all components that you interact with. In large, real-world applications, it can be hard to figure out which code and which third party libraries are thread-safe and which don't. It isn't trivial to make the whole thread-safe without introducing dead locks or other issues.

Multithreading is very error prone. It goes wrong *unless* you take careful safety measures. And when it goes wrong, it's incredibly hard to debug. Multithreading is easy in theory, but [practice](http://blackhole12.blogspot.nl/2012/05/multithreading-problems-in-game-design.html) shows differently.


## The case for singlethreaded applications

When starting to program JavaScript, coming from a Java or C background, you may notice a deafening absence of complexity. Part of this is because JavaScript is singlethreaded. You just don't-have-to-worry about data corruption as your application just can't manipulate the same data simultaneously from multiple threads - there *are* no multiple threads. It's an incredible relief not having to reckon with these issues. Instead, you can focus on the actual logic you want to build around your data.

Why is it that JavaScript is so strong in dealing with asynchronousity? Common JavaScript and Node.js patterns use asynchronous callback functions, timeouts, and alike. The reason that this works so easy and naturally is because JavaScript is singlethreaded. It wouldn't have worked if JavaScript had been multithreaded. That would result in a terrible mess of locks on the data shared between all these callbacks. This may be the reason why these kind of powerful concurrency patterns are not used a lot in languages like C++ and Java: these languages just aren't very suitable for asynchronous programming.

The point here is: a singlethreaded application just works *without* you having to take safety measures to protect your data. You *can't* screw it up. You can do as complicated things as you like, even so complicated that you don't understand it yourself anymore. But you simply can't get your data corrupted.


## Yeah very funny, but I just need multithreading

It's just plain stupid to have an application doing all work in a single thread. Any single CPU-heavy request will completely block the application. You remember these websites where you press a button and the complete browser freezes because JavaScript needs to do some work?! That's thanks to JavaScript being singlethreaded you know...

Well, what you need isn't multithreading per se. What you *do* need are solutions for concurrency. However there are other models to deal with [concurrency](http://en.wikipedia.org/wiki/Concurrency_\(computer_science\)) besides multithreading and resource locking. Typical models used in JavaScript and Node.js are:

- **Message passing between isolated processes.**
  JavaScript supports [web workers](http://en.wikipedia.org/wiki/Web_worker) in the browser to do CPU intensive tasks in the background.
  In Node.js you typically spawn [child processes](http://nodejs.org/api/child_process.html) which interact with the main process via message passing.
  Note that the client/server model itself is a message passing solution as well: the client offloads work to the server side, and they interact with each via other HTTP requests.

- **Splitting a long running computation in small pieces.**
  To keep a singlethreaded application responsive, you can partition long running computations into many small parts. The parts are executed one by one with a short timeout between them, to give the application space to process other events. The size of the parts can be determined by a fixed amount of work, or by a maximum amount of time which the calculation may block the application.

These solutions require a different way of thinking and modelling than multithreading and resource locking. My experience though is that modelling your application in separate, isolated parts (or as [actors](http://en.wikipedia.org/wiki/Actor_model)) results in a very clear and natural separation of concerns. This is beneficial to the overall architecture of your application.


## How to utilize multi-core processors then?

One concern with single-threaded applications is that they can't utilize a multi-core processor. This is a currently active discussion: what programming paradigms are suitable to utilize multi-core architectures? And no, multithreading is not the solution. Multithreaded applications don't magically solve the [multi-core dilemma](http://www.flowlang.net/p/solving-multicore-dilemma.html). The solution involves modelling your application in a way that allows for parallel processing.

I don't have a ready made solution for this multi-core problem. I'm convinced however that dealing with multi-cores should be abstracted away from the developer. Similar to GPU's which do most graphics processing in parallel without us having to worry about that.
 All the developer should have to worry about is modelling his application in a parallelizable way, and the programming language should ideally facilitate this. Not you, but the virtual machine running your application should worry about the (multi-core) hardware.


## An analogy with the beloved GOTO statement

There have been long and heated discussions in the past on whether the [GOTO](http://en.wikipedia.org/wiki/Goto) statement is good or bad. It's incredible powerful, and quite a logic statement for everybody with a background in assembly. At the same time, using GOTO can very easily lead to [spagetti code](http://en.wikipedia.org/wiki/Spaghetti_code). Nowadays, GOTO is considered harmful by most, but it wasn't at that time. Luckily, smart people came up with a completely different paradigm: structured programming. Modelling your application in separate subroutines. This offered a solution on a different abstraction level than the GOTO statement. One which was even more powerful, and made the GOTO statement redundant.

I believe that you can compare multitreading with the GOTO statement. At least how multithreading is implemented right now. It solves a serious need: we need solutions for concurrency. However, it is not the right solution for the problem. It introduces so many troubles that, as with GOTO, we can consider this a harmful paradigm which must be avoided. We are a little bit late to fulfill Steve Yegge's [prediction #3](https://sites.google.com/site/steveyegge2/ten-predictions), but better late than never.

We should start thinking about better solutions for concurrency instead of multithreading. No, maybe not. The solutions are probably already there. Obviously, they will require a completely different way of modelling our applications. But all we have to do is realize that multithreading really sucks, stop torturing ourselves, and start using some of the other excellent solutions out there.
