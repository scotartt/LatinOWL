//
//  OL_AppDelegate.m
//  OnlineLatinLookupTool
//
//  Created by Scot Mcphee on 10/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import "OL_AppDelegate.h"
#import "OL_ViewController.h"

@implementation OL_AppDelegate

  @synthesize netAlert;

  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[OL_ViewController alloc] initWithNibName:@"OL_ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [self startReach];

    return YES;
  }

  - (void)startReach {
    // starts the 'reachability' network notification.
    NSLog(@"Starting up 'Reachability' network notification to %@", hostName);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *reach = [Reachability reachabilityWithHostName:hostName];
    [reach startNotifier];
    // test it right off the bat to alert the user if anything is wrong.
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
      netAlert = [[UIAlertView alloc] initWithTitle:@"Perseus Alert"
                                            message:@"perseus.tufts.edu is not reachable." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [netAlert show];
    }
  }

  - (void)reachChanged:(NSNotification *)notification {
    // this method is called when the
    Reachability *reach = [notification object];
    if ([reach isKindOfClass:[Reachability class]]) {
      NetworkStatus status = [reach currentReachabilityStatus];
      NSLog(@"Perseus network status changed: now %@", [self stringFromStatus:status]);
      if (status == NotReachable) {
        netAlert = [[UIAlertView alloc] initWithTitle:@"Perseus Alert"
                                              message:@"perseus.tufts.edu is not reachable." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [netAlert show];
      } else if (netAlert != nil && netAlert.visible == YES) {
        NSLog(@"Dismissing stale network alert: %@", netAlert.title);
        [netAlert setTitle:@"Perseus OK"];
        [netAlert setMessage:@"Reachable! HUZZAH!"];
        [netAlert dismissWithClickedButtonIndex:0 animated:YES];
        [netAlert setHidden:YES];
        netAlert = nil;
      } else {
        NSLog(@"No stale network alert to dismiss.");
        netAlert = nil;
      }
    }
  }

  - (NSString *)stringFromStatus:(NetworkStatus)status {
    NSString *statusStr;
    switch (status) {
      case NotReachable:
        statusStr = @"Not Reachable";
        break;
      case ReachableViaWiFi:
        statusStr = @"Reachable via WiFi";
        break;
      case ReachableViaWWAN:
        statusStr = @"Reachable via WWAN";
        break;
      default:
        statusStr = @"Unknown";
        break;
    }
    return statusStr;
  }

  - (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  - (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  - (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  - (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  - (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


@end
