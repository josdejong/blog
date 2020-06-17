---
categories:
- maintainability
- simplicity
- complexity
- code
comments: true
date: "2020-06-17T01:00:00Z"
title: How to keep your code simple and maintainable
draft: false
---

When developing a new application, your code base starts small and simple. Over time, your code grows and becomes more complex. It can be hard to fight complexity and keep a code base maintainable in the long run. Here some principles that help me with that.


## Recon with the cost of maintaining code, not just the cost of development

When buying a car, it's quite easy to reckon with both the cost of the one-time purchase as well as ongoing costs like fuel, taxes, and maintenance. You can calculate the impact of choosing this bad-ass, inefficient car over a small, efficient car in the long run. For some reason, in software development we mostly calculate the costs of developing a new feature only, and tend to forget that every new feature has an impact on the complexity and maintainability of the code, resulting in a "tax" on all future changes in this code base.

When a user comes with a feature request, the easiest thing to do is "just" build it. However, in the long run your code base can easily end up as a bloated, unmaintainable patch work. It's important to weigh the value that a new feature brings to the customer against the cost of software development _and_ maintenance. It's important to keep an eye on the bigger picture. With every new feature, think through how this impacts the code base. If it doesn't fit in nicely, take a step back and think through the options you have and what this will mean for the code base as a whole in the long run. 

Accepting all feature requests as-is will turn your software into unmaintainable bloatware over time. So, be really careful what to implement. Keep a clear focus. And dare to say no when features are out of scope or not worth the effort.


## Don't see feature requests as a given, challenge them

When a new feature doesn't fit nicely in the current architecture, or isn't really in the scope of the application, it can help to challenge the feature request itself instead of seeing it as a given. What problem does the feature solve? How does this fit in the way users normally use the application? Is it a core feature for the user or a nice-to-have? Is it relevant for _all_ users or just a few? 

Asking these questions can lead to new insights. It can be that the feature turns out to be not really needed after all. It can turn out that there was a need hidden behind the feature request which can be addressed with a _different_ feature. It can be that the original feature falls apart in two smaller, easier to implement features which are better aligned with the architecture you have.

One example: for one of our customers we have a table showing prospects that are sent in. A feature request was to be able to more clearly see which of the prospects were sent in today, which ones are from yesterday, or from last week, etc. Similar to how emails in a mail application can be grouped together based on their date. Building this feature can be done, though in this specific case it was relatively complicated since besides sorting on date, the table has prospects sorted by favorites first, and hidden prospects last. So you have to do some smart things with grouping. However, after more discussion together with the customer we figured out that the underlying question was: "I'm only interested in the prospects sent in today". So in the end, we created a simple filter option that allows you to see only prospects of today or see all prospects. The code to achieve that was _very_ simple, and it did fit perfectly as an extension of the filtering options that were already in place.


## Start simple, build an evolvable architecture

It can be tempting to think through the whole architecture beforehand in detail, and directly set up the right architecture and abstractions so you can go full speed ahead from that moment. However, often, you're building an application or a feature that hasn't been built before, and there are simply a lot of unknowns. And besides that, requirements itself can change during the process, and the outside world isn't frozen either: new technologies arise whilst others retire. There is a serious risk of choosing an architecture that turns out to be a very bad fit in the end. A mis-fitting core architecture is very hard to revert, so it is good to be a bit cautious against overengineering your architecture in an early stage. 

Often, only once you actually build an application you figure out how to best build it. I found the talk ["Good Enough Architecture"](https://www.youtube.com/watch?v=PzEox3szeRc) by Stefan Tilkov really really inspiring, it resonates with me. Instead of trying to control and think through everything up-front, accept that software and circumstances will be constantly changing. Don't try to come up with the perfect architecture upfront, but create an architecture that can easily evolve with changing circumstances.

How to do this practically? Build the simplest thing that will work ([KISS](https://en.wikipedia.org/wiki/KISS_principle)), and keep the [YAGNI](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it) principle in mind. Only start creating abstractions once the code starts hurting to maintain or extend further. As soon as you see yourself repeating a piece of code more than two times, it's time to see if you can create an abstraction to reuse the code. At that point, you don't have to guess what a suitable abstraction will be, since you have your use case right in front of you. Pay attention to decoupling components and technology in such a way that it is easy to replace a single component or technology (like a login screen, a date picker library, database, or your authentication solution). Ask yourself the question: if I make the wrong choice here, how hard is it to replace it with something else? If the answer is "easy", you can just go ahead. If the answer is "hard", it's a sign to think this through twice, and see if you can somehow decouple this to reduce risks and lock-in. Use plain data structures and pure functions as much as possible, these constructs are timeless and will survive everything.


## Recognize accidental complexity

Now this is not a trivial one, there is not a formula you can apply to recognize accidental complexity. This requires experience. It is important though to get a feeling for accidental complexity. You can distinguish between two types of complexity: [accidental complexity and essential complexity](https://en.wikipedia.org/wiki/No_Silver_Bullet). Essential complexity is the absolute minimum complexity required to create certain functionality. Accidental complexity is extra complexity that we add ourselves due to choices of certain patterns, frameworks, or libraries that we selected. 

Techniques that help me reduce complexity are declarative and [functional programming](https://codeburst.io/functional-programming-in-javascript-e57e7e28c0e5), and choosing [composition over inheritance](https://en.wikipedia.org/wiki/Composition_over_inheritance). Use pure functions and immutable data as much as possible, but be pragmatic. Reduce the amount of stateful code by moving as much logic as possible into pure functions which are easy to test and to reason about.

When writing code, ask yourself whether the complexity of the code is in proportion with the complexity of what you try to achieve. If it's not in proportion anymore, it can mean that it is time for a refactoring, or time to look around for a library which neatly abstracts what you're doing. Take a step back if you have the feeling that the code becomes needlessly complicated. What helps me in this regard is having experience with different programming languages and frameworks. That makes you think: "this feels way too complicated, in programming language X this would require just a few lines of code. Is there another way?". It can help finding out of the box solutions if you're familiar with how things are done in other languages.


## Avoid using advanced language features

Sometimes you have to apply a hack or you come up with a very nifty solution to get something working. Whilst it's a kick to tackle a problem with a smart solution, these solutions are often on the edge of what libraries and code are intended to do. These hacks often come back to bite you one day in the future. The hack may suddenly stop working after updating a library. And it can be very frustrating to have to solve a bug in a piece of "very smart" but hard to understand code written by your colleague (or your former self).

Try not to use advanced features of your programming language, frameworks, or libraries. It will make your code more robust when you're not using cutting edge features. It makes the code easier to understand, there is less knowledge required to understand what's going on. In general, it makes your code also more powerful because it is easier to integrate with other libraries and tooling. This is more or less the idea behind the [rule of the least power](https://en.wikipedia.org/wiki/Rule_of_least_power).

As a small example: when you have certain data and related methods in your web application, you can implement classes with methods to deal with your data. This makes it very natural to work with the data. However, you can also choose to keep the data plain JSON, and create pure functions to work with the data. This removes a whole layer of complexity that you walk into when using classes: you don't have to write code to serialize and deserialize when loading data or persisting it. You don't have to do class conversions when interacting with libraries. Any component can deal with plain data without any extra steps needed.


## Keep an eye on where your architecture is heading

If you don't keep an eye on the architecture of your application, it will evolve like an unmaintained back-yard and becomes a luxuriant mess, a patchwork of styles and patterns. I want to keep my code bases clean and consistent, and I think everybody wants that. But for some reason it's very hard to achieve when software gets full grown. You learn new practices and sometimes want to replace libraries with better, newer alternatives. It's not always possible to apply changes to the whole code base in one go, so you end up with a hybrid of old and new. 

Having inconsistencies in the code base does not need to be a problem though. What is important is that you and your colleagues working on the code all are aware of and agree on the way ahead. If you know where you want to go, it is fine if you're not there immediately but go there step by step. Same holds for quick-and-dirty solutions. There are good reasons to do something quick-and-dirty, like doing functional validation before putting effort in a robust long-term solution. It is essential that it is clear for everybody what code is temporary or does do things the "old" way, and hence is meant to be replaced with something better.

I used to see building software like building a house. You make a plan, build the house, then it's done. This is not close to reality though. I heard a different comparison made by Sócrates Díaz a few years ago, which much is closer: [software is like gardening](https://dev.to/socratesdz/software-is-like-gardening-1bb0). "Software is not static, software is alive". It will never be perfect, it's always in flux. Keep an eye on it and make sure the changes you make go in the right direction. With every change you make, try leave the code behind in a _bit_ better state than you found it.
