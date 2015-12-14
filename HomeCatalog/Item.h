//
//  Item.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/13/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface Item : NSObject

@property (strong, nonatomic) NSNumber *ident;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *cost;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) UIImage *picture;
@property (strong, nonatomic) NSNumber *subsection;
@property (strong, nonatomic) NSString *seria;
@property (strong, nonatomic) NSNumber *set;
@property (strong, nonatomic) NSString *producer;

@property (strong, nonatomic) NSArray *materials;
@property (strong, nonatomic) NSArray *measures;

@property (strong, nonatomic) NSString *about;

@end
