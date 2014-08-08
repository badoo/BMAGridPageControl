//
//  BMAGridPageControlTests.m
//  Badoo
//
//  Created by Miguel Angel Quinones on 05/11/2013.
//  Copyright (c) 2013 Badoo Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "BMAGridPageControl.h"
#import "BMAGridPageControl_Private.h"

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

- (void)testThat_GivenControlCreated_IsDelegateOfDriver {
    XCTAssertEqual(self.pageControl.driver.delegate, self.pageControl);
}

- (void)testThat_GivenControlCreatedWithBackgroundImage_ThenIntrinsicContentSizeNotZero {
    BOOL intrinsicContentSizeIsZero = CGSizeEqualToSize([self.pageControl intrinsicContentSize], CGSizeZero);
    XCTAssertFalse(intrinsicContentSizeIsZero);
}

- (void)testThat_GivenControlCreated_ThenModeIsPagination {
    XCTAssertEqual(self.pageControl.mode, BMAGridPageControlModePagination);
}

@end
