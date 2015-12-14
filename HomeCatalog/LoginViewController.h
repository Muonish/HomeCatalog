//
//  LoginViewController.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/14/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *mail;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)cancelPopover:(UIBarButtonItem *)sender;
- (IBAction)enterUser:(UIButton *)sender;

@end
