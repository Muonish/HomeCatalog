//
//  DataBaseCommunicator.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/13/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subsection.h"
#import "Seria.h"
#import "Item.h"
#import "User.h"
#import "Material.h"
#import "Measure.h"

@interface DataBaseCommunicator : NSObject

+ (NSData *)getDataWithQuery:(NSString *)url;


+ (NSArray *)downloadSections;
+ (NSArray *)downloadSubsections: (NSString *)sectionName;
+ (NSArray *)downloadSeries;
+ (NSArray *)downloadItems;
+ (NSArray *)downloadItemsInSubsection: (Subsection *)subsection;
+ (NSArray *)downloadItemsInSeria: (Seria *)seria;
+ (NSArray *)downloadOrdersForUserIdent: (NSNumber *)ident;
+ (NSArray *)downloadFavouritesForUserIdent: (NSNumber *)ident;
+ (Item *)downloadItemByID: (NSNumber *)ident;
+ (BOOL)isUserExistsWithMail: (NSString *)mail;
+ (BOOL)isUserLoginWithMail: (NSString *)mail andPassword: (NSString *)password;
+ (void)loadUser: (User *)newUser;
+ (void)loadOrder: (NSString *)comment;
+ (void)loadFavourite: (NSNumber *)itemIdent;
+ (void)deleteFavourite: (NSNumber *)itemIdent;

+ (NSArray *)searchItemsByName: (NSString *)name;
+ (NSArray *)searchItemsBySeria: (NSString *)seriaName;

@end
