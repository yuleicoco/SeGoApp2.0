/*
	libsephone_tester - libsephone test suite
	Copyright (C) 2013  Belledonne Communications SARL

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#ifndef LIBSEPHONE_TESTER_H_
#define LIBSEPHONE_TESTER_H_



#include "bc_tester_utils.h"
#include "sephonecore.h"
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

extern test_suite_t setup_test_suite;
extern test_suite_t register_test_suite;
extern test_suite_t call_test_suite;
extern test_suite_t message_test_suite;
extern test_suite_t presence_test_suite;
extern test_suite_t upnp_test_suite;
extern test_suite_t event_test_suite;
extern test_suite_t flexisip_test_suite;
extern test_suite_t stun_test_suite;
extern test_suite_t remote_provisioning_test_suite;
extern test_suite_t quality_reporting_test_suite;
extern test_suite_t log_collection_test_suite;
extern test_suite_t transport_test_suite;
extern test_suite_t player_test_suite;
extern test_suite_t dtmf_test_suite;
extern test_suite_t offeranswer_test_suite;
extern test_suite_t video_test_suite;
extern test_suite_t multicast_call_test_suite;
extern test_suite_t multi_call_test_suite;


extern int libsephone_tester_ipv6_available(void);

/**
 * @brief Tells the tester whether or not to clean the accounts it has created between runs.
 * @details Setting this to 1 will not clear the list of created accounts between successive
 * calls to libsephone_run_tests(). Some testing APIs call this function for *each* test,
 * in which case we should keep the accounts that were created for further testing.
 *
 * You are supposed to manually call libsephone_tester_clear_account when all the tests are
 * finished.
 *
 * @param keep 1 to keep the accounts in-between runs, 0 to clear them after each run.
 */
extern void libsephone_tester_keep_accounts( int keep );

/**
 * @brief Clears the created accounts during the testing session.
 */
extern void libsephone_tester_clear_accounts(void);

#ifdef __cplusplus
};
#endif


extern const char* test_domain;
extern const char* auth_domain;
extern const char* test_username;
extern const char* test_password;
extern const char* test_route;
extern const char* userhostsfile;


typedef struct _stats {
	int number_of_SephoneRegistrationNone;
	int number_of_SephoneRegistrationProgress ;
	int number_of_SephoneRegistrationOk ;
	int number_of_SephoneRegistrationCleared ;
	int number_of_SephoneRegistrationFailed ;
	int number_of_auth_info_requested ;


	int number_of_SephoneCallIncomingReceived;
	int number_of_SephoneCallOutgoingInit;
	int number_of_SephoneCallOutgoingProgress;
	int number_of_SephoneCallOutgoingRinging;
	int number_of_SephoneCallOutgoingEarlyMedia;
	int number_of_SephoneCallConnected;
	int number_of_SephoneCallStreamsRunning;
	int number_of_SephoneCallPausing;
	int number_of_SephoneCallPaused;
	int number_of_SephoneCallResuming;
	int number_of_SephoneCallRefered;
	int number_of_SephoneCallError;
	int number_of_SephoneCallEnd;
	int number_of_SephoneCallPausedByRemote;
	int number_of_SephoneCallUpdatedByRemote;
	int number_of_SephoneCallIncomingEarlyMedia;
	int number_of_SephoneCallUpdating;
	int number_of_SephoneCallReleased;
	int number_of_SephoneCallEarlyUpdatedByRemote;
	int number_of_SephoneCallEarlyUpdating;

	int number_of_SephoneTransferCallOutgoingInit;
	int number_of_SephoneTransferCallOutgoingProgress;
	int number_of_SephoneTransferCallOutgoingRinging;
	int number_of_SephoneTransferCallOutgoingEarlyMedia;
	int number_of_SephoneTransferCallConnected;
	int number_of_SephoneTransferCallStreamsRunning;
	int number_of_SephoneTransferCallError;

	int number_of_SephoneMessageReceived;
	int number_of_SephoneMessageReceivedWithFile;
	int number_of_SephoneMessageReceivedLegacy;
	int number_of_SephoneMessageExtBodyReceived;
	int number_of_SephoneMessageInProgress;
	int number_of_SephoneMessageDelivered;
	int number_of_SephoneMessageNotDelivered;
	int number_of_SephoneMessageFileTransferDone;
	int number_of_SephoneIsComposingActiveReceived;
	int number_of_SephoneIsComposingIdleReceived;
	int progress_of_SephoneFileTransfer;

	int number_of_IframeDecoded;

	int number_of_NewSubscriptionRequest;
	int number_of_NotifyReceived;
	int number_of_SephonePresenceActivityOffline;
	int number_of_SephonePresenceActivityOnline;
	int number_of_SephonePresenceActivityAppointment;
	int number_of_SephonePresenceActivityAway;
	int number_of_SephonePresenceActivityBreakfast;
	int number_of_SephonePresenceActivityBusy;
	int number_of_SephonePresenceActivityDinner;
	int number_of_SephonePresenceActivityHoliday;
	int number_of_SephonePresenceActivityInTransit;
	int number_of_SephonePresenceActivityLookingForWork;
	int number_of_SephonePresenceActivityLunch;
	int number_of_SephonePresenceActivityMeal;
	int number_of_SephonePresenceActivityMeeting;
	int number_of_SephonePresenceActivityOnThePhone;
	int number_of_SephonePresenceActivityOther;
	int number_of_SephonePresenceActivityPerformance;
	int number_of_SephonePresenceActivityPermanentAbsence;
	int number_of_SephonePresenceActivityPlaying;
	int number_of_SephonePresenceActivityPresentation;
	int number_of_SephonePresenceActivityShopping;
	int number_of_SephonePresenceActivitySleeping;
	int number_of_SephonePresenceActivitySpectator;
	int number_of_SephonePresenceActivitySteering;
	int number_of_SephonePresenceActivityTravel;
	int number_of_SephonePresenceActivityTV;
	int number_of_SephonePresenceActivityUnknown;
	int number_of_SephonePresenceActivityVacation;
	int number_of_SephonePresenceActivityWorking;
	int number_of_SephonePresenceActivityWorship;
	const SephonePresenceModel *last_received_presence;

	int number_of_inforeceived;
	SephoneInfoMessage* last_received_info_message;

	int number_of_SephoneSubscriptionIncomingReceived;
	int number_of_SephoneSubscriptionOutgoingInit;
	int number_of_SephoneSubscriptionPending;
	int number_of_SephoneSubscriptionActive;
	int number_of_SephoneSubscriptionTerminated;
	int number_of_SephoneSubscriptionError;
	int number_of_SephoneSubscriptionExpiring;

	int number_of_SephonePublishProgress;
	int number_of_SephonePublishOk;
	int number_of_SephonePublishExpiring;
	int number_of_SephonePublishError;
	int number_of_SephonePublishCleared;

	int number_of_SephoneConfiguringSkipped;
	int number_of_SephoneConfiguringFailed;
	int number_of_SephoneConfiguringSuccessful;

	int number_of_SephoneCallEncryptedOn;
	int number_of_SephoneCallEncryptedOff;
	int number_of_NetworkReachableTrue;
	int number_of_NetworkReachableFalse;
	int number_of_player_eof;
	SephoneChatMessage* last_received_chat_message;

	char * dtmf_list_received;
	int dtmf_count;

	int number_of_SephoneCallStatsUpdated;
	int number_of_rtcp_sent;
	int number_of_rtcp_received;

	int number_of_video_windows_created;

	int number_of_SephoneFileTransferDownloadSuccessful;
	int number_of_SephoneCoreLogCollectionUploadStateDelivered;
	int number_of_SephoneCoreLogCollectionUploadStateNotDelivered;
	int number_of_SephoneCoreLogCollectionUploadStateInProgress;
	int audio_download_bandwidth;
	int audio_upload_bandwidth;
	int video_download_bandwidth;
	int video_upload_bandwidth;

}stats;

typedef struct _SephoneCoreManager {
	SephoneCoreVTable v_table;
	SephoneCore* lc;
	stats stat;
	SephoneAddress* identity;
	SephoneEvent *lev;
	bool_t decline_subscribe;
	int number_of_cunit_error_at_creation;
} SephoneCoreManager;

typedef struct _SephoneCallTestParams {
	SephoneCallParams *base;
	bool_t sdp_removal;
	bool_t sdp_simulate_error;
} SephoneCallTestParams;


void libsephone_tester_add_suites();

SephoneCoreManager* sephone_core_manager_init(const char* rc_file);
void sephone_core_manager_start(SephoneCoreManager *mgr, const char* rc_file, int check_for_proxies);
SephoneCoreManager* sephone_core_manager_new2(const char* rc_file, int check_for_proxies);
SephoneCoreManager* sephone_core_manager_new(const char* rc_file);
void sephone_core_manager_stop(SephoneCoreManager *mgr);
void sephone_core_manager_destroy(SephoneCoreManager* mgr);

void reset_counters( stats* counters);

void registration_state_changed(struct _SephoneCore *lc, SephoneProxyConfig *cfg, SephoneRegistrationState cstate, const char *message);
void call_state_changed(SephoneCore *lc, SephoneCall *call, SephoneCallState cstate, const char *msg);
void sephone_transfer_state_changed(SephoneCore *lc, SephoneCall *transfered, SephoneCallState new_call_state);
void notify_presence_received(SephoneCore *lc, SephoneFriend * lf);
void text_message_received(SephoneCore *lc, SephoneChatRoom *room, const SephoneAddress *from_address, const char *message);
void message_received(SephoneCore *lc, SephoneChatRoom *room, SephoneChatMessage* message);
void file_transfer_received(SephoneChatMessage *message, const SephoneContent* content, const SephoneBuffer *buffer);
SephoneBuffer * file_transfer_send(SephoneChatMessage *message, const SephoneContent* content, size_t offset, size_t size);
SephoneBuffer * memory_file_transfer_send(SephoneChatMessage *message, const SephoneContent* content, size_t offset, size_t size);
void file_transfer_progress_indication(SephoneChatMessage *message, const SephoneContent* content, size_t offset, size_t total);
void is_composing_received(SephoneCore *lc, SephoneChatRoom *room);
void info_message_received(SephoneCore *lc, SephoneCall *call, const SephoneInfoMessage *msg);
void new_subscription_requested(SephoneCore *lc, SephoneFriend *lf, const char *url);
void sephone_subscription_state_change(SephoneCore *lc, SephoneEvent *ev, SephoneSubscriptionState state);
void sephone_publish_state_changed(SephoneCore *lc, SephoneEvent *ev, SephonePublishState state);
void sephone_notify_received(SephoneCore *lc, SephoneEvent *lev, const char *eventname, const SephoneContent *content);
void sephone_configuration_status(SephoneCore *lc, SephoneConfiguringState status, const char *message);
void sephone_call_encryption_changed(SephoneCore *lc, SephoneCall *call, bool_t on, const char *authentication_token);
void dtmf_received(SephoneCore *lc, SephoneCall *call, int dtmf);
void call_stats_updated(SephoneCore *lc, SephoneCall *call, const SephoneCallStats *stats);

SephoneAddress * create_sephone_address(const char * domain);
bool_t wait_for(SephoneCore* lc_1, SephoneCore* lc_2,int* counter,int value);
bool_t wait_for_list(MSList* lcs,int* counter,int value,int timeout_ms);
bool_t wait_for_until(SephoneCore* lc_1, SephoneCore* lc_2,int* counter,int value,int timout_ms);

bool_t call_with_params(SephoneCoreManager* caller_mgr
						,SephoneCoreManager* callee_mgr
						, const SephoneCallParams *caller_params
						, const SephoneCallParams *callee_params);
bool_t call_with_test_params(SephoneCoreManager* caller_mgr
				,SephoneCoreManager* callee_mgr
				,const SephoneCallTestParams *caller_test_params
				,const SephoneCallTestParams *callee_test_params);

bool_t call(SephoneCoreManager* caller_mgr,SephoneCoreManager* callee_mgr);
bool_t add_video(SephoneCoreManager* caller,SephoneCoreManager* callee);
void end_call(SephoneCoreManager *m1, SephoneCoreManager *m2);
void disable_all_audio_codecs_except_one(SephoneCore *lc, const char *mime, int rate);
void disable_all_video_codecs_except_one(SephoneCore *lc, const char *mime);
stats * get_stats(SephoneCore *lc);
SephoneCoreManager *get_manager(SephoneCore *lc);
const char *libsephone_tester_get_subscribe_content(void);
const char *libsephone_tester_get_notify_content(void);
void libsephone_tester_chat_message_state_change(SephoneChatMessage* msg,SephoneChatMessageState state,void* ud);
void libsephone_tester_chat_message_msg_state_changed(SephoneChatMessage *msg, SephoneChatMessageState state);
void libsephone_tester_check_rtcp(SephoneCoreManager* caller, SephoneCoreManager* callee);
void libsephone_tester_clock_start(MSTimeSpec *start);
bool_t libsephone_tester_clock_elapsed(const MSTimeSpec *start, int value_ms);
void sephone_core_manager_check_accounts(SephoneCoreManager *m);
void account_manager_destroy(void);
SephoneCore* configure_lc_from(SephoneCoreVTable* v_table, const char* path, const char* file, void* user_data);
void libsephone_tester_enable_ipv6(bool_t enabled);
void sephone_call_cb(SephoneCall *call,void * user_data);
void call_paused_resumed_base(bool_t multicast);
void simple_call_base(bool_t enable_multicast_recv_side);
void call_base_with_configfile(SephoneMediaEncryption mode, bool_t enable_video,bool_t enable_relay,SephoneFirewallPolicy policy,bool_t enable_tunnel, const char *marie_rc, const char *pauline_rc);
void call_base(SephoneMediaEncryption mode, bool_t enable_video,bool_t enable_relay,SephoneFirewallPolicy policy,bool_t enable_tunnel);
bool_t call_with_caller_params(SephoneCoreManager* caller_mgr,SephoneCoreManager* callee_mgr, const SephoneCallParams *params);
bool_t pause_call_1(SephoneCoreManager* mgr_1,SephoneCall* call_1,SephoneCoreManager* mgr_2,SephoneCall* call_2);
bool_t compare_files(const char *path1, const char *path2);
#endif /* LIBSEPHONE_TESTER_H_ */

