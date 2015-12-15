//
//  CategorieViewController.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/13/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "CategoryViewController.h"
#import "DataBaseCommunicator.h"
#import "SubcategoryViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.data = [[NSMutableArray alloc] init];
    [self.data addObject:@"Серии"];
    NSArray *arr = [DataBaseCommunicator downloadSections];
    for (NSString *s in arr) {
        [self.data addObject:s];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showSubcategory"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *category = self.data[indexPath.row + 1];
        SubcategoryViewController *controller = (SubcategoryViewController *)[segue destinationViewController];
        controller.detailItem = category;
        controller.delegate = self.delegate;
        //controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((section == 0) ? 1 : (self.data.count - 1));
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if (indexPath.section == 0) {
        cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [self.data objectAtIndex:indexPath.row + 1];
    }
    
    return cell;
}



- (IBAction)cancelPopover:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
