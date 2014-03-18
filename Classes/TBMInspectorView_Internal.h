//
//  TBMInspectorView_Internal.h
//  TBMInspectorView
//
//  Created by Thore Bartholomäus on 18/03/14.
//  Copyright (c) 2014 Thore Bartholomäus. All rights reserved.
//

#import "TBMInspectorView.h"

@interface TBMInspectorView ()

- (void)updateDetailViewPositions;

- (BOOL)shouldExpanItem:(TBMDetailView *)detailView;

- (BOOL)shouldCollapseItem:(TBMDetailView *)detailView;

@end
