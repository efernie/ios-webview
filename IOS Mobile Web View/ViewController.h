//
//  ViewController.h
//  IOS Mobile Web View
//
//  Created by Eric Fernberg on 10/8/13.
//  Copyright (c) 2013 Eric Fernberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate>

// WebView fomr the storyboard
@property (weak, nonatomic) IBOutlet UIWebView *mobileWebView;

@property NSString *baseURL;
@property NSString *webScheme;

@end
