//
//  BMACollectionViewCell.m
//  BMAGridPageControlExample
//
//  Created by Miguel Angel Quinones on 23/06/2014.
//  Copyright (c) 2014 Badoo. All rights reserved.
//

#import "BMACollectionViewCell.h"

@implementation BMACollectionViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
