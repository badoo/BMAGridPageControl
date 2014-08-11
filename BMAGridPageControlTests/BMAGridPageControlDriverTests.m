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

#import <XCTest/XCTestCase.h>
#import <OCMock/OCMock.h>
#import "BMAGridPageControlDriver.h"

#define BMAVerifyMock(s) [s verify]

@interface BMAGridPageControlDriverTests : XCTestCase
@property (nonatomic) BMAGridPageControlDriver* driver;
@property (nonatomic) id delegateMock;
@end

@implementation BMAGridPageControlDriverTests

- (void)setUp
{
    [super setUp];
    self.driver = [[BMAGridPageControlDriver alloc] init];
    self.delegateMock = [OCMockObject niceMockForProtocol:@protocol(BMAGridPageControlDriverDelegate)];
    self.driver.delegate = self.delegateMock;
}

- (void)tearDown
{
    self.driver = nil;
    self.delegateMock = nil;
    [super tearDown];
}

#pragma mark - Helpers 
- (void)rejectAnyDisplayRowChangeCalls {
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY displayRowChangedFrom:0u];
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY displayRowChangedFrom:1u];
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY displayRowChangedFrom:2u];
}

- (void)rejectAnyCurrentItemChangedCalls {
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY currentItemChangedFrom:0u];
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY currentItemChangedFrom:1u];
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY currentItemChangedFrom:2u];
}

- (void)rejectAnyTotalCountChangedCalls {
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY totalNumberOfItemsChangedFrom:0u];
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY totalNumberOfItemsChangedFrom:1u];
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY totalNumberOfItemsChangedFrom:2u];
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY totalNumberOfItemsChangedFrom:3u];
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY totalNumberOfItemsChangedFrom:4u];
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY totalNumberOfItemsChangedFrom:5u];
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY totalNumberOfItemsChangedFrom:6u];
}

- (void)rejectAnyModeChangedCalls {
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY modeChangedFrom:BMAGridPageControlModePagination];
    [[self.delegateMock reject] pageControlDriver:OCMOCK_ANY modeChangedFrom:BMAGridPageControlModeButton];
}


#pragma mark - Initial values
- (void)testThat_GivenControlCreated_ThenCurrentItemIs0 {
    XCTAssertEqual(self.driver.currentItemIndex, 0u);
}

- (void)testThat_GivenControlCreated_ThenNumberOfItemsIsZero {
    XCTAssertEqual(self.driver.totalNumberOfItems, 0u);
}

#pragma mark - CurrentItemPosition
- (void)testThat_GivenTotalNumberOfItems3_WhenCurrentItemChangedTo4_ThenCurrentItem3{
    self.driver.totalNumberOfItems = 3;
    self.driver.currentItemIndex = 4;
    XCTAssertEqual(self.driver.currentItemIndex, 2u);
}

- (void)testThat_GivenCurrentItem4_WhenCurrentItemChangedTo2_ThenThenCurrentItem2{
    self.driver.totalNumberOfItems = 10;
    self.driver.currentItemIndex = 4;
    self.driver.currentItemIndex = 2;
    XCTAssertEqual(self.driver.currentItemIndex, 2u);
}

- (void)testThat_GivenTotalNumberOfItems10_WhenCurrentItemChangedTo5_ThenCurrentItem5{
    self.driver.totalNumberOfItems = 10;
    self.driver.currentItemIndex = 5;
    XCTAssertEqual(self.driver.currentItemIndex, 5u);
}

- (void)testThat_GivenControlCreated_ThenCurrentItemPositionTopLeft {
    XCTAssertEqual(self.driver.currentItemPosition, BMAGridPageControlItemPositionTopLeft);
}

- (void)testThat_GivenTotalNumberOfItems2_WhenCurrentItemChangedTo0_ThenCurrentItemPositionTopLeft{
    self.driver.totalNumberOfItems = 2;
    self.driver.currentItemIndex = 0;
    XCTAssertEqual(self.driver.currentItemPosition, BMAGridPageControlItemPositionTopLeft);
}

- (void)testThat_GivenTotalNumberOfItems2_WhenCurrentItemChangedTo1_ThenCurrentItemPositionTopRight{
    self.driver.totalNumberOfItems = 2;
    self.driver.currentItemIndex = 1;
    XCTAssertEqual(self.driver.currentItemPosition, BMAGridPageControlItemPositionTopRight);
}

- (void)testThat_GivenTotalNumberOfItems3_WhenCurrentItemChangedTo2_ThenCurrentItemPositionBottomLeft{
    self.driver.totalNumberOfItems = 3;
    self.driver.currentItemIndex = 2;
    XCTAssertEqual(self.driver.currentItemPosition, BMAGridPageControlItemPositionBottomLeft);
}

- (void)testThat_GivenTotalNumberOfItems4_WhenCurrentItemChangedTo3_ThenCurrentItemPositionBottomRight {
    self.driver.totalNumberOfItems = 4;
    self.driver.currentItemIndex = 3;
    XCTAssertEqual(self.driver.currentItemPosition, BMAGridPageControlItemPositionBottomRight);
}

- (void)testThat_GivenTotalNumberOfItems5_WhenCurrentItemChangedTo3_ThenCurrentItemPositionTopRight{
    self.driver.totalNumberOfItems = 5;
    self.driver.currentItemIndex = 3;
    XCTAssertEqual(self.driver.currentItemPosition, BMAGridPageControlItemPositionTopRight);
}

- (void)testThat_GivenTotalNumberOfItems6_WhenCurrentItemChangedTo4_ThenCurrentItemPositionTopRight{
    self.driver.totalNumberOfItems = 6;
    self.driver.currentItemIndex = 3;
    XCTAssertEqual(self.driver.currentItemPosition, BMAGridPageControlItemPositionTopRight);
}

- (void)testThat_GivenTotalNumberOfItems10_WhenCurrentItemChangedTo7_ThenCurrentItemPositionTopRight{
    self.driver.totalNumberOfItems = 10;
    self.driver.currentItemIndex = 7;
    XCTAssertEqual(self.driver.currentItemPosition, BMAGridPageControlItemPositionTopRight);
}

#pragma mark - NumberOfItems in Row
- (void)testThat_GivenZeroItems_ItemsAtRowIsZero {
    XCTAssertEqual([self.driver numberOfItemsInRow:30], 0u);
}

- (void)testThat_GivenFourItems_ThenItemsAtRow30IsZero {
    self.driver.totalNumberOfItems = 4;
    XCTAssertEqual([self.driver numberOfItemsInRow:30], 0u);
}

- (void)testThat_GivenOneItem_ItemsAtRowZeroIsOne_AtRowOneIsOne {
    self.driver.totalNumberOfItems = 1;
    XCTAssertEqual([self.driver numberOfItemsInRow:0], 1u);
    XCTAssertEqual([self.driver numberOfItemsInRow:1], 0u);
}

- (void)testThat_GivenTwoItems_ItemsAtRowZeroIsTwo_AtRowOneIsZero {
    self.driver.totalNumberOfItems = 2;
    XCTAssertEqual([self.driver numberOfItemsInRow:0], 2u);
    XCTAssertEqual([self.driver numberOfItemsInRow:1], 0u);
}

- (void)testThat_GivenThreeItems_ItemsAtRowZeroIsTwo_ItemsAtRowOneIsOne {
    self.driver.totalNumberOfItems = 3;
    XCTAssertEqual([self.driver numberOfItemsInRow:0], 2u);
    XCTAssertEqual([self.driver numberOfItemsInRow:1], 1u);
}

- (void)testThat_GivenFourItems_ItemsAtRowZeroIsTwo_ItemsAtRowOneIsTwo {
    self.driver.totalNumberOfItems = 4;
    XCTAssertEqual([self.driver numberOfItemsInRow:0], 2u);
    XCTAssertEqual([self.driver numberOfItemsInRow:1], 2u);
}

- (void)testThat_GivenFiveItems_ItemsAtRowZeroIsTwo {
    self.driver.totalNumberOfItems = 5;
    XCTAssertEqual([self.driver numberOfItemsInRow:0], 2u);
}

- (void)testThat_GivenFiveItems_ItemsAtRowOneIsTwo {
    self.driver.totalNumberOfItems = 5;
    XCTAssertEqual([self.driver numberOfItemsInRow:1], 2u);
}

- (void)testThat_GivenFiveItems_ItemsAtRowTwoIsOne {
    self.driver.totalNumberOfItems = 5;
    XCTAssertEqual([self.driver numberOfItemsInRow:2], 1u);
}

- (void)testThat_GivenSixItems_ItemsAtRowZeroIsTwo {
    self.driver.totalNumberOfItems = 6;
    XCTAssertEqual([self.driver numberOfItemsInRow:0], 2u);
}

- (void)testThat_GivenSixItems_ItemsAtRowOneIsTwo {
    self.driver.totalNumberOfItems = 6;
    XCTAssertEqual([self.driver numberOfItemsInRow:1], 2u);
}

- (void)testThat_GivenSixItems_ItemsAtRowTwoIsTwo {
    self.driver.totalNumberOfItems = 6;
    XCTAssertEqual([self.driver numberOfItemsInRow:2], 2u);
}

#pragma mark - DisplayStartRow
- (void)testThat_GivenNoData_ThenDisplayRowZero {
    XCTAssertEqual(self.driver.displayRow, 0u);
}

- (void)testThat_GivenOneItem_WhenCurrentItemIsZero_ThenDisplayRowZero {
    self.driver.totalNumberOfItems = 1;
    self.driver.currentItemIndex = 0;
    XCTAssertEqual(self.driver.displayRow, 0u);
}

- (void)testThat_GivenTwoItems_WhenWhenCurrentItemIsOne_ThenDisplayRowZero{
    self.driver.totalNumberOfItems = 2;
    self.driver.currentItemIndex = 1;
    XCTAssertEqual(self.driver.displayRow, 0u);
}

- (void)testThat_GivenThreeItems_WhenWhenCurrentItemIsOne_ThenDisplayRowZero{
    self.driver.totalNumberOfItems = 3;
    self.driver.currentItemIndex = 1;
    XCTAssertEqual(self.driver.displayRow, 0u);
}

- (void)testThat_GivenThreeItems_WhenWhenCurrentItemIsTwo_ThenDisplayRowZero{
    self.driver.totalNumberOfItems = 3;
    self.driver.currentItemIndex = 2;
    XCTAssertEqual(self.driver.displayRow, 0u);
}

- (void)testThat_GivenFourItems_WhenCurrentItemIsZero_ThenDisplayRowZero {
    self.driver.totalNumberOfItems = 4;
    self.driver.currentItemIndex = 0;
    XCTAssertEqual(self.driver.displayRow, 0u);
}

- (void)testThat_GivenFourItems_WhenCurrentItemIsOne_ThenDisplayRowZero {
    self.driver.totalNumberOfItems = 4;
    self.driver.currentItemIndex = 1;
    XCTAssertEqual(self.driver.displayRow, 0u);
}

- (void)testThat_GivenFourItems_WhenCurrentItemIsTwo_ThenDisplayRowZero {
    self.driver.totalNumberOfItems = 4;
    self.driver.currentItemIndex = 2;
    XCTAssertEqual(self.driver.displayRow, 0u);
}

- (void)testThat_GivenFourItems_WhenCurrentItemIsThree_ThenDisplayRowZero {
    self.driver.totalNumberOfItems = 4;
    self.driver.currentItemIndex = 3;
    XCTAssertEqual(self.driver.displayRow, 0u);
}

- (void)testThat_GivenFiveItems_WhenCurrentItemIsThree_ThenDisplayRowOne{
    self.driver.totalNumberOfItems = 5;
    self.driver.currentItemIndex = 3;
    XCTAssertEqual(self.driver.displayRow, 1u);
}

- (void)testThat_GivenFiveItems_WhenCurrentItemIsFour_ThenDisplayRowOne{
    self.driver.totalNumberOfItems = 5;
    self.driver.currentItemIndex = 4;
    XCTAssertEqual(self.driver.displayRow, 1u);
}

- (void)testThat_GivenTenItems_WhenCurrentItemIsSix_ThenDisplayRowTwo{
    self.driver.totalNumberOfItems = 10;
    self.driver.currentItemIndex = 6;
    XCTAssertEqual(self.driver.displayRow, 2u);
}

- (void)testThat_GivenTenItems_WhenCurrentItemIsSeven_ThenDisplayRowThree{
    self.driver.totalNumberOfItems = 10;
    self.driver.currentItemIndex = 7;
    XCTAssertEqual(self.driver.displayRow, 3u);
}

- (void)testThat_GivenTenItems_WhenCurrentItemIsEight_ThenDisplayRowThree{
    self.driver.totalNumberOfItems = 10;
    self.driver.currentItemIndex = 8;
    XCTAssertEqual(self.driver.displayRow, 3u);
}

- (void)testThat_GivenTenItems_WhenCurrentItemIsNine_ThenDisplayRowThree{
    self.driver.totalNumberOfItems = 10;
    self.driver.currentItemIndex = 9;
    XCTAssertEqual(self.driver.displayRow, 3u);
}

#pragma mark - Visible Items In page
- (void)testThat_GivenZeroItem_ThenVisibleItemsIsZero{
    XCTAssertEqual(self.driver.visibleItems, 0u);
}

- (void)testThat_GivenOneItem_ThenVisibleItemsIsOne {
    self.driver.totalNumberOfItems = 1;
    XCTAssertEqual(self.driver.visibleItems, 1u);
}

- (void)testThat_GivenTwoItems_ThenVisibleItemsIsTwo {
    self.driver.totalNumberOfItems = 2;
    XCTAssertEqual(self.driver.visibleItems, 2u);
}

- (void)testThat_GivenThreeItems_ThenVisibleItemsIsThree {
    self.driver.totalNumberOfItems = 3;
    XCTAssertEqual(self.driver.visibleItems, 3u);
}

- (void)testThat_GivenFourItems_ThenVisibleItemsIsThree {
    self.driver.totalNumberOfItems = 4;
    XCTAssertEqual(self.driver.visibleItems, 4u);
}

- (void)testThat_GivenTenItems_ThenVisibleItemsIsFour {
    self.driver.totalNumberOfItems = 10;
    XCTAssertEqual(self.driver.visibleItems, 4u);
}

- (void)testThat_GivenFiveItems_WhenCurrentItemIndexIs3_ThenVisibleItemsIsOne {
    self.driver.totalNumberOfItems = 5;
    self.driver.currentItemIndex = 3;
    XCTAssertEqual(self.driver.visibleItems, 3u);
}

- (void)testThat_GivenSixItems_WhenCurrentItemIndexIs3_ThenVisibleItemsIsTwo {
    self.driver.totalNumberOfItems = 6;
    self.driver.currentItemIndex = 3;
    XCTAssertEqual(self.driver.visibleItems, 4u);
}

#pragma mark - Mode
- (void)testThat_GivenDriverCreated_ThenModeIsPagination {
    XCTAssertEqual(BMAGridPageControlModePagination, self.driver.mode);
}

#pragma mark - Delegate calls
- (void)testThat_WhenCurrentItemChanged_ThenDelegateCallTriggered {
    self.driver.totalNumberOfItems = 3;
    [[self.delegateMock expect] pageControlDriver:self.driver currentItemChangedFrom:0u];
    self.driver.currentItemIndex = 1;
    BMAVerifyMock(self.delegateMock);
}

- (void)testThat_GivenCurrentItemIsFive_WhenCurrentItemChanged_ThenDelegateCallTriggered {
    self.driver.totalNumberOfItems = 5;
    self.driver.currentItemIndex = 2;
    [[self.delegateMock expect] pageControlDriver:self.driver currentItemChangedFrom:2u];
    self.driver.currentItemIndex = 1;
    BMAVerifyMock(self.delegateMock);
}

- (void)testThat_GivenCurrentItemChanges_WhenCurrentWhenDisplayRowAlsoChanges_ThenOnlyTriggersDisplayRowDelegate {
    self.driver.totalNumberOfItems = 5;
    self.driver.currentItemIndex = 2;
    [[self.delegateMock expect] pageControlDriver:self.driver displayRowChangedFrom:0u];
    [self rejectAnyCurrentItemChangedCalls];
    self.driver.currentItemIndex = 3;
    BMAVerifyMock(self.delegateMock);
}

- (void)testThat_GivenCurrentitemChanged_WhenDisplayRowChanges_ThenDelegateCallTriggered{
    self.driver.totalNumberOfItems = 5;
    self.driver.currentItemIndex = 2;
    [[self.delegateMock expect] pageControlDriver:self.driver displayRowChangedFrom:0u];
    self.driver.currentItemIndex = 3;
    BMAVerifyMock(self.delegateMock);
}

- (void)testThat_GivenCurrentitemChanged_WhenDisplayRowDoesNotChange_ThenDelegateCallNotTriggered{
    self.driver.totalNumberOfItems = 5;
    self.driver.currentItemIndex = 1;
    [self rejectAnyDisplayRowChangeCalls];
    self.driver.currentItemIndex = 2;
    BMAVerifyMock(self.delegateMock);
}

- (void)testThat_WhenCurrentItemSetToSame_ThenDelegateCallNotTriggered{
    self.driver.totalNumberOfItems = 10;
    self.driver.currentItemIndex = 1;
    [self rejectAnyCurrentItemChangedCalls];
    [self rejectAnyDisplayRowChangeCalls];
    self.driver.currentItemIndex = 1;
    BMAVerifyMock(self.delegateMock);
}

- (void)testThat_WhenTotalItemCountChanged_ThenDelegateCallTriggered{
    self.driver.totalNumberOfItems = 4;
    [[self.delegateMock expect] pageControlDriver:self.driver totalNumberOfItemsChangedFrom:4];
    self.driver.totalNumberOfItems = 10;
    BMAVerifyMock(self.delegateMock);
}

- (void)testThat_WhenTotalItemCountSame_ThenDelegateCallNotTriggered{
    self.driver.totalNumberOfItems = 4;
    [self rejectAnyTotalCountChangedCalls];
    self.driver.totalNumberOfItems = 4;
    BMAVerifyMock(self.delegateMock);
}

- (void)testThat_GivenModeIsButton_WhenCurrentItemChanged_ThenNoDelegateCallTriggered{
    self.driver.totalNumberOfItems = 10;
    self.driver.mode = BMAGridPageControlModeButton;
    [self rejectAnyCurrentItemChangedCalls];
    self.driver.currentItemIndex = 2;
    BMAVerifyMock(self.delegateMock);
}

- (void)testThat_GivenModeIsButton_WhenTotalCountChanged_ThenNoDelegateCallTriggered{
    self.driver.totalNumberOfItems = 1;
    self.driver.mode = BMAGridPageControlModeButton;
    [self rejectAnyTotalCountChangedCalls];
    self.driver.totalNumberOfItems = 3;
    BMAVerifyMock(self.delegateMock);
}

- (void)testThat_GivenModeIsButton_WhenDisplayRowChanged_ThenNoDelegateCallTriggered{
    self.driver.totalNumberOfItems = 10;
    self.driver.mode = BMAGridPageControlModeButton;
    [self rejectAnyDisplayRowChangeCalls];
    self.driver.currentItemIndex = 3;
    BMAVerifyMock(self.delegateMock);
}

- (void)testThat_GivenModeIsGridPage_WhenModeChangesToButton_ThenDelegateCallTriggered {
    [[self.delegateMock expect] pageControlDriver:self.driver modeChangedFrom:BMAGridPageControlModePagination];
    self.driver.mode = BMAGridPageControlModeButton;
    BMAVerifyMock(self.delegateMock);
}

- (void)testThat_GivenModeIsGridPage_WhenModeSetToGridPage_ThenDelegateIsNotTriggered {
    [self rejectAnyModeChangedCalls];
    self.driver.mode = BMAGridPageControlModePagination;
    BMAVerifyMock(self.delegateMock);
}
@end
