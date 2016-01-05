//
//  PizzaPlace.h
//  Pizza Time NYC
//
//  Created by SUGAR^2 on 12/25/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PizzaPlace : NSObject

//information on PizzaPlace
@property (nonatomic, retain) NSString *pizzaPlaceName;
@property (nonatomic, retain) NSString *pizzaPlaceURL;
@property (nonatomic, retain) NSString *pizzaPlaceImage;

//location of PizzaPlace
@property (nonatomic, retain) NSString *pizzaPlaceAddress;
@property float pizzaPlaceLatitude;
@property float pizzaPlaceLongitude;
@property float pizzaPlaceDistance;
@end
