//
//  AZShop+CoreDataProperties.h
//  AutozvukUA
//
//  Created by Admin on 1/29/16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AZShop.h"

NS_ASSUME_NONNULL_BEGIN

@interface AZShop (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *image;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nullable, nonatomic, retain) NSString *objId;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *workTime;

@end

NS_ASSUME_NONNULL_END
