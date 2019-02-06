//
//  AZShop+CD.m
//  AutozvukUA
//
//  Created by Serbin Taras on 15.01.16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//

#import "AZShop+CD.h"

@implementation AZShop (CD)


+(BOOL)isWithID:(NSString *)objId
{
    return [AZCoreDataUtils isManagedObjectOfClass:[AZShop class] forKey:@"objId" byStr:objId];
}

+(AZShop*)getByID:(NSString *)objId
{
    return (AZShop*)[AZCoreDataUtils getManagedObjectOfClass:[AZShop class] forKey:@"objId" byStr:objId];
}

+(NSEntityDescription*)getEntity
{
    return [AZCoreDataUtils getEntityForClass:[AZShop class]];
}

+(NSArray*)getAll
{
    return [AZCoreDataUtils getAllManagedObjectOfClass:[AZShop class] sortedKey:@"objId"];
}

+ (NSArray *)arrayFromString:(NSString *)string
{
    return [string componentsSeparatedByString:@";"];
}
@end
