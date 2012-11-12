//
//  NBInfiniteScrollView.h
//
//  Created by Nathaniel Brown on 11/12/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBInfiniteScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic,copy) UIView *(^viewForIndex)(NSUInteger index);
@property (nonatomic) NSUInteger count;
@property (nonatomic) BOOL vertical;
@property (nonatomic) UIEdgeInsets padding;

@end

