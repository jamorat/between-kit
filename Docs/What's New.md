#What's New

###Overview

This document, as the title suggests, details what's new in the  `2.0.0` release of this codebase (`BetweenKit`) and how its moved on since the original `1.0.0` release (`i3-dragndrop`).

We've used the feedback that we've received over the past year to re-design the original `i3-dragndrop` helper and develop the concept into a fully-fledged user interface framework for iOS. An unfortunate caveat is that `BetweenKit` is completely backwards incompatible with `i3-dragndrop`, which has now deprecated.

Hopefully this guide will provide some useful pointers for migrating your codebase to the new release.

###Protocols

Originally, there was but 1 protocol: the `I3DragBetweenDelegate`. The design of this protocol was fraught with redundancy.

Well no more! We have 3 new protocols for you:

- `I3Collection`
- `I3DragDataSource`
- `I3DragRenderDelegate`

`I3Collection`s are the dynamic replacement for the old `dstView` and `srcView`s, which could only be either of type `UICollectionView` or `UITableView`. We've variablized the concepts of `dst` and `src` such that you can have any number of collections on your screen, and you can even implement your own. As long as they are of type `UIView<I3Collection>`, you're good to go.

By registering your collections with the `I3DragArena` in a particular order, you can also control their drag-and-drop priority.

__This resolves: #5, #6, #7, #16 and #22__

The `I3DragDataSource` is the shiny new replacement for the `I3DragBetweenDelegate`, which clearly defines 2 sets of methods: assertions and mutations.

The assertion methods can be loosely mapped from the `I3DragBetweenDelegate` to the `I3DragDataSource` as follows:

	isCell... -> can...

The responsibillity of mutating the data source wasn't really well defined in the original `I3DragBetweenDelegate` and is much harder to map.

__This resolves:  #15__

The 'rendering' capabilities of the codebase were also completely private, and there was no way of extending how drag-and-drops _looked and felt_ on the screen. As the `I3DragBetweenHelper` did not expressly define extension points the only way one could customize the drag-and-drop rendering would be to extend the it and start hack-ily overriding private methods.

Now we have the `I3DragRenderDelegate` protocol, which will allow you to completely customize how the rendering of the drag-and-drops is dealt with as you so desire.


###Drops

Drops can now be recognized in 2 forms:

- Drops on a specific item in a collection
- Drops on a specific point in a collection

Which means that you can drop things on the empty part of your collections! The suggested work-around to this limitation of `i3-dragndrop` was to add a static 'placeholder' cell to your collection and configure it to receive drops. No longer a problem.

__This resolves: #15__



###Gesture Recognizer

Much like the rendering capabilities of `i3-dragndrop`, the `UIGestureRecognizer` that was used to listen for drag-and-drop events was created and configured privately. This was problematic as it _forced_ you to create 1 new `UIPanGestureRecognizer` and have it listen to your `superview`, which left no room for customization and even caused problems when integrating with some `UITableView`'s features such as `moving` and `editing`.


Now you have the option to inject an instance of `UIGestureRecognizer` into the framework that will be used to recognize drags, or can just leave it to create its own `UIPanGestureRecognizer` 'behind the scenes'.

We've found that the best way to integrate with the `UITableView`s `moving` and `editing` properties, is to inject a `UILongPressGestureRecognizer` into the framework to recognizer drags whenever a long press gesture occurs on a `UITableViewCell`. This won't interfere with the `UITableView`'s underlying `UIPanGestureRecognizer`.

__This resolves: #14__


###Cloning Instability

This was clearly a massive issue with `i3-dragndrop`: we used the `NSKeyArchiver` and `NSKeyUnarchiver` to create copies of the dragging item in question. It often caused hard crashes due to various conflicting `UIView` properties and also made it very difficult to create your own subclasses of `UITableViewCell` and `UICollectionViewCell` to drag about.

We've fixed that now with the use of the new `I3CloneView`. This class simply renders the given `sourceView` into a `UIImage` off-screen and then draws the `UIImage` into its frame on `drawRect`, which so far, has worked pretty flawlessly.

__This resolves: #8, #23, #12, #29__



___

<u>Documentation</u>: BetweenKit 2.0.0
