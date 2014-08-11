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

#import "BMAViewController.h"
#import <BMAGridPageControl/BMAGridPageControl.h>
#import "BMACollectionViewCell.h"
#import <TLLayoutTransitioning/TLTransitionLayout.h>

@interface BMAViewController () <UINavigationControllerDelegate>
@property (nonatomic, weak) BMAGridPageControl *control;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UICollectionViewFlowLayout *gridLayout;
@property (nonatomic, strong) UICollectionViewLayout *fullsizeLayout;
@property (nonatomic, assign) BOOL changingLayouts;
@end

@implementation BMAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.images = [self hardcodedImages];
    [self addPageControl];
    [self configureCollectionView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - BMAGridPageControl

- (void)addPageControl {
    BMAGridPageControl *control = [[BMAGridPageControl alloc] initWithBackgroundImage:[UIImage imageNamed:@"CircleGrid"] itemImage:[UIImage imageNamed:@"SquareFocused"]];
    [self.view addSubview:control];
    
    control.frame = (CGRect) {
        .origin = CGPointMake(CGRectGetMidX(self.view.bounds) - CGRectGetWidth(control.frame)/2, CGRectGetMaxY(self.view.bounds) - CGRectGetHeight(control.frame)),
        .size = control.frame.size
    };
    
    [control addTarget:self action:@selector(switchLayouts:) forControlEvents:UIControlEventTouchUpInside];
    
    control.totalNumberOfItems = self.images.count;
    self.control = control;
}

- (void)switchLayouts:(BMAGridPageControl *)control {
    NSIndexPath *visible = [self.collectionView indexPathsForVisibleItems].firstObject;
    NSAssert(visible, @"really?");
    [self collectionView:self.collectionView didSelectItemAtIndexPath:visible];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.changingLayouts) {
        self.control.currentItemIndex = round(scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds));
    }
}

#pragma mark - CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSAssert([cell isKindOfClass:[BMACollectionViewCell class]], @"Expecting concrete subclass");
    NSAssert(indexPath.item < self.images.count, @"Expecting data stability");
    
    ((BMACollectionViewCell *)cell).imageView.image = [self.images objectAtIndex:indexPath.item];
    
    return cell;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayout *toLayout = self.gridLayout == collectionView.collectionViewLayout ? self.fullsizeLayout : self.gridLayout;
    self.changingLayouts = YES;
    TLTransitionLayout *layout = (TLTransitionLayout *)[collectionView transitionToCollectionViewLayout:toLayout
                                                                                               duration:0.5
                                                                                                 easing:QuarticEaseInOut
                                                                                             completion:^(BOOL completed, BOOL finished) {
                                                                                                 if (finished) {
                                                                                                    self.control.mode = self.control.mode == BMAGridPageControlModePagination ? BMAGridPageControlModeButton : BMAGridPageControlModePagination;
                                                                                                 }
                                                                                                 self.changingLayouts = NO;
                                                                                                 [self scrollViewDidScroll:self.collectionView];
                                                                                             }];
    CGPoint toOffset = [collectionView toContentOffsetForLayout:layout
                                                     indexPaths:@[indexPath]
                                                      placement:TLTransitionLayoutIndexPathPlacementCenter
                                                placementAnchor:kTLPlacementAnchorDefault
                                                 placementInset:UIEdgeInsetsZero
                                                         toSize:self.collectionView.bounds.size
                                                 toContentInset:self.collectionView.contentInset];
    layout.toContentOffset = toOffset;
}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    TLTransitionLayout *layout = [[TLTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout supplementaryKinds:nil];
    return layout;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionViewLayout == self.fullsizeLayout) {
        return self.collectionView.bounds.size;
    }
    
    if (collectionViewLayout == self.gridLayout) {
        return self.gridLayout.itemSize;
    }
    
    return CGSizeZero;
}

#pragma mark - Utils

- (NSArray *)hardcodedImages {
    return @[[UIImage imageNamed:@"1.jpg"], [UIImage imageNamed:@"2.png"], [UIImage imageNamed:@"3.jpg"], [UIImage imageNamed:@"4.png"], [UIImage imageNamed:@"5.jpg"], [UIImage imageNamed:@"6.jpeg"], [UIImage imageNamed:@"7.jpg"]];
}

- (void)configureCollectionView {
    self.fullsizeLayout = self.collectionView.collectionViewLayout;
    self.gridLayout = [[UICollectionViewFlowLayout alloc] init];
    self.gridLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.gridLayout.itemSize = CGSizeMake(75, 75);
    [self.collectionView registerNib:[BMACollectionViewCell nib] forCellWithReuseIdentifier:@"cell"];
}
@end
