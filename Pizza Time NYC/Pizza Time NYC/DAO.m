//
//  DAO.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/4/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "DAO.h"

@implementation DAO


-(void) downloadParse {
	// unsure of what to type to return here
	// check if object exists, if so, update,
	// if not, create
	// ?iterate through and create PP instance for place
	PFQuery *query = [PFQuery queryWithClassName:@"PizzaPlaceParse"];
	//	[query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
	
	// Sorts the results in ascending order by the score field
	[query orderByAscending:@"zip"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *parseArray, NSError *error) {
		if (!error) {
			// The find succeeded.
			NSLog(@"Successfully retrieved %lu pizzaPlaces.", (unsigned long)parseArray.count);
			// Do something with the found objects
			PizzaPlace *pizzaPlace = nil;
			for (PFObject *pizzaPlaceParse in parseArray) {
				
				pizzaPlace = [[PizzaPlace alloc]init]; // allocate the new instance
				// assign its values from the objects
				pizzaPlace.name = pizzaPlaceParse[@"name"];
				pizzaPlace.address = pizzaPlaceParse[@"address"];
				pizzaPlace.city = pizzaPlaceParse[@"city"];
				pizzaPlace.zip = [pizzaPlaceParse[@"zip"]integerValue];
				pizzaPlace.latitude = [pizzaPlaceParse[@"latitude"]floatValue];
				pizzaPlace.longitude = [pizzaPlaceParse[@"longitude"]floatValue];
				
				//					NSLog(@"%@", pizzaPlace.name);
				//					NSLog(@"%f", pizzaPlace.latitude);
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

- (NSMutableArray *) pizzaPlaceArray {
	if (!_pizzaPlaceArray) {
		_pizzaPlaceArray = [NSMutableArray new];
	}
	return _pizzaPlaceArray;
}

-(void) fromLocalData {
	PFQuery *query = [PFQuery queryWithClassName:@"PizzaPlaceParse"];
	[query fromLocalDatastore];
	[query findObjectsInBackgroundWithBlock:^(NSArray *parseArray, NSError *error) {
		if (!error) {
			// The find succeeded.
			NSLog(@"Successfully retrieved %lu pizzaPlaces.", (unsigned long)parseArray.count);
			// Do something with the found objects
			PizzaPlace *pizzaPlace = nil;
			for (PFObject *pizzaPlaceParse in parseArray) {
				
				pizzaPlace = [[PizzaPlace alloc]init]; // allocate the new instance
				// assign its values from the objects
				pizzaPlace.name = pizzaPlaceParse[@"name"];
				pizzaPlace.address = pizzaPlaceParse[@"address"];
				pizzaPlace.city = pizzaPlaceParse[@"city"];
				pizzaPlace.zip = [pizzaPlaceParse[@"zip"]integerValue];
				pizzaPlace.latitude = [pizzaPlaceParse[@"latitude"]floatValue];
				pizzaPlace.longitude = [pizzaPlaceParse[@"longitude"]floatValue];
				
				//					NSLog(@"%@", pizzaPlace.name);
				//					NSLog(@"%f", pizzaPlace.latitude);
				[self.pizzaPlaceArray addObject:pizzaPlace];
				//					NSLog(@"my array is = %@", self.pizzaPlaceArray);
			}
		}
		else {
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
		if (parseArray == nil || parseArray.count == 0) {
			[self downloadParse];
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
	
}

-(void)createPizzaPlaces
{
	if (!self.pizzaPlaceArray) {// if data has not loaded, load. Else, ...
		/* making a new pizza place
		 
		 PizzaPlace *replaceMeWithName = [[PizzaPlace alloc]init];
		 replaceMeWithName.name = @"";
		 
		 replaceMeWithName.address = @"";
		 replaceMeWithName.street = @"";
		 replaceMeWithName.city = @"New York NY";
		 replaceMeWithName.zip = ;
		 replaceMeWithName.latitude = ;
		 replaceMeWithName.longitude = ;
		 // do not forget to add to array
		 
		 */
		//TwoBros PizzaPlaces //as of 12.26.15 we have 7 TB
		//12 places as of 1.9.16
		// name, address, image, url, Lat / Long
		//tb = Two Bros
		//nn = 99 [cent]
		PizzaPlace *tb32_stMarks = [[PizzaPlace alloc]init];
		PizzaPlace *tb542_9thAve = [[PizzaPlace alloc]init];
		PizzaPlace *tb601_6thAve = [[PizzaPlace alloc]init];
		PizzaPlace *tb557_8thAve = [[PizzaPlace alloc]init];
		PizzaPlace *tb31_46thSt = [[PizzaPlace alloc]init];
		PizzaPlace *tb755_6thAve = [[PizzaPlace alloc]init];
		PizzaPlace *tb319_6thAve = [[PizzaPlace alloc]init];
		
		PizzaPlace *vinnyVincenz = [[PizzaPlace alloc]init];
		PizzaPlace *nn1723_broad = [[PizzaPlace alloc]init];
		PizzaPlace *nn201_34thSt = [[PizzaPlace alloc]init];
		PizzaPlace *nn151_43rdSt = [[PizzaPlace alloc]init];
		PizzaPlace *nn71_2ndAve = [[PizzaPlace alloc]init];
		
		// names
		tb32_stMarks.name = @"Two Bros 32 St. Marks";
		tb542_9thAve.name = @"Two Bros 542 9th Ave";
		tb601_6thAve.name = @"Two Bros 601 6th Ave";
		tb557_8thAve.name = @"Two Bros 557 8th Ave";
		tb31_46thSt.name = @"Two Bros 31 46th St";
		tb755_6thAve.name = @"Two Bros 755 6th Ave";
		tb319_6thAve.name = @"Two Bros 319 6th Ave";
		
		vinnyVincenz.name = @"Vinny Vincenz Pizza";
		
		nn1723_broad.name = @"99 Cents 1723 Broadway";
		nn201_34thSt.name = @"99 Cents 201 E 34th St";
		nn151_43rdSt.name = @"99 Cents 151 E 43rd St";
		nn71_2ndAve.name = @"99 Cents 71 2nd Ave";
		
		// info
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
		
		tb319_6thAve.address = @"319 6th Ave New York NY 10014";
		tb319_6thAve.street = @"319 6th Ave";
		tb319_6thAve.city = @"New York NY";
		tb319_6thAve.zip = 10014;
		tb319_6thAve.latitude = 40.731076;
		tb319_6thAve.longitude = -74.001708;
		
		vinnyVincenz.address = @"231 1st Ave New York NY 10003";
		vinnyVincenz.street = @"231 1st Ave";
		vinnyVincenz.city = @"New York NY";
		vinnyVincenz.zip = 10003;
		vinnyVincenz.latitude = 40.731179;
		vinnyVincenz.longitude = -73.983096;
		
		nn1723_broad.address = @"1723 Broadway, New York, NY 10019";
		nn1723_broad.street = @"1723 Broadway";
		nn1723_broad.city = @"New York NY";
		nn1723_broad.zip = 10019;
		nn1723_broad.latitude = 40.764607;
		nn1723_broad.longitude = -73.982533;
		
		nn201_34thSt.address = @"201 E 34th St New York NY 10016";
		nn201_34thSt.street = @"201 E 34th St";
		nn201_34thSt.city = @"New York NY";
		nn201_34thSt.zip = 10016;
		nn201_34thSt.latitude = 40.745733;
		nn201_34thSt.longitude = -73.977664;
		
		nn151_43rdSt.address = @"151 E 43rd St, New York, NY 10017";
		nn151_43rdSt.street = @"151 E 43rd St";
		nn151_43rdSt.city = @"New York NY";
		nn151_43rdSt.zip = 10017;
		nn151_43rdSt.latitude = 40.751694;
		nn151_43rdSt.longitude = -73.974272;
		
		nn71_2ndAve.address = @"71 2nd Ave, New York, NY 10003";
		nn71_2ndAve.street = @"71 2nd Ave";
		nn71_2ndAve.city = @"New York NY";
		nn71_2ndAve.zip = 10003;
		nn71_2ndAve.latitude = 40.726453;
		nn71_2ndAve.longitude = -73.989572;
		// do not forget to add to array
		
		
		//		self.pizzaPlaceArray = [[NSMutableArray alloc]initWithArray:@[tb32_stMarks, tb542_9thAve, tb601_6thAve, tb557_8thAve, tb31_46thSt, tb755_6thAve, tb319_6thAve, vinnyVincenz, nn1723_broad, nn201_34thSt, nn151_43rdSt]];
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
