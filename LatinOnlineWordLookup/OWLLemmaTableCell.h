//
//  OWLLemmaTableCell.h
//  OnlineLatinLookupTool
//
//  Created by Scot Mcphee on 13/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OWLLemmaTableCell : UITableViewCell
    @property(weak, nonatomic) IBOutlet UILabel *lemmaTitle;
    @property(weak, nonatomic) IBOutlet UILabel *lemmaMeaning;
@end
