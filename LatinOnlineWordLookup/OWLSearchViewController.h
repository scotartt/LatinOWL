//
//  OWLSearchViewController.h
//  OnlineLatinLookupTool
//
//  Created by Scot Mcphee on 10/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OWLMorphData.h"
#import "OWLMorphDataObserver.h"


@interface OWLSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, OWLMorphDataObserver>

    @property(strong, nonatomic) NSString *searchText;
    @property(weak, nonatomic) IBOutlet UISearchBar *searchBar;
    @property(weak, nonatomic) IBOutlet UITableView *tableView;
    @property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
    @property(strong, nonatomic) IBOutlet UIButton *aboutButton;

@end
