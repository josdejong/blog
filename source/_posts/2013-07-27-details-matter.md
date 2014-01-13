---
layout: post
title: "Details matter"
date: 2013-07-27
comments: true
categories: [application, details, quality, user experience]
---

This is a theme which pops up again and again at the software projects I am working on.
I really liked this blog by Jeff Atwood in this regard, explaining
[all your app is, is a collection of tiny details](
http://www.codinghorror.com/blog/2012/05/this-is-all-your-app-is-a-collection-of-tiny-details.html).
Software which has not taken care of details right can be extremely annoying,
and vice versa, an application having its details right can be real joy to work with.

This article explains the importance of paying attention to details
in application development. This holds true for different different application
levels. The article discusses this in two sections:

- The first section explains the importance for the end users of your applications,
  and gives some practical tips to help you to achieve a better end user experience.
- The second section focuses on developing usable software libraries.
  This highlights the need to write readable and well documented code.


## End user experience

A decade ago people where used to adapting themselves to
the vagaries of software applications - they had no choice. This is kind of
the world up-side down: computers and applications should make peoples life
easier and more fun, rather than get into their way and regularly raise their
irritation level to dangerous heights.

Nowadays people have more choice, for example when it comes to smartphone apps.
The barrier to install and remove apps is very low, and the selection is huge.
If your app doesn't work exactly as a user wants or expects,
it will be immediately replaced by some other app who better understands what
the user wants. Users are very critical in that, which is healthy.
This forces app builders to deliver quality if they want to attract a large
user base.

Now what kind of details am I talking about?
Well, consider your own experience with applications.
Both desktop, web, and mobile apps.
What kind of things annoy you in the applications that you use?
Here a list with examples of details that strongly influence the user experience.
They are all very logic, but I see these kind of details being overlooked a lot,
even in professional applications.

- **Feedback**.
  When pressing a button, you want *immediate* feedback that the
  application is working on it. Pressing a button and having the application
  "do nothing" or even block completely is a terrible user experience.
  Most applications do not need to be blazing fast and be finished without
  missing a beat, but it is very important that they inform the user being busy.
  For actions that really take a lot of time, the application
  should also inform the user of the progress of the action.

  When developing an application, you typically work in a development environment
  with fast hardware and a fast internet connection.
  It is important to anticipate which actions may get slow when in a real world
  environment without fast hardware, fast internet, and with loaded servers.
  To be robust against this, it is wise to *always* give the user immediate
  feedback. Disable the clicked button, inform the user via a "loading..."
  message, and perform actions in an asynchronous, non-blocking way such that
  the user interface stay responsive all the time.

- **Navigation**.
  Applications are often build with one type of navigation
  in mind. However, more and more people are using differing devices
  to work with the same applications.
  Especially websites should reckon with this and make it easy to navigate
  in different ways: mouse, touch, keyboard.
  Keep in mind to have scrolling work smoothly both for touch as well as using
  the mouse wheel. Built in shortcut keys, so you can navigate with arrows
  for example. Things like quick keys can make it much more comfortable and
  efficient for users who use your application intensively.

- **Loosing data**.
  What is more annoying than filling out a large
  form, press the "Submit" button, getting back some weird error,
  and... having to fill out everything again?
  Or losing data from a document which you where editing when the application
  crashes, or when your internet connection goes down at an unfortunate moment.
  And what about accidentally doing something in an app and having no way to
  undo the action?

  I suppose everyone has encountered these situation.
  We are getting better at this though: more and more web applications take care
  of this now. Forms stay neatly filled and more and more applications
  automatically save your input, no longer relying on you pressing the "Save"
  button every now and then.
  A user should never have to worry about losing data.
  It is necessary to take this into account when designing your application.

- **Documentation**.
  Ideally, an application is self explanatory. A new user immediately knows
  how to use the application. Mobile applications typically have limited
  functionality, leaving no doubt on how to use the application.
  For larger applications, it is important to provide users with documentation
  in the form of tooltips explaining the behavior of buttons and menu items,
  helping the user along the way.
  As a last resort, an application should always have documentation explaining
  the functionality and the workflow in detail.

- **Design**.
  Design is not directly influencing the functionality which your application
  offers. It plays a large role though in how a user feels about using the
  application. Ensuring the application looks good makes the user feel that
  this is a professional, robust application.
  Which is probably is, because you appear to care for details.

All of these points of attention may sound trivial,
so why don't we just apply this?
Well, because it takes more time and is more complicated to reckon with all
of this when building an application.

Keep in mind though that you build an application to serve the user.
Force yourself to put a *little* more effort in ensuring a good user
experience. This can really make the difference,
resulting in lots of users actually enjoying using your application.


## Developer experience

On a different level, developers themselves are also encountering user
experience issues when working with libraries and frameworks.

Most programmers don't like commenting code and documenting their applications.
It is boring and takes a lot of time.
However, in order to make your work usable for others,
either as code or in the form of a library or framework.
You really need to pay attention to this.

- **Structure**.
  Your code should be well structured and neatly commented. Regularly take
  time to clean up redundant parts of the code.
  Ensure your API's stay consistent.
  Don't be afraid to refactor code to improve readability and clarity.
  Don't use dirty tricks which are hard to understand for others.
  Keep in mind that you only write the code once, but it will be read often.
  Spending a little extra time to make your code better readable and
  maintainable will most likely pay of, not only for others but also for
  yourself.

- **Documentation**.
  The more developers use your work, the more it will pay of to spend some
  effort on documenting your library.
  Suppose you don't document your work. Then *each* developer starting to
  use your library may have to spend a couple of hours (and a lot of frustration)
  to dig in your undocumented code and search the web for examples and help.
  When spending a few hours to document your code, you will save each of these
  developers a couple of hours work. This, ultimately, will save us together
  a lot of time which we can spend doing actual work.

  And no, now and then exporting your code as JavaDoc is not enough.
  Good documentation consists of the following parts:

  - A high level overview of how your library works, how all parts fit together,
    explaining the flow of the program.
  - A set tutorials, helping a developer to get up and running with your stuff.
  - A set of examples, demonstrating how to use your library in practice.
  - Detailed documentation describing the API's of your library.
    These docs should be easy to generate when you neatly document your code.

  <p></p>

- **Setup**.
  A library or framework will not gain much traction when the process to get it
  up and running is a 14 step process which takes hours and requires a lot of
  knowledge and pre-conditions.
  It should be a no-brainer to get your library up and running.
  If not, developers will give up and find themselves an alternative which
  actually does come with good documentation and an easy setup.
  Writing a getting started tutorial helps a lot making clear what an
  installation exactly needs.

  When your library is complicated to get up and running,
  this may be a sign that something is wrong. If that is the case,
  take a step back and figure out what makes it so complicated.
  Eliminate these complex requirements and ensure a smooth first experience
  with your software.

You can be a brilliant programmer and write genius pieces of code.
However, if you don't make your work accessible and usable for others, your
code will most likely have a limited use, and will die as soon as you're no
longer in the neighborhood to baby-sit and maintain it.
Put a little extra effort in documenting your code and make it easy for other
developers to get started with your code. This will drastically increase the
applicability of your code, and makes the life of developers much more fun.

I'm sure you prefer to use applications and libraries which are well documented
and supported, so take these as an example when writing your own.
