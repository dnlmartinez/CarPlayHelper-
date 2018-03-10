//
//  ConnectionManager.m
//  CarPlay
//
//  Created by daniel martinez gonzalez on 20/11/17.
//  Copyright © 2017 . All rights reserved.
//


#import "CP_ConnectionManager.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <UIKit/UIKit.h>
#import "UIKit+CarPlay.h"


@implementation CP_ConnectionManager

@synthesize protocolString;
@synthesize manufacturer;
@synthesize name;
@synthesize firmwareRevision;

#pragma mark Singleton Methods


+ (id)sharedManager{
    static CP_ConnectionManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id)init{
    if (self = [super init]) {
        protocolString = [NSArray new];
        manufacturer = @"";
        name = @"";
        firmwareRevision = @"";
    }
    return self;
}

- (void)dealloc {
    
}

- (void)InitEAPObservers{
    
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(screenDidConnect:)
                                                 name:UIScreenDidConnectNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(screenDidDisconnect:)
                                                 name:UIScreenDidDisconnectNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessoryDidConnect:)
                                                 name:EAAccessoryDidConnectNotification
                                               object:nil];
    
    if ([[UIScreen screens] count] > 1)
    {
        for (UIScreen *screen in [UIScreen screens])
        {
            if ([screen _isCarScreen])
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"1" forKey:@"State"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"secondScreenConnected"
                                                                    object:nil
                                                                  userInfo:userInfo];
            }
        }
    }
}


//MARK: SecondScreen


- (void)screenDidConnect:(NSNotification *)notification{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"1" forKey:@"State"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"secondScreenConnected"
                                                        object:nil
                                                      userInfo:userInfo];
}


- (void)screenDidDisconnect:(NSNotification *)notification{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"0" forKey:@"State"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"secondScreenConnected"
                                                        object:nil
                                                      userInfo:userInfo];
}


- (void)accessoryDidConnect:(NSNotification *)notification{
    
    NSArray *connectedAccessories = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];
    
    for(EAAccessory *accessory in connectedAccessories){

        protocolString = accessory.protocolStrings;
        manufacturer = accessory.manufacturer;
        name = accessory.name;
        firmwareRevision = accessory.firmwareRevision;

    }
}



@end


