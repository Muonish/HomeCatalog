//
//  SubcategoryViewController.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/13/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "SubcategoryViewController.h"
#import "DataBaseCommunicator.h"
#import "Subsection.h"

@interface SubcategoryViewController ()

@end

@implementation SubcategoryViewController

static NSString *const cSeries = @"Серии";

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.detailItem isEqualToString:cSeries]) {
        self.data = [DataBaseCommunicator downloadSeries];
    } else {
        self.data = [DataBaseCommunicator downloadSubsections: self.detailItem];
    }

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
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if ([self.detailItem isEqualToString:cSeries]) {
        Seria *seria = [self.data objectAtIndex:indexPath.row];
        cell.textLabel.text = seria.name;
    } else {
        Subsection *subsection = [self.data objectAtIndex:indexPath.row];
        cell.textLabel.text = subsection.name;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;

    if ([self.detailItem isEqualToString:cSeries]) {
        [self.delegate seriaSelected:[self.data objectAtIndex:indexPath.row]];
    } else {
        [self.delegate subcategorySelected:[self.data objectAtIndex:indexPath.row]];
    }
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}


@end
