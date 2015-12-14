//
//  CategorieViewController.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/13/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubcategoryViewController.h"

@interface CategoryViewController : UITableViewController

@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) id <SubcategoryViewDelegate> delegate;

- (IBAction)cancelPopover:(UIBarButtonItem *)sender;

@end
