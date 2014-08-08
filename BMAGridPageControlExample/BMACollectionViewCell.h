//
//  BMACollectionViewCell.h
//  BMAGridPageControlExample
//
//  Created by Miguel Angel Quinones on 23/06/2014.
//  Copyright (c) 2014 Badoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMACollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

+ (UINib *)nib;
@end
