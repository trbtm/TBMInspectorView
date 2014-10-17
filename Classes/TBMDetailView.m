//
//  TBMDetailView.m
//  TBMInspectorView
//
//  Created by Thore Bartholomäus on 18/03/14.
//  Copyright (c) 2014 Thore Bartholomäus. All rights reserved.
//

#import "TBMDetailView.h"

#import "TBMInspectorView_Internal.h"

#import "TBMShowHideButton.h"

CGFloat const TBDetailViewBarHeight = 19.0;

@interface TBMDetailView ()

@property (retain) NSTrackingArea *trackingArea;
@property (retain, readwrite) NSView *detailView;
@property (unsafe_unretained) NSTextField *label;
@property (unsafe_unretained) NSButton *showHideButton;

- (NSAttributedString *)attributedStringForButton:(NSString *)stringValue
                                     hightlighted:(BOOL)highlighted;

@end

@implementation TBMDetailView

#pragma mark -
#pragma mark init

- (instancetype)initWithWidth:(CGFloat)width
                        label:(NSString *)labelString
                   detailView:(NSView *)detailView
                     expanded:(BOOL)expanded {
    
    //Calculate the frame of the container
    NSRect frame = NSMakeRect(0.0,
                              0.0,
                              width,
                              TBDetailViewBarHeight + (expanded ? NSHeight(detailView.frame) : 0.0));
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.collapsed = !expanded;
        self.autoresizingMask = (NSViewWidthSizable);
        
        //Create the label for the bar
        NSTextField *label = [[NSTextField alloc] init];
        [label.cell setControlSize:NSSmallControlSize];
        [label setBezeled:NO];
        [label setEditable:NO];
        [label setSelectable:NO];
        [label setDrawsBackground:NO];
        label.autoresizingMask = (NSViewMaxXMargin | NSViewMinYMargin);
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:labelString
                                                                               attributes:@{NSFontAttributeName : [NSFont boldSystemFontOfSize:11.0]}];
        
        label.attributedStringValue = attributedString;
        [attributedString release];
        [label sizeToFit];
        
        NSRect labelFrame = label.frame;
        CGFloat labelFrameY = NSHeight(self.frame) - TBDetailViewBarHeight + (TBDetailViewBarHeight - NSHeight(labelFrame)) / 2;
        labelFrame.origin = NSMakePoint(8.0, labelFrameY);
        label.frame = labelFrame;
        
        [self addSubview:label];
        
        self.label = label;
        [label release];
        
        //Create the show/hide button for the bar
        NSButton *showHideButton = [[TBMShowHideButton alloc] init];
        showHideButton.autoresizingMask = (NSViewMinYMargin | NSViewMinXMargin);
        [showHideButton.cell setControlSize:NSSmallControlSize];
        showHideButton.bezelStyle = NSRecessedBezelStyle;
        [showHideButton setBordered:NO];
        [showHideButton setButtonType:NSToggleButton];
        [showHideButton setHidden:YES];
        
        //Calculate the max width of the button
        NSString *showLabel = NSLocalizedString(@"Show", nil);
        NSString *hideLabel = NSLocalizedString(@"Hide", nil);
        
        showHideButton.attributedTitle = [self attributedStringForButton:showLabel hightlighted:NO];
        [showHideButton sizeToFit];
        CGFloat maxWidth = NSWidth(showHideButton.frame);
        
        showHideButton.attributedTitle = [self attributedStringForButton:hideLabel hightlighted:NO];
        [showHideButton sizeToFit];
        CGFloat secondWidth = NSWidth(showHideButton.frame);
        maxWidth = MAX(secondWidth, maxWidth);
        
        //Set the frame of the button
        NSRect buttonFrame = showHideButton.frame;
        buttonFrame.size.width = maxWidth;
        buttonFrame.origin = NSMakePoint(width - 5.0 - NSWidth(buttonFrame),
                                         NSHeight(self.frame) - TBDetailViewBarHeight + (TBDetailViewBarHeight - NSHeight(buttonFrame)) / 2);
        showHideButton.frame = buttonFrame;
        
        //Set the attributed string
        showHideButton.attributedTitle = [self attributedStringForButton:expanded ? hideLabel : showLabel hightlighted:NO];
        
        //Place the button on the view
        [self addSubview:showHideButton];
        
        self.showHideButton = showHideButton;
        [showHideButton release];
        
        //Calculate the origin of the detailView and apply the right width
        NSRect detailViewFrame = detailView.frame;
        detailViewFrame.size.width = width;
        detailViewFrame.origin = NSZeroPoint;
        detailView.frame = detailViewFrame;
        detailView.autoresizingMask = (NSViewWidthSizable);
        
        if (expanded) {
            [self addSubview:detailView];
        }
        
        self.detailView = detailView;
    }
    return self;
}

- (void)dealloc {
    
    //Release properties
    self.detailView = nil;
    self.representingObject = nil;
    self.trackingArea = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    
    //Draw bottom line
    [[NSColor colorWithCalibratedRed:0.7 green:0.7 blue:0.7 alpha:1.0] setStroke];
    
    NSRect bounds = self.bounds;
    //Inseted bezierPath the 0px line width to create a perfect 1px line
    NSBezierPath *bottomLine = [NSBezierPath bezierPathWithRect:NSMakeRect(NSMinX(bounds), NSMinY(bounds) + 0.5, NSWidth(bounds), 0.0)];
    bottomLine.lineCapStyle = NSButtLineCapStyle;
    [bottomLine stroke];
}

#pragma mark -
#pragma mark Expand/collpase

- (void)collapse {
    
    [self.detailView removeFromSuperview];
    
    //Decrease the frame of self
    NSRect oldRect = self.frame;
    NSRect collapsedFrame = NSMakeRect(0.0,
                                       NSMinY(oldRect) + NSHeight(_detailView.frame),
                                       NSWidth(oldRect),
                                       TBDetailViewBarHeight);
    
    self.frame = collapsedFrame;
    //The the flag
    self.collapsed = YES;
    
    //Update the title of the show/hide button
    self.showHideButton.attributedTitle = [self attributedStringForButton:NSLocalizedString(@"Show", nil)
                                                             hightlighted:NO];
}

- (void)expand {
    
    //Increase the frame of self
    NSRect oldRect = self.frame;
    NSRect detailViewFrame = self.detailView.frame;
    NSRect expanedRect = NSMakeRect(0.0,
                                    NSMaxY(oldRect) - TBDetailViewBarHeight - NSHeight(detailViewFrame),
                                    NSWidth(oldRect),
                                    NSHeight(detailViewFrame) + TBDetailViewBarHeight);
    self.frame = expanedRect;
    //Position the detailof the at the bottom left
    detailViewFrame.origin = NSZeroPoint;
    detailViewFrame.size.width = NSWidth(self.frame);
    self.detailView.frame = detailViewFrame;
    
    [self addSubview:self.detailView];
    
    //Set the flag
    self.collapsed = NO;
    //Update the title of the show/hide button
    self.showHideButton.attributedTitle = [self attributedStringForButton:NSLocalizedString(@"Hide", nil)
                                                             hightlighted:NO];
}

#pragma mark -
#pragma mark Mouse events

- (NSRect)barArea {
    
    //The rect of the top bar where the user can click
    return NSMakeRect(0.0,
                      NSHeight(self.frame) - TBDetailViewBarHeight,
                      NSWidth(self.frame),
                      TBDetailViewBarHeight);
}

- (void)updateTrackingAreas {
    
    [super updateTrackingAreas];
    
    //Remove the old tracking area
    if (self.trackingArea) {
        [self removeTrackingArea:self.trackingArea];
        self.trackingArea = nil;
    }
    
    //Create a new tracking area for the top bar
    NSTrackingArea *newTrackingArea = [[NSTrackingArea alloc] initWithRect:self.barArea
                                                                   options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow)
                                                                     owner:self
                                                                  userInfo:nil];
    [self addTrackingArea:newTrackingArea];
    
    self.trackingArea = newTrackingArea;
    [newTrackingArea release];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    
    //Reset the title of the button to prevent highlighted state from dragged moused
    //with mouseUp over another view
    self.showHideButton.attributedTitle = [self attributedStringForButton:self.showHideButton.attributedTitle.string
                                                             hightlighted:NO];
    
    //Display the show hide button
    [self.showHideButton setHidden:NO];
}

- (void)mouseExited:(NSEvent *)theEvent {
    
    //Hide the show/hide button
    [self.showHideButton setHidden:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    
    NSPoint coordinateInBaseWindow = theEvent.locationInWindow;
    NSPoint coordinateInView = [self convertPoint:coordinateInBaseWindow fromView:nil];
    
    if (NSPointInRect(coordinateInView, self.barArea)) {
        
        BOOL alternateCondition = (self.collapsed && [(TBMInspectorView *)self.superview shouldExpanItem:self]) ||
        (!self.collapsed && [(TBMInspectorView *)self.superview shouldCollapseItem:self]);
        
        if (alternateCondition) {
            
            //Change the color the of the button title
            self.showHideButton.attributedTitle = [self attributedStringForButton:self.showHideButton.attributedTitle.string
                                                                     hightlighted:YES];
        }
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    
    NSPoint coordinateInBaseWindow = theEvent.locationInWindow;
    NSPoint coordinateInView = [self convertPoint:coordinateInBaseWindow fromView:nil];
    
    if (NSPointInRect(coordinateInView, self.barArea)) {
        
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:self, @"NSObject", nil];
        
        //The delegate if the self should be expanded
        if ( self.collapsed && [(TBMInspectorView *)self.superview shouldExpanItem:self] ) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:TBMInspectorViewDetailViewWillExpandNotification
                                                                object:self.superview
                                                              userInfo:userInfo];
            
            [self expand];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:TBMInspectorViewDetailViewDidExpandNotification
                                                                object:self.superview
                                                              userInfo:userInfo];
            
        } else if ( [(TBMInspectorView *)self.superview shouldCollapseItem:self] ) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:TBMInspectorViewDetailViewWillCollapseNotification
                                                                object:self.superview
                                                              userInfo:userInfo];
            
            [self collapse];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:TBMInspectorViewDetailViewDidCollapseNotification
                                                                object:self.superview
                                                              userInfo:userInfo];
        }
        
        [userInfo release];
        
        [(TBMInspectorView *)self.superview updateDetailViewPositions];
    }
}

#pragma mark -
#pragma mark Helpers

- (NSAttributedString *)attributedStringForButton:(NSString *)stringValue
                                     hightlighted:(BOOL)highlighted {
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setAlignment:NSRightTextAlignment];
    
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:[NSFont boldSystemFontOfSize:10.0], NSFontAttributeName,
                                highlighted ? [NSColor alternateSelectedControlColor] : [NSColor colorWithCalibratedRed:0.6 green:0.65 blue:0.73 alpha:1.0], NSForegroundColorAttributeName,
                                paragraph, NSParagraphStyleAttributeName, nil];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:stringValue
                                                                           attributes:attributes];
    [attributes release];
    [paragraph release];
    
    return [attributedString autorelease];
}

@end
