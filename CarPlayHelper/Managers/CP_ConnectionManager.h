//
//  ConnectionManager.h
//  CarPlay
//
//  Created by daniel martinez gonzalez on 20/11/17.
//  Copyright © 2017. All rights reserved.
//

/// External Accesory Connection - HU Firmware Info

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>


@interface CP_ConnectionManager : NSObject{
    NSArray *protocolString;
    NSString *manufacturer;
    NSString *name;
    NSString *firmwareRevision;
}

@property (nonatomic, retain) NSArray *protocolString;
@property (nonatomic, retain) NSString *manufacturer;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *firmwareRevision;

+ (id)sharedManager;
- (void)InitEAPObservers;

@end
