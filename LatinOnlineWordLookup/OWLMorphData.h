//
//  OWLMorphData.h
//  OnlineLatinTool
//
//  Created by Scot Mcphee on 5/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OWLSearchViewController;
@protocol OWLMorphDataObserver;

static NSString *const HOPPER_BASE = @"http://www.perseus.tufts.edu/hopper/";
static NSString *const HOPPER_DOC_LOADER_URL = @"loadquery?doc=";  // have to add this onto HOPPER_BASE
static NSString *const KEY_HEADING = @"heading";
static NSString *const KEY_DEFINITION = @"definition";
static NSString *const KEY_TABLE = @"table";
static NSString *const KEY_LEXICON = @"lexicon";


@interface OWLMorphData : NSObject <NSURLConnectionDelegate>

    @property(nonatomic, weak) id <OWLMorphDataObserver> observer;
    @property(nonatomic, strong) NSURL *theURL;
    @property(nonatomic, strong) NSString *urlString;
    @property(nonatomic, strong) NSMutableData *responseData;
    @property(nonatomic, strong) NSURLConnection *urlConnection;
    @property(nonatomic, strong) NSMutableDictionary *definitions;
    @property(nonatomic, strong) NSArray *lemmas;

    - (void)searchLatin:(NSString *)latinSearchTerm withObserver:(id <OWLMorphDataObserver>)morphObserver;

    - (NSArray *)getAnalysis:(NSData *)data;

    - (void)populateLemmaData:(NSData *)data;

    - (NSString *)theMeaning:(NSString *)lemmaId;

    - (NSString *)theHeaderString:(NSString *)lemmaId;

    - (NSString *)theForm:(NSString *)lemmaId ofIndex:(int)index;

    - (NSString *)theFormParsed:(NSString *)lemmaId ofIndex:(int)index;

    - (NSString *)theLewisAndShortURL:(NSString *)lemmaId;

    - (OWLMorphData *)reset;

    + (OWLMorphData *)data;
@end
