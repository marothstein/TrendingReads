//
//  SecondViewController.m
//  TweaderTabs
//
//  Created by Alex Garcia on 9/20/11.
//  Copyright 2011 UMD HCI Lab. All rights reserved.
//

#import "SecondViewController.h"
#import "TweaderTabsAppDelegate.h"

@implementation SecondViewController
@synthesize webView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
        

}

- (void) viewDidAppear:(BOOL)animated{
    NSString *urlAddress = @"http://www.instapaper.com/m?u=";
    TweaderTabsAppDelegate *appDelegate = (TweaderTabsAppDelegate*)[UIApplication sharedApplication].delegate;
    //appDelegate.urlToLoad;
    urlAddress = [NSString stringWithFormat:@"%@%@",urlAddress,appDelegate.urlToLoad];
    NSLog(urlAddress);
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    //NSLog(@"url for webview: %@",url);
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    NSLog(@" url for main document: %@", requestObj.URL);
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end


