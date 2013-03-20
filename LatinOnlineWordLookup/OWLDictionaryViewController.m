//
//  OWLDictionaryViewController.m
//  LatinOnlineWordLookup
//
//  Created by Scot Mcphee on 16/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import "OWLDictionaryViewController.h"

@interface OWLDictionaryViewController ()

@end


@implementation OWLDictionaryViewController

@synthesize webView;
@synthesize theURL;


    - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        if (self) {
            // Custom initialization
        }
        return self;
    }

    -(void)viewDidAppear:(BOOL)animated {
        [self.activityIndicator stopAnimating];
    }

    - (void)viewDidLoad {
        [super viewDidLoad];
        NSURL *aURL = [NSURL URLWithString:theURL];
        NSLog(@"Getting url:%@", aURL);
        NSURLRequest *request = [NSURLRequest requestWithURL:aURL];
        [self.webView loadRequest:request];
    }


    - (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];
        [self.activityIndicator startAnimating];
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }


    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end
