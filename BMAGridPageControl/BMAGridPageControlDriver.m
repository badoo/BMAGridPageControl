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

#import "BMAGridPageControlDriver.h"

const NSUInteger BMAGridPageControlDriverItemsInOneRow = 2;
const NSUInteger BMAGridPageControlDriverItemsInOnePage = 4;

@implementation BMAGridPageControlDriver

#pragma mark - Setter overrides
- (void)setCurrentItemIndex:(NSUInteger)itemIndex {
    if (self.mode == BMAGridPageControlModePagination) {        
        NSUInteger lastIndex = _currentItemIndex;
        NSUInteger lastDisplayRow = [self displayRow];
        
        _currentItemIndex = MIN(self.totalNumberOfItems-1, itemIndex);
        if ([self displayRow] != lastDisplayRow) {
            [self.delegate pageControlDriver:self displayRowChangedFrom:lastDisplayRow];
        } else {
            if (lastIndex != _currentItemIndex) {
                [self.delegate pageControlDriver:self currentItemChangedFrom:lastIndex];
            }
        }
    }
}

- (void)setTotalNumberOfItems:(NSUInteger)totalNumberOfItems {
    if (self.mode == BMAGridPageControlModePagination) {
        if (_totalNumberOfItems != totalNumberOfItems) {
            NSUInteger oldTotalNumber = _totalNumberOfItems;
            _totalNumberOfItems = totalNumberOfItems;
            [self.delegate pageControlDriver:self totalNumberOfItemsChangedFrom:oldTotalNumber];
        }
    }
}

- (void)setMode:(BMAGridPageControlMode)mode {
    if (_mode != mode) {
        BMAGridPageControlMode oldMode = _mode;
        _mode = mode;
        [self.delegate pageControlDriver:self modeChangedFrom:oldMode];
    }
}

- (NSUInteger)visibleItems {
    return ([self numberOfItemsInRow:self.displayRow] + [self numberOfItemsInRow:self.displayRow+1]);
}

- (BMAGridPageControlItemPosition)currentItemPosition {
    
    NSUInteger currentItemPosX = self.currentItemIndex % 2;
    NSUInteger currentItemPosY = self.currentItemIndex / 2;
    
    BMAGridPageControlItemPosition position = [self positionForX:currentItemPosX positionY:currentItemPosY];
    if ([self indexIsLastInPage:self.currentItemIndex] && ![self indexIsLast:self.currentItemIndex]) {
        position = BMAGridPageControlItemPositionTopRight;
    }
    return position;

}

- (NSUInteger)numberOfItemsInRow:(NSUInteger)row {
    NSUInteger firstItemIndex = row * BMAGridPageControlDriverItemsInOneRow;
    if (self.totalNumberOfItems < firstItemIndex) {
        return 0u;
    }
    
    NSUInteger distanceToEnd = self.totalNumberOfItems - firstItemIndex;
    if (distanceToEnd > BMAGridPageControlDriverItemsInOneRow) {
        return BMAGridPageControlDriverItemsInOneRow;
    } else {
        return distanceToEnd;
    }
    
}

- (NSUInteger)displayRow {
    NSUInteger rowForItemIndex = [self rowForItemIndex:self.currentItemIndex];
    
    if (rowForItemIndex > 0u) {
        --rowForItemIndex;
        BOOL currentIndexIsLastInPage = [self indexIsLastInPage:self.currentItemIndex];
        BOOL currentIndexIsLast = [self indexIsLast:self.currentItemIndex];
        if (currentIndexIsLastInPage && !currentIndexIsLast) {
            ++rowForItemIndex;
        }
    }
    
    return rowForItemIndex;
}

#pragma mark - Utils
- (BOOL)indexIsLastInPage:(NSUInteger)index {
    NSUInteger pageForIndex = [self pageForIndex:index];
    NSUInteger maxIndexInPage = BMAGridPageControlDriverItemsInOnePage - 1 + (pageForIndex * BMAGridPageControlDriverItemsInOnePage);
    return index == maxIndexInPage;
}

- (BOOL)indexIsLast:(NSUInteger)index {
    return (index == self.totalNumberOfItems - 1);
}

- (NSUInteger)pageForIndex:(NSUInteger)index {
    return index / BMAGridPageControlDriverItemsInOnePage;
}

- (NSUInteger)rowForItemIndex:(NSUInteger)index {
    return index / BMAGridPageControlDriverItemsInOneRow;
}

- (BMAGridPageControlItemPosition)positionForX:(NSUInteger)x positionY:(NSUInteger)y {
    
    BMAGridPageControlItemPosition result;
    
    if (x == 0) {
        
        if (y == 0) {
            result = BMAGridPageControlItemPositionTopLeft;
        } else {
            result = BMAGridPageControlItemPositionBottomLeft;
        }
        
    } else {
        
        if (y == 0) {
            result = BMAGridPageControlItemPositionTopRight;
        } else {
            result = BMAGridPageControlItemPositionBottomRight;
        }
        
    }
    
    return result;
}

@end
