/*
event.h
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
#ifndef SEPHONEEVENT_H
#define SEPHONEEVENT_H

/**
 * @addtogroup event_api
 * @{
**/

struct _SephoneEvent;

/**
 * Object representing an event state, which is subcribed or published.
 * @see sephone_core_publish()
 * @see sephone_core_subscribe()
**/
typedef struct _SephoneEvent SephoneEvent;

/**
 * Enum for subscription direction (incoming or outgoing).
**/
enum _SephoneSubscriptionDir{
	SephoneSubscriptionIncoming, /**< Incoming subscription. */
	SephoneSubscriptionOutgoing, /**< Outgoing subscription. */
	SephoneSubscriptionInvalidDir /**< Invalid subscription direction. */
};

/**
 * Typedef alias for _SephoneSubscriptionDir
**/
typedef enum _SephoneSubscriptionDir SephoneSubscriptionDir;

/**
 * Enum for subscription states.
**/
enum _SephoneSubscriptionState{
	SephoneSubscriptionNone, /**< Initial state, should not be used.**/
	SephoneSubscriptionOutgoingProgress, /**<An outgoing subcription was sent*/
	SephoneSubscriptionIncomingReceived, /**<An incoming subcription is received*/
	SephoneSubscriptionPending, /**<Subscription is pending, waiting for user approval*/
	SephoneSubscriptionActive, /**<Subscription is accepted.*/
	SephoneSubscriptionTerminated, /**<Subscription is terminated normally*/
	SephoneSubscriptionError, /**<Subscription encountered an error, indicated by sephone_event_get_reason()*/
	SephoneSubscriptionExpiring, /**<Subscription is about to expire, only sent if [sip]->refresh_generic_subscribe property is set to 0.*/
};
/*typo compatibility*/
#define SephoneSubscriptionOutoingInit SephoneSubscriptionOutgoingInit

#define SephoneSubscriptionOutgoingInit SephoneSubscriptionOutgoingProgress
/**
 * Typedef for subscription state enum.
**/
typedef enum _SephoneSubscriptionState SephoneSubscriptionState;

SEPHONE_PUBLIC const char *sephone_subscription_state_to_string(SephoneSubscriptionState state);

/**
 * Enum for publish states.
**/
enum _SephonePublishState{
	SephonePublishNone, /**< Initial state, do not use**/
	SephonePublishProgress, /**<An outgoing publish was created and submitted*/
	SephonePublishOk, /**<Publish is accepted.*/
	SephonePublishError, /**<Publish encoutered an error, sephone_event_get_reason() gives reason code*/
	SephonePublishExpiring, /**<Publish is about to expire, only sent if [sip]->refresh_generic_publish property is set to 0.*/
	SephonePublishCleared /**<Event has been un published*/
};

/**
 * Typedef for publish state enum
**/
typedef enum _SephonePublishState SephonePublishState;

SEPHONE_PUBLIC const char *sephone_publish_state_to_string(SephonePublishState state);

/**
 * Callback prototype for notifying the application about notification received from the network.
**/
typedef void (*SephoneCoreNotifyReceivedCb)(SephoneCore *lc, SephoneEvent *lev, const char *notified_event, const SephoneContent *body);

/**
 * Callback prototype for notifying the application about changes of subscription states, including arrival of new subscriptions.
**/
typedef void (*SephoneCoreSubscriptionStateChangedCb)(SephoneCore *lc, SephoneEvent *lev, SephoneSubscriptionState state);

/**
 * Callback prototype for notifying the application about changes of publish states.
**/
typedef void (*SephoneCorePublishStateChangedCb)(SephoneCore *lc, SephoneEvent *lev, SephonePublishState state);

/**
 * Create an outgoing subscription, specifying the destination resource, the event name, and an optional content body.
 * If accepted, the subscription runs for a finite period, but is automatically renewed if not terminated before.
 * @param lc the #SephoneCore
 * @param resource the destination resource
 * @param event the event name
 * @param expires the whished duration of the subscription
 * @param body an optional body, may be NULL.
 * @return a SephoneEvent holding the context of the created subcription.
**/
SEPHONE_PUBLIC SephoneEvent *sephone_core_subscribe(SephoneCore *lc, const SephoneAddress *resource, const char *event, int expires, const SephoneContent *body);

/**
 * Create an outgoing subscription, specifying the destination resource, the event name, and an optional content body.
 * If accepted, the subscription runs for a finite period, but is automatically renewed if not terminated before.
 * Unlike sephone_core_subscribe() the subscription isn't sent immediately. It will be send when calling sephone_event_send_subscribe().
 * @param lc the #SephoneCore
 * @param resource the destination resource
 * @param event the event name
 * @param expires the whished duration of the subscription
 * @return a SephoneEvent holding the context of the created subcription.
**/
SEPHONE_PUBLIC SephoneEvent *sephone_core_create_subscribe(SephoneCore *lc, const SephoneAddress *resource, const char *event, int expires);

/**
 * Send a subscription previously created by sephone_core_create_subscribe().
 * @param ev the SephoneEvent
 * @param body optional content to attach with the subscription.
 * @return 0 if successful, -1 otherwise.
**/
SEPHONE_PUBLIC int sephone_event_send_subscribe(SephoneEvent *ev, const SephoneContent *body);

/**
 * Update (refresh) an outgoing subscription.
 * @param lev a SephoneEvent
 * @param body an optional body to include in the subscription update, may be NULL.
**/
SEPHONE_PUBLIC int sephone_event_update_subscribe(SephoneEvent *lev, const SephoneContent *body);


/**
 * Accept an incoming subcription.
**/
SEPHONE_PUBLIC int sephone_event_accept_subscription(SephoneEvent *lev);
/**
 * Deny an incoming subscription with given reason.
**/
SEPHONE_PUBLIC int sephone_event_deny_subscription(SephoneEvent *lev, SephoneReason reason);
/**
 * Send a notification.
 * @param lev a #SephoneEvent corresponding to an incoming subscription previously received and accepted.
 * @param body an optional body containing the actual notification data.
 * @return 0 if successful, -1 otherwise.
 **/
SEPHONE_PUBLIC int sephone_event_notify(SephoneEvent *lev, const SephoneContent *body);


/**
 * Publish an event state.
 * This first create a SephoneEvent with sephone_core_create_publish() and calls sephone_event_send_publish() to actually send it.
 * After expiry, the publication is refreshed unless it is terminated before.
 * @param lc the #SephoneCore
 * @param resource the resource uri for the event
 * @param event the event name
 * @param expires the lifetime of event being published, -1 if no associated duration, in which case it will not be refreshed.
 * @param body the actual published data
 * @return the SephoneEvent holding the context of the publish.
**/
SEPHONE_PUBLIC SephoneEvent *sephone_core_publish(SephoneCore *lc, const SephoneAddress *resource, const char *event, int expires, const SephoneContent *body);

/**
 * Create a publish context for an event state.
 * After being created, the publish must be sent using sephone_event_send_publish().
 * After expiry, the publication is refreshed unless it is terminated before.
 * @param lc the #SephoneCore
 * @param resource the resource uri for the event
 * @param event the event name
 * @param expires the lifetime of event being published, -1 if no associated duration, in which case it will not be refreshed.
 * @return the SephoneEvent holding the context of the publish.
**/
SEPHONE_PUBLIC SephoneEvent *sephone_core_create_publish(SephoneCore *lc, const SephoneAddress *resource, const char *event, int expires);

/**
 * Send a publish created by sephone_core_create_publish().
 * @param lev the #SephoneEvent
 * @param body the new data to be published
**/
SEPHONE_PUBLIC int sephone_event_send_publish(SephoneEvent *lev, const SephoneContent *body);

/**
 * Update (refresh) a publish.
 * @param lev the #SephoneEvent
 * @param body the new data to be published
**/
SEPHONE_PUBLIC int sephone_event_update_publish(SephoneEvent *lev, const SephoneContent *body);


/**
 * Return reason code (in case of error state reached).
**/
SEPHONE_PUBLIC SephoneReason sephone_event_get_reason(const SephoneEvent *lev);

/**
 * Get full details about an error occured.
**/
SEPHONE_PUBLIC const SephoneErrorInfo *sephone_event_get_error_info(const SephoneEvent *lev);

/**
 * Get subscription state. If the event object was not created by a subscription mechanism, #SephoneSubscriptionNone is returned.
**/
SEPHONE_PUBLIC SephoneSubscriptionState sephone_event_get_subscription_state(const SephoneEvent *lev);

/**
 * Get publish state. If the event object was not created by a publish mechanism, #SephonePublishNone is returned.
**/
SEPHONE_PUBLIC SephonePublishState sephone_event_get_publish_state(const SephoneEvent *lev);

/**
 * Get subscription direction.
 * If the object wasn't created by a subscription mechanism, #SephoneSubscriptionInvalidDir is returned.
**/
SEPHONE_PUBLIC SephoneSubscriptionDir sephone_event_get_subscription_dir(SephoneEvent *lev);

/**
 * Set a user (application) pointer.
**/
SEPHONE_PUBLIC void sephone_event_set_user_data(SephoneEvent *ev, void *up);

/**
 * Retrieve user pointer.
**/
SEPHONE_PUBLIC void *sephone_event_get_user_data(const SephoneEvent *ev);

/**
 * Add a custom header to an outgoing susbscription or publish.
 * @param ev the SephoneEvent
 * @param name header's name
 * @param value the header's value.
**/
SEPHONE_PUBLIC void sephone_event_add_custom_header(SephoneEvent *ev, const char *name, const char *value);

/**
 * Obtain the value of a given header for an incoming subscription.
 * @param ev the SephoneEvent
 * @param name header's name
 * @return the header's value or NULL if such header doesn't exist.
**/
SEPHONE_PUBLIC const char *sephone_event_get_custom_header(SephoneEvent *ev, const char *name);

/**
 * Terminate an incoming or outgoing subscription that was previously acccepted, or a previous publication.
 * This function does not unref the object. The core will unref() if it does not need this object anymore.
 *
 * For subscribed event, when the subscription is terminated normally or because of an error, the core will unref.
 * For published events, no unref is performed. This is because it is allowed to re-publish an expired publish, as well as retry it in case of error.
**/
SEPHONE_PUBLIC void sephone_event_terminate(SephoneEvent *lev);


/**
 * Increase reference count of SephoneEvent.
 * By default SephoneEvents created by the core are owned by the core only.
 * An application that wishes to retain a reference to it must call sephone_event_ref().
 * When this reference is no longer needed, sephone_event_unref() must be called.
 *
**/
SEPHONE_PUBLIC SephoneEvent *sephone_event_ref(SephoneEvent *lev);

/**
 * Decrease reference count.
 * @see sephone_event_ref()
**/
SEPHONE_PUBLIC void sephone_event_unref(SephoneEvent *lev);

/**
 * Get the name of the event as specified in the event package RFC.
**/
SEPHONE_PUBLIC const char *sephone_event_get_name(const SephoneEvent *lev);

/**
 * Get the "from" address of the subscription.
**/
SEPHONE_PUBLIC const SephoneAddress *sephone_event_get_from(const SephoneEvent *lev);

/**
 * Get the resource address of the subscription or publish.
**/
SEPHONE_PUBLIC const SephoneAddress *sephone_event_get_resource(const SephoneEvent *lev);

/**
 * Returns back pointer to the SephoneCore that created this SephoneEvent
**/
SEPHONE_PUBLIC SephoneCore *sephone_event_get_core(const SephoneEvent *lev);

/**
 * @}
**/


#endif
