//
//  ViewController.h
//  webviewios
//
//  Created by Eric Fernberg on 7/12/13.
//  Copyright (c) 2013 efernie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate>

@property NSString *BASE_URL;
@property NSString *WEB_SCHEME;
@property Boolean development;

@property (weak, nonatomic) IBOutlet UIWebView *web;

@end
