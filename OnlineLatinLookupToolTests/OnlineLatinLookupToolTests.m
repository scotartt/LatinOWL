//
//  OnlineLatinLookupToolTests.m
//  OnlineLatinLookupToolTests
//
//  Created by Scot Mcphee on 10/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import "OnlineLatinLookupToolTests.h"
#import "OL_ViewController.h"
#import "XPathResultNode.h"

@implementation OnlineLatinLookupToolTests

  @synthesize controller;
  @synthesize latinData;

  - (void)setUp {
    [super setUp];
    controller = [[OL_ViewController alloc] init];
    latinData = [[OL_LatinMorphData alloc] init];
  }

  - (void)tearDown {
    // Tear-down code here.

    [super tearDown];
  }

  - (void)testLatinDataConstructsCorrectStringURL {
    [latinData searchLatin:@"amo" withController:controller];
    NSURLConnection *connection = latinData.urlConnection;
    NSString *expected = @"http://www.perseus.tufts.edu/hopper/morph?la=la&l=amo";
    NSString *constructed = connection.currentRequest.URL.absoluteString;
    STAssertTrue([expected isEqualToString:constructed], @"URL does not match");
  }


  - (void)testLatinDataConnectionIsNotNil {
    // STFail(@"Unit tests are not implemented yet in OnlineLatinToolTests");
    [latinData searchLatin:@"amo" withController:controller];
    NSURLConnection *connection = latinData.urlConnection;
    STAssertNotNil(connection, @"Connection must not be nil");
  }

  - (void)testLatinDataResponseHasBytes {
    [latinData searchLatin:@"amo" withController:controller];
    STAssertNotNil(latinData.responseData, @"Connection must not be nil");
    NSUInteger len = latinData.responseData.length;
    NSLog(@"Data length is %lu bytes", (unsigned long) len);
  }

  - (void)testGetURLSynchronously {
    NSData *data = [self getData:latinData withLatin:@"amo"];
    NSString *content = [[NSString alloc] initWithBytes:[data bytes]
                                                 length:[data length]
                                               encoding:NSUTF8StringEncoding];
    NSLog(@"Data = %@", content);
  }

  - (void)testParseAnalysisDataNodesFor_amo {
    NSData *data = [self getData:latinData withLatin:@"amo"];
    NSArray *analysisNodes = [latinData getAnalysis:data];
    STAssertNotNil(analysisNodes, @"Should have got analysisNode data");
    NSLog(@"'amo' analysis count is %lu Nodes", (unsigned long) [analysisNodes count]);
    STAssertEquals((int) [analysisNodes count], (int) 1, @"'amo' should have 1 result");
  }

  - (void)testParseAnalysisDataNodesFor_ire {
    NSData *data = [self getData:latinData withLatin:@"ire"];
    NSArray *analysisNodes = [latinData getAnalysis:data];
    STAssertNotNil(analysisNodes, @"Should have got analysisNode data");
    NSLog(@"'ire' analysis count is %lu Nodes", (unsigned long) [analysisNodes count]);
    STAssertEquals((int) [analysisNodes count], (int) 3, @"'ire' should have 3 results");
  }

  - (void)testParseLemmaContentFor_amo {
    NSData *data = [self getData:latinData withLatin:@"amo"];
    NSArray *analysisNodes = [latinData getAnalysis:data];
    [latinData populateLemmaData:data];
    STAssertNotNil(latinData.definitions, @"definitions must not be empty");
    STAssertEquals([analysisNodes count], [latinData.definitions count], @"Lemma nodes must equal analysis nodes");
  }

  - (void)testParseLemmaContentFor_amo_has4DataComponents {
    NSData *data = [self getData:latinData withLatin:@"amo"];
    [latinData populateLemmaData:data];
    NSDictionary *dict = latinData.definitions;
    NSDictionary *amoData = [dict objectForKey:@"amo"];
    STAssertNotNil(amoData, @"must have data elements");
    STAssertEquals((int) [amoData count], (int) 4, @"should have four elements");
  }

  - (void)testParseLemmaContentFor_amo_hasComponentHeading {
    NSData *data = [self getData:latinData withLatin:@"amo"];
    [latinData populateLemmaData:data];
    NSDictionary *dict = latinData.definitions;
    NSDictionary *amoData = [dict objectForKey:@"amo"];
    NSArray *dataArray = [amoData objectForKey:@"heading"];
    STAssertNotNil(dataArray, @"must have data elements");
    NSLog(@"array has %d elements", dataArray.count);
  }


  - (void)testParseLemmaContentFor_eo {
    NSData *data = [self getData:latinData withLatin:@"eo"];
    NSArray *analysisNodes = [latinData getAnalysis:data];
    [latinData populateLemmaData:data];
    STAssertNotNil(latinData.definitions, @"definitions must not be empty");
    STAssertEquals([analysisNodes count], [latinData.definitions count], @"Lemma nodes must equal analysis nodes");
  }

  - (void)testParseLemmaContentFor_eo_hasCorrectCountOfLemmaFound {
    NSData *data = [self getData:latinData withLatin:@"eo"];
    [latinData populateLemmaData:data];
    STAssertEquals((int) 4, (int) [latinData.definitions count], @"I expect 4 lemma nodes: Eos; eo; eo2, is");
  }

  - (void)testParseLemmaContentFor_eo_has4DataComponents {
    NSData *data = [self getData:latinData withLatin:@"eo"];
    [latinData populateLemmaData:data];
    NSDictionary *dict = latinData.definitions;
    NSDictionary *eoData = [dict objectForKey:@"eo"];
    STAssertNotNil(eoData, @"must have data elements");
    STAssertEquals((int) [eoData count], (int) 4, @"should have four elements");
  }

  - (void)testParseLemmaContentFor_eo_hasCorrectLemmaDefinition {
    NSData *data = [self getData:latinData withLatin:@"eo"];
    [latinData populateLemmaData:data];
    NSDictionary *dict = latinData.definitions;
    NSDictionary *amoData = [dict objectForKey:@"eo"];
    NSArray *dataArray = [amoData objectForKey:@"definition"];
    STAssertNotNil(dataArray, @"must have data elements");
    STAssertEquals((int) 1, (int) dataArray.count, @"must be only one definition of any single lemma");
    XPathResultNode *node = [dataArray objectAtIndex:0];
    NSLog(@"content=%@", [node contentString]);
    STAssertTrue([[node contentString] isEqualToString:@"to go, walk, ride, sail, fly, move, pass"], @"The second definition of 'eo' is wrong!");
  }

  - (void)testParseLemmaContentFor_eo_hasTableOfPossibilities {
    NSData *data = [self getData:latinData withLatin:@"eo"];
    [latinData populateLemmaData:data];
    NSDictionary *dict = latinData.definitions;
    NSDictionary *eosData = [dict objectForKey:@"Eos"];
    NSArray *dataArray = [eosData objectForKey:@"table"];
    STAssertNotNil(dataArray, @"must have data elements");
    STAssertEquals((int) 2, (int) dataArray.count, @"'eo' for 'Eos' has two possible parts (sg dat & sg abl)");
    for (XPathResultNode *node in dataArray) {
      NSLog(@"content=%@", [node description]);
      STAssertTrue([node.name isEqualToString:@"tr"], @"all elements in 'table' should be 'tr'");
    }
  }

  - (void)testParseLemmaContentFor_eo_whatsInTheLexicon {
    NSData *data = [self getData:latinData withLatin:@"eo"];
    [latinData populateLemmaData:data];
    NSDictionary *dict = latinData.definitions;
    NSDictionary *eoData = [dict objectForKey:@"eo"];
    NSArray *dataArray = [eoData objectForKey:@"lexicon"];
    STAssertNotNil(dataArray, @"must have lexicon elements");
    STAssertEquals((int) 5, (int) dataArray.count, @"should be 5 lexicon links");
    for (XPathResultNode *node in dataArray) {
      NSLog(@"data=%@", [node description]);
    }
  }

  - (void)testParseLemmaContentFor_eo2_whatsInTheLexicon {
    NSData *data = [self getData:latinData withLatin:@"eo"];
    [latinData populateLemmaData:data];
    NSDictionary *dict = latinData.definitions;
    NSDictionary *eoData = [dict objectForKey:@"eo2"];
    NSArray *dataArray = [eoData objectForKey:@"lexicon"];
    STAssertNotNil(dataArray, @"must have lexicon elements");
    STAssertEquals((int) 5, (int) dataArray.count, @"should be 5 lexicon links");
    for (XPathResultNode *node in dataArray) {
      NSLog(@"data=%@", [node description]);
    }
  }

  - (void)testParseNonLatinWord {
    NSData *data = [self getData:latinData withLatin:@"hello"];

    STAssertThrows([latinData populateLemmaData:data], @"Expect an exception!");

  }

  - (void)testParseLemmaContentFor_eo_hasLexiconLinks {
    NSData *data = [self getData:latinData withLatin:@"eo"];
    [latinData populateLemmaData:data];
    NSDictionary *dict = latinData.definitions;
    NSDictionary *eoData = [dict objectForKey:@"eo"];
    NSArray *lexicon = [eoData objectForKey:@"lexicon"];
    STAssertNotNil(lexicon, @"must have lexicon link elements");
    NSLog(@"array has %d elements", lexicon.count);
    for (XPathResultNode *node in lexicon) {
      NSLog(@"data=%@", [node description]);
    }
  }

#pragma Helper methods

  - (NSData *)getData:(OL_LatinMorphData *)theLatinData withLatin:(NSString *)latinWord {
    [theLatinData searchLatin:latinWord withController:controller];
    NSURLConnection *connection = theLatinData.urlConnection;
    NSURLRequest *request = connection.currentRequest;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSUInteger len = data.length;
    NSLog(@"Data length is %lu bytes", (unsigned long) len);
    STAssertTrue(len > 0, @"Length must be > 0");
    return data;
  }

@end
