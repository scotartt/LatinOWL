//
//  OL_LatinMorphData.h
//  OnlineLatinTool
//
//  Created by Scot Mcphee on 5/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OL_ViewController;

static NSString *const hopperBase = @"http://www.perseus.tufts.edu/hopper/";

@interface OL_LatinMorphData : NSObject <NSURLConnectionDelegate>

  @property(nonatomic, strong) OL_ViewController *viewController;
  @property(nonatomic, strong) NSURL *theURL;
  @property(nonatomic, strong) NSString *urlString;
  @property(nonatomic, strong) NSMutableData *responseData;
  @property(nonatomic, strong) NSURLConnection *urlConnection;
  @property(nonatomic, strong) NSMutableDictionary *definitions;

  - (void)searchLatin:(NSString *)latinSearchTerm withController:(OL_ViewController *)viewController;

  - (NSArray *)getAnalysis:(NSData *)data;

  - (void)populateLemmaData:(NSData *)data;

@end
