//
//  WebViewController.h
//  Pizza Time NYC
//
//  Created by SUGAR^2 on 12/26/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController


@property (nonatomic, retain) NSString *url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
