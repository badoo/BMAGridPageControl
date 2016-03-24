[![Build Status](https://travis-ci.org/badoo/BMAGridPageControl.svg?branch=master)](https://travis-ci.org/badoo/BMAGridPageControl)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


##A different page control
![demo](/demoimages/demo.gif)

![demo2](/demoimages/demo2.gif)

Do you want to suggest to your users that they can do more than just scrolling? Enter BMAGridPageControl.

BMAGridPageControl is designed to be really similar to UIPageControl. You control it specifying a total number of items, and a current item. The control will highlight the current item as it was inside a grid.

###Testing

While developing this small control, we also wanted to check how you would apply TDD to it. We came out with a two-class implementation: A driver and the control itself. Check the sources and tell us what you think!

##Installation

###CocoaPods

Add the pod to your Podfile:

```ruby
pod 'BMAGridPageControl'
```

###Carthage

Add the repository to your Cartfile:

```Bash
github "badoo/BMAGridPageControl"
```

Then drag and drop the produced BMAGridPageControl.framework from Carthage/build

###Manual

Just drop into your project the files under BMAGridPageControl directory.

##License
Source code is distributed under MIT license.

##Blog
Read more on our [tech blog](http://techblog.badoo.com/) or explore our other [open source projects](https://github.com/badoo)
