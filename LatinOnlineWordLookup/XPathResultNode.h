//
//  XPathQuery.h
//  CocoaWithLove
//
//  Created by Matt Gallagher on 2011/05/20.
//  Copyright 2011 Matt Gallagher. All rights reserved.
//  MINOR ALTERATIONS MADE 2013 Scot Mcphee:
//    a. changed to use ARC, which is to say I removed use of 'retain' and 'dealloc' etc.
//    b. added contentStringByUnifyingSubnodesWithSeparator:NSString which allows
//       to append all child nodes with a given separator string (e.g. space).
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

@interface XPathResultNode : NSObject {
        NSString *name;
        NSMutableDictionary *attributes;
        NSMutableArray *content;
    }

    @property(nonatomic, strong, readonly) NSString *name;
    @property(nonatomic, strong, readonly) NSMutableDictionary *attributes;
    @property(nonatomic, strong, readonly) NSMutableArray *content;

    + (NSArray *)nodesForXPathQuery:(NSString *)query onHTML:(NSData *)htmlData;

    + (NSArray *)nodesForXPathQuery:(NSString *)query onXML:(NSData *)xmlData;

    - (NSArray *)childNodes;

    - (NSString *)contentString;

    - (NSString *)contentStringByUnifyingSubnodes;

    - (NSString *)contentStringByUnifyingSubnodesWithSeparator:(NSString *)separator;

@end
