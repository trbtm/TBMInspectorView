//
//  TBMInspectorView.m
//  TBMInspectorView
//
//  Created by Thore Bartholomäus on 17/03/14.
//  Copyright (c) 2014 Thore Bartholomäus. All rights reserved.
//

#import "TBMInspectorView.h"
#import "TBMInspectorView_Internal.h"

#import "TBMDetailView.h"

NSString *TBMInspectorViewDetailViewWillExpandNotification = @"TBMInspectorViewDetailViewWillExpandNotification";
NSString *TBMInspectorViewDetailViewDidExpandNotification = @"TBMInspectorViewDetailViewDidExpandNotification";
NSString *TBMInspectorViewDetailViewWillCollapseNotification = @"TBMInspectorViewDetailViewWillCollapseNotification";
NSString *TBMInspectorViewDetailViewDidCollapseNotification = @"TBMInspectorViewDetailViewDidCollapseNotification";

@implementation TBMInspectorView

- (void)setDelegate:(id<TBInspectorViewDelegate>)delegate {
    
    if (_delegate) {
        
        void(^removeDelegateAsObserverBlock)(SEL sel, NSString *name) = ^void(SEL sel, NSString *name){
            
            if ([_delegate respondsToSelector:sel]) {
                [[NSNotificationCenter defaultCenter] removeObserver:_delegate name:name object:nil];
            }
        };
        
        //Unregister the old observer as observer for the notifications
        removeDelegateAsObserverBlock(@selector(inspectorViewDetailViewDidCollapse:), TBMInspectorViewDetailViewDidCollapseNotification);
        removeDelegateAsObserverBlock(@selector(inspectorViewDetailViewDidExpand:), TBMInspectorViewDetailViewDidExpandNotification);
        removeDelegateAsObserverBlock(@selector(inspectorViewDetailViewWillCollapse:), TBMInspectorViewDetailViewWillCollapseNotification);
        removeDelegateAsObserverBlock(@selector(inspectorViewDetailViewWillExpand:), TBMInspectorViewDetailViewWillExpandNotification);
    }
    
    _delegate = delegate;
    
    if (_delegate) {
        
        void (^addDelegateAsObserverBlock)(SEL sel, NSString *name) = ^void(SEL sel, NSString *name) {
            
            if ([_delegate respondsToSelector:sel]) {
                [[NSNotificationCenter defaultCenter] addObserver:_delegate selector:sel name:name object:self];
            }
        };
        
        //Register the new observer as observer for the notifications
        addDelegateAsObserverBlock(@selector(inspectorViewDetailViewDidCollapse:), TBMInspectorViewDetailViewDidCollapseNotification);
        addDelegateAsObserverBlock(@selector(inspectorViewDetailViewDidExpand:), TBMInspectorViewDetailViewDidExpandNotification);
        addDelegateAsObserverBlock(@selector(inspectorViewDetailViewWillCollapse:), TBMInspectorViewDetailViewWillCollapseNotification);
        addDelegateAsObserverBlock(@selector(inspectorViewDetailViewWillExpand:), TBMInspectorViewDetailViewWillExpandNotification);
    }
}

#pragma mark -
#pragma mark init

- (instancetype)initWithFrame:(NSRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.autoresizingMask = NSViewWidthSizable;
    }
    return self;
}

- (void)dealloc {
    
    //Unregister the delegate
    self.delegate = nil;
    
    [super dealloc];
}

- (BOOL)isFlipped {
    
    //Return YES so that the inspectorView displays at the top of the scrollView
    return YES;
}

#pragma mark -
#pragma mark Add/remove detailViews

- (TBMDetailView *)addView:(NSView *)detailView
                    label:(NSString *)label
                 expanded:(BOOL)expanded {
    
    //Insert the view at the end of all subviews
    return [self insertView:detailView
                    atIndex:self.subviews.count
                      label:label
                   expanded:expanded];
}

- (TBMDetailView *)insertView:(NSView *)detailView
                     atIndex:(NSUInteger)index
                       label:(NSString *)label
                    expanded:(BOOL)expanded {
    
    //Create a new view container
    TBMDetailView *viewContainer = [[TBMDetailView alloc] initWithWidth:NSWidth(self.frame)
                                                                label:label
                                                           detailView:detailView
                                                             expanded:expanded];
    //Insert the view container
    NSMutableArray *subviews = [self mutableArrayValueForKey:@"subviews"];
    [subviews insertObject:viewContainer atIndex:index];
    //Respotition all view containers
    [self updateDetailViewPositions];
    
    return [viewContainer autorelease];
}

- (void)removeDetailView:(TBMDetailView *)detailView {
    
    //Remove the object at the right index
    [self removeDetailViewAtIndex:[self.subviews indexOfObject:detailView]];
}

- (void)removeDetailViewAtIndex:(NSUInteger)index {
    
    //Remove the object at the index
    NSMutableArray *subview = [self mutableArrayValueForKey:@"subviews"];
    [subview removeObjectAtIndex:index];
    
    //Reposition all detailViews
    [self updateDetailViewPositions];
}

#pragma mark -
#pragma mark Internal

- (void)updateDetailViewPositions {
    
    NSArray *subviews = self.subviews;
    
    //The coordinate system is flipped
    //Begin to count from the bottom
    CGFloat yPosition = 0.0;
    
    
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        
        TBMDetailView *detailView = [subviews objectAtIndex:i];
        
        NSRect detailViewFrame = detailView.frame;
        //Set the new y position
        detailViewFrame.origin.y = yPosition;
        detailView.frame = detailViewFrame;
        
        //Increase the y position for the next view
        yPosition += NSHeight(detailViewFrame);
    }
    
    //Adjust the height of the inspector view
    NSRect viewFrame = self.frame;
    viewFrame.size.height = yPosition;
    self.frame = viewFrame;
}

- (BOOL)shouldExpanItem:(TBMDetailView *)detailView {
    
    BOOL returnValue = YES;
    
    //Ask the delegate if the item get expanded
    id delegate = self.delegate;
    if (delegate && [delegate respondsToSelector:@selector(inspectorView:shouldExpandItem:)]) {
        returnValue = [delegate inspectorView:self shouldExpandItem:detailView];
    }
    
    return returnValue;
}

- (BOOL)shouldCollapseItem:(TBMDetailView *)detailView {
    
    BOOL returnValue = YES;
    
    //Ask the delegate if the item should get collapsed
    id delegate = self.delegate;
    if (delegate && [delegate respondsToSelector:@selector(inspectorView:shouldCollapseItem:)]) {
        returnValue = [delegate inspectorView:self shouldCollapseItem:detailView];
    }
    
    return returnValue;
}

@end
