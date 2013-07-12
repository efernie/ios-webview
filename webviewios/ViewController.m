//
//  ViewController.m
//  webviewios
//
//  Created by Eric Fernberg on 7/12/13.
//  Copyright (c) 2013 efernie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize BASE_URL;
@synthesize WEB_SCHEME;
@synthesize web;
@synthesize development;


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.WEB_SCHEME = @"webview";
    self.development = TRUE;

    if ( self.development ) {
      self.BASE_URL = @"http://192.168.5.110:3000";
    }

    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:BASE_URL] cachePolicy:2 timeoutInterval:50]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finished");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWIthRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType) navigationType {
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
      NSURL *url = [request URL];
      NSString *fragment = [url fragment];

      NSString *safariRegEx = @"openInSafari\\b";
      NSPredicate *regExTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", safariRegEx];

      if ( [regExTest evaluateWithObject: fragment] ) {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
      }
    }

    if ( [[[request URL] scheme] isEqualToString:WEB_SCHEME] ) {
      NSArray *components = [[[[request URL] absoluteString] stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@%@", WEB_SCHEME, @"://"] withString:@""] componentsSeparatedByString:@"//"];

      NSString *command = [components objectAtIndex:0];

      if ( [command isEqualToString:@"takepic"] ) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
      }

      return NO;
    }

    return YES;
}

@end
