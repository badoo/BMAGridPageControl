//
//  BMAGridPageControl.h
//  Badoo
//
//  Created by Miguel Angel Quinones on 05/11/2013.
//  Copyright (c) 2013 Badoo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Modes in which the control can work
 
 There are two modes: 
 
 - 'Pagination' behaves as UIPageControl, meaning the control UI will
 change by changing total and current items. 
 - 'Button' ignores any set to currentItem and totalNumberOfItems, and just shows all 
 elements 'selected'
 */
typedef NS_ENUM(NSUInteger, BMAGridPageControlMode) {
    BMAGridPageControlModePagination,   /// Behaves as a page control, changing appearance through API
    BMAGridPageControlModeButton  /// Behaves as button, ignores page control API
};

/**
 A control to display indicator of 'pagination', in a grid.
 */
@interface BMAGridPageControl : UIControl

/** Returns properly initialized control. Designated initializer
 
 This is the designated initializer.
 
 @param backgroundImage Image to be set as the whole control background
 @param itemImage Image to be used as a single item in the grid
 @return Correctly initialized and configured control
 */
- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage itemImage:(UIImage *)itemImage;

/** The current item index
 
 Shown as selected (see itemSelectedAlpha). Other items are unselected (see itemUnselectedAlpha)
 */
@property (nonatomic, assign) NSUInteger currentItemIndex;

/** The number of items in total.
 
 Affects the behaviour of 'pagination animation' and how many items are shown in total.
 */
@property (nonatomic, assign) NSUInteger totalNumberOfItems;

/** Changes the mode in which the control works
 */
@property (nonatomic, assign) BMAGridPageControlMode mode;

/** Padding between items.
 
 Used to separate items in grid. Margin between first items and borders is unaffected by this property.
 Default is 2.
 */
@property (nonatomic, assign) UIOffset itemPadding UI_APPEARANCE_SELECTOR;

/** Alpha to use for the 'selected' element
 
 The selected element is generally brighter than other elements. Default is 1
 */
@property (nonatomic, assign) CGFloat itemSelectedAlpha UI_APPEARANCE_SELECTOR;

/** Alpha to use for the 'unselected' elements
 
 Default is 0.4
 */
@property (nonatomic, assign) CGFloat itemUnselectedAlpha UI_APPEARANCE_SELECTOR;
@end



