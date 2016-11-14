
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

#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <sys/sysctl.h>

#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioToolbox.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTCallCenter.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import "SephoneManager.h"


#include "sephone/sephonecore_utils.h"
#include "sephone/spconfig.h"
#include "mediastreamer2/mscommon.h"

#import "SephoneIOSVersion.h"

#import <AVFoundation/AVAudioPlayer.h>

#define SEPHONE_LOGS_MAX_ENTRY 5000

static void audioRouteChangeListenerCallback (
											  void                   *inUserData,                                 // 1
											  AudioSessionPropertyID inPropertyID,                                // 2
											  UInt32                 inPropertyValueSize,                         // 3
											  const void             *inPropertyValue                             // 4
											  );
static SephoneCore* theSephoneCore = nil;
static SephoneManager* theSephoneManager = nil;

const char *const SEPHONERC_APPLICATION_KEY = "app";

NSString *const kSephoneCoreUpdate = @"SephoneCoreUpdate";
NSString *const kSephoneDisplayStatusUpdate = @"SephoneDisplayStatusUpdate";
NSString *const kSephoneTextReceived = @"SephoneTextReceived";
NSString *const kSephoneTextComposeEvent = @"SephoneTextComposeStarted";
NSString *const kSephoneCallUpdate = @"SephoneCallUpdate";
NSString *const kSephoneRegistrationUpdate = @"SephoneRegistrationUpdate";
NSString *const kSephoneAddressBookUpdate = @"SephoneAddressBookUpdate";
NSString *const kSephoneMainViewChange = @"SephoneMainViewChange";
NSString *const kSephoneLogsUpdate = @"SephoneLogsUpdate";
NSString *const kSephoneSettingsUpdate = @"SephoneSettingsUpdate";
NSString *const kSephoneBluetoothAvailabilityUpdate = @"SephoneBluetoothAvailabilityUpdate";
NSString *const kSephoneConfiguringStateUpdate = @"SephoneConfiguringStateUpdate";
NSString *const kSephoneGlobalStateUpdate = @"SephoneGlobalStateUpdate";
NSString *const kSephoneNotifyReceived = @"SephoneNotifyReceived";


const int kSephoneAudioVbrCodecDefaultBitrate=36; /*you can override this from sephonerc or sephonerc-factory*/

extern void libmsilbc_init(void);
extern void libmsamr_init(void);
extern void libmsx264_init(void);
extern void libmsopenh264_init(void);
extern void libmssilk_init(void);
extern void libmsbcg729_init(void);

#define FRONT_CAM_NAME "AV Capture: com.apple.avfoundation.avcapturedevice.built-in_video:1" /*"AV Capture: Front Camera"*/
#define BACK_CAM_NAME "AV Capture: com.apple.avfoundation.avcapturedevice.built-in_video:0" /*"AV Capture: Back Camera"*/


NSString *const kSephoneOldChatDBFilename      = @"chat_database.sqlite";
NSString *const kSephoneInternalChatDBFilename = @"sephone_chats.db";

@implementation SephoneCallAppData
- (id)init {
	if ((self = [super init])) {
		self->batteryWarningShown = FALSE;
		self->notification = nil;
		self->videoRequested = FALSE;
		self->userInfos = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc {
	[self->userInfos release];
	[super dealloc];
}
@end


@interface SephoneManager ()
@property (retain, nonatomic) AVAudioPlayer* messagePlayer;
@end

@implementation SephoneManager

@synthesize connectivity;
@synthesize network;
@synthesize frontCamId;
@synthesize backCamId;
@synthesize database;
@synthesize pushNotificationToken;
@synthesize sounds;
@synthesize logs;
@synthesize speakerEnabled;
@synthesize bluetoothAvailable;
@synthesize bluetoothEnabled;
@synthesize photoLibrary;
@synthesize tunnelMode;
@synthesize silentPushCompletion;
@synthesize wasRemoteProvisioned;
@synthesize configDb;

struct codec_name_pref_table{
	const char *name;
	int rate;
	NSString *prefname;
};

struct codec_name_pref_table codec_pref_table[]={
	{ "speex", 8000, @"speex_8k_preference" },
	{ "speex", 16000, @"speex_16k_preference" },
	{ "silk", 24000, @"silk_24k_preference" },
	{ "silk", 16000, @"silk_16k_preference" },
	{ "amr", 8000, @"amr_preference" },
	{ "gsm", 8000, @"gsm_preference" },
	{ "ilbc", 8000, @"ilbc_preference"},
	{ "pcmu", 8000, @"pcmu_preference"},
	{ "pcma", 8000, @"pcma_preference"},
	{ "g722", 8000, @"g722_preference"},
	{ "g729", 8000, @"g729_preference"},
	{ "mp4v-es", 90000, @"mp4v-es_preference"},
	{ "h264", 90000, @"h264_preference"},
	{ "vp8", 90000, @"vp8_preference"},
    { "mpeg4-generic", 16000, @"aaceld_16k_preference"},
    { "mpeg4-generic", 22050, @"aaceld_22k_preference"},
    { "mpeg4-generic", 32000, @"aaceld_32k_preference"},
    { "mpeg4-generic", 44100, @"aaceld_44k_preference"},
	{ "mpeg4-generic", 48000, @"aaceld_48k_preference"},
	{ "opus", 48000, @"opus_preference"},
	{ NULL,0,Nil }
};

+ (NSString *)getPreferenceForCodec: (const char*) name withRate: (int) rate{
	int i;
	for(i=0;codec_pref_table[i].name!=NULL;++i){
		if (strcasecmp(codec_pref_table[i].name,name)==0 && codec_pref_table[i].rate==rate)
			return codec_pref_table[i].prefname;
	}
	return Nil;
}

+ (NSSet *)unsupportedCodecs {
	NSMutableSet *set = [NSMutableSet set];
	for(int i=0;codec_pref_table[i].name!=NULL;++i) {
		PayloadType* available = sephone_core_find_payload_type(theSephoneCore,
																 codec_pref_table[i].name,
																 codec_pref_table[i].rate,
																 SEPHONE_FIND_PAYLOAD_IGNORE_CHANNELS);
		if( (available == NULL)
		   // these two codecs should not be hidden, even if not supported
		   && ![codec_pref_table[i].prefname isEqualToString:@"h264_preference"]
		   && ![codec_pref_table[i].prefname isEqualToString:@"mp4v-es_preference"]
		   )
		{
			[set addObject:codec_pref_table[i].prefname];
		}
	}
	return set;
}

+ (BOOL)isCodecSupported: (const char *)codecName {
	return (codecName != NULL) &&
	(NULL != sephone_core_find_payload_type(theSephoneCore, codecName,
											 SEPHONE_FIND_PAYLOAD_IGNORE_RATE,
											 SEPHONE_FIND_PAYLOAD_IGNORE_CHANNELS));
}

+ (BOOL)runningOnIpad {
#ifdef UI_USER_INTERFACE_IDIOM
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
	return NO;
#endif
}

+ (BOOL)isRunningTests {
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *injectBundle = environment[@"XCInjectBundle"];
    return [[injectBundle pathExtension] isEqualToString:@"xctest"];
}

+ (BOOL)isNotIphone3G
{
	static BOOL done=FALSE;
	static BOOL result;
	if (!done){
		size_t size;
		sysctlbyname("hw.machine", NULL, &size, NULL, 0);
		char *machine = malloc(size);
		sysctlbyname("hw.machine", machine, &size, NULL, 0);
		NSString *platform = [[NSString alloc ] initWithUTF8String:machine];
		free(machine);

		result = ![platform isEqualToString:@"iPhone1,2"];

		[platform release];
		done=TRUE;
	}
	return result;
}

+ (NSString *)getUserAgent {
	return [NSString stringWithFormat:@"SephoneIphone/%@ (Sephone/%s; Apple %@/%@)",
			[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey],
			sephone_core_get_version(),
			[UIDevice currentDevice].systemName,
			[UIDevice currentDevice].systemVersion];
}

+ (SephoneManager*)instance {
	if(theSephoneManager == nil) {
		theSephoneManager = [SephoneManager alloc];
		[theSephoneManager init];
	}
	return theSephoneManager;
}

#ifdef DEBUG
+ (void)instanceRelease {
	if(theSephoneManager != nil) {
		[theSephoneManager release];
		theSephoneManager = nil;
	}
}
#endif

+ (BOOL)langageDirectionIsRTL {
    static NSLocaleLanguageDirection dir = NSLocaleLanguageDirectionLeftToRight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dir = [NSLocale characterDirectionForLanguage:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]];
    });
    return dir == NSLocaleLanguageDirectionRightToLeft;
}

#pragma mark - Lifecycle Functions

- (id)init {
	if ((self = [super init])) {
		AudioSessionInitialize(NULL, NULL, NULL, NULL);
		OSStatus lStatus = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback, self);
		if (lStatus) {
			[SephoneLogger logc:SephoneLoggerError format:"cannot register route change handler [%ld]",lStatus];
		}


        NSString *path = [[NSBundle mainBundle] pathForResource:@"msg" ofType:@"wav"];
        self.messagePlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:path] error:nil] autorelease];

        sounds.vibrate = kSystemSoundID_Vibrate;

        logs = [[NSMutableArray alloc] init];
		database = NULL;
		speakerEnabled = FALSE;
		bluetoothEnabled = FALSE;
		tunnelMode = FALSE;
		[self copyDefaultSettings];
		pushCallIDs = [[NSMutableArray alloc] init ];
		photoLibrary = [[ALAssetsLibrary alloc] init];
        self->_isTesting = [SephoneManager isRunningTests];

		NSString* factoryConfig = [SephoneManager bundleFile:[SephoneManager runningOnIpad]?@"sephonerc-factory~ipad":@"sephonerc-factory"];
		NSString *confiFileName = [SephoneManager documentFile:@".sephonerc"];
		configDb=sp_config_new_with_factory([confiFileName cStringUsingEncoding:[NSString defaultCStringEncoding]] , [factoryConfig cStringUsingEncoding:[NSString defaultCStringEncoding]]);

		//set default values for first boot
		if (sp_config_get_string(configDb,SEPHONERC_APPLICATION_KEY,"debugenable_preference",NULL)==NULL){
#ifdef DEBUG
			[self spConfigSetBool:TRUE forKey:@"debugenable_preference"];
#else
			[self spConfigSetBool:FALSE forKey:@"debugenable_preference"];
#endif
		}

		[self migrateFromUserPrefs];
	}
	return self;
}

- (void)dealloc {
	[logs release];

	OSStatus lStatus = AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback, self);
	if (lStatus) {
		[SephoneLogger logc:SephoneLoggerError format:"cannot un register route change handler [%ld]", lStatus];
	}

	[[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kSephoneGlobalStateUpdate];
	[[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kSephoneConfiguringStateUpdate];


	[photoLibrary release];
	[pushCallIDs release];
	[super dealloc];
}

- (void)silentPushFailed:(NSTimer*)timer
{
	if( silentPushCompletion ){
		[SephoneLogger log:SephoneLoggerLog format:@"silentPush failed, silentPushCompletion block: %p", silentPushCompletion ];
		silentPushCompletion(UIBackgroundFetchResultNoData);
		silentPushCompletion = nil;
	}
}

#pragma mark - Database Functions

static int check_should_migrate_images(void* data ,int argc,char** argv,char** cnames){
	*((BOOL*)data) = TRUE;
	return 0;
}

- (BOOL)migrateChatDBIfNeeded:(SephoneCore*)lc {
	sqlite3* newDb;
	char *errMsg;
	NSError* error;
	NSString *oldDbPath = [SephoneManager documentFile:kSephoneOldChatDBFilename];
	NSString *newDbPath = [SephoneManager documentFile:kSephoneInternalChatDBFilename];
	BOOL shouldMigrate  = [[NSFileManager defaultManager] fileExistsAtPath:oldDbPath];
	BOOL shouldMigrateImages = FALSE;
	SephoneProxyConfig* default_proxy;
	const char* identity = NULL;
	BOOL migrated = FALSE;
	char* attach_stmt = NULL;

	sephone_core_get_default_proxy(lc, &default_proxy);


	if( sqlite3_open([newDbPath UTF8String], &newDb) != SQLITE_OK) {
		[SephoneLogger log:SephoneLoggerError format:@"Can't open \"%@\" sqlite3 database.", newDbPath];
		return FALSE;
	}

	const char* check_appdata = "SELECT url,message FROM history WHERE url LIKE 'assets-library%' OR message LIKE 'assets-library%' LIMIT 1;";
	// will set "needToMigrateImages to TRUE if a result comes by
	sqlite3_exec(newDb, check_appdata, check_should_migrate_images, &shouldMigrateImages, NULL);
	if( !shouldMigrate && !shouldMigrateImages ) {
		sqlite3_close(newDb);
		return FALSE;
	}


	[SephoneLogger logc:SephoneLoggerLog format:"Starting migration procedure"];

	if( shouldMigrate ){

		// attach old database to the new one:
		attach_stmt = sqlite3_mprintf("ATTACH DATABASE %Q AS oldchats", [oldDbPath UTF8String]);
		if( sqlite3_exec(newDb, attach_stmt, NULL, NULL, &errMsg) != SQLITE_OK ){
			[SephoneLogger logc:SephoneLoggerError format:"Can't attach old chat table, error[%s] ", errMsg];
			sqlite3_free(errMsg);
			goto exit_dbmigration;
		}


		// migrate old chats to the new db. The iOS stores timestamp in UTC already, so we can directly put it in the 'utc' field and set 'time' to -1
		const char* migration_statement = "INSERT INTO history (localContact,remoteContact,direction,message,utc,read,status,time) "
		"SELECT localContact,remoteContact,direction,message,time,read,state,'-1' FROM oldchats.chat";

		if( sqlite3_exec(newDb, migration_statement, NULL, NULL, &errMsg) != SQLITE_OK ){
			[SephoneLogger logc:SephoneLoggerError format:"DB migration failed, error[%s] ", errMsg];
			sqlite3_free(errMsg);
			goto exit_dbmigration;
		}

		// invert direction of old messages, because iOS was storing the direction flag incorrectly
		const char* invert_direction = "UPDATE history SET direction = NOT direction";
		if( sqlite3_exec(newDb, invert_direction, NULL, NULL, &errMsg) != SQLITE_OK){
			[SephoneLogger log: SephoneLoggerError format:@"Inverting direction failed, error[%s]", errMsg];
			sqlite3_free(errMsg);
			goto exit_dbmigration;
		}

		// replace empty from: or to: by the current identity.
		if( default_proxy ){
			identity = sephone_proxy_config_get_identity(default_proxy);
		}
		if( !identity ){
			identity = "sip:unknown@sip.sego-phone.org";
		}

		char* from_conversion = sqlite3_mprintf("UPDATE history SET localContact = %Q WHERE localContact = ''", identity);
		if( sqlite3_exec(newDb, from_conversion, NULL, NULL, &errMsg) != SQLITE_OK ){
			[SephoneLogger logc:SephoneLoggerError format:"FROM conversion failed, error[%s] ", errMsg];
			sqlite3_free(errMsg);
		}
		sqlite3_free(from_conversion);

		char* to_conversion = sqlite3_mprintf("UPDATE history SET remoteContact = %Q WHERE remoteContact = ''", identity);
		if( sqlite3_exec(newDb, to_conversion, NULL, NULL, &errMsg) != SQLITE_OK ){
			[SephoneLogger logc:SephoneLoggerError format:"DB migration failed, error[%s] ", errMsg];
			sqlite3_free(errMsg);
		}
		sqlite3_free(to_conversion);

	}

	// local image paths were stored in the 'message' field historically. They were
	// very temporarily stored in the 'url' field, and now we migrated them to a JSON-
	// encoded field. These are the migration steps to migrate them.

	// move already stored images from the messages to the appdata JSON field
	const char* assetslib_migration = "UPDATE history SET appdata='{\"localimage\":\"'||message||'\"}' , message='' WHERE message LIKE 'assets-library%'";
	if( sqlite3_exec(newDb, assetslib_migration, NULL, NULL, &errMsg) != SQLITE_OK ){
		[SephoneLogger logc:SephoneLoggerError format:"Assets-history migration for MESSAGE failed, error[%s] ", errMsg];
		sqlite3_free(errMsg);
	}

	// move already stored images from the url to the appdata JSON field
	const char* assetslib_migration_fromurl = "UPDATE history SET appdata='{\"localimage\":\"'||url||'\"}' , url='' WHERE url LIKE 'assets-library%'";
	if( sqlite3_exec(newDb, assetslib_migration_fromurl, NULL, NULL, &errMsg) != SQLITE_OK ){
		[SephoneLogger logc:SephoneLoggerError format:"Assets-history migration for URL failed, error[%s] ", errMsg];
		sqlite3_free(errMsg);
	}

	// We will lose received messages with remote url, they will be displayed in plain. We can't do much for them..
	migrated = TRUE;

exit_dbmigration:

	if( attach_stmt ) sqlite3_free(attach_stmt);

	sqlite3_close(newDb);

	// in any case, we should remove the old chat db
	if( shouldMigrate && ![[NSFileManager defaultManager] removeItemAtPath:oldDbPath error:&error] ){
		[SephoneLogger logc:SephoneLoggerError format:"Could not remove old chat DB: %@", error];
	}

	[SephoneLogger log:SephoneLoggerLog format:@"Message storage migration finished: success = %@", migrated ? @"TRUE":@"FALSE"];
	return migrated;
}

- (void)migrateFromUserPrefs {
	static const char* migration_flag = "userpref_migration_done";

	if( configDb == nil ) return;

	if( sp_config_get_int(configDb, SEPHONERC_APPLICATION_KEY, migration_flag, 0) ){
		LOGI(@"UserPrefs migration already performed, skip");
		return;
	}

	NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
	NSArray* defaults_keys = [defaults allKeys];
	NSDictionary* values   = @{@"backgroundmode_preference" :@YES,
							   @"debugenable_preference"    :@NO,
							   @"start_at_boot_preference"  :@YES};
	BOOL shouldSync        = FALSE;

	LOGI(@"%lu user prefs", (unsigned long)[defaults_keys count]);

	for( NSString* userpref in values ){
		if( [defaults_keys containsObject:userpref] ){
			LOGI(@"Migrating %@ from user preferences: %d", userpref, [[defaults objectForKey:userpref] boolValue]);
			sp_config_set_int(configDb, SEPHONERC_APPLICATION_KEY, [userpref UTF8String], [[defaults objectForKey:userpref] boolValue]);
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:userpref];
			shouldSync = TRUE;
		} else if ( sp_config_get_string(configDb, SEPHONERC_APPLICATION_KEY, [userpref UTF8String], NULL) == NULL ){
			// no default value found in our sephonerc, we need to add them
			sp_config_set_int(configDb, SEPHONERC_APPLICATION_KEY, [userpref UTF8String], [[values objectForKey:userpref] boolValue]);
		}
	}

	if( shouldSync ){
		LOGI(@"Synchronizing...");
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	// don't get back here in the future
	sp_config_set_int(configDb, SEPHONERC_APPLICATION_KEY, migration_flag, 1);
}


#pragma mark - Sephone Core Functions

+ (SephoneCore*)getLc {
	if (theSephoneCore==nil) {
		@throw([NSException exceptionWithName:@"SephoneCoreException" reason:@"Sephone core not initialized yet" userInfo:nil]);
	}
	return theSephoneCore;
}

+ (BOOL)isLcReady {
	return theSephoneCore != nil;
}

#pragma mark Debug functions

struct _entry_data {
	const SpConfig* conf;
	const char* section;
};

static void dump_entry(const char* entry, void*data) {
	struct _entry_data *d = (struct _entry_data*)data;
	const char* value = sp_config_get_string(d->conf, d->section, entry, "");
	[SephoneLogger log:SephoneLoggerLog format:@"%s=%s", entry, value];
}

static void dump_section(const char* section, void* data){
	[SephoneLogger log:SephoneLoggerLog format:@"[%s]", section ];
	struct _entry_data d = {(const SpConfig*)data, section};
	sp_config_for_each_entry((const SpConfig*)data, section, dump_entry, &d);
}

+ (void)dumpLCConfig {
	if (theSephoneCore ){
		SpConfig *conf=[SephoneManager instance].configDb;
		sp_config_for_each_section(conf, dump_section, conf);
	}
}


#pragma mark - Logs Functions

//generic log handler for debug version
void sephone_iphone_log_handler(int lev, const char *fmt, va_list args){
	NSString* format = [[NSString alloc] initWithUTF8String:fmt];
	NSLogv(format, args);
//	NSString* formatedString = [[NSString alloc] initWithFormat:format arguments:args];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if([[SephoneManager instance].logs count] >= SEPHONE_LOGS_MAX_ENTRY) {
//            [[SephoneManager instance].logs removeObjectAtIndex:0];
//        }
//        [[SephoneManager instance].logs addObject:formatedString];
//
//        // Post event
//        NSDictionary *dict = [NSDictionary dictionaryWithObject:formatedString forKey:@"log"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kSephoneLogsUpdate object:[SephoneManager instance] userInfo:dict];
//    });
//
//	[formatedString release];
	[format release];
}

//Error/warning log handler
static void sephone_iphone_log(struct _SephoneCore * lc, const char * message) {
	NSString* log = [NSString stringWithCString:message encoding:[NSString defaultCStringEncoding]];
	NSLog(log, NULL);

//    dispatch_async(dispatch_get_main_queue(), ^{
//        if([[SephoneManager instance].logs count] >= SEPHONE_LOGS_MAX_ENTRY) {
//            [[SephoneManager instance].logs removeObjectAtIndex:0];
//        }
//        [[SephoneManager instance].logs addObject:log];
//
//        // Post event
//        NSDictionary *dict = [NSDictionary dictionaryWithObject:log forKey:@"log"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kSephoneLogsUpdate object:[SephoneManager instance] userInfo:dict];
//    });
}


#pragma mark - Display Status Functions

- (void)displayStatus:(NSString*) message {
	// Post event
    [[NSNotificationCenter defaultCenter] postNotificationName:kSephoneDisplayStatusUpdate
                                                        object:self
                                                      userInfo:@{@"message":message}];
}


static void sephone_iphone_display_status(struct _SephoneCore * lc, const char * message) {
	NSString* status = [[NSString alloc] initWithCString:message encoding:[NSString defaultCStringEncoding]];
	[(SephoneManager*)sephone_core_get_user_data(lc)  displayStatus:status];
	[status release];
}


#pragma mark - Call State Functions

- (void)localNotifContinue:(NSTimer*) timer {
	UILocalNotification* notif = [timer userInfo];
	if (notif){
		[SephoneLogger log:SephoneLoggerLog format:@"cancelling/presenting local notif"];
		[[UIApplication sharedApplication] cancelLocalNotification:notif];
		[[UIApplication sharedApplication] presentLocalNotificationNow:notif];
	}
}

- (void)onCall:(SephoneCall*)call StateChanged:(SephoneCallState)state withMessage:(const char *)message {

	// Handling wrapper
	SephoneCallAppData* data=(SephoneCallAppData*)sephone_call_get_user_pointer(call);
	if (!data) {
		data = [[SephoneCallAppData alloc] init];
		sephone_call_set_user_pointer(call, data);
	}

	if (silentPushCompletion) {

		// we were woken up by a silent push. Call the completion handler with NEWDATA
		// so that the push is notified to the user
		[SephoneLogger log:SephoneLoggerLog format:@"onCall - handler %p", silentPushCompletion];
		silentPushCompletion(UIBackgroundFetchResultNewData);
		silentPushCompletion = nil;
	}

	const SephoneAddress *addr = sephone_call_get_remote_address(call);
	NSString* address = nil;
	if(addr != NULL) {
		BOOL useSephoneAddress = true;
		// contact name
//		char* lAddress = sephone_address_as_string_uri_only(addr);
//		if(lAddress) {
//			NSString *normalizedSipAddress = [FastAddressBook normalizeSipURI:[NSString stringWithUTF8String:lAddress]];
//			ABRecordRef contact = [fastAddressBook getContact:normalizedSipAddress];
//			if(contact) {
//				address = [FastAddressBook getContactDisplayName:contact];
//				useSephoneAddress = false;
//			}
//			ms_free(lAddress);
//		}
		if(useSephoneAddress) {
			const char* lDisplayName = sephone_address_get_display_name(addr);
			const char* lUserName = sephone_address_get_username(addr);
			if (lDisplayName)
				address = [NSString stringWithUTF8String:lDisplayName];
			else if(lUserName)
				address = [NSString stringWithUTF8String:lUserName];
		}
	}
	if(address == nil) {
		address = NSLocalizedString(@"Unknown", nil);
	}

	if (state == SephoneCallIncomingReceived) {

		/*first step is to re-enable ctcall center*/
		CTCallCenter* lCTCallCenter = [[CTCallCenter alloc] init];

		/*should we reject this call ?*/
		if ([lCTCallCenter currentCalls]!=nil) {
			char *tmp=sephone_call_get_remote_address_as_string(call);
			if (tmp) {
				[SephoneLogger logc:SephoneLoggerLog format:"Mobile call ongoing... rejecting call from [%s]",tmp];
				ms_free(tmp);
			}
			sephone_core_decline_call(theSephoneCore, call,SephoneReasonBusy);
			[lCTCallCenter release];
			return;
		}
		[lCTCallCenter release];

		if(	[UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {

			SephoneCallLog* callLog=sephone_call_get_call_log(call);
			NSString* callId=[NSString stringWithUTF8String:sephone_call_log_get_call_id(callLog)];

			if (![[SephoneManager instance] popPushCallID:callId]){
				// case where a remote notification is not already received
				// Create a new local notification
				data->notification = [[UILocalNotification alloc] init];
				if (data->notification) {

                    // iOS8 doesn't need the timer trick for the local notification.
                    if( [[UIDevice currentDevice].systemVersion floatValue] >= 8){
                        data->notification.soundName = @"ring.caf";
                        data->notification.category = @"incoming_call";
                    } else {
                        data->notification.soundName = @"shortring.caf";
                        data->timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(localNotifContinue:) userInfo:data->notification repeats:TRUE];
                    }

					data->notification.repeatInterval = 0;

					data->notification.alertBody =[NSString  stringWithFormat:NSLocalizedString(@"IC_MSG",nil), address];
					data->notification.alertAction = NSLocalizedString(@"Answer", nil);
					data->notification.userInfo = @{@"callId": callId, @"timer":[NSNumber numberWithInt:1] };
					data->notification.applicationIconBadgeNumber = 1;

					[[UIApplication sharedApplication] presentLocalNotificationNow:data->notification];

					if (!incallBgTask){
						incallBgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler: ^{
							[SephoneLogger log:SephoneLoggerWarning format:@"Call cannot ring any more, too late"];
							[[UIApplication sharedApplication] endBackgroundTask:incallBgTask];
							incallBgTask=0;
						}];

                        if( data->timer ){
                            [[NSRunLoop currentRunLoop] addTimer:data->timer forMode:NSRunLoopCommonModes];
                        }
					}

				}
			}
		}
	}

	// we keep the speaker auto-enabled state in this static so that we don't
	// force-enable it on ICE re-invite if the user disabled it.
	static BOOL speaker_already_enabled = FALSE;

	// Disable speaker when no more call
	if ((state == SephoneCallEnd || state == SephoneCallError)) {
		speaker_already_enabled = FALSE;
		if(sephone_core_get_calls_nb(theSephoneCore) == 0) {
			[self setSpeakerEnabled:FALSE];
			[self removeCTCallCenterCb];
			bluetoothAvailable = FALSE;
			bluetoothEnabled = FALSE;
			/*IOS specific*/
			sephone_core_start_dtmf_stream(theSephoneCore);
		}
		if (incallBgTask) {
			[[UIApplication sharedApplication]  endBackgroundTask:incallBgTask];
			incallBgTask=0;
		}
		if(data != nil && data->notification != nil) {
			SephoneCallLog *log = sephone_call_get_call_log(call);

			// cancel local notif if needed
			if( data->timer ){
				[data->timer invalidate];
				data->timer = nil;
			}
			[[UIApplication sharedApplication] cancelLocalNotification:data->notification];

			[data->notification release];
			data->notification = nil;

			if(log == NULL || sephone_call_log_get_status(log) == SephoneCallMissed) {
				UILocalNotification *notification = [[UILocalNotification alloc] init];
				notification.repeatInterval = 0;
				notification.alertBody =  [NSString stringWithFormat:NSLocalizedString(@"You missed a call from %@", nil), address];
				notification.alertAction = NSLocalizedString(@"Show", nil);
				notification.userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithUTF8String:sephone_call_log_get_call_id(log)] forKey:@"callLog"];
				[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
				[notification release];
			}

		}
	}

	if(state == SephoneCallReleased) {
		if(data != NULL) {
			[data release];
			sephone_call_set_user_pointer(call, NULL);
		}
	}

	// Enable speaker when video
	if(state == SephoneCallIncomingReceived ||
	   state == SephoneCallOutgoingInit ||
	   state == SephoneCallConnected ||
	   state == SephoneCallStreamsRunning) {
		if (sephone_call_params_video_enabled(sephone_call_get_current_params(call)) && !speaker_already_enabled) {
			[self setSpeakerEnabled:TRUE];
			speaker_already_enabled = TRUE;
		}
	}

	if (state == SephoneCallConnected && !mCallCenter) {
		/*only register CT call center CB for connected call*/
		[self setupGSMInteraction];
	}

	// Post event
    NSDictionary* dict = @{@"call":   [NSValue valueWithPointer:call],
                           @"state":  [NSNumber numberWithInt:state],
                           @"message":[NSString stringWithUTF8String:message]};
	[[NSNotificationCenter defaultCenter] postNotificationName:kSephoneCallUpdate object:self userInfo:dict];
}

static void sephone_iphone_call_state(SephoneCore *lc, SephoneCall* call, SephoneCallState state,const char* message) {
	[(SephoneManager*)sephone_core_get_user_data(lc) onCall:call StateChanged: state withMessage:  message];
}


#pragma mark - Transfert State Functions

static void sephone_iphone_transfer_state_changed(SephoneCore* lc, SephoneCall* call, SephoneCallState state) {
}

#pragma mark - Global state change

static void sephone_iphone_global_state_changed(SephoneCore *lc, SephoneGlobalState gstate, const char *message) {
	[(SephoneManager*)sephone_core_get_user_data(lc) onGlobalStateChanged:gstate withMessage:message];
}

-(void)onGlobalStateChanged:(SephoneGlobalState)state withMessage:(const char*)message {
	[SephoneLogger log:SephoneLoggerLog format:@"onGlobalStateChanged: %d (message: %s)", state, message];

	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSNumber numberWithInt:state], @"state",
						  [NSString stringWithUTF8String:message?message:""], @"message",
						  nil];

	// dispatch the notification asynchronously
	dispatch_async(dispatch_get_main_queue(), ^(void){
		[[NSNotificationCenter defaultCenter] postNotificationName:kSephoneGlobalStateUpdate object:self userInfo:dict];
	});
}


-(void)globalStateChangedNotificationHandler:(NSNotification*)notif {
	if( (SephoneGlobalState)[[[notif userInfo] valueForKey:@"state"] integerValue] == SephoneGlobalOn){
		[self finishCoreConfiguration];
	}
}


#pragma mark - Configuring status changed

static void sephone_iphone_configuring_status_changed(SephoneCore *lc, SephoneConfiguringState status, const char *message) {
	[(SephoneManager*)sephone_core_get_user_data(lc) onConfiguringStatusChanged:status withMessage:message];
}

-(void)onConfiguringStatusChanged:(SephoneConfiguringState)status withMessage:(const char*)message {
	[SephoneLogger log:SephoneLoggerLog format:@"onConfiguringStatusChanged: %d (message: %s)", status, message];

	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSNumber numberWithInt:status], @"state",
						  [NSString stringWithUTF8String:message?message:""], @"message",
						  nil];

	// dispatch the notification asynchronously
	dispatch_async(dispatch_get_main_queue(), ^(void){
		[[NSNotificationCenter defaultCenter] postNotificationName:kSephoneConfiguringStateUpdate object:self userInfo:dict];
	});
}


-(void)configuringStateChangedNotificationHandler:(NSNotification*)notif {
	if( (SephoneConfiguringState)[[[notif userInfo] valueForKey:@"state"] integerValue] == SephoneConfiguringSuccessful){
		wasRemoteProvisioned = TRUE;
	} else {
		wasRemoteProvisioned = FALSE;
	}
}


#pragma mark - Registration State Functions

- (void)onRegister:(SephoneCore *)lc cfg:(SephoneProxyConfig*) cfg state:(SephoneRegistrationState) state message:(const char*) message {
	[SephoneLogger logc:SephoneLoggerLog format:"NEW REGISTRATION STATE: '%s' (message: '%s')", sephone_registration_state_to_string(state), message];

	// Post event
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSNumber numberWithInt:state], @"state",
						  [NSValue valueWithPointer:cfg], @"cfg",
						  [NSString stringWithUTF8String:message], @"message",
						  nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kSephoneRegistrationUpdate object:self userInfo:dict];
}

static void sephone_iphone_registration_state(SephoneCore *lc, SephoneProxyConfig* cfg, SephoneRegistrationState state,const char* message) {
	[(SephoneManager*)sephone_core_get_user_data(lc) onRegister:lc cfg:cfg state:state message:message];
}


#pragma mark - Text Received Functions

- (void)onMessageReceived:(SephoneCore *)lc room:(SephoneChatRoom *)room  message:(SephoneChatMessage*)msg {

	if (silentPushCompletion) {

		// we were woken up by a silent push. Call the completion handler with NEWDATA
		// so that the push is notified to the user
		[SephoneLogger log:SephoneLoggerLog format:@"onMessageReceived - handler %p", silentPushCompletion];
		silentPushCompletion(UIBackgroundFetchResultNewData);
		silentPushCompletion = nil;
	}
    const SephoneAddress* remoteAddress = sephone_chat_message_get_from_address(msg);
    char* c_address                      = sephone_address_as_string_uri_only(remoteAddress);
    NSString* address                    = [NSString stringWithUTF8String:c_address];
    NSString* remote_uri                 = [NSString stringWithUTF8String:c_address];
    const char* call_id                  = sephone_chat_message_get_custom_header(msg, "Call-ID");
    NSString* callID                     = [NSString stringWithUTF8String:call_id];

	ms_free(c_address);

	if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {

//		ABRecordRef contact = [fastAddressBook getContact:address];
//		if(contact) {
//			address = [FastAddressBook getContactDisplayName:contact];
//		} else {
			if ([[SephoneManager instance] spConfigBoolForKey:@"show_contacts_emails_preference"] == true) {
				SephoneAddress *sephoneAddress = sephone_address_new([address cStringUsingEncoding:[NSString defaultCStringEncoding]]);
				address = [NSString stringWithUTF8String:sephone_address_get_username(sephoneAddress)];
				sephone_address_destroy(sephoneAddress);
			}
//		}
		if(address == nil) {
			address = NSLocalizedString(@"Unknown", nil);
		}

		// Create a new notification
		UILocalNotification* notif = [[[UILocalNotification alloc] init] autorelease];
		if (notif) {
			notif.repeatInterval = 0;
            if( [[UIDevice currentDevice].systemVersion floatValue] >= 8){
                notif.category       = @"incoming_msg";
            }
			notif.alertBody      = [NSString  stringWithFormat:NSLocalizedString(@"IM_MSG",nil), address];
			notif.alertAction    = NSLocalizedString(@"Show", nil);
			notif.soundName      = @"msg.caf";
			notif.userInfo       = @{@"from":address, @"from_addr":remote_uri, @"call-id":callID};

			[[UIApplication sharedApplication] presentLocalNotificationNow:notif];
		}
	}

	// Post event
	NSDictionary* dict = @{@"room"        :[NSValue valueWithPointer:room],
						   @"from_address":[NSValue valueWithPointer:sephone_chat_message_get_from_address(msg)],
						   @"message"     :[NSValue valueWithPointer:msg],
						   @"call-id"     : callID};

	[[NSNotificationCenter defaultCenter] postNotificationName:kSephoneTextReceived object:self userInfo:dict];
}

static void sephone_iphone_message_received(SephoneCore *lc, SephoneChatRoom *room, SephoneChatMessage *message) {
	[(SephoneManager*)sephone_core_get_user_data(lc) onMessageReceived:lc room:room message:message];
}

- (void)onNotifyReceived:(SephoneCore *)lc event:(SephoneEvent *)lev notifyEvent:(const char *)notified_event content:(const SephoneContent *)body {
	// Post event
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSValue valueWithPointer:lev] forKey:@"event"];
	[dict setObject:[NSString stringWithUTF8String:notified_event] forKey:@"notified_event"];
	if (body != NULL) {
		[dict setObject:[NSValue valueWithPointer:body] forKey:@"content"];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:kSephoneNotifyReceived object:self userInfo:dict];

}

static void sephone_iphone_notify_received(SephoneCore *lc, SephoneEvent *lev, const char *notified_event, const SephoneContent *body) {
	[(SephoneManager*)sephone_core_get_user_data(lc) onNotifyReceived:lc event:lev notifyEvent:notified_event content:body];
}

#pragma mark - Message composition start

- (void)onMessageComposeReceived:(SephoneCore*)core forRoom:(SephoneChatRoom*)room {
	[[NSNotificationCenter defaultCenter] postNotificationName:kSephoneTextComposeEvent
														object:self
													  userInfo:@{@"room":[NSValue valueWithPointer:room]}];
}

static void sephone_iphone_is_composing_received(SephoneCore *lc, SephoneChatRoom *room){
	[(SephoneManager*)sephone_core_get_user_data(lc) onMessageComposeReceived:lc forRoom:room];
}



#pragma mark - Network Functions

- (SCNetworkReachabilityRef) getProxyReachability {
	return proxyReachability;
}

+ (void)kickOffNetworkConnection {
    static BOOL in_progress = FALSE;
    if( in_progress ){
        LOGW(@"Connection kickoff already in progress");
        return;
    }
    in_progress = TRUE;
	/* start a new thread to avoid blocking the main ui in case of peer host failure */
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static int sleep_us = 10000;
        static int timeout_s = 5;
        BOOL timeout_reached = FALSE;
        int loop = 0;
		CFWriteStreamRef writeStream;
		CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.0.200"/*"sego-phone.org"*/, 15000, nil, &writeStream);
		BOOL res = CFWriteStreamOpen (writeStream);
		const char* buff="hello";
        time_t start = time(NULL);
        time_t loop_time;

        if( res == FALSE ){
            LOGI(@"Could not open write stream, backing off");
            CFRelease(writeStream);
            in_progress = FALSE;
            return;
        }

        // check stream status and handle timeout
        CFStreamStatus status = CFWriteStreamGetStatus(writeStream);
        while (status != kCFStreamStatusOpen && status != kCFStreamStatusError ) {
            usleep(sleep_us);
            status = CFWriteStreamGetStatus(writeStream);
            loop_time = time(NULL);
            if( loop_time - start >= timeout_s){
                timeout_reached = TRUE;
                break;
            }
            loop++;
        }


        if (status == kCFStreamStatusOpen ) {
            CFWriteStreamWrite (writeStream,(const UInt8*)buff,strlen(buff));
        } else if( !timeout_reached ){
            CFErrorRef error = CFWriteStreamCopyError(writeStream);
            LOGD(@"CFStreamError: %@", error);
            CFRelease(error);
        } else if( timeout_reached ){
            LOGI(@"CFStream timeout reached");
        }
		CFWriteStreamClose (writeStream);
		CFRelease(writeStream);
        in_progress = FALSE;
	});
}

+ (NSString*)getCurrentWifiSSID {
#if TARGET_IPHONE_SIMULATOR
	return @"Sim_err_SSID_NotSupported";
#else
	NSString *data = nil;
	CFDictionaryRef dict = CNCopyCurrentNetworkInfo((CFStringRef)@"en0");
	if(dict) {
		[SephoneLogger log:SephoneLoggerDebug format:@"AP Wifi: %@", dict];
		data = [NSString stringWithString:(NSString*) CFDictionaryGetValue(dict, @"SSID")];
		CFRelease(dict);
	}
	return data;
#endif
}

static void showNetworkFlags(SCNetworkReachabilityFlags flags){
	[SephoneLogger logc:SephoneLoggerLog format:"Network connection flags:"];
	if (flags==0) [SephoneLogger logc:SephoneLoggerLog format:"no flags."];
	if (flags & kSCNetworkReachabilityFlagsTransientConnection)
		[SephoneLogger logc:SephoneLoggerLog format:"kSCNetworkReachabilityFlagsTransientConnection"];
	if (flags & kSCNetworkReachabilityFlagsReachable)
		[SephoneLogger logc:SephoneLoggerLog format:"kSCNetworkReachabilityFlagsReachable"];
	if (flags & kSCNetworkReachabilityFlagsConnectionRequired)
		[SephoneLogger logc:SephoneLoggerLog format:"kSCNetworkReachabilityFlagsConnectionRequired"];
	if (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)
		[SephoneLogger logc:SephoneLoggerLog format:"kSCNetworkReachabilityFlagsConnectionOnTraffic"];
	if (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)
		[SephoneLogger logc:SephoneLoggerLog format:"kSCNetworkReachabilityFlagsConnectionOnDemand"];
	if (flags & kSCNetworkReachabilityFlagsIsLocalAddress)
		[SephoneLogger logc:SephoneLoggerLog format:"kSCNetworkReachabilityFlagsIsLocalAddress"];
	if (flags & kSCNetworkReachabilityFlagsIsDirect)
		[SephoneLogger logc:SephoneLoggerLog format:"kSCNetworkReachabilityFlagsIsDirect"];
	if (flags & kSCNetworkReachabilityFlagsIsWWAN)
		[SephoneLogger logc:SephoneLoggerLog format:"kSCNetworkReachabilityFlagsIsWWAN"];
}

static void networkReachabilityNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	SephoneManager *mgr = [SephoneManager instance];
	SCNetworkReachabilityFlags flags;

	// for an unknown reason, we are receiving multiple time the notification, so
	// we will skip each time the SSID did not change
	NSString *newSSID = [SephoneManager getCurrentWifiSSID];
	if ([newSSID compare:mgr.SSID] == NSOrderedSame) return;

	mgr.SSID = newSSID;

	if (SCNetworkReachabilityGetFlags([mgr getProxyReachability], &flags)) {
		networkReachabilityCallBack([mgr getProxyReachability],flags,nil);
	}
}

void networkReachabilityCallBack(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* nilCtx){
	showNetworkFlags(flags);
	SephoneManager* lSephoneMgr = [SephoneManager instance];
	SCNetworkReachabilityFlags networkDownFlags=kSCNetworkReachabilityFlagsConnectionRequired |kSCNetworkReachabilityFlagsConnectionOnTraffic | kSCNetworkReachabilityFlagsConnectionOnDemand;

	if (theSephoneCore != nil) {
		SephoneProxyConfig* proxy;
		sephone_core_get_default_proxy(theSephoneCore, &proxy);

		struct NetworkReachabilityContext* ctx = nilCtx ? ((struct NetworkReachabilityContext*)nilCtx) : 0;
		if ((flags == 0) || (flags & networkDownFlags)) {
			sephone_core_set_network_reachable(theSephoneCore, false);
			lSephoneMgr.connectivity = none;
			[SephoneManager kickOffNetworkConnection];
		} else {
			SephoneTunnel *tunnel = sephone_core_get_tunnel([SephoneManager getLc]);
			Connectivity  newConnectivity;
			BOOL isWifiOnly = sp_config_get_int(lSephoneMgr.configDb, SEPHONERC_APPLICATION_KEY, "wifi_only_preference",FALSE);
			if (!ctx || ctx->testWWan)
				newConnectivity = flags & kSCNetworkReachabilityFlagsIsWWAN ? wwan:wifi;
			else
				newConnectivity = wifi;

			if (newConnectivity == wwan
				&& proxy
				&& isWifiOnly
				&& (lSephoneMgr.connectivity == newConnectivity || lSephoneMgr.connectivity == none)) {
				sephone_proxy_config_expires(proxy, 0);
			} else if (proxy){
				NSInteger defaultExpire = [[SephoneManager instance] spConfigIntForKey:@"default_expires"];
				if (defaultExpire>=0)
					sephone_proxy_config_expires(proxy, (int)defaultExpire);
				//else keep default value from sephonecore
			}

			if (lSephoneMgr.connectivity != newConnectivity) {
				if (tunnel) sephone_tunnel_reconnect(tunnel);
				// connectivity has changed
				sephone_core_set_network_reachable(theSephoneCore,false);
				if (newConnectivity == wwan && proxy && isWifiOnly) {
					sephone_proxy_config_expires(proxy, 0);
				}
				sephone_core_set_network_reachable(theSephoneCore,true);
				sephone_core_iterate(theSephoneCore);
				[SephoneLogger logc:SephoneLoggerLog format:"Network connectivity changed to type [%s]",(newConnectivity==wifi?"wifi":"wwan")];
			}
			lSephoneMgr.connectivity=newConnectivity;
			switch (lSephoneMgr.tunnelMode) {
				case tunnel_wwan:
					sephone_tunnel_enable(tunnel,lSephoneMgr.connectivity == wwan);
					break;
				case tunnel_auto:
					sephone_tunnel_auto_detect(tunnel);
					break;
				default:
					//nothing to do
					break;
			}
		}
		if (ctx && ctx->networkStateChanged) {
			(*ctx->networkStateChanged)(lSephoneMgr.connectivity);
		}
	}
}

- (void)setupNetworkReachabilityCallback {
	SCNetworkReachabilityContext *ctx=NULL;
	//any internet cnx
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;

	if (proxyReachability) {
		[SephoneLogger logc:SephoneLoggerLog format:"Cancelling old network reachability"];
		SCNetworkReachabilityUnscheduleFromRunLoop(proxyReachability, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		CFRelease(proxyReachability);
		proxyReachability = nil;
	}

	// This notification is used to detect SSID change (switch of Wifi network). The ReachabilityCallback is
	// not triggered when switching between 2 private Wifi...
	// Since we cannot be sure we were already observer, remove ourself each time... to be improved
	_SSID = [[SephoneManager getCurrentWifiSSID] retain];
	CFNotificationCenterRemoveObserver(
									   CFNotificationCenterGetDarwinNotifyCenter(),
									   self,
									   CFSTR("com.apple.system.config.network_change"),
									   NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
										self,
										networkReachabilityNotification,
										CFSTR("com.apple.system.config.network_change"),
										NULL,
										CFNotificationSuspensionBehaviorDeliverImmediately);

	proxyReachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);

	if (!SCNetworkReachabilitySetCallback(proxyReachability, (SCNetworkReachabilityCallBack)networkReachabilityCallBack, ctx)){
		[SephoneLogger logc:SephoneLoggerError format:"Cannot register reachability cb: %s", SCErrorString(SCError())];
		return;
	}
	if(!SCNetworkReachabilityScheduleWithRunLoop(proxyReachability, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)){
		[SephoneLogger logc:SephoneLoggerError format:"Cannot register schedule reachability cb: %s", SCErrorString(SCError())];
		return;
	}

	// this check is to know network connectivity right now without waiting for a change. Don'nt remove it unless you have good reason. Jehan
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(proxyReachability, &flags)) {
		networkReachabilityCallBack(proxyReachability,flags,nil);
	}
}

- (NetworkType)network {
	if( [[[UIDevice currentDevice] systemVersion] floatValue] < 7 ){
		UIApplication *app = [UIApplication sharedApplication];
		NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"]    subviews];
		NSNumber *dataNetworkItemView = nil;

		for (id subview in subviews) {
			if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
				dataNetworkItemView = subview;
				break;
			}
		}

		NSNumber *number = (NSNumber*)[dataNetworkItemView valueForKey:@"dataNetworkType"];
		return [number intValue];
	} else {
		CTTelephonyNetworkInfo* info = [[CTTelephonyNetworkInfo alloc] init];
		NSString* currentRadio = info.currentRadioAccessTechnology;
		if( [currentRadio isEqualToString:CTRadioAccessTechnologyEdge]){
			return network_2g;
		} else if ([currentRadio isEqualToString:CTRadioAccessTechnologyLTE]){
			return network_4g;
		}
		return network_3g;
	}
}


#pragma mark -

static SephoneCoreVTable sephonec_vtable = {
	.show =NULL,
	.call_state_changed =(SephoneCoreCallStateChangedCb)sephone_iphone_call_state,
	.registration_state_changed = sephone_iphone_registration_state,
	.notify_presence_received=NULL,
	.new_subscription_requested = NULL,
	.auth_info_requested = NULL,
	.display_status = sephone_iphone_display_status,
	.display_message=sephone_iphone_log,
	.display_warning=sephone_iphone_log,
	.display_url=NULL,
	.text_received=NULL,
	.message_received=sephone_iphone_message_received,
	.dtmf_received=NULL,
	.transfer_state_changed=sephone_iphone_transfer_state_changed,
	.is_composing_received = sephone_iphone_is_composing_received,
	.configuring_status = sephone_iphone_configuring_status_changed,
	.global_state_changed = sephone_iphone_global_state_changed,
	.notify_received = sephone_iphone_notify_received,
    .umsg_received = NULL
};

//scheduling loop
- (void)iterate {
	sephone_core_iterate(theSephoneCore);
}

- (void)audioSessionInterrupted:(NSNotification *)notification
{
	int interruptionType = [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
	if (interruptionType == AVAudioSessionInterruptionTypeBegan) {
		[self beginInterruption];
	} else if (interruptionType == AVAudioSessionInterruptionTypeEnded) {
		[self endInterruption];
	}
}

/** Should be called once per sephone_core_new() */
- (void)finishCoreConfiguration {

	//get default config from bundle
	NSString *zrtpSecretsFileName = [SephoneManager documentFile:@"zrtp_secrets"];
	NSString *chatDBFileName      = [SephoneManager documentFile:kSephoneInternalChatDBFilename];
	const char* lRootCa           = [[SephoneManager bundleFile:@"rootca.pem"] cStringUsingEncoding:[NSString defaultCStringEncoding]];

	sephone_core_set_user_agent(theSephoneCore, [[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] stringByAppendingString:@"Iphone"] UTF8String], SEPHONE_IOS_VERSION);

	[_contactSipField release];
	_contactSipField = [[self spConfigStringForKey:@"contact_im_type_value" withDefault:@"SIP"] retain];



	sephone_core_set_root_ca(theSephoneCore, lRootCa);
	// Set audio assets
	const char* lRing = [[SephoneManager bundleFile:@"ring.wav"] cStringUsingEncoding:[NSString defaultCStringEncoding]];
	sephone_core_set_ring(theSephoneCore, lRing);
	const char* lRingBack = [[SephoneManager bundleFile:@"ringback.wav"] cStringUsingEncoding:[NSString defaultCStringEncoding]];
	sephone_core_set_ringback(theSephoneCore, lRingBack);
	const char* lPlay = [[SephoneManager bundleFile:@"hold.wav"] cStringUsingEncoding:[NSString defaultCStringEncoding]];
	sephone_core_set_play_file(theSephoneCore, lPlay);

	sephone_core_set_zrtp_secrets_file(theSephoneCore, [zrtpSecretsFileName cStringUsingEncoding:[NSString defaultCStringEncoding]]);
	sephone_core_set_chat_database_path(theSephoneCore, [chatDBFileName cStringUsingEncoding:[NSString defaultCStringEncoding]]);

	// we need to proceed to the migration *after* the chat database was opened, so that we know it is in consistent state
	BOOL migrated = [self migrateChatDBIfNeeded:theSephoneCore];
	if( migrated ){
		// if a migration was performed, we should reinitialize the chat database
		sephone_core_set_chat_database_path(theSephoneCore, [chatDBFileName cStringUsingEncoding:[NSString defaultCStringEncoding]]);
	}

	/* AVPF migration */
	if( [self spConfigBoolForKey:@"avpf_migration_done" forSection:@"app"] == FALSE ){
		const MSList* proxies = sephone_core_get_proxy_config_list(theSephoneCore);
		while(proxies){
			SephoneProxyConfig* proxy = (SephoneProxyConfig*)proxies->data;
			const char* addr = sephone_proxy_config_get_addr(proxy);
			// we want to enable AVPF for the proxies
			if( addr && strstr(addr, "sip.sego-phone.org") != 0 ){
				LOGI(@"Migrating proxy config to use AVPF");
				sephone_proxy_config_enable_avpf(proxy, TRUE);
			}
			proxies = proxies->next;
		}
		[self spConfigSetBool:TRUE forKey:@"avpf_migration_done"];
	}
	/* Quality Reporting migration */
	if( [self spConfigBoolForKey:@"quality_report_migration_done" forSection:@"app"] == FALSE ){
		const MSList* proxies = sephone_core_get_proxy_config_list(theSephoneCore);
		while(proxies){
			SephoneProxyConfig* proxy = (SephoneProxyConfig*)proxies->data;
			const char* addr = sephone_proxy_config_get_addr(proxy);
			// we want to enable quality reporting for the proxies that are on sego-phone.org
			if( addr && strstr(addr, "sip.sego-phone.org") != 0 ){
				LOGI(@"Migrating proxy config to send quality report");
				sephone_proxy_config_set_quality_reporting_collector(proxy, "sip:voip-metrics@sip.sego-phone.org");
				sephone_proxy_config_set_quality_reporting_interval(proxy, 180);
				sephone_proxy_config_enable_quality_reporting(proxy, TRUE);
			}
			proxies = proxies->next;
		}
		[self spConfigSetBool:TRUE forKey:@"quality_report_migration_done"];
	}

	[self setupNetworkReachabilityCallback];

	NSString* path = [SephoneManager bundleFile:@"nowebcamCIF.jpg"];
	if (path) {
		const char* imagePath = [path cStringUsingEncoding:[NSString defaultCStringEncoding]];
		[SephoneLogger logc:SephoneLoggerLog format:"Using '%s' as source image for no webcam", imagePath];
		sephone_core_set_static_picture(theSephoneCore, imagePath);
	}

	/*DETECT cameras*/
	frontCamId= backCamId=nil;
	char** camlist = (char**)sephone_core_get_video_devices(theSephoneCore);
	for (char* cam = *camlist;*camlist!=NULL;cam=*++camlist) {
		if (strcmp(FRONT_CAM_NAME, cam)==0) {
			frontCamId = cam;
			//great set default cam to front
			sephone_core_set_video_device(theSephoneCore, cam);
		}
		if (strcmp(BACK_CAM_NAME, cam)==0) {
			backCamId = cam;
		}

	}
//        {
//            PayloadType *pt=sephone_core_find_payload_type(theSephoneCore,"vp8",90000,-1);
//            if (pt) {
//                sephone_core_enable_payload_type(theSephoneCore,pt,FALSE);
//            }
//        }
//        {
//            PayloadType *pt=sephone_core_find_payload_type(theSephoneCore,"h264",90000,-1);
//            if (pt) {
//                sephone_core_enable_payload_type(theSephoneCore,pt,TRUE);
//            }
//        }
    
	if (![SephoneManager isNotIphone3G]){
		PayloadType *pt=sephone_core_find_payload_type(theSephoneCore,"SILK",24000,-1);
		if (pt) {
			sephone_core_enable_payload_type(theSephoneCore,pt,FALSE);
			[SephoneLogger logc:SephoneLoggerWarning format:"SILK/24000 and video disabled on old iPhone 3G"];
		}
		sephone_core_enable_video(theSephoneCore, FALSE, FALSE);
	}

	[SephoneLogger logc:SephoneLoggerWarning format:"Sephone [%s]  started on [%s]", sephone_core_get_version(), [[UIDevice currentDevice].model cStringUsingEncoding:[NSString defaultCStringEncoding]]];


	// Post event
	NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSValue valueWithPointer:theSephoneCore]
													 forKey:@"core"];

	[[NSNotificationCenter defaultCenter] postNotificationName:kSephoneCoreUpdate
														object:[SephoneManager instance]
													  userInfo:dict];

}


static BOOL libStarted = FALSE;

- (void)startSephoneCore {

	if ( libStarted ) {
		[SephoneLogger logc:SephoneLoggerError format:"Libsephone is already initialized!"];
		return;
	}

	libStarted = TRUE;

	connectivity = none;
	signal(SIGPIPE, SIG_IGN);


	// create sephone core
	[self createSephoneCore];

	sephone_core_migrate_to_multi_transport(theSephoneCore);

	// init audio session (just getting the instance will init)
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	BOOL bAudioInputAvailable= audioSession.inputAvailable;
	NSError* err;

	if( ![audioSession setActive:NO error: &err] && err ){
		NSLog(@"audioSession setActive failed: %@", [err description]);
	}
	if(!bAudioInputAvailable){
		UIAlertView* error = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No microphone",nil)
														message:NSLocalizedString(@"You need to plug a microphone to your device to use this application.",nil)
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Ok",nil)
											  otherButtonTitles:nil ,nil];
		[error show];
		[error release];
	}

	if ([UIApplication sharedApplication].applicationState ==  UIApplicationStateBackground) {
		//go directly to bg mode
		[self enterBackgroundMode];
	}

}

- (void)createSephoneCore {

	if (theSephoneCore != nil) {
		[SephoneLogger logc:SephoneLoggerLog format:"sephonecore is already created"];
		return;
	}
	[SephoneLogger logc:SephoneLoggerLog format:"Create sephonecore"];

	connectivity=none;

    ms_init(); // Need to initialize mediastreamer2 before loading the plugins

    libmsilbc_init();
#if defined (HAVE_SILK)
    libmssilk_init();
#endif
#ifdef HAVE_AMR
    libmsamr_init(); //load amr plugin if present from the libsephone sdk
#endif
#ifdef HAVE_X264
    libmsx264_init(); //load x264 plugin if present from the libsephone sdk
#endif
#ifdef HAVE_OPENH264
    libmsopenh264_init(); //load openh264 plugin if present from the libsephone sdk
#endif

#if HAVE_G729
    libmsbcg729_init(); // load g729 plugin
#endif

	sephone_core_set_log_collection_path([[SephoneManager cacheDirectory] UTF8String]);
	[self setLogsEnabled:[self spConfigBoolForKey:@"debugenable_preference"]];


	theSephoneCore = sephone_core_new_with_config (&sephonec_vtable
										 ,configDb
										 ,self /* user_data */);

    // clear proxy history
    sephone_core_clear_proxy_config(theSephoneCore);
    sephone_core_clear_all_auth_info(theSephoneCore);

	/* set the CA file no matter what, since the remote provisioning could be hitting an HTTPS server */
	const char* lRootCa = [[SephoneManager bundleFile:@"rootca.pem"] cStringUsingEncoding:[NSString defaultCStringEncoding]];
	sephone_core_set_root_ca(theSephoneCore, lRootCa);
	sephone_core_set_user_certificates_path(theSephoneCore,[[SephoneManager cacheDirectory] UTF8String]);

	/* The core will call the sephone_iphone_configuring_status_changed callback when the remote provisioning is loaded (or skipped).
	 Wait for this to finish the code configuration */

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterrupted:) name:AVAudioSessionInterruptionNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globalStateChangedNotificationHandler:) name:kSephoneGlobalStateUpdate object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configuringStateChangedNotificationHandler:) name:kSephoneConfiguringStateUpdate object:nil];

	/*call iterate once immediately in order to initiate background connections with sip server or remote provisioning grab, if any */
	sephone_core_iterate(theSephoneCore);
	// start scheduler
	mIterateTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
													 target:self
												   selector:@selector(iterate)
												   userInfo:nil
													repeats:YES];
}

- (void)destroySephoneCore {
	[mIterateTimer invalidate];
	//just in case
	[self removeCTCallCenterCb];

	[[NSNotificationCenter defaultCenter] removeObserver:self];

	if (theSephoneCore != nil) { //just in case application terminate before sephone core initialization
		[SephoneLogger logc:SephoneLoggerLog format:"Destroy sephonecore"];
		sephone_core_destroy(theSephoneCore);
		theSephoneCore = nil;
		ms_exit(); // Uninitialize mediastreamer2

		// Post event
		NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSValue valueWithPointer:theSephoneCore] forKey:@"core"];
		[[NSNotificationCenter defaultCenter] postNotificationName:kSephoneCoreUpdate object:[SephoneManager instance] userInfo:dict];

		SCNetworkReachabilityUnscheduleFromRunLoop(proxyReachability, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		if (proxyReachability)
			CFRelease(proxyReachability);
		proxyReachability=nil;

	}
	libStarted  = FALSE;
}

- (void) resetSephoneCore {
	[self destroySephoneCore];
	[self createSephoneCore];

	// reset network state to trigger a new network connectivity assessment
	sephone_core_set_network_reachable(theSephoneCore, FALSE);
}

static int comp_call_id(const SephoneCall* call , const char *callid) {
	if (sephone_call_log_get_call_id(sephone_call_get_call_log(call)) == nil) {
		ms_error ("no callid for call [%p]", call);
		return 1;
	}
	return strcmp(sephone_call_log_get_call_id(sephone_call_get_call_log(call)), callid);
}

- (void)cancelLocalNotifTimerForCallId:(NSString*)callid {
    //first, make sure this callid is not already involved in a call
    MSList* calls = (MSList*)sephone_core_get_calls(theSephoneCore);
    MSList* call = ms_list_find_custom(calls, (MSCompareFunc)comp_call_id, [callid UTF8String]);
    if (call != NULL) {
        SephoneCallAppData* data = sephone_call_get_user_pointer((SephoneCall*)call->data);
        if ( data->timer )
            [data->timer invalidate];
        data->timer = nil;
        return;
    }
}

- (SephoneCall *)acceptCallForCallId:(NSString*)callid {
    //first, make sure this callid is not already involved in a call
    MSList* calls = (MSList*)sephone_core_get_calls(theSephoneCore);
    MSList* call = ms_list_find_custom(calls, (MSCompareFunc)comp_call_id, [callid UTF8String]);
    if (call != NULL) {
        [self acceptCall:(SephoneCall*)call->data];
        return (SephoneCall*)call->data;
    };
    return NULL;
}

- (void)addPushCallId:(NSString*) callid {
   //first, make sure this callid is not already involved in a call
    MSList* calls = (MSList*)sephone_core_get_calls(theSephoneCore);
    if (ms_list_find_custom(calls, (MSCompareFunc)comp_call_id, [callid UTF8String])) {
        LOGW(@"Call id [%@] already handled",callid);
        return;
    };
    if ([pushCallIDs count] > 10 /*max number of pending notif*/)
        [pushCallIDs removeObjectAtIndex:0];

    [pushCallIDs addObject:callid];
}

- (BOOL)popPushCallID:(NSString*) callId {
	for (NSString* pendingNotif in pushCallIDs) {
		if ([pendingNotif  compare:callId] == NSOrderedSame) {
			[pushCallIDs removeObject:pendingNotif];
			return TRUE;
		}
	}
	return FALSE;
}

- (BOOL)resignActive {
	sephone_core_stop_dtmf_stream(theSephoneCore);

	return YES;
}

- (void)playMessageSound {
    BOOL success = [self.messagePlayer play];
    if( !success ){
        LOGE(@"Could not play the message sound");
    }
    AudioServicesPlaySystemSound([SephoneManager instance].sounds.vibrate);
}

static int comp_call_state_paused  (const SephoneCall* call, const void* param) {
	return sephone_call_get_state(call) != SephoneCallPaused;
}

- (void) startCallPausedLongRunningTask {
	pausedCallBgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler: ^{
		[SephoneLogger log:SephoneLoggerWarning format:@"Call cannot be paused any more, too late"];
		[[UIApplication sharedApplication] endBackgroundTask:pausedCallBgTask];
	}];
	[SephoneLogger log:SephoneLoggerLog format:@"Long running task started, remaining [%g s] because at least one call is paused"
	 ,[[UIApplication  sharedApplication] backgroundTimeRemaining]];
}
- (BOOL)enterBackgroundMode {
	SephoneProxyConfig* proxyCfg;
	sephone_core_get_default_proxy(theSephoneCore, &proxyCfg);
	BOOL shouldEnterBgMode=FALSE;

	//handle proxy config if any
	if (proxyCfg) {
		if ([[SephoneManager instance] spConfigBoolForKey:@"backgroundmode_preference"] ||
			[[SephoneManager instance] spConfigBoolForKey:@"pushnotification_preference"]) {

			//For registration register
			[self refreshRegisters];
		}

		if ([[SephoneManager instance] spConfigBoolForKey:@"backgroundmode_preference"]) {

			//register keepalive
			if ([[UIApplication sharedApplication] setKeepAliveTimeout:600/*(NSTimeInterval)sephone_proxy_config_get_expires(proxyCfg)*/
															   handler:^{
																   [SephoneLogger logc:SephoneLoggerWarning format:"keepalive handler"];
																   if (mLastKeepAliveDate)
																	   [mLastKeepAliveDate release];
																   mLastKeepAliveDate=[NSDate date];
																   [mLastKeepAliveDate retain];
																   if (theSephoneCore == nil) {
																	   [SephoneLogger logc:SephoneLoggerWarning format:"It seems that Sephone BG mode was deactivated, just skipping"];
																	   return;
																   }
																   //kick up network cnx, just in case
																   [self refreshRegisters];
																   sephone_core_iterate(theSephoneCore);
															   }
				 ]) {


				[SephoneLogger logc:SephoneLoggerLog format:"keepalive handler succesfully registered"];
			} else {
				[SephoneLogger logc:SephoneLoggerLog format:"keepalive handler cannot be registered"];
			}
			shouldEnterBgMode=TRUE;
		}
	}

	SephoneCall* currentCall = sephone_core_get_current_call(theSephoneCore);
	const MSList* callList = sephone_core_get_calls(theSephoneCore);
	if (!currentCall //no active call
		&& callList // at least one call in a non active state
		&& ms_list_find_custom((MSList*)callList, (MSCompareFunc) comp_call_state_paused, NULL)) {
		[self startCallPausedLongRunningTask];
	}
	if (callList){
		/*if at least one call exist, enter normal bg mode */
		shouldEnterBgMode=TRUE;
	}
	/*stop the video preview*/
	if (theSephoneCore){
		sephone_core_enable_video_preview(theSephoneCore, FALSE);
		sephone_core_iterate(theSephoneCore);
	}
	sephone_core_stop_dtmf_stream(theSephoneCore);

	[SephoneLogger logc:SephoneLoggerLog format:"Entering [%s] bg mode",shouldEnterBgMode?"normal":"lite"];

	if (!shouldEnterBgMode ) {
		if([[SephoneManager instance] spConfigBoolForKey:@"pushnotification_preference"]) {
            
			[SephoneLogger logc:SephoneLoggerLog format:"Keeping lc core to handle push"];
			/*destroy voip socket if any and reset connectivity mode*/
			connectivity=none;
			sephone_core_set_network_reachable(theSephoneCore, FALSE);
			return YES;
		}
		return NO;

	} else
		return YES;
}

- (void)keepAliveHandler {
    [SephoneLogger logc:SephoneLoggerWarning format:"keepalive handler"];
    if (mLastKeepAliveDate)
        [mLastKeepAliveDate release];
    mLastKeepAliveDate=[NSDate date];
    [mLastKeepAliveDate retain];
    if (theSephoneCore == nil) {
        [SephoneLogger logc:SephoneLoggerWarning format:"It seems that Sephone BG mode was deactivated, just skipping"];
        return;
    }
    //kick up network cnx, just in case
    [self refreshRegisters];
    sephone_core_iterate(theSephoneCore);
}




- (void)becomeActive {
    
	[self refreshRegisters];
	if (pausedCallBgTask) {
		[[UIApplication sharedApplication]  endBackgroundTask:pausedCallBgTask];
		pausedCallBgTask=0;
	}
	if (incallBgTask) {
		[[UIApplication sharedApplication]  endBackgroundTask:incallBgTask];
		incallBgTask=0;
	}
    if ([[SephoneManager instance] spConfigBoolForKey:@"backgroundmode_preference"]) {
        [[UIApplication sharedApplication]  clearKeepAliveTimeout];
    }

	/*IOS specific*/
	sephone_core_start_dtmf_stream(theSephoneCore);

	/*start the video preview in case we are in the main view*/
	if ([SephoneManager runningOnIpad]  && sephone_core_video_enabled(theSephoneCore) && [self spConfigBoolForKey:@"preview_preference"]){
		sephone_core_enable_video_preview(theSephoneCore, TRUE);
	}
	/*check last keepalive handler date*/
	if (mLastKeepAliveDate!=Nil){
		NSDate *current=[NSDate date];
		if ([current timeIntervalSinceDate:mLastKeepAliveDate]>700){
			NSString *datestr=[mLastKeepAliveDate description];
			[SephoneLogger logc:SephoneLoggerWarning format:"keepalive handler was called for the last time at %@",datestr];
		}
	}

}

- (void)beginInterruption {
	SephoneCall* c = sephone_core_get_current_call(theSephoneCore);
	[SephoneLogger logc:SephoneLoggerLog format:"Sound interruption detected!"];
	if (c && sephone_call_get_state(c) == SephoneCallStreamsRunning) {
		sephone_core_pause_call(theSephoneCore, c);
	}
}

- (void)endInterruption {
	[SephoneLogger logc:SephoneLoggerLog format:"Sound interruption ended!"];
}

- (void)refreshRegisters{
	if (connectivity==none){
		//don't trust ios when he says there is no network. Create a new reachability context, the previous one might be mis-functionning.
		[self setupNetworkReachabilityCallback];
	}
	sephone_core_refresh_registers(theSephoneCore);//just to make sure REGISTRATION is up to date
}


- (void)copyDefaultSettings {
	NSString *src = [SephoneManager bundleFile:[SephoneManager runningOnIpad]?@"sephonerc~ipad":@"sephonerc"];
	NSString *dst = [SephoneManager documentFile:@".sephonerc"];
	[SephoneManager copyFile:src destination:dst override:FALSE];
}


#pragma mark - Audio route Functions

- (bool)allowSpeaker {
	bool notallow = false;
	CFStringRef lNewRoute = CFSTR("Unknown");
	UInt32 lNewRouteSize = sizeof(lNewRoute);
	OSStatus lStatus = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &lNewRouteSize, &lNewRoute);
	if (!lStatus && lNewRouteSize > 0) {
		NSString *route = (NSString *) lNewRoute;
		notallow = [route isEqualToString: @"Headset"] ||
			[route isEqualToString: @"Headphone"] ||
			[route isEqualToString: @"HeadphonesAndMicrophone"] ||
			[route isEqualToString: @"HeadsetInOut"] ||
			[route isEqualToString: @"Lineout"] ||
			[SephoneManager runningOnIpad];
		CFRelease(lNewRoute);
	}
	return !notallow;
}

static void audioRouteChangeListenerCallback (
											  void                   *inUserData,                                 // 1
											  AudioSessionPropertyID inPropertyID,                                // 2
											  UInt32                 inPropertyValueSize,                         // 3
											  const void             *inPropertyValue                             // 4
											  ) {
	if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return; // 5
	SephoneManager* lm = (SephoneManager*)inUserData;

	bool speakerEnabled = false;
	CFStringRef lNewRoute = CFSTR("Unknown");
	UInt32 lNewRouteSize = sizeof(lNewRoute);
	OSStatus lStatus = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &lNewRouteSize, &lNewRoute);
	if (!lStatus && lNewRouteSize > 0) {
		NSString *route = (NSString *) lNewRoute;
		[SephoneLogger logc:SephoneLoggerLog format:"Current audio route is [%s]", [route cStringUsingEncoding:[NSString defaultCStringEncoding]]];

		speakerEnabled = [route isEqualToString: @"Speaker"] ||
						 [route isEqualToString: @"SpeakerAndMicrophone"];
		if (![SephoneManager runningOnIpad] && [route isEqualToString:@"HeadsetBT"] && !speakerEnabled) {
			lm.bluetoothEnabled = TRUE;
			lm.bluetoothAvailable = TRUE;
			NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSNumber numberWithBool:lm.bluetoothAvailable], @"available", nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:kSephoneBluetoothAvailabilityUpdate object:lm userInfo:dict];
		} else {
			lm.bluetoothEnabled = FALSE;
		}
		CFRelease(lNewRoute);
	}

	if(speakerEnabled != lm.speakerEnabled) { // Reforce value
		lm.speakerEnabled = lm.speakerEnabled;
	}
}

- (void)setSpeakerEnabled:(BOOL)enable {
	speakerEnabled = enable;

	if(enable && [self allowSpeaker]) {
		UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
		AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute
								 , sizeof (audioRouteOverride)
								 , &audioRouteOverride);
		bluetoothEnabled = FALSE;
	} else {
		UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
		AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute
								 , sizeof (audioRouteOverride)
								 , &audioRouteOverride);
	}

	if (bluetoothAvailable) {
		UInt32 bluetoothInputOverride = bluetoothEnabled;
		AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryEnableBluetoothInput, sizeof(bluetoothInputOverride), &bluetoothInputOverride);
	}
}

- (void)setBluetoothEnabled:(BOOL)enable {
	if (bluetoothAvailable) {
		// The change of route will be done in setSpeakerEnabled
		bluetoothEnabled = enable;
		if (bluetoothEnabled) {
			[self setSpeakerEnabled:FALSE];
		} else {
			[self setSpeakerEnabled:speakerEnabled];
		}
	}
}

#pragma mark - Call Functions

- (void)acceptCall:(SephoneCall *)call {
	SephoneCallParams* lcallParams = sephone_core_create_call_params(theSephoneCore,call);
	if([self spConfigBoolForKey:@"edge_opt_preference"]) {
		bool low_bandwidth = self.network == network_2g;
		if(low_bandwidth) {
			[SephoneLogger log:SephoneLoggerLog format:@"Low bandwidth mode"];
		}
		sephone_call_params_enable_low_bandwidth(lcallParams, low_bandwidth);
	}

	sephone_core_accept_call_with_params(theSephoneCore,call, lcallParams);
}

- (void)call:(NSString *)address displayName:(NSString*)displayName transfer:(BOOL)transfer {
	if (!sephone_core_is_network_reachable(theSephoneCore)) {
		UIAlertView* error = [[UIAlertView alloc]	initWithTitle:NSLocalizedString(@"Network Error",nil)
														message:NSLocalizedString(@"There is no network connection available, enable WIFI or WWAN prior to place a call",nil)
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Continue",nil)
											  otherButtonTitles:nil];
		[error show];
		[error release];
		return;
	}

	CTCallCenter* callCenter = [[CTCallCenter alloc] init];
	if ([callCenter currentCalls]!=nil) {
		[SephoneLogger logc:SephoneLoggerError format:"GSM call in progress, cancelling outgoing SIP call request"];
		UIAlertView* error = [[UIAlertView alloc]	initWithTitle:NSLocalizedString(@"Cannot make call",nil)
														message:NSLocalizedString(@"Please terminate GSM call",nil)
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Continue",nil)
											  otherButtonTitles:nil];
		[error show];
		[error release];
		[callCenter release];
		return;
	}
	[callCenter release];

	SephoneProxyConfig* proxyCfg;
	//get default proxy
	sephone_core_get_default_proxy(theSephoneCore,&proxyCfg);
	SephoneCallParams* lcallParams = sephone_core_create_default_call_parameters(theSephoneCore);
	if([self spConfigBoolForKey:@"edge_opt_preference"]) {
		bool low_bandwidth = self.network == network_2g;
		if(low_bandwidth) {
			[SephoneLogger log:SephoneLoggerLog format:@"Low bandwidth mode"];
		}
		sephone_call_params_enable_low_bandwidth(lcallParams, low_bandwidth);
	}
	SephoneCall* call=NULL;

    BOOL addressIsASCII = [address canBeConvertedToEncoding:[NSString defaultCStringEncoding]];

	if ([address length] == 0) return; //just return
    if( !addressIsASCII ){
        UIAlertView* error = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid SIP address",nil)
                                                        message:NSLocalizedString(@"The address should only contain ASCII data",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Continue",nil)
                                              otherButtonTitles:nil];
        [error show];
        [error release];

    }
	SephoneAddress* sephoneAddress = sephone_core_interpret_url(theSephoneCore, [address cStringUsingEncoding:[NSString defaultCStringEncoding]]);

	if (sephoneAddress) {

		if(displayName!=nil) {
			sephone_address_set_display_name(sephoneAddress,[displayName cStringUsingEncoding:[NSString defaultCStringEncoding]]);
		}
		if ([[SephoneManager instance] spConfigBoolForKey:@"override_domain_with_default_one"])
			sephone_address_set_domain(sephoneAddress, [[[SephoneManager instance] spConfigStringForKey:@"domain" forSection:@"wizard"] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
		if(transfer) {
			sephone_core_transfer_call(theSephoneCore, sephone_core_get_current_call(theSephoneCore), [address cStringUsingEncoding:[NSString defaultCStringEncoding]]);
		} else {
			call=sephone_core_invite_address_with_params(theSephoneCore, sephoneAddress, lcallParams);
		}
		sephone_address_destroy(sephoneAddress);

	} else {

		UIAlertView* error = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid SIP address",nil)
														message:NSLocalizedString(@"Either configure a SIP proxy server from settings prior to place a call or use a valid SIP address (I.E sip:john@example.net)",nil)
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Continue",nil)
											  otherButtonTitles:nil];
		[error show];
		[error release];

    }


	if (call) {
		// The SephoneCallAppData object should be set on call creation with callback
		// - (void)onCall:StateChanged:withMessage:. If not, we are in big trouble and expect it to crash
		// We are NOT responsible for creating the AppData.
		SephoneCallAppData* data=(SephoneCallAppData*)sephone_call_get_user_pointer(call);
		if (data==nil)
			[SephoneLogger log:SephoneLoggerError format:@"New call instanciated but app data was not set. Expect it to crash."];
		/* will be used later to notify user if video was not activated because of the sephone core*/
		data->videoRequested = sephone_call_params_video_enabled(lcallParams);
	}
	sephone_call_params_destroy(lcallParams);
}


#pragma mark - Property Functions

- (void)setPushNotificationToken:(NSData *)apushNotificationToken {
	if(apushNotificationToken == pushNotificationToken) {
		return;
	}
	if(pushNotificationToken != nil) {
		[pushNotificationToken release];
		pushNotificationToken = nil;
	}

    if(apushNotificationToken != nil) {
        pushNotificationToken = [apushNotificationToken retain];
    }
    SephoneProxyConfig *cfg=nil;
    sephone_core_get_default_proxy(theSephoneCore, &cfg);
    if (cfg ) {
        sephone_proxy_config_edit(cfg);
        [self configurePushTokenForProxyConfig: cfg];
        sephone_proxy_config_done(cfg);
    }
}

- (void)configurePushTokenForProxyConfig:(SephoneProxyConfig*)proxyCfg{
	NSData *tokenData =  pushNotificationToken;
	if(tokenData != nil && [self spConfigBoolForKey:@"pushnotification_preference"]) {
		const unsigned char *tokenBuffer = [tokenData bytes];
		NSMutableString *tokenString = [NSMutableString stringWithCapacity:[tokenData length]*2];
		for(int i = 0; i < [tokenData length]; ++i) {
			[tokenString appendFormat:@"%02X", (unsigned int)tokenBuffer[i]];
		}
		// NSLocalizedString(@"IC_MSG", nil); // Fake for genstrings
		// NSLocalizedString(@"IM_MSG", nil); // Fake for genstrings
#ifdef DEBUG
#define APPMODE_SUFFIX @"dev"
#else
#define APPMODE_SUFFIX @"prod"
#endif
        NSString *params = [NSString stringWithFormat:@"app-id=%@.%@;pn-type=apple;pn-tok=%@;pn-msg-str=IM_MSG;pn-call-str=IC_MSG;pn-call-snd=ring.caf;pn-msg-snd=msg.caf", [[NSBundle mainBundle] bundleIdentifier],APPMODE_SUFFIX,tokenString];

        sephone_proxy_config_set_contact_uri_parameters(proxyCfg, [params UTF8String]);
        sephone_proxy_config_set_contact_parameters(proxyCfg, NULL);
	} else {
		// no push token:
		sephone_proxy_config_set_contact_uri_parameters(proxyCfg, NULL);
		sephone_proxy_config_set_contact_parameters(proxyCfg, NULL);
	}
}



#pragma mark - Misc Functions

+ (NSString*)bundleFile:(NSString*)file {
	return [[NSBundle mainBundle] pathForResource:[file stringByDeletingPathExtension] ofType:[file pathExtension]];
}

+ (NSString*)documentFile:(NSString*)file {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	return [documentsPath stringByAppendingPathComponent:file];
}

+ (NSString*)cacheDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachePath = [paths objectAtIndex:0];
	BOOL isDir = NO;
	NSError *error;
	// cache directory must be created if not existing
	if (! [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO) {
		[[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
	}
    return cachePath;
}

+ (int)unreadMessageCount {
    int count = 0;
    MSList* rooms = sephone_core_get_chat_rooms([SephoneManager getLc]);
    MSList* item = rooms;
    while (item) {
        SephoneChatRoom* room = (SephoneChatRoom*)item->data;
        if( room ){
            count += sephone_chat_room_get_unread_messages_count(room);
        }
        item = item->next;
    }

    return count;
}

+ (BOOL)copyFile:(NSString*)src destination:(NSString*)dst override:(BOOL)override {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	if ([fileManager fileExistsAtPath:dst] == YES) {
		if(override) {
			[fileManager removeItemAtPath:dst error:&error];
			if(error != nil) {
				[SephoneLogger log:SephoneLoggerError format:@"Can't remove \"%@\": %@", dst, [error localizedDescription]];
				return FALSE;
			}
		} else {
			[SephoneLogger log:SephoneLoggerWarning format:@"\"%@\" already exists", dst];
			return FALSE;
		}
	}
	if ([fileManager fileExistsAtPath:src] == NO) {
		[SephoneLogger log:SephoneLoggerError format:@"Can't find \"%@\": %@", src, [error localizedDescription]];
		return FALSE;
	}
	[fileManager copyItemAtPath:src toPath:dst error:&error];
	if(error != nil) {
		[SephoneLogger log:SephoneLoggerError format:@"Can't copy \"%@\" to \"%@\": %@", src, dst, [error localizedDescription]];
		return FALSE;
	}
	return TRUE;
}

- (void)configureVbrCodecs{
	PayloadType *pt;
	int bitrate=sp_config_get_int(configDb,"audio","codec_bitrate_limit",kSephoneAudioVbrCodecDefaultBitrate);/*default value is in sephonerc or sephonerc-factory*/
    const MSList *audio_codecs = sephone_core_get_audio_codecs(theSephoneCore);
    const MSList* codec = audio_codecs;
    while (codec) {
        pt = codec->data;
        if( sephone_core_payload_type_is_vbr(theSephoneCore, pt) ) {
            sephone_core_set_payload_type_bitrate(theSephoneCore, pt, bitrate);
        }

        codec = codec->next;
    }
}

-(void)setLogsEnabled:(BOOL)enabled {
	if (enabled) {
		NSLog(@"Enabling debug logs");
		sephone_core_enable_logs_with_cb((OrtpLogFunc)sephone_iphone_log_handler);
		ortp_set_log_level(ORTP_MESSAGE);
		sephone_core_enable_log_collection(enabled);
	} else {
		NSLog(@"Disabling debug logs");
		sephone_core_enable_log_collection(enabled);
		sephone_core_disable_logs();
	}
}

+(id)getMessageAppDataForKey:(NSString*)key inMessage:(SephoneChatMessage*)msg {

	if(msg == nil ) return nil;

	id value = nil;
	const char* appData = sephone_chat_message_get_appdata(msg);
	if( appData) {
		NSDictionary* appDataDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes:appData length:strlen(appData)] options:0 error:nil];
		value = [appDataDict objectForKey:key];
	}
	return value;
}

+(void)setValueInMessageAppData:(id)value forKey:(NSString*)key inMessage:(SephoneChatMessage*)msg {

	NSMutableDictionary* appDataDict = [NSMutableDictionary dictionary];
	const char* appData = sephone_chat_message_get_appdata(msg);
	if( appData) {
		appDataDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes:appData length:strlen(appData)] options:NSJSONReadingMutableContainers error:nil];
	}

	[appDataDict setValue:value forKey:key];

	NSData* data = [NSJSONSerialization dataWithJSONObject:appDataDict options:0 error:nil];
	NSString* appdataJSON = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	sephone_chat_message_set_appdata(msg, [appdataJSON UTF8String]);
	[appdataJSON release];
}

#pragma mark - SPConfig Functions

- (void)spConfigSetString:(NSString*)value forKey:(NSString*)key {
	[self spConfigSetString:value forKey:key forSection:[NSString stringWithUTF8String:SEPHONERC_APPLICATION_KEY]];
}

- (void)spConfigSetString:(NSString*)value forKey:(NSString*)key forSection:(NSString *)section {
	if (!key) return;
	sp_config_set_string(configDb, [section UTF8String], [key UTF8String], value?[value UTF8String]:NULL);
}

- (NSString*)spConfigStringForKey:(NSString*)key {
	return [self spConfigStringForKey:key forSection:[NSString stringWithUTF8String:SEPHONERC_APPLICATION_KEY]];
}
- (NSString*)spConfigStringForKey:(NSString*)key withDefault:(NSString*)defaultValue {
	NSString* value = [self spConfigStringForKey:key];
	return value?value:defaultValue;
}

- (NSString*)spConfigStringForKey:(NSString*)key forSection:(NSString *)section {
	if (!key) return nil;
	const char* value = sp_config_get_string(configDb, [section UTF8String], [key UTF8String], NULL);
	if (value)
		return [NSString stringWithUTF8String:value];
	else
		return nil;
}

- (void)spConfigSetInt:(NSInteger)value forKey:(NSString*)key {
	[self spConfigSetInt:value forKey:key forSection:[NSString stringWithUTF8String:SEPHONERC_APPLICATION_KEY]];
}

- (void)spConfigSetInt:(NSInteger)value forKey:(NSString*)key forSection:(NSString *)section {
	if (!key) return;
	sp_config_set_int(configDb, [section UTF8String], [key UTF8String], (int)value );
}

- (NSInteger)spConfigIntForKey:(NSString*)key {
	return [self spConfigIntForKey:key forSection:[NSString stringWithUTF8String:SEPHONERC_APPLICATION_KEY]];
}

- (NSInteger)spConfigIntForKey:(NSString*)key forSection:(NSString *)section {
	if (!key) return -1;
	return sp_config_get_int(configDb, [section UTF8String], [key UTF8String], -1);
}

- (void)spConfigSetBool:(BOOL)value forKey:(NSString*)key {
	[self spConfigSetBool:value forKey:key forSection:[NSString stringWithUTF8String:SEPHONERC_APPLICATION_KEY]];
}

- (void)spConfigSetBool:(BOOL)value forKey:(NSString*)key forSection:(NSString *)section {
	return [self spConfigSetInt:(NSInteger)(value == TRUE) forKey:key forSection:section];
}

- (BOOL)spConfigBoolForKey:(NSString*)key {
	return [self spConfigBoolForKey:key forSection:[NSString stringWithUTF8String:SEPHONERC_APPLICATION_KEY]];
}

- (BOOL)spConfigBoolForKey:(NSString*)key forSection:(NSString *)section {
	return [self spConfigIntForKey:key forSection:section] == 1;
}

#pragma mark - GSM management

-(void) removeCTCallCenterCb {
	if (mCallCenter != nil) {
		[SephoneLogger log:SephoneLoggerLog format:@"Removing CT call center listener [%p]",mCallCenter];
		mCallCenter.callEventHandler=NULL;
		[mCallCenter release];
	}
	mCallCenter=nil;
}

- (void)setupGSMInteraction {

	[self removeCTCallCenterCb];
	mCallCenter = [[CTCallCenter alloc] init];
	[SephoneLogger log:SephoneLoggerLog format:@"Adding CT call center listener [%p]",mCallCenter];
	mCallCenter.callEventHandler = ^(CTCall* call) {
		// post on main thread
		[self performSelectorOnMainThread:@selector(handleGSMCallInteration:)
							   withObject:mCallCenter
							waitUntilDone:YES];
	};

}

- (void)handleGSMCallInteration: (id) cCenter {
	CTCallCenter* ct = (CTCallCenter*) cCenter;
	/* pause current call, if any */
	SephoneCall* call = sephone_core_get_current_call(theSephoneCore);
	if ([ct currentCalls]!=nil) {
		if (call) {
			[SephoneLogger log:SephoneLoggerLog format:@"Pausing SIP call because GSM call"];
			sephone_core_pause_call(theSephoneCore, call);
			[self startCallPausedLongRunningTask];
		} else if (sephone_core_is_in_conference(theSephoneCore)) {
			[SephoneLogger log:SephoneLoggerLog format:@"Leaving conference call because GSM call"];
			sephone_core_leave_conference(theSephoneCore);
			[self startCallPausedLongRunningTask];
		}
	} //else nop, keep call in paused state
}

-(NSString*) contactFilter {
	NSString* filter=@"*";
	if ( [self spConfigBoolForKey:@"contact_filter_on_default_domain"]) {
		SephoneProxyConfig* proxy_cfg;
		sephone_core_get_default_proxy(theSephoneCore, &proxy_cfg);
		if (proxy_cfg && sephone_proxy_config_get_addr(proxy_cfg)) {
			return [NSString stringWithCString:sephone_proxy_config_get_domain(proxy_cfg)
									  encoding:[NSString defaultCStringEncoding]];
		}
	}
	return filter;
}

#pragma Tunnel

- (void)setTunnelMode:(TunnelMode)atunnelMode {
	SephoneTunnel *tunnel = sephone_core_get_tunnel(theSephoneCore);
	tunnelMode = atunnelMode;
	switch (tunnelMode) {
		case tunnel_off:
			sephone_tunnel_enable(tunnel, false);
			break;
		case tunnel_on:
			sephone_tunnel_enable(tunnel, true);
			break;
		case tunnel_wwan:
			if (connectivity != wwan) {
				sephone_tunnel_enable(tunnel, false);
			} else {
				sephone_tunnel_enable(tunnel, true);
			}
			break;
		case tunnel_auto:
			sephone_tunnel_auto_detect(tunnel);
			break;

	}
}

#pragma mark - Utils

// 加入sip账号并注册
+ (void)addProxyConfig:(NSString *)username password:(NSString *)password domain:(NSString *)domain {
    SephoneCore *lc = [SephoneManager getLc];
    SephoneProxyConfig *proxyCfg = sephone_core_create_proxy_config(lc);

    // 创建账号信息。
    char normalizedUserName[256];
    sephone_proxy_config_normalize_number(proxyCfg, [username cStringUsingEncoding:[NSString defaultCStringEncoding]], normalizedUserName, sizeof(normalizedUserName));

    const char *identity = sephone_proxy_config_get_identity(proxyCfg);
    if (!identity || !*identity)
        identity = "sip:user@example.com";

    SephoneAddress *address = sephone_address_new(identity);
    sephone_address_set_username(address, normalizedUserName);

    if (domain && [domain length] != 0) {
        sephone_address_set_domain(address, [domain UTF8String]);
        sephone_proxy_config_set_server_addr(proxyCfg, [domain UTF8String]);
    }

    identity = sephone_address_as_string_uri_only(address);
    sephone_proxy_config_set_identity(proxyCfg, identity);

    sephone_address_destroy(address);

    SephoneAuthInfo *info = sephone_auth_info_new([username UTF8String], NULL, [password UTF8String], NULL, NULL, sephone_proxy_config_get_domain(proxyCfg));

    // 清除历史账号。
    sephone_core_clear_proxy_config([SephoneManager getLc]);
    sephone_core_clear_all_auth_info([SephoneManager getLc]);

    // 设置新账号。
    sephone_proxy_config_enable_register(proxyCfg, true);
    sephone_core_add_auth_info(lc, info);
    sephone_core_add_proxy_config(lc, proxyCfg);
    sephone_core_set_default_proxy(lc, proxyCfg);

    // 注册。
    sephone_core_refresh_registers(lc);
}

// 通话是否存在
+ (BOOL)hasCall:(SephoneCall*)call {
    SephoneCore* lc = [SephoneManager getLc];
    if(sephone_core_get_calls_nb(lc) == 0) {
        return FALSE;
    }
    const MSList *list = sephone_core_get_calls(lc);
    while(list != NULL) {
        SephoneCall *acall = (SephoneCall*) list->data;
        if (acall == call) {
            return TRUE;
        }
        list = list->next;
    }
    return FALSE;
}

// 通话是否为主叫
+ (BOOL)isCallOutgoing:(SephoneCall*)call {
    if (call == NULL) {
        return FALSE;
    }
    SephoneCallState state = sephone_call_get_state(call);
    if (state == SephoneCallOutgoingInit || state == SephoneCallOutgoingProgress || state == SephoneCallOutgoingRinging || state == SephoneCallOutgoingEarlyMedia) {
        return TRUE;
    }

    return FALSE;
}

// 通话是否为被叫
+ (BOOL)isCallIncoming:(SephoneCall*)call {
    if (call == NULL) {
        return FALSE;
    }
    SephoneCallState state = sephone_call_get_state(call);
    if (state == SephoneCallIncomingReceived || state == SephoneCallIncomingEarlyMedia) {
        return TRUE;
    }
    
    return FALSE;
}

+ (bool)isInConference:(SephoneCall *)call {
    if (!call)
        return false;
    return sephone_call_is_in_conference(call);
}

+ (int)callCount:(SephoneCore *)lc {
    int count = 0;
    const MSList *calls = sephone_core_get_calls(lc);
    while (calls != 0) {
        if (![SephoneManager isInConference:((SephoneCall *)calls->data)]) {
            count++;
        }
        calls = calls->next;
    }
    return count;
}

+ (void)terminateCurrentCallOrConference {
    SephoneCore *lc = [SephoneManager getLc];
    SephoneCall *currentcall = sephone_core_get_current_call(lc);
    if (sephone_core_is_in_conference(lc) ||                                             // In conference
        (sephone_core_get_conference_size(lc) > 0 && [SephoneManager callCount:lc] == 0) // Only one conf
        ) {
        sephone_core_terminate_conference(lc);
    } else if (currentcall != NULL) { // In a call
        sephone_core_terminate_call(lc, currentcall);
    } else {
        const MSList *calls = sephone_core_get_calls(lc);
        if (ms_list_size(calls) == 1) { // Only one call
            sephone_core_terminate_call(lc, (SephoneCall *)(calls->data));
        }
    }
}

@end
