//
//  ItemCollectionViewCell.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/13/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "ItemCollectionViewCell.h"

@implementation ItemCollectionViewCell

@synthesize name = _name;
@synthesize cost = _cost;
@synthesize image = _image;

- (id)initWithFrame:(CGRect)aRect {
    self = [super initWithFrame:aRect];
    self.name.text = @"label";
    return self;
}



@end
