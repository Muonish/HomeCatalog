//
//  DetailViewController.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/14/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface DetailViewController : UITableViewController

@property (strong, nonatomic) Item *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *seriaName;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *countStay;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *sizes;
@property (weak, nonatomic) IBOutlet UITextView *about;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *number;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *like;
@property (nonatomic, strong) UIPopoverController *popOverController;

- (IBAction)barLike:(UIBarButtonItem *)sender;
- (IBAction)barMinus:(UIBarButtonItem *)sender;
- (IBAction)barPlus:(UIBarButtonItem *)sender;

@end
