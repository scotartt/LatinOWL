//
// Created by smcphee on 13/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

@class OWLMorphData;


@protocol OWLMorphDataObserver <NSObject>
    - (void)refreshViewData:(OWLMorphData *)latinMorph;

    - (void)showError:(NSError *)error forConnection:(NSURLConnection *)connection;

    - (void)showError:(NSException *)exception forSearchTerm:(NSString *)searchTerm;
@end
