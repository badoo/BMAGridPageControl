/*
 The MIT License (MIT)
 
 Copyright (c) 2014-present Badoo Trading Limited.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

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



