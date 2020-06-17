---
categories:
- api
- complexity
- flexibility
- simplicity
comments: true
date: "2014-10-18T00:00:00Z"
title: The art of creating simple but flexible APIs
url: "blog/2014/10/18/the-art-of-creating-simple-but-flexible-apis/"
---

A while ago I read the blog post [Ranging Near and Far](http://fr.umio.us/ranging-near-and-far/) by Scott Sauyet. On [Echo JS](http://www.echojs.com/), Scott titled a link to this blog *"Choosing simple APIs over flexible ones"*. This title suggests that you have to choose between *either* simple *or* flexible APIs, which is a false dilemma. This got me thinking: What makes a good API?


## Flexibility

Scott discusses the API of the `range` function of [Ramda](http://ramdajs.com/) compared to that of [Underscore](http://underscorejs.org/). Where Underscores `range` supports optional start (defaulting to zero), custom step size, and a negative step, Ramda's range "only" supports a step size of 1 and does not allow to omit the start value. While Underscores implementation is more flexible, Scott argues that Ramda's more limited implementation may be the better choice because of its simplicity. Scott suggests that it is way more complicated to use Underscores `range` because of it being more flexible. Scott has an argument here, but there are more factors determining how easy it is to use an API.


## Simple != limited 
 
It is important to distinguish simplicity from being limited. Simplicity is the opposite of complexity. The complexity of an API can be measured by the [cognitive load](http://en.wikipedia.org/wiki/Cognitive_load) it requires to use the API. This cognitive load is determined by:

- **Compactness**   
  Count the number of functions and the number of parameters per function.
  This may be the hardest to get right. You have to find the right primitives to cover the APIs functionality in a compact way. The functions should be as "orthogonal" to each other as possible, not overlapping in functionality.

- **Verbosity**  
  Common scenarios should be easy to do, verbosity should be minimal there. Ideally, the verbosity and complexity should grow linear when using more advanced features.

- **Consistency**  
  All functions of the API should have consistent naming, and the function signatures should be consistent.

- **Appropriate function naming**  
  Shorter function names are easier to remember, though too short function names can become meaningless. Finding good names may be one of the most difficult things in software development and it's importance should not be underestimated.

- **Adhere to common practice**  
  The API should ideally work similar to other (comparable) APIs where the audience is familiar with.

- **The number of different ways you can call an individual function**  
  The less different signatures a function accepts, the easier it is to recall it's functioning.

The importance of these factors depends on the application and the situation. In established environments, adhering to common practice is very important, even at the expense of consistency. In others cases, consistency or compactness may be decisive. Together, these factors determine the complexity of the API as a whole, and thus how easy it will be for a user to work with it. 


## Practical tips

Creating simple, powerful APIs requires a lot of practice. There is no magic formula, but here are some practical tips:

- **Limit the number of parameters of a function to 3 or maximum 4, use an object if you have more**  
  If you have to pass more than 4 parameters to a function, it's not easy to see which argument corresponds to which parameter. You can accidentally forget one argument, causing all arguments matching the wrong parameter. 
  Take a at the signature of the [`CreatWindowEx`](http://msdn.microsoft.com/en-us/library/windows/desktop/ms632680(v=vs.85).aspx) function of the C++ Win32 API, which requires 12 (!) parameters:
  
  ```c++
  // BAD: way too many parameters
  HWND WINAPI CreateWindowEx(DWORD dwExStyle, LPCTSTR lpClassName, LPCTSTR lpWindowName, DWORD dwStyle, int x int y, int nWidth, int nHeight, HWND hWndParent, HMENU hMenu, HINSTANCE hInstance, LPVOID lpParam);
  ```

  Instead of having an endless list with parameter, pass a single object with named parameters instead. Take a look at the [`ajax`](http://api.jquery.com/jquery.ajax/) function of jQuery:
  
  ```js
  $.ajax({
    type: 'POST',
    url: '/rest/user',
    data: { name: 'John', location: 'Boston' },
    dataType: 'application/json'
    success: function () {...},
    error: function () {...},
    // ... and much more (optional) parameters ...
  });
  ```

   This function has 30+ parameters, but this is no problem at all: normally you only need to provide a few of them. Passing an object holding all parameters has a couple of advantages:
   
   - By looking at the code, you immediately see which parameter the arguments represent.

   - No need to pass `null` or `undefined` for optional parameters. Instead, most parameters are optional and have a good default value, so for common scenarios you will have to provide only a few parameters.

- **Support granularity in options**  
  Sometimes a specific feature has a set of options related to just this feature. These options can be put in a nested object. For example, one parameter can support both a boolean to enable/disable the feature as a whole, or accepts an object allowing to specify detailed options for this feature.
  
  ```js
  // completely disable a feature
  simulation.run({
    animate: false
  });
  
  // enable a feature, use default configuration
  simulation.run({
    animate: true
  });
  
  // enable a feature, custom configuration
  simulation.run({
    animate: {
      duration: 3000,
      renderer: 'webgl',
      ...
    }
  });
  ```
  
  Or another example:
  
  ```js
  // specify one color for all headers
  draw({
    color: 'gray'
  })
  
  // specify different colors for individual components
  draw({
    color: {
      h1: 'gray',
      h2: 'darkred',
      h3: 'gray',
      default: 'black'
    } 
  })
  ```

- **Too long function names may indicate a lack of abstraction**  
  If you find yourself giving functions long names, and cannot shorten them without loosing their meaning, this may be a sign that you have to rethink your API. It can be the case that the API has too many functions and needs to be split out in multiple small APIs on different layers:
   
  ```js
  // BAD: a verbose API due to lack of abstraction
  app.createUser(...)
  app.updateUser(...)
  app.deleteUser(...)
  app.createProduct(...)
  app.updateProduct(...)
  app.deleteProduct(...)
  ...
  
  // GOOD: split in multiple smaller (and trivial) APIs
  app.user: User
  app.product: Product
  
  User.create(...)
  User.update(...)
  User.delete(...)
  
  Product.create(...)
  Product.update(...)
  Product.delete(...)
  ```
  
  It may also be the case that functions can be bundled together into a single one with an extra option:
  
  ```js
  // BAD: too specific functions
  app.createCustomer(...)
  app.createEnterpriseCustomer(...)
  app.createStudentCustomer(...)
  
  // GOOD:
  app.createCustomer({
    type: 'normal'    // Choose from 'normal', 'enterprise', 'student'
    // ... other arguments
  })
  ```

- **Create an open, flexible API**
  It's tempting to create "controlled" APIs where you control exactly what a user can input. Trying to control this easily results in a limited, closed API. For example the following function may look easy and quite flexible:
  
  ```js
  customers.find({
    name: string, 
    profession: string, 
    city: string
  })
  ```
  
  But this API is limited to a few hardcoded properties. The following approach is much more flexible, and probably easier to remember:
  
  ```js
  // functional approach: callback function to filter customers
  customers.find(function (customer) {
    // ... full freedom to match a customer against any criteria
    return customer.name == 'John';
  });
  ```

  Note that this second approach requires `Customer` to have a public API, which may be a good thing anyway.

- **Adhere to common practice**  
   If you create a function `range(start, end)`, it is a good idea to exclude `end`. If you create string or array manipulation functions, it's a good idea to keep the indexes zero-based. Why? Because all existing (JavaScript) native functions and modules do it like that. You will cause a lot of trouble for your users when deviating from these kind of common practice.

- **Internal and external API**  
  Typically, a module exposes a small part of the internal API as public API. If you see that the public API is totally different from the API used internally, you may need to rethink the API. Users will start asking for features resembling the internal API that you use yourself. Users want to be just as close to the metal as you yourself.

- **Prevent feature creep**  
  All modules start out with a cozy and simple API. But as the module matures, the API grows, and there is the danger of "feature creep". In the end, an API may be so bloated that it's hardly usable for the average user. To prevent this, at some point the module needs get an extensible architecture: A limited core, enriched with a set of extensions. This extensibility allows users to build custom solutions for their specific needs on top of it, instead of demanding all kind of exotic features to be built in the main product.

- **Write documentation and examples**  
  By writing docs you will see whether the API is consistent and easy to explain. Writing examples helps a lot in figuring out whether your API works as nicely as you thought beforehand. Main purpose of docs and examples are of course getting your users up and running with your software as smoothly as possible.

- **Look at APIs of popular modules**
  Study the APIs of popular modules to see how they do things and why. One of the reasons they have become the most popular of their kind will be that they have a great API.


## Conclusion

The complexity of an API can be measured by the cognitive load it requires to use the API. Factors determining the cognitive load are compactness and consistency of the API, verbosity in common use cases, right function naming, and whether they follow common practice. Depending on the goals of a library, authors may come to different conclusions for similar functionality, like different choices made for the `range` function by either Ramda and Underscore.

Learning to write APIs which are both simple and flexible requires a lot of practice and takes a life time. Learn from the APIs of popular modules. Pay attention to details in your own APIs. Keep rethinking your API, keep trying to get things more and more logic, consistent, and concise. Watch for feature creep. Aim for an open, extensible API.
