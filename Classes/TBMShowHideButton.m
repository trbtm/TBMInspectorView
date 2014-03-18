//
//  TBShowHideButtton.m
//  TBMInspectorView
//
//  Created by Thore Bartholomäus on 18/03/14.
//  Copyright (c) 2014 Thore Bartholomäus. All rights reserved.
//

#import "TBMShowHideButton.h"

@implementation TBMShowHideButton

- (void)mouseUp:(NSEvent *)theEvent {
    
    //Passing the event directly the TBMDetailView
    [self.superview mouseUp:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent {
    
    [self.superview mouseDown:theEvent];
}

@end
