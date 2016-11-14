/*
sephonefriend.h
Copyright (C) 2010  Belledonne Communications SARL

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

#ifndef SEPHONEFRIEND_H_
#define SEPHONEFRIEND_H_

#include "sephonepresence.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @addtogroup buddy_list
 * @{
 */
/**
 * Enum controlling behavior for incoming subscription request.
 * <br> Use by sephone_friend_set_inc_subscribe_policy()
 */
typedef enum _SephoneSubscribePolicy {
	/**
	 * Does not automatically accept an incoming subscription request.
	 * This policy implies that a decision has to be taken for each incoming subscription request notified by callback SephoneCoreVTable.new_subscription_requested
	 *
	 */
	SephoneSPWait,
	/**
	 * Rejects incoming subscription request.
	 */
	SephoneSPDeny,
	/**
	 * Automatically accepts a subscription request.
	 */
	SephoneSPAccept
} SephoneSubscribePolicy;

/**
 * Enum describing remote friend status
 * @deprecated Use #SephonePresenceModel and #SephonePresenceActivity instead
 */
typedef enum _SephoneOnlineStatus{
	/**
	 * Offline
	 */
	SephoneStatusOffline,
	/**
	 * Online
	 */
	SephoneStatusOnline,
	/**
	 * Busy
	 */
	SephoneStatusBusy,
	/**
	 * Be right back
	 */
	SephoneStatusBeRightBack,
	/**
	 * Away
	 */
	SephoneStatusAway,
	/**
	 * On the phone
	 */
	SephoneStatusOnThePhone,
	/**
	 * Out to lunch
	 */
	SephoneStatusOutToLunch,
	/**
	 * Do not disturb
	 */
	SephoneStatusDoNotDisturb,
	/**
	 * Moved in this sate, call can be redirected if an alternate contact address has been set using function sephone_core_set_presence_info()
	 */
	SephoneStatusMoved,
	/**
	 * Using another messaging service
	 */
	SephoneStatusAltService,
	/**
	 * Pending
	 */
	SephoneStatusPending,
	/**
	 * Vacation
	 */
	SephoneStatusVacation,

	SephoneStatusEnd
}SephoneOnlineStatus;


struct _SephoneFriend;
/**
 * Represents a buddy, all presence actions like subscription and status change notification are performed on this object
 */
typedef struct _SephoneFriend SephoneFriend;

/**
 * Contructor
 * @return a new empty #SephoneFriend
 */
SEPHONE_PUBLIC SephoneFriend * sephone_friend_new(void);

/**
 * Contructor same as sephone_friend_new() + sephone_friend_set_address()
 * @param addr a buddy address, must be a sip uri like sip:joe@sip.linphone.org
 * @return a new #SephoneFriend with \link sephone_friend_get_address() address initialized \endlink
 */
SEPHONE_PUBLIC	SephoneFriend *sephone_friend_new_with_address(const char *addr);

/**
 * Contructor same as sephone_friend_new() + sephone_friend_set_address()
 * @deprecated Use #sephone_friend_new_with_address instead
 */
#define sephone_friend_new_with_addr sephone_friend_new_with_address

/**
 * Destroy a SephoneFriend.
 * @param lf SephoneFriend object
 * @deprecated Use sephone_friend_unref() instead.
 */
SEPHONE_PUBLIC void sephone_friend_destroy(SephoneFriend *lf);

/**
 * Set #SephoneAddress for this friend
 * @param fr #SephoneFriend object
 * @param address #SephoneAddress
 */
SEPHONE_PUBLIC int sephone_friend_set_address(SephoneFriend *fr, const SephoneAddress* address);

/**
 * Set #SephoneAddress for this friend
 * @deprecated Use #sephone_friend_set_address instead
 */
#define sephone_friend_set_addr sephone_friend_set_address

/**
 * Get address of this friend
 * @param lf #SephoneFriend object
 * @return #SephoneAddress
 */
SEPHONE_PUBLIC	const SephoneAddress *sephone_friend_get_address(const SephoneFriend *lf);

/**
 * Set the display name for this friend
 * @param lf #SephoneFriend object
 * @param name 
 */
SEPHONE_PUBLIC int sephone_friend_set_name(SephoneFriend *lf, const char *name);

/**
 * Get the display name for this friend
 * @param lf #SephoneFriend object
 * @return The display name of this friend
 */
SEPHONE_PUBLIC const char * sephone_friend_get_name(const SephoneFriend *lf);

/**
 * get subscription flag value
 * @param lf #SephoneFriend object
 * @return returns true is subscription is activated for this friend
 *
 */
SEPHONE_PUBLIC bool_t sephone_friend_subscribes_enabled(const SephoneFriend *lf);
#define sephone_friend_get_send_subscribe sephone_friend_subscribes_enabled

/**
 * Configure #SephoneFriend to subscribe to presence information
 * @param fr #SephoneFriend object
 * @param val if TRUE this friend will receive subscription message
 */

SEPHONE_PUBLIC	int sephone_friend_enable_subscribes(SephoneFriend *fr, bool_t val);
#define sephone_friend_send_subscribe sephone_friend_enable_subscribes

/**
 * Configure incoming subscription policy for this friend.
 * @param fr #SephoneFriend object
 * @param pol #SephoneSubscribePolicy policy to apply.
 */
SEPHONE_PUBLIC int sephone_friend_set_inc_subscribe_policy(SephoneFriend *fr, SephoneSubscribePolicy pol);

/**
 * get current subscription policy for this #SephoneFriend
 * @param lf #SephoneFriend object
 * @return #SephoneSubscribePolicy
 *
 */
SEPHONE_PUBLIC SephoneSubscribePolicy sephone_friend_get_inc_subscribe_policy(const SephoneFriend *lf);

/**
 * Starts editing a friend configuration.
 *
 * Because friend configuration must be consistent, applications MUST
 * call sephone_friend_edit() before doing any attempts to modify
 * friend configuration (such as \link sephone_friend_set_address() address \endlink  or \link sephone_friend_set_inc_subscribe_policy() subscription policy\endlink  and so on).
 * Once the modifications are done, then the application must call
 * sephone_friend_done() to commit the changes.
**/
SEPHONE_PUBLIC	void sephone_friend_edit(SephoneFriend *fr);

/**
 * Commits modification made to the friend configuration.
 * @param fr #SephoneFriend object
**/
SEPHONE_PUBLIC	void sephone_friend_done(SephoneFriend *fr);

/**
 * Get the status of a friend
 * @param[in] lf A #SephoneFriend object
 * @return #SephoneOnlineStatus
 * @deprecated Use sephone_friend_get_presence_model() instead
 */
SEPHONE_PUBLIC SephoneOnlineStatus sephone_friend_get_status(const SephoneFriend *lf);

/**
 * Get the presence model of a friend
 * @param[in] lf A #SephoneFriend object
 * @return A #SephonePresenceModel object, or NULL if the friend do not have presence information (in which case he is considered offline)
 */
SEPHONE_PUBLIC const SephonePresenceModel * sephone_friend_get_presence_model(SephoneFriend *lf);

/**
 * Store user pointer to friend object.
**/
SEPHONE_PUBLIC void sephone_friend_set_user_data(SephoneFriend *lf, void *data);

/**
 * Retrieve user data associated with friend.
**/
SEPHONE_PUBLIC void* sephone_friend_get_user_data(const SephoneFriend *lf);

SEPHONE_PUBLIC BuddyInfo * sephone_friend_get_info(const SephoneFriend *lf);

/**
 * Set the reference key of a friend.
 * @param[in] lf #SephoneFriend object.
 * @param[in] key The reference key to use for the friend.
**/
SEPHONE_PUBLIC void sephone_friend_set_ref_key(SephoneFriend *lf, const char *key);

/**
 * Get the reference key of a friend.
 * @param[in] lf #SephoneFriend object.
 * @return The reference key of the friend.
**/
SEPHONE_PUBLIC const char *sephone_friend_get_ref_key(const SephoneFriend *lf);

/**
 * Check that the given friend is in a friend list.
 * @param[in] lf #SephoneFriend object.
 * @return TRUE if the friend is in a friend list, FALSE otherwise.
**/
SEPHONE_PUBLIC bool_t sephone_friend_in_list(const SephoneFriend *lf);


/**
 * Return humain readable presence status
 * @param ss
 * @deprecated Use #SephonePresenceModel, #SephonePresenceActivity and sephone_presence_activity_to_string() instead.
 */
SEPHONE_PUBLIC const char *sephone_online_status_to_string(SephoneOnlineStatus ss);


/**
 * Create a default SephoneFriend.
 * @param[in] lc #SephoneCore object
 * @return The created #SephoneFriend object
 */
SEPHONE_PUBLIC SephoneFriend * sephone_core_create_friend(SephoneCore *lc);

/**
 * Create a SephoneFriend from the given address.
 * @param[in] lc #SephoneCore object
 * @param[in] address A string containing the address to create the SephoneFriend from
 * @return The created #SephoneFriend object
 */
SEPHONE_PUBLIC SephoneFriend * sephone_core_create_friend_with_address(SephoneCore *lc, const char *address);

/**
 * Set my presence status
 * @param[in] lc #SephoneCore object
 * @param[in] minutes_away how long in away
 * @param[in] alternative_contact sip uri used to redirect call in state #SephoneStatusMoved
 * @param[in] os #SephoneOnlineStatus
 * @deprecated Use sephone_core_set_presence_model() instead
 */
SEPHONE_PUBLIC void sephone_core_set_presence_info(SephoneCore *lc,int minutes_away,const char *alternative_contact,SephoneOnlineStatus os);

/**
 * Set my presence model
 * @param[in] lc #SephoneCore object
 * @param[in] presence #SephonePresenceModel
 */
SEPHONE_PUBLIC void sephone_core_set_presence_model(SephoneCore *lc, SephonePresenceModel *presence);

/**
 * Get my presence status
 * @param[in] lc #SephoneCore object
 * @return #SephoneOnlineStatus
 * @deprecated Use sephone_core_get_presence_model() instead
 */
SEPHONE_PUBLIC SephoneOnlineStatus sephone_core_get_presence_info(const SephoneCore *lc);

/**
 * Get my presence model
 * @param[in] lc #SephoneCore object
 * @return A #SephonePresenceModel object, or NULL if no presence model has been set.
 */
SEPHONE_PUBLIC SephonePresenceModel * sephone_core_get_presence_model(const SephoneCore *lc);

/**
 * @deprecated Use sephone_core_interpret_url() instead
 */
SEPHONE_PUBLIC void sephone_core_interpret_friend_uri(SephoneCore *lc, const char *uri, char **result);

/**
 * Add a friend to the current buddy list, if \link sephone_friend_enable_subscribes() subscription attribute \endlink is set, a SIP SUBSCRIBE message is sent.
 * @param lc #SephoneCore object
 * @param fr #SephoneFriend to add
 */
SEPHONE_PUBLIC	void sephone_core_add_friend(SephoneCore *lc, SephoneFriend *fr);

/**
 * remove a friend from the buddy list
 * @param lc #SephoneCore object
 * @param fr #SephoneFriend to add
 */
SEPHONE_PUBLIC void sephone_core_remove_friend(SephoneCore *lc, SephoneFriend *fr);

/**
 * Black list a friend. same as sephone_friend_set_inc_subscribe_policy() with #SephoneSPDeny policy;
 * @param lc #SephoneCore object
 * @param lf #SephoneFriend to add
 */
SEPHONE_PUBLIC void sephone_core_reject_subscriber(SephoneCore *lc, SephoneFriend *lf);

/**
 * Get Buddy list of SephoneFriend
 * @param[in] lc #SephoneCore object
 * @return \mslist{SephoneFriend}
 */
SEPHONE_PUBLIC	const MSList * sephone_core_get_friend_list(const SephoneCore *lc);

/**
 * Notify all friends that have subscribed
 * @param lc #SephoneCore object
 * @param presence #SephonePresenceModel to notify
 */
SEPHONE_PUBLIC void sephone_core_notify_all_friends(SephoneCore *lc, SephonePresenceModel *presence);

/**
 * Search a SephoneFriend by its address.
 * @param[in] lc #SephoneCore object.
 * @param[in] addr The address to use to search the friend.
 * @return The #SephoneFriend object corresponding to the given address.
 * @deprecated use sephone_core_find_friend() instead.
 */
SEPHONE_PUBLIC SephoneFriend *sephone_core_get_friend_by_address(const SephoneCore *lc, const char *addr);

/**
 * Search a SephoneFriend by its address.
 * @param[in] lc #SephoneCore object.
 * @param[in] addr The address to use to search the friend.
 * @return The #SephoneFriend object corresponding to the given address.
 */
SEPHONE_PUBLIC SephoneFriend *sephone_core_find_friend(const SephoneCore *lc, const SephoneAddress *addr);

/**
 * Search a SephoneFriend by its reference key.
 * @param[in] lc #SephoneCore object.
 * @param[in] key The reference key to use to search the friend.
 * @return The #SephoneFriend object corresponding to the given reference key.
 */
SEPHONE_PUBLIC SephoneFriend *sephone_core_get_friend_by_ref_key(const SephoneCore *lc, const char *key);

/**
 * Acquire a reference to the sephone friend.
 * @param[in] lf SephoneFriend object
 * @return The same SephoneFriend object
**/
SEPHONE_PUBLIC SephoneFriend * sephone_friend_ref(SephoneFriend *lf);

/**
 * Release a reference to the sephone friend.
 * @param[in] lf LinohoneFriend object
**/
SEPHONE_PUBLIC void sephone_friend_unref(SephoneFriend *lf);

/**
 * Returns the SephoneCore object managing this friend, if any.
 */
SEPHONE_PUBLIC SephoneCore *sephone_friend_get_core(const SephoneFriend *fr);
/**
 * @}
 */

#ifdef __cplusplus
}
#endif

#endif /* SEPHONEFRIEND_H_ */
