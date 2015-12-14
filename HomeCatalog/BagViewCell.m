//
//  BagViewCell.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/14/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "BagViewCell.h"

@implementation BagViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)valueChanged:(UIStepper *)sender {
    int value = [sender value];
    self.count.text = [NSString stringWithFormat:@"%d", value];

    Bag *bag = [Bag sharedBag];
    [bag.items setObject:[NSNumber numberWithInt:value] forKey:self.item.ident];
    int cost = [self.item.cost intValue] * value;
    self.sum.text = [NSString stringWithFormat:@"%d.-",cost];
}
@end
