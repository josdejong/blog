---
layout: post
title: "Static typing: the good parts"
date: 2016-06-05
comments: true
categories: [interoperability, scalability, static typing, dynamic typing, structural typing, nominal typing ]
---


<span style="font-style: italic;">
  <span style="font-weight: bold;">tl;dr</span>
  So far I've been hesitant to embrace static type checkers like TypeScript. It's because I associated static type checking with the restrictions and interoperability issues that I know from Java and C++. However, it turns out that TypeScript is different: it uses a structural type system rather than a nominal one, which eliminates these downsides. It gives us a way to describe data types without sacrificing flexibility, interoperability, or scalability.
</span>

## An uneasy feeling

Sometimes I have the feeling that I'm supposed to be averse of static typing in order to be a proper JavaScript citizen. I regularly hear people bragging about not needing it at all. And I have to say, I barely miss static type checking in JavaScript either: the cons are way bigger than the pros. Still, I miss static typing every now and then. That made me wonder, *what* is it about static typing that I miss?

The smell of static typing gives me an uncomfortable feeling. It reminds my of my hard-core Java time which was a continuous fight against the system: trying to get classes to play nice together. In Java, a lot of time goes into bookkeeping of classes and marshalling between them rather than developing actual application logic. So far I have been hesitant to embrace static type checkers like [TypeScript](https://www.typescriptlang.org/) or [Flow](http://flowtype.org/) which are built on top of JavaScript. I was afraid that the down sides of static typing would leak back into my applications again.

My first thought was: when I feel I need static typing in my application... it's probably a code smell. It means that the application has grown to large and complicated to easily keep in my head. I can "solve" this by using a statically typed language which allows me to reach a higher level of complexity before my head explodes. Or I can acknowledge that the application is just too complicated and refactor it into smaller, easier to understand chunks.

However, there is more to it. Static typing and dynamic typing are typically pitched against each other as two opposites. You have to choose one or the other. However, I'm convinced that there are *parts* of static typing which are harmful and *parts* that are useful. Let's figure this out.

## The bad parts

Let me try to explain the problem with static typing with a Java example. Suppose we create a function which calculates the distance between two points:

```java
class Point {
	double x = 0;
	double y = 0;

	public Point (double x, double y) {
		this.x = x;
		this.y = y;
	}
}

static double distance (Point a, Point b) {
	double dx = b.x - a.x;
	double dy = b.y - a.y;
	return Math.sqrt(dx * dx + dy * dy);
}
```

We can use it like:

```java
// OK
Point a = new Point(0, 0);
Point b = new Point(3, 4);
double d = distance(a, b);
```

Instead of a class `Point` we could better define it as an interface, that makes the `distance` function more flexible as we can create multiple classes implementing the same interface. In Java you can't define properties on an interface though, only methods, so we have to define getters `getX()` and `getY()` on the interface and the implementing classes:

```java
interface Point {
  double getX()
  double getY()
}

class Point2D extends Point {
	double x = 0;
	double y = 0;

	public Point (double x, double y) {
		this.x = x;
		this.y = y;
	}

	double getX () {
	    return this.x;
	}

	double getY() {
	    return this.y;
	}
}

// OK
Point2D a = new Point2D(0, 0);
Point2D b = new Point2D(3, 4);
double d = distance(a, b);
```

However, suppose we are using an external library which deals with points too. It will probably have it's own classes and/or interfaces for points, like:

```java
class ColoredPoint {
	double x = 0;
	double y = 0;
	String color = "black";

	ColoredPoint (double x, double y, String color) {
		this.x = x;
		this.y = y;
		this.color = color;
	}

	double getX () {
	    return this.x;
	}

	double getY() {
	    return this.y;
	}

	string getColor() {
	    return this.color;
	}
}

// FAIL
ColoredPoint a = new ColoredPoint(0, 0, "red");
ColoredPoint b = new ColoredPoint(3, 4, "blue");
double d = distance(a, b);
```

We *know* this class is compatible with our `Point` class. But the compiler doesn't agree.
We will have to write code to convert a `ColoredPoint` into `Point`, else the `distance` function doesn't accept it:

```java
Point2D convertToPoint2D (ColoredPoint point) {
    return new Point2D(point.getX(), point.getY())
}

// OKISH
ColoredPoint a = new ColoredPoint(0, 0, "red");
ColoredPoint b = new ColoredPoint(3, 4, "blue");
double d = distance(convertToPoint2D(a), convertToPoint2D(b));
```

Another common case is that we're just dealing with JSON data fetched from a server or database:

```java
// FAIL
JSONArray points = new JSONArray("[{\"x\":0,\"y\":0},{\"x\":3,\"y\":4}]");
JSONObject a = points.getJSONObject(0);
JSONObject b = points.getJSONObject(1);
double d = distance(a, b);
```

From a logical point of view you could argue that something like this could work. But from a Java point of view you of course know that it won't. Java strongly discourages working with "unstructured" data like JSON objects or arbitrary maps. The normal way of doing things is to parse JSON into Java classes like our `Point2D`.


Wrapping up, you will probably say that I just shouldn't do such things in Java. You are right, Java isn't made for that. What I observe here though is:

- Java cannot deal with data in a flexible way, it can only handle Java classes with methods (having data encapsulated). In practice, the most straightforward solutions are often to operate on data directly in a functional way, without class ceremony. Java is no good fit there.
- Java has serious cross-cutting concerns, which strongly hinders its scalability. If you have two different libraries each having their own classes and interfaces dealing with similar entities (like `Point`), they can't work together. You will have to do quite some plumbing to convert from one type to the other everywhere the libraries have to work together.

If you look at the original goal: a function which calculates the distance between two points {x,y}, you see that we have to jump through a *lot* of hoops and have to deal with serious limitations. This demonstrates the bad parts of static typing: it harms interoperability and scalability.


## The good parts

The good part of static typing in my opinion is that data types describe the intent of functions. They describe the input types that a function expect, and the output type that a function will return. This is very helpful and convenient, especially when working on a large application with a large team. For me, the most value is in *communicating* interfaces of functions and components between developers, not in statically analyzing correctness of an application or detecting type related bugs.

Let's see how the same code example we did for Java works out in TypeScript:

```js
interface Point {
  x: number
  y: number
}

function distance(a: Point, b: Point) {
  const dx = a.x - b.x
  const dy = a.y - b.y
  return Math.sqrt(dx * dx + dy * dy)
}
```

We don't need getters and setters in JavaScript, and can keep the interface a simple, straightforward data structure instead. Of course we *can* use getters and setters and other methods when needed, but we're not *restricted* here. You will see the impact of of using a simple data structure later on.

Next, we can create a class that implements the `Point` interface:

```
class Point2D implements Point {
  x: number
  y: number

  constructor (x: number, y: number) {
    this.x = x
    this.y = x
  }
}

// OK
const a = new Point2D(0, 0)
const b = new Point2D(3, 4)
const d = distance(a, b)
```

But we can also use a class that *implicitly* implements the `Point` interface, without even knowing it. There are no interoperability issues, the following class `ColoredPoint` is compatible with the interface `Point`:

```
// Note that the class ColoredPoint is totally unaware of `Point` and `distance`
class ColoredPoint {
  x: number
  y: number
  color: string

  constructor (x: number, y: number, color: string) {
    this.x = x
    this.y = x
    this.color = color
  }
}

// OK
const a = new ColoredPoint(0, 0, 'red')
const b = new ColoredPoint(3, 4, 'blue')
const d = distance(a, b)
```

We can also use plain data:

```js
// OK
const a = {x: 0, y: 0}
const b = {x: 0, y: 0}
const d = distance(a, b)
```

The reason that our function `distance` works with both `Point2D`, `ColoredPoint`, as well as with plain objects is because TypeScript uses a [structural type system](https://www.typescriptlang.org/docs/handbook/type-compatibility.html):

> Type compatibility in TypeScript is based on structural subtyping. Structural typing is a way of relating types based solely on their members. This is in contrast with nominal typing.

Not only TypeScript uses structural typing, similar initiatives like [Flow](http://flowtype.org/), [rtype](https://github.com/ericelliott/rtype) (and [JSDoc](http://usejsdoc.org/) for that matter) do the same. This is awesome! This is the best of both worlds: we can communicate interfaces with our fellow developers, get warnings when trying to call functions in incompatible ways, without sacrificing flexibility, interoperability, or scalability.

You might wonder why languages like Java don't use structural typing since nominal typing causes such interoperability issues. Well, the answer is simple: it's way more expensive to deep compare classes property by property than it is to compare a single memory pointer. Since Java has runtime type checking, the performance penalty is just too big. Languages like TypeScript only do type checking at compile time, so it's a non-issue for them.


## Conclusion

The experience I have with statically typed languages such as Java and C++ is that it gets in your way. It restricts you, forces you to write lots of boilerplate for simple classes and conversions between them. The reason is that these languages use a [nominal type system](https://www.wikiwand.com/en/Nominal_type_system), which compares classes by name. TypeScript on the other hand uses a [structural type system](https://www.wikiwand.com/en/Structural_type_system), which compares types by property. This does not cause interoperability issues between similar data types, and provides what we need most: a way to communicate the interface of our functions.

Of course there are more reasons to prefer a statically typed language. One is that "it saves you from a lot of bugs". Well, I don't recognize that advantage: as soon as you unit test your code, static type checking becomes redundant. More on this in a article published yesterday by Eric Elliot: [The Shocking Secret About Static Types](https://medium.com/javascript-scene/the-shocking-secret-about-static-types-514d39bf30a3).

I'm no longer in doubt whether I can happily use a static type checker like TypeScript without being dragged back into the restrictive, limiting environment that I know all too well from statically typed languages like Java. TypeScript and it's companions offer the best of both worlds.
