//
//  RoomViewController.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/15/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "RoomViewController.h"
#
#import "User.h"

@interface RoomViewController ()

@end

@implementation RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    User *user = [User sharedUser];
    if (user.email) {
        self.name.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        self.mail.text = user.email;
        self.address.text = user.address;
        self.phone.text = user.tel;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"showOrders"]) {
//
//        CategoryViewController *controller = (CategoryViewController *)[[segue destinationViewController] topViewController];
//        controller.delegate = self;
//        //controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        //controller.navigationItem.leftItemsSupplementBackButton = YES;
//
//    } else if([[segue identifier] isEqualToString:@"showDetail"]) {
//        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
//        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
//        controller.detailItem = self.data[indexPath.row];
//    }
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    User *user = [User sharedUser];
    if (user.email) {
        return 2;
    } else {
        return 0;
    }
}




@end
