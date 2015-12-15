//
//  OrdersViewController.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/15/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "OrdersViewController.h"
#import "DataBaseCommunicator.h"
#import "User.h"
#import "Order.h"

@interface OrdersViewController ()

@end

@implementation OrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    User *user = [User sharedUser];
    self.orders = user.orders;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Order *object = [self.orders objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"№%@ (%@)", object.ident, object.status];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@         Сумма: %@.-", object.date, object.comment];
    
    return cell;
}

@end
