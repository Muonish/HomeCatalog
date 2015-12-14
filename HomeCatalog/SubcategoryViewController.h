//
//  SubcategoryViewController.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/13/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subsection.h"

@protocol SubcategoryViewDelegate;

@interface SubcategoryViewController : UITableViewController

@property (strong, nonatomic) NSString *detailItem;
@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) id <SubcategoryViewDelegate> delegate;

@end

@protocol SubcategoryViewDelegate <NSObject>

@required
- (void) subcategorySelected: (Subsection *) subsection;

@end
