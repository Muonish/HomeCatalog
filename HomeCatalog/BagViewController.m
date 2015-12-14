//
//  BagViewController.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/14/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "BagViewController.h"
#import "BagViewCell.h"
#import "DataBaseCommunicator.h"
#import "Bag.h"
#import "User.h"

@interface BagViewController ()

@end

@implementation BagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.editButtonItem.title = @"Delete";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // Make sure you call super first
    [super setEditing:editing animated:animated];

    if (editing)
    {
        self.editButtonItem.title = NSLocalizedString(@"Done", @"Done");
    }
    else
    {
        self.editButtonItem.title = NSLocalizedString(@"Delete", @"Delete");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    Bag *bag = [Bag sharedBag];
    self.items = [[NSMutableArray alloc] init];
    for (NSString *ident in bag.items) {
        [self.items addObject:[DataBaseCommunicator downloadItemByID:
                               [NSNumber numberWithInt:ident.intValue]]];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BagViewCell *cell = (BagViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BagCell" forIndexPath:indexPath];

    Bag *bag = [Bag sharedBag];
    Item *object = [self.items objectAtIndex:indexPath.row];
    [cell.image setImage: object.picture];
    cell.seriaNmae.text = object.seria;
    cell.name.text = object.name;

    cell.countStay.text = [NSString stringWithFormat:@"%@ шт. в наличии", object.count];
    cell.count.text = [NSString stringWithFormat:@"%@",
                         [bag.items objectForKey:object.ident]];
    cell.item = object;

    int sum = [object.cost intValue] * [[bag.items objectForKey:object.ident] intValue];

    cell.sum.text = [NSString stringWithFormat:@"%d.-",sum];
    cell.stepper.value = [[bag.items objectForKey:object.ident] intValue];
    cell.stepper.maximumValue = [object.count intValue];
    cell.stepper.minimumValue = 0;

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Bag *bag = [Bag sharedBag];
        [bag.items removeObjectForKey:[[self.items objectAtIndex:indexPath.row] ident]];
        [self.items removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
}

#pragma mark - Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"orderPop"]) {
        User *user = [User sharedUser];
        if (!user.email) {
            return YES;
        } else {
            Bag *bag = [Bag sharedBag];
            int sum = 0;
            for (Item *item in self.items) {
                sum += [item.cost intValue] * [[bag.items objectForKey:item.ident] intValue];
            }

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Информация о заказе" message:[NSString stringWithFormat:@"Заказ успешно оформлен. Ожидайте, с вами свяжутся в ближайшее время.\n\nСумма заказа: %d.-", sum] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Продолжить" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return NO;
        }
    }
    return NO;
}

@end
