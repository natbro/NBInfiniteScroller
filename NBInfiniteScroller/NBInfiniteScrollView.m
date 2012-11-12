//
//  NBInfiniteScrollView.m
//
//  Created by Nathaniel Brown on 11/12/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "NBInfiniteScrollView.h"

@interface NBInfiniteScrollView () {
  NSMutableArray *visibleViews;
  UIView         *containerView;
  NSInteger      _min, _max;
}

- (void)tileViewsFromMin:(CGFloat)minimumVisible toMax:(CGFloat)maximumVisible;

@end

@implementation NBInfiniteScrollView

- (void)setVertical:(BOOL)vertical
{
  _vertical = vertical;
  if (_vertical) {
    self.contentSize = CGSizeMake(self.frame.size.width, 5000);
  } else {
    self.contentSize = CGSizeMake(5000, self.frame.size.height);
  }
  containerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
}

- (void)internalInit
{
  _count = 20;
  _vertical = self.frame.size.width < self.frame.size.height;
  _min = _max = 0;
  _padding = UIEdgeInsetsZero;
  
  if (_vertical) {
    self.contentSize = CGSizeMake(self.frame.size.width, 5000);
  } else {
    self.contentSize = CGSizeMake(5000, self.frame.size.height);
  }
  
  visibleViews = [[NSMutableArray alloc] init];
  
  containerView = [[UIView alloc] init];
  containerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
  [self addSubview:containerView];
  
  [containerView setUserInteractionEnabled:NO];
  
  // hide scroll indicators so our recentering tricks are not revealed
  self.showsHorizontalScrollIndicator = NO;
  self.showsVerticalScrollIndicator = NO;
  self.pagingEnabled = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self internalInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    [self internalInit];
  }
  return self;
}

#pragma mark -
#pragma mark Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary {
  CGPoint currentOffset = [self contentOffset];
  if (_vertical) {
    CGFloat contentWidth = [self contentSize].height;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.height) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetX);
    
    if (distanceFromCenter > (contentWidth / 4.0)) {
      self.contentOffset = CGPointMake(currentOffset.x, centerOffsetX);
      
      // move content by the same amount so it appears to stay still
      for (UIView *view in visibleViews) {
        CGPoint center = [containerView convertPoint:view.center toView:self];
        center.y += (centerOffsetX - currentOffset.y);
        view.center = [self convertPoint:center toView:containerView];
      }
    }
  } else {
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter > (contentWidth / 4.0)) {
      self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
      
      // move content by the same amount so it appears to stay still
      for (UIView *view in visibleViews) {
        CGPoint center = [containerView convertPoint:view.center toView:self];
        center.x += (centerOffsetX - currentOffset.x);
        view.center = [self convertPoint:center toView:containerView];
      }
    }
  }
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [self recenterIfNecessary];
  
  // tile content in visible bounds
  CGRect visibleBounds = [self convertRect:[self bounds] toView:containerView];
  CGFloat minimumVisible, maximumVisible;
  
  minimumVisible = _vertical ? CGRectGetMinY(visibleBounds) : CGRectGetMinX(visibleBounds);
  maximumVisible = _vertical ? CGRectGetMaxY(visibleBounds) : CGRectGetMaxX(visibleBounds);
  
  [self tileViewsFromMin:minimumVisible toMax:maximumVisible];
}


#pragma mark -
#pragma mark View Tiling

- (UIView *)insertView:(NSUInteger)index {
  UIView *v;
  if (nil != _viewForIndex) {
    v = _viewForIndex(index);
  } else {
    // simple placeholder view for debugging/viewing prior to establishing your custom views
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 80)] autorelease];
    [label setNumberOfLines:1];
    [label setText:[NSString stringWithFormat:@"%d", index]];
    v = label;
  }
  [containerView addSubview:v];
  return v;
}

- (CGFloat)placeNewViewOnRight:(CGFloat)rightEdge withIndex:(NSUInteger)index
{
  UIView *view = [self insertView:index];
  [visibleViews addObject:view]; // add rightmost view at the end of the array
  
  CGRect frame = [view frame];
  if (_vertical) {
    frame.origin.x = (([containerView bounds].size.width - frame.size.width - _padding.left - _padding.right)/2.0) + _padding.left;
    frame.origin.y = rightEdge + _padding.top;
  } else {
    frame.origin.x = rightEdge + _padding.left;
    frame.origin.y = (([containerView bounds].size.height - frame.size.height - _padding.top - _padding.bottom)/2.0) + _padding.top;
  }
  [view setFrame:frame];
  
  return _vertical ? (CGRectGetMaxY(frame) + _padding.bottom) : (CGRectGetMaxX(frame) + _padding.right);
}

- (CGFloat)placeNewViewOnLeft:(CGFloat)leftEdge withIndex:(NSUInteger)index {
  UIView *view = [self insertView:index];
  [visibleViews insertObject:view atIndex:0]; // add leftmost view at the beginning of the array
  
  CGRect frame = [view frame];
  if (_vertical) {
    frame.origin.x = (([containerView bounds].size.width - frame.size.width - _padding.left - _padding.right)/2.0) + _padding.left;
    frame.origin.y = leftEdge - frame.size.height - _padding.bottom;
  } else {
    frame.origin.x = leftEdge - frame.size.width - _padding.right;
    frame.origin.y = (([containerView bounds].size.height - frame.size.height - _padding.top - _padding.bottom)/2.0) + _padding.top;
  }
  [view setFrame:frame];
  
  return _vertical ? (CGRectGetMinY(frame) - _padding.top) : (CGRectGetMinX(frame) - _padding.left);
}

- (void)tileViewsFromMin:(CGFloat)minimumVisible toMax:(CGFloat)maximumVisible
{
  // the upcoming tiling logic depends on there already being at least one view in the visibleViews array, so
  // to kick off the tiling we need to make sure there's at least one view
  if ([visibleViews count] == 0) {
    [self placeNewViewOnRight:minimumVisible withIndex:(++_max > _count-1 ? (_max=0) : _max)];
  }
  
  // add views that are missing on right side
  UIView *lastView = [visibleViews lastObject];
  CGFloat rightEdge = _vertical ? (CGRectGetMaxY([lastView frame]) + _padding.bottom) :
                                  (CGRectGetMaxX([lastView frame]) + _padding.right);
  while (rightEdge < maximumVisible) {
    rightEdge = [self placeNewViewOnRight:rightEdge withIndex:(++_max > _count-1 ? (_max=0) : _max)];
  }
  
  // add views that are missing on left side
  UIView *firstView = [visibleViews objectAtIndex:0];
  CGFloat leftEdge = _vertical ? (CGRectGetMinY([firstView frame]) - _padding.top) :
                                 (CGRectGetMinX([firstView frame]) - _padding.left);
  while (leftEdge > minimumVisible) {
    leftEdge = [self placeNewViewOnLeft:leftEdge withIndex:(--_min < 0 ? (_min=_count-1) : _min)];
  }
  
  // remove views that have fallen off right edge
  lastView = [visibleViews lastObject];
  while ((_vertical ? [lastView frame].origin.y : [lastView frame].origin.x) > maximumVisible) {
    if (--_max < 0) _max = _count-1;
    [lastView removeFromSuperview];
    [visibleViews removeLastObject];
    lastView = [visibleViews lastObject];
  }
  
  // remove views that have fallen off left edge
  firstView = [visibleViews objectAtIndex:0];
  while ((_vertical ? CGRectGetMaxY([firstView frame]) : CGRectGetMaxX([firstView frame])) < minimumVisible) {
    if (++_min > _count-1) _min=0;
    [firstView removeFromSuperview];
    [visibleViews removeObjectAtIndex:0];
    firstView = [visibleViews objectAtIndex:0];
  }
}

@end
