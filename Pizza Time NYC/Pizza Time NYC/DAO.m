//
//  DAO.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/4/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "DAO.h"

@implementation DAO


-(void)createPizzaPlaces
{
	if (!self.pizzaPlaceArray) {// if data has not loaded, load. Else, ...
		
		//TwoBros PizzaPlaces //as of 12.26.15 we have 7 TB
	// name, address, image, url, Lat / Long
	PizzaPlace *tb32_stMarks = [[PizzaPlace alloc]init];
	PizzaPlace *tb542_9thAve = [[PizzaPlace alloc]init];
	PizzaPlace *tb601_6thAve = [[PizzaPlace alloc]init];
	PizzaPlace *tb557_8thAve = [[PizzaPlace alloc]init];
	PizzaPlace *tb31_46thSt = [[PizzaPlace alloc]init];
	PizzaPlace *tb755_6thAve = [[PizzaPlace alloc]init];
	PizzaPlace *tb319_6thAve = [[PizzaPlace alloc]init];
	
	tb32_stMarks.name = @"Two Bros 32 St. Marks";
	tb542_9thAve.name = @"Two Bros 542 9th Ave";
	tb601_6thAve.name = @"Two Bros 601 6th Ave";
	tb557_8thAve.name = @"Two Bros 557 8th Ave";
	tb31_46thSt.name = @"Two Bros 31 46th St";
	tb755_6thAve.name = @"Two Bros 755 6th Ave";
	tb319_6thAve.name = @"Two Bros 319 6th Ave";
	
	tb32_stMarks.address = @"32 Saint Marks Place New York NY 10003";
	tb32_stMarks.street = @"32 Saint Marks Place";
	tb32_stMarks.city = @"New York NY";
	tb32_stMarks.zip = 10003;
	tb32_stMarks.latitude = 40.728677;
	tb32_stMarks.longitude = -73.988488;
	
	tb542_9thAve.address = @"542 9th Ave New York NY 10018";
	tb542_9thAve.street = @"542 9th Ave";
	tb542_9thAve.city = @"New York NY";
	tb542_9thAve.zip = 10018;
	tb542_9thAve.latitude = 40.756921;
	tb542_9thAve.longitude = -73.993333;
	
	tb601_6thAve.address = @"601 6th Ave New York NY 10011";
	tb601_6thAve.street = @"601 6th Ave";
	tb601_6thAve.city = @"New York NY";
	tb601_6thAve.zip = 10011;
	tb601_6thAve.latitude = 40.739602;
	tb601_6thAve.longitude = -73.995534;
	
	tb557_8thAve.address = @"557 8th Ave New York NY 10018";
	tb557_8thAve.street = @"557 8th Ave";
	tb557_8thAve.city = @"New York NY";
	tb557_8thAve.zip = 10018;
	tb557_8thAve.latitude = 40.754742;
	tb557_8thAve.longitude = -73.992015;
	
	tb31_46thSt.address = @"31 West 46th St New York NY 10036";
	tb31_46thSt.street = @"31 West 46th St";
	tb31_46thSt.city = @"New York NY";
	tb31_46thSt.zip = 10036;
	tb31_46thSt.latitude = 40.756775;
	tb31_46thSt.longitude = -73.980227;
	
	tb755_6thAve.address = @"755 6th Ave New York NY 10010";
	tb755_6thAve.street = @"755 6th Ave";
	tb755_6thAve.city = @"New York NY";
	tb755_6thAve.zip = 10010;
	tb755_6thAve.latitude = 40.744382;
	tb755_6thAve.longitude = -73.992049;
	
	tb319_6thAve.address = @"319 6th Avenue New York NY 10014";
	tb319_6thAve.street = @"319 6th Avenue";
	tb319_6thAve.city = @"New York NY";
	tb319_6thAve.zip = 10014;
	tb319_6thAve.latitude = 40.731076;
	tb319_6thAve.longitude = -74.001708;
	
	self.pizzaPlaceArray = [[NSMutableArray alloc]initWithArray:@[tb32_stMarks, tb542_9thAve, tb601_6thAve, tb557_8thAve, tb31_46thSt, tb755_6thAve, tb319_6thAve]];
//			NSLog(@"PizzaPlaceArray:%@", self.pizzaPlaceArray);
	}
	else
	{
//		NSLog(@"already exists");
	}

}

+ (instancetype)sharedDAO
{
	static DAO *sharedDAO = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedDAO = [[DAO alloc] init];
		// Do any other initialisation stuff here
	});
	return sharedDAO;
}


@end
