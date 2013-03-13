//
//  OL_LemmaTableViewCell.m
//  OnlineLatinLookupTool
//
//  Created by Scot Mcphee on 13/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import "OL_LemmaTableViewCell.h"

@implementation OL_LemmaTableViewCell

  - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      // Initialization code
    }
    return self;
  }

  - (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
  }

@end
