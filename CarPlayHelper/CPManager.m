//
//  CPManager.m
//  CarPlay
//
//  Created by daniel martinez gonzalez on 20/11/17.
//  Copyright © 2017. All rights reserved.
//

#import "CPManager.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <UIKit/UIKit.h>
#import "UIKit+CarPlay.h"
#include <stdlib.h>

@interface UIScreen (UIScreenSecrets)
    + (UIScreen *)_carScreen;
    - (BOOL)_isCarScreen;
@end

@interface CPManager()

    @property ( strong, nonatomic) NSMutableArray *arrayReceivers;

@end

@implementation CPManager

@synthesize CPversion;
@synthesize CPmanufacturer;
@synthesize CPname;
@synthesize CPfirmwareRevision;
@synthesize connectionManager;
@synthesize notifiedSecondScreen;


static CPManager *sharedInstance = nil;


+(CPManager *) sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[CPManager alloc] init];
    }
    
    return sharedInstance;
}


- (void)initialize{
    connectionManager = [CP_ConnectionManager sharedManager];
    self.arrayReceivers = [[NSMutableArray alloc]init];
    notifiedSecondScreen = FALSE;
    [connectionManager InitEAPObservers];
    [self initObserversNotifications];
}


- (void)initObserversNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(secondScreenNotification:)
                                                 name:@"secondScreenConnected"
                                               object:nil];
}


- (BOOL)CarPlayScreen{
    
    if ([[UIScreen screens] count] > 1)
    {
        for (UIScreen *screen in [UIScreen screens])
        {
            if ([screen _isCarScreen])
            {
                return YES;
            }
        }
    }
    
    return NO;
}


- (UIScreen *)returnCarPlayScreen{
    
    if ([[UIScreen screens] count] > 1)
    {
        for (UIScreen *screen in [UIScreen screens])
        {
            if ([screen _isCarScreen])
            {
                return screen;
            }
        }
    }
    return [UIScreen new];
}

//MARK: Notification Center Second Screen Methods

- (void) secondScreenNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"secondScreenConnected"]){

        NSDictionary *dictConnect = notification.userInfo;
        NSString *value = [dictConnect valueForKey:@"State"];
        [self notifyConnectedSecondScreenToReceivers:value.boolValue];
        
        if(value.boolValue){
            NSString *values[4];
            values[0] = @"1";
            values[1] = [NSString stringWithFormat:@"%@", connectionManager.name];
            values[2] = [NSString stringWithFormat:@"%@", connectionManager.manufacturer];
            values[3] = [NSString stringWithFormat:@"%@", connectionManager.firmwareRevision];
            
            NSString *keys[4];
            keys[0] = @"state";
            keys[1] = @"name";
            keys[2] = @"manufacturer";
            keys[3] = @"firmwareRevision";
            NSDictionary *dictInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys count:3];
            
            if(!notifiedSecondScreen){
                notifiedSecondScreen = TRUE;
                [self notifyInfosecondScreenToReceivers:dictInfo];
            }
        }
        else{
            
            NSString *values[4];
            values[0] = @"0";
            values[1] = [NSString stringWithFormat:@"%@", connectionManager.name];
            values[2] = [NSString stringWithFormat:@"%@", connectionManager.manufacturer];
            values[3] = [NSString stringWithFormat:@"%@", connectionManager.firmwareRevision];
            
            NSString *keys[4];
            keys[0] = @"state";
            keys[1] = @"name";
            keys[2] = @"manufacturer";
            keys[3] = @"firmwareRevision";
            NSDictionary *dictInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys count:3];
            
            if(notifiedSecondScreen){
                notifiedSecondScreen = FALSE;
                [self notifyInfosecondScreenToReceivers:dictInfo];
            }
        }
    }
}


//MARK: Protocol Observer Methods

- (void)addReceiver: (id<CPDelegate>)receiver
{
    [self.arrayReceivers addObject:receiver];
}


//MARK: Protocol Second Screen Methods

- (void)notifyConnectedSecondScreenToReceivers: (BOOL )connected{
    [self.arrayReceivers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        
        if ([obj respondsToSelector:@selector(secondScreen:)]){
            [obj secondScreen:connected];
        }
    }];
}


- (void)notifyInfosecondScreenToReceivers: (NSDictionary *)dict{
    [self.arrayReceivers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        
         if ([obj respondsToSelector:@selector(accesoryInfo:)]){
             [obj accesoryInfo:dict];
         }
     }];
}

@end
