//
//  OnlineLatinLookupToolTests.h
//  OnlineLatinLookupToolTests
//
//  Created by Scot Mcphee on 10/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "OL_LatinMorphData.h"

@interface OnlineLatinLookupToolTests : SenTestCase

  @property(nonatomic, strong) UIViewController *controller;
  @property(nonatomic, strong) OL_LatinMorphData *latinData;

@end
