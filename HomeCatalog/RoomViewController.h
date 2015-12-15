//
//  RoomViewController.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/15/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mail;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@end
