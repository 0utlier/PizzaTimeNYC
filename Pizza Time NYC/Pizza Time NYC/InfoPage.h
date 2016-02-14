//
//  InfoPage.h
//  Pizza Time NYC
//
//  Created by SUGAR^2 on 12/28/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoPage : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *broughtToYou;
@property (weak, nonatomic) IBOutlet UILabel *designLabel;

@end
