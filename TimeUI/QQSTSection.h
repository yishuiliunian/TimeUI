//
//  QQSTSection.h
//  QQMSFContact
//
//  Created by Stone Dong on 14-2-12.
//
//

#import <Foundation/Foundation.h>

@class QQSTRow;
@interface QQSTSection : NSObject
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* footerTitle;
@property (nonatomic, strong) NSString* headerTitle;
@property (nonatomic, assign, readonly) NSInteger rowCount;
- (void) addRow:(QQSTRow*)row atIndex:(NSInteger)index;
- (void) removeRowAtIndex:(NSInteger)index;
- (QQSTRow*) rowAtIndex:(NSInteger)index;

@end
