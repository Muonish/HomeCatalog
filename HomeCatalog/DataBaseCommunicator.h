//
//  DataBaseCommunicator.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/13/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subsection.h"
#import "Item.h"
#import "User.h"
#import "Material.h"
#import "Measure.h"

@interface DataBaseCommunicator : NSObject

+ (NSData *)getDataWithQuery:(NSString *)url;


+ (NSArray *)downloadSections;
+ (NSArray *)downloadSubsections: (NSString *)sectionName;
+ (NSArray *)downloadItemsInSubsection: (Subsection *)subsection;
+ (Item *)downloadItemByID: (NSNumber *)ident;
+ (BOOL)isUserExistsWithMail: (NSString *)mail;
+ (BOOL)isUserLoginWithMail: (NSString *)mail andPassword: (NSString *)password;
+ (void)loadUser: (User *)newUser;

@end
