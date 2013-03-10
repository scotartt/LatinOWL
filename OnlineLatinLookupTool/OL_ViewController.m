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
    self.title = @"Online Latin Lookup";

  }

  - (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  }

  - (void)refreshViewData:(OL_LatinMorphData *)latinMorph {
    NSLog(@"refreshViewData called from URL %@", latinMorph.urlString);
  }

  - (void)showError:(NSError *)error forConnection:(NSURLConnection *)connection {
    NSLog(@"Error = %@", error);
  }

#pragma UISearchBarDelegate methods

  - (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
  }

  - (void)handleSearch:(UISearchBar *)searchBar {
    NSLog(@"User searched for '%@'", searchBar.text);
    [searchBar resignFirstResponder]; // keyboard go away
    self.searchText = searchBar.text;
    OL_LatinMorphData *latinMorphData = [[OL_LatinMorphData alloc] init];
    [latinMorphData searchLatin:self.searchText withController:self];
  }

  - (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder]; // keyboard go away
  }

#pragma UITableViewDelegate methods
  - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
  }

  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
  }


@end
