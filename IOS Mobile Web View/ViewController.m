//
//  ViewController.m
//  IOS Mobile Web View
//
//  Created by Eric Fernberg on 10/8/13.
//  Copyright (c) 2013 Eric Fernberg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize mobileWebView;
@synthesize baseURL;
@synthesize webScheme;

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Connect the UIWebViewDelegate to the web view set in the storyboard
    mobileWebView.delegate = self;
  
    // Set this for later on when you want to call objective c methods from javascript
    self.webScheme = @"mobileWebView";
    // this is the url to your localhost for now, The protocol is NEEDED be it http or https!!!
    self.baseURL = @"http://192.168.1.100:3000";
  
    // The URL setup for loading the page
    NSURL *loadUrl = [NSURL URLWithString:self.baseURL];
    NSURLRequest *loadUrlRequest = [NSURLRequest requestWithURL:loadUrl cachePolicy:NSURLCacheStorageAllowed timeoutInterval:50];
  
    // start the loading of the url
    [mobileWebView loadRequest:loadUrlRequest];
  
}

// put stuff here that you might want when the view is finished loading. ie close out loading indicator.
- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
}

// I like my status bar hidden
- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
