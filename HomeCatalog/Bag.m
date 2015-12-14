//
//  Bag.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/14/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "Bag.h"

@implementation Bag

+ (id)sharedBag {
    static Bag *sharedBag = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBag = [[self alloc] init];
    });
    return sharedBag;
}

@end
