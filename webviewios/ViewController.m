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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.WEB_SCHEME = @"webview";

    // this will be automatically switched when auto built
    self.development = TRUE;

    if ( self.development ) {
      // development url
      self.BASE_URL = @"http://192.168.5.110:3000";
    } else {
      // production url
      self.BASE_URL = @"https://someproductionurl.com";
    }

    // stop the view from bouncing
    [[web scrollView] setBounces: NO];

    // load the page
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:BASE_URL] cachePolicy:2 timeoutInterval:50 ]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// handle anything when page is loaded
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // store in the views local storage that this is an iphone
   // [self stringByEvaluatingJavascriptFromString:@"localStorage.setItem('isiphone', true);"];

    NSLog(@"finished loading");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWIthRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType) navigationType {
    // handle link clicks inside app
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
      NSURL *url = [request URL];
      NSString *fragment = [url fragment];

      // this is to open links in safari
      NSString *safariRegEx = @"openInSafari\\b";
      NSPredicate *regExTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", safariRegEx];

      // need to add something to strip out the fragment from the url when passing it to safari
      if ( [regExTest evaluateWithObject: fragment] ) {
        // open the link in safari
        [[UIApplication sharedApplication] openURL:url];
        return NO;
      }
    }

    // to handle when you need the native functions
    // right now there is only the image controller
    if ( [[[request URL] scheme] isEqualToString:WEB_SCHEME] ) {
      NSArray *components = [[[[request URL] absoluteString] stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@%@", WEB_SCHEME, @"://"] withString:@""] componentsSeparatedByString:@"//"];

      NSString *command = [components objectAtIndex:0];

      // for taking pictures
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  NSData *data = UIImageJPEGRepresentation(originalImage,0.2);
  NSString *string = [self base64forData:data];
  int chunkSize = 50000;

  while ( [string length] > 0 ) {
    if ( [string length] > chunkSize ) {
      // [web stringByEvaluatingJavascriptFromString:[NSString stringWithFormat:@"app.chunkImage('%@');", [string substringToIndex:chunkSize]]];
      string = [string substringFromIndex:chunkSize];
    } else {
      // [web stringByEvaluatingJavascriptFromString:[NSString stringWithFormat:@"app.chunkImage('%@');", [string substringToIndex:[string length]]]];
    }
  }

  // [web stringByEvaluatingJavascriptFromString:@"app.endChunk();"];

  [self dismissViewControllerAnimated:YES completion: nil];
}

- (NSString *)base64forData:(NSData *)theData {

    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];

    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;

    NSInteger i;
    for ( i = 0; i < length; i+= 3 ) {
      NSInteger value = 0;
      NSInteger j;
      for ( j = i; j < ( i + 3 ); j++ ) {
        value <<=8;

        if ( j < length ) {
          value |= (0xFF & input[j]);
        }
      }

      NSInteger theIndex = (i /3) * 4;
      output[theIndex + 0] = table[(value >> 18) & 0x3F];
      output[theIndex + 1] = table[(value >> 12) & 0x3F];
      output[theIndex + 2] = ( i + 1 ) < length ? table[(value >> 6) & 0x3F] : '=';
      output[theIndex + 3] = ( i + 2 ) < length ? table[(value >> 0) & 0x3F] : '=';
    }

    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

// - (BOOL) shoudAutorotate {
//   return NO;
// }

@end
