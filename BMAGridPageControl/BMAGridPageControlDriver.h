//
//  BMAGridPageControlDriver.h
//  Badoo
//
//  Created by Miguel Angel Quinones on 05/11/2013.
//  Copyright (c) 2013 Badoo Ltd. All rights reserved.
//

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
