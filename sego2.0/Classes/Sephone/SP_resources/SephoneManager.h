/* SephoneManager.h
 *
 * Copyright (C) 2011  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioSession.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <CoreTelephony/CTCallCenter.h>

#import <sqlite3.h>
#import "SephoneUtils.h"

#include "sephone/sephonecore.h"
#include "sephone/sephone_tunnel.h"

extern const char *const SEPHONERC_APPLICATION_KEY;

extern NSString *const kSephoneCoreUpdate;
extern NSString *const kSephoneDisplayStatusUpdate;
extern NSString *const kSephoneTextReceived;
extern NSString *const kSephoneTextComposeEvent;
extern NSString *const kSephoneCallUpdate;
extern NSString *const kSephoneRegistrationUpdate;
extern NSString *const kSephoneMainViewChange;
extern NSString *const kSephoneAddressBookUpdate;
extern NSString *const kSephoneLogsUpdate;
extern NSString *const kSephoneSettingsUpdate;
extern NSString *const kSephoneBluetoothAvailabilityUpdate;
extern NSString *const kSephoneConfiguringStateUpdate;
extern NSString *const kSephoneGlobalStateUpdate;
extern NSString *const kSephoneNotifyReceived;

typedef enum _NetworkType {
    network_none = 0,
    network_2g,
    network_3g,
    network_4g,
    network_lte,
    network_wifi
} NetworkType;

typedef enum _TunnelMode {
    tunnel_off = 0,
    tunnel_on,
    tunnel_wwan,
    tunnel_auto
} TunnelMode;

typedef enum _Connectivity {
	wifi,
	wwan,
    none
} Connectivity;

extern const int kSephoneAudioVbrCodecDefaultBitrate;

/* Application specific call context */
typedef struct _CallContext {
    SephoneCall* call;
    bool_t cameraIsEnabled;
} CallContext;

struct NetworkReachabilityContext {
    bool_t testWifi, testWWan;
    void (*networkStateChanged) (Connectivity newConnectivity);
};

@interface SephoneCallAppData :NSObject {
    @public
	bool_t batteryWarningShown;
    UILocalNotification *notification;
    NSMutableDictionary *userInfos;
	bool_t videoRequested; /*set when user has requested for video*/
    NSTimer* timer;
};
@end

typedef struct _SephoneManagerSounds {
    SystemSoundID vibrate;
} SephoneManagerSounds;

@interface SephoneManager : NSObject {
@protected
	SCNetworkReachabilityRef proxyReachability;
	
@private
	NSTimer* mIterateTimer;
    NSMutableArray*  pushCallIDs;
	Connectivity connectivity;
	UIBackgroundTaskIdentifier pausedCallBgTask;
	UIBackgroundTaskIdentifier incallBgTask;
	CTCallCenter* mCallCenter;
    NSDate *mLastKeepAliveDate;
@public
    CallContext currentCallContextBeforeGoingBackground;
}
+ (SephoneManager*)instance;
#ifdef DEBUG
+ (void)instanceRelease;
#endif
+ (SephoneCore*) getLc;
+ (BOOL)isLcReady;
+ (BOOL)runningOnIpad;
+ (BOOL)isNotIphone3G;
+ (NSString *)getPreferenceForCodec: (const char*) name withRate: (int) rate;
+ (BOOL)isCodecSupported: (const char*)codecName;
+ (NSSet *)unsupportedCodecs;
+ (NSString *)getUserAgent;
+ (int)unreadMessageCount;

- (void)playMessageSound;
- (void)resetSephoneCore;
- (void)startSephoneCore;
- (void)destroySephoneCore;
- (BOOL)resignActive;
- (void)becomeActive;
- (BOOL)enterBackgroundMode;
- (void)keepAliveHandler;
- (void)addPushCallId:(NSString*) callid;
- (void)configurePushTokenForProxyConfig: (SephoneProxyConfig*)cfg;
- (BOOL)popPushCallID:(NSString*) callId;
- (SephoneCall *)acceptCallForCallId:(NSString*)callid;
- (void)cancelLocalNotifTimerForCallId:(NSString*)callid;

+ (BOOL)langageDirectionIsRTL;
+ (void)kickOffNetworkConnection;
- (void)setupNetworkReachabilityCallback;

- (void)refreshRegisters;

- (bool)allowSpeaker;

- (void)configureVbrCodecs;
- (void)setLogsEnabled:(BOOL)enabled;

+ (BOOL)copyFile:(NSString*)src destination:(NSString*)dst override:(BOOL)override;
+ (NSString*)bundleFile:(NSString*)file;
+ (NSString*)documentFile:(NSString*)file;
+ (NSString*)cacheDirectory;

- (void)acceptCall:(SephoneCall *)call;
- (void)call:(NSString *)address displayName:(NSString*)displayName transfer:(BOOL)transfer;


+(id)getMessageAppDataForKey:(NSString*)key inMessage:(SephoneChatMessage*)msg;
+(void)setValueInMessageAppData:(id)value forKey:(NSString*)key inMessage:(SephoneChatMessage*)msg;

- (void)spConfigSetString:(NSString*)value forKey:(NSString*)key;
- (NSString*)spConfigStringForKey:(NSString*)key;
- (NSString*)spConfigStringForKey:(NSString*)key withDefault:(NSString*)value;
- (void)spConfigSetString:(NSString*)value forKey:(NSString*)key forSection:(NSString*)section;
- (NSString*)spConfigStringForKey:(NSString*)key forSection:(NSString*)section;
- (void)spConfigSetInt:(NSInteger)value forKey:(NSString*)key;
- (NSInteger)spConfigIntForKey:(NSString*)key;
- (void)spConfigSetInt:(NSInteger)value forKey:(NSString*)key forSection:(NSString*)section;
- (NSInteger)spConfigIntForKey:(NSString*)key forSection:(NSString*)section;
- (void)spConfigSetBool:(BOOL)value forKey:(NSString*)key;
- (BOOL)spConfigBoolForKey:(NSString*)key;
- (void)spConfigSetBool:(BOOL)value forKey:(NSString*)key forSection:(NSString*)section;
- (BOOL)spConfigBoolForKey:(NSString*)key forSection:(NSString*)section;
- (void)silentPushFailed:(NSTimer*)timer;

+ (void)addProxyConfig:(NSString *)username password:(NSString *)password domain:(NSString *)domain;
+ (BOOL)hasCall:(SephoneCall*)call;
+ (BOOL)isCallOutgoing:(SephoneCall*)call;
+ (BOOL)isCallIncoming:(SephoneCall*)call;
+ (void)terminateCurrentCallOrConference;

@property (readonly) BOOL isTesting;

@property Connectivity connectivity;
@property (readonly) NetworkType network;
@property (readonly) const char*  frontCamId;
@property (readonly) const char*  backCamId;
@property (retain, nonatomic) NSString* SSID;
@property (readonly) sqlite3* database;
@property (nonatomic, retain) NSData *pushNotificationToken;
@property (readonly) SephoneManagerSounds sounds;
@property (readonly) NSMutableArray *logs;
@property (nonatomic, assign) BOOL speakerEnabled;
@property (nonatomic, assign) BOOL bluetoothAvailable;
@property (nonatomic, assign) BOOL bluetoothEnabled;
@property (readonly) ALAssetsLibrary *photoLibrary;
@property (nonatomic, assign) TunnelMode tunnelMode;
@property (readonly) NSString* contactSipField;
@property (readonly,copy) NSString* contactFilter;
@property (copy) void (^silentPushCompletion)(UIBackgroundFetchResult);
@property (readonly) BOOL wasRemoteProvisioned;
@property (readonly) SpConfig *configDb;

@end

