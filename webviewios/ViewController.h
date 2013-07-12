//
//  ViewController.h
//  webviewios
//
//  Created by Eric Fernberg on 7/12/13.
//  Copyright (c) 2013 efernie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// the url where the app is located
@property NSString *BASE_URL;

// when acessing native ios functions ie: webview://takepic
@property NSString *WEB_SCHEME;

// To switch between development and production
@property Boolean development;

@property (weak, nonatomic) IBOutlet UIWebView *web;

@end
