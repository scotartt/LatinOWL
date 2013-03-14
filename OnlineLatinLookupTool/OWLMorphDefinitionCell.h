//
//  OWLMorphDefinitionCell.h
//  OnlineLatinLookupTool
//
//  Created by Scot Mcphee on 13/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OWLMorphDefinitionCell : UITableViewCell
    @property(weak, nonatomic) IBOutlet UILabel *morphTitle;
    @property(weak, nonatomic) IBOutlet UILabel *morphParsing;

@end
