//
//  main.m
//  OnlineLatinLookupTool
//
//  Created by Scot Mcphee on 10/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import "OWLAppDelegate.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([OWLAppDelegate class]));
        } @catch (NSException *ex) {
            NSLog(@"An uncaught exception in 'main' - %@", ex);
            @throw ex;
        }
    }
}
