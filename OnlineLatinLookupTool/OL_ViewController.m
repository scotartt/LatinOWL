//
//  OL_ViewController.m
//  OnlineLatinLookupTool
//
//  Created by Scot Mcphee on 10/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import "OL_ViewController.h"
#import "OL_AppDelegate.h"

@interface OL_ViewController ()

@end

@implementation OL_ViewController

  - (void)viewDidLoad {
    [super viewDidLoad];
      [self.tableView setHidden:YES];
    self.title = @"Online Latin Lookup";
    [self.activityIndicator stopAnimating];
  }

  - (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  }

  - (void)refreshViewData:(OL_LatinMorphData *)latinMorph {
    NSLog(@"refreshViewData called from URL %@", latinMorph.urlString);
   [self.activityIndicator stopAnimating];
      [self.tableView setHidden:NO];

  }

  - (void)showError:(NSError *)error forConnection:(NSURLConnection *)connection {
    NSLog(@"Error = %@", error);
  }

- (void)showError:(NSException *)exception forSearchTerm:(NSString *)searchTerm {
    NSLog(@"For search term=%@ - got error = %@", searchTerm, [exception description]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(NSString *)[exception.userInfo objectForKey:@"title"]
                                               message:(NSString *)[exception.userInfo objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}

#pragma UISearchBarDelegate methods

  - (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
  }

  - (void)handleSearch:(UISearchBar *)searchBar {
    [self.activityIndicator startAnimating];
      [self.tableView setHidden:YES];

    NSLog(@"User searched for '%@'", searchBar.text);
    [searchBar resignFirstResponder]; // keyboard go away
    self.searchText = searchBar.text;
    OL_LatinMorphData *latinMorphData = [[OL_LatinMorphData alloc] init];
    [latinMorphData searchLatin:self.searchText withController:self];
  }

  - (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder]; // keyboard go away
    [self.activityIndicator stopAnimating];

  }

#pragma UITableViewDelegate methods
  - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
  }

  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
  }


@end
