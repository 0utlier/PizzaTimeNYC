//
//  DAO.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/4/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "DAO.h"

@implementation DAO

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

- (NSMutableArray *) pizzaPlaceArray { // every time that pizzaPlaceArray GETS assigned, this gets called
	if (!_pizzaPlaceArray) {
		_pizzaPlaceArray = [NSMutableArray new];
	}
	return _pizzaPlaceArray;
}


#pragma mark - PARSE

-(void) downloadParsePP {
	// iterate through and create PP instance for place
	PFQuery *query = [PFQuery queryWithClassName:@"PizzaPlaceParse"];
	
	// Sorts the results in ascending order by the ZIP field
	[query orderByAscending:@"zip"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *parseArray, NSError *error) {
		if (!error) {
			// The find succeeded.
			NSLog(@"Successfully retrieved %lu pizzaPlaces from PARSE DB", (unsigned long)parseArray.count);
			// Do something with the found objects
			PizzaPlace *pizzaPlace = nil;
			self.pizzaPlaceArray = [[NSMutableArray alloc]init]; // removed old one, and replace with new
			for (PFObject *pizzaPlaceParse in parseArray) {
				
				pizzaPlace = [[PizzaPlace alloc]init]; // allocate the new instance
				// assign its values from the objects
				pizzaPlace.name = pizzaPlaceParse[@"name"];
				pizzaPlace.address = pizzaPlaceParse[@"address"];
				pizzaPlace.street = pizzaPlaceParse[@"street"];
				pizzaPlace.city = pizzaPlaceParse[@"city"];
				pizzaPlace.zip = [pizzaPlaceParse[@"zip"]integerValue];
				pizzaPlace.latitude = [pizzaPlaceParse[@"latitude"]floatValue];
				pizzaPlace.longitude = [pizzaPlaceParse[@"longitude"]floatValue];
				
				[self.pizzaPlaceArray addObject:pizzaPlace];
				[pizzaPlaceParse pinInBackground]; // this is for local Storage
				//					NSLog(@"my array is = %@", self.pizzaPlaceArray);
			}
		}
		else {
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}

-(void) fromLocalDataPP {
	PFQuery *query = [PFQuery queryWithClassName:@"PizzaPlaceParse"];
	[query fromLocalDatastore];
	[query findObjectsInBackgroundWithBlock:^(NSArray *parseArray, NSError *error) {
		if (!error) {
			// The find succeeded.
			NSLog(@"Successfully retrieved %lu pizzaPlaces from LOCAL", (unsigned long)parseArray.count);
			// Do something with the found objects
			PizzaPlace *pizzaPlace = nil;
			for (PFObject *pizzaPlaceParse in parseArray) {
				
				pizzaPlace = [[PizzaPlace alloc]init]; // allocate the new instance
				// assign its values from the objects
				pizzaPlace.name = pizzaPlaceParse[@"name"];
				pizzaPlace.address = pizzaPlaceParse[@"address"];
				pizzaPlace.street = pizzaPlaceParse[@"street"];
				pizzaPlace.city = pizzaPlaceParse[@"city"];
				pizzaPlace.zip = [pizzaPlaceParse[@"zip"]integerValue];
				pizzaPlace.latitude = [pizzaPlaceParse[@"latitude"]floatValue];
				pizzaPlace.longitude = [pizzaPlaceParse[@"longitude"]floatValue];
				
				
				[self.pizzaPlaceArray addObject:pizzaPlace];
				//					NSLog(@"my array is = %@", self.pizzaPlaceArray);
			}
		}
		else {
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
		if (parseArray == nil || parseArray.count == 0) {
			[self downloadParsePP];
		}
	}];
}

- (void)downloadParseGifs {
	// iterate through and create PFFile instance for Gif
	PFQuery *query = [PFQuery queryWithClassName:@"GifParse"];
	
	// Sorts the results in ascending order by the updated field
	[query orderByAscending:@"updatedAt"];
	self.gifArray = [[NSMutableArray alloc]init]; // removed old one, and replace with new
	[query findObjectsInBackgroundWithBlock:^(NSArray *parseArray, NSError *error) {
		if (!error) {
			// The find succeeded.
			NSLog(@"Successfully retrieved %lu Gifs from PARSE DB", (unsigned long)parseArray.count);
			PFFile *gifImage = nil;
			for (PFObject *gifObject in parseArray) {
				gifImage = gifObject[@"GifFile"];
				[gifObject pinInBackground]; // this is for local Storage
				[gifImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
					if (!error) {
						[self.gifArray addObject:imageData];
					}
					else {
						NSLog(@"There was an error, and it needs to be logged");
					}
				}];
}
		}
		else {
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}

- (void)fromLocalDataGifs {
	PFQuery *query = [PFQuery queryWithClassName:@"GifParse"];
	[query fromLocalDatastore];
	self.gifArray = [[NSMutableArray alloc]init]; // removed old one, and replace with new
	[query findObjectsInBackgroundWithBlock:^(NSArray *parseArray, NSError *error) {
		if (!error) {
			// The find succeeded.
			NSLog(@"Successfully retrieved %lu Gifs from LOCAL", (unsigned long)parseArray.count);
			// Do something with the found objects
			PFFile *gifImage = nil;
			for (PFObject *gifObject in parseArray) {
				gifImage = gifObject[@"GifFile"];
				[gifImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
					if (!error) {
						[self.gifArray addObject:imageData];
					}
					else {
						NSLog(@"There was an error, and it needs to be logged");
					}
				}];
			}
		}
		else {
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
		if (parseArray == nil || parseArray.count == 0) {
			[self downloadParseGifs];
		}
	}];
}

-(void) saveParse {
	
	PFObject *testObjectPizza = [PFObject objectWithClassName:@"PizzaPlaceParse"];
	testObjectPizza[@"name"] = @"Two Bros 32 St. Marks";
	testObjectPizza[@"address"] = @"32 Saint Marks Place New York NY 10003";
	testObjectPizza[@"street"] = @"32 Saint Marks Place";
	testObjectPizza[@"city"] = @"New York NY";
	testObjectPizza[@"zip"] = @10003;
	testObjectPizza[@"latitude"] =	@40.728677;
	testObjectPizza[@"longitude"] =	@-73.988488;
	[testObjectPizza saveInBackground];
	
	NSString *kenPizzaMan = @"KenPizzaMan";
	NSString *gifFilePath = [[NSBundle mainBundle] pathForResource:kenPizzaMan ofType:@"gif"];
	NSData *gifData = [NSData dataWithContentsOfFile:gifFilePath];
	
	PFFile *file = [PFFile fileWithName:[NSString stringWithFormat:@"%@.gif",kenPizzaMan] data:gifData];
	PFObject *gifObject = [PFObject objectWithClassName:@"GifParse"];
	[gifObject setObject:file forKey:@"GifFile"];
	[gifObject saveInBackground];

	
}


@end
