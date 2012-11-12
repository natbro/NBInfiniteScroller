//
//  NBInfiniteScrollerViewController.h
//
//  Created by Nathaniel Brown on 11/12/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NBInfiniteScrollView;

@interface NBInfiniteScrollerViewController : UIViewController {
  IBOutlet NBInfiniteScrollView *scrollViewLeft;
  IBOutlet NBInfiniteScrollView *scrollViewRight;
}

@end
