/*
sephonecore.h
Copyright (C) 2000 - 2010 Simon MORLAT (simon.morlat@linphone.org)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/
#ifndef SEPHONECORE_H
#define SEPHONECORE_H

#include "ortp/ortp.h"
#include "ortp/payloadtype.h"
#include "mediastreamer2/mscommon.h"
#include "mediastreamer2/msvideo.h"
#include "mediastreamer2/mediastream.h"
#include "mediastreamer2/bitratecontrol.h"

#ifdef IN_SEPHONE
#include "sipsetup.h"
#else
#include "sephone/sipsetup.h"
#endif

#include "spconfig.h"

#define SEPHONE_IPADDR_SIZE 64
#define SEPHONE_HOSTNAME_SIZE 128

#ifndef SEPHONE_PUBLIC
	#define SEPHONE_PUBLIC MS2_PUBLIC
#endif

#ifdef __cplusplus
extern "C" {
#endif

struct _SephoneCore;
/**
 * Sephone core main object created by function sephone_core_new() .
 * @ingroup initializing
 */
typedef struct _SephoneCore SephoneCore;


/**
 * Disable a sip transport
 * Use with #SCSipTransports
 * @ingroup initializing
 */
#define LC_SIP_TRANSPORT_DISABLED 0
/**
 * Randomly chose a sip port for this transport
 * Use with #SCSipTransports
 * @ingroup initializing
 */
#define LC_SIP_TRANSPORT_RANDOM -1

/**
 * Sephone core SIP transport ports.
 * Use with #sephone_core_set_sip_transports
 * @ingroup initializing
 */
typedef struct _SCSipTransports{
	/**
	 * udp port to listening on, negative value if not set
	 * */
	int udp_port;
	/**
	 * tcp port to listening on, negative value if not set
	 * */
	int tcp_port;
	/**
	 * dtls port to listening on, negative value if not set
	 * */
	int dtls_port;
	/**
	 * tls port to listening on, negative value if not set
	 * */
	int tls_port;
} SCSipTransports;


/**
 * Enum describing transport type for SephoneAddress.
 * @ingroup sephone_address
**/
enum _SephoneTransportType{
	SephoneTransportUdp,
	SephoneTransportTcp,
	SephoneTransportTls,
	SephoneTransportDtls
};
/*this enum MUST be kept in sync with the SalTransport from sal.h*/

/**
 * Typedef for transport type enum.
 * @ingroup sephone_address
**/
typedef enum _SephoneTransportType SephoneTransportType;

/**
 * Object that represents a SIP address.
 *
 * The SephoneAddress is an opaque object to represents SIP addresses, ie
 * the content of SIP's 'from' and 'to' headers.
 * A SIP address is made of display name, username, domain name, port, and various
 * uri headers (such as tags). It looks like 'Alice <sip:alice@example.net>'.
 * The SephoneAddress has methods to extract and manipulate all parts of the address.
 * When some part of the address (for example the username) is empty, the accessor methods
 * return NULL.
 *
 * @ingroup sephone_address
 */
typedef struct SalAddress SephoneAddress;

typedef struct belle_sip_dict SephoneDictionary;

/**
 * The SephoneCall object represents a call issued or received by the SephoneCore
 * @ingroup call_control
**/
struct _SephoneCall;
/**
 * The SephoneCall object represents a call issued or received by the SephoneCore
 * @ingroup call_control
**/
typedef struct _SephoneCall SephoneCall;

/**
 * Enum describing various failure reasons or contextual information for some events.
 * @see sephone_call_get_reason()
 * @see sephone_proxy_config_get_error()
 * @see sephone_error_info_get_reason()
 * @ingroup misc
**/
enum _SephoneReason{
	SephoneReasonNone,
	SephoneReasonNoResponse, /**<No response received from remote*/
	SephoneReasonForbidden, /**<Authentication failed due to bad credentials or resource forbidden*/
	SephoneReasonDeclined, /**<The call has been declined*/
	SephoneReasonNotFound, /**<Destination of the call was not found.*/
	SephoneReasonNotAnswered, /**<The call was not answered in time (request timeout)*/
	SephoneReasonBusy, /**<Phone line was busy */
	SephoneReasonUnsupportedContent, /**<Unsupported content */
	SephoneReasonIOError, /**<Transport error: connection failures, disconnections etc...*/
	SephoneReasonDoNotDisturb, /**<Do not disturb reason*/
	SephoneReasonUnauthorized, /**<Operation is unauthorized because missing credential*/
	SephoneReasonNotAcceptable, /**<Operation like call update rejected by peer*/
	SephoneReasonNoMatch, /**<Operation could not be executed by server or remote client because it didn't have any context for it*/
	SephoneReasonMovedPermanently, /**<Resource moved permanently*/
	SephoneReasonGone, /**<Resource no longer exists*/
	SephoneReasonTemporarilyUnavailable, /**<Temporarily unavailable*/
	SephoneReasonAddressIncomplete, /**<Address incomplete*/
	SephoneReasonNotImplemented, /**<Not implemented*/
	SephoneReasonBadGateway, /**<Bad gateway*/
	SephoneReasonServerTimeout, /**<Server timeout*/
	SephoneReasonUnknown /**Unknown reason*/
};

#define SephoneReasonBadCredentials SephoneReasonForbidden

/*for compatibility*/
#define SephoneReasonMedia SephoneReasonUnsupportedContent

/**
 * Enum describing failure reasons.
 * @ingroup misc
**/
typedef enum _SephoneReason SephoneReason;

/**
 * Converts a SephoneReason enum to a string.
 * @ingroup misc
**/
SEPHONE_PUBLIC const char *sephone_reason_to_string(SephoneReason err);

/**
 * Object representing full details about a signaling error or status.
 * All SephoneErrorInfo object returned by the libsephone API are readonly and transcients. For safety they must be used immediately
 * after obtaining them. Any other function call to the libsephone may change their content or invalidate the pointer.
 * @ingroup misc
**/
typedef struct _SephoneErrorInfo SephoneErrorInfo;

SEPHONE_PUBLIC SephoneReason sephone_error_info_get_reason(const SephoneErrorInfo *ei);
SEPHONE_PUBLIC const char *sephone_error_info_get_phrase(const SephoneErrorInfo *ei);
SEPHONE_PUBLIC const char *sephone_error_info_get_details(const SephoneErrorInfo *ei);
SEPHONE_PUBLIC int sephone_error_info_get_protocol_code(const SephoneErrorInfo *ei);

/* sephone dictionary */
SEPHONE_PUBLIC	SephoneDictionary* sephone_dictionary_new(void);
SEPHONE_PUBLIC SephoneDictionary * sephone_dictionary_clone(const SephoneDictionary* src);
SEPHONE_PUBLIC SephoneDictionary * sephone_dictionary_ref(SephoneDictionary* obj);
SEPHONE_PUBLIC void sephone_dictionary_unref(SephoneDictionary* obj);
SEPHONE_PUBLIC void sephone_dictionary_set_int(SephoneDictionary* obj, const char* key, int value);
SEPHONE_PUBLIC int sephone_dictionary_get_int(SephoneDictionary* obj, const char* key, int default_value);
SEPHONE_PUBLIC void sephone_dictionary_set_string(SephoneDictionary* obj, const char* key, const char*value);
SEPHONE_PUBLIC const char* sephone_dictionary_get_string(SephoneDictionary* obj, const char* key, const char* default_value);
SEPHONE_PUBLIC void sephone_dictionary_set_int64(SephoneDictionary* obj, const char* key, int64_t value);
SEPHONE_PUBLIC int64_t sephone_dictionary_get_int64(SephoneDictionary* obj, const char* key, int64_t default_value);
SEPHONE_PUBLIC int sephone_dictionary_remove(SephoneDictionary* obj, const char* key);
SEPHONE_PUBLIC void sephone_dictionary_clear(SephoneDictionary* obj);
SEPHONE_PUBLIC int sephone_dictionary_haskey(const SephoneDictionary* obj, const char* key);
SEPHONE_PUBLIC void sephone_dictionary_foreach( const SephoneDictionary* obj, void (*apply_func)(const char*key, void* value, void* userdata), void* userdata);
/**
 * Converts a config section into a dictionary.
 * @return a #SephoneDictionary with all the keys from a section, or NULL if the section doesn't exist
 * @ingroup misc
 */
SEPHONE_PUBLIC SephoneDictionary* sp_config_section_to_dict( const SpConfig* spconfig, const char* section );

/**
 * Loads a dictionary into a section of the spconfig. If the section doesn't exist it is created.
 * Overwrites existing keys, creates non-existing keys.
 * @ingroup misc
 */
SEPHONE_PUBLIC void sp_config_load_dict_to_section( SpConfig* spconfig, const char* section, const SephoneDictionary* dict);


/**
 * @addtogroup media_parameters
 * @{
**/

/**
 * Object representing an RTP payload type.
 */
typedef PayloadType SephonePayloadType;

/**
 * Get the type of payload.
 * @param[in] pt SephonePayloadType object
 * @return The type of payload.
 */
SEPHONE_PUBLIC int sephone_payload_type_get_type(const SephonePayloadType *pt);

/**
 * Get the normal bitrate in bits/s.
 * @param[in] pt SephonePayloadType object
 * @return The normal bitrate in bits/s.
 */
SEPHONE_PUBLIC int sephone_payload_type_get_normal_bitrate(const SephonePayloadType *pt);

/**
 * Get the mime type.
 * @param[in] pt SephonePayloadType object
 * @return The mime type.
 */
SEPHONE_PUBLIC const char * sephone_payload_type_get_mime_type(const SephonePayloadType *pt);

/**
 * Get the number of channels.
 * @param[in] pt SephonePayloadType object
 * @return The number of channels.
 */
SEPHONE_PUBLIC int sephone_payload_type_get_channels(const SephonePayloadType *pt);


/**
 * Enum describing RTP AVPF activation modes.
**/
enum _SephoneAVPFMode{
	SephoneAVPFDefault=-1, /**<Use default value defined at upper level*/
	SephoneAVPFDisabled, /**<AVPF is disabled*/
	SephoneAVPFEnabled /**<AVPF is enabled */
};

/**
 * Enum describing RTP AVPF activation modes.
**/
typedef enum _SephoneAVPFMode  SephoneAVPFMode;

/**
 * Enum describing type of media encryption types.
**/
enum _SephoneMediaEncryption {
	SephoneMediaEncryptionNone, /**< No media encryption is used */
	SephoneMediaEncryptionSRTP, /**< Use SRTP media encryption */
	SephoneMediaEncryptionZRTP, /**< Use ZRTP media encryption */
	SephoneMediaEncryptionDTLS /**< Use DTLS media encryption */
};

/**
 * Enum describing type of media encryption types.
**/
typedef enum _SephoneMediaEncryption SephoneMediaEncryption;

/**
 * Convert enum member to string.
**/
SEPHONE_PUBLIC const char *sephone_media_encryption_to_string(SephoneMediaEncryption menc);

/**
 * @}
**/


/*
 * Note for developers: this enum must be kept synchronized with the SalPrivacy enum declared in sal.h
 */
/**
 * @ingroup call_control
 * Defines privacy policy to apply as described by rfc3323
**/
typedef enum _SephonePrivacy {
	/**
	 * Privacy services must not perform any privacy function
	 */
	SephonePrivacyNone=0x0,
	/**
	 * Request that privacy services provide a user-level privacy
	 * function.
	 * With this mode, "from" header is hidden, usually replaced by  From: "Anonymous" <sip:anonymous@anonymous.invalid>
	 */
	SephonePrivacyUser=0x1,
	/**
	 * Request that privacy services modify headers that cannot
	 * be set arbitrarily by the user (Contact/Via).
	 */
	SephonePrivacyHeader=0x2,
	/**
	 *  Request that privacy services provide privacy for session
	 * media
	 */
	SephonePrivacySession=0x4,
	/**
	 * rfc3325
	 * The presence of this privacy type in
	 * a Privacy header field indicates that the user would like the Network
	 * Asserted Identity to be kept private with respect to SIP entities
	 * outside the Trust Domain with which the user authenticated.  Note
	 * that a user requesting multiple types of privacy MUST include all of
	 * the requested privacy types in its Privacy header field value
	 *
	 */
	SephonePrivacyId=0x8,
	/**
	 * Privacy service must perform the specified services or
	 * fail the request
	 *
	 **/
	SephonePrivacyCritical=0x10,

	/**
	 * Special keyword to use privacy as defined either globally or by proxy using sephone_proxy_config_set_privacy()
	 */
	SephonePrivacyDefault=0x8000,
} SephonePrivacy;
/*
 * a mask  of #SephonePrivacy values
 * */
typedef unsigned int SephonePrivacyMask;


SEPHONE_PUBLIC const char* sephone_privacy_to_string(SephonePrivacy privacy);


#ifdef IN_SEPHONE
#include "buffer.h"
#include "call_log.h"
#include "call_params.h"
#include "content.h"
#include "event.h"
#include "sephonefriend.h"
#else
#include "sephone/buffer.h"
#include "sephone/call_log.h"
#include "sephone/call_params.h"
#include "sephone/content.h"
#include "sephone/event.h"
#include "sephone/sephonefriend.h"
#endif

SEPHONE_PUBLIC	SephoneAddress * sephone_address_new(const char *addr);
SEPHONE_PUBLIC SephoneAddress * sephone_address_clone(const SephoneAddress *addr);
SEPHONE_PUBLIC SephoneAddress * sephone_address_ref(SephoneAddress *addr);
SEPHONE_PUBLIC void sephone_address_unref(SephoneAddress *addr);
SEPHONE_PUBLIC const char *sephone_address_get_scheme(const SephoneAddress *u);
SEPHONE_PUBLIC	const char *sephone_address_get_display_name(const SephoneAddress* u);
SEPHONE_PUBLIC	const char *sephone_address_get_username(const SephoneAddress *u);
SEPHONE_PUBLIC	const char *sephone_address_get_domain(const SephoneAddress *u);
SEPHONE_PUBLIC int sephone_address_get_port(const SephoneAddress *u);
SEPHONE_PUBLIC	void sephone_address_set_display_name(SephoneAddress *u, const char *display_name);
SEPHONE_PUBLIC	void sephone_address_set_username(SephoneAddress *uri, const char *username);
SEPHONE_PUBLIC	void sephone_address_set_domain(SephoneAddress *uri, const char *host);
SEPHONE_PUBLIC	void sephone_address_set_port(SephoneAddress *uri, int port);
/*remove tags, params etc... so that it is displayable to the user*/
SEPHONE_PUBLIC	void sephone_address_clean(SephoneAddress *uri);
SEPHONE_PUBLIC bool_t sephone_address_is_secure(const SephoneAddress *addr);
SEPHONE_PUBLIC bool_t sephone_address_get_secure(const SephoneAddress *addr);
SEPHONE_PUBLIC void sephone_address_set_secure(SephoneAddress *addr, bool_t enabled);
SEPHONE_PUBLIC bool_t sephone_address_is_sip(const SephoneAddress *uri);
SEPHONE_PUBLIC SephoneTransportType sephone_address_get_transport(const SephoneAddress *uri);
SEPHONE_PUBLIC void sephone_address_set_transport(SephoneAddress *uri,SephoneTransportType type);
SEPHONE_PUBLIC	char *sephone_address_as_string(const SephoneAddress *u);
SEPHONE_PUBLIC	char *sephone_address_as_string_uri_only(const SephoneAddress *u);
SEPHONE_PUBLIC	bool_t sephone_address_weak_equal(const SephoneAddress *a1, const SephoneAddress *a2);
SEPHONE_PUBLIC bool_t sephone_address_equal(const SephoneAddress *a1, const SephoneAddress *a2);
SEPHONE_PUBLIC void sephone_address_set_password(SephoneAddress *addr, const char *passwd);
SEPHONE_PUBLIC const char *sephone_address_get_password(const SephoneAddress *addr);
SEPHONE_PUBLIC void sephone_address_set_header(SephoneAddress *addr, const char *header_name, const char *header_value);
SEPHONE_PUBLIC	void sephone_address_destroy(SephoneAddress *u);

/**
 * Create a #SephoneAddress object by parsing the user supplied address, given as a string.
 * @param[in] lc #SephoneCore object
 * @param[in] address String containing the user supplied address
 * @return The create #SephoneAddress object
 * @ingroup sephone_address
 */
SEPHONE_PUBLIC SephoneAddress * sephone_core_create_address(SephoneCore *lc, const char *address);

struct _SipSetupContext;


struct _SephoneInfoMessage;
/**
 * The SephoneInfoMessage is an object representing an informational message sent or received by the core.
**/
typedef struct _SephoneInfoMessage SephoneInfoMessage;

SEPHONE_PUBLIC SephoneInfoMessage *sephone_core_create_info_message(SephoneCore*lc);
SEPHONE_PUBLIC int sephone_call_send_info_message(struct _SephoneCall *call, const SephoneInfoMessage *info);
SEPHONE_PUBLIC void sephone_info_message_add_header(SephoneInfoMessage *im, const char *name, const char *value);
SEPHONE_PUBLIC const char *sephone_info_message_get_header(const SephoneInfoMessage *im, const char *name);
SEPHONE_PUBLIC void sephone_info_message_set_content(SephoneInfoMessage *im,  const SephoneContent *content);
SEPHONE_PUBLIC const SephoneContent * sephone_info_message_get_content(const SephoneInfoMessage *im);
SEPHONE_PUBLIC void sephone_info_message_destroy(SephoneInfoMessage *im);
SEPHONE_PUBLIC SephoneInfoMessage *sephone_info_message_copy(const SephoneInfoMessage *orig);



/**
 * Structure describing policy regarding video streams establishments.
 * @ingroup media_parameters
**/
struct _SephoneVideoPolicy{
	bool_t automatically_initiate; /**<Whether video shall be automatically proposed for outgoing calls.*/
	bool_t automatically_accept; /**<Whether video shall be automatically accepted for incoming calls*/
	bool_t unused[2];
};

/**
 * Structure describing policy regarding video streams establishments.
 * @ingroup media_parameters
**/
typedef struct _SephoneVideoPolicy SephoneVideoPolicy;




/**
 * @addtogroup call_misc
 * @{
**/

#define SEPHONE_CALL_STATS_AUDIO 0
#define SEPHONE_CALL_STATS_VIDEO 1

/**
 * Enum describing ICE states.
 * @ingroup initializing
**/
enum _SephoneIceState{
	SephoneIceStateNotActivated, /**< ICE has not been activated for this call or stream*/
	SephoneIceStateFailed, /**< ICE processing has failed */
	SephoneIceStateInProgress, /**< ICE process is in progress */
	SephoneIceStateHostConnection, /**< ICE has established a direct connection to the remote host */
	SephoneIceStateReflexiveConnection, /**< ICE has established a connection to the remote host through one or several NATs */
	SephoneIceStateRelayConnection /**< ICE has established a connection through a relay */
};

/**
 * Enum describing Ice states.
 * @ingroup initializing
**/
typedef enum _SephoneIceState SephoneIceState;

SEPHONE_PUBLIC const char *sephone_ice_state_to_string(SephoneIceState state);

/**
 * Enum describing uPnP states.
 * @ingroup initializing
**/
enum _SephoneUpnpState{
	SephoneUpnpStateIdle, /**< uPnP is not activate */
	SephoneUpnpStatePending, /**< uPnP process is in progress */
	SephoneUpnpStateAdding,   /**< Internal use: Only used by port binding */
	SephoneUpnpStateRemoving, /**< Internal use: Only used by port binding */
	SephoneUpnpStateNotAvailable,  /**< uPnP is not available */
	SephoneUpnpStateOk, /**< uPnP is enabled */
	SephoneUpnpStateKo, /**< uPnP processing has failed */
	SephoneUpnpStateBlacklisted, /**< IGD router is blacklisted */
};

/**
 * Enum describing uPnP states.
 * @ingroup initializing
**/
typedef enum _SephoneUpnpState SephoneUpnpState;


#define SEPHONE_CALL_STATS_RECEIVED_RTCP_UPDATE (1 << 0) /**< received_rtcp field of SephoneCallStats object has been updated */
#define SEPHONE_CALL_STATS_SENT_RTCP_UPDATE (1 << 1) /**< sent_rtcp field of SephoneCallStats object has been updated */
#define SEPHONE_CALL_STATS_PERIODICAL_UPDATE (1 << 2) /**< Every seconds SephoneCallStats object has been updated */


/**
 * The SephoneCallStats objects carries various statistic informations regarding quality of audio or video streams.
 *
 * To receive these informations periodically and as soon as they are computed, the application is invited to place a #SephoneCoreCallStatsUpdatedCb callback in the SephoneCoreVTable structure
 * it passes for instanciating the SephoneCore object (see sephone_core_new() ).
 *
 * At any time, the application can access last computed statistics using sephone_call_get_audio_stats() or sephone_call_get_video_stats().
**/
typedef struct _SephoneCallStats SephoneCallStats;

/**
 * The SephoneCallStats objects carries various statistic informations regarding quality of audio or video streams.
 *
 * To receive these informations periodically and as soon as they are computed, the application is invited to place a #SephoneCoreCallStatsUpdatedCb callback in the SephoneCoreVTable structure
 * it passes for instantiating the SephoneCore object (see sephone_core_new() ).
 *
 * At any time, the application can access last computed statistics using sephone_call_get_audio_stats() or sephone_call_get_video_stats().
**/
struct _SephoneCallStats {
	int		type; /**< Can be either SEPHONE_CALL_STATS_AUDIO or SEPHONE_CALL_STATS_VIDEO*/
	jitter_stats_t	jitter_stats; /**<jitter buffer statistics, see oRTP documentation for details */
	mblk_t*		received_rtcp; /**<Last RTCP packet received, as a mblk_t structure. See oRTP documentation for details how to extract information from it*/
	mblk_t*		sent_rtcp;/**<Last RTCP packet sent, as a mblk_t structure. See oRTP documentation for details how to extract information from it*/
	float		round_trip_delay; /**<Round trip propagation time in seconds if known, -1 if unknown.*/
	SephoneIceState	ice_state; /**< State of ICE processing. */
	SephoneUpnpState	upnp_state; /**< State of uPnP processing. */
	uint64_t packet_sent; /*number of outgoing packets */
	uint64_t packet_recv; /* number of incoming packets */
	uint64_t outoftime; /* number of incoming packets that were received too late */
	int64_t  cum_packet_loss; /* cumulative number of incoming packet lost */
	float download_bandwidth; /**<Download bandwidth measurement of received stream, expressed in kbit/s, including IP/UDP/RTP headers*/
	float upload_bandwidth; /**<Download bandwidth measurement of sent stream, expressed in kbit/s, including IP/UDP/RTP headers*/
	float local_late_rate; /**<percentage of packet received too late over last second*/
	float local_loss_rate; /**<percentage of lost packet over last second*/
	int updated; /**< Tell which RTCP packet has been updated (received_rtcp or sent_rtcp). Can be either SEPHONE_CALL_STATS_RECEIVED_RTCP_UPDATE or SEPHONE_CALL_STATS_SENT_RTCP_UPDATE */
	float rtcp_download_bandwidth; /**<RTCP download bandwidth measurement of received stream, expressed in kbit/s, including IP/UDP/RTP headers*/
	float rtcp_upload_bandwidth; /**<RTCP download bandwidth measurement of sent stream, expressed in kbit/s, including IP/UDP/RTP headers*/
};

/**
 * @}
**/

SEPHONE_PUBLIC const SephoneCallStats *sephone_call_get_audio_stats(SephoneCall *call);
SEPHONE_PUBLIC const SephoneCallStats *sephone_call_get_video_stats(SephoneCall *call);
SEPHONE_PUBLIC float sephone_call_stats_get_sender_loss_rate(const SephoneCallStats *stats);
SEPHONE_PUBLIC float sephone_call_stats_get_receiver_loss_rate(const SephoneCallStats *stats);
SEPHONE_PUBLIC float sephone_call_stats_get_sender_interarrival_jitter(const SephoneCallStats *stats, SephoneCall *call);
SEPHONE_PUBLIC float sephone_call_stats_get_receiver_interarrival_jitter(const SephoneCallStats *stats, SephoneCall *call);
SEPHONE_PUBLIC uint64_t sephone_call_stats_get_late_packets_cumulative_number(const SephoneCallStats *stats, SephoneCall *call);
SEPHONE_PUBLIC float sephone_call_stats_get_download_bandwidth(const SephoneCallStats *stats);
SEPHONE_PUBLIC float sephone_call_stats_get_upload_bandwidth(const SephoneCallStats *stats);
SEPHONE_PUBLIC SephoneIceState sephone_call_stats_get_ice_state(const SephoneCallStats *stats);
SEPHONE_PUBLIC SephoneUpnpState sephone_call_stats_get_upnp_state(const SephoneCallStats *stats);

/** Callback prototype */
typedef void (*SephoneCallCbFunc)(SephoneCall *call,void * user_data);

/**
 * Player interface.
 * @ingroup call_control
**/
typedef struct _SephonePlayer SephonePlayer;

/**
 * Callback for notifying end of play (file).
 * @param obj the SephonePlayer
 * @param user_data the user_data provided when calling sephone_player_open().
 * @ingroup call_control
**/
typedef void (*SephonePlayerEofCallback)(struct _SephonePlayer *obj, void *user_data);

SEPHONE_PUBLIC int sephone_player_open(SephonePlayer *obj, const char *filename, SephonePlayerEofCallback, void *user_data);
SEPHONE_PUBLIC int sephone_player_start(SephonePlayer *obj);
SEPHONE_PUBLIC int sephone_player_pause(SephonePlayer *obj);
SEPHONE_PUBLIC int sephone_player_seek(SephonePlayer *obj, int time_ms);
SEPHONE_PUBLIC MSPlayerState sephone_player_get_state(SephonePlayer *obj);
SEPHONE_PUBLIC int sephone_player_get_duration(SephonePlayer *obj);
SEPHONE_PUBLIC int sephone_player_get_current_position(SephonePlayer *obj);
SEPHONE_PUBLIC void sephone_player_close(SephonePlayer *obj);
SEPHONE_PUBLIC void sephone_player_destroy(SephonePlayer *obj);

/**
 * @brief Create an independent media file player.
 * This player support WAVE and MATROSKA formats.
 * @param lc A SephoneCore object
 * @param snd_card Playback sound card. If NULL, the sound card set in SephoneCore will be used
 * @param video_out Video display. If NULL, the video display set in SephoneCore will be used
 * @param window_id Id of the drawing window. Depend of video out
 * @return A pointer on the new instance. NULL if faild.
 */
SEPHONE_PUBLIC SephonePlayer *sephone_core_create_local_player(SephoneCore *lc, MSSndCard *snd_card, const char *video_out, unsigned long window_id);

/**
 * @brief Check whether Matroksa format is supported by the player
 * @return TRUE if it is supported
 */
SEPHONE_PUBLIC bool_t sephone_local_player_matroska_supported(void);

/**
 * SephoneCallState enum represents the different state a call can reach into.
 * The application is notified of state changes through the SephoneCoreVTable::call_state_changed callback.
 * @ingroup call_control
**/
typedef enum _SephoneCallState{
	SephoneCallIdle,					/**<Initial call state */
	SephoneCallIncomingReceived, /**<This is a new incoming call */
	SephoneCallOutgoingInit, /**<An outgoing call is started */
	SephoneCallOutgoingProgress, /**<An outgoing call is in progress */
	SephoneCallOutgoingRinging, /**<An outgoing call is ringing at remote end */
	SephoneCallOutgoingEarlyMedia, /**<An outgoing call is proposed early media */
	SephoneCallConnected, /**<Connected, the call is answered */
	SephoneCallStreamsRunning, /**<The media streams are established and running*/
	SephoneCallPausing, /**<The call is pausing at the initiative of local end */
	SephoneCallPaused, /**< The call is paused, remote end has accepted the pause */
	SephoneCallResuming, /**<The call is being resumed by local end*/
	SephoneCallRefered, /**<The call is being transfered to another party, resulting in a new outgoing call to follow immediately*/
	SephoneCallError, /**<The call encountered an error*/
	SephoneCallEnd, /**<The call ended normally*/
	SephoneCallPausedByRemote, /**<The call is paused by remote end*/
	SephoneCallUpdatedByRemote, /**<The call's parameters change is requested by remote end, used for example when video is added by remote */
	SephoneCallIncomingEarlyMedia, /**<We are proposing early media to an incoming call */
	SephoneCallUpdating, /**<A call update has been initiated by us */
	SephoneCallReleased, /**< The call object is no more retained by the core */
	SephoneCallEarlyUpdatedByRemote, /*<The call is updated by remote while not yet answered (early dialog SIP UPDATE received).*/
	SephoneCallEarlyUpdating, /*<We are updating the call while not yet answered (early dialog SIP UPDATE sent)*/
	SephoneCallFirstImageDecoded, /*<First video frame decoded successfully*/
	SephoneCallVideoDecodingError /*<Video decoder got errors*/
} SephoneCallState;

SEPHONE_PUBLIC	const char *sephone_call_state_to_string(SephoneCallState cs);

/**
 * Acquire a reference to the call.
 * An application that wishes to retain a pointer to call object
 * must use this function to unsure the pointer remains
 * valid. Once the application no more needs this pointer,
 * it must call sephone_call_unref().
 * @param[in] call The call.
 * @return The same call.
 * @ingroup call_control
**/
SEPHONE_PUBLIC SephoneCall *sephone_call_ref(SephoneCall *call);

/**
 * Release reference to the call.
 * @param[in] call The call.
 * @ingroup call_control
**/
SEPHONE_PUBLIC void sephone_call_unref(SephoneCall *call);

/**
 * Retrieve the user pointer associated with the call.
 * @param[in] call The call.
 * @return The user pointer associated with the call.
 * @ingroup call_control
**/
SEPHONE_PUBLIC void *sephone_call_get_user_data(const SephoneCall *call);

/**
 * Assign a user pointer to the call.
 * @param[in] cfg The call.
 * @param[in] ud The user pointer to associate with the call.
 * @ingroup call_control
**/
SEPHONE_PUBLIC void sephone_call_set_user_data(SephoneCall *call, void *ud);

/**
 * Get the core that has created the specified call.
 * @param[in] call SephoneCall object
 * @return The SephoneCore object that has created the specified call.
 * @ingroup call_control
 */
SEPHONE_PUBLIC SephoneCore *sephone_call_get_core(const SephoneCall *call);

SEPHONE_PUBLIC	SephoneCallState sephone_call_get_state(const SephoneCall *call);
SEPHONE_PUBLIC bool_t sephone_call_asked_to_autoanswer(SephoneCall *call);

/**
 * Get the remote address of the current call.
 * @param[in] lc SephoneCore object.
 * @return The remote address of the current call or NULL if there is no current call.
 * @ingroup call_control
 */
SEPHONE_PUBLIC	const SephoneAddress * sephone_core_get_current_call_remote_address(SephoneCore *lc);

SEPHONE_PUBLIC	const SephoneAddress * sephone_call_get_remote_address(const SephoneCall *call);
SEPHONE_PUBLIC	char *sephone_call_get_remote_address_as_string(const SephoneCall *call);
SEPHONE_PUBLIC	SephoneCallDir sephone_call_get_dir(const SephoneCall *call);
SEPHONE_PUBLIC	SephoneCallLog *sephone_call_get_call_log(const SephoneCall *call);
SEPHONE_PUBLIC const char *sephone_call_get_refer_to(const SephoneCall *call);
SEPHONE_PUBLIC bool_t sephone_call_has_transfer_pending(const SephoneCall *call);
SEPHONE_PUBLIC SephoneCall *sephone_call_get_transferer_call(const SephoneCall *call);
SEPHONE_PUBLIC SephoneCall *sephone_call_get_transfer_target_call(const SephoneCall *call);
SEPHONE_PUBLIC	SephoneCall *sephone_call_get_replaced_call(SephoneCall *call);
SEPHONE_PUBLIC	int sephone_call_get_duration(const SephoneCall *call);
SEPHONE_PUBLIC	const SephoneCallParams * sephone_call_get_current_params(SephoneCall *call);
SEPHONE_PUBLIC	const SephoneCallParams * sephone_call_get_remote_params(SephoneCall *call);
SEPHONE_PUBLIC void sephone_call_enable_camera(SephoneCall *lc, bool_t enabled);
SEPHONE_PUBLIC bool_t sephone_call_camera_enabled(const SephoneCall *lc);
SEPHONE_PUBLIC int sephone_call_take_video_snapshot(SephoneCall *call, const char *file);
SEPHONE_PUBLIC int sephone_call_take_preview_snapshot(SephoneCall *call, const char *file);
SEPHONE_PUBLIC	SephoneReason sephone_call_get_reason(const SephoneCall *call);
SEPHONE_PUBLIC const SephoneErrorInfo *sephone_call_get_error_info(const SephoneCall *call);
SEPHONE_PUBLIC	const char *sephone_call_get_remote_user_agent(SephoneCall *call);
SEPHONE_PUBLIC	const char *sephone_call_get_remote_contact(SephoneCall *call);
SEPHONE_PUBLIC	float sephone_call_get_play_volume(SephoneCall *call);
SEPHONE_PUBLIC	float sephone_call_get_record_volume(SephoneCall *call);
SEPHONE_PUBLIC	float sephone_call_get_current_quality(SephoneCall *call);
SEPHONE_PUBLIC	float sephone_call_get_average_quality(SephoneCall *call);
SEPHONE_PUBLIC	const char* sephone_call_get_authentication_token(SephoneCall *call);
SEPHONE_PUBLIC	bool_t sephone_call_get_authentication_token_verified(SephoneCall *call);
SEPHONE_PUBLIC	void sephone_call_set_authentication_token_verified(SephoneCall *call, bool_t verified);
SEPHONE_PUBLIC void sephone_call_send_vfu_request(SephoneCall *call);
/** @deprecated Use sephone_call_get_user_data() instead. */
#define sephone_call_get_user_pointer(call) sephone_call_get_user_data(call)
/** @deprecated Use sephone_call_set_user_data() instead. */
#define sephone_call_set_user_pointer(call, ud) sephone_call_set_user_data(call, ud)
SEPHONE_PUBLIC	void sephone_call_set_next_video_frame_decoded_callback(SephoneCall *call, SephoneCallCbFunc cb, void* user_data);
SEPHONE_PUBLIC SephoneCallState sephone_call_get_transfer_state(SephoneCall *call);
SEPHONE_PUBLIC void sephone_call_zoom_video(SephoneCall* call, float zoom_factor, float* cx, float* cy);
SEPHONE_PUBLIC	void sephone_call_start_recording(SephoneCall *call);
SEPHONE_PUBLIC	void sephone_call_stop_recording(SephoneCall *call);
SEPHONE_PUBLIC SephonePlayer * sephone_call_get_player(SephoneCall *call);
SEPHONE_PUBLIC bool_t sephone_call_media_in_progress(SephoneCall *call);
/**
 * Send the specified dtmf.
 *
 * The dtmf is automatically played to the user.
 * @param call The SephoneCall object
 * @param dtmf The dtmf name specified as a char, such as '0', '#' etc...
 * @return 0 if successful, -1 on error.
**/
SEPHONE_PUBLIC	int sephone_call_send_dtmf(SephoneCall *lc,char dtmf);

/**
 * Send a list of dtmf.
 *
 * The dtmfs are automatically sent to remote, separated by some needed customizable delay.
 * Sending is canceled if the call state changes to something not SephoneCallStreamsRunning.
 * @param call The SephoneCall object
 * @param dtmfs A dtmf sequence such as '123#123123'
 * @return -2 if there is already a DTMF sequence, -1 if call is not ready, 0 otherwise.
**/
SEPHONE_PUBLIC	int sephone_call_send_dtmfs(SephoneCall *call,char *dtmfs);

/**
 * Stop current DTMF sequence sending.
 *
 * Please note that some DTMF could be already sent,
 * depending on when this function call is delayed from #sephone_call_send_dtmfs. This
 * function will be automatically called if call state change to anything but SephoneCallStreamsRunning.
 *
 * @param call The SephoneCall object
**/
SEPHONE_PUBLIC	void sephone_call_cancel_dtmfs(SephoneCall *call);

/**
 * Get the native window handle of the video window, casted as an unsigned long.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC unsigned long sephone_call_get_native_video_window_id(const SephoneCall *call);

/**
 * Set the native video window id where the video is to be displayed.
 * For MacOS, Linux, Windows: if not set or 0 a window will be automatically created, unless the special id -1 is given.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC void sephone_call_set_native_video_window_id(SephoneCall *call, unsigned long id);

/**
 * Return TRUE if this call is currently part of a conference
 * @param call #SephoneCall
 * @return TRUE if part of a conference.
 *
 * @deprecated
 * @ingroup call_control
 */
SEPHONE_PUBLIC	bool_t sephone_call_is_in_conference(const SephoneCall *call);
/**
 * Enables or disable echo cancellation for this call
 * @param call
 * @param val
 *
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC	void sephone_call_enable_echo_cancellation(SephoneCall *call, bool_t val) ;
/**
 * Returns TRUE if echo cancellation is enabled.
 *
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC	bool_t sephone_call_echo_cancellation_enabled(SephoneCall *lc);
/**
 * Enables or disable echo limiter for this call
 * @param call
 * @param val
 *
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC	void sephone_call_enable_echo_limiter(SephoneCall *call, bool_t val);
/**
 * Returns TRUE if echo limiter is enabled.
 *
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC	bool_t sephone_call_echo_limiter_enabled(const SephoneCall *call);

/*keep this in sync with mediastreamer2/msvolume.h*/

/**
 * Lowest volume measurement that can be returned by sephone_call_get_play_volume() or sephone_call_get_record_volume(), corresponding to pure silence.
 * @ingroup call_misc
**/
#define SEPHONE_VOLUME_DB_LOWEST (-120)

/**
 * @addtogroup proxies
 * @{
**/
/**
 * The SephoneProxyConfig object represents a proxy configuration to be used
 * by the SephoneCore object.
 * Its fields must not be used directly in favour of the accessors methods.
 * Once created and filled properly the SephoneProxyConfig can be given to
 * SephoneCore with sephone_core_add_proxy_config().
 * This will automatically triggers the registration, if enabled.
 *
 * The proxy configuration are persistent to restarts because they are saved
 * in the configuration file. As a consequence, after sephone_core_new() there
 * might already be a list of configured proxy that can be examined with
 * sephone_core_get_proxy_config_list().
 *
 * The default proxy (see sephone_core_set_default_proxy() ) is the one of the list
 * that is used by default for calls.
**/
typedef struct _SephoneProxyConfig SephoneProxyConfig;

/**
 * SephoneRegistrationState describes proxy registration states.
**/
typedef enum _SephoneRegistrationState{
	SephoneRegistrationNone, /**<Initial state for registrations */
	SephoneRegistrationProgress, /**<Registration is in progress */
	SephoneRegistrationOk,	/**< Registration is successful */
	SephoneRegistrationCleared, /**< Unregistration succeeded */
	SephoneRegistrationFailed	/**<Registration failed */
}SephoneRegistrationState;

/**
 * Human readable version of the #SephoneRegistrationState
 * @param cs sate
 */
SEPHONE_PUBLIC	const char *sephone_registration_state_to_string(SephoneRegistrationState cs);
SEPHONE_PUBLIC	SephoneProxyConfig *sephone_proxy_config_new(void);

/**
 * Acquire a reference to the proxy config.
 * @param[in] cfg The proxy config.
 * @return The same proxy config.
**/
SEPHONE_PUBLIC SephoneProxyConfig *sephone_proxy_config_ref(SephoneProxyConfig *cfg);

/**
 * Release reference to the proxy config.
 * @param[in] cfg The proxy config.
**/
SEPHONE_PUBLIC void sephone_proxy_config_unref(SephoneProxyConfig *cfg);

/**
 * Retrieve the user pointer associated with the proxy config.
 * @param[in] cfg The proxy config.
 * @return The user pointer associated with the proxy config.
**/
SEPHONE_PUBLIC void *sephone_proxy_config_get_user_data(const SephoneProxyConfig *cfg);

/**
 * Assign a user pointer to the proxy config.
 * @param[in] cfg The proxy config.
 * @param[in] ud The user pointer to associate with the proxy config.
**/
SEPHONE_PUBLIC void sephone_proxy_config_set_user_data(SephoneProxyConfig *cfg, void *ud);

SEPHONE_PUBLIC	int sephone_proxy_config_set_server_addr(SephoneProxyConfig *obj, const char *server_addr);
SEPHONE_PUBLIC	int sephone_proxy_config_set_identity(SephoneProxyConfig *obj, const char *identity);
SEPHONE_PUBLIC	int sephone_proxy_config_set_route(SephoneProxyConfig *obj, const char *route);
SEPHONE_PUBLIC	void sephone_proxy_config_set_expires(SephoneProxyConfig *obj, int expires);

#define sephone_proxy_config_expires sephone_proxy_config_set_expires
/**
 * Indicates  either or not, REGISTRATION must be issued for this #SephoneProxyConfig .
 * <br> In case this #SephoneProxyConfig has been added to #SephoneCore, follows the sephone_proxy_config_edit() rule.
 * @param obj object pointer
 * @param val if true, registration will be engaged
 */
SEPHONE_PUBLIC	void sephone_proxy_config_enable_register(SephoneProxyConfig *obj, bool_t val);
#define sephone_proxy_config_enableregister sephone_proxy_config_enable_register
SEPHONE_PUBLIC	void sephone_proxy_config_edit(SephoneProxyConfig *obj);
SEPHONE_PUBLIC	int sephone_proxy_config_done(SephoneProxyConfig *obj);
/**
 * Indicates  either or not, PUBLISH must be issued for this #SephoneProxyConfig .
 * <br> In case this #SephoneProxyConfig has been added to #SephoneCore, follows the sephone_proxy_config_edit() rule.
 * @param obj object pointer
 * @param val if true, publish will be engaged
 *
 */
SEPHONE_PUBLIC	void sephone_proxy_config_enable_publish(SephoneProxyConfig *obj, bool_t val);
/**
 * Set the publish expiration time in second.
 * @param obj proxy config
 * @param expires in second
 * */

SEPHONE_PUBLIC	void sephone_proxy_config_set_publish_expires(SephoneProxyConfig *obj, int expires);
/**
 * get the publish expiration time in second. Default value is the registration expiration value.
 * @param obj proxy config
 * @return expires in second
 * */

SEPHONE_PUBLIC	int sephone_proxy_config_get_publish_expires(const SephoneProxyConfig *obj);

SEPHONE_PUBLIC	void sephone_proxy_config_set_dial_escape_plus(SephoneProxyConfig *cfg, bool_t val);
SEPHONE_PUBLIC	void sephone_proxy_config_set_dial_prefix(SephoneProxyConfig *cfg, const char *prefix);

 /**
 * Indicates whether quality statistics during call should be stored and sent to a collector according to RFC 6035.
 * @param[in] cfg #SephoneProxyConfig object
 * @param[in] enable True to sotre quality statistics and sent them to the collector, false to disable it.
 */
SEPHONE_PUBLIC	void sephone_proxy_config_enable_quality_reporting(SephoneProxyConfig *cfg, bool_t enable);

/**
 * Indicates whether quality statistics during call should be stored and sent to a collector according to RFC 6035.
 * @param[in] cfg #SephoneProxyConfig object
 * @return True if quality repotring is enabled, false otherwise.
 */
SEPHONE_PUBLIC	bool_t sephone_proxy_config_quality_reporting_enabled(SephoneProxyConfig *cfg);

 /**
 * Set the SIP address of the collector end-point when using quality reporting. This SIP address
 * should be used on server-side to process packets directly then discard packets. Collector address
 * should be a non existing account and should not received any packets.
 * @param[in] cfg #SephoneProxyConfig object
 * @param[in] collector SIP address of the collector end-point.
 */
SEPHONE_PUBLIC	void sephone_proxy_config_set_quality_reporting_collector(SephoneProxyConfig *cfg, const char *collector);

 /**
 * Get the SIP address of the collector end-point when using quality reporting. This SIP address
 * should be used on server-side to process packets directly then discard packets. Collector address
 * should be a non existing account and should not received any packets.
 * @param[in] cfg #SephoneProxyConfig object
 * @return The SIP address of the collector end-point.
 */
SEPHONE_PUBLIC	const char *sephone_proxy_config_get_quality_reporting_collector(const SephoneProxyConfig *cfg);

/**
 * Set the interval between 2 interval reports sending when using quality reporting. If call exceed interval size, an
 * interval report will be sent to the collector. On call termination, a session report will be sent
 * for the remaining period. Value must be 0 (disabled) or positive.
 * @param[in] cfg #SephoneProxyConfig object
 * @param[in] interval The interval in seconds, 0 means interval reports are disabled.
 */
SEPHONE_PUBLIC void sephone_proxy_config_set_quality_reporting_interval(SephoneProxyConfig *cfg, uint8_t interval);

/**
 * Get the interval between interval reports when using quality reporting.
 * @param[in] cfg #SephoneProxyConfig object
 * @return The interval in seconds, 0 means interval reports are disabled.
 */

SEPHONE_PUBLIC int sephone_proxy_config_get_quality_reporting_interval(SephoneProxyConfig *cfg);

/**
 * Get the registration state of the given proxy config.
 * @param[in] obj #SephoneProxyConfig object.
 * @return The registration state of the proxy config.
**/
SEPHONE_PUBLIC	SephoneRegistrationState sephone_proxy_config_get_state(const SephoneProxyConfig *obj);

SEPHONE_PUBLIC	bool_t sephone_proxy_config_is_registered(const SephoneProxyConfig *obj);

/**
 * Get the domain name of the given proxy config.
 * @param[in] cfg #SephoneProxyConfig object.
 * @return The domain name of the proxy config.
**/
SEPHONE_PUBLIC	const char *sephone_proxy_config_get_domain(const SephoneProxyConfig *cfg);

/**
 * Get the realm of the given proxy config.
 * @param[in] cfg #SephoneProxyConfig object.
 * @return The realm of the proxy config.
**/
SEPHONE_PUBLIC	const char *sephone_proxy_config_get_realm(const SephoneProxyConfig *cfg);
/**
 * Set the realm of the given proxy config.
 * @param[in] cfg #SephoneProxyConfig object.
 * @param[in] realm New realm value.
 * @return The realm of the proxy config.
**/
SEPHONE_PUBLIC	void sephone_proxy_config_set_realm(SephoneProxyConfig *cfg, const char * realm);

SEPHONE_PUBLIC	const char *sephone_proxy_config_get_route(const SephoneProxyConfig *obj);
SEPHONE_PUBLIC	const char *sephone_proxy_config_get_identity(const SephoneProxyConfig *obj);
SEPHONE_PUBLIC	bool_t sephone_proxy_config_publish_enabled(const SephoneProxyConfig *obj);
SEPHONE_PUBLIC	const char *sephone_proxy_config_get_server_addr(const SephoneProxyConfig *obj);
#define sephone_proxy_config_get_addr sephone_proxy_config_get_server_addr
SEPHONE_PUBLIC	int sephone_proxy_config_get_expires(const SephoneProxyConfig *obj);
SEPHONE_PUBLIC	bool_t sephone_proxy_config_register_enabled(const SephoneProxyConfig *obj);
SEPHONE_PUBLIC	void sephone_proxy_config_refresh_register(SephoneProxyConfig *obj);
SEPHONE_PUBLIC void sephone_proxy_config_pause_register(SephoneProxyConfig *obj);
SEPHONE_PUBLIC	const char *sephone_proxy_config_get_contact_parameters(const SephoneProxyConfig *obj);
SEPHONE_PUBLIC	void sephone_proxy_config_set_contact_parameters(SephoneProxyConfig *obj, const char *contact_params);
SEPHONE_PUBLIC void sephone_proxy_config_set_contact_uri_parameters(SephoneProxyConfig *obj, const char *contact_uri_params);
SEPHONE_PUBLIC const char* sephone_proxy_config_get_contact_uri_parameters(const SephoneProxyConfig *obj);

/**
 * Get the #SephoneCore object to which is associated the #SephoneProxyConfig.
 * @param[in] obj #SephoneProxyConfig object.
 * @return The #SephoneCore object to which is associated the #SephoneProxyConfig.
**/
SEPHONE_PUBLIC SephoneCore * sephone_proxy_config_get_core(const SephoneProxyConfig *obj);

SEPHONE_PUBLIC	bool_t sephone_proxy_config_get_dial_escape_plus(const SephoneProxyConfig *cfg);
SEPHONE_PUBLIC	const char * sephone_proxy_config_get_dial_prefix(const SephoneProxyConfig *cfg);

/**
 * Get the reason why registration failed when the proxy config state is SephoneRegistrationFailed.
 * @param[in] cfg #SephoneProxyConfig object.
 * @return The reason why registration failed for this proxy config.
**/
SEPHONE_PUBLIC SephoneReason sephone_proxy_config_get_error(const SephoneProxyConfig *cfg);

/**
 * Get detailed information why registration failed when the proxy config state is SephoneRegistrationFailed.
 * @param[in] cfg #SephoneProxyConfig object.
 * @return The details why registration failed for this proxy config.
**/
SEPHONE_PUBLIC const SephoneErrorInfo *sephone_proxy_config_get_error_info(const SephoneProxyConfig *cfg);

/**
 * Get the transport from either service route, route or addr.
 * @param[in] cfg #SephoneProxyConfig object.
 * @return The transport as a string (I.E udp, tcp, tls, dtls)
**/
SEPHONE_PUBLIC const char* sephone_proxy_config_get_transport(const SephoneProxyConfig *cfg);


/* destruction is called automatically when removing the proxy config */
SEPHONE_PUBLIC void sephone_proxy_config_destroy(SephoneProxyConfig *cfg);
SEPHONE_PUBLIC void sephone_proxy_config_set_sip_setup(SephoneProxyConfig *cfg, const char *type);
SEPHONE_PUBLIC SipSetupContext *sephone_proxy_config_get_sip_setup_context(SephoneProxyConfig *cfg);
SEPHONE_PUBLIC SipSetup *sephone_proxy_config_get_sip_setup(SephoneProxyConfig *cfg);

/**
 * Detect if the given input is a phone number or not.
 * @param proxy #SephoneProxyConfig argument, unused yet but may contain useful data. Can be NULL.
 * @param username string to parse.
 * @return TRUE if input is a phone number, FALSE otherwise.
**/
SEPHONE_PUBLIC bool_t sephone_proxy_config_is_phone_number(SephoneProxyConfig *proxy, const char *username);

/**
 * Normalize a human readable phone number into a basic string. 888-444-222 becomes 888444222
 * or +33888444222 depending on the #SephoneProxyConfig argument. This function will always
 * generate a normalized username; if input is not a phone number, output will be a copy of input.
 * @param proxy #SephoneProxyConfig object containing country code and/or escape symbol.
 * @param username the string to parse
 * @param result the newly normalized number
 * @param result_len the size of the normalized number \a result
 * @return TRUE if a phone number was recognized, FALSE otherwise.
 */
SEPHONE_PUBLIC	bool_t sephone_proxy_config_normalize_number(SephoneProxyConfig *proxy, const char *username,
																char *result, size_t result_len);

/**
 * Set default privacy policy for all calls routed through this proxy.
 * @param cfg #SephoneProxyConfig object to be modified
 * @param privacy SephonePrivacy to configure privacy
 * */
SEPHONE_PUBLIC void sephone_proxy_config_set_privacy(SephoneProxyConfig *cfg, SephonePrivacyMask privacy);
/**
 * Get default privacy policy for all calls routed through this proxy.
 * @param cfg #SephoneProxyConfig object
 * @return Privacy mode
 * */
SEPHONE_PUBLIC SephonePrivacyMask sephone_proxy_config_get_privacy(const SephoneProxyConfig *cfg);
/**
 * Set the http file transfer server to be used for content type application/vnd.gsma.rcs-ft-http+xml
 * @param cfg #SephoneProxyConfig object to be modified
 * @param server_url URL of the file server like https://file.linphone.org/upload.php
 * */
SEPHONE_PUBLIC void sephone_proxy_config_set_file_transfer_server(SephoneProxyConfig *cfg, const char * server_url);
/**
 * Get the http file transfer server to be used for content type application/vnd.gsma.rcs-ft-http+xml
 * @param cfg #SephoneProxyConfig object
 * @return URL of the file server like https://file.linphone.org/upload.php
 * */
SEPHONE_PUBLIC const char* sephone_proxy_config_get_file_transfer_server(const SephoneProxyConfig *cfg);

/**
 * Indicates whether AVPF/SAVPF must be used for calls using this proxy config.
 * @param[in] cfg #SephoneProxyConfig object
 * @param[in] enable True to enable AVPF/SAVF, false to disable it.
 * @deprecated use sephone_proxy_config_set_avpf_mode()
 */
SEPHONE_PUBLIC void sephone_proxy_config_enable_avpf(SephoneProxyConfig *cfg, bool_t enable);

/**
 * Indicates whether AVPF/SAVPF is being used for calls using this proxy config.
 * @param[in] cfg #SephoneProxyConfig object
 * @return True if AVPF/SAVPF is enabled, false otherwise.
 * @deprecated use sephone_proxy_config_set_avpf_mode()
 */
SEPHONE_PUBLIC bool_t sephone_proxy_config_avpf_enabled(SephoneProxyConfig *cfg);

/**
 * Set the interval between regular RTCP reports when using AVPF/SAVPF.
 * @param[in] cfg #SephoneProxyConfig object
 * @param[in] interval The interval in seconds (between 0 and 5 seconds).
 */
SEPHONE_PUBLIC void sephone_proxy_config_set_avpf_rr_interval(SephoneProxyConfig *cfg, uint8_t interval);

/**
 * Get the interval between regular RTCP reports when using AVPF/SAVPF.
 * @param[in] cfg #SephoneProxyConfig object
 * @return The interval in seconds.
 */
SEPHONE_PUBLIC uint8_t sephone_proxy_config_get_avpf_rr_interval(const SephoneProxyConfig *cfg);

/**
 * Get enablement status of RTCP feedback (also known as AVPF profile).
 * @param[in] cfg the proxy config
 * @return the enablement mode, which can be SephoneAVPFDefault (use SephoneCore's mode), SephoneAVPFEnabled (avpf is enabled), or SephoneAVPFDisabled (disabled).
**/
SEPHONE_PUBLIC SephoneAVPFMode sephone_proxy_config_get_avpf_mode(const SephoneProxyConfig *cfg);

/**
 * Enable the use of RTCP feedback (also known as AVPF profile).
 * @param[in] cfg the proxy config
 * @param[in] mode the enablement mode, which can be SephoneAVPFDefault (use SephoneCore's mode), SephoneAVPFEnabled (avpf is enabled), or SephoneAVPFDisabled (disabled).
**/
SEPHONE_PUBLIC void sephone_proxy_config_set_avpf_mode(SephoneProxyConfig *cfg, SephoneAVPFMode mode);

/**
 * Obtain the value of a header sent by the server in last answer to REGISTER.
 * @param cfg the proxy config object
 * @param header_name the header name for which to fetch corresponding value
 * @return the value of the queried header.
**/
SEPHONE_PUBLIC const char *sephone_proxy_config_get_custom_header(SephoneProxyConfig *cfg, const char *header_name);

/**
 * Set the value of a custom header sent to the server in REGISTERs request.
 * @param cfg the proxy config object
 * @param header_name the header name
 * @param header_value the header's value
**/
SEPHONE_PUBLIC void sephone_proxy_config_set_custom_header(SephoneProxyConfig *cfg, const char *header_name, const char *header_value);
/**
 * @}
**/

typedef struct _SephoneAccountCreator{
	SephoneCore *lc;
	struct _SipSetupContext *ssctx;
	char *username;
	char *password;
	char *domain;
	char *route;
	char *email;
	int suscribe;
	bool_t succeeded;
}SephoneAccountCreator;

SEPHONE_PUBLIC SephoneAccountCreator *sephone_account_creator_new(SephoneCore *core, const char *type);
SEPHONE_PUBLIC void sephone_account_creator_set_username(SephoneAccountCreator *obj, const char *username);
SEPHONE_PUBLIC void sephone_account_creator_set_password(SephoneAccountCreator *obj, const char *password);
SEPHONE_PUBLIC void sephone_account_creator_set_domain(SephoneAccountCreator *obj, const char *domain);
SEPHONE_PUBLIC void sephone_account_creator_set_route(SephoneAccountCreator *obj, const char *route);
SEPHONE_PUBLIC void sephone_account_creator_set_email(SephoneAccountCreator *obj, const char *email);
SEPHONE_PUBLIC void sephone_account_creator_set_suscribe(SephoneAccountCreator *obj, int suscribre);
SEPHONE_PUBLIC const char * sephone_account_creator_get_username(SephoneAccountCreator *obj);
SEPHONE_PUBLIC const char * sephone_account_creator_get_domain(SephoneAccountCreator *obj);
SEPHONE_PUBLIC int sephone_account_creator_test_existence(SephoneAccountCreator *obj);
SEPHONE_PUBLIC int sephone_account_creator_test_validation(SephoneAccountCreator *obj);
SEPHONE_PUBLIC SephoneProxyConfig * sephone_account_creator_validate(SephoneAccountCreator *obj);
SEPHONE_PUBLIC void sephone_account_creator_destroy(SephoneAccountCreator *obj);

struct _SephoneAuthInfo;

/**
 * @addtogroup authentication
 * @{
 * Object holding authentication information.
 *
 * @note The object's fields should not be accessed directly. Prefer using
 * the accessor methods.
 *
 * In most case, authentication information consists of a username and password.
 * Sometimes, a userid is required by proxy, and realm can be useful to discriminate
 * different SIP domains.
 *
 * Once created and filled, a SephoneAuthInfo must be added to the SephoneCore in
 * order to become known and used automatically when needed.
 * Use sephone_core_add_auth_info() for that purpose.
 *
 * The SephoneCore object can take the initiative to request authentication information
 * when needed to the application through the auth_info_requested callback of the
 * SephoneCoreVTable structure.
 *
 * The application can respond to this information request later using
 * sephone_core_add_auth_info(). This will unblock all pending authentication
 * transactions and retry them with authentication headers.
 *
**/
typedef struct _SephoneAuthInfo SephoneAuthInfo;

/**
 * Creates a #SephoneAuthInfo object with supplied information.
 * The object can be created empty, that is with all arguments set to NULL.
 * Username, userid, password, realm and domain can be set later using specific methods.
 * At the end, username and passwd (or ha1) are required.
 * @param username The username that needs to be authenticated
 * @param userid The userid used for authenticating (use NULL if you don't know what it is)
 * @param passwd The password in clear text
 * @param ha1 The ha1-encrypted password if password is not given in clear text.
 * @param realm The authentication domain (which can be larger than the sip domain. Unfortunately many SIP servers don't use this parameter.
 * @param domain The SIP domain for which this authentication information is valid, if it has to be restricted for a single SIP domain.
 * @return A #SephoneAuthInfo object. sephone_auth_info_destroy() must be used to destroy it when no longer needed. The SephoneCore makes a copy of SephoneAuthInfo
 * passed through sephone_core_add_auth_info().
**/
SEPHONE_PUBLIC	SephoneAuthInfo *sephone_auth_info_new(const char *username, const char *userid,
	const char *passwd, const char *ha1,const char *realm, const char *domain);

/**
 * @addtogroup authentication
 * Instantiates a new auth info with values from source.
 * @param[in] source The #SephoneAuthInfo object to be cloned
 * @return The newly created #SephoneAuthInfo object.
 */
SEPHONE_PUBLIC	SephoneAuthInfo *sephone_auth_info_clone(const SephoneAuthInfo* source);

/**
 * Sets the password.
 * @param[in] info The #SephoneAuthInfo object
 * @param[in] passwd The password.
**/
SEPHONE_PUBLIC void sephone_auth_info_set_passwd(SephoneAuthInfo *info, const char *passwd);

/**
 * Sets the username.
 * @param[in] info The #SephoneAuthInfo object
 * @param[in] username The username.
**/
SEPHONE_PUBLIC void sephone_auth_info_set_username(SephoneAuthInfo *info, const char *username);

/**
 * Sets the userid.
 * @param[in] info The #SephoneAuthInfo object
 * @param[in] userid The userid.
**/
SEPHONE_PUBLIC void sephone_auth_info_set_userid(SephoneAuthInfo *info, const char *userid);

/**
 * Sets the realm.
 * @param[in] info The #SephoneAuthInfo object
 * @param[in] realm The realm.
**/
SEPHONE_PUBLIC void sephone_auth_info_set_realm(SephoneAuthInfo *info, const char *realm);

/**
 * Sets the domain for which this authentication is valid.
 * @param[in] info The #SephoneAuthInfo object
 * @param[in] domain The domain.
 * This should not be necessary because realm is supposed to be unique and sufficient.
 * However, many SIP servers don't set realm correctly, then domain has to be used to distinguish between several SIP account bearing the same username.
**/
SEPHONE_PUBLIC void sephone_auth_info_set_domain(SephoneAuthInfo *info, const char *domain);

/**
 * Sets the ha1.
 * @param[in] info The #SephoneAuthInfo object
 * @param[in] ha1 The ha1.
**/
SEPHONE_PUBLIC void sephone_auth_info_set_ha1(SephoneAuthInfo *info, const char *ha1);

/**
 * Gets the username.
 *
 * @param[in] info The #SephoneAuthInfo object
 * @return The username.
 */
SEPHONE_PUBLIC const char *sephone_auth_info_get_username(const SephoneAuthInfo *info);

/**
 * Gets the password.
 *
 * @param[in] info The #SephoneAuthInfo object
 * @return The password.
 */
SEPHONE_PUBLIC const char *sephone_auth_info_get_passwd(const SephoneAuthInfo *info);

/**
 * Gets the userid.
 *
 * @param[in] info The #SephoneAuthInfo object
 * @return The userid.
 */
SEPHONE_PUBLIC const char *sephone_auth_info_get_userid(const SephoneAuthInfo *info);

/**
 * Gets the realm.
 *
 * @param[in] info The #SephoneAuthInfo object
 * @return The realm.
 */
SEPHONE_PUBLIC const char *sephone_auth_info_get_realm(const SephoneAuthInfo *info);

/**
 * Gets the domain.
 *
 * @param[in] info The #SephoneAuthInfo object
 * @return The domain.
 */
SEPHONE_PUBLIC const char *sephone_auth_info_get_domain(const SephoneAuthInfo *info);

/**
 * Gets the ha1.
 *
 * @param[in] info The #SephoneAuthInfo object
 * @return The ha1.
 */
SEPHONE_PUBLIC const char *sephone_auth_info_get_ha1(const SephoneAuthInfo *info);

/* you don't need those function*/
SEPHONE_PUBLIC void sephone_auth_info_destroy(SephoneAuthInfo *info);
SEPHONE_PUBLIC SephoneAuthInfo * sephone_auth_info_new_from_config_file(SpConfig *config, int pos);

/**
 * @}
 */


struct _SephoneChatRoom;
/**
 * @addtogroup chatroom
 * @{
 */

/**
 * An object to handle the callbacks for the handling a SephoneChatMessage objects.
 */
typedef struct _SephoneChatMessageCbs SephoneChatMessageCbs;

/**
 * A chat room message to hold content to be sent.
 * <br> Can be created by sephone_chat_room_create_message().
 */
typedef struct _SephoneChatMessage SephoneChatMessage;

/**
 * A chat room is the place where text messages are exchanged.
 * <br> Can be created by sephone_core_create_chat_room().
 */
typedef struct _SephoneChatRoom SephoneChatRoom;

/**
 * SephoneChatMessageState is used to notify if messages have been succesfully delivered or not.
 */
typedef enum _SephoneChatMessageState {
	SephoneChatMessageStateIdle, /**< Initial state */
	SephoneChatMessageStateInProgress, /**< Delivery in progress */
	SephoneChatMessageStateDelivered, /**< Message successfully delivered and acknowledged by remote end point */
	SephoneChatMessageStateNotDelivered, /**< Message was not delivered */
	SephoneChatMessageStateFileTransferError, /**< Message was received(and acknowledged) but cannot get file from server */
	SephoneChatMessageStateFileTransferDone /**< File transfer has been completed successfully. */
} SephoneChatMessageState;

/**
 * Call back used to notify message delivery status
 * @param msg #SephoneChatMessage object
 * @param status SephoneChatMessageState
 * @param ud application user data
 * @deprecated
 */
typedef void (*SephoneChatMessageStateChangedCb)(SephoneChatMessage* msg,SephoneChatMessageState state,void* ud);

/**
 * Call back used to notify message delivery status
 * @param msg #SephoneChatMessage object
 * @param status SephoneChatMessageState
 */
typedef void (*SephoneChatMessageCbsMsgStateChangedCb)(SephoneChatMessage* msg, SephoneChatMessageState state);

/**
 * File transfer receive callback prototype. This function is called by the core upon an incoming File transfer is started. This function may be call several time for the same file in case of large file.
 * @param message #SephoneChatMessage message from which the body is received.
 * @param content #SephoneContent incoming content information
 * @param buffer #SephoneBuffer holding the received data. Empty buffer means end of file.
 */
typedef void (*SephoneChatMessageCbsFileTransferRecvCb)(SephoneChatMessage *message, const SephoneContent* content, const SephoneBuffer *buffer);

/**
 * File transfer send callback prototype. This function is called by the core when an outgoing file transfer is started. This function is called until size is set to 0.
 * @param message #SephoneChatMessage message from which the body is received.
 * @param content #SephoneContent outgoing content
 * @param offset the offset in the file from where to get the data to be sent
 * @param size the number of bytes expected by the framework
 * @return A SephoneBuffer object holding the data written by the application. An empty buffer means end of file.
 */
typedef SephoneBuffer * (*SephoneChatMessageCbsFileTransferSendCb)(SephoneChatMessage *message,  const SephoneContent* content, size_t offset, size_t size);

/**
 * File transfer progress indication callback prototype.
 * @param message #SephoneChatMessage message from which the body is received.
 * @param content #SephoneContent incoming content information
 * @param offset The number of bytes sent/received since the beginning of the transfer.
 * @param total The total number of bytes to be sent/received.
 */
typedef void (*SephoneChatMessageCbsFileTransferProgressIndicationCb)(SephoneChatMessage *message, const SephoneContent* content, size_t offset, size_t total);

SEPHONE_PUBLIC void sephone_core_set_chat_database_path(SephoneCore *lc, const char *path);
SEPHONE_PUBLIC	SephoneChatRoom * sephone_core_create_chat_room(SephoneCore *lc, const char *to);
SEPHONE_PUBLIC	SephoneChatRoom * sephone_core_get_or_create_chat_room(SephoneCore *lc, const char *to);
SEPHONE_PUBLIC SephoneChatRoom *sephone_core_get_chat_room(SephoneCore *lc, const SephoneAddress *addr);
SEPHONE_PUBLIC SephoneChatRoom *sephone_core_get_chat_room_from_uri(SephoneCore *lc, const char *to);
SEPHONE_PUBLIC void sephone_core_disable_chat(SephoneCore *lc, SephoneReason deny_reason);
SEPHONE_PUBLIC void sephone_core_enable_chat(SephoneCore *lc);
SEPHONE_PUBLIC bool_t sephone_core_chat_enabled(const SephoneCore *lc);
SEPHONE_PUBLIC void sephone_chat_room_destroy(SephoneChatRoom *cr);
SEPHONE_PUBLIC	SephoneChatMessage* sephone_chat_room_create_message(SephoneChatRoom *cr,const char* message);
SEPHONE_PUBLIC	SephoneChatMessage* sephone_chat_room_create_message_2(SephoneChatRoom *cr, const char* message, const char* external_body_url, SephoneChatMessageState state, time_t time, bool_t is_read, bool_t is_incoming);

/**
 * Acquire a reference to the chat room.
 * @param[in] cr The chat room.
 * @return The same chat room.
**/
SEPHONE_PUBLIC SephoneChatRoom *sephone_chat_room_ref(SephoneChatRoom *cr);

/**
 * Release reference to the chat room.
 * @param[in] cr The chat room.
**/
SEPHONE_PUBLIC void sephone_chat_room_unref(SephoneChatRoom *cr);

/**
 * Retrieve the user pointer associated with the chat room.
 * @param[in] cr The chat room.
 * @return The user pointer associated with the chat room.
**/
SEPHONE_PUBLIC void *sephone_chat_room_get_user_data(const SephoneChatRoom *cr);

/**
 * Assign a user pointer to the chat room.
 * @param[in] cr The chat room.
 * @param[in] ud The user pointer to associate with the chat room.
**/
SEPHONE_PUBLIC void sephone_chat_room_set_user_data(SephoneChatRoom *cr, void *ud);

/**
 * Create a message attached to a dedicated chat room with a particular content. Use #sephone_chat_room_file_transfer_send to initiate the transfer
 * @param[in] cr the chat room.
 * @param[in] initial_content #SephoneContent initial content. #SephoneCoreVTable.file_transfer_send is invoked later to notify file transfer progress and collect next chunk of the message if #SephoneContentSourceType.src_type is set to SEPHONE_CONTENT_SOURCE_CHUNKED_BUFFER.
 * @return a new #SephoneChatMessage
 */
SEPHONE_PUBLIC	SephoneChatMessage* sephone_chat_room_create_file_transfer_message(SephoneChatRoom *cr, SephoneContent* initial_content);

SEPHONE_PUBLIC	const SephoneAddress* sephone_chat_room_get_peer_address(SephoneChatRoom *cr);
SEPHONE_PUBLIC	void sephone_chat_room_send_message(SephoneChatRoom *cr, const char *msg);
SEPHONE_PUBLIC	void sephone_chat_room_send_message2(SephoneChatRoom *cr, SephoneChatMessage* msg,SephoneChatMessageStateChangedCb status_cb,void* ud);
SEPHONE_PUBLIC void sephone_chat_room_send_chat_message(SephoneChatRoom *cr, SephoneChatMessage *msg);
SEPHONE_PUBLIC void sephone_chat_room_update_url(SephoneChatRoom *cr, SephoneChatMessage *msg);
SEPHONE_PUBLIC MSList *sephone_chat_room_get_history(SephoneChatRoom *cr,int nb_message);

/**
 * Mark all messages of the conversation as read
 * @param[in] cr The #SephoneChatRoom object corresponding to the conversation.
 */
SEPHONE_PUBLIC void sephone_chat_room_mark_as_read(SephoneChatRoom *cr);
/**
 * Delete a message from the chat room history.
 * @param[in] cr The #SephoneChatRoom object corresponding to the conversation.
 * @param[in] msg The #SephoneChatMessage object to remove.
 */

SEPHONE_PUBLIC void sephone_chat_room_delete_message(SephoneChatRoom *cr, SephoneChatMessage *msg);
/**
 * Delete all messages from the history
 * @param[in] cr The #SephoneChatRoom object corresponding to the conversation.
 */
SEPHONE_PUBLIC void sephone_chat_room_delete_history(SephoneChatRoom *cr);
/**
 * Gets the number of messages in a chat room.
 * @param[in] cr The #SephoneChatRoom object corresponding to the conversation for which size has to be computed
 * @return the number of messages.
 */
SEPHONE_PUBLIC int sephone_chat_room_get_history_size(SephoneChatRoom *cr);

/**
 * Gets the partial list of messages in the given range, sorted from oldest to most recent.
 * @param[in] cr The #SephoneChatRoom object corresponding to the conversation for which messages should be retrieved
 * @param[in] begin The first message of the range to be retrieved. History most recent message has index 0.
 * @param[in] end The last message of the range to be retrieved. History oldest message has index of history size - 1 (use #sephone_chat_room_get_history_size to retrieve history size)
 * @return \mslist{SephoneChatMessage}
 */
SEPHONE_PUBLIC MSList *sephone_chat_room_get_history_range(SephoneChatRoom *cr, int begin, int end);

/**
 * Notifies the destination of the chat message being composed that the user is typing a new message.
 * @param[in] cr The #SephoneChatRoom object corresponding to the conversation for which a new message is being typed.
 */
SEPHONE_PUBLIC void sephone_chat_room_compose(SephoneChatRoom *cr);

/**
 * Tells whether the remote is currently composing a message.
 * @param[in] cr The "SephoneChatRoom object corresponding to the conversation.
 * @return TRUE if the remote is currently composing a message, FALSE otherwise.
 */
SEPHONE_PUBLIC bool_t sephone_chat_room_is_remote_composing(const SephoneChatRoom *cr);

/**
 * Gets the number of unread messages in the chatroom.
 * @param[in] cr The "SephoneChatRoom object corresponding to the conversation.
 * @return the number of unread messages.
 */
SEPHONE_PUBLIC int sephone_chat_room_get_unread_messages_count(SephoneChatRoom *cr);
SEPHONE_PUBLIC SephoneCore* sephone_chat_room_get_lc(SephoneChatRoom *cr);
SEPHONE_PUBLIC SephoneCore* sephone_chat_room_get_core(SephoneChatRoom *cr);
SEPHONE_PUBLIC MSList* sephone_core_get_chat_rooms(SephoneCore *lc);
SEPHONE_PUBLIC unsigned int sephone_chat_message_store(SephoneChatMessage *msg);

SEPHONE_PUBLIC	const char* sephone_chat_message_state_to_string(const SephoneChatMessageState state);
SEPHONE_PUBLIC	SephoneChatMessageState sephone_chat_message_get_state(const SephoneChatMessage* message);
SEPHONE_PUBLIC SephoneChatMessage* sephone_chat_message_clone(const SephoneChatMessage* message);
SEPHONE_PUBLIC SephoneChatMessage * sephone_chat_message_ref(SephoneChatMessage *msg);
SEPHONE_PUBLIC void sephone_chat_message_unref(SephoneChatMessage *msg);
SEPHONE_PUBLIC void sephone_chat_message_destroy(SephoneChatMessage* msg);
/** @deprecated Use sephone_chat_message_set_from_address() instead. */
#define sephone_chat_message_set_from(msg, addr) sephone_chat_message_set_from_address(msg, addr)
SEPHONE_PUBLIC void sephone_chat_message_set_from_address(SephoneChatMessage* message, const SephoneAddress* addr);
/** @deprecated Use sephone_chat_message_get_from_address() instead. */
#define sephone_chat_message_get_from(msg) sephone_chat_message_get_from_address(msg)
SEPHONE_PUBLIC	const SephoneAddress* sephone_chat_message_get_from_address(const SephoneChatMessage* message);
#define sephone_chat_message_set_to(msg, addr) sephone_chat_message_set_to_address(msg, addr)
SEPHONE_PUBLIC void sephone_chat_message_set_to_address(SephoneChatMessage* message, const SephoneAddress* addr);
/** @deprecated Use sephone_chat_message_get_to_address() instead. */
#define sephone_chat_message_get_to(msg) sephone_chat_message_get_to_address(msg)
SEPHONE_PUBLIC	const SephoneAddress* sephone_chat_message_get_to_address(const SephoneChatMessage* message);
SEPHONE_PUBLIC	const char* sephone_chat_message_get_external_body_url(const SephoneChatMessage* message);
SEPHONE_PUBLIC	void sephone_chat_message_set_external_body_url(SephoneChatMessage* message,const char* url);
SEPHONE_PUBLIC	const SephoneContent* sephone_chat_message_get_file_transfer_information(const SephoneChatMessage* message);
SEPHONE_PUBLIC void sephone_chat_message_start_file_download(SephoneChatMessage* message, SephoneChatMessageStateChangedCb status_cb, void* ud);
SEPHONE_PUBLIC void sephone_chat_message_download_file(SephoneChatMessage *message);
SEPHONE_PUBLIC void sephone_chat_message_cancel_file_transfer(SephoneChatMessage* msg);
SEPHONE_PUBLIC	const char* sephone_chat_message_get_appdata(const SephoneChatMessage* message);
SEPHONE_PUBLIC	void sephone_chat_message_set_appdata(SephoneChatMessage* message, const char* data);
SEPHONE_PUBLIC	const char* sephone_chat_message_get_text(const SephoneChatMessage* message);
SEPHONE_PUBLIC	time_t sephone_chat_message_get_time(const SephoneChatMessage* message);
SEPHONE_PUBLIC	void* sephone_chat_message_get_user_data(const SephoneChatMessage* message);
SEPHONE_PUBLIC	void sephone_chat_message_set_user_data(SephoneChatMessage* message,void*);
SEPHONE_PUBLIC SephoneChatRoom* sephone_chat_message_get_chat_room(SephoneChatMessage *msg);
SEPHONE_PUBLIC	const SephoneAddress* sephone_chat_message_get_peer_address(SephoneChatMessage *msg);
SEPHONE_PUBLIC	SephoneAddress *sephone_chat_message_get_local_address(const SephoneChatMessage* message);
SEPHONE_PUBLIC	void sephone_chat_message_add_custom_header(SephoneChatMessage* message, const char *header_name, const char *header_value);
SEPHONE_PUBLIC	const char * sephone_chat_message_get_custom_header(SephoneChatMessage* message, const char *header_name);
SEPHONE_PUBLIC bool_t sephone_chat_message_is_read(SephoneChatMessage* message);
SEPHONE_PUBLIC bool_t sephone_chat_message_is_outgoing(SephoneChatMessage* message);
SEPHONE_PUBLIC unsigned int sephone_chat_message_get_storage_id(SephoneChatMessage* message);
SEPHONE_PUBLIC SephoneReason sephone_chat_message_get_reason(SephoneChatMessage* msg);
SEPHONE_PUBLIC const SephoneErrorInfo *sephone_chat_message_get_error_info(const SephoneChatMessage *msg);
SEPHONE_PUBLIC void sephone_chat_message_set_file_transfer_filepath(SephoneChatMessage *msg, const char *filepath);
SEPHONE_PUBLIC const char * sephone_chat_message_get_file_transfer_filepath(SephoneChatMessage *msg);
SEPHONE_PUBLIC SephoneChatMessageCbs * sephone_chat_message_get_callbacks(const SephoneChatMessage *msg);

SEPHONE_PUBLIC SephoneChatMessageCbs * sephone_chat_message_cbs_ref(SephoneChatMessageCbs *cbs);
SEPHONE_PUBLIC void sephone_chat_message_cbs_unref(SephoneChatMessageCbs *cbs);
SEPHONE_PUBLIC void *sephone_chat_message_cbs_get_user_data(const SephoneChatMessageCbs *cbs);
SEPHONE_PUBLIC void sephone_chat_message_cbs_set_user_data(SephoneChatMessageCbs *cbs, void *ud);
SEPHONE_PUBLIC SephoneChatMessageCbsMsgStateChangedCb sephone_chat_message_cbs_get_msg_state_changed(const SephoneChatMessageCbs *cbs);
SEPHONE_PUBLIC void sephone_chat_message_cbs_set_msg_state_changed(SephoneChatMessageCbs *cbs, SephoneChatMessageCbsMsgStateChangedCb cb);
SEPHONE_PUBLIC SephoneChatMessageCbsFileTransferRecvCb sephone_chat_message_cbs_get_file_transfer_recv(const SephoneChatMessageCbs *cbs);
SEPHONE_PUBLIC void sephone_chat_message_cbs_set_file_transfer_recv(SephoneChatMessageCbs *cbs, SephoneChatMessageCbsFileTransferRecvCb cb);
SEPHONE_PUBLIC SephoneChatMessageCbsFileTransferSendCb sephone_chat_message_cbs_get_file_transfer_send(const SephoneChatMessageCbs *cbs);
SEPHONE_PUBLIC void sephone_chat_message_cbs_set_file_transfer_send(SephoneChatMessageCbs *cbs, SephoneChatMessageCbsFileTransferSendCb cb);
SEPHONE_PUBLIC SephoneChatMessageCbsFileTransferProgressIndicationCb sephone_chat_message_cbs_get_file_transfer_progress_indication(const SephoneChatMessageCbs *cbs);
SEPHONE_PUBLIC void sephone_chat_message_cbs_set_file_transfer_progress_indication(SephoneChatMessageCbs *cbs, SephoneChatMessageCbsFileTransferProgressIndicationCb cb);

/**
 * @}
 */


/**
 * @addtogroup initializing
 * @{
**/

/**
 * SephoneGlobalState describes the global state of the SephoneCore object.
 * It is notified via the SephoneCoreVTable::global_state_changed
**/
typedef enum _SephoneGlobalState{
	SephoneGlobalOff,
	SephoneGlobalStartup,
	SephoneGlobalOn,
	SephoneGlobalShutdown,
	SephoneGlobalConfiguring
}SephoneGlobalState;

SEPHONE_PUBLIC const char *sephone_global_state_to_string(SephoneGlobalState gs);

/**
 * SephoneCoreLogCollectionUploadState is used to notify if log collection upload have been succesfully delivered or not.
 */
typedef enum _SephoneCoreLogCollectionUploadState {
	SephoneCoreLogCollectionUploadStateInProgress, /**< Delivery in progress */
	SephoneCoreLogCollectionUploadStateDelivered, /**< Log collection upload successfully delivered and acknowledged by remote end point */
	SephoneCoreLogCollectionUploadStateNotDelivered, /**< Log collection upload was not delivered */
} SephoneCoreLogCollectionUploadState;

/**
 * Global state notification callback.
 * @param lc
 * @param gstate the global state
 * @param message informational message.
 */
typedef void (*SephoneCoreGlobalStateChangedCb)(SephoneCore *lc, SephoneGlobalState gstate, const char *message);
/**
 * Call state notification callback.
 * @param lc the SephoneCore
 * @param call the call object whose state is changed.
 * @param cstate the new state of the call
 * @param message an informational message about the state.
 */
typedef void (*SephoneCoreCallStateChangedCb)(SephoneCore *lc, SephoneCall *call, SephoneCallState cstate, const char *message);

/**
 * Call encryption changed callback.
 * @param lc the SephoneCore
 * @param call the call on which encryption is changed.
 * @param on whether encryption is activated.
 * @param authentication_token an authentication_token, currently set for ZRTP kind of encryption only.
 */
typedef void (*SephoneCoreCallEncryptionChangedCb)(SephoneCore *lc, SephoneCall *call, bool_t on, const char *authentication_token);

/** @ingroup Proxies
 * Registration state notification callback prototype
 * */
typedef void (*SephoneCoreRegistrationStateChangedCb)(SephoneCore *lc, SephoneProxyConfig *cfg, SephoneRegistrationState cstate, const char *message);
/** Callback prototype
 * @deprecated
 */
typedef void (*ShowInterfaceCb)(SephoneCore *lc);
/** Callback prototype
 * @deprecated
 */
typedef void (*DisplayStatusCb)(SephoneCore *lc, const char *message);
/** Callback prototype
 * @deprecated
 */
typedef void (*DisplayMessageCb)(SephoneCore *lc, const char *message);
/** Callback prototype
 * @deprecated
 */
typedef void (*DisplayUrlCb)(SephoneCore *lc, const char *message, const char *url);
/** Callback prototype
 */
typedef void (*SephoneCoreCbFunc)(SephoneCore *lc,void * user_data);
/**
 * Report status change for a friend previously \link sephone_core_add_friend() added \endlink to #SephoneCore.
 * @param lc #SephoneCore object .
 * @param lf Updated #SephoneFriend .
 */
typedef void (*SephoneCoreNotifyPresenceReceivedCb)(SephoneCore *lc, SephoneFriend * lf);
/**
 *  Reports that a new subscription request has been received and wait for a decision.
 *  Status on this subscription request is notified by \link sephone_friend_set_inc_subscribe_policy() changing policy \endlink for this friend
 * @param lc #SephoneCore object
 * @param lf #SephoneFriend corresponding to the subscriber
 * @param url of the subscriber
 *  Callback prototype
 */
typedef void (*SephoneCoreNewSubscriptionRequestedCb)(SephoneCore *lc, SephoneFriend *lf, const char *url);
/**
 * Callback for requesting authentication information to application or user.
 * @param lc the SephoneCore
 * @param realm the realm (domain) on which authentication is required.
 * @param username the username that needs to be authenticated.
 * Application shall reply to this callback using sephone_core_add_auth_info().
 */
typedef void (*SephoneCoreAuthInfoRequestedCb)(SephoneCore *lc, const char *realm, const char *username, const char *domain);

/**
 * Callback to notify a new call-log entry has been added.
 * This is done typically when a call terminates.
 * @param lc the SephoneCore
 * @param newcl the new call log entry added.
 */
typedef void (*SephoneCoreCallLogUpdatedCb)(SephoneCore *lc, SephoneCallLog *newcl);

/**
 * Callback prototype
 * @deprecated use #SephoneCoreMessageReceivedCb instead.
 *
 * @param lc #SephoneCore object
 * @param room #SephoneChatRoom involved in this conversation. Can be be created by the framework in case \link #SephoneAddress the from \endlink is not present in any chat room.
 * @param from #SephoneAddress from
 * @param message incoming message
 */
typedef void (*SephoneCoreTextMessageReceivedCb)(SephoneCore *lc, SephoneChatRoom *room, const SephoneAddress *from, const char *message);

/**
 * Chat message callback prototype
 *
 * @param lc #SephoneCore object
 * @param room #SephoneChatRoom involved in this conversation. Can be be created by the framework in case \link #SephoneAddress the from \endlink is not present in any chat room.
 * @param SephoneChatMessage incoming message
 */
typedef void (*SephoneCoreMessageReceivedCb)(SephoneCore *lc, SephoneChatRoom *room, SephoneChatMessage *message);

/**
 * File transfer receive callback prototype. This function is called by the core upon an incoming File transfer is started. This function may be call several time for the same file in case of large file.
 *
 *
 * @param lc #SephoneCore object
 * @param message #SephoneChatMessage message from which the body is received.
 * @param content #SephoneContent incoming content information
 * @param buff pointer to the received data
 * @param size number of bytes to be read from buff. 0 means end of file.
 *
 */
typedef void (*SephoneCoreFileTransferRecvCb)(SephoneCore *lc, SephoneChatMessage *message, const SephoneContent* content, const char* buff, size_t size);

/**
 * File transfer send callback prototype. This function is called by the core upon an outgoing File transfer is started. This function is called until size is set to 0.
 * <br> a #SephoneContent with a size equal zero
 *
 * @param lc #SephoneCore object
 * @param message #SephoneChatMessage message from which the body is received.
 * @param content #SephoneContent outgoing content
 * @param buff pointer to the buffer where data chunk shall be written by the app
 * @param size as input value, it represents the number of bytes expected by the framework. As output value, it means the number of bytes wrote by the application in the buffer. 0 means end of file.
 *
 */
typedef void (*SephoneCoreFileTransferSendCb)(SephoneCore *lc, SephoneChatMessage *message,  const SephoneContent* content, char* buff, size_t* size);

/**
 * File transfer progress indication callback prototype.
 *
 * @param lc #SephoneCore object
 * @param message #SephoneChatMessage message from which the body is received.
 * @param content #SephoneContent incoming content information
 * @param offset The number of bytes sent/received since the beginning of the transfer.
 * @param total The total number of bytes to be sent/received.
 */
typedef void (*SephoneCoreFileTransferProgressIndicationCb)(SephoneCore *lc, SephoneChatMessage *message, const SephoneContent* content, size_t offset, size_t total);

/**
 * Is composing notification callback prototype.
 *
 * @param[in] lc #SephoneCore object
 * @param[in] room #SephoneChatRoom involved in the conversation.
 */
typedef void (*SephoneCoreIsComposingReceivedCb)(SephoneCore *lc, SephoneChatRoom *room);

typedef void (*SephoneCoreUmsgMessageReceivedCb)(SephoneCore *lc, SephoneCall *call, const char *message);

/**
 * Callback for being notified of DTMFs received.
 * @param lc the sephone core
 * @param call the call that received the dtmf
 * @param dtmf the ascii code of the dtmf
 */
typedef void (*SephoneCoreDtmfReceivedCb)(SephoneCore* lc, SephoneCall *call, int dtmf);

/** Callback prototype */
typedef void (*SephoneCoreReferReceivedCb)(SephoneCore *lc, const char *refer_to);
/** Callback prototype */
typedef void (*SephoneCoreBuddyInfoUpdatedCb)(SephoneCore *lc, SephoneFriend *lf);
/**
 * Callback for notifying progresses of transfers.
 * @param lc the SephoneCore
 * @param transfered the call that was transfered
 * @param new_call_state the state of the call to transfer target at the far end.
 */
typedef void (*SephoneCoreTransferStateChangedCb)(SephoneCore *lc, SephoneCall *transfered, SephoneCallState new_call_state);

/**
 * Callback for receiving quality statistics for calls.
 * @param lc the SephoneCore
 * @param call the call
 * @param stats the call statistics.
 */
typedef void (*SephoneCoreCallStatsUpdatedCb)(SephoneCore *lc, SephoneCall *call, const SephoneCallStats *stats);

/**
 * Callback prototype for receiving info messages.
 * @param lc the SephoneCore
 * @param call the call whose info message belongs to.
 * @param msg the info message.
 */
typedef void (*SephoneCoreInfoReceivedCb)(SephoneCore *lc, SephoneCall *call, const SephoneInfoMessage *msg);

/**
 * SephoneGlobalState describes the global state of the SephoneCore object.
 * It is notified via the SephoneCoreVTable::global_state_changed
**/
typedef enum _SephoneConfiguringState {
	SephoneConfiguringSuccessful,
	SephoneConfiguringFailed,
	SephoneConfiguringSkipped
} SephoneConfiguringState;

/**
 * Callback prototype for configuring status changes notification
 * @param lc the SephoneCore
 * @param message informational message.
 */
typedef void (*SephoneCoreConfiguringStatusCb)(SephoneCore *lc, SephoneConfiguringState status, const char *message);

/**
 * Callback prototype for reporting network change either automatically detected or notified by #sephone_core_set_network_reachable.
 * @param lc the SephoneCore
 * @param reachable true if network is reachable.
 */
typedef void (*SephoneCoreNetworkReachableCb)(SephoneCore *lc, bool_t reachable);

/**
 * Callback prototype for reporting log collection upload state change.
 * @param[in] lc SephoneCore object
 * @param[in] state The state of the log collection upload
 * @param[in] info Additional information: error message in case of error state, URL of uploaded file in case of success.
 */
typedef void (*SephoneCoreLogCollectionUploadStateChangedCb)(SephoneCore *lc, SephoneCoreLogCollectionUploadState state, const char *info);

/**
 * Callback prototype for reporting log collection upload progress indication.
 * @param[in] lc SephoneCore object
 * @param[in] progress Percentage of the file size of the log collection already uploaded.
 */
typedef void (*SephoneCoreLogCollectionUploadProgressIndicationCb)(SephoneCore *lc, size_t offset, size_t total);

/**
 * This structure holds all callbacks that the application should implement.
 *  None is mandatory.
**/
typedef struct _SephoneCoreVTable{
	SephoneCoreGlobalStateChangedCb global_state_changed; /**<Notifies global state changes*/
	SephoneCoreRegistrationStateChangedCb registration_state_changed;/**<Notifies registration state changes*/
	SephoneCoreCallStateChangedCb call_state_changed;/**<Notifies call state changes*/
	SephoneCoreNotifyPresenceReceivedCb notify_presence_received; /**< Notify received presence events*/
	SephoneCoreNewSubscriptionRequestedCb new_subscription_requested; /**< Notify about pending presence subscription request */
	SephoneCoreAuthInfoRequestedCb auth_info_requested; /**< Ask the application some authentication information */
	SephoneCoreCallLogUpdatedCb call_log_updated; /**< Notifies that call log list has been updated */
	SephoneCoreMessageReceivedCb message_received; /**< a message is received, can be text or external body*/
	SephoneCoreIsComposingReceivedCb is_composing_received; /**< An is-composing notification has been received */
	SephoneCoreDtmfReceivedCb dtmf_received; /**< A dtmf has been received received */
	SephoneCoreReferReceivedCb refer_received; /**< An out of call refer was received */
	SephoneCoreCallEncryptionChangedCb call_encryption_changed; /**<Notifies on change in the encryption of call streams */
	SephoneCoreTransferStateChangedCb transfer_state_changed; /**<Notifies when a transfer is in progress */
	SephoneCoreBuddyInfoUpdatedCb buddy_info_updated; /**< a SephoneFriend's BuddyInfo has changed*/
	SephoneCoreCallStatsUpdatedCb call_stats_updated; /**<Notifies on refreshing of call's statistics. */
	SephoneCoreInfoReceivedCb info_received; /**<Notifies an incoming informational message received.*/
	SephoneCoreSubscriptionStateChangedCb subscription_state_changed; /**<Notifies subscription state change */
	SephoneCoreNotifyReceivedCb notify_received; /**< Notifies a an event notification, see sephone_core_subscribe() */
	SephoneCorePublishStateChangedCb publish_state_changed;/**Notifies publish state change (only from #SephoneEvent api)*/
	SephoneCoreConfiguringStatusCb configuring_status; /** Notifies configuring status changes */
	DisplayStatusCb display_status; /**< @deprecated Callback that notifies various events with human readable text.*/
	DisplayMessageCb display_message;/**< @deprecated Callback to display a message to the user */
	DisplayMessageCb display_warning;/**< @deprecated Callback to display a warning to the user */
	DisplayUrlCb display_url; /**< @deprecated */
	ShowInterfaceCb show; /**< @deprecated Notifies the application that it should show up*/
	SephoneCoreTextMessageReceivedCb text_received; /**< @deprecated, use #message_received instead <br> A text message has been received */
	SephoneCoreFileTransferRecvCb file_transfer_recv; /**< @deprecated Callback to store file received attached to a #SephoneChatMessage */
	SephoneCoreFileTransferSendCb file_transfer_send; /**< @deprecated Callback to collect file chunk to be sent for a #SephoneChatMessage */
	SephoneCoreFileTransferProgressIndicationCb file_transfer_progress_indication; /**< @deprecated Callback to indicate file transfer progress */
	SephoneCoreNetworkReachableCb network_reachable; /**< Callback to report IP network status (I.E up/down )*/
	SephoneCoreLogCollectionUploadStateChangedCb log_collection_upload_state_changed; /**< Callback to upload collected logs */
	SephoneCoreLogCollectionUploadProgressIndicationCb log_collection_upload_progress_indication; /**< Callback to indicate log collection upload progress */
	SephoneCoreUmsgMessageReceivedCb umsg_received;
	void *user_data; /**<User data associated with the above callbacks */
} SephoneCoreVTable;

/**
 * Instantiate a vtable with all arguments set to NULL
 * @return newly allocated vtable
 */
SEPHONE_PUBLIC SephoneCoreVTable *sephone_core_v_table_new();

/**
 * Sets a user data pointer in the vtable.
 * @param table the vtable
 * @param data the user data to attach
 */
SEPHONE_PUBLIC void sephone_core_v_table_set_user_data(SephoneCoreVTable *table, void *data);

/**
 * Gets a user data pointer in the vtable.
 * @param table the vtable
 * @return the data attached to the vtable
 */
SEPHONE_PUBLIC void* sephone_core_v_table_get_user_data(SephoneCoreVTable *table);

/**
 * Gets the current VTable.
 * This is meant only to be called from a callback to be able to get the user_data associated with the vtable that called the callback.
 * @param lc the sephonecore
 * @return the vtable that called the last callback
 */
SEPHONE_PUBLIC SephoneCoreVTable *sephone_core_get_current_vtable(SephoneCore *lc);

/**
 * Destroy a vtable.
 * @param vtable to be destroyed
 */
SEPHONE_PUBLIC void sephone_core_v_table_destroy(SephoneCoreVTable* table);

/**
 * @}
**/

typedef struct _SCCallbackObj
{
	SephoneCoreCbFunc _func;
	void * _user_data;
}SCCallbackObj;


/**
 * Policy to use to pass through firewalls.
 * @ingroup network_parameters
**/
typedef enum _SephoneFirewallPolicy {
	SephonePolicyNoFirewall, /**< Do not use any mechanism to pass through firewalls */
	SephonePolicyUseNatAddress, /**< Use the specified public adress */
	SephonePolicyUseStun, /**< Use a STUN server to get the public address */
	SephonePolicyUseIce, /**< Use the ICE protocol */
	SephonePolicyUseUpnp, /**< Use the uPnP protocol */
} SephoneFirewallPolicy;

typedef enum _SephoneWaitingState{
	SephoneWaitingStart,
	SephoneWaitingProgress,
	SephoneWaitingFinished
} SephoneWaitingState;
typedef void * (*SephoneCoreWaitingCallback)(SephoneCore *lc, void *context, SephoneWaitingState ws, const char *purpose, float progress);


/* THE main API */

typedef enum _SephoneLogCollectionState {
	SephoneLogCollectionDisabled,
	SephoneLogCollectionEnabled,
	SephoneLogCollectionEnabledWithoutPreviousLogHandler
} SephoneLogCollectionState;

/**
 * Tells whether the sephone core log collection is enabled.
 * @ingroup misc
 * @return The state of the sephone core log collection.
 */
SEPHONE_PUBLIC SephoneLogCollectionState sephone_core_log_collection_enabled(void);

/**
 * Enable the sephone core log collection to upload logs on a server.
 * @ingroup misc
 * @param[in] state SephoneLogCollectionState value telling whether to enable log collection or not.
 */
SEPHONE_PUBLIC void sephone_core_enable_log_collection(SephoneLogCollectionState state);

/**
 * Get the path where the log files will be written for log collection.
 * @ingroup misc
 * @return The path where the log files will be written.
 */
SEPHONE_PUBLIC const char * sephone_core_get_log_collection_path(void);

/**
 * Set the path where the log files will be written for log collection.
 * @ingroup misc
 * @param[in] path The path where the log files will be written.
 */
SEPHONE_PUBLIC void sephone_core_set_log_collection_path(const char *path);

/**
 * Get the prefix of the filenames that will be used for log collection.
 * @ingroup misc
 * @return The prefix of the filenames used for log collection.
 */
SEPHONE_PUBLIC const char * sephone_core_get_log_collection_prefix(void);

/**
 * Set the prefix of the filenames that will be used for log collection.
 * @ingroup misc
 * @param[in] prefix The prefix to use for the filenames for log collection.
 */
SEPHONE_PUBLIC void sephone_core_set_log_collection_prefix(const char *prefix);

/**
 * Get the max file size in bytes of the files used for log collection.
 * @ingroup misc
 * @return The max file size in bytes of the files used for log collection.
 */
SEPHONE_PUBLIC int sephone_core_get_log_collection_max_file_size(void);

/**
 * Set the max file size in bytes of the files used for log collection.
 * Warning: this function should only not be used to change size
 * dynamically but instead only before calling @see
 * sephone_core_enable_log_collection. If you increase max size
  * on runtime, logs chronological order COULD be broken.
 * @ingroup misc
 * @param[in] size The max file size in bytes of the files used for log collection.
 */
SEPHONE_PUBLIC void sephone_core_set_log_collection_max_file_size(int size);

/**
 * Set the url of the server where to upload the collected log files.
 * @ingroup misc
 * @param[in] core SephoneCore object
 * @param[in] server_url The url of the server where to upload the collected log files.
 */
SEPHONE_PUBLIC void sephone_core_set_log_collection_upload_server_url(SephoneCore *core, const char *server_url);

/**
 * Upload the log collection to the configured server url.
 * @ingroup misc
 * @param[in] core SephoneCore object
 */
SEPHONE_PUBLIC void sephone_core_upload_log_collection(SephoneCore *core);

/**
 * Compress the log collection in a single file.
 * @ingroup misc
 * @return The path of the compressed log collection file (to be freed calling ms_free()).
 */
SEPHONE_PUBLIC char * sephone_core_compress_log_collection();

/**
 * Reset the log collection by removing the log files.
 * @ingroup misc
 */
SEPHONE_PUBLIC void sephone_core_reset_log_collection();

/**
 * Define a log handler.
 *
 * @ingroup misc
 *
 * @param logfunc The function pointer of the log handler.
 */
SEPHONE_PUBLIC void sephone_core_set_log_handler(OrtpLogFunc logfunc);
/**
 * Define a log file.
 *
 * @ingroup misc
 *
 * If the file pointer passed as an argument is NULL, stdout is used instead.
 *
 * @param file A pointer to the FILE structure of the file to write to.
 */
SEPHONE_PUBLIC void sephone_core_set_log_file(FILE *file);

/**
 * @deprecated Use #sephone_core_set_log_level_mask instead, which is exactly the
 * same function..
**/
SEPHONE_PUBLIC void sephone_core_set_log_level(OrtpLogLevel loglevel);
/**
 * Define the log level.
 *
 * @ingroup misc
 *
 * The loglevel parameter is a bitmask parameter. Therefore to enable only warning and error
 * messages, use ORTP_WARNING | ORTP_ERROR. To disable logs, simply set loglevel to 0.
 *
 * @param loglevel A bitmask of the log levels to set.
 */
SEPHONE_PUBLIC void sephone_core_set_log_level_mask(OrtpLogLevel loglevel);
SEPHONE_PUBLIC void sephone_core_enable_logs(FILE *file);
SEPHONE_PUBLIC void sephone_core_enable_logs_with_cb(OrtpLogFunc logfunc);
SEPHONE_PUBLIC void sephone_core_disable_logs(void);

SEPHONE_PUBLIC int sephone_core_enable_slog3(bool_t enable);

/**
 * Enable logs serialization (output logs from either the thread that creates the sephone core or the thread that calls sephone_core_iterate()).
 * Must be called before creating the sephone core.
 * @ingroup misc
 */
SEPHONE_PUBLIC void sephone_core_serialize_logs(void);

SEPHONE_PUBLIC	const char *sephone_core_get_version(void);
SEPHONE_PUBLIC	const char *sephone_core_get_user_agent(SephoneCore *lc);
/**
 * @deprecated Use #sephone_core_get_user_agent instead.
**/
SEPHONE_PUBLIC	const char *sephone_core_get_user_agent_name(void);
/**
 * @deprecated Use #sephone_core_get_user_agent instead.
**/
SEPHONE_PUBLIC	const char *sephone_core_get_user_agent_version(void);

SEPHONE_PUBLIC SephoneCore *sephone_core_new(const SephoneCoreVTable *vtable,
						const char *config_path, const char *factory_config, void* userdata);

/**
 * Instantiates a SephoneCore object with a given SpConfig.
 * @ingroup initializing
 *
 * The SephoneCore object is the primary handle for doing all phone actions.
 * It should be unique within your application.
 * @param vtable a SephoneCoreVTable structure holding your application callbacks
 * @param config a pointer to an SpConfig object holding the configuration of the SephoneCore to be instantiated.
 * @param userdata an opaque user pointer that can be retrieved at any time (for example in
 *        callbacks) using sephone_core_get_user_data().
 * @see sephone_core_new
**/
SEPHONE_PUBLIC SephoneCore *sephone_core_new_with_config(const SephoneCoreVTable *vtable, SpConfig *config, void *userdata);

/* function to be periodically called in a main loop */
/* For ICE to work properly it should be called every 20ms */
SEPHONE_PUBLIC	void sephone_core_iterate(SephoneCore *lc);

/**
 * @ingroup initializing
 * add a listener to be notified of sephone core events. Once events are received, registered vtable are invoked in order.
 * @param vtable a SephoneCoreVTable structure holding your application callbacks. Object is owned by sephone core until sephone_core_remove_listener.
 * @param lc object
 * @param string identifying the device, can be EMEI or UDID
 *
 */
SEPHONE_PUBLIC void sephone_core_add_listener(SephoneCore *lc, SephoneCoreVTable *vtable);
/**
 * @ingroup initializing
 * remove a listener registred by sephone_core_add_listener.
 * @param vtable a SephoneCoreVTable structure holding your application callbacks
 * @param lc object
 * @param string identifying the device, can be EMEI or UDID
 *
 */
SEPHONE_PUBLIC void sephone_core_remove_listener(SephoneCore *lc, const SephoneCoreVTable *vtable);


/*sets the user-agent string in sip messages, ideally called just after sephone_core_new() or sephone_core_init() */
SEPHONE_PUBLIC	void sephone_core_set_user_agent(SephoneCore *lc, const char *ua_name, const char *version);

SEPHONE_PUBLIC	SephoneAddress * sephone_core_interpret_url(SephoneCore *lc, const char *url);

SEPHONE_PUBLIC	SephoneCall * sephone_core_invite(SephoneCore *lc, const char *url);

SEPHONE_PUBLIC	SephoneCall * sephone_core_invite_address(SephoneCore *lc, const SephoneAddress *addr);

SEPHONE_PUBLIC	SephoneCall * sephone_core_invite_with_params(SephoneCore *lc, const char *url, const SephoneCallParams *params);

SEPHONE_PUBLIC	SephoneCall * sephone_core_invite_address_with_params(SephoneCore *lc, const SephoneAddress *addr, const SephoneCallParams *params);

SEPHONE_PUBLIC	int sephone_core_transfer_call(SephoneCore *lc, SephoneCall *call, const char *refer_to);

SEPHONE_PUBLIC	int sephone_core_transfer_call_to_another(SephoneCore *lc, SephoneCall *call, SephoneCall *dest);

SEPHONE_PUBLIC SephoneCall * sephone_core_start_refered_call(SephoneCore *lc, SephoneCall *call, const SephoneCallParams *params);

/** @deprecated Use sephone_core_is_incoming_invite_pending() instead. */
#define sephone_core_inc_invite_pending(lc) sephone_core_is_incoming_invite_pending(lc)

/**
 * Tells whether there is an incoming invite pending.
 * @ingroup call_control
 * @param[in] lc SephoneCore object
 * @return A boolean telling whether an incoming invite is pending or not.
 */
SEPHONE_PUBLIC	bool_t sephone_core_is_incoming_invite_pending(SephoneCore*lc);

SEPHONE_PUBLIC bool_t sephone_core_in_call(const SephoneCore *lc);

SEPHONE_PUBLIC	SephoneCall *sephone_core_get_current_call(const SephoneCore *lc);

SEPHONE_PUBLIC	int sephone_core_accept_call(SephoneCore *lc, SephoneCall *call);

SEPHONE_PUBLIC	int sephone_core_accept_call_with_params(SephoneCore *lc, SephoneCall *call, const SephoneCallParams *params);

SEPHONE_PUBLIC int sephone_core_accept_early_media_with_params(SephoneCore* lc, SephoneCall* call, const SephoneCallParams* params);

SEPHONE_PUBLIC int sephone_core_accept_early_media(SephoneCore* lc, SephoneCall* call);

SEPHONE_PUBLIC	int sephone_core_terminate_call(SephoneCore *lc, SephoneCall *call);

/**
 * Redirect the specified call to the given redirect URI.
 * @param[in] lc #SephoneCore object.
 * @param[in] call The #SephoneCall to redirect.
 * @param[in] redirect_uri The URI to redirect the call to.
 * @return 0 if successful, -1 on error.
 * @ingroup call_control
 */
SEPHONE_PUBLIC int sephone_core_redirect_call(SephoneCore *lc, SephoneCall *call, const char *redirect_uri);

SEPHONE_PUBLIC	int sephone_core_decline_call(SephoneCore *lc, SephoneCall * call, SephoneReason reason);

SEPHONE_PUBLIC	int sephone_core_terminate_all_calls(SephoneCore *lc);

SEPHONE_PUBLIC	int sephone_core_pause_call(SephoneCore *lc, SephoneCall *call);

SEPHONE_PUBLIC	int sephone_core_pause_all_calls(SephoneCore *lc);

SEPHONE_PUBLIC	int sephone_core_resume_call(SephoneCore *lc, SephoneCall *call);

SEPHONE_PUBLIC	int sephone_core_update_call(SephoneCore *lc, SephoneCall *call, const SephoneCallParams *params);

SEPHONE_PUBLIC	int sephone_core_defer_call_update(SephoneCore *lc, SephoneCall *call);

SEPHONE_PUBLIC	int sephone_core_accept_call_update(SephoneCore *lc, SephoneCall *call, const SephoneCallParams *params);
/**
 * @ingroup media_parameters
 * Get default call parameters reflecting current sephone core configuration
 * @param lc SephoneCore object
 * @return  SephoneCallParams
 * @deprecated use sephone_core_create_call_params()
 */
SEPHONE_PUBLIC	SephoneCallParams *sephone_core_create_default_call_parameters(SephoneCore *lc);

SEPHONE_PUBLIC SephoneCallParams *sephone_core_create_call_params(SephoneCore *lc, SephoneCall *call);

SEPHONE_PUBLIC	SephoneCall *sephone_core_get_call_by_remote_address(SephoneCore *lc, const char *remote_address);

/**
 * Send stun user text message from audio rtp stream
 */
SEPHONE_PUBLIC	void sephone_core_send_user_message(SephoneCore *lc, const char *message);

/**
 * Send the specified dtmf.
 *
 * @ingroup media_parameters
 * @deprecated Use #sephone_call_send_dtmf instead.
 * This function only works during calls. The dtmf is automatically played to the user.
 * @param lc The SephoneCore object
 * @param dtmf The dtmf name specified as a char, such as '0', '#' etc...
 *
**/
SEPHONE_PUBLIC	void sephone_core_send_dtmf(SephoneCore *lc,char dtmf);

SEPHONE_PUBLIC	int sephone_core_set_primary_contact(SephoneCore *lc, const char *contact);

SEPHONE_PUBLIC	const char *sephone_core_get_primary_contact(SephoneCore *lc);

SEPHONE_PUBLIC	const char * sephone_core_get_identity(SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_set_guess_hostname(SephoneCore *lc, bool_t val);
SEPHONE_PUBLIC bool_t sephone_core_get_guess_hostname(SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_enable_lime(SephoneCore *lc, bool_t val);
SEPHONE_PUBLIC bool_t sephone_core_lime_enabled(const SephoneCore *lc);

SEPHONE_PUBLIC	bool_t sephone_core_ipv6_enabled(SephoneCore *lc);
SEPHONE_PUBLIC	void sephone_core_enable_ipv6(SephoneCore *lc, bool_t val);

SEPHONE_PUBLIC	SephoneAddress *sephone_core_get_primary_contact_parsed(SephoneCore *lc);
SEPHONE_PUBLIC	const char * sephone_core_get_identity(SephoneCore *lc);
/*0= no bandwidth limit*/
SEPHONE_PUBLIC	void sephone_core_set_download_bandwidth(SephoneCore *lc, int bw);
SEPHONE_PUBLIC	void sephone_core_set_upload_bandwidth(SephoneCore *lc, int bw);

SEPHONE_PUBLIC	int sephone_core_get_download_bandwidth(const SephoneCore *lc);
SEPHONE_PUBLIC	int sephone_core_get_upload_bandwidth(const SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_enable_adaptive_rate_control(SephoneCore *lc, bool_t enabled);
SEPHONE_PUBLIC bool_t sephone_core_adaptive_rate_control_enabled(const SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_set_adaptive_rate_algorithm(SephoneCore *lc, const char *algorithm);
SEPHONE_PUBLIC const char* sephone_core_get_adaptive_rate_algorithm(const SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_set_download_ptime(SephoneCore *lc, int ptime);
SEPHONE_PUBLIC	int  sephone_core_get_download_ptime(SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_set_upload_ptime(SephoneCore *lc, int ptime);

SEPHONE_PUBLIC	int sephone_core_get_upload_ptime(SephoneCore *lc);

/**
 * Set the SIP transport timeout.
 * @param[in] lc #SephoneCore object.
 * @param[in] timeout_ms The SIP transport timeout in milliseconds.
 * @ingroup media_parameters
 */
void sephone_core_set_sip_transport_timeout(SephoneCore *lc, int timeout_ms);

/**
 * Get the SIP transport timeout.
 * @param[in] lc #SephoneCore object.
 * @return The SIP transport timeout in milliseconds.
 * @ingroup media_parameters
 */
int sephone_core_get_sip_transport_timeout(SephoneCore *lc);

/**
 * Enable or disable DNS SRV resolution.
 * @param[in] lc #SephoneCore object.
 * @param[in] enable TRUE to enable DNS SRV resolution, FALSE to disable it.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC void sephone_core_enable_dns_srv(SephoneCore *lc, bool_t enable);

/**
 * Tells whether DNS SRV resolution is enabled.
 * @param[in] lc #SephoneCore object.
 * @return TRUE if DNS SRV resolution is enabled, FALSE if disabled.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC bool_t sephone_core_dns_srv_enabled(const SephoneCore *lc);

/* returns a MSList of PayloadType */
SEPHONE_PUBLIC	const MSList *sephone_core_get_audio_codecs(const SephoneCore *lc);

SEPHONE_PUBLIC int sephone_core_set_audio_codecs(SephoneCore *lc, MSList *codecs);
/* returns a MSList of PayloadType */
SEPHONE_PUBLIC const MSList *sephone_core_get_video_codecs(const SephoneCore *lc);

SEPHONE_PUBLIC int sephone_core_set_video_codecs(SephoneCore *lc, MSList *codecs);

SEPHONE_PUBLIC void sephone_core_enable_generic_confort_noise(SephoneCore *lc, bool_t enabled);

SEPHONE_PUBLIC bool_t sephone_core_generic_confort_noise_enabled(const SephoneCore *lc);

/**
 * Tells whether the specified payload type is enabled.
 * @param[in] lc #SephoneCore object.
 * @param[in] pt The #SephonePayloadType we want to know is enabled or not.
 * @return TRUE if the payload type is enabled, FALSE if disabled.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC bool_t sephone_core_payload_type_enabled(SephoneCore *lc, const SephonePayloadType *pt);

/**
 * Tells whether the specified payload type represents a variable bitrate codec.
 * @param[in] lc #SephoneCore object.
 * @param[in] pt The #SephonePayloadType we want to know
 * @return TRUE if the payload type represents a VBR codec, FALSE if disabled.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC bool_t sephone_core_payload_type_is_vbr(SephoneCore *lc, const SephonePayloadType *pt);

/**
 * Set an explicit bitrate (IP bitrate, not codec bitrate) for a given codec, in kbit/s.
 * @param[in] lc the #SephoneCore object
 * @param[in] pt the #SephonePayloadType to modify.
 * @param[in] bitrate the IP bitrate in kbit/s.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC void sephone_core_set_payload_type_bitrate(SephoneCore *lc, SephonePayloadType *pt, int bitrate);

/**
 * Get the bitrate explicitely set with sephone_core_set_payload_type_bitrate().
 * @param[in] lc the #SephoneCore object
 * @param[in] pt the #SephonePayloadType to modify.
 * @return bitrate the IP bitrate in kbit/s, or -1 if an error occured.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC int sephone_core_get_payload_type_bitrate(SephoneCore *lc, const SephonePayloadType *pt);

/**
 * Enable or disable the use of the specified payload type.
 * @param[in] lc #SephoneCore object.
 * @param[in] pt The #SephonePayloadType to enable or disable. It can be retrieved using #sephone_core_find_payload_type
 * @param[in] enable TRUE to enable the payload type, FALSE to disable it.
 * @return 0 if successful, any other value otherwise.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC	int sephone_core_enable_payload_type(SephoneCore *lc, SephonePayloadType *pt, bool_t enable);

/**
 * Wildcard value used by #sephone_core_find_payload_type to ignore rate in search algorithm
 * @ingroup media_parameters
 */
#define SEPHONE_FIND_PAYLOAD_IGNORE_RATE -1
/**
 * Wildcard value used by #sephone_core_find_payload_type to ignore channel in search algorithm
 * @ingroup media_parameters
 */
#define SEPHONE_FIND_PAYLOAD_IGNORE_CHANNELS -1
/**
 * Get payload type from mime type and clock rate
 * @ingroup media_parameters
 * This function searches in audio and video codecs for the given payload type name and clockrate.
 * @param lc #SephoneCore object
 * @param type payload mime type (I.E SPEEX, PCMU, VP8)
 * @param rate can be #SEPHONE_FIND_PAYLOAD_IGNORE_RATE
 * @param channels  number of channels, can be #SEPHONE_FIND_PAYLOAD_IGNORE_CHANNELS
 * @return Returns NULL if not found.
 */
SEPHONE_PUBLIC	SephonePayloadType* sephone_core_find_payload_type(SephoneCore* lc, const char* type, int rate, int channels) ;

/**
 * @ingroup media_parameters
 * Returns the payload type number assigned for this codec.
**/
SEPHONE_PUBLIC	int sephone_core_get_payload_type_number(SephoneCore *lc, const PayloadType *pt);

/**
 * @ingroup media_parameters
 * Force a number for a payload type. The SephoneCore does payload type number assignment automatically. THis function is to be used mainly for tests, in order
 * to override the automatic assignment mechanism.
**/
SEPHONE_PUBLIC void sephone_core_set_payload_type_number(SephoneCore *lc, PayloadType *pt, int number);

SEPHONE_PUBLIC	const char *sephone_core_get_payload_type_description(SephoneCore *lc, PayloadType *pt);

SEPHONE_PUBLIC	bool_t sephone_core_check_payload_type_usability(SephoneCore *lc, const PayloadType *pt);

/**
 * Create a proxy config with default values from Sephone core.
 * @param[in] lc #SephoneCore object
 * @return #SephoneProxyConfig with default values set
 * @ingroup proxy
 */
SEPHONE_PUBLIC	SephoneProxyConfig * sephone_core_create_proxy_config(SephoneCore *lc);

SEPHONE_PUBLIC	int sephone_core_add_proxy_config(SephoneCore *lc, SephoneProxyConfig *config);

SEPHONE_PUBLIC	void sephone_core_clear_proxy_config(SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_remove_proxy_config(SephoneCore *lc, SephoneProxyConfig *config);

SEPHONE_PUBLIC	const MSList *sephone_core_get_proxy_config_list(const SephoneCore *lc);

/** @deprecated Use sephone_core_set_default_proxy_config() instead. */
#define sephone_core_set_default_proxy(lc, config) sephone_core_set_default_proxy_config(lc, config)

SEPHONE_PUBLIC void sephone_core_set_default_proxy_index(SephoneCore *lc, int index);

SEPHONE_PUBLIC	int sephone_core_get_default_proxy(SephoneCore *lc, SephoneProxyConfig **config);

SEPHONE_PUBLIC SephoneProxyConfig * sephone_core_get_default_proxy_config(SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_set_default_proxy_config(SephoneCore *lc, SephoneProxyConfig *config);

/**
 * Create an authentication information with default values from Sephone core.
 * @param[in] lc #SephoneCore object
 * @param[in] username String containing the username part of the authentication credentials
 * @param[in] userid String containing the username to use to calculate the authentication digest (optional)
 * @param[in] passwd String containing the password of the authentication credentials (optional, either passwd or ha1 must be set)
 * @param[in] ha1 String containing a ha1 hash of the password (optional, either passwd or ha1 must be set)
 * @param[in] realm String used to discriminate different SIP authentication domains (optional)
 * @param[in] domain String containing the SIP domain for which this authentication information is valid, if it has to be restricted for a single SIP domain.
 * @return #SephoneAuthInfo with default values set
 * @ingroup authentication
 */
SEPHONE_PUBLIC SephoneAuthInfo * sephone_core_create_auth_info(SephoneCore *lc, const char *username, const char *userid, const char *passwd, const char *ha1, const char *realm, const char *domain);

SEPHONE_PUBLIC	void sephone_core_add_auth_info(SephoneCore *lc, const SephoneAuthInfo *info);

SEPHONE_PUBLIC void sephone_core_remove_auth_info(SephoneCore *lc, const SephoneAuthInfo *info);

SEPHONE_PUBLIC const MSList *sephone_core_get_auth_info_list(const SephoneCore *lc);

SEPHONE_PUBLIC const SephoneAuthInfo *sephone_core_find_auth_info(SephoneCore *lc, const char *realm, const char *username, const char *sip_domain);

SEPHONE_PUBLIC void sephone_core_abort_authentication(SephoneCore *lc,  SephoneAuthInfo *info);

SEPHONE_PUBLIC	void sephone_core_clear_all_auth_info(SephoneCore *lc);

/**
 * Enable or disable the audio adaptive jitter compensation.
 * @param[in] lc #SephoneCore object
 * @param[in] enable TRUE to enable the audio adaptive jitter compensation, FALSE to disable it.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC void sephone_core_enable_audio_adaptive_jittcomp(SephoneCore *lc, bool_t enable);

/**
 * Tells whether the audio adaptive jitter compensation is enabled.
 * @param[in] lc #SephoneCore object
 * @return TRUE if the audio adaptive jitter compensation is enabled, FALSE otherwise.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC bool_t sephone_core_audio_adaptive_jittcomp_enabled(SephoneCore *lc);

SEPHONE_PUBLIC int sephone_core_get_audio_jittcomp(SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_set_audio_jittcomp(SephoneCore *lc, int value);

/**
 * Enable or disable the video adaptive jitter compensation.
 * @param[in] lc #SephoneCore object
 * @param[in] enable TRUE to enable the video adaptive jitter compensation, FALSE to disable it.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC void sephone_core_enable_video_adaptive_jittcomp(SephoneCore *lc, bool_t enable);

/**
 * Tells whether the video adaptive jitter compensation is enabled.
 * @param[in] lc #SephoneCore object
 * @return TRUE if the video adaptive jitter compensation is enabled, FALSE otherwise.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC bool_t sephone_core_video_adaptive_jittcomp_enabled(SephoneCore *lc);

SEPHONE_PUBLIC int sephone_core_get_video_jittcomp(SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_set_video_jittcomp(SephoneCore *lc, int value);

SEPHONE_PUBLIC	int sephone_core_get_audio_port(const SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_get_audio_port_range(const SephoneCore *lc, int *min_port, int *max_port);

SEPHONE_PUBLIC	int sephone_core_get_video_port(const SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_get_video_port_range(const SephoneCore *lc, int *min_port, int *max_port);

SEPHONE_PUBLIC	int sephone_core_get_nortp_timeout(const SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_set_audio_port(SephoneCore *lc, int port);

SEPHONE_PUBLIC	void sephone_core_set_audio_port_range(SephoneCore *lc, int min_port, int max_port);

SEPHONE_PUBLIC	void sephone_core_set_video_port(SephoneCore *lc, int port);

SEPHONE_PUBLIC	void sephone_core_set_video_port_range(SephoneCore *lc, int min_port, int max_port);

SEPHONE_PUBLIC	void sephone_core_set_nortp_timeout(SephoneCore *lc, int port);

SEPHONE_PUBLIC	void sephone_core_set_use_info_for_dtmf(SephoneCore *lc, bool_t use_info);

SEPHONE_PUBLIC	bool_t sephone_core_get_use_info_for_dtmf(SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_set_use_rfc2833_for_dtmf(SephoneCore *lc,bool_t use_rfc2833);

SEPHONE_PUBLIC	bool_t sephone_core_get_use_rfc2833_for_dtmf(SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_set_sip_port(SephoneCore *lc, int port);

SEPHONE_PUBLIC	int sephone_core_get_sip_port(SephoneCore *lc);

SEPHONE_PUBLIC	int sephone_core_set_sip_transports(SephoneCore *lc, const SCSipTransports *transports);

SEPHONE_PUBLIC	int sephone_core_get_sip_transports(SephoneCore *lc, SCSipTransports *transports);

SEPHONE_PUBLIC void sephone_core_get_sip_transports_used(SephoneCore *lc, SCSipTransports *tr);

SEPHONE_PUBLIC	bool_t sephone_core_sip_transport_supported(const SephoneCore *lc, SephoneTransportType tp);
/**
 *
 * Give access to the UDP sip socket. Can be useful to configure this socket as persistent I.E kCFStreamNetworkServiceType set to kCFStreamNetworkServiceTypeVoIP)
 * @param lc #SephoneCore
 * @return socket file descriptor
 */
ortp_socket_t sephone_core_get_sip_socket(SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_set_inc_timeout(SephoneCore *lc, int seconds);

SEPHONE_PUBLIC	int sephone_core_get_inc_timeout(SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_set_in_call_timeout(SephoneCore *lc, int seconds);

SEPHONE_PUBLIC	int sephone_core_get_in_call_timeout(SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_set_delayed_timeout(SephoneCore *lc, int seconds);

SEPHONE_PUBLIC	int sephone_core_get_delayed_timeout(SephoneCore *lc);

/**
 * Set the STUN server address to use when the firewall policy is set to STUN.
 * @param[in] lc #SephoneCore object
 * @param[in] server The STUN server address to use.
 * @ingroup network_parameters
 */
SEPHONE_PUBLIC	void sephone_core_set_stun_server(SephoneCore *lc, const char *server);

/**
 * Get the STUN server address being used.
 * @param[in] lc #SephoneCore object
 * @return The STUN server address being used.
 * @ingroup network_parameters
 */
SEPHONE_PUBLIC	const char * sephone_core_get_stun_server(const SephoneCore *lc);

/**
 * @ingroup network_parameters
 * Return the availability of uPnP.
 *
 * @return true if uPnP is available otherwise return false.
 */
SEPHONE_PUBLIC bool_t sephone_core_upnp_available(void);

/**
 * @ingroup network_parameters
 * Return the internal state of uPnP.
 *
 * @param lc #SephoneCore
 * @return an SephoneUpnpState.
 */
SEPHONE_PUBLIC SephoneUpnpState sephone_core_get_upnp_state(const SephoneCore *lc);

/**
 * @ingroup network_parameters
 * Return the external ip address of router.
 * In some cases the uPnP can have an external ip address but not a usable uPnP
 * (state different of Ok).
 *
 * @param lc #SephoneCore
 * @return a null terminated string containing the external ip address. If the
 * the external ip address is not available return null.
 */
SEPHONE_PUBLIC const char * sephone_core_get_upnp_external_ipaddress(const SephoneCore *lc);

/**
 * Set the public IP address of NAT when using the firewall policy is set to use NAT.
 * @param[in] lc #SephoneCore object.
 * @param[in] addr The public IP address of NAT to use.
 * @ingroup network_parameters
 */
SEPHONE_PUBLIC void sephone_core_set_nat_address(SephoneCore *lc, const char *addr);

/**
 * Get the public IP address of NAT being used.
 * @param[in] lc #SephoneCore object.
 * @return The public IP address of NAT being used.
 * @ingroup network_parameters
 */
SEPHONE_PUBLIC const char *sephone_core_get_nat_address(const SephoneCore *lc);

/**
 * Set the policy to use to pass through firewalls.
 * @param[in] lc #SephoneCore object.
 * @param[in] pol The #SephoneFirewallPolicy to use.
 * @ingroup network_parameters
 */
SEPHONE_PUBLIC	void sephone_core_set_firewall_policy(SephoneCore *lc, SephoneFirewallPolicy pol);

/**
 * Get the policy that is used to pass through firewalls.
 * @param[in] lc #SephoneCore object.
 * @return The #SephoneFirewallPolicy that is being used.
 * @ingroup network_parameters
 */
SEPHONE_PUBLIC	SephoneFirewallPolicy sephone_core_get_firewall_policy(const SephoneCore *lc);

/* sound functions */
/* returns a null terminated static array of string describing the sound devices */
SEPHONE_PUBLIC const char**  sephone_core_get_sound_devices(SephoneCore *lc);

/**
 * Update detection of sound devices.
 *
 * Use this function when the application is notified of USB plug events, so that
 * list of available hardwares for sound playback and capture is updated.
 * @param[in] lc #SephoneCore object.
 * @ingroup media_parameters
 **/
SEPHONE_PUBLIC void sephone_core_reload_sound_devices(SephoneCore *lc);

SEPHONE_PUBLIC bool_t sephone_core_sound_device_can_capture(SephoneCore *lc, const char *device);
SEPHONE_PUBLIC bool_t sephone_core_sound_device_can_playback(SephoneCore *lc, const char *device);
SEPHONE_PUBLIC	int sephone_core_get_ring_level(SephoneCore *lc);
SEPHONE_PUBLIC	int sephone_core_get_play_level(SephoneCore *lc);
SEPHONE_PUBLIC int sephone_core_get_rec_level(SephoneCore *lc);
SEPHONE_PUBLIC	void sephone_core_set_ring_level(SephoneCore *lc, int level);
SEPHONE_PUBLIC	void sephone_core_set_play_level(SephoneCore *lc, int level);

SEPHONE_PUBLIC	void sephone_core_set_mic_gain_db(SephoneCore *lc, float level);
SEPHONE_PUBLIC	float sephone_core_get_mic_gain_db(SephoneCore *lc);
SEPHONE_PUBLIC	void sephone_core_set_playback_gain_db(SephoneCore *lc, float level);
SEPHONE_PUBLIC	float sephone_core_get_playback_gain_db(SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_set_rec_level(SephoneCore *lc, int level);
SEPHONE_PUBLIC const char * sephone_core_get_ringer_device(SephoneCore *lc);
SEPHONE_PUBLIC const char * sephone_core_get_playback_device(SephoneCore *lc);
SEPHONE_PUBLIC const char * sephone_core_get_capture_device(SephoneCore *lc);
SEPHONE_PUBLIC int sephone_core_set_ringer_device(SephoneCore *lc, const char * devid);
SEPHONE_PUBLIC int sephone_core_set_playback_device(SephoneCore *lc, const char * devid);
SEPHONE_PUBLIC int sephone_core_set_capture_device(SephoneCore *lc, const char * devid);
char sephone_core_get_sound_source(SephoneCore *lc);
void sephone_core_set_sound_source(SephoneCore *lc, char source);
SEPHONE_PUBLIC void sephone_core_stop_ringing(SephoneCore *lc);
SEPHONE_PUBLIC	void sephone_core_set_ring(SephoneCore *lc, const char *path);
SEPHONE_PUBLIC const char *sephone_core_get_ring(const SephoneCore *lc);
SEPHONE_PUBLIC void sephone_core_verify_server_certificates(SephoneCore *lc, bool_t yesno);
SEPHONE_PUBLIC void sephone_core_verify_server_cn(SephoneCore *lc, bool_t yesno);
SEPHONE_PUBLIC void sephone_core_set_root_ca(SephoneCore *lc, const char *path);
SEPHONE_PUBLIC const char *sephone_core_get_root_ca(SephoneCore *lc);
SEPHONE_PUBLIC	void sephone_core_set_ringback(SephoneCore *lc, const char *path);
SEPHONE_PUBLIC const char * sephone_core_get_ringback(const SephoneCore *lc);

/**
 * Specify a ring back tone to be played to far end during incoming calls.
 * @param[in] lc #SephoneCore object
 * @param[in] ring The path to the ring back tone to be played.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC void sephone_core_set_remote_ringback_tone(SephoneCore *lc, const char *ring);

/**
 * Get the ring back tone played to far end during incoming calls.
 * @param[in] lc #SephoneCore object
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC const char *sephone_core_get_remote_ringback_tone(const SephoneCore *lc);

/**
 * Enable or disable the ring play during an incoming early media call.
 * @param[in] lc #SephoneCore object
 * @param[in] enable A boolean value telling whether to enable ringing during an incoming early media call.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC void sephone_core_set_ring_during_incoming_early_media(SephoneCore *lc, bool_t enable);

/**
 * Tells whether the ring play is enabled during an incoming early media call.
 * @param[in] lc #SephoneCore object
 * @ingroup media_paramaters
 */
SEPHONE_PUBLIC bool_t sephone_core_get_ring_during_incoming_early_media(const SephoneCore *lc);

SEPHONE_PUBLIC int sephone_core_preview_ring(SephoneCore *lc, const char *ring,SephoneCoreCbFunc func,void * userdata);
SEPHONE_PUBLIC int sephone_core_play_local(SephoneCore *lc, const char *audiofile);
SEPHONE_PUBLIC	void sephone_core_enable_echo_cancellation(SephoneCore *lc, bool_t val);
SEPHONE_PUBLIC	bool_t sephone_core_echo_cancellation_enabled(SephoneCore *lc);

/**
 * Enables or disable echo limiter.
 * @param[in] lc #SephoneCore object.
 * @param[in] val TRUE to enable echo limiter, FALSE to disable it.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC	void sephone_core_enable_echo_limiter(SephoneCore *lc, bool_t val);

/**
 * Tells whether echo limiter is enabled.
 * @param[in] lc #SephoneCore object.
 * @return TRUE if the echo limiter is enabled, FALSE otherwise.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC	bool_t sephone_core_echo_limiter_enabled(const SephoneCore *lc);

void sephone_core_enable_agc(SephoneCore *lc, bool_t val);
bool_t sephone_core_agc_enabled(const SephoneCore *lc);

/**
 * @deprecated Use #sephone_core_enable_mic instead.
**/
SEPHONE_PUBLIC	void sephone_core_mute_mic(SephoneCore *lc, bool_t muted);

/**
 * Get mic state.
 * @deprecated Use #sephone_core_mic_enabled instead
**/
SEPHONE_PUBLIC	bool_t sephone_core_is_mic_muted(SephoneCore *lc);

/**
 * Enable or disable the microphone.
 * @param[in] lc #SephoneCore object
 * @param[in] enable TRUE to enable the microphone, FALSE to disable it.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC void sephone_core_enable_mic(SephoneCore *lc, bool_t enable);

/**
 * Tells whether the microphone is enabled.
 * @param[in] lc #SephoneCore object
 * @return TRUE if the microphone is enabled, FALSE if disabled.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC bool_t sephone_core_mic_enabled(SephoneCore *lc);

SEPHONE_PUBLIC bool_t sephone_core_is_rtp_muted(SephoneCore *lc);

SEPHONE_PUBLIC bool_t sephone_core_get_rtp_no_xmit_on_audio_mute(const SephoneCore *lc);
SEPHONE_PUBLIC void sephone_core_set_rtp_no_xmit_on_audio_mute(SephoneCore *lc, bool_t val);


/*******************************************************************************
 * Call log related functions                                                  *
 ******************************************************************************/

/**
 * @addtogroup call_logs
 * @{
**/

/**
 * Get the list of call logs (past calls).
 * @param[in] lc SephoneCore object
 * @return \mslist{SephoneCallLog}
**/
SEPHONE_PUBLIC const MSList * sephone_core_get_call_logs(SephoneCore *lc);

/**
 * Erase the call log.
 * @param[in] lc SephoneCore object
**/
SEPHONE_PUBLIC void sephone_core_clear_call_logs(SephoneCore *lc);

/**
 * Get the number of missed calls.
 * Once checked, this counter can be reset with sephone_core_reset_missed_calls_count().
 * @param[in] lc #SephoneCore object.
 * @return The number of missed calls.
**/
SEPHONE_PUBLIC int sephone_core_get_missed_calls_count(SephoneCore *lc);

/**
 * Reset the counter of missed calls.
 * @param[in] lc #SephoneCore object.
**/
SEPHONE_PUBLIC void sephone_core_reset_missed_calls_count(SephoneCore *lc);

/**
 * Remove a specific call log from call history list.
 * This function destroys the call log object. It must not be accessed anymore by the application after calling this function.
 * @param[in] lc #SephoneCore object
 * @param[in] call_log #SephoneCallLog object to remove.
**/
SEPHONE_PUBLIC void sephone_core_remove_call_log(SephoneCore *lc, SephoneCallLog *call_log);

/**
 * @}
**/


/* video support */
SEPHONE_PUBLIC bool_t sephone_core_video_supported(SephoneCore *lc);

/**
 * Enables video globally.
 *
 * This function does not have any effect during calls. It just indicates SephoneCore to
 * initiate future calls with video or not. The two boolean parameters indicate in which
 * direction video is enabled. Setting both to false disables video entirely.
 *
 * @param lc The SephoneCore object
 * @param vcap_enabled indicates whether video capture is enabled
 * @param display_enabled indicates whether video display should be shown
 * @ingroup media_parameters
 * @deprecated Use #sephone_core_enable_video_capture and #sephone_core_enable_video_display instead.
**/
SEPHONE_PUBLIC	void sephone_core_enable_video(SephoneCore *lc, bool_t vcap_enabled, bool_t display_enabled);

/**
 * Returns TRUE if video is enabled, FALSE otherwise.
 * @ingroup media_parameters
 * @deprecated Use #sephone_core_video_capture_enabled and #sephone_core_video_display_enabled instead.
**/
SEPHONE_PUBLIC bool_t sephone_core_video_enabled(SephoneCore *lc);

/**
 * Enable or disable video capture.
 *
 * This function does not have any effect during calls. It just indicates the #SephoneCore to
 * initiate future calls with video capture or not.
 * @param[in] lc #SephoneCore object.
 * @param[in] enable TRUE to enable video capture, FALSE to disable it.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC void sephone_core_enable_video_capture(SephoneCore *lc, bool_t enable);

/**
 * Enable or disable video display.
 *
 * This function does not have any effect during calls. It just indicates the #SephoneCore to
 * initiate future calls with video display or not.
 * @param[in] lc #SephoneCore object.
 * @param[in] enable TRUE to enable video display, FALSE to disable it.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC void sephone_core_enable_video_display(SephoneCore *lc, bool_t enable);


/**
 * Enable or disable video source reuse when switching from preview to actual video call.
 *
 * This source reuse is useful when you always display the preview, even before calls are initiated.
 * By keeping the video source for the transition to a real video call, you will smooth out the
 * source close/reopen cycle.
 *
 * This function does not have any effect durfing calls. It just indicates the #SephoneCore to
 * initiate future calls with video source reuse or not.
 * Also, at the end of a video call, the source will be closed whatsoever for now.
 * @param[in] lc #SephoneCore object
 * @param[in] enable TRUE to enable video source reuse. FALSE to disable it for subsequent calls.
 * @ingroup media_parameters
 *
 */
SEPHONE_PUBLIC void sephone_core_enable_video_source_reuse(SephoneCore* lc, bool_t enable);

/**
 * Tells whether video capture is enabled.
 * @param[in] lc #SephoneCore object.
 * @return TRUE if video capture is enabled, FALSE if disabled.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC bool_t sephone_core_video_capture_enabled(SephoneCore *lc);

/**
 * Tells whether video display is enabled.
 * @param[in] lc #SephoneCore object.
 * @return TRUE if video display is enabled, FALSE if disabled.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC bool_t sephone_core_video_display_enabled(SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_set_video_policy(SephoneCore *lc, const SephoneVideoPolicy *policy);
SEPHONE_PUBLIC const SephoneVideoPolicy *sephone_core_get_video_policy(SephoneCore *lc);

typedef struct MSVideoSizeDef{
	MSVideoSize vsize;
	const char *name;
}MSVideoSizeDef;
/* returns a zero terminated table of MSVideoSizeDef*/
SEPHONE_PUBLIC const MSVideoSizeDef *sephone_core_get_supported_video_sizes(SephoneCore *lc);
SEPHONE_PUBLIC void sephone_core_set_preferred_video_size(SephoneCore *lc, MSVideoSize vsize);
SEPHONE_PUBLIC void sephone_core_set_preview_video_size(SephoneCore *lc, MSVideoSize vsize);
SEPHONE_PUBLIC void sephone_core_set_preview_video_size_by_name(SephoneCore *lc, const char *name);
SEPHONE_PUBLIC MSVideoSize sephone_core_get_preview_video_size(const SephoneCore *lc);
SEPHONE_PUBLIC MSVideoSize sephone_core_get_current_preview_video_size(const SephoneCore *lc);
SEPHONE_PUBLIC MSVideoSize sephone_core_get_preferred_video_size(const SephoneCore *lc);

/**
 * Get the name of the current preferred video size for sending.
 * @param[in] lc #SephoneCore object.
 * @return A string containing the name of the current preferred video size (to be freed with ms_free()).
 */
SEPHONE_PUBLIC char * sephone_core_get_preferred_video_size_name(const SephoneCore *lc);
SEPHONE_PUBLIC void sephone_core_set_preferred_video_size_by_name(SephoneCore *lc, const char *name);
SEPHONE_PUBLIC void sephone_core_set_preferred_framerate(SephoneCore *lc, float fps);
SEPHONE_PUBLIC float sephone_core_get_preferred_framerate(SephoneCore *lc);
SEPHONE_PUBLIC void sephone_core_enable_video_preview(SephoneCore *lc, bool_t val);
SEPHONE_PUBLIC bool_t sephone_core_video_preview_enabled(const SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_enable_self_view(SephoneCore *lc, bool_t val);
SEPHONE_PUBLIC bool_t sephone_core_self_view_enabled(const SephoneCore *lc);


/**
 * Update detection of camera devices.
 *
 * Use this function when the application is notified of USB plug events, so that
 * list of available hardwares for video capture is updated.
 * @param[in] lc #SephoneCore object.
 * @ingroup media_parameters
 **/
SEPHONE_PUBLIC void sephone_core_reload_video_devices(SephoneCore *lc);

/* returns a null terminated static array of string describing the webcams */
SEPHONE_PUBLIC const char**  sephone_core_get_video_devices(const SephoneCore *lc);
SEPHONE_PUBLIC int sephone_core_set_video_device(SephoneCore *lc, const char *id);
SEPHONE_PUBLIC const char *sephone_core_get_video_device(const SephoneCore *lc);

/* Set and get static picture to be used when "Static picture" is the video device */
/**
 * Set the path to the image file to stream when "Static picture" is set as the video device.
 * @param[in] lc #SephoneCore object.
 * @param[in] path The path to the image file to use.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC int sephone_core_set_static_picture(SephoneCore *lc, const char *path);

/**
 * Get the path to the image file streamed when "Static picture" is set as the video device.
 * @param[in] lc #SephoneCore object.
 * @return The path to the image file streamed when "Static picture" is set as the video device.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC const char *sephone_core_get_static_picture(SephoneCore *lc);

/**
 * Set the frame rate for static picture.
 * @param[in] lc #SephoneCore object.
 * @param[in] fps The new frame rate to use for static picture.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC int sephone_core_set_static_picture_fps(SephoneCore *lc, float fps);

/**
 * Get the frame rate for static picture
 * @param[in] lc #SephoneCore object.
 * @return The frame rate used for static picture.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC float sephone_core_get_static_picture_fps(SephoneCore *lc);

/*function to be used for eventually setting window decorations (icons, title...)*/
SEPHONE_PUBLIC unsigned long sephone_core_get_native_video_window_id(const SephoneCore *lc);
SEPHONE_PUBLIC void sephone_core_set_native_video_window_id(SephoneCore *lc, unsigned long id);

SEPHONE_PUBLIC unsigned long sephone_core_get_native_preview_window_id(const SephoneCore *lc);
SEPHONE_PUBLIC void sephone_core_set_native_preview_window_id(SephoneCore *lc, unsigned long id);

/**
 * Tells the core to use a separate window for local camera preview video, instead of
 * inserting local view within the remote video window.
 * @param[in] lc #SephoneCore object.
 * @param[in] yesno TRUE to use a separate window, FALSE to insert the preview in the remote video window.
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC void sephone_core_use_preview_window(SephoneCore *lc, bool_t yesno);

SEPHONE_PUBLIC int sephone_core_get_device_rotation(SephoneCore *lc );
SEPHONE_PUBLIC void sephone_core_set_device_rotation(SephoneCore *lc, int rotation);

/**
 * Get the camera sensor rotation.
 *
 * This is needed on some mobile platforms to get the number of degrees the camera sensor
 * is rotated relative to the screen.
 *
 * @param lc The sephone core related to the operation
 * @return The camera sensor rotation in degrees (0 to 360) or -1 if it could not be retrieved
 */
SEPHONE_PUBLIC int sephone_core_get_camera_sensor_rotation(SephoneCore *lc);

/* start or stop streaming video in case of embedded window */
void sephone_core_show_video(SephoneCore *lc, bool_t show);

/** @deprecated Use sephone_core_set_use_files() instead. */
#define sephone_core_use_files(lc, yesno) sephone_core_set_use_files(lc, yesno)
/*play/record support: use files instead of soundcard*/
SEPHONE_PUBLIC void sephone_core_set_use_files(SephoneCore *lc, bool_t yesno);

/**
 * Get the wav file that is played when putting somebody on hold,
 * or when files are used instead of soundcards (see sephone_core_set_use_files()).
 *
 * The file is a 16 bit linear wav file.
 * @ingroup media_parameters
 * @param[in] lc SephoneCore object
 * @return The path to the file that is played when putting somebody on hold.
 */
SEPHONE_PUBLIC const char * sephone_core_get_play_file(const SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_set_play_file(SephoneCore *lc, const char *file);

/**
 * Get the wav file where incoming stream is recorded,
 * when files are used instead of soundcards (see sephone_core_set_use_files()).
 *
 * This feature is different from call recording (sephone_call_params_set_record_file())
 * The file is a 16 bit linear wav file.
 * @ingroup media_parameters
 * @param[in] lc SephoneCore object
 * @return The path to the file where incoming stream is recorded.
**/
SEPHONE_PUBLIC const char * sephone_core_get_record_file(const SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_set_record_file(SephoneCore *lc, const char *file);

SEPHONE_PUBLIC void sephone_core_play_dtmf(SephoneCore *lc, char dtmf, int duration_ms);
SEPHONE_PUBLIC void sephone_core_stop_dtmf(SephoneCore *lc);

SEPHONE_PUBLIC	int sephone_core_get_current_call_duration(const SephoneCore *lc);


SEPHONE_PUBLIC int sephone_core_get_mtu(const SephoneCore *lc);
SEPHONE_PUBLIC void sephone_core_set_mtu(SephoneCore *lc, int mtu);

/**
 * @ingroup network_parameters
 * This method is called by the application to notify the sephone core library when network is reachable.
 * Calling this method with true trigger sephone to initiate a registration process for all proxies.
 * Calling this method disables the automatic network detection mode. It means you must call this method after each network state changes.
 */
SEPHONE_PUBLIC	void sephone_core_set_network_reachable(SephoneCore* lc,bool_t value);
/**
 * @ingroup network_parameters
 * return network state either as positioned by the application or by sephone itself.
 */
SEPHONE_PUBLIC	bool_t sephone_core_is_network_reachable(SephoneCore* lc);

/**
 *  @ingroup network_parameters
 *  enable signaling keep alive. small udp packet sent periodically to keep udp NAT association
 */
SEPHONE_PUBLIC	void sephone_core_enable_keep_alive(SephoneCore* lc,bool_t enable);
/**
 *  @ingroup network_parameters
 * Is signaling keep alive
 */
SEPHONE_PUBLIC	bool_t sephone_core_keep_alive_enabled(SephoneCore* lc);

SEPHONE_PUBLIC	void *sephone_core_get_user_data(const SephoneCore *lc);
SEPHONE_PUBLIC	void sephone_core_set_user_data(SephoneCore *lc, void *userdata);

/* returns SpConfig object to read/write to the config file: usefull if you wish to extend
the config file with your own sections */
SEPHONE_PUBLIC SpConfig * sephone_core_get_config(SephoneCore *lc);

/**
 * Create a SpConfig object from a user config file.
 * @param[in] lc #SephoneCore object
 * @param[in] filename The filename of the config file to read to fill the instantiated SpConfig
 * @ingroup misc
 */
SEPHONE_PUBLIC SpConfig * sephone_core_create_sp_config(SephoneCore *lc, const char *filename);

/*set a callback for some blocking operations, it takes you informed of the progress of the operation*/
SEPHONE_PUBLIC void sephone_core_set_waiting_callback(SephoneCore *lc, SephoneCoreWaitingCallback cb, void *user_context);

/*returns the list of registered SipSetup (sephonecore plugins) */
SEPHONE_PUBLIC const MSList * sephone_core_get_sip_setups(SephoneCore *lc);

SEPHONE_PUBLIC	void sephone_core_destroy(SephoneCore *lc);

/*for advanced users:*/
typedef RtpTransport * (*SephoneCoreRtpTransportFactoryFunc)(void *data, int port);
struct _SephoneRtpTransportFactories{
	SephoneCoreRtpTransportFactoryFunc audio_rtp_func;
	void *audio_rtp_func_data;
	SephoneCoreRtpTransportFactoryFunc audio_rtcp_func;
	void *audio_rtcp_func_data;
	SephoneCoreRtpTransportFactoryFunc video_rtp_func;
	void *video_rtp_func_data;
	SephoneCoreRtpTransportFactoryFunc video_rtcp_func;
	void *video_rtcp_func_data;
};
typedef struct _SephoneRtpTransportFactories SephoneRtpTransportFactories;

void sephone_core_set_rtp_transport_factories(SephoneCore* lc, SephoneRtpTransportFactories *factories);

int sephone_core_get_current_call_stats(SephoneCore *lc, rtp_stats_t *local, rtp_stats_t *remote);

SEPHONE_PUBLIC	int sephone_core_get_calls_nb(const SephoneCore *lc);

SEPHONE_PUBLIC	const MSList *sephone_core_get_calls(SephoneCore *lc);

SEPHONE_PUBLIC SephoneGlobalState sephone_core_get_global_state(const SephoneCore *lc);
/**
 * force registration refresh to be initiated upon next iterate
 * @ingroup proxies
 */
SEPHONE_PUBLIC void sephone_core_refresh_registers(SephoneCore* lc);

/**
 * Set the path to the file storing the zrtp secrets cache.
 * @param[in] lc #SephoneCore object
 * @param[in] file The path to the file to use to store the zrtp secrets cache.
 * @ingroup initializing
 */
SEPHONE_PUBLIC void sephone_core_set_zrtp_secrets_file(SephoneCore *lc, const char* file);

/**
 * Get the path to the file storing the zrtp secrets cache.
 * @param[in] lc #SephoneCore object.
 * @return The path to the file storing the zrtp secrets cache.
 * @ingroup initializing
 */
SEPHONE_PUBLIC const char *sephone_core_get_zrtp_secrets_file(SephoneCore *lc);

/**
 * Set the path to the directory storing the user's x509 certificates (used by dtls)
 * @param[in] lc #SephoneCore object
 * @param[in] path The path to the directory to use to store the user's certificates.
 * @ingroup initializing
 */
SEPHONE_PUBLIC void sephone_core_set_user_certificates_path(SephoneCore *lc, const char* path);

/**
 * Get the path to the directory storing the user's certificates.
 * @param[in] lc #SephoneCore object.
 * @returns The path to the directory storing the user's certificates.
 * @ingroup initializing
 */
SEPHONE_PUBLIC const char *sephone_core_get_user_certificates_path(SephoneCore *lc);

/**
 * Search from the list of current calls if a remote address match uri
 * @ingroup call_control
 * @param lc
 * @param uri which should match call remote uri
 * @return SephoneCall or NULL is no match is found
 */
SEPHONE_PUBLIC SephoneCall* sephone_core_find_call_from_uri(const SephoneCore *lc, const char *uri);

SEPHONE_PUBLIC	int sephone_core_add_to_conference(SephoneCore *lc, SephoneCall *call);
SEPHONE_PUBLIC	int sephone_core_add_all_to_conference(SephoneCore *lc);
SEPHONE_PUBLIC	int sephone_core_remove_from_conference(SephoneCore *lc, SephoneCall *call);
SEPHONE_PUBLIC	bool_t sephone_core_is_in_conference(const SephoneCore *lc);
SEPHONE_PUBLIC	int sephone_core_enter_conference(SephoneCore *lc);
SEPHONE_PUBLIC	int sephone_core_leave_conference(SephoneCore *lc);
SEPHONE_PUBLIC	float sephone_core_get_conference_local_input_volume(SephoneCore *lc);

SEPHONE_PUBLIC	int sephone_core_terminate_conference(SephoneCore *lc);
SEPHONE_PUBLIC	int sephone_core_get_conference_size(SephoneCore *lc);
SEPHONE_PUBLIC int sephone_core_start_conference_recording(SephoneCore *lc, const char *path);
SEPHONE_PUBLIC int sephone_core_stop_conference_recording(SephoneCore *lc);
/**
 * Get the maximum number of simultaneous calls Sephone core can manage at a time. All new call above this limit are declined with a busy answer
 * @ingroup initializing
 * @param lc core
 * @return max number of simultaneous calls
 */
SEPHONE_PUBLIC int sephone_core_get_max_calls(SephoneCore *lc);
/**
 * Set the maximum number of simultaneous calls Sephone core can manage at a time. All new call above this limit are declined with a busy answer
 * @ingroup initializing
 * @param lc core
 * @param max number of simultaneous calls
 */
SEPHONE_PUBLIC void sephone_core_set_max_calls(SephoneCore *lc, int max);

SEPHONE_PUBLIC	bool_t sephone_core_sound_resources_locked(SephoneCore *lc);
/**
 * @ingroup initializing
 * Check if a media encryption type is supported
 * @param lc core
 * @param menc SephoneMediaEncryption
 * @return whether a media encryption scheme is supported by the SephoneCore engine
**/

SEPHONE_PUBLIC	bool_t sephone_core_media_encryption_supported(const SephoneCore *lc, SephoneMediaEncryption menc);

/**
 * Choose the media encryption policy to be used for RTP packets.
 * @param[in] lc #SephoneCore object.
 * @param[in] menc The media encryption policy to be used.
 * @return 0 if successful, any other value otherwise.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC	int sephone_core_set_media_encryption(SephoneCore *lc, SephoneMediaEncryption menc);

/**
 * Get the media encryption policy being used for RTP packets.
 * @param[in] lc #SephoneCore object.
 * @return The media encryption policy being used.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC	SephoneMediaEncryption sephone_core_get_media_encryption(SephoneCore *lc);

/**
 * Get behaviour when encryption parameters negociation fails on outgoing call.
 * @param[in] lc #SephoneCore object.
 * @return TRUE means the call will fail; FALSE means an INVITE will be resent with encryption disabled.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC	bool_t sephone_core_is_media_encryption_mandatory(SephoneCore *lc);

/**
 * Define behaviour when encryption parameters negociation fails on outgoing call.
 * @param[in] lc #SephoneCore object.
 * @param[in] m If set to TRUE call will fail; if set to FALSE will resend an INVITE with encryption disabled.
 * @ingroup media_parameters
 */
SEPHONE_PUBLIC	void sephone_core_set_media_encryption_mandatory(SephoneCore *lc, bool_t m);

/**
 * Init call params using SephoneCore's current configuration
 */
SEPHONE_PUBLIC	void sephone_core_init_default_params(SephoneCore*lc, SephoneCallParams *params);

/**
 * True if tunnel support was compiled.
 *  @ingroup tunnel
 */
SEPHONE_PUBLIC	bool_t sephone_core_tunnel_available(void);

/**
 * Sephone tunnel object.
 * @ingroup tunnel
 */
typedef struct _SephoneTunnel SephoneTunnel;

/**
* get tunnel instance if available
* @ingroup tunnel
* @param lc core object
* @returns SephoneTunnel or NULL if not available
*/
SEPHONE_PUBLIC	SephoneTunnel *sephone_core_get_tunnel(const SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_set_sip_dscp(SephoneCore *lc, int dscp);
SEPHONE_PUBLIC int sephone_core_get_sip_dscp(const SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_set_audio_dscp(SephoneCore *lc, int dscp);
SEPHONE_PUBLIC int sephone_core_get_audio_dscp(const SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_set_video_dscp(SephoneCore *lc, int dscp);
SEPHONE_PUBLIC int sephone_core_get_video_dscp(const SephoneCore *lc);

SEPHONE_PUBLIC const char *sephone_core_get_video_display_filter(SephoneCore *lc);
SEPHONE_PUBLIC void sephone_core_set_video_display_filter(SephoneCore *lc, const char *filtername);

/** Contact Providers
  */

typedef unsigned int ContactSearchID;

typedef struct _SephoneContactSearch SephoneContactSearch;
typedef struct _SephoneContactProvider SephoneContactProvider;

typedef void (*ContactSearchCallback)( SephoneContactSearch* id, MSList* friends, void* data );

/*
 * Remote provisioning
 */

/**
 * Set URI where to download xml configuration file at startup.
 * This can also be set from configuration file or factory config file, from [misc] section, item "config-uri".
 * Calling this function does not load the configuration. It will write the value into configuration so that configuration
 * from remote URI will take place at next SephoneCore start.
 * @param lc the sephone core
 * @param uri the http or https uri to use in order to download the configuration.
 * @ingroup initializing
**/
SEPHONE_PUBLIC void sephone_core_set_provisioning_uri(SephoneCore *lc, const char*uri);

/**
 * Get provisioning URI.
 * @param lc the sephone core
 * @return the provisioning URI.
 * @ingroup initializing
**/
SEPHONE_PUBLIC const char* sephone_core_get_provisioning_uri(const SephoneCore *lc);

/**
 * Gets if the provisioning URI should be removed after it's been applied successfully
 * @param lc the sephone core
 * @return TRUE if the provisioning URI should be removed, FALSE otherwise
 */
SEPHONE_PUBLIC bool_t sephone_core_is_provisioning_transient(SephoneCore *lc);

SEPHONE_PUBLIC int sephone_core_migrate_to_multi_transport(SephoneCore *lc);


/**
 * Control when media offer is sent in SIP INVITE.
 * @param lc the sephone core
 * @param enable true if INVITE has to be sent whitout SDP.
 * @ingroup network_parameters
**/
SEPHONE_PUBLIC void sephone_core_enable_sdp_200_ack(SephoneCore *lc, bool_t enable);
/**
 * Media offer control param for SIP INVITE.
 * @return true if INVITE has to be sent whitout SDP.
 * @ingroup network_parameters
**/
SEPHONE_PUBLIC bool_t sephone_core_sdp_200_ack_enabled(const SephoneCore *lc);


/**
 * Enum listing frequent telephony tones.
**/
enum _SephoneToneID{
	SephoneToneUndefined, /**<Not a tone */
	SephoneToneBusy, /**<Busy tone */
	SephoneToneCallWaiting, /**Call waiting tone */
	SephoneToneCallOnHold, /**Call on hold tone */
	SephoneToneCallLost /**Tone played when call is abruptly disconnected (media lost)*/
};

/**
 * Enum typedef for representing frequent telephony tones.
**/
typedef enum _SephoneToneID SephoneToneID;


SEPHONE_PUBLIC void sephone_core_set_call_error_tone(SephoneCore *lc, SephoneReason reason, const char *audiofile);

SEPHONE_PUBLIC void sephone_core_set_tone(SephoneCore *lc, SephoneToneID id, const char *audiofile);

/**
 * Globaly set an http file transfer server to be used for content type application/vnd.gsma.rcs-ft-http+xml. This value can also be set for a dedicated account using #sephone_proxy_config_set_file_transfer_server
 * @param[in] core #SephoneCore to be modified
 * @param[in] server_url URL of the file server like https://file.linphone.org/upload.php
 * @ingroup misc
 * */
SEPHONE_PUBLIC void sephone_core_set_file_transfer_server(SephoneCore *core, const char * server_url);

/**
 * Get the globaly set http file transfer server to be used for content type application/vnd.gsma.rcs-ft-http+xml.
 * @param[in] core #SephoneCore from which to get the server_url
 * @return URL of the file server like https://file.linphone.org/upload.php
 * @ingroup misc
 * */
SEPHONE_PUBLIC const char * sephone_core_get_file_transfer_server(SephoneCore *core);

/**
 * Returns a null terminated table of strings containing the file format extension supported for call recording.
 * @param core the core
 * @return the supported formats, typically 'wav' and 'mkv'
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC const char ** sephone_core_get_supported_file_formats(SephoneCore *core);

SEPHONE_PUBLIC void sephone_core_add_supported_tag(SephoneCore *core, const char *tag);

SEPHONE_PUBLIC void sephone_core_remove_supported_tag(SephoneCore *core, const char *tag);

SEPHONE_PUBLIC void sephone_core_set_avpf_mode(SephoneCore *lc, SephoneAVPFMode mode);

SEPHONE_PUBLIC SephoneAVPFMode sephone_core_get_avpf_mode(const SephoneCore *lc);

SEPHONE_PUBLIC void sephone_core_set_avpf_rr_interval(SephoneCore *lc, int interval);

SEPHONE_PUBLIC int sephone_core_get_avpf_rr_interval(const SephoneCore *lc);

/**
 * Use to set multicast address to be used for audio stream.
 * @param core #SephoneCore
 * @param ip an ipv4/6 multicast address
 * @return 0 in case of success
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC int sephone_core_set_audio_multicast_addr(SephoneCore *core, const char* ip);
/**
 * Use to set multicast address to be used for video stream.
 * @param core #SephoneCore
 * @param ip an ipv4/6 multicast address
 * @return 0 in case of success
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC int sephone_core_set_video_multicast_addr(SephoneCore *lc, const char *ip);

/**
 * Use to get multicast address to be used for audio stream.
 * @param core #SephoneCore
 * @return an ipv4/6 multicast address or default value
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC const char* sephone_core_get_audio_multicast_addr(const SephoneCore *core);

/**
 * Use to get multicast address to be used for video stream.
 * @param core #SephoneCore
 * @return an ipv4/6 multicast address, or default value
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC const char* sephone_core_get_video_multicast_addr(const SephoneCore *core);

/**
 * Use to set multicast ttl to be used for audio stream.
 * @param core #SephoneCore
 * @param ttl value or -1 if not used. [0..255] default value is 1
 * @return 0 in case of success
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC int sephone_core_set_audio_multicast_ttl(SephoneCore *core, int ttl);
/**
 * Use to set multicast ttl to be used for video stream.
 * @param core #SephoneCore
 * @param  ttl value or -1 if not used. [0..255] default value is 1
 * @return 0 in case of success
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC int sephone_core_set_video_multicast_ttl(SephoneCore *lc, int ttl);

/**
 * Use to get multicast ttl to be used for audio stream.
 * @param core #SephoneCore
 * @return a time to leave value
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC int sephone_core_get_audio_multicast_ttl(const SephoneCore *core);

/**
 * Use to get multicast ttl to be used for video stream.
 * @param core #SephoneCore
 * @return a time to leave value
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC int sephone_core_get_video_multicast_ttl(const SephoneCore *core);


/**
 * Use to enable multicast rtp for audio stream.
 * * If enabled, outgoing calls put a multicast address from #sephone_core_get_video_multicast_addr into audio cline. In case of outgoing call audio stream is sent to this multicast address.
 * <br> For incoming calls behavior is unchanged.
 * @param core #SephoneCore
 * @param yesno if yes, subsequent calls will propose multicast ip set by #sephone_core_set_audio_multicast_addr
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC void sephone_core_enable_audio_multicast(SephoneCore *core, bool_t yesno);

/**
 * Use to get multicast state of audio stream.
 * @param core #SephoneCore
 * @return true if  subsequent calls will propose multicast ip set by #sephone_core_set_audio_multicast_addr
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC bool_t sephone_core_audio_multicast_enabled(const SephoneCore *core);

/**
 * Use to enable multicast rtp for video stream.
 * If enabled, outgoing calls put a multicast address from #sephone_core_get_video_multicast_addr into video cline. In case of outgoing call video stream is sent to this  multicast address.
 * <br> For incoming calls behavior is unchanged.
 * @param core #SephoneCore
 * @param yesno if yes, subsequent outgoing calls will propose multicast ip set by #sephone_core_set_video_multicast_addr
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC void sephone_core_enable_video_multicast(SephoneCore *core, bool_t yesno);
/**
 * Use to get multicast state of video stream.
 * @param core #SephoneCore
 * @return true if  subsequent calls will propose multicast ip set by #sephone_core_set_video_multicast_addr
 * @ingroup media_parameters
**/
SEPHONE_PUBLIC bool_t sephone_core_video_multicast_enabled(const SephoneCore *core);

/**
 * Set the network simulator parameters.
 * Libsephone has the capabability of simulating the effects of a network (latency, lost packets, jitter, max bandwidth).
 * Please refer to the oRTP documentation for the meaning of the parameters of the OrtpNetworkSimulatorParams structure.
 * This function has effect for future calls, but not for currently running calls, though this behavior may be changed in future versions.
 * @warning Due to design of network simulation in oRTP, simulation is applied independently for audio and video stream. This means for example that a bandwidth
 * limit of 250kbit/s will have no effect on an audio stream running at 40kbit/s while a videostream targetting 400kbit/s will be highly affected.
 * @param lc the SephoneCore
 * @param params the parameters used for the network simulation.
 * @return 0 if successful, -1 otherwise.
**/
SEPHONE_PUBLIC int sephone_core_set_network_simulator_params(SephoneCore *lc, const OrtpNetworkSimulatorParams *params);


/**
 * Get the previously set network simulation parameters.
 * @see sephone_core_set_network_simulator_params
 * @return a OrtpNetworkSimulatorParams structure.
**/
SEPHONE_PUBLIC const OrtpNetworkSimulatorParams *sephone_core_get_network_simulator_params(const SephoneCore *lc);

#ifdef __cplusplus
}
#endif

#endif
