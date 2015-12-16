//
//  DataBaseCommunicator.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/13/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "DataBaseCommunicator.h"
#import "User.h"
#import "Bag.h"
#import "Order.h"

@import UIKit;

@implementation DataBaseCommunicator

+ (NSData *)getDataWithQuery:(NSString *)query
{
    NSString *url = [NSString stringWithFormat: @"http://localhost/course/api.php?%@", query ];
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];

    NSURLResponse *response = nil;
    NSError *error = nil;

    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];

    return data;
}

+ (NSArray *)downloadSections
{
    NSData *data = [DataBaseCommunicator getDataWithQuery:@"f=downloadSections"];

    NSMutableArray *categories = [[NSMutableArray alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Loop through Json objects
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];

        [categories addObject:jsonElement[@"name"]];
    }

    return categories;
}

+ (NSArray *)downloadSubsections: (NSString *)sectionName{

    NSData *data = [DataBaseCommunicator getDataWithQuery:
                    [NSString stringWithFormat:@"f=downloadSubsections&sectionName=%@", sectionName]];

    NSMutableArray *subcategories = [[NSMutableArray alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Loop through Json objects
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];

        Subsection *subsection = [[Subsection alloc] init];
        subsection.ident = jsonElement[@"subsection_id"];
        subsection.name = jsonElement[@"name"];

        [subcategories addObject:subsection];
    }
    
    return subcategories;
}

+ (NSArray *)downloadSeries {
    NSData *data = [DataBaseCommunicator getDataWithQuery:@"f=downloadSeries"];

    NSMutableArray *series = [[NSMutableArray alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Loop through Json objects
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];

        Seria *seria = [[Seria alloc] init];
        seria.ident = jsonElement[@"seria_id"];
        seria.name = jsonElement[@"name"];

        [series addObject:seria];
    }
    
    return series;
}

+ (NSArray *)downloadItems{
    NSData *data = [DataBaseCommunicator getDataWithQuery:@"f=downloadItems"];

    NSMutableArray *items = [[NSMutableArray alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Loop through Json objects
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];

        Item *item = [[Item alloc] init];
        item.ident = jsonElement[@"item_id"];
        item.name = jsonElement[@"name"];
        item.cost = jsonElement[@"cost"];
        item.count = jsonElement[@"count"];
        item.about = jsonElement[@"about"];
        item.producer = jsonElement[@"producer"];
        item.seria = jsonElement[@"seria"];
        item.subsection = jsonElement[@"subsection"];
        item.materials = [DataBaseCommunicator downloadMaterialsForItemIdent:item.ident];
        item.measures = [DataBaseCommunicator downloadMeasuresForItemIdent:item.ident];

        NSString *url = [NSString stringWithFormat:@"http://localhost/course/img/%@",
                         jsonElement[@"picture"]];
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
        item.picture = [UIImage imageWithData:data];

        [items addObject:item];
    }
    return items;
}

+ (NSArray *)downloadItemsInSubsection: (Subsection *)subsection {
    NSData *data = [DataBaseCommunicator getDataWithQuery:
                    [NSString stringWithFormat:@"f=downloadItemsInSubsection&subsectionIdent=%@",subsection.ident]];

    NSMutableArray *items = [[NSMutableArray alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Loop through Json objects
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];

        Item *item = [[Item alloc] init];
        item.ident = jsonElement[@"item_id"];
        item.name = jsonElement[@"name"];
        item.cost = jsonElement[@"cost"];
        item.count = jsonElement[@"count"];
        item.about = jsonElement[@"about"];
        item.producer = jsonElement[@"producer"];
        item.seria = jsonElement[@"seria"];
        item.subsection = subsection.ident;
        item.materials = [DataBaseCommunicator downloadMaterialsForItemIdent:item.ident];
        item.measures = [DataBaseCommunicator downloadMeasuresForItemIdent:item.ident];

        NSString *url = [NSString stringWithFormat:@"http://localhost/course/img/%@",
                         jsonElement[@"picture"]];
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
        item.picture = [UIImage imageWithData:data];

        [items addObject:item];
    }
    return items;
}

+ (NSArray *)downloadItemsInSeria: (Seria *)seria {
//    NSString *query = [NSString stringWithFormat: @"SELECT DISTINCT `item`.`item_id`, `item`.`name`, `item`.`cost`, `item`.`count`, `item`.`about`, `item`.`picture`, `producer`.`name` AS ""producer"", `subsection`.`name` AS ""subsection"" FROM `item`, `producer`,`seria`, `subsection` WHERE `producer`.`producer_id` = `item`.`producer_id` AND `subsection`.`subsection_id` = `item`.`subsection_id` AND `item`.`seria_id` = %@", seria.ident];

    NSData *data = [DataBaseCommunicator getDataWithQuery:
                    [NSString stringWithFormat:@"f=downloadItemsInSeria&seriaIdent=%@",seria.ident]];

    NSMutableArray *items = [[NSMutableArray alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Loop through Json objects
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];

        Item *item = [[Item alloc] init];
        item.ident = jsonElement[@"item_id"];
        item.name = jsonElement[@"name"];
        item.cost = jsonElement[@"cost"];
        item.count = jsonElement[@"count"];
        item.about = jsonElement[@"about"];
        item.producer = jsonElement[@"producer"];
        item.seria = seria.name;
        item.subsection = jsonElement[@"subsection"];
        item.materials = [DataBaseCommunicator downloadMaterialsForItemIdent:item.ident];
        item.measures = [DataBaseCommunicator downloadMeasuresForItemIdent:item.ident];

        NSString *url = [NSString stringWithFormat:@"http://localhost/course/img/%@",
                         jsonElement[@"picture"]];
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
        item.picture = [UIImage imageWithData:data];

        [items addObject:item];
    }
    return items;
}

+ (NSArray *)downloadMaterialsForItemIdent: (NSNumber *)ident {
    NSData *data = [DataBaseCommunicator getDataWithQuery:
                    [NSString stringWithFormat:@"f=downloadMaterialsForItemIdent&itemIdent=%@",ident]];

    // Create an array to store the categories
    NSMutableArray *materials = [[NSMutableArray alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Loop through Json objects
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];

        Material *material = [[Material alloc] init];
        material.name = jsonElement[@"material"];
        material.color = jsonElement[@"color"];

        [materials addObject:material];
    }
    
    return materials;
}

+ (NSArray *)downloadMeasuresForItemIdent: (NSNumber *)ident {

    NSData *data = [DataBaseCommunicator getDataWithQuery:
                    [NSString stringWithFormat:@"f=downloadMeasuresForItemIdent&itemIdent=%@",ident]];

    // Create an array to store the categories
    NSMutableArray *measures = [[NSMutableArray alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Loop through Json objects
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];

        Measure *measure = [[Measure alloc] init];
        measure.name = jsonElement[@"measure"];
        measure.unit = jsonElement[@"unit"];
        measure.count = jsonElement[@"count"];

        [measures addObject:measure];
    }
    
    return measures;
}

+ (Item *)downloadItemByID: (NSNumber *)ident{
    NSData *queryData = [DataBaseCommunicator getDataWithQuery:
                         [NSString stringWithFormat:@"f=downloadItemByID&itemIdent=%@",ident]];

    Item *item = [[Item alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:queryData options:NSJSONReadingAllowFragments error:&error];

    NSDictionary *jsonElement = jsonArray[0];

    item.ident = jsonElement[@"item_id"];
    item.name = jsonElement[@"name"];
    item.cost = jsonElement[@"cost"];
    item.count = jsonElement[@"count"];
    item.about = jsonElement[@"about"];
    item.producer = jsonElement[@"producer"];
    item.seria = jsonElement[@"seria"];
    item.subsection = jsonElement[@"subsection_id"];;
    item.materials = [DataBaseCommunicator downloadMaterialsForItemIdent:item.ident];
    item.measures = [DataBaseCommunicator downloadMeasuresForItemIdent:item.ident];

    NSString *url = [NSString stringWithFormat:@"http://localhost/course/img/%@",
                     jsonElement[@"picture"]];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
        item.picture = [UIImage imageWithData:data];

    return item;
}

+ (void)loadUser: (User *)newUser {
    [DataBaseCommunicator getDataWithQuery:
     [NSString stringWithFormat:@"f=loadUser&email=%@&password=%@&firstName=%@&lastName=%@&address=%@&tel=%@",newUser.email, newUser.password, newUser.firstName, newUser.lastName, newUser.address, newUser.tel]];

    newUser.ident = [DataBaseCommunicator downloadUserIDByMail:newUser.email];

}

+ (BOOL)isUserExistsWithMail: (NSString *)mail{
    if ([DataBaseCommunicator downloadUserIDByMail:mail]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isUserLoginWithMail: (NSString *)mail andPassword: (NSString *)password {
    NSData *queryData = [DataBaseCommunicator getDataWithQuery:
                         [NSString stringWithFormat:@"f=isUserLoginWithMail&mail=%@&password=%@",mail, password]];

    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:queryData options:NSJSONReadingAllowFragments error:&error];

    if (jsonArray.count == 0) {
        return NO;
    } else {
        NSDictionary *jsonElement = jsonArray[0];

        User* user = [User sharedUser];
        user.ident = jsonElement[@"user_id"];
        user.email = jsonElement[@"mail"];
        user.password = jsonElement[@"password"];
        user.firstName = jsonElement[@"first_name"];
        user.lastName = jsonElement[@"last_name"];
        user.address = jsonElement[@"address"];
        user.tel = jsonElement[@"tel"];
        user.orders = [DataBaseCommunicator downloadOrdersForUserIdent:user.ident];
        user.favorteIdents = [DataBaseCommunicator downloadFavouritesForUserIdent:user.ident];

        return YES;
    }
}

+ (NSArray *)downloadOrdersForUserIdent: (NSNumber *)ident {
    NSData *data = [DataBaseCommunicator getDataWithQuery:
                    [NSString stringWithFormat:@"f=downloadOrdersForUserIdent&ident=%@",ident]];

    // Create an array to store the categories
    NSMutableArray *orders = [[NSMutableArray alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Loop through Json objects
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];

        Order *order = [[Order alloc] init];
        order.ident = jsonElement[@"order_id"];
        order.status = jsonElement[@"status"];
        order.date = jsonElement[@"created"];
        order.comment = jsonElement[@"comments"];

        [orders addObject:order];
    }
    
    return orders;
}

+ (NSArray *)downloadFavouritesForUserIdent: (NSNumber *)ident {
    NSData *data = [DataBaseCommunicator getDataWithQuery:
                    [NSString stringWithFormat:@"f=downloadFavouritesForUserIdent&ident=%@",ident]];
    // Create an array to store the categories
    NSMutableArray *fav = [[NSMutableArray alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Loop through Json objects
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];

        [fav addObject:jsonElement[@"item_id"]];
    }
    
    return fav;
}

+ (NSNumber *)downloadUserIDByMail: (NSString *)mail {
    NSData *queryData = [DataBaseCommunicator getDataWithQuery:
                         [NSString stringWithFormat:@"f=downloadUserIDByMail&mail=%@",mail]];

    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:queryData options:NSJSONReadingAllowFragments error:&error];

    if (jsonArray.count > 0) {
        NSDictionary *jsonElement = jsonArray[0];
        return jsonElement[@"user_id"];
    } else {
        return nil;
    }

}

+ (void)loadOrder:(NSString *)comment {
    User *user = [User sharedUser];
    Bag *bag = [Bag sharedBag];

    NSString *query = [NSString stringWithFormat: @"query=INSERT INTO `order`(`status`, `user_id`, `comments`) VALUES ('обработка',%@, %@)",user.ident, comment];

    [DataBaseCommunicator getDataWithQuery:query];

    for (NSString *key in bag.items) {

        int count = [[bag.items objectForKey:key] intValue];

        query = [NSString stringWithFormat: @"query=INSERT INTO `order_item`(`order_id`, `item_id`, `count`) VALUES (((SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'home_catalog' AND TABLE_NAME = 'order') - 1),%@,%d)",key,count];
        [DataBaseCommunicator getDataWithQuery:query];

        query = [NSString stringWithFormat: @"query=UPDATE `item` SET `count`= (`count` - %d) WHERE `item`.`item_id` = %@", count, key];
        [DataBaseCommunicator getDataWithQuery:query];


    }

}

+ (void)loadFavourite: (NSNumber *)itemIdent {
    User *user = [User sharedUser];
    [DataBaseCommunicator getDataWithQuery:
     [NSString stringWithFormat:@"f=loadFavourite&userID=%@&itemID=%@",user.ident, itemIdent]];
}

+ (void)deleteFavourite: (NSNumber *)itemIdent {
    User *user = [User sharedUser];

    [DataBaseCommunicator getDataWithQuery:
     [NSString stringWithFormat:@"f=deleteFavourite&userID=%@&itemID=%@",user.ident, itemIdent]];

}

+ (NSArray *)searchItemsByName: (NSString *)name {
    NSData *data = [DataBaseCommunicator getDataWithQuery:
                    [NSString stringWithFormat:@"f=searchItemsByName&name=%@",name]];

    NSMutableArray *items = [[NSMutableArray alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Loop through Json objects

    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];

        Item *item = [[Item alloc] init];
        item.ident = jsonElement[@"item_id"];
        item.name = jsonElement[@"name"];
        item.cost = jsonElement[@"cost"];
        item.count = jsonElement[@"count"];
        item.about = jsonElement[@"about"];
        item.producer = jsonElement[@"producer"];
        item.seria = jsonElement[@"seria"];
        item.subsection = jsonElement[@"subsection"];
        item.materials = [DataBaseCommunicator downloadMaterialsForItemIdent:item.ident];
        item.measures = [DataBaseCommunicator downloadMeasuresForItemIdent:item.ident];

        NSString *url = [NSString stringWithFormat:@"http://localhost/course/img/%@",
                         jsonElement[@"picture"]];
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
        item.picture = [UIImage imageWithData:data];

        [items addObject:item];
    }
    return items;

}

+ (NSArray *)searchItemsBySeria: (NSString *)seriaName {
    NSData *data = [DataBaseCommunicator getDataWithQuery:
                    [NSString stringWithFormat:@"f=searchItemsBySeria&name=%@",seriaName]];

    NSMutableArray *items = [[NSMutableArray alloc] init];

    // Parse the JSON that came in
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Loop through Json objects

    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];

        Item *item = [[Item alloc] init];
        item.ident = jsonElement[@"item_id"];
        item.name = jsonElement[@"name"];
        item.cost = jsonElement[@"cost"];
        item.count = jsonElement[@"count"];
        item.about = jsonElement[@"about"];
        item.producer = jsonElement[@"producer"];
        item.seria = jsonElement[@"seria"];
        item.subsection = jsonElement[@"subsection"];
        item.materials = [DataBaseCommunicator downloadMaterialsForItemIdent:item.ident];
        item.measures = [DataBaseCommunicator downloadMeasuresForItemIdent:item.ident];

        NSString *url = [NSString stringWithFormat:@"http://localhost/course/img/%@",
                         jsonElement[@"picture"]];
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
        item.picture = [UIImage imageWithData:data];

        [items addObject:item];
    }
    return items;
}

@end
