//
//  BagViewCell.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/14/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "Bag.h"

@interface BagViewCell : UITableViewCell

@property (weak, nonatomic) Item *item;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *seriaNmae;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *countStay;

@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@property (weak, nonatomic) IBOutlet UILabel *sum;

- (IBAction)valueChanged:(UIStepper *)sender;

@end
