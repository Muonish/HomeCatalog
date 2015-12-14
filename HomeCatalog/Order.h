//
//  Order.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/15/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (strong, nonatomic) NSNumber *ident;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *date;

@property (strong, nonatomic) NSMutableDictionary *items;

@end
