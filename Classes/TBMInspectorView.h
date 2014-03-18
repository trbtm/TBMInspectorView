//
//  TBMInspectorView.h
//  TBMInspectorView
//
//  Created by Thore Bartholomäus on 17/03/14.
//  Copyright (c) 2014 Thore Bartholomäus. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//Delegate notifications
extern NSString *TBMInspectorViewDetailViewWillExpandNotification;
extern NSString *TBMInspectorViewDetailViewDidExpandNotification;
extern NSString *TBMInspectorViewDetailViewWillCollapseNotification;
extern NSString *TBMInspectorViewDetailViewDidCollapseNotification;

@class TBMDetailView;
@protocol TBInspectorViewDelegate;

@interface TBMInspectorView : NSView

@property (unsafe_unretained, nonatomic) id <TBInspectorViewDelegate> delegate;

- (TBMDetailView *)insertView:(NSView *)detailView
                     atIndex:(NSUInteger)index
                       label:(NSString *)label
                    expanded:(BOOL)expanded;

- (TBMDetailView *)addView:(NSView *)detailView
                    label:(NSString *)label
                 expanded:(BOOL)expanded;

- (void)removeDetailView:(TBMDetailView *)detailView;

- (void)removeDetailViewAtIndex:(NSUInteger)index;

@end

@protocol TBInspectorViewDelegate <NSObject>

@optional

- (BOOL)inspectorView:(TBMInspectorView *)inspectorView
   shouldCollapseItem:(TBMDetailView *)item;

- (BOOL)inspectorView:(TBMInspectorView *)inspectorView
     shouldExpandItem:(TBMDetailView *)item;

- (void)inspectorViewDetailViewWillExpand:(NSNotification *)notification;
- (void)inspectorViewDetailViewDidExpand:(NSNotification *)notification;
- (void)inspectorViewDetailViewWillCollapse:(NSNotification *)notification;
- (void)inspectorViewDetailViewDidCollapse:(NSNotification *)notification;

@end
