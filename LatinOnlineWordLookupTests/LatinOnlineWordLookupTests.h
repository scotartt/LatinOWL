//
//  LatinOnlineWordLookupTests.h
//  LatinOnlineWordLookupTests
//
//  Created by Scot Mcphee on 16/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "OWLMorphDataObserver.h"
#import "OWLMorphData.h"

@interface LatinOnlineWordLookupTests : SenTestCase <OWLMorphDataObserver>

    @property OWLMorphData *morphData;

@end
