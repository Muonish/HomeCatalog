//
//  FavouriteViewController.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/15/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "FavouriteViewController.h"
#import "DetailViewController.h"
#import "FavouriteViewCell.h"
#import "User.h"
#import "DataBaseCommunicator.h"

@interface FavouriteViewController ()

@end

@implementation FavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.title = @"Delete";
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

- (void)viewDidAppear:(BOOL)animated{
    User *user = [User sharedUser];
    self.items = [[NSMutableArray alloc] init];
    for (NSString *ident in user.favorteIdents) {
        [self.items addObject:[DataBaseCommunicator downloadItemByID:
                               [NSNumber numberWithInt:ident.intValue]]];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showFavDetail"]) {
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        controller.detailItem = self.items[indexPath.row];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavouriteViewCell *cell = (FavouriteViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FavouriteCell" forIndexPath:indexPath];

    Item *object = [self.items objectAtIndex:indexPath.row];
    [cell.image setImage: object.picture];
    cell.seria.text = object.seria;
    cell.name.text = object.name;

    cell.countStay.text = [NSString stringWithFormat:@"%@ шт. в наличии", object.count];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        User *user = [User sharedUser];
        Item *object = [self.items objectAtIndex:indexPath.row];

        if ([user.favorteIdents containsObject:object.ident]) {
            [DataBaseCommunicator deleteFavourite:object.ident];
        } 
        user.favorteIdents = [DataBaseCommunicator downloadFavouritesForUserIdent:user.ident];
        [self.items removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
}



@end
