//
//  BMAGridPageControl_Private.h
//  Badoo
//
//  Created by Miguel Angel Quinones on 05/11/2013.
//  Copyright (c) 2013 Badoo Ltd. All rights reserved.
//

#import "BMAGridPageControl.h"
#import "BMAGridPageControlDriver.h"

@interface BMAGridPageControl () <BMAGridPageControlDriverDelegate>
@property (nonatomic, strong) BMAGridPageControlDriver* driver;
@property (nonatomic, strong) UIImageView* background;
@property (nonatomic, strong) NSMutableArray* itemImages;

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *itemImage;
@property (nonatomic, readonly) CGFloat itemHiddenAlpha;
@end
