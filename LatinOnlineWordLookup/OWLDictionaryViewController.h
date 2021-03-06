//
//  OWLDictionaryViewController.h
//  LatinOnlineWordLookup
//
//  Created by Scot Mcphee on 16/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OWLDictionaryViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDelegate>

    @property(strong, nonatomic) IBOutlet UIWebView *webView;
    @property(strong, nonatomic) NSString *theURL;
    @property(strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
