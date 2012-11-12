# NBInfiniteScroller

Expands on the Apple sample [StreetScroller](http://developer.apple.com/library/ios/#samplecode/StreetScroller/Introduction/Intro.html) to give you both horizontal and vertical "infinite" or "looping" scrolling over a set of UIViews.

I was looking for a circular/infinite scroller with memory behavior closer to UITableView (only holding on to views that were visible or recently visible). Most examples I found were loopers with a single item visible at once and without good memory behavior. Apple's StreetScroller example had the visual and memory behaviors I wanted but only worked horizontally and didn't keep track of items in a way that would easily allow you to map them to items in an array or elsewhere back in your application. I added in vertical scrolling and a block/callback to return views to the scroller based on their index within the **count** of items you tell it are in the list.

##Examples of use
 This test project gives an example of a vertical and a horizontal infinite/looper scroller.

      // will default based on the height/width of the view (vertical if height > width), but you can override it
      scrollViewLeft.vertical = YES;

      // the number of items to loop over, 0..N-1
      scrollViewLeft.count = 40;

      // the views are by default centered in the NBInfiniteScroller's view with no padding
      scrollViewLeft.padding = UIEdgeInsetsMake(5, 5, 5, 5);

      // provide a block to return UIView's as needed when they come into view
      // if you don't provide a block, a simple label with the index will be provided (useful just for debugging)
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

##Installation
 Simply copy NBInfiniteScrollView.h and NBInfiniteScrollView.m into your project and use them as you would a UIScrollView. See the example above from the sample NBInfiniteScrollerViewController.
