//
//  ItemsViewController.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/13/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubcategoryViewController.h"

@interface ItemsViewController : UICollectionViewController <SubcategoryViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *search;

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) UIGestureRecognizer *tapper;


@end
