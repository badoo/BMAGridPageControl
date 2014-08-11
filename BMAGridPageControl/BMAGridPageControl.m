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

#import "BMAGridPageControl.h"
#import "BMAGridPageControl_Private.h"

#define BMA_WEAK_SELF __weak __typeof(&*self)weakSelf = self;

@implementation BMAGridPageControl

- (id)initWithBackgroundImage:(UIImage *)backgroundImage itemImage:(UIImage *)itemImage {
    NSParameterAssert(backgroundImage);
    NSParameterAssert(itemImage);
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _itemPadding = [self defaultItemPadding];
        _itemSelectedAlpha = [self defaultItemSelectedAlpha];
        _itemUnselectedAlpha = [self defaultItemUnselectedAlpha];
        _backgroundImage = backgroundImage;
        _itemImage = itemImage;
        _background = [[UIImageView alloc] initWithImage:backgroundImage];
        [self addSubview:_background];
        
        self.frame = (CGRect) {
            .origin = CGPointZero,
            .size = backgroundImage.size
        };
        
        _driver = [[BMAGridPageControlDriver alloc] init];
        _driver.delegate = self;
        _itemImages = [@[[self itemImageView],
                         [self itemImageView],
                         [self itemImageView],
                         [self itemImageView]] mutableCopy];
        [_itemImages enumerateObjectsUsingBlock:^(UIView* v, NSUInteger idx, BOOL *stop) {
            [self addSubview:v];
        }];
        
        [self layoutStaticViews];
    }
    return self;
}


#pragma mark - Setter Overrides
- (void)setCurrentItemIndex:(NSUInteger)currentItemIndex {
    self.driver.currentItemIndex = currentItemIndex;
}

- (NSUInteger)currentItemIndex {
    return self.driver.currentItemIndex;
}

- (void)setTotalNumberOfItems:(NSUInteger)totalNumberOfItems {
    self.driver.totalNumberOfItems = totalNumberOfItems;
}

- (NSUInteger)totalNumberOfItems {
    return self.driver.totalNumberOfItems;
}

- (void)setMode:(BMAGridPageControlMode)mode {
    self.driver.mode = mode;
}

- (BMAGridPageControlMode)mode {
    return self.driver.mode;
}

#pragma mark - View Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    self.background.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)layoutStaticViews {
    BMA_WEAK_SELF
    [self.itemImages enumerateObjectsUsingBlock:^(UIView* v, NSUInteger idx, BOOL *stop) {
        BMAGridPageControlItemPosition position = (BMAGridPageControlItemPosition)idx;
        v.center = [weakSelf coordinateForItemPosition:position];
        [weakSelf configureView:v atPosition:idx withDriver:weakSelf.driver];
    }];
}

- (void)configureView:(UIView*)view
           atPosition:(BMAGridPageControlItemPosition)position
           withDriver:(BMAGridPageControlDriver*)driver {
    NSUInteger itemsInPage = [driver numberOfItemsInRow:[driver displayRow]] + [driver numberOfItemsInRow:[driver displayRow] + 1];
    view.alpha = [self alphaForItemAtPosition:position
                         selectedItemPosition:driver.currentItemPosition
                          andFinalItemsInPage:itemsInPage];
}

- (CGFloat)alphaForItemAtPosition:(BMAGridPageControlItemPosition)position
             selectedItemPosition:(BMAGridPageControlItemPosition)selectedPosition
              andFinalItemsInPage:(NSUInteger)itemsInPage {
    CGFloat alpha;
    if (self.mode == BMAGridPageControlModeButton || position == selectedPosition) {
        alpha = self.itemSelectedAlpha;
    } else {
        alpha = (position < itemsInPage) ? self.itemUnselectedAlpha : self.itemHiddenAlpha;
    }
    
    return alpha;
}

- (CGSize)intrinsicContentSize {
    return _background.frame.size;
}

#pragma mark - Driver delegate
- (void)pageControlDriver:(BMAGridPageControlDriver *)driver currentItemChangedFrom:(NSUInteger)oldIndex {
    BMA_WEAK_SELF
    [UIView animateWithDuration:[self animationDuration] delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        [weakSelf layoutStaticViews];
    } completion:nil];
}

- (void)pageControlDriver:(BMAGridPageControlDriver *)driver totalNumberOfItemsChangedFrom:(NSUInteger)oldTotalCount {
    BMA_WEAK_SELF
    [UIView animateWithDuration:[self animationDuration] delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        [weakSelf layoutStaticViews];
    } completion:nil];
}

- (void)pageControlDriver:(BMAGridPageControlDriver *)driver displayRowChangedFrom:(NSUInteger)oldDisplayRow {
    CGFloat direction = ((NSInteger)[driver displayRow] - (NSInteger)oldDisplayRow) > 0 ? -1.f : 1.f;
    NSUInteger enteringRow = [self enteringRowFromDisplayRow:[driver displayRow] andDirection:direction];
    [self applyAnimationsWithDirection:direction enteringRow:enteringRow];
}

- (void)pageControlDriver:(BMAGridPageControlDriver *)driver modeChangedFrom:(BMAGridPageControlMode)oldMode {
    BMA_WEAK_SELF
    [UIView animateWithDuration:[self animationDuration] animations:^{
        [weakSelf layoutStaticViews];
    } completion:nil];
}

#pragma mark - Animations
- (void)applyAnimationsWithDirection:(CGFloat)direction enteringRow:(NSUInteger)enteringRow {
    NSArray* viewsDisappearing = [self disappearingViewsWithDirection:direction];
    NSArray* viewsAppearing = [self fakeViewsAppearingWithDirection:direction andRow:enteringRow];
    [self addSubviews:viewsAppearing];
    
    BMA_WEAK_SELF
    [UIView animateWithDuration:[self rowAnimationDuration] delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        [weakSelf animateInternalViewsWithDirection:direction];
        [weakSelf animateAppearingViews:viewsAppearing withDirection:direction];
        [weakSelf animateDisappearingViews:viewsDisappearing withDirection:direction];
    } completion:^(BOOL finished) {
        [weakSelf layoutStaticViews];
        [weakSelf removeSubViews:viewsAppearing];
    }];
}

- (void)animateInternalViewsWithDirection:(CGFloat)direction {
    BMA_WEAK_SELF
    [self.itemImages enumerateObjectsUsingBlock:^(UIView* v, NSUInteger idx, BOOL *stop) {
        [weakSelf animateInternalView:v atPosition:idx withDirection:direction];
    }];
}

- (void)animateAppearingViews:(NSArray*)views withDirection:(CGFloat)direction {
    BMA_WEAK_SELF
    [views enumerateObjectsUsingBlock:^(UIView* v, NSUInteger idx, BOOL *stop) {
        BMAGridPageControlItemPosition firstPosition = [weakSelf firstFakeViewItemPositionWithDirection:direction];
        [weakSelf animateAppearingView:v toFinalPosition:firstPosition + idx withDirection:direction];
    }];

}

- (void)animateDisappearingViews:(NSArray*)views withDirection:(CGFloat)direction {
    BMA_WEAK_SELF
    [views enumerateObjectsUsingBlock:^(UIView* v, NSUInteger idx, BOOL *stop) {
        v.alpha = [weakSelf itemHiddenAlpha];
    }];
}

- (void)animateInternalView:(UIView*)view
                 atPosition:(BMAGridPageControlItemPosition)fromPosition
              withDirection:(CGFloat)direction {
    CGPoint coord = [self coordinateForItemPosition:fromPosition];
    CGPoint withOffset = [self animationOffsetToPosition:coord WithDirection:direction];
    view.center = withOffset;

    view.alpha = [self alphaForItemAtPosition:[self finalPositionWithDirection:direction fromPosition:fromPosition]
                         selectedItemPosition:self.driver.currentItemPosition
                          andFinalItemsInPage:self.driver.visibleItems];
}

- (void)animateAppearingView:(UIView*)view
            toFinalPosition:(NSUInteger)finalPosition
              withDirection:(CGFloat)direction {
    view.center = [self animationOffsetToPosition:view.center WithDirection:direction];;
    view.alpha = [self alphaForItemAtPosition:finalPosition
                         selectedItemPosition:self.driver.currentItemPosition
                          andFinalItemsInPage:self.driver.visibleItems];
}

- (NSArray *)disappearingViewsWithDirection:(CGFloat)direction {
    NSUInteger initialViewMovingOut = direction > 0.f ? BMAGridPageControlItemPositionBottomLeft : BMAGridPageControlItemPositionTopLeft;
    NSIndexSet* disappearingIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(initialViewMovingOut, BMAGridPageControlDriverItemsInOneRow)];
    return [self.itemImages objectsAtIndexes:disappearingIndexes];
}

- (NSArray*)fakeViewsAppearingWithDirection:(CGFloat)direction andRow:(NSUInteger)row {
    NSArray* fakeViewsEntering = @[[self itemImageView],[self itemImageView]];
    
    BMA_WEAK_SELF
    BMAGridPageControlItemPosition firstViewGridPosition = [self firstFakeViewItemPositionWithDirection:direction];
    [fakeViewsEntering enumerateObjectsUsingBlock:^(UIView* v, NSUInteger idx, BOOL *stop) {
        CGPoint coord = [weakSelf coordinateForItemPosition:firstViewGridPosition + idx];
        CGPoint withOffset = [weakSelf animationOffsetToPosition:coord WithDirection:-direction];
        v.center = withOffset;
    }];
    
    return fakeViewsEntering;
}

- (CGPoint)animationOffsetToPosition:(CGPoint)coord WithDirection:(CGFloat)direction {
    CGPoint offsetApplied = CGPointMake(coord.x, coord.y);
    offsetApplied.y += direction * [self itemSpacingY];
    return offsetApplied;
}

- (NSUInteger)enteringRowFromDisplayRow:(NSUInteger)displayRow andDirection:(CGFloat)direction {
    if (displayRow == 0 && direction < 0.f) {
        return 0;
    }
    
    return direction > 0.f ? displayRow - 1 : displayRow + 1;
}

- (BMAGridPageControlItemPosition)firstFakeViewItemPositionWithDirection:(CGFloat)direction {
    BMAGridPageControlItemPosition firstViewGridPosition = direction > 0.f ? BMAGridPageControlItemPositionTopLeft : BMAGridPageControlItemPositionBottomLeft;
    return firstViewGridPosition;
}

- (BMAGridPageControlItemPosition)finalPositionWithDirection:(CGFloat)direction fromPosition:(BMAGridPageControlItemPosition)position {
    NSInteger positionOffset = direction > 0.f ? 2 : -2;
    return position + positionOffset;
}


#pragma mark - Utils
- (void)addSubviews:(NSArray*)array {
    BMA_WEAK_SELF
    [array enumerateObjectsUsingBlock:^(UIView* v, NSUInteger idx, BOOL *stop) {
        [weakSelf addSubview:v];
    }];
}

- (void)removeSubViews:(NSArray*)array {
    [array enumerateObjectsUsingBlock:^(UIView* v, NSUInteger idx, BOOL *stop) {
        [v removeFromSuperview];
    }];
}

- (CGSize)itemSize {
    return [self itemImage].size;
}

- (UIImageView*)itemImageView {
    UIImageView* view =[[UIImageView alloc] initWithImage:[self itemImage]];
    view.alpha = 0.f;
    return view;
}

- (CGFloat)itemSpacingY {
    CGSize itemSize = [self itemSize];
    return itemSize.height + self.itemPadding.vertical;
}

- (CGFloat)itemSpacingX {
    CGSize itemSize = [self itemSize];
    return itemSize.width + self.itemPadding.horizontal;
}

- (CGFloat)itemHiddenAlpha {
    return 0.1f;
}

- (CGFloat)rowAnimationDuration {
    return .4f;
}

- (CGFloat)animationDuration {
    return .1f;
}

- (CGPoint)coordinateForItemPosition:(BMAGridPageControlItemPosition)position {
    CGFloat minX = CGRectGetMidX(self.bounds) - [self itemSpacingX]/2;
    CGFloat minY = CGRectGetMidY(self.bounds) - [self itemSpacingY]/2;
    CGFloat maxX = CGRectGetMidX(self.bounds) + [self itemSpacingX]/2;
    CGFloat maxY = CGRectGetMidY(self.bounds) + [self itemSpacingY]/2;
    
    CGPoint coords = CGPointZero;
    switch (position) {
        case BMAGridPageControlItemPositionTopLeft:
            coords = CGPointMake(minX, minY);
            break;
        case BMAGridPageControlItemPositionTopRight:
            coords = CGPointMake(maxX, minY);
            break;
        case BMAGridPageControlItemPositionBottomLeft:
            coords = CGPointMake(minX, maxY);
            break;
        case BMAGridPageControlItemPositionBottomRight:
            coords = CGPointMake(maxX, maxY);
            break;
        default:
            break;
    }
    
    return coords;
}

#pragma mark - Default values

- (UIOffset)defaultItemPadding {
    return UIOffsetMake(2, 2);
}

- (CGFloat)defaultItemUnselectedAlpha {
    return .4f;
}

- (CGFloat)defaultItemSelectedAlpha {
    return 1.f;
}

@end
