//
//  OnlineLatinLookupToolTests.h
//  OnlineLatinLookupToolTests
//
//  Created by Scot Mcphee on 10/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "OWLMorphData.h"

@interface OnlineLatinLookupToolTests : SenTestCase

  @property(nonatomic, strong) OWLSearchViewController *controller;
  @property(nonatomic, strong) OWLMorphData *latinData;

@end
