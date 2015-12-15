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
    NSString *url = [NSString stringWithFormat: @"http://localhost/course/api.php?query=%@", query ];
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
    NSString *query = @"SELECT name FROM section";

    NSData *data = [DataBaseCommunicator getDataWithQuery:query];

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
    NSString *query = [NSString stringWithFormat: @"SELECT `subsection`.`subsection_id`, `subsection`.`name` FROM `subsection` JOIN `section` ON `section`.`section_id` = `subsection`.`section_id` WHERE `section`.`name` = '%@'", sectionName];

    NSData *data = [DataBaseCommunicator getDataWithQuery:query];

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
    NSString *query = [NSString stringWithFormat: @"SELECT `seria`.`seria_id`, `seria`.`name` FROM `seria` "];

    NSData *data = [DataBaseCommunicator getDataWithQuery:query];

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

+ (NSArray *)downloadItemsInSubsection: (Subsection *)subsection {
    NSString *query = [NSString stringWithFormat: @"SELECT `item`.`item_id`, `item`.`name`, `item`.`cost`, `item`.`count`, `item`.`about`, `item`.`picture`, `producer`.`name` AS ""producer"", `seria`.`name` AS ""seria"" FROM `item`, `producer`,`seria` WHERE `producer`.`producer_id` = `item`.`producer_id` AND `seria`.`seria_id` = `item`.`seria_id` AND `item`.`subsection_id` = %@", subsection.ident];

    NSData *data = [DataBaseCommunicator getDataWithQuery:query];

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
    NSString *query = [NSString stringWithFormat: @"SELECT DISTINCT `item`.`item_id`, `item`.`name`, `item`.`cost`, `item`.`count`, `item`.`about`, `item`.`picture`, `producer`.`name` AS ""producer"", `subsection`.`name` AS ""subsection"" FROM `item`, `producer`,`seria`, `subsection` WHERE `producer`.`producer_id` = `item`.`producer_id` AND `subsection`.`subsection_id` = `item`.`subsection_id` AND `item`.`seria_id` = %@", seria.ident];

    NSData *data = [DataBaseCommunicator getDataWithQuery:query];

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
    NSString *query = [NSString stringWithFormat: @"SELECT DISTINCT `material`.`name` AS ""material"", `color`.`name` AS ""color"" FROM `material`, `color`, `material_color`, `material_color_item` WHERE `material`.`material_id` = `material_color`.`material_id` AND `color`.`color_id` = `material_color`.`color_id` AND `material_color`.`material_color_id` = `material_color_item`.`material_color_id` AND `material_color_item`.`item_id` = %@", ident];

    NSData *data = [DataBaseCommunicator getDataWithQuery:query];

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
    NSString *query = [NSString stringWithFormat: @"SELECT DISTINCT `measure`.`name` AS ""measure"", `unit`.`name` AS ""unit"", `unit_measure_item`.`count` FROM `measure`, `unit`, `unit_measure_item` WHERE `measure`.`measure_id` = `unit_measure_item`.`measure_id` AND `unit`.`unit_id` = `unit_measure_item`.`unit_id` AND `unit_measure_item`.`item_id` = %@", ident];

    NSData *data = [DataBaseCommunicator getDataWithQuery:query];

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
    NSString *query = [NSString stringWithFormat: @"SELECT `item`.`item_id`, `item`.`name`, `item`.`cost`, `item`.`count`, `item`.`about`, `item`.`picture`, `producer`.`name` AS ""producer"", `seria`.`name` AS ""seria"", `item`.`subsection_id` AS ""subsection_id"" FROM `item`, `producer`,`seria` WHERE `producer`.`producer_id` = `item`.`producer_id` AND `seria`.`seria_id` = `item`.`seria_id` AND `item`.`item_id` = %@",ident];

    NSData *queryData = [DataBaseCommunicator getDataWithQuery:query];

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
    NSString *query = [NSString stringWithFormat: @"INSERT INTO `user`(`mail`, `password`, `status`, `user_type_id`) VALUES ('%@','%@','active',(SELECT `user_type_id` FROM `user_type` WHERE `user_type`.`name` = 'user'))",newUser.email, newUser.password];

    [DataBaseCommunicator getDataWithQuery:query];

    NSString *queryInfo = [NSString stringWithFormat: @"INSERT INTO `user_info`(`user_id`, `first_name`, `last_name`, `address`, `tel`) VALUES ((SELECT `user_id` FROM `user` WHERE `user`.`mail` = '%@'),'%@','%@','%@','%@')",newUser.email, newUser.firstName, newUser.lastName, newUser.address, newUser.tel];

    [DataBaseCommunicator getDataWithQuery:queryInfo];

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
    NSString *query = [NSString stringWithFormat: @"SELECT `user`.`user_id`, `user`.`mail`, `user`.`password`, `user_info`.`first_name`, `user_info`.`last_name`, `user_info`.`address`, `user_info`.`tel` FROM `user`, `user_info` WHERE `user`.`user_id` = `user_info`.`user_id` AND `user`.`mail` = '%@' AND `user`.`password` = '%@'",mail, password];

    NSData *queryData = [DataBaseCommunicator getDataWithQuery:query];

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
    NSString *query = [NSString stringWithFormat: @"SELECT `order_id`, `status`, `created`, `comments` FROM `order` WHERE `order`.`user_id` = %@", ident];

    NSData *data = [DataBaseCommunicator getDataWithQuery:query];

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
    NSString *query = [NSString stringWithFormat: @"SELECT `favorite`.`item_id` FROM `favorite` WHERE `favorite`.`user_id` = %@ ", ident];

    NSData *data = [DataBaseCommunicator getDataWithQuery:query];

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
    NSString *query = [NSString stringWithFormat: @"SELECT `user_id` FROM `user` WHERE `user`.`mail` = '%@'",mail];

    NSData *queryData = [DataBaseCommunicator getDataWithQuery:query];

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

    NSString *query = [NSString stringWithFormat: @"INSERT INTO `order`(`status`, `user_id`, `comments`) VALUES ('обработка',%@, %@)",user.ident, comment];

    [DataBaseCommunicator getDataWithQuery:query];

    for (NSString *key in bag.items) {

        int count = [[bag.items objectForKey:key] intValue];

        query = [NSString stringWithFormat: @"INSERT INTO `order_item`(`order_id`, `item_id`, `count`) VALUES (((SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'home_catalog' AND TABLE_NAME = 'order') - 1),%@,%d)",key,count];
        [DataBaseCommunicator getDataWithQuery:query];

        query = [NSString stringWithFormat: @"UPDATE `item` SET `count`= (`count` - %d) WHERE `item`.`item_id` = %@", count, key];
        [DataBaseCommunicator getDataWithQuery:query];


    }

}

+ (void)loadFavourite: (NSNumber *)itemIdent {
    User *user = [User sharedUser];
    NSString *query = [NSString stringWithFormat: @"INSERT INTO `favorite`(`user_id`, `item_id`) VALUES (%@,%@)",user.ident, itemIdent];

    [DataBaseCommunicator getDataWithQuery:query];
}

+ (void)deleteFavourite: (NSNumber *)itemIdent {
    User *user = [User sharedUser];
    NSString *query = [NSString stringWithFormat: @"DELETE FROM `favorite` WHERE `favorite`.`user_id` = %@ AND `favorite`.`item_id` = %@",user.ident, itemIdent];

    [DataBaseCommunicator getDataWithQuery:query];
    NSLog(@"%@",query);

}

+ (NSArray *)searshItemsByName: (NSString *)name {
    NSString *query = [NSString stringWithFormat: @"SELECT `item`.`item_id`, `item`.`name`, `item`.`cost`, `item`.`count`, `item`.`about`, `item`.`picture`, `producer`.`name` AS ""producer"", `seria`.`name` AS ""seria"", `subsection`.`name` AS ""subsection"" FROM `item`, `producer`,`seria`, `subsection` WHERE `producer`.`producer_id` = `item`.`producer_id` AND `seria`.`seria_id` = `item`.`seria_id` AND `subsection`.`subsection_id` = `item`.`subsection_id` AND LOWER(`item`.`name`) REGEXP LOWER('^.*%@.*$') ", name];

    NSData *data = [DataBaseCommunicator getDataWithQuery:query];

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

+ (NSArray *)searshItemsBySeria: (NSString *)seriaName {
    NSString *query = [NSString stringWithFormat: @"SELECT `item`.`item_id`, `item`.`name`, `item`.`cost`, `item`.`count`, `item`.`about`, `item`.`picture`, `producer`.`name` AS ""producer"", `seria`.`name` AS ""seria"", `subsection`.`name` AS ""subsection"" FROM `item`, `producer`,`seria`, `subsection` WHERE `producer`.`producer_id` = `item`.`producer_id` AND `seria`.`seria_id` = `item`.`seria_id` AND `subsection`.`subsection_id` = `item`.`subsection_id` AND LOWER(`seria`.`name`) REGEXP LOWER('^.*%@.*$') ", seriaName];

    NSData *data = [DataBaseCommunicator getDataWithQuery:query];

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
