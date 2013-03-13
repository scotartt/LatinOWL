//
//  OL_ViewController.m
//  OnlineLatinLookupTool
//
//  Created by Scot Mcphee on 10/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import "OL_ViewController.h"
#import "OL_LemmaTableViewCell.h"
#import "OL_MorphDefinitionCell.h"

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
    [self.tableView setHidden:YES];
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
    [searchBar setText:@""];
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


//  - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSLog(@"called titleForHeaderInSection:%d", section);
//    // The header for the section is the region name -- get this from the region at the section index.
//    NSString *lemmaId = [self getLemmaIdForSection:(NSUInteger) section];
//    return [self.latinMorphData theHeaderString:lemmaId];
//  }

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
      NSString *cellIdentifier = @"LemmaTableCell";
      OL_LemmaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (cell == nil) {
        cell = [[OL_LemmaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
      }

      NSString *titleText = [self.latinMorphData theHeaderString:lemmaId];
      UILabel *titleLabel = [cell lemmaTitle];
      [titleLabel setText:titleText];

      NSString *meaningText = [self.latinMorphData theMeaning:lemmaId];
      UILabel *meaningCell = [cell lemmaMeaning];
      [meaningCell setText:meaningText];
      //[meaningCell setAdjustsFontSizeToFitWidth:YES];

      return cell;
    } else if (row < [self tableView:tableView numberOfRowsInSection:section]) {
      NSString *cellIdentifier = @"MorphTableCell";
      OL_MorphDefinitionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (cell == nil) {
        cell = [[OL_MorphDefinitionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
      }
      [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
      int indexId = row - 1; // the meaning of the lemma is at the first cell position, therefore subtract one from the row number.
      NSString *form = [self.latinMorphData theForm:lemmaId ofIndex:indexId];
      NSString *parsed = [self.latinMorphData theFormParsed:lemmaId ofIndex:indexId];
      if (form == nil || parsed == nil || [form isEqualToString:@""] || [parsed isEqualToString:@""]) {
        return cell;
      }
      UILabel *morphTitleLabel = [cell morphTitle];
      [morphTitleLabel setText:form];

      UILabel *morphParsing = [cell morphParsing];
      [morphParsing setText:parsed];
      return cell;
    }  else {
      return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty"];
    }
  }


@end
