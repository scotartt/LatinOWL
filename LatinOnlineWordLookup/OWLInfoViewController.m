//
//  OWLInfoViewController.m
//  LatinOWL
//
//  Created by Scot Mcphee on 17/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import "OWLInfoViewController.h"


@interface OWLInfoViewController ()

@end


@implementation OWLInfoViewController
    @synthesize webView;


    - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        if (self) {
            // Custom initialization
        }
        return self;
    }


    - (void)viewDidLoad {
        [super viewDidLoad];
        NSURL *aURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]
          pathForResource:@"splash" ofType:@"xhtml"]
                                 isDirectory:NO];
        //NSURL fileURLWithPath:@"/splash.xhtml"];
        NSLog(@"Getting url:%@", aURL);
        NSURLRequest *request = [NSURLRequest requestWithURL:aURL];
        [self.webView loadRequest:request];
    }


    - (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }


    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end
