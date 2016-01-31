//
//  GIFPage.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/30/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "GIFPage.h"

@interface GIFPage ()

@property CGAffineTransform transform;
@end

@implementation GIFPage

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor orangeColor];
	/*
	 UIWebView *webViewBG;
	 NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tmntBikePizza" ofType:@"gif"];
	 
	 NSData *gif = [NSData dataWithContentsOfFile:filePath];
	 
	 webViewBG = [[UIWebView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width)/2 , self.view.bounds.size.width, self.view.bounds.size.width)];
	 NSURL *nilURL = nil; // these are to remove a warning from putting nil in for string and URL
	 NSString *nilString = nil; // these are to remove a warning from putting nil in for string and URL
	 [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nilString baseURL:nilURL];
	 
	 webViewBG.userInteractionEnabled = NO;
	 
	 // set the rotation of the GIF
	 self.transform = CGAffineTransformMakeRotation(M_PI_2); // 90 degrees EAST
	 
	 //Obtaining the current device orientation
	 UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	 
	 //	NSLog(@"orienation = %ld", (long)orientation);
	 if (orientation == UIDeviceOrientationLandscapeRight)
	 {
		// code for RIGHT orientation
		self.transform = CGAffineTransformMakeRotation(M_PI_2 *3); // 90 degrees WEST
		
	 }
	 
	 webViewBG.transform = self.transform;
	 [self.view addSubview:webViewBG];
	 */
	
	// Do any additional setup after loading the view.
	NSString *filePathTMNT = [[NSBundle mainBundle] pathForResource:@"tmntBikePizza" ofType:@"gif"];
	NSString *filePathKen =
 [[NSBundle mainBundle] pathForResource:@"KenPizzaMan" ofType:@"gif"];
	
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
	
	
	NSURL *imageURL = [NSURL fileURLWithPath: filePathKen];
	
	// Create HTML string from image URL
	// Width-value is arbitrary (and found experimentally): 750 works fine for me
	NSString *htmlString = @"<html><body><img src='%@' margin='0' padding='0' width='965' height='965'></body></html>";
	NSString *imageHTML  = [[NSString alloc] initWithFormat:htmlString, imageURL];
	
	self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width)/2 , self.view.bounds.size.width, self.view.bounds.size.width)];
	
	// Load image in UIWebView
	self.webView.scalesPageToFit = YES;
	self.webView.userInteractionEnabled = NO;
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	//	NSString *padding = @"document.body.style.margin='0';document.body.style.padding = '0'";
	//	[self.webView stringByEvaluatingJavaScriptFromString:padding];
	
	// set the rotation of the GIF
	self.transform = CGAffineTransformMakeRotation(M_PI_2); // 90 degrees EAST
	
	//Obtaining the current device orientation
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	//	NSLog(@"orienation = %ld", (long)orientation);
	if (orientation == UIDeviceOrientationLandscapeRight)
	{
		// code for RIGHT orientation
		self.transform = CGAffineTransformMakeRotation(M_PI_2 *3); // 90 degrees WEST
		
	}
	
	self.webView.transform = self.transform;
	
	[self.webView loadHTMLString:imageHTML baseURL:nil];
	[self.view addSubview:self.webView];
	
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
