//
//  TBMAppDelegate.m
//  TBMInspector Example
//
//  Created by Thore Bartholomäus on 18/03/14.
//
//

#import "TBMAppDelegate.h"

#import "TBMInspectorView.h"

@implementation TBMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    TBMInspectorView *inspector = [[TBMInspectorView alloc] initWithFrame:NSMakeRect(0.0, 0.0, NSWidth(scrollView.frame), 0.0)];
    [inspector addView:view1 label:@"View 1" expanded:NO];
    [inspector addView:view2 label:@"View 2" expanded:YES];
    
    [scrollView setDocumentView:inspector];
    
    [inspector release];
}

@end
