//
//  NBInfiniteScrollerViewController.m
//
//  Created by Nathaniel Brown on 11/12/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "NBInfiniteScrollerViewController.h"
#import "NBInfiniteScrollView.h"
#import <QuartzCore/CAAnimation.h>

@implementation NBInfiniteScrollerViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  NSArray *colors = [NSArray arrayWithObjects: [UIColor redColor], [UIColor blueColor], [UIColor greenColor], nil];

  [super viewDidLoad];
  scrollViewLeft.vertical = YES;
  scrollViewLeft.count = 40;
  scrollViewLeft.padding = UIEdgeInsetsMake(5, 5, 5, 5);
  scrollViewLeft.viewForIndex = ^(NSUInteger index){
    UIView *inner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    inner.layer.cornerRadius = 10.0;
    inner.backgroundColor = [colors objectAtIndex:arc4random() % [colors count]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"%d", index];
    [inner addSubview:label];
    return inner;
  };
  scrollViewRight.vertical = NO;
  scrollViewRight.count = 120;
  scrollViewRight.padding = UIEdgeInsetsMake(5, 5, 5, 5);
  scrollViewRight.viewForIndex = scrollViewLeft.viewForIndex;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
