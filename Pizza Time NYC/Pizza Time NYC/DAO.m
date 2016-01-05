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
	//TwoBros PizzaPlaces //as of 12.26.15 we have 7 TB
	// name, address, image, url, Lat / Long
	PizzaPlace *tb32_stMarks = [[PizzaPlace alloc]init];
	PizzaPlace *tb542_9thAve = [[PizzaPlace alloc]init];
	PizzaPlace *tb601_6thAve = [[PizzaPlace alloc]init];
	PizzaPlace *tb557_8thAve = [[PizzaPlace alloc]init];
	PizzaPlace *tb31_46thSt = [[PizzaPlace alloc]init];
	PizzaPlace *tb755_6thAve = [[PizzaPlace alloc]init];
	PizzaPlace *tb319_6thAve = [[PizzaPlace alloc]init];
	
	tb32_stMarks.pizzaPlaceName = @"Two Bros 32 St. Marks";
	tb542_9thAve.pizzaPlaceName = @"Two Bros 542 9th Ave";
	tb601_6thAve.pizzaPlaceName = @"Two Bros 601 6th Ave";
	tb557_8thAve.pizzaPlaceName = @"Two Bros 557 8th Ave";
	tb31_46thSt.pizzaPlaceName = @"Two Bros 31 46th St";
	tb755_6thAve.pizzaPlaceName = @"Two Bros 755 6th Ave";
	tb319_6thAve.pizzaPlaceName = @"Two Bros 319 6th Ave";
	
	tb32_stMarks.pizzaPlaceAddress = @"32 Saint Marks Place New York NY 10003";
	tb32_stMarks.pizzaPlaceLatitude = 40.728677;
	tb32_stMarks.pizzaPlaceLongitude = -73.988488;
	
	tb542_9thAve.pizzaPlaceAddress = @"542 9th Ave New York NY 10018";
	tb542_9thAve.pizzaPlaceLatitude = 40.756921;
	tb542_9thAve.pizzaPlaceLongitude = -73.993333;
	
	tb601_6thAve.pizzaPlaceAddress = @"601 6th Ave New York NY 10011";
	tb601_6thAve.pizzaPlaceLatitude = 40.739602;
	tb601_6thAve.pizzaPlaceLongitude = -73.995534;
	
	tb557_8thAve.pizzaPlaceAddress = @"557 8th Ave New York NY 10018";
	tb557_8thAve.pizzaPlaceLatitude = 40.754742;
	tb557_8thAve.pizzaPlaceLongitude = -73.992015;
	
	tb31_46thSt.pizzaPlaceAddress = @"31 West 46th St New York NY 10036";
	tb31_46thSt.pizzaPlaceLatitude = 40.756775;
	tb31_46thSt.pizzaPlaceLongitude = -73.980227;
	
	tb755_6thAve.pizzaPlaceAddress = @"755 6th Ave New York NY 10010";
	tb755_6thAve.pizzaPlaceLatitude = 40.744382;
	tb755_6thAve.pizzaPlaceLongitude = -73.992049;
	
	tb319_6thAve.pizzaPlaceAddress = @"319 6th Avenue New York NY 10014";
	tb319_6thAve.pizzaPlaceLatitude = 40.731076;
	tb319_6thAve.pizzaPlaceLongitude = -74.001708;
	
	self.pizzaPlaceArray = [[NSMutableArray alloc]initWithArray:@[tb32_stMarks, tb542_9thAve, tb601_6thAve, tb557_8thAve, tb31_46thSt, tb755_6thAve, tb319_6thAve]];
		//	NSLog(@"PizzaPlaceArry:%@", self.pizzaPlaceArray);
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
