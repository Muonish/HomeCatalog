//
//  Bag.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/14/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bag : NSObject

@property(strong, nonatomic) NSMutableDictionary *items;

+ (id)sharedBag;

@end
