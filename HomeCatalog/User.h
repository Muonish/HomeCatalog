//
//  User.h
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/14/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSNumber *ident;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *tel;
@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSMutableArray *favorteIdents;
@property (strong, nonatomic) NSMutableArray *orders;

+ (id)sharedUser;

@end
