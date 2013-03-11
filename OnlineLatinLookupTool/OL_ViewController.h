//
//  OL_ViewController.h
//  OnlineLatinLookupTool
//
//  Created by Scot Mcphee on 10/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OL_LatinMorphData.h"

@interface OL_ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

  @property(weak, nonatomic) IBOutlet UISearchBar *searchBar;
  @property(weak, nonatomic) IBOutlet UITableView *tableView;
  @property(strong, nonatomic) NSString *searchText;
  @property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

  - (void)refreshViewData:(OL_LatinMorphData *)latinMorph;
  - (void)showError:(NSError *)error forConnection:(NSURLConnection *)connection;
  - (void)showError:(NSException *)exception forSearchTerm:(NSString *)searchTerm;

@end
