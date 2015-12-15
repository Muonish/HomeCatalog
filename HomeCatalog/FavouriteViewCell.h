//
//  FavouriteViewCell.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/15/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *seria;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *countStay;

@end
