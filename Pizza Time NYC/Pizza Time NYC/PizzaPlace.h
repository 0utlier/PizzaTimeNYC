//
//  PizzaPlace.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 12/23/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import <Foundation/Foundation.h>

//PizzaPlace is the definition of each of our dollarPizza places
@interface PizzaPlace : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *url;

@property float latitude;
@property float longitude;

@end
