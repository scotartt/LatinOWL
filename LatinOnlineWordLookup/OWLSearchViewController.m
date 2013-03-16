//
//  OWLSearchViewController.m
//  OnlineLatinLookupTool
//
//  Created by Scot Mcphee on 10/03/13.
//  Copyright (c) 2013 Scot Mcphee. All rights reserved.
//

#import "OWLSearchViewController.h"
#import "OWLLemmaTableCell.h"
#import "OWLMorphDefinitionCell.h"
#import "OWLDictionaryViewController.h"

@interface OWLSearchViewController ()

    @property OWLMorphData *latinMorphData;

@end


@implementation OWLSearchViewController

    @synthesize latinMorphData;


    - (void)viewDidLoad {
        [super viewDidLoad];
        [self.tableView setHidden:YES];
        self.title = @"Latin Search";
        [self.activityIndicator stopAnimating];
    }


    - (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // we are opening up the dictionary view.
    if ([segue.identifier isEqualToString:@"OWLDictionarySegue"]) {
        OWLDictionaryViewController *dictionaryViewController = segue.destinationViewController;
        NSLog(@"changing to view:%@", dictionaryViewController);
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        int section = [indexPath section];
        NSString *lemmaId = [[[self latinMorphData] lemmas] objectAtIndex:section];
        NSLog(@"Selected lemma:%@", lemmaId);
        NSString *theURL = [NSString stringWithFormat:@"https://www.google.com.au?q=%@", lemmaId];
        dictionaryViewController.theURL = theURL;
    }
}


    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

#pragma OWLMorphDataObserver methods

    - (void)refreshViewData:(OWLMorphData *)latinMorph {
        if (latinMorph == [self latinMorphData]) {
            // this is the latest instance of search...
            [self.tableView setHidden:NO];
            NSLog(@"refreshViewData called from URL %@", latinMorph.urlString);
            [self.activityIndicator stopAnimating];
            [self.tableView reloadData];
        }
    }


    - (void)showError:(NSError *)error forConnection:(NSURLConnection *)connection {
        NSLog(@"Connection Error = %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error"
                                                        message:error.localizedDescription
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
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
        OWLMorphData *searchLatinMorphData = [OWLMorphData data];
        [self setLatinMorphData:searchLatinMorphData];
        // clear the table
        [self.tableView reloadData];
        NSLog(@"User searched for '%@'", searchBar.text);
        [searchBar resignFirstResponder]; // keyboard go away
        self.searchText = searchBar.text;
        [searchLatinMorphData searchLatin:self.searchText withObserver:self];
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


    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        int row = [indexPath row];
        int section = [indexPath section];
        NSString *lemmaId = [[[self latinMorphData] lemmas] objectAtIndex:section];
        NSLog(@"called cellForRowAtIndexPath:%d,%d %@", section, row, lemmaId);
        if (row == 0) {
            NSString *cellIdentifier = @"LemmaTableCell";
            OWLLemmaTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[OWLLemmaTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }

            NSString *titleText = [self.latinMorphData theHeaderString:lemmaId];
            UILabel *titleLabel = [cell lemmaTitle];
            [titleLabel setText:titleText];

            NSString *meaningText = [self.latinMorphData theMeaning:lemmaId];
            UILabel *meaningCell = [cell lemmaMeaning];
            [meaningCell setText:meaningText];
            return cell;
        } else if (row < [self tableView:tableView numberOfRowsInSection:section]) {
            NSString *cellIdentifier = @"MorphTableCell";
            OWLMorphDefinitionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[OWLMorphDefinitionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
        } else {
            return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty"];
        }
    }

@end
