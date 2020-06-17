---
categories:
- language
- paradigms
comments: true
date: "2014-01-13T00:00:00Z"
title: Shaped by the language you use
url: "blog/2014/01/13/shaped-by-the-language-you-use/"
---


A few months ago I did an astonishing discovery, namely how strong your solutions are shaped by the programming language you use, the language that lives in your head. The interesting thing is that I already *knew* this. But despite that, I hadn't expected this to be *so* incredibly influencing until I saw such a clear case of this in my own work.


## The right tool for the right job

First a short explanation of my programming background. I've experience with various Basics, C++, Java, Python, JavaScript, Matlab, and others. Experience with procedural languages, object oriented languages, prototypal languages. Strict and loosly typed languages. Compiled languages and scripting languages. Desktop, web, server, mobile. I have explored quite some corners of the programming universe, and the more I learn, the more I discover just how little I know...

When gaining experience with different languages, you discover that each language has its strong and weak sides. There is not a single language which is the ultimate solution for everything. That's why programmers tell you to 'use the right tool for the right job' rather than strive to find that one super-language. Which language is the best choice for a certain project depends on things like functional requirements, platform support, team experience, and more.

So far so good.


## Consequences of choosing a language

The choice for a programming language is quite determinative for how the application code will be structured. The language may be procedural, object oriented, event driven, prototype-oriented, functional, etc. Every language has its own paradigms, patterns, and best practices.

For example the strict nature of Java encourages you structure your code very well, create abstraction layers and use patterns like getters/setters and interfaces. This helps in keeping large projects scalable and maintainable directly from the start. On the other hand, the focus on structure has annoying side effects: lots of classes consisting mainly of empty getters and setters, over-abstraction which makes it hard to understand what is actually going on, a lot of marshalling of objects, etc. All of this can cause a lot of overhead over the actual contents of an application. it  can make an application rigid and adjustments cumbersome.

The opposite of the Java may be JavaScript, which is extremely unstructured and dynamic by nature. This encourages you to program in a flexible, defensive, and robust way, acting friendly and forgiving for (partially) wrong inputs. JavaScript applications are typically built up in a loosely-coupled and modular way, perfectly fitting in the continuously changing, dynamic environment of today's world. On the other hand, the lack of support for structure can easily result in archaic and unmaintainable code. A lot of discipline is required from the programmer to create and guard the needed structure and abstractions.

It is best to adhere to a language's best practices. When working in a team, one need to agree on code style and structure to ensure consistent code, and need to document the code. This helps making the application understandable and maintainable by others than just you.

The choice of language plays an important role in how your application will be structured. However, the choice of language may influence a lot more than just that.


## Shaped by your language

Where it is really becoming interesting is when realizing that a language not only is a matter of differing syntax, organization, library support, and tooling. It also strongly influences the way you solve problems and the type of solutions that you see.

You are not using a programming language 'just' to express *your* logic and *your* solutions. Rather, the solutions that you come up with are influenced and limited by the language that lives in your head. If you are used to an object-oriented language, you will think in a different way than when you are used to functional languages. These and other paradigms all offer a different solution-space. Some problems are easily described in an object-oriented way, others by taking an event-driven or functional approach.

How influencing a language can be became clear to me while developing a math application in my spare time. This application is basically capable of parsing and evaluating expressions. It supports complex numbers, matrices, units, and other advanced data types. I have built this application first in a Basic language, then in C++, then in Java, and finally in JavaScript.

The third iteration of the application, written in Java, had become really neat. It was well structured and had logical abstractions. All data types where classes extending a single base class `MathObject`. Functions too where created as classes extending a specific base class `MathFunction`. The function classes had an eval method with a specific signature, accepting instances of `MathObject` as arguments. Implementing a new function was really easy and robust: just implement eval functions for the supported data types, unsupported types where automatically dealt with by the extended base class. The expression parser generated a node tree linking these functions and arguments together. It was a closed and well controlled solution.

But then I decided to rewrite the whole application in JavaScript. Now that is quite a different story. JavaScript encourages you to create an open solution rather than closed, controlled solution. JavaScript is no strictly typed language, and you can call any function with any type and number of parameters. You can't control that. At first I thought this would complicate the application, having to do a lot of type checking in every function. But it turned out to give amazing opportunities. Rather than creating my own data types, I let the functions accept both JavaScript's primitives (Booleans, Numbers, Strings, and Arrays), as well as advanced data types (such Matrix and Complex). Having first class functions available was really an enormous advantage.

This open nature of JavaScript gave a great synergy between my application and JavaScript itself. The Java application was built *on top* of Java in a kind of closed, sandboxed environment, only accepting my own data types. The JavaScript version on the other hand was seamlessly integrated with JavaScript itself, embracing JavaScripts own data types and first class functions. This resulted in strongly reduced complexity, and an amazingly open solution, which because of this openness can be integrated seamlessly with other applications and libraries (no marshalling horror...).

I was really perplexed to see how influential a language can be on the architecture of an application. I have been thinking: what did I do wrong with the Java version? Well, I did too much in an object oriented fashion. And I wanted to control everything with my own classes. This object-oriented paradigm is the core of what Java is, but it turns out not to be the right solution for everything. Now, with this lesson learned, could I rewrite the application in Java with the simplicity it has in JavaScript? I think for an important part: yes. This is mainly a matter of thinking outside of the (Java) box, and not primarily about a limitation in the language itself (though I really miss lambdas...). A language seriously influences your way of thinking.


## Conclusion

There are many programming languages available. Non of them is perfect, each has their strong and weak sides. When starting a project, it is important to choose the right tool for the job: the language which best fits given functional requirements, platform support, and team experience.

The choice of language does not only determine syntax and tool chain though. It also strongly influences the way you solve problems and the type of solutions that you see.

When you are familiar with one language and one way of working, you may be blind for other types of solutions, which might have resulted in much simpler solutions. Even when you are familiar with multiple languages it may be the case that you - like me - always tend to stick to a few familiar patterns.

Be aware of the fact that the language that lives in your mind plays an important role in how you solve problems. Improve yourself by learning new languages, paradigms, and patterns. Dare to experiment, take time to build and compare prototypes following different paradigms and see how that works out for your problem. Every now and then this will lead to surprising results. It's just awesome to see a complicated problem being reduced to an elegant, straight forward solution when applying a well suited paradigm!
