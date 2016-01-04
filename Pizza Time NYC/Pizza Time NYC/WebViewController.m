//
//  WebViewController.m
//  Pizza Time NYC
//
//  Created by SUGAR^2 on 12/26/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	//convert nsstring to nsurl
	NSURL *myurl = [[NSURL alloc] initWithString:self.url];
	// then load the url
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:myurl];
//	[request setValue:@"Some desktop user-agent" forHTTPHeaderField:@"User-Agent"];
	[self.webView loadRequest:request];
}

@end
