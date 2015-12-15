//
//  ItemsViewController.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/13/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "ItemsViewController.h"
#import "DetailViewController.h"
#import "ItemCollectionViewCell.h"
#import "CategoryViewController.h"
#import "DataBaseCommunicator.h"

@interface ItemsViewController ()

@end

@implementation ItemsViewController

static NSString * const reuseIdentifier = @"ReuseID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tapper = [[UITapGestureRecognizer alloc]
                   initWithTarget:self action:@selector(handleSingleTap:)];
    self.tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapper];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SubcategoryViewDelegate

- (void) subcategorySelected: (Subsection *) subsection{
    self.navigationItem.title = subsection.name;
    self.data = [DataBaseCommunicator downloadItemsInSubsection:subsection];
    [self.collectionView reloadData];
}

- (void) seriaSelected: (Seria *) seria{
    self.navigationItem.title = seria.name;
    self.data = [DataBaseCommunicator downloadItemsInSeria:seria];
    [self.collectionView reloadData];
}

#pragma mark - TextFeild Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.search && ![textField.text isEqualToString:@""]) {
        self.data = [DataBaseCommunicator searshItemsByName:self.search.text];
        if (self.data.count == 0) {
            self.data = [DataBaseCommunicator searshItemsBySeria:self.search.text];
            if (self.data.count == 0) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Результаты поиска." message:@"Ничего не найдено."preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"Продолжить" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
            }
        }
        [self.collectionView reloadData];
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"popup"]) {

        CategoryViewController *controller = (CategoryViewController *)[[segue destinationViewController] topViewController];
        controller.delegate = self;
        //controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        //controller.navigationItem.leftItemsSupplementBackButton = YES;

    } else if([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        controller.detailItem = self.data[indexPath.row];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.data) {
        return self.data.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCollectionViewCell *cell = (ItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Item *object = [self.data objectAtIndex:indexPath.row];

    [cell.image setImage: object.picture];
    cell.name.text = [NSString stringWithFormat:@"%@ %@", object.seria, object.name];
    cell.cost.text = [NSString stringWithFormat:@"%@.-", object.cost];
    
    return cell;
}


@end
