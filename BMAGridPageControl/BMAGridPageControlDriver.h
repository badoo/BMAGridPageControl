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

#import <Foundation/Foundation.h>
#import "BMAGridPageControl.h"


typedef NS_ENUM(NSUInteger, BMAGridPageControlItemPosition) {
    BMAGridPageControlItemPositionTopLeft = 0,
    BMAGridPageControlItemPositionTopRight = 1,
    BMAGridPageControlItemPositionBottomLeft = 2,
    BMAGridPageControlItemPositionBottomRight = 3
};

const NSUInteger BMAGridPageControlDriverItemsInOneRow;
const NSUInteger BMAGridPageControlDriverItemsInOnePage;

@class BMAGridPageControlDriver;
@protocol BMAGridPageControlDriverDelegate <NSObject>
- (void)pageControlDriver:(BMAGridPageControlDriver*)driver currentItemChangedFrom:(NSUInteger)oldIndex;
- (void)pageControlDriver:(BMAGridPageControlDriver *)driver totalNumberOfItemsChangedFrom:(NSUInteger)oldTotalCount;
- (void)pageControlDriver:(BMAGridPageControlDriver *)driver displayRowChangedFrom:(NSUInteger)oldDisplayRow;
- (void)pageControlDriver:(BMAGridPageControlDriver *)driver modeChangedFrom:(BMAGridPageControlMode)oldMode;
@end

@interface BMAGridPageControlDriver : NSObject

- (NSUInteger)numberOfItemsInRow:(NSUInteger)row;

@property (nonatomic) NSUInteger currentItemIndex;
@property (nonatomic) NSUInteger totalNumberOfItems;

@property (nonatomic, readonly) NSUInteger visibleItems;
@property (nonatomic, readonly) NSUInteger displayRow;

@property (nonatomic,readonly) BMAGridPageControlItemPosition currentItemPosition;
@property (nonatomic, weak) id<BMAGridPageControlDriverDelegate> delegate;
@property (nonatomic) BMAGridPageControlMode mode;
@end
