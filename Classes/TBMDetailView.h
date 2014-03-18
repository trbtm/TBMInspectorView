//
//  TBMDetailView.h
//  TBMInspectorView
//
//  Created by Thore Bartholomäus on 18/03/14.
//  Copyright (c) 2014 Thore Bartholomäus. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TBMDetailView : NSView

@property (assign, nonatomic) NSString *labelString;
@property (retain, readonly) NSView *detailView;
@property BOOL collapsed;
@property (retain) id representingObject;

- (id)initWithWidth:(CGFloat)width
              label:(NSString *)labelString
         detailView:(NSView *)detailView
           expanded:(BOOL)expanded;

- (void)collapse;

- (void)expand;

@end
