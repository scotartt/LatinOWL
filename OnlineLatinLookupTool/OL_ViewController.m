//
//  OL_ViewController.m
//  OnlineLatinLookupTool
//
//  Created by Scot Mcphee on 10/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import "OL_ViewController.h"
#import "OL_AppDelegate.h"
#import "XPathResultNode.h"

@interface OL_ViewController ()

  @property OL_LatinMorphData *latinMorphData;

@end

@implementation OL_ViewController

  @synthesize latinMorphData;


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
    [self.tableView setHidden:NO];
    NSLog(@"refreshViewData called from URL %@", latinMorph.urlString);
    [self setLatinMorphData:latinMorph];
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];

  }

  - (void)showError:(NSError *)error forConnection:(NSURLConnection *)connection {
    NSLog(@"Error = %@", error);
  }

  - (void)showError:(NSException *)exception forSearchTerm:(NSString *)searchTerm {
    NSLog(@"For search term=%@ - got error = %@", searchTerm, [exception description]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(NSString *) [exception.userInfo objectForKey:@"title"]
                                                    message:(NSString *) [exception.userInfo objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

  }

#pragma UISearchBarDelegate methods

  - (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
  }

  - (void)handleSearch:(UISearchBar *)searchBar {
    [self.activityIndicator startAnimating];
    [self.tableView setHidden:NO];
    // clear the table
    OL_LatinMorphData *searchLatinMorphData = [[[OL_LatinMorphData alloc] init] reset];
    [self.tableView reloadData];
    NSLog(@"User searched for '%@'", searchBar.text);
    [searchBar resignFirstResponder]; // keyboard go away
    self.searchText = searchBar.text;
    [searchLatinMorphData searchLatin:self.searchText withController:self];
  }

  - (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder]; // keyboard go away
    [self.activityIndicator stopAnimating];

  }

#pragma UITableViewDelegate methods

  - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"called numberOfSectionsInTableView:%@", tableView);
    return [[[self latinMorphData] lemmas] count];
  }

  - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"called numberOfRowsInSection:%d", section);
    // Number of rows is the number of time zones in the region for the specified section.
    NSString *lemmaId = [[[self latinMorphData] lemmas] objectAtIndex:(NSUInteger) section];
    NSDictionary *definitions = [[self latinMorphData] definitions];
    if (definitions != nil) {
      NSDictionary *lemmaData = [definitions objectForKey:lemmaId];
      if (lemmaData != nil) {
        NSArray *formTable = [lemmaData objectForKey:KEY_TABLE];
        if (formTable != nil && [formTable count] > 0) {
          return [formTable count] + 1;
        }
      }
    }
    return 0;
  }


  - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSLog(@"called titleForHeaderInSection:%d", section);
    // The header for the section is the region name -- get this from the region at the section index.
    NSString *lemmaId = [self getLemmaIdForSection:(NSUInteger) section];
    return [self.latinMorphData theHeaderString:lemmaId];
  }

  - (NSString *)getLemmaIdForSection:(NSUInteger)section {
    NSString *lemmaId = [[[self latinMorphData] lemmas] objectAtIndex:section];
    return lemmaId;
  }


  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
    int section = [indexPath section];
    NSString *lemmaId = [[[self latinMorphData] lemmas] objectAtIndex:section];
    NSLog(@"called cellForRowAtIndexPath:%d,%d %@", section, row, lemmaId);
    if (row == 0) {
      NSString *cellIdentifier = @"LemmaDefCellIdentifier";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
      }
      NSString *meaning = [self.latinMorphData theMeaning:lemmaId];
      UILabel *label = [cell textLabel];
      [label setText:meaning];
      [label setAdjustsFontSizeToFitWidth:YES];
      [label setFont:[UIFont italicSystemFontOfSize:[UIFont smallSystemFontSize]]];
      return cell;
    } else if (row < [self tableView:tableView numberOfRowsInSection:section]) {
      NSString *cellIdentifier = @"LatinCellIdentifier";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
      }
      int indexId = row - 1; // the meaning of the lemma is at the first position.
      NSString *form = [self.latinMorphData theForm:lemmaId ofIndex:indexId];
      NSString *parsed = [self.latinMorphData theFormParsed:lemmaId ofIndex:indexId];
      if (form == nil || parsed == nil || [form isEqualToString:@""] || [parsed isEqualToString:@""]) {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty"];
      }
      UILabel *label = [cell textLabel];
      NSString *labelText = [NSString stringWithFormat:@"%@ (%@)", form, parsed];
      [label setText:labelText];
      [label setAdjustsFontSizeToFitWidth:YES];
      [label setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
      return cell;
    } else {
      return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty"];
    }
  }


@end
