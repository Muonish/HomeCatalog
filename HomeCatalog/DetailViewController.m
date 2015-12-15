//
//  DetailViewController.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/14/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "DetailViewController.h"
#import "DataBaseCommunicator.h"
#import "LoginViewController.h"
#import "Measure.h"
#import "Material.h"
#import "User.h"
#import "Bag.h"

@import UIKit;

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.detailItem) {
        self.seriaName.text = self.detailItem.seria;
        self.itemName.text = self.detailItem.name;
        [self.image setImage: self.detailItem.picture];
        NSString *m = @"";
        for (Measure *measure in self.detailItem.measures) {
            m = [NSString stringWithFormat:@"%@%@: %@ %@\n", m, measure.name, measure.count, measure.unit];
        }

        m = [NSString stringWithFormat:@"%@\nМатериалы и цвета: ", m];
        for (Material *material in self.detailItem.materials) {
            m = [NSString stringWithFormat:@"%@%@ (%@), ", m, material.name, material.color];
        }
        self.sizes.text = m;

        self.about.text = [NSString stringWithFormat:@"%@", self.detailItem.about];
        self.countStay.text = [NSString stringWithFormat:@"%@ шт. в наличии", self.detailItem.count];

        self.number.title = @"0";

        Bag *bag = [Bag sharedBag];
        if (bag.items) {
            if ([bag.items objectForKey:self.detailItem.ident]) {
                self.number.title = [NSString stringWithFormat:@"%@",
                                     [bag.items objectForKey:self.detailItem.ident]];
            }
        }

        User *user = [User sharedUser];
        if ([user.favorteIdents containsObject:self.detailItem.ident]) {
            self.like.image = [UIImage imageNamed:@"likeFilled"];
        } else {
            self.like.image = [UIImage imageNamed:@"like"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"likePop"]) {
        User *user = [User sharedUser];
        if (!user.email) {
            return YES;
        } else {
            User *user = [User sharedUser];
            if (![user.favorteIdents containsObject:self.detailItem.ident]) {
                self.like.image = [UIImage imageNamed:@"likeFilled"];
                [DataBaseCommunicator loadFavourite:self.detailItem.ident];
            } else {
                self.like.image = [UIImage imageNamed:@"like"];
                [DataBaseCommunicator deleteFavourite:self.detailItem.ident];
            }
            user.favorteIdents = [DataBaseCommunicator downloadFavouritesForUserIdent:user.ident];
            return NO;
        }
    }
    return NO;
}

#pragma mark - BarButtons

- (IBAction)barPlus:(UIBarButtonItem *)sender {
    int number = [self.number.title intValue];
    if (([self.detailItem.count intValue] - number) > 0) {
        number++;
        self.number.title = [NSString stringWithFormat:@"%d", number];

        Bag *bag = [Bag sharedBag];
        if (!bag.items) {
            bag.items = [[NSMutableDictionary alloc] init];
        } else {
            [bag.items setObject:[NSNumber numberWithInt:number] forKey:self.detailItem.ident];
        }
    }
}




- (IBAction)barMinus:(UIBarButtonItem *)sender {
    int number = [self.number.title intValue];
    if (number > 0) {
        number--;
        self.number.title = [NSString stringWithFormat:@"%d", number];
        
        Bag *bag = [Bag sharedBag];
        if (!bag.items) {
            bag.items = [[NSMutableDictionary alloc] init];
        } else {
            [bag.items setObject:[NSNumber numberWithInt:number] forKey:self.detailItem.ident];
        }
    }
}
@end
