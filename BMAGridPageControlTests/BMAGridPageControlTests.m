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

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "BMAGridPageControl.h"

@interface BMAGridPageControlTests : XCTestCase
@property (nonatomic) BMAGridPageControl* pageControl;
@end

@implementation BMAGridPageControlTests

- (void)setUp
{
    [super setUp];
    self.pageControl = [[BMAGridPageControl alloc] initWithBackgroundImage:[self fakeImageWithSize:CGSizeMake(100, 100)] itemImage:[self fakeImageWithSize:CGSizeMake(10, 10)]];
}

- (void)tearDown
{
    self.pageControl = nil;
    [super tearDown];
}

- (UIImage *)fakeImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillRect(context, (CGRect) {.origin = CGPointZero, .size = size});
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

#pragma mark - API
- (void)testThat_GivenControlCreatedWithBackgroundImage_ThenFrameIsNotZero {
    BOOL frameIsZero = CGRectEqualToRect(self.pageControl.frame, CGRectZero);
    XCTAssertFalse(frameIsZero);
}

- (void)testThat_GivenControlCreated_ThenCurrentItemIs0 {
    XCTAssertEqual(self.pageControl.currentItemIndex, 0u);
}

- (void)testThat_GivenControlCreated_ThenNumberOfItemsIsZero {
    XCTAssertEqual(self.pageControl.totalNumberOfItems, 0u);
}

- (void)testThat_GivenTotalNumberOfItems3_WhenCurrentItemChangedTo4_ThenCurrentItem3{
    self.pageControl.totalNumberOfItems = 3u;
    self.pageControl.currentItemIndex = 4u;
    XCTAssertEqual(self.pageControl.currentItemIndex, 2u);
}

- (void)testThat_GivenControlCreatedWithBackgroundImage_ThenIntrinsicContentSizeNotZero {
    BOOL intrinsicContentSizeIsZero = CGSizeEqualToSize([self.pageControl intrinsicContentSize], CGSizeZero);
    XCTAssertFalse(intrinsicContentSizeIsZero);
}

- (void)testThat_GivenControlCreated_ThenModeIsPagination {
    XCTAssertEqual(self.pageControl.mode, BMAGridPageControlModePagination);
}

@end
