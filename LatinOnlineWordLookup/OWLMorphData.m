//
//  OWLMorphData.m
//  OnlineLatinTool
//
//  Created by Scot Mcphee on 5/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import "OWLMorphData.h"
#import "OWLSearchViewController.h"
#import "XPathResultNode.h"


@implementation OWLMorphData
    @synthesize responseData;
    @synthesize urlConnection;
    @synthesize definitions;
    @synthesize observer;
    @synthesize theURL;
    @synthesize urlString;
    @synthesize lemmas;


    + (OWLMorphData *)data {
        return [[[OWLMorphData alloc] init] reset];
    }


    - (OWLMorphData *)reset {
        self.definitions = [[NSMutableDictionary alloc] init];
        self.responseData = [NSMutableData data];
        self.lemmas = [NSMutableArray array];
        self.urlConnection = nil;
        return self;
    }


    - (void)searchLatin:(NSString *)latinSearchTerm withObserver:(id <OWLMorphDataObserver>)morphObserver {
        self.observer = morphObserver;
        self.urlString = [NSString stringWithFormat:@"%@morph?la=la&l=%@", HOPPER_BASE, latinSearchTerm];
        NSLog(@"url = %@", self.urlString);
        NSURL *aUrl = [NSURL URLWithString:self.urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:aUrl];
        self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }

#pragma accessor methods for data once parsed
    - (NSString *)theMeaning:(NSString *)lemmaId {
        NSDictionary *lemmaDict = [self.definitions objectForKey:lemmaId];
        NSArray *definitionNodes = [lemmaDict objectForKey:KEY_DEFINITION];
        NSLog(@"%@=%@", KEY_DEFINITION, definitionNodes);
        NSMutableString *meaning = [NSMutableString string];
        for (XPathResultNode *definition in definitionNodes) {
            [meaning appendString:[definition contentString]];
        }
        NSRegularExpression *twoSpacesRegex = [NSRegularExpression regularExpressionWithPattern:@"\\s+"
                                                                                        options:NSRegularExpressionCaseInsensitive error:nil];
        return [twoSpacesRegex stringByReplacingMatchesInString:meaning
                                                        options:NSRegularExpressionCaseInsensitive
                                                          range:NSMakeRange(0, [meaning length])
                                                   withTemplate:@" "];
    }


    - (NSString *)theLewisAndShortURL:(NSString *)lemmaId {
        NSDictionary *lemmaDict = [self.definitions objectForKey:lemmaId];
        NSArray *lexicons = [lemmaDict objectForKey:KEY_LEXICON];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^Lewis" options:NSRegularExpressionCaseInsensitive error:nil];
        for (XPathResultNode *node in lexicons) {
            NSString *content = [node contentString];
            if ([regex matchesInString:content options:0 range:NSMakeRange(0, [content length])]) {
                //NSLog(@"A match:%@", content);
                return [[node attributes] objectForKey:@"href"];
            }
        }
        NSLog(@"No Lewis & Short link found for '%@'!", lemmaId);
        return nil;
    }


    - (NSString *)theHeaderString:(NSString *)lemmaId {
        NSArray *headers = [[[self definitions] objectForKey:lemmaId] objectForKey:KEY_HEADING];
        NSLog(@"%@=%@", KEY_HEADING, headers);
        NSMutableString *headerTitleString = [NSMutableString stringWithString:@""];
        for (XPathResultNode *header in headers) {
            [headerTitleString appendString:[header contentString]];
        }
        return headerTitleString;
    }


    - (NSString *)theForm:(NSString *)lemmaId ofIndex:(int)index {
        NSArray *table = [[[self definitions] objectForKey:lemmaId] objectForKey:KEY_TABLE];
        @try {
            XPathResultNode *node = [table objectAtIndex:index];
            NSLog(@"table = %@", node);
            XPathResultNode *td0 = [[node childNodes] objectAtIndex:0];
            return [td0 contentString];
        } @catch (id theException) {
            NSLog(@"Caught an exception trying to get the form data: %@", theException);
        }
        return @"";
    }


    - (NSString *)theFormParsed:(NSString *)lemmaId ofIndex:(int)index {
        NSArray *table = [[[self definitions] objectForKey:lemmaId] objectForKey:KEY_TABLE];
        @try {
            XPathResultNode *node = [table objectAtIndex:index];
            NSLog(@"table = %@", node);
            XPathResultNode *td1 = [[node childNodes] objectAtIndex:1];
            return [td1 contentString];
        } @catch (id theException) {
            NSLog(@"Caught an exception trying to get the form parse data: %@", theException);
        }
        return @"";
    }



#pragma mark NSURLConnectionDelegate methods
    - (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
        NSLog(@"connection:%@ WillSendRequest:%@ redirecResponse:%@ is called", connection, request.URL.absoluteString, response);
        @autoreleasepool {
            self.theURL = [request URL];
        }
        return request;
    }


    - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
        NSLog(@"connection:%@ didReceiveResponse:%@ is called", connection, response);
        [self.responseData setLength:0];
    }


    - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
        NSLog(@"connection:%@ didReceiveData:%@ is called", connection, data);
        [self.responseData appendData:data];
    }


    - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
        [self.observer showError:error forConnection:connection];
    }


    - (void)connectionDidFinishLoading:(NSURLConnection *)connection {
        NSLog(@"connectionDidFininishLoading:%@ is called", connection);
        NSString *content = [[NSString alloc] initWithBytes:[self.responseData bytes]
                                                     length:[self.responseData length]
                                                   encoding:NSUTF8StringEncoding];
        NSLog(@"Data = %@", content);
        [self populateLemmaData:self.responseData];
        [self.observer refreshViewData:self];
    }

#pragma mark the population methods that parse the HTML for the necessary data.

    - (NSArray *)getAnalysis:(NSData *)data {
        NSString *xPathQueryString = @"//div[@class='analysis']";
        return [XPathResultNode nodesForXPathQuery:xPathQueryString onHTML:data];
    }


    - (void)populateLemmaData:(NSData *)data {
        NSString *xPathDivClassLemma = @"//div[@class='analysis']//div[@class='lemma']";
        //NSLog(@"xpath=%@", xPathDivClassLemma);
        NSArray *idNodes = [self getLemmaIds:[XPathResultNode nodesForXPathQuery:xPathDivClassLemma onHTML:data]];
        NSMutableArray *temporaryLemmas = [NSMutableArray arrayWithCapacity:[idNodes count]];
        if (idNodes == nil || [idNodes count] == 0) {
            NSString *reasonStr = [self cannotParseLemmataFromData:data];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
            [userInfo setObject:@"Search Failed" forKey:@"title"];
            [userInfo setObject:reasonStr
                         forKey:@"message"];
            NSException *exception = [NSException exceptionWithName:@"NoLemmataPresent" reason:reasonStr userInfo:userInfo];
            if (self.observer != nil) {
                [self.observer showError:exception
                           forSearchTerm:self.urlString];
            } else {
                @throw exception;
            }
        }

        for (NSString *lemmaId in idNodes) {
            [temporaryLemmas addObject:lemmaId];
            NSMutableDictionary *lemmaDict = [[NSMutableDictionary alloc] init];
            NSLog(@"lemma nodeID='%@'", lemmaId);
            [self lemmaHeading:data lemmaId:lemmaId nodeData:lemmaDict];
            [self lemmaDefinition:data lemmaId:lemmaId nodeData:lemmaDict];
            [self lemmaTable:data lemmaId:lemmaId nodeData:lemmaDict];
            [self lemmaLexiconLinks:data lemmaId:lemmaId lemmaDict:lemmaDict];

            [[self definitions] setObject:lemmaDict forKey:lemmaId];
        }
        [self setLemmas:temporaryLemmas];
    }


    - (void)lemmaLexiconLinks:(NSData *)data lemmaId:(NSString *)lemmaId lemmaDict:(NSMutableDictionary *)lemmaDict {
        NSString *xPath = [NSString stringWithFormat:@"//div[@class='analysis']//div[@id='%@']/p/a", lemmaId];
        //NSLog(@"xpath=%@", xPath);
        NSArray *queryResult = [XPathResultNode nodesForXPathQuery:xPath onHTML:data];
        // we need a mutable array, because we are going to add to it
        NSMutableArray *lexicon = [NSMutableArray arrayWithArray:queryResult];
        NSMutableArray *lexiconReal = [self extractLinksFromStaticHtml:data forLemma:lemmaId withLexicon:lexicon];
        [self setIntoData:lemmaDict theValue:lexiconReal withKey:KEY_LEXICON whichCameFromXpath:xPath];
    }


    - (NSMutableArray *)extractLinksFromStaticHtml:(NSData *)data forLemma:(NSString *)lemmaId withLexicon:(NSArray *)lexiconPossibles {
        // get the embedded links, which are elsewhere in the html;
        // these can be found by regex on the id of the node, and
        // trivially transforming it to a new id format, then searching.
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"-link$" options:NSRegularExpressionCaseInsensitive error:nil];
        NSMutableArray *lexiconReal = [NSMutableArray array];
        for (XPathResultNode *node in lexiconPossibles) {
            @try {
                NSString *nodeId = [[node attributes] objectForKey:@"id"];
                NSString *linkContentsId = [regex stringByReplacingMatchesInString:nodeId options:NSRegularExpressionCaseInsensitive
                                                                             range:NSMakeRange(0, [nodeId length]) withTemplate:@"-contents"];
                NSString *docId = [regex stringByReplacingMatchesInString:nodeId options:NSRegularExpressionCaseInsensitive
                                                                    range:NSMakeRange(0, [nodeId length]) withTemplate:@""];
                NSString *xPathLink = [NSString stringWithFormat:@"//div[@id='lexicon']/div[@id='%@']/p[@class='new_window_link']/a[@target]", linkContentsId];
                //NSLog(@"docId='%@'\nxpath='%@'", docId, xPathLink);
                NSArray *links = [XPathResultNode nodesForXPathQuery:xPathLink onHTML:data];
                //NSLog(@"Links count=%d", [links count]);
                if ([links count] == 1) {
                    NSString *documentLink = [NSString stringWithFormat:@"%@%@%@", HOPPER_BASE, HOPPER_DOC_LOADER_URL, docId];
                    //NSLog(@"The document link is:%@", documentLink);
                    NSString *documentDescription = [node contentString];
                    NSString *artificialLinkStr = [NSString stringWithFormat:@"<a lemma='%@' id='%@' docId='%@' href='%@'>%@</a>", lemmaId, linkContentsId,
                                                                             docId, documentLink, documentDescription];
                    NSLog(@"The link should be: %@", artificialLinkStr);
                    NSData *artificialLinkData = [artificialLinkStr dataUsingEncoding:NSUTF8StringEncoding];
                    [lexiconReal addObjectsFromArray:[XPathResultNode nodesForXPathQuery:@"//a" onHTML:artificialLinkData]];
                } else if ([links count] > 1) {
                    NSLog(@"There is more than one link, which is an error.");
                    @throw [NSException exceptionWithName:@"ThereCanOnlyBeOne" reason:[NSString stringWithFormat:@"Found more than one element of link data for id:%@",
                                                                                                                 linkContentsId] userInfo:nil];
                }
                NSLog(@"Completed for lemma '%@' link to '%@' entry", lemmaId, node.contentString);
                // [lexiconTemp addObjectsFromArray:links];
            } @catch (id theException) {
                NSLog(@"Caught an exception: %@", theException);
            }
        }
        return lexiconReal;
    }


    - (void)lemmaTable:(NSData *)data lemmaId:(NSString *)lemmaId nodeData:(NSMutableDictionary *)lemmaDict {
        NSString *xPath = [NSString stringWithFormat:@"//div[@class='analysis']//div[@id='%@']/table//tr", lemmaId];
        //NSLog(@"xpath=%@", xPath);
        NSArray *table = [XPathResultNode nodesForXPathQuery:xPath onHTML:data];
        [self setIntoData:lemmaDict theValue:table withKey:KEY_TABLE whichCameFromXpath:xPath];
    }


    - (void)lemmaDefinition:(NSData *)data lemmaId:(NSString *)lemmaId nodeData:(NSMutableDictionary *)lemmaDict {
        NSString *xPath = [NSString stringWithFormat:@"//div[@class='analysis']//div[@id='%@']/div[@class='lemma_header']/span[@class='lemma_definition']",
                                                     lemmaId];
        //NSLog(@"xpath=%@", xPath);
        NSArray *definition = [XPathResultNode nodesForXPathQuery:xPath onHTML:data];
        [self setIntoData:lemmaDict theValue:definition withKey:KEY_DEFINITION whichCameFromXpath:xPath];
    }


    - (void)lemmaHeading:(NSData *)data lemmaId:(NSString *)lemmaId nodeData:(NSMutableDictionary *)lemmaDict {
        NSString *xPath = [NSString stringWithFormat:@"//div[@class='analysis']//div[@id='%@']/div[@class='lemma_header']/h4", lemmaId];
        //NSLog(@"xpath=%@", xPath);
        NSArray *header = [XPathResultNode nodesForXPathQuery:xPath onHTML:data];
        [self setIntoData:lemmaDict theValue:header withKey:KEY_HEADING whichCameFromXpath:xPath];
    }


    - (void)setIntoData:(NSMutableDictionary *)nodeData theValue:(NSArray *)value withKey:(NSString *)key whichCameFromXpath:(NSString *)xPath {
        if (value != nil) {
            [nodeData setObject:value forKey:key];
        } else {
            NSLog(@"Values %@ not found for xpath %@", key, xPath);
        }
    }


    - (NSArray *)getLemmaIds:(NSArray *)array {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (XPathResultNode *node in array) {
            NSDictionary *dict = node.attributes;
            NSString *theNodeId = [dict objectForKey:@"id"];
            NSLog(@"found lemma node with id:%@", theNodeId);
            [result addObject:theNodeId];
        }
        return result;
    }

    // ERROR HANDLING FROM SERVER IS BELOW HERE.
    //
    // 1. If we get an error, it either looks like this (i.e. server error);
    //
    //  <html><head>
    //  <title>503 Service Temporarily Unavailable</title>
    //  </head><body>
    //  <h1>Service Temporarily Unavailable</h1>
    //  <p>The server is temporarily unable to service your
    //      request due to maintenance downtime or capacity
    //  problems. Please try again later.</p>
    //  <hr>
    //  <address>Apache/2.2.14 (Ubuntu) Server at new13.perseus.tufts.edu Port 80</address>
    //  </body></html>
    //
    // 2. OR it looks like this: (i.e. 'word not found' basically) Trimmed to the interesting bits.
    //
    // <html><head>
    //  <title>Latin Word Study Tool</title>
    // ...
    //  <body onload="document.f.l.focus(); checkRedirect();">
    // ...
    //  <div id="main">
    // ...
    //  <div id="main_col">
    //      <p>Sorry, no information was found for <span class="la">sgskg</span>.</p>
    //  </div>
    //  </div>
    //  </body></html>

    - (NSString *)cannotParseLemmataFromData:(NSData *)data {
        // error
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        // NSLog(@"Data could not be parsed into lemmata! Data=%@", dataString);
        NSString *reasonStr;
        NSArray *errorTitleValues = [XPathResultNode nodesForXPathQuery:@"//title" onHTML:data];
        NSString *errorTitleText;
        if (errorTitleValues != nil && [errorTitleValues count] > 0) {
            XPathResultNode *errorTitleNode = (XPathResultNode *) [errorTitleValues objectAtIndex:0];
            if (errorTitleNode != nil) {
                errorTitleText = errorTitleNode.contentString;
                //NSLog(@"Error title: %@", errorTitleText);
            }
        }

        if (errorTitleText != nil && [errorTitleText isEqualToString:@"Latin Word Study Tool"]) {
            NSArray *errorData = [XPathResultNode nodesForXPathQuery:@"//div[@id='main_col']/p" onHTML:data];
            if (errorData != nil && [errorData count] > 0) {
                XPathResultNode *errorNode = (XPathResultNode *) [errorData objectAtIndex:0];
                NSString *appended = [errorNode contentStringByUnifyingSubnodesWithSeparator:@" "];
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s*\\.\\s*$" options:0 error:nil];
                NSString *fixed = [regex stringByReplacingMatchesInString:appended options:NULL range:NSMakeRange(0, [appended length]) withTemplate:@"."];
                reasonStr = [NSString stringWithFormat:@"Not found. Server reported: \"%@\"", fixed];
            } else {
                reasonStr = @"Unknown issue with data!";
                NSLog(@"%@ Data could not be parsed into lemmata! Data=%@", reasonStr, dataString);
            }
        } else if (errorTitleText != nil) {
            reasonStr = [NSString stringWithFormat:@"Server error: %@", errorTitleText];
        } else {
            reasonStr = @"Unknown error!";
            NSLog(@"%@ Data could not be parsed into lemmata! Data=%@", reasonStr, dataString);
        }

        NSLog(@"Error reason was: %@", reasonStr);
        return reasonStr;
    }

@end
