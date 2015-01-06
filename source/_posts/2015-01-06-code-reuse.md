---
layout: post
title: "Reusable software? Just don't write generic code"
date: 2015-01-06
comments: true
categories: [reuse, genericity, modularity, composability, coupling, cohesion]
---

It may be the holy grail of programming: writing reusable code. Not getting stuck by inventing the wheel again and again, but moving forward and building on top of what has been done. Looking at what we do today, we still haven't really figured this out.

So you are writing a software library. You had a great idea for a simple, broadly applicable solution. You have cooked up a nice API and are happy with the result. Then, new features are needed. The library grows and grows, and becomes extremely versatile. To account for more and more specific cases though, the API grows at a disproportional rate. Due to this feature creep, soon there isn't much left from your initial, beautiful API. At some point it becomes almost too complicated to work with the library due to all configuration options and edge cases.

Then, a new, fresh alternative arises and moves your library into oblivion. This new library is awesome. It doesn't suffer from a bloated API, it just works. It does more or less the same as your library but is faster and easier to use. Over time though, this new library will go through the same cycle as yours. It gets bloated too and will be replaced with something fresh at some time.

What went wrong?


## Generic solutions

In the quest for writing reusable software, it's a common mistake to make software *too* generic. To build a single, uber flexible, monolithic solution which is applicable in an extremely broad range of use cases and environments. Being generic is a basic requirement for reusable software. However, making software too generic causes it's usability to suffer.

When a piece of software grows too large, it becomes bloated. Besides having a negative impact on the performance, the software typically becomes more complicated to use. The component will have a more extensive API and configuration. This requires more knowledge on the clients side, and makes debugging harder as more things can go wrong. Developing and debugging the component itself becomes harder as one needs to account for more and more edge cases. Summarizing, we can say:

> Maximizing genericity complicates use

Besides negatively affecting the usability, being too generic can also hurt the reusability. Having a broader API and requiring more configuration results in a higher "contact surface" or coupling between the component and the application. This makes it harder to move the component to an other application for reuse.

Making your software too generic can make it too complicated to use. This can result in the software not being used at all, defeating the original goal of writing reusable software.


## Reusable software

How to write reusable software then? Don't write a single monolithic solution that will solve all problems. Instead, write small, composable, focused components.
Components that just do one thing and stick with it ([single responsibility principle](http://www.wikiwand.com/en/Single_responsibility_principle)). Components that are loosely coupled and have a concise API. This is one of the basic fundamentals in software engineering:

> Reusable software requires loose coupling and strong cohesion

Writing small components will give your software a high chance of survival: all individual components are easy to use and understand, and are usable on their own in various use cases. When one of the component gets outdated, it can be replaced relatively easy as the components doesn't have a high coupling with each other.

It's hard to find the right boundaries and granularity for components. You don't always get it right the first time. And when software grows over time, it will be necessary to reorganize, split, and refactor components in order to keep them focused. Don't be afraid of refactoring. This is necessary to keep your software healthy in the long run, as opposed to killing it off because of overweight.

A great source of inspiration to me is the [Node.js](http://nodejs.org/) community, which seems to have small, composable components in their DNA. It's like LEGO. It's the [Unix philosophy](http://www.wikiwand.com/en/Unix_philosophy):

> Favor composability over monolithic design

The flexibility and non-strictness of JavaScript helps a lot in this regard. It's interesting to see the recent interest in functional and reactive programming in the JavaScript community. These paradigms can help a lot in writing loosely coupled, reusable code. Also, the trend towards [micro service architectures](http://martinfowler.com/articles/microservices.html) looks promising.


## Pitfalls

There are a couple of common patterns which are good in itself, but can easily be used the wrong way, adversely affecting the (re)usability of code. Let's have a closer look at two of them: abstraction layers and inheritance.


### Abstraction layers everywhere

An important ingredient for reusability is separating interface from implementation. That way, implementations can be replaced without the need to change the clients code. The Gang of Four writes in [Design patterns](http://www.wikiwand.com/en/Design_Patterns):

> "Program to an interface, not an implementation."

Abstracting from implementations is a great solution when applied in the right cases. For example when using an ODBC driver to communicate with different types of SQL databases without having to write database specific code.

Especially in the Java world, I see a tendency to overuse and misuse this type of abstraction via interfaces. In order to "decouple" from any third party library, one might create an abstraction layer consisting of an interface and wrapper classes around this library. It's as if some Java programmers don't dare to make *any* concrete choice, and want to be able to replace *everything* without having to change *anything* in their code. Therefore, they introduce lots of abstractions and plenty of configuration. This results in very generic code, not bound to specific implementations. It may look like a great, generic, reusable solution. In practice however, these solutions are easily too complicated to be usable at all.

As Mark Seeman puts it in his blog *[Interfaces are not abstractions](http://blog.ploeh.dk/2010/12/02/Interfacesarenotabstractions/)*:

> "Do you extract interfaces from your classes to enable loose coupling? If so, you probably have a 1:1 relationship between your interfaces and the concrete classes that implement them. That's probably not a good sign, and violates the [Reused Abstractions Principle (RAP)](http://www.codemanship.co.uk/parlezuml/blog/?postid=934)."

Do not introduce an abstraction layer unless it is clear that you will have multiple implementations ([YAGNI principle](http://www.wikiwand.com/en/You_aren%27t_gonna_need_it)).


### Excessive use of inheritance

Inheritance is a great way to extend a class with extra functionality. In the Java community, inheritance is used excessively. Java offers a single inheritance model, where classes can only inherit from a single super class. It's not uncommon to see inheritance levels of six or even more classes, which is absurd. De Gang of Four describes the danger of overusing inheritance in [Design Patterns](http://www.wikiwand.com/en/Design_Patterns):

> "Because inheritance exposes a subclass to details of its parent's implementation, it's often said that 'inheritance breaks encapsulation'."

Inheritance causes a high coupling, as the superclass exposes it's internals to subclasses, and the subclasses are depending on external functionality offered by the superclass. This makes it hard to change the superclass without breaking the functionality of its subclasses.

Daniel Pietraru clearly explains the difficulty with inheritance in *[No, Inheritance is not the way to achieve code reuse](http://littletutorials.com/2008/06/23/inheritance-not-for-code-reuse/)*:

> "Inheritance, while a very powerful tool, it is very hard to use right. While the rule of thumb - use inheritance for 'is a' relationships and composition for 'has a' relationships - is very true, applying it in non trivial situations is difficult and wanders close to philosophy. Think about this question: 'Is an CircusDog a Dog or maybe CircusDog is just a role a Dog plays?'."

In general, inheritance should be used only when:
- One class is an extension of another class, reusing most of the code of this class and adding some new features to it.
- Two or more classes are very similar and share a large part of code, which can then be moved into a superclass used by all of them.


## Conclusions

Writing reusable code is not about developing generic, monolithic all-rounders. The key to writing reusable code is to write focused, composable components with a high cohesion and loose coupling.

Keep your code sanitized. Replace outdated components. Don't be afraid to refactor when needed. Be careful to use patterns like interfaces and inheritance proportionally, do not overuse them. Strive for writing focused components with a low complexity: easy to understand and easy to maintain.
