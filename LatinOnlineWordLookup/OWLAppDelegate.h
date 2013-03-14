//
//  OWLAppDelegate.h
//  OnlineLatinLookupTool
//
//  Created by Scot Mcphee on 10/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class OWLSearchViewController;
@class Reachability;

static NSString *const hostName = @"www.perseus.tufts.edu";


@interface OWLAppDelegate : UIResponder <UIApplicationDelegate> {
        Reachability *hostReach;
        // Reachability *internetReach;
    }

    @property(strong, nonatomic) UIWindow *window;
    @property(strong, nonatomic) OWLSearchViewController *viewController;
    @property(strong, nonatomic) UIAlertView *netAlert;
    @property(strong, nonatomic) UIStoryboard *storyBoard;

    - (NSString *)stringFromStatus:(NetworkStatus)status;

@end
