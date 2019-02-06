//
//  AZShop+CD.h
//  AutozvukUA
//
//  Created by Serbin Taras on 15.01.16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//

#import "AZShop.h"
#import "AZCoreDataUtils.h"

@interface AZShop (CD)
+(BOOL)isWithID:(NSString *)objId;
+(AZShop*)getByID:(NSString *)objId;
+(NSEntityDescription*)getEntity;
+(NSArray*)getAll;
+ (NSArray *)arrayFromString:(NSString *)string;
@end
