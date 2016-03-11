# TBMInspectorView

![Alternativtext](Screenshot.png "")

TBMInspectorView is a copy of the Xcode 5's inspector view. It is pretty easy to setup and should used as the documentView of a NSScrollView.

## Adding to your Project
If your are using [CocoaPods](http://cocoapods.org/) simply add the following to your Podfile

``` ruby
pod 'TBMInspectorView'
```

else add all .h and .m files you find the `Classes` folder to your project.
## Getting started
Code from the example project for setting up the inspector view:

```objective-c

	TBMInspectorView *inspector = [[TBMInspectorView alloc] initWithFrame:NSMakeRect(0.0, 0.0, NSWidth(scrollView.frame), 0.0)];
	
    [inspector addView:view1 label:@"View 1" expanded:NO];
    [inspector addView:view2 label:@"View 2" expanded:YES];
    
    [scrollView setDocumentView:inspector];
```

## Deployment
Supports 10.6+, not tested in Autolayout environment yet

## License
MIT

