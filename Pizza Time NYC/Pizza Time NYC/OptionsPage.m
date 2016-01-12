//
//  OptionsPage.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/9/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "OptionsPage.h"

@interface OptionsPage ()

@end

@implementation OptionsPage

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tmntBikePizza" ofType:@"gif"];
	
	//	NSData *gif = [NSData dataWithContentsOfFile:filePath];
	//	[self.webView loadData:gif MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@"http://"] ];
	//
	//	NSString *jsCommandW = [NSString stringWithFormat:@"document.getElementsByTagName('img')[0].style.width = '80px'"];
	//	[self.webView stringByEvaluatingJavaScriptFromString:jsCommandW];
	//	NSString *jsCommandH = [NSString stringWithFormat:@"document.getElementsByTagName('img')[0].style.height = '80px'"];
	//	[self.webView stringByEvaluatingJavaScriptFromString:jsCommandH];
	//
	//
	//	self.webView.userInteractionEnabled = NO;
	
	
	NSURL	 *imageURL	 = [NSURL fileURLWithPath: filePath];
	
	// Create HTML string from image URL
	// Width-value is arbitrary (and found experimentally): 750 works fine for me
	NSString *htmlString = @"<html><body><img src='%@' margin='0' padding='0' width='750' height='750'></body></html>";
	NSString *imageHTML  = [[NSString alloc] initWithFormat:htmlString, imageURL];
	
	// Load image in UIWebView
	self.webView.scalesPageToFit = YES;
	self.webView.userInteractionEnabled = NO;
	self.automaticallyAdjustsScrollViewInsets = NO;
	
//	NSString *padding = @"document.body.style.margin='0';document.body.style.padding = '0'";
//	[self.webView stringByEvaluatingJavaScriptFromString:padding];

	[self.webView loadHTMLString:imageHTML baseURL:nil];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
