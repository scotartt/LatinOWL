//
// Created by smcphee on 13/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


@protocol OL_LatinMorphDataObserver <NSObject>
  - (void)refreshViewData:(OL_LatinMorphData *)latinMorph;

  - (void)showError:(NSError *)error forConnection:(NSURLConnection *)connection;

  - (void)showError:(NSException *)exception forSearchTerm:(NSString *)searchTerm;
@end
