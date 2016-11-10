/*
call_params.h
Copyright (C) 2010-2014  Belledonne Communications SARL

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


#ifndef __SEPHONE_CALL_PARAMS_H__
#define __SEPHONE_CALL_PARAMS_H__

/**
 * @addtogroup call_control
 * @{
**/


/*******************************************************************************
 * Structures and enums                                                        *
 ******************************************************************************/
/**
 * Indicates for a given media the stream direction
 * */
enum _SephoneMediaDirection {
	SephoneMediaDirectionInactive, /** No active media not supported yet*/
	SephoneMediaDirectionSendOnly, /** Send only mode*/
	SephoneMediaDirectionRecvOnly, /** recv only mode*/
	SephoneMediaDirectionSendRecv, /*send receive mode not supported yet*/

};
/**
 * Typedef for enum
**/
typedef enum _SephoneMediaDirection SephoneMediaDirection;

/**
 * Private structure definition for SephoneCallParams.
**/
struct _SephoneCallParams;

/**
 * The SephoneCallParams is an object containing various call related parameters.
 * It can be used to retrieve parameters from a currently running call or modify
 * the call's characteristics dynamically.
**/
typedef struct _SephoneCallParams SephoneCallParams;


/*******************************************************************************
 * Public functions                                                            *
 ******************************************************************************/

/**
 * Add a custom SIP header in the INVITE for a call.
 * @param[in] cp The #SephoneCallParams to add a custom SIP header to.
 * @param[in] header_name The name of the header to add.
 * @param[in] header_value The content of the header to add.
**/
SEPHONE_PUBLIC void sephone_call_params_add_custom_header(SephoneCallParams *cp, const char *header_name, const char *header_value);

/**
 * Copy an existing SephoneCallParams object to a new SephoneCallParams object.
 * @param[in] cp The SephoneCallParams object to copy.
 * @return A copy of the SephoneCallParams object.
**/
SEPHONE_PUBLIC SephoneCallParams * sephone_call_params_copy(const SephoneCallParams *cp);

/**
 * Indicate whether sending of early media was enabled.
 * @param[in] cp SephoneCallParams object
 * @return A boolean value telling whether sending of early media was enabled.
**/
SEPHONE_PUBLIC bool_t sephone_call_params_early_media_sending_enabled(const SephoneCallParams *cp);

/**
 * Enable sending of real early media (during outgoing calls).
 * @param[in] cp SephoneCallParams object
 * @param[in] enabled A boolean value telling whether to enable early media sending or not.
**/
SEPHONE_PUBLIC void sephone_call_params_enable_early_media_sending(SephoneCallParams *cp, bool_t enabled);

/**
 * Indicate low bandwith mode.
 * Configuring a call to low bandwidth mode will result in the core to activate several settings for the call in order to ensure that bitrate usage
 * is lowered to the minimum possible. Typically, ptime (packetization time) will be increased, audio codec's output bitrate will be targetted to 20kbit/s provided
 * that it is achievable by the codec selected after SDP handshake. Video is automatically disabled.
 * @param[in] cp SephoneCallParams object
 * @param[in] enabled A boolean value telling whether to activate the low bandwidth mode or not.
**/
SEPHONE_PUBLIC void sephone_call_params_enable_low_bandwidth(SephoneCallParams *cp, bool_t enabled);

/**
 * Enable video stream.
 * @param[in] cp SephoneCallParams object
 * @param[in] enabled A boolean value telling whether to enable video or not.
**/
SEPHONE_PUBLIC void sephone_call_params_enable_video(SephoneCallParams *cp, bool_t enabled);

/**
 * Get a custom SIP header.
 * @param[in] cp The #SephoneCallParams to get the custom SIP header from.
 * @param[in] header_name The name of the header to get.
 * @return The content of the header or NULL if not found.
**/
SEPHONE_PUBLIC const char *sephone_call_params_get_custom_header(const SephoneCallParams *cp, const char *header_name);

/**
 * Tell whether the call is part of the locally managed conference.
 * @param[in] cp SephoneCallParams object
 * @return A boolean value telling whether the call is part of the locally managed conference.
**/
SEPHONE_PUBLIC bool_t sephone_call_params_get_local_conference_mode(const SephoneCallParams *cp);

/**
 * Get the kind of media encryption selected for the call.
 * @param[in] cp SephoneCallParams object
 * @return The kind of media encryption selected for the call.
**/
SEPHONE_PUBLIC SephoneMediaEncryption sephone_call_params_get_media_encryption(const SephoneCallParams *cp);

/**
 * Get requested level of privacy for the call.
 * @param[in] cp SephoneCallParams object
 * @return The privacy mode used for the call.
**/
SEPHONE_PUBLIC SephonePrivacyMask sephone_call_params_get_privacy(const SephoneCallParams *cp);

/**
 * Get the framerate of the video that is received.
 * @param[in] cp SephoneCallParams object
 * @return The actual received framerate in frames per seconds, 0 if not available.
 */
SEPHONE_PUBLIC float sephone_call_params_get_received_framerate(const SephoneCallParams *cp);

/**
 * Get the size of the video that is received.
 * @param[in] cp SephoneCallParams object
 * @return The received video size or MS_VIDEO_SIZE_UNKNOWN if not available.
 */
SEPHONE_PUBLIC MSVideoSize sephone_call_params_get_received_video_size(const SephoneCallParams *cp);

/**
 * Get the path for the audio recording of the call.
 * @param[in] cp SephoneCallParams object
 * @return The path to the audio recording of the call.
**/
SEPHONE_PUBLIC const char *sephone_call_params_get_record_file(const SephoneCallParams *cp);

/**
 * Get the RTP profile being used.
 * @param[in] cp #SephoneCallParams object
 * @return The RTP profile.
 */
SEPHONE_PUBLIC const char * sephone_call_params_get_rtp_profile(const SephoneCallParams *cp);

/**
 * Get the framerate of the video that is sent.
 * @param[in] cp SephoneCallParams object
 * @return The actual sent framerate in frames per seconds, 0 if not available.
 */
SEPHONE_PUBLIC float sephone_call_params_get_sent_framerate(const SephoneCallParams *cp);

/**
 * Gets the size of the video that is sent.
 * @param[in] cp SephoneCalParams object
 * @return The sent video size or MS_VIDEO_SIZE_UNKNOWN if not available.
 */
SEPHONE_PUBLIC MSVideoSize sephone_call_params_get_sent_video_size(const SephoneCallParams *cp);

/**
 * Get the session name of the media session (ie in SDP).
 * Subject from the SIP message can be retrieved using sephone_call_params_get_custom_header() and is different.
 * @param[in] cp SephoneCallParams object
 * @return The session name of the media session.
**/
SEPHONE_PUBLIC const char *sephone_call_params_get_session_name(const SephoneCallParams *cp);

/**
 * Get the audio codec used in the call, described as a SephonePayloadType object.
 * @param[in] cp SephoneCallParams object
 * @return The SephonePayloadType object corresponding to the audio codec being used in the call.
**/
SEPHONE_PUBLIC const SephonePayloadType* sephone_call_params_get_used_audio_codec(const SephoneCallParams *cp);

/**
 * Get the video codec used in the call, described as a SephonePayloadType structure.
 * @param[in] cp SephoneCallParams object
 * @return The SephonePayloadType object corresponding to the video codec being used in the call.
**/
SEPHONE_PUBLIC const SephonePayloadType* sephone_call_params_get_used_video_codec(const SephoneCallParams *cp);

/**
 * Tell whether the call has been configured in low bandwidth mode or not.
 * This mode can be automatically discovered thanks to a stun server when activate_edge_workarounds=1 in section [net] of configuration file.
 * An application that would have reliable way to know network capacity may not use activate_edge_workarounds=1 but instead manually configure
 * low bandwidth mode with sephone_call_params_enable_low_bandwidth().
 * When enabled, this param may transform a call request with video in audio only mode.
 * @param[in] cp SephoneCallParams object
 * @return A boolean value telling whether the low bandwidth mode has been configured/detected.
 */
SEPHONE_PUBLIC bool_t sephone_call_params_low_bandwidth_enabled(const SephoneCallParams *cp);

/**
 * Refine bandwidth settings for this call by setting a bandwidth limit for audio streams.
 * As a consequence, codecs whose bitrates are not compatible with this limit won't be used.
 * @param[in] cp SephoneCallParams object
 * @param[in] bw The audio bandwidth limit to set in kbit/s.
**/
SEPHONE_PUBLIC void sephone_call_params_set_audio_bandwidth_limit(SephoneCallParams *cp, int bw);

/**
 * Set requested media encryption for a call.
 * @param[in] cp SephoneCallParams object
 * @param[in] enc The media encryption to use for the call.
**/
SEPHONE_PUBLIC void sephone_call_params_set_media_encryption(SephoneCallParams *cp, SephoneMediaEncryption enc);

/**
 * Set requested level of privacy for the call.
 * \xmlonly <language-tags>javascript</language-tags> \endxmlonly
 * @param[in] cp SephoneCallParams object
 * @param[in] privacy The privacy mode to used for the call.
**/
SEPHONE_PUBLIC void sephone_call_params_set_privacy(SephoneCallParams *params, SephonePrivacyMask privacy);

/**
 * Enable recording of the call.
 * This function must be used before the call parameters are assigned to the call.
 * The call recording can be started and paused after the call is established with
 * sephone_call_start_recording() and sephone_call_pause_recording().
 * @param[in] cp SephoneCallParams object
 * @param[in] path A string containing the path and filename of the file where audio/video streams are to be written.
 * The filename must have either .mkv or .wav extention. The video stream will be written only if a MKV file is given.
**/
SEPHONE_PUBLIC void sephone_call_params_set_record_file(SephoneCallParams *cp, const char *path);

/**
 * Set the session name of the media session (ie in SDP).
 * Subject from the SIP message (which is different) can be set using sephone_call_params_set_custom_header().
 * @param[in] cp SephoneCallParams object
 * @param[in] name The session name to be used.
**/
SEPHONE_PUBLIC void sephone_call_params_set_session_name(SephoneCallParams *cp, const char *name);

/**
 * Tell whether video is enabled or not.
 * @param[in] cp SephoneCallParams object
 * @return A boolean value telling whether video is enabled or not.
**/
SEPHONE_PUBLIC bool_t sephone_call_params_video_enabled(const SephoneCallParams *cp);

/**
 * Get the audio stream direction.
 * @param[in] cl SephoneCallParams object
 * @return The audio stream direction associated with the call params.
**/
SEPHONE_PUBLIC  SephoneMediaDirection sephone_call_params_get_audio_direction(const SephoneCallParams *cp);

/**
 * Get the video stream direction.
 * @param[in] cl SephoneCallParams object
 * @return The video stream direction associated with the call params.
**/
SEPHONE_PUBLIC  SephoneMediaDirection sephone_call_params_get_video_direction(const SephoneCallParams *cp);

/**
 * Set the audio stream direction. Only relevant for multicast
 * @param[in] cl SephoneCallParams object
 * @param[in] The audio stream direction associated with this call params.
**/
SEPHONE_PUBLIC void sephone_call_params_set_audio_direction(SephoneCallParams *cp, SephoneMediaDirection dir);

/**
 * Set the video stream direction. Only relevant for multicast
 * @param[in] cl SephoneCallParams object
 * @param[in] The video stream direction associated with this call params.
**/
SEPHONE_PUBLIC void sephone_call_params_set_video_direction(SephoneCallParams *cp, SephoneMediaDirection dir);


/*******************************************************************************
 * Reference and user data handling functions                                  *
 ******************************************************************************/

/**
 * Get the user data associated with the call params.
 * @param[in] cl SephoneCallParams object
 * @return The user data associated with the call params.
**/
SEPHONE_PUBLIC void *sephone_call_params_get_user_data(const SephoneCallParams *cp);

/**
 * Assign a user data to the call params.
 * @param[in] cl SephoneCallParams object
 * @param[in] ud The user data to associate with the call params.
**/
SEPHONE_PUBLIC void sephone_call_params_set_user_data(SephoneCallParams *cp, void *ud);

/**
 * Acquire a reference to the call params.
 * @param[in] cl SephoneCallParams object
 * @return The same SephoneCallParams object
**/
SEPHONE_PUBLIC SephoneCallParams * sephone_call_params_ref(SephoneCallParams *cp);

/**
 * Release a reference to the call params.
 * @param[in] cl SephoneCallParams object
**/
SEPHONE_PUBLIC void sephone_call_params_unref(SephoneCallParams *cp);


/*******************************************************************************
 * DEPRECATED                                                                  *
 ******************************************************************************/

/** @deprecated Use sephone_call_params_get_local_conference_mode() instead. */
#define sephone_call_params_local_conference_mode sephone_call_params_get_local_conference_mode

/**
 * Destroy a SephoneCallParams object.
 * @param[in] cp SephoneCallParams object
 * @deprecated Use sephone_call_params_unref() instead.
**/
SEPHONE_PUBLIC void sephone_call_params_destroy(SephoneCallParams *cp);


/**
 * @}
**/


#endif /* __SEPHONE_CALL_PARAMS_H__ */
