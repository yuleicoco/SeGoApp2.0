/*
sephonepresence.h
Copyright (C) 2010-2013  Belledonne Communications SARL

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

#ifndef SEPHONEPRESENCE_H_
#define SEPHONEPRESENCE_H_


#ifdef __cplusplus
extern "C" {
#endif


/**
 * @addtogroup buddy_list
 * @{
 */


/** Basic status as defined in section 4.1.4 of RFC 3863 */
typedef enum SephonePresenceBasicStatus {
	/** This value means that the associated contact element, if any, is ready to accept communication. */
	SephonePresenceBasicStatusOpen,

	/** This value means that the associated contact element, if any, is unable to accept communication. */
	SephonePresenceBasicStatusClosed
} SephonePresenceBasicStatus;

/** Activities as defined in section 3.2 of RFC 4480 */
typedef enum SephonePresenceActivityType {
	/** This value is not defined in the RFC, it corresponds to no activity with a basic status of "closed". */
	SephonePresenceActivityOffline,

	/** This value is not defined in the RFC, it corresponds to no activity with a basic status of "open". */
	SephonePresenceActivityOnline,

	/** The person has a calendar appointment, without specifying exactly of what type. This activity is
	 *  indicated if more detailed information is not available or the person chooses not to reveal more
	 * information. */
	SephonePresenceActivityAppointment,

	/** The person is physically away from all interactive communication devices. */
	SephonePresenceActivityAway,

	/** The person is eating the first meal of the day, usually eaten in the morning. */
	SephonePresenceActivityBreakfast,

	/** The person is busy, without further details. */
	SephonePresenceActivityBusy,

	/** The person is having his or her main meal of the day, eaten in the evening or at midday. */
	SephonePresenceActivityDinner,

	/**  This is a scheduled national or local holiday. */
	SephonePresenceActivityHoliday,

	/** The person is riding in a vehicle, such as a car, but not steering. */
	SephonePresenceActivityInTransit,

	/** The person is looking for (paid) work. */
	SephonePresenceActivityLookingForWork,

	/** The person is eating his or her midday meal. */
	SephonePresenceActivityLunch,

	/** The person is scheduled for a meal, without specifying whether it is breakfast, lunch, or dinner,
	 *  or some other meal. */
	SephonePresenceActivityMeal,

	/** The person is in an assembly or gathering of people, as for a business, social, or religious purpose.
	 *  A meeting is a sub-class of an appointment. */
	SephonePresenceActivityMeeting,

	/** The person is talking on the telephone. */
	SephonePresenceActivityOnThePhone,

	/** The person is engaged in an activity with no defined representation. A string describing the activity
	 *  in plain text SHOULD be provided. */
	SephonePresenceActivityOther,

	/** A performance is a sub-class of an appointment and includes musical, theatrical, and cinematic
	 *  performances as well as lectures. It is distinguished from a meeting by the fact that the person
	 *  may either be lecturing or be in the audience, with a potentially large number of other people,
	 *  making interruptions particularly noticeable. */
	SephonePresenceActivityPerformance,

	/** The person will not return for the foreseeable future, e.g., because it is no longer working for
	 *  the company. */
	SephonePresenceActivityPermanentAbsence,

	/** The person is occupying himself or herself in amusement, sport, or other recreation. */
	SephonePresenceActivityPlaying,

	/** The person is giving a presentation, lecture, or participating in a formal round-table discussion. */
	SephonePresenceActivityPresentation,

	/** The person is visiting stores in search of goods or services. */
	SephonePresenceActivityShopping,

	/** The person is sleeping.*/
	SephonePresenceActivitySleeping,

	/** The person is observing an event, such as a sports event. */
	SephonePresenceActivitySpectator,

	/** The person is controlling a vehicle, watercraft, or plane. */
	SephonePresenceActivitySteering,

	/** The person is on a business or personal trip, but not necessarily in-transit. */
	SephonePresenceActivityTravel,

	/** The person is watching television. */
	SephonePresenceActivityTV,

	/** The activity of the person is unknown. */
	SephonePresenceActivityUnknown,

	/** A period of time devoted to pleasure, rest, or relaxation. */
	SephonePresenceActivityVacation,

	/** The person is engaged in, typically paid, labor, as part of a profession or job. */
	SephonePresenceActivityWorking,

	/** The person is participating in religious rites. */
	SephonePresenceActivityWorship
} SephonePresenceActivityType;

/**
 * Structure holding the information about the presence of a person.
 */
struct _SephonePresenceModel;

/**
 * Presence model type holding information about the presence of a person.
 */
typedef struct _SephonePresenceModel SephonePresenceModel;

/**
 * Structure holding the information about a presence service.
 */
struct _SephonePresenceService;

/**
 * Structure holding the information about a presence person.
 */
struct _SephonePresencePerson;

/**
 * Presence person holding information about a presence person.
 */
typedef struct _SephonePresencePerson SephonePresencePerson;

/**
 * Presence service type holding information about a presence service.
 */
typedef struct _SephonePresenceService SephonePresenceService;

/**
 * Structure holding the information about a presence activity.
 */
struct _SephonePresenceActivity;

/**
 * Presence activity type holding information about a presence activity.
 */
typedef struct _SephonePresenceActivity SephonePresenceActivity;

/**
 * Structure holding the information about a presence note.
 */
struct _SephonePresenceNote;

/**
 * Presence note type holding information about a presence note.
 */
typedef struct _SephonePresenceNote SephonePresenceNote;



/*****************************************************************************
 * HELPER FUNCTIONS TO EASE ACCESS IN MOST SIMPLER CASES                     *
 ****************************************************************************/

/**
 * Creates a presence model specifying an activity.
 * @param[in] activity The activity to set for the created presence model.
 * @param[in] description An additional description of the activity (mainly useful for the 'other' activity). Set it to NULL to not add a description.
 * @return The created presence model, or NULL if an error occured.
 * @see sephone_presence_model_new
 * @see sephone_presence_model_new_with_activity_and_note
 *
 * The created presence model has the activity specified in the parameters.
 */
SEPHONE_PUBLIC SephonePresenceModel * sephone_presence_model_new_with_activity(SephonePresenceActivityType activity, const char *description);

/**
 * Creates a presence model specifying an activity and adding a note.
 * @param[in] activity The activity to set for the created presence model.
 * @param[in] description An additional description of the activity (mainly useful for the 'other' activity). Set it to NULL to not add a description.
 * @param[in] note An additional note giving additional information about the contact presence.
 * @param[in] lang The language the note is written in. It can be set to NULL in order to not specify the language of the note.
 * @return The created presence model, or NULL if an error occured.
 * @see sephone_presence_model_new_with_activity
 * @see sephone_presence_model_new_with_activity_and_note
 *
 * The created presence model has the activity and the note specified in the parameters.
 */
SEPHONE_PUBLIC SephonePresenceModel * sephone_presence_model_new_with_activity_and_note(SephonePresenceActivityType activity, const char *description, const char *note, const char *lang);

/**
 * Gets the basic status of a presence model.
 * @param[in] model The #SephonePresenceModel object to get the basic status from.
 * @return The #SephonePresenceBasicStatus of the #SephonePresenceModel object given as parameter.
 */
SEPHONE_PUBLIC SephonePresenceBasicStatus sephone_presence_model_get_basic_status(const SephonePresenceModel *model);

/**
 *  Sets the basic status of a presence model.
 * @param[in] model The #SephonePresenceModel object for which to set the basic status.
 * @param[in] basic_status The #SephonePresenceBasicStatus to set for the #SephonePresenceModel object.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_model_set_basic_status(SephonePresenceModel *model, SephonePresenceBasicStatus basic_status);

/**
 *  Gets the timestamp of a presence model.
 * @param[in] model The #SephonePresenceModel object to get the timestamp from.
 * @return The timestamp of the #SephonePresenceModel object or -1 on error.
 */
SEPHONE_PUBLIC time_t sephone_presence_model_get_timestamp(const SephonePresenceModel *model);

/**
 * Gets the contact of a presence model.
 * @param[in] model The #SephonePresenceModel object to get the contact from.
 * @return A pointer to a dynamically allocated string containing the contact, or NULL if no contact is found.
 *
 * The returned string is to be freed by calling ms_free().
 */
SEPHONE_PUBLIC char * sephone_presence_model_get_contact(const SephonePresenceModel *model);

/**
 * Sets the contact of a presence model.
 * @param[in] model The #SephonePresenceModel object for which to set the contact.
 * @param[in] contact The contact string to set.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_model_set_contact(SephonePresenceModel *model, const char *contact);

/**
 * Gets the first activity of a presence model (there is usually only one).
 * @param[in] model The #SephonePresenceModel object to get the activity from.
 * @return A #SephonePresenceActivity object if successful, NULL otherwise.
 */
SEPHONE_PUBLIC SephonePresenceActivity * sephone_presence_model_get_activity(const SephonePresenceModel *model);

/**
 * Sets the activity of a presence model (limits to only one activity).
 * @param[in] model The #SephonePresenceModel object for which to set the activity.
 * @param[in] activity The #SephonePresenceActivityType to set for the model.
 * @param[in] description An additional description of the activity to set for the model. Can be NULL if no additional description is to be added.
 * @return 0 if successful, a value < 0 in case of error.
 *
 * WARNING: This function will modify the basic status of the model according to the activity being set.
 * If you don't want the basic status to be modified automatically, you can use the combination of sephone_presence_model_set_basic_status(),
 * sephone_presence_model_clear_activities() and sephone_presence_model_add_activity().
 */
SEPHONE_PUBLIC int sephone_presence_model_set_activity(SephonePresenceModel *model, SephonePresenceActivityType activity, const char *description);

/**
 * Gets the number of activities included in the presence model.
 * @param[in] model The #SephonePresenceModel object to get the number of activities from.
 * @return The number of activities included in the #SephonePresenceModel object.
 */
SEPHONE_PUBLIC unsigned int sephone_presence_model_get_nb_activities(const SephonePresenceModel *model);

/**
 * Gets the nth activity of a presence model.
 * @param[in] model The #SephonePresenceModel object to get the activity from.
 * @param[in] idx The index of the activity to get (the first activity having the index 0).
 * @return A pointer to a #SephonePresenceActivity object if successful, NULL otherwise.
 */
SEPHONE_PUBLIC SephonePresenceActivity * sephone_presence_model_get_nth_activity(const SephonePresenceModel *model, unsigned int idx);

/**
 * Adds an activity to a presence model.
 * @param[in] model The #SephonePresenceModel object for which to add an activity.
 * @param[in] activity The #SephonePresenceActivity object to add to the model.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_model_add_activity(SephonePresenceModel *model, SephonePresenceActivity *activity);

/**
 * Clears the activities of a presence model.
 * @param[in] model The #SephonePresenceModel object for which to clear the activities.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_model_clear_activities(SephonePresenceModel *model);

/**
 * Gets the first note of a presence model (there is usually only one).
 * @param[in] model The #SephonePresenceModel object to get the note from.
 * @param[in] lang The language of the note to get. Can be NULL to get a note that has no language specified or to get the first note whatever language it is written into.
 * @return A pointer to a #SephonePresenceNote object if successful, NULL otherwise.
 */
SEPHONE_PUBLIC SephonePresenceNote * sephone_presence_model_get_note(const SephonePresenceModel *model, const char *lang);

/**
 * Adds a note to a presence model.
 * @param[in] model The #SephonePresenceModel object to add a note to.
 * @param[in] note_content The note to be added to the presence model.
 * @param[in] lang The language of the note to be added. Can be NULL if no language is to be specified for the note.
 * @return 0 if successful, a value < 0 in case of error.
 *
 * Only one note for each language can be set, so e.g. setting a note for the 'fr' language if there is only one will replace the existing one.
 */
SEPHONE_PUBLIC int sephone_presence_model_add_note(SephonePresenceModel *model, const char *note_content, const char *lang);

/**
 * Clears all the notes of a presence model.
 * @param[in] model The #SephonePresenceModel for which to clear notes.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_model_clear_notes(SephonePresenceModel *model);


/*****************************************************************************
 * PRESENCE MODEL FUNCTIONS TO GET ACCESS TO ALL FUNCTIONALITIES             *
 ****************************************************************************/

/**
 * Creates a default presence model.
 * @return The created presence model, NULL on error.
 * @see sephone_presence_model_new_with_activity
 * @see sephone_presence_model_new_with_activity_and_note
 *
 * The created presence model is considered 'offline'.
 */
SEPHONE_PUBLIC SephonePresenceModel * sephone_presence_model_new(void);

/**
 * Gets the number of services included in the presence model.
 * @param[in] model The #SephonePresenceModel object to get the number of services from.
 * @return The number of services included in the #SephonePresenceModel object.
 */
SEPHONE_PUBLIC unsigned int sephone_presence_model_get_nb_services(const SephonePresenceModel *model);

/**
 * Gets the nth service of a presence model.
 * @param[in] model The #SephonePresenceModel object to get the service from.
 * @param[in] idx The index of the service to get (the first service having the index 0).
 * @return A pointer to a #SephonePresenceService object if successful, NULL otherwise.
 */
SEPHONE_PUBLIC SephonePresenceService * sephone_presence_model_get_nth_service(const SephonePresenceModel *model, unsigned int idx);

/**
 * Adds a service to a presence model.
 * @param[in] model The #SephonePresenceModel object for which to add a service.
 * @param[in] service The #SephonePresenceService object to add to the model.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_model_add_service(SephonePresenceModel *model, SephonePresenceService *service);

/**
 * Clears the services of a presence model.
 * @param[in] model The #SephonePresenceModel object for which to clear the services.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_model_clear_services(SephonePresenceModel *model);

/**
 * Gets the number of persons included in the presence model.
 * @param[in] model The #SephonePresenceModel object to get the number of persons from.
 * @return The number of persons included in the #SephonePresenceModel object.
 */
SEPHONE_PUBLIC unsigned int sephone_presence_model_get_nb_persons(const SephonePresenceModel *model);

/**
 * Gets the nth person of a presence model.
 * @param[in] model The #SephonePresenceModel object to get the person from.
 * @param[in] idx The index of the person to get (the first person having the index 0).
 * @return A pointer to a #SephonePresencePerson object if successful, NULL otherwise.
 */
SEPHONE_PUBLIC SephonePresencePerson * sephone_presence_model_get_nth_person(const SephonePresenceModel *model, unsigned int idx);

/**
 * Adds a person to a presence model.
 * @param[in] model The #SephonePresenceModel object for which to add a person.
 * @param[in] person The #SephonePresencePerson object to add to the model.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_model_add_person(SephonePresenceModel *model, SephonePresencePerson *person);

/**
 * Clears the persons of a presence model.
 * @param[in] model The #SephonePresenceModel object for which to clear the persons.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_model_clear_persons(SephonePresenceModel *model);


/*****************************************************************************
 * PRESENCE SERVICE FUNCTIONS TO GET ACCESS TO ALL FUNCTIONALITIES           *
 ****************************************************************************/

/**
 * Creates a presence service.
 * @param[in] id The id of the presence service to be created. Can be NULL to generate it automatically.
 * @param[in] basic_status The #SephonePresenceBasicStatus to set for the #SephonePresenceService object.
 * @param[in] contact The contact string to set.
 * @return The created presence service, NULL on error.
 *
 * The created presence service has the basic status 'closed'.
 */
SEPHONE_PUBLIC SephonePresenceService * sephone_presence_service_new(const char *id, SephonePresenceBasicStatus basic_status, const char *contact);

/**
 * Gets the id of a presence service.
 * @param[in] service The #SephonePresenceService object to get the id from.
 * @return A pointer to a dynamically allocated string containing the id, or NULL in case of error.
 *
 * The returned string is to be freed by calling ms_free().
 */
SEPHONE_PUBLIC char * sephone_presence_service_get_id(const SephonePresenceService *service);

/**
 * Sets the id of a presence service.
 * @param[in] service The #SephonePresenceService object for which to set the id.
 * @param[in] id The id string to set. Can be NULL to generate it automatically.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_service_set_id(SephonePresenceService *service, const char *id);

/**
 * Gets the basic status of a presence service.
 * @param[in] service The #SephonePresenceService object to get the basic status from.
 * @return The #SephonePresenceBasicStatus of the #SephonePresenceService object given as parameter.
 */
SEPHONE_PUBLIC SephonePresenceBasicStatus sephone_presence_service_get_basic_status(const SephonePresenceService *service);

/**
 * Sets the basic status of a presence service.
 * @param[in] service The #SephonePresenceService object for which to set the basic status.
 * @param[in] basic_status The #SephonePresenceBasicStatus to set for the #SephonePresenceService object.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_service_set_basic_status(SephonePresenceService *service, SephonePresenceBasicStatus basic_status);

/**
 * Gets the contact of a presence service.
 * @param[in] service The #SephonePresenceService object to get the contact from.
 * @return A pointer to a dynamically allocated string containing the contact, or NULL if no contact is found.
 *
 * The returned string is to be freed by calling ms_free().
 */
SEPHONE_PUBLIC char * sephone_presence_service_get_contact(const SephonePresenceService *service);

/**
 * Sets the contact of a presence service.
 * @param[in] service The #SephonePresenceService object for which to set the contact.
 * @param[in] contact The contact string to set.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_service_set_contact(SephonePresenceService *service, const char *contact);

/**
 * Gets the number of notes included in the presence service.
 * @param[in] service The #SephonePresenceService object to get the number of notes from.
 * @return The number of notes included in the #SephonePresenceService object.
 */
SEPHONE_PUBLIC unsigned int sephone_presence_service_get_nb_notes(const SephonePresenceService *service);

/**
 * Gets the nth note of a presence service.
 * @param[in] service The #SephonePresenceService object to get the note from.
 * @param[in] idx The index of the note to get (the first note having the index 0).
 * @return A pointer to a #SephonePresenceNote object if successful, NULL otherwise.
 */
SEPHONE_PUBLIC SephonePresenceNote * sephone_presence_service_get_nth_note(const SephonePresenceService *service, unsigned int idx);

/**
 * Adds a note to a presence service.
 * @param[in] service The #SephonePresenceService object for which to add a note.
 * @param[in] note The #SephonePresenceNote object to add to the service.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_service_add_note(SephonePresenceService *service, SephonePresenceNote *note);

/**
 * Clears the notes of a presence service.
 * @param[in] service The #SephonePresenceService object for which to clear the notes.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_service_clear_notes(SephonePresenceService *service);


/*****************************************************************************
 * PRESENCE PERSON FUNCTIONS TO GET ACCESS TO ALL FUNCTIONALITIES            *
 ****************************************************************************/

/**
 * Creates a presence person.
 * @param[in] id The id of the presence person to be created. Can be NULL to generate it automatically.
 * @return The created presence person, NULL on error.
 */
SEPHONE_PUBLIC SephonePresencePerson * sephone_presence_person_new(const char *id);

/**
 * Gets the id of a presence person.
 * @param[in] person The #SephonePresencePerson object to get the id from.
 * @return A pointer to a dynamically allocated string containing the id, or NULL in case of error.
 *
 * The returned string is to be freed by calling ms_free().
 */
SEPHONE_PUBLIC char * sephone_presence_person_get_id(const SephonePresencePerson *person);

/**
 * Sets the id of a presence person.
 * @param[in] person The #SephonePresencePerson object for which to set the id.
 * @param[in] id The id string to set. Can be NULL to generate it automatically.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_person_set_id(SephonePresencePerson *person, const char *id);

/**
 * Gets the number of activities included in the presence person.
 * @param[in] person The #SephonePresencePerson object to get the number of activities from.
 * @return The number of activities included in the #SephonePresencePerson object.
 */
SEPHONE_PUBLIC unsigned int sephone_presence_person_get_nb_activities(const SephonePresencePerson *person);

/**
 * Gets the nth activity of a presence person.
 * @param[in] person The #SephonePresencePerson object to get the activity from.
 * @param[in] idx The index of the activity to get (the first activity having the index 0).
 * @return A pointer to a #SephonePresenceActivity object if successful, NULL otherwise.
 */
SEPHONE_PUBLIC SephonePresenceActivity * sephone_presence_person_get_nth_activity(const SephonePresencePerson *person, unsigned int idx);

/**
 * Adds an activity to a presence person.
 * @param[in] person The #SephonePresencePerson object for which to add an activity.
 * @param[in] activity The #SephonePresenceActivity object to add to the person.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_person_add_activity(SephonePresencePerson *person, SephonePresenceActivity *activity);

/**
 * Clears the activities of a presence person.
 * @param[in] person The #SephonePresencePerson object for which to clear the activities.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_person_clear_activities(SephonePresencePerson *person);

/**
 * Gets the number of notes included in the presence person.
 * @param[in] person The #SephonePresencePerson object to get the number of notes from.
 * @return The number of notes included in the #SephonePresencePerson object.
 */
SEPHONE_PUBLIC unsigned int sephone_presence_person_get_nb_notes(const SephonePresencePerson *person);

/**
 * Gets the nth note of a presence person.
 * @param[in] person The #SephonePresencePerson object to get the note from.
 * @param[in] idx The index of the note to get (the first note having the index 0).
 * @return A pointer to a #SephonePresenceNote object if successful, NULL otherwise.
 */
SEPHONE_PUBLIC SephonePresenceNote * sephone_presence_person_get_nth_note(const SephonePresencePerson *person, unsigned int idx);

/**
 * Adds a note to a presence person.
 * @param[in] person The #SephonePresencePerson object for which to add a note.
 * @param[in] note The #SephonePresenceNote object to add to the person.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_person_add_note(SephonePresencePerson *person, SephonePresenceNote *note);

/**
 * Clears the notes of a presence person.
 * @param[in] person The #SephonePresencePerson object for which to clear the notes.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_person_clear_notes(SephonePresencePerson *person);

/**
 * Gets the number of activities notes included in the presence person.
 * @param[in] person The #SephonePresencePerson object to get the number of activities notes from.
 * @return The number of activities notes included in the #SephonePresencePerson object.
 */
SEPHONE_PUBLIC unsigned int sephone_presence_person_get_nb_activities_notes(const SephonePresencePerson *person);

/**
 * Gets the nth activities note of a presence person.
 * @param[in] person The #SephonePresencePerson object to get the activities note from.
 * @param[in] idx The index of the activities note to get (the first note having the index 0).
 * @return A pointer to a #SephonePresenceNote object if successful, NULL otherwise.
 */
SEPHONE_PUBLIC SephonePresenceNote * sephone_presence_person_get_nth_activities_note(const SephonePresencePerson *person, unsigned int idx);

/**
 * Adds an activities note to a presence person.
 * @param[in] person The #SephonePresencePerson object for which to add an activities note.
 * @param[in] note The #SephonePresenceNote object to add to the person.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_person_add_activities_note(SephonePresencePerson *person, SephonePresenceNote *note);

/**
 * Clears the activities notes of a presence person.
 * @param[in] person The #SephonePresencePerson object for which to clear the activities notes.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_person_clear_activities_notes(SephonePresencePerson *person);


/*****************************************************************************
 * PRESENCE ACTIVITY FUNCTIONS TO GET ACCESS TO ALL FUNCTIONALITIES          *
 ****************************************************************************/

/**
 * Creates a presence activity.
 * @param[in] acttype The #SephonePresenceActivityType to set for the activity.
 * @param[in] description An additional description of the activity to set for the activity. Can be NULL if no additional description is to be added.
 * @return The created presence activity, NULL on error.
 */
SEPHONE_PUBLIC SephonePresenceActivity * sephone_presence_activity_new(SephonePresenceActivityType acttype, const char *description);

/**
 * Gets the string representation of a presence activity.
 * @param[in] activity A pointer to the #SephonePresenceActivity object for which to get a string representation.
 * @return A pointer a dynamically allocated string representing the given activity.
 *
 * The returned string is to be freed by calling ms_free().
 */
SEPHONE_PUBLIC char * sephone_presence_activity_to_string(const SephonePresenceActivity * activity);

/**
 * Gets the activity type of a presence activity.
 * @param[in] activity A pointer to the #SephonePresenceActivity for which to get the type.
 * @return The #SephonePresenceActivityType of the activity.
 */
SEPHONE_PUBLIC SephonePresenceActivityType sephone_presence_activity_get_type(const SephonePresenceActivity *activity);

/**
 * Sets the type of activity of a presence activity.
 * @param[in] activity The #SephonePresenceActivity for which to set for the activity type.
 * @param[in] acttype The activity type to set for the activity.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_activity_set_type(SephonePresenceActivity *activity, SephonePresenceActivityType acttype);

/**
 * Gets the description of a presence activity.
 * @param[in] activity A pointer to the #SephonePresenceActivity for which to get the description.
 * @return A pointer to the description string of the presence activity, or NULL if no description is specified.
 */
SEPHONE_PUBLIC const char * sephone_presence_activity_get_description(const SephonePresenceActivity *activity);

/**
 * Sets the description of a presence activity.
 * @param[in] activity The #SephonePresenceActivity object for which to set the description.
 * @param[in] description An additional description of the activity. Can be NULL if no additional description is to be added.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_activity_set_description(SephonePresenceActivity *activity, const char *description);


/*****************************************************************************
 * PRESENCE NOTE FUNCTIONS TO GET ACCESS TO ALL FUNCTIONALITIES              *
 ****************************************************************************/

/**
 * Creates a presence note.
 * @param[in] content The content of the note to be created.
 * @param[in] lang The language of the note to be created. Can be NULL if no language is to be specified for the note.
 * @return The created presence note, NULL on error.
 */
SEPHONE_PUBLIC SephonePresenceNote * sephone_presence_note_new(const char *content, const char *lang);

/**
 * Gets the content of a presence note.
 * @param[in] note A pointer to the #SephonePresenceNote for which to get the content.
 * @return A pointer to the content of the presence note.
 */
SEPHONE_PUBLIC const char * sephone_presence_note_get_content(const SephonePresenceNote *note);

/**
 * Sets the content of a presence note.
 * @param[in] note The #SephonePresenceNote object for which to set the content.
 * @param[in] content The content of the note.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_note_set_content(SephonePresenceNote *note, const char *content);

/**
 * Gets the language of a presence note.
 * @param[in] note A pointer to the #SephonePresenceNote for which to get the language.
 * @return A pointer to the language string of the presence note, or NULL if no language is specified.
 */
SEPHONE_PUBLIC const char * sephone_presence_note_get_lang(const SephonePresenceNote *note);

/**
 * Sets the language of a presence note.
 * @param[in] note The #SephonePresenceNote object for which to set the language.
 * @param[in] lang The language of the note.
 * @return 0 if successful, a value < 0 in case of error.
 */
SEPHONE_PUBLIC int sephone_presence_note_set_lang(SephonePresenceNote *note, const char *lang);


/*****************************************************************************
 * PRESENCE INTERNAL FUNCTIONS FOR WRAPPERS IN OTHER PROGRAMMING LANGUAGES   *
 ****************************************************************************/

/**
 * Increase the reference count of the #SephonePresenceModel object.
 * @param[in] model The #SephonePresenceModel object for which the reference count is to be increased.
 * @return The #SephonePresenceModel object with the increased reference count.
 */
SEPHONE_PUBLIC SephonePresenceModel * sephone_presence_model_ref(SephonePresenceModel *model);

/**
 * Decrease the reference count of the #SephonePresenceModel object and destroy it if it reaches 0.
 * @param[in] model The #SephonePresenceModel object for which the reference count is to be decreased.
 * @return The #SephonePresenceModel object if the reference count is still positive, NULL if the object has been destroyed.
 */
SEPHONE_PUBLIC SephonePresenceModel * sephone_presence_model_unref(SephonePresenceModel *model);

/**
 * Sets the user data of a #SephonePresenceModel object.
 * @param[in] model The #SephonePresenceModel object for which to set the user data.
 * @param[in] user_data A pointer to the user data to set.
 */
SEPHONE_PUBLIC void sephone_presence_model_set_user_data(SephonePresenceModel *model, void *user_data);

/**
 * Gets the user data of a #SephonePresenceModel object.
 * @param[in] model The #SephonePresenceModel object for which to get the user data.
 * @return A pointer to the user data.
 */
SEPHONE_PUBLIC void * sephone_presence_model_get_user_data(const SephonePresenceModel *model);

/**
 * Increase the reference count of the #SephonePresenceService object.
 * @param[in] service The #SephonePresenceService object for which the reference count is to be increased.
 * @return The #SephonePresenceService object with the increased reference count.
 */
SEPHONE_PUBLIC SephonePresenceService * sephone_presence_service_ref(SephonePresenceService *service);

/**
 * Decrease the reference count of the #SephonePresenceService object and destroy it if it reaches 0.
 * @param[in] service The #SephonePresenceService object for which the reference count is to be decreased.
 * @return The #SephonePresenceService object if the reference count is still positive, NULL if the object has been destroyed.
 */
SEPHONE_PUBLIC SephonePresenceService * sephone_presence_service_unref(SephonePresenceService *service);

/**
 * Sets the user data of a #SephonePresenceService object.
 * @param[in] service The #SephonePresenceService object for which to set the user data.
 * @param[in] user_data A pointer to the user data to set.
 */
SEPHONE_PUBLIC void sephone_presence_service_set_user_data(SephonePresenceService *service, void *user_data);

/**
 * Gets the user data of a #SephonePresenceService object.
 * @param[in] service The #SephonePresenceService object for which to get the user data.
 * @return A pointer to the user data.
 */
SEPHONE_PUBLIC void * sephone_presence_service_get_user_data(const SephonePresenceService *service);

/**
 * Increase the reference count of the #SephonePresencePerson object.
 * @param[in] person The #SephonePresencePerson object for which the reference count is to be increased.
 * @return The #SephonePresencePerson object with the increased reference count.
 */
SEPHONE_PUBLIC SephonePresencePerson * sephone_presence_person_ref(SephonePresencePerson *person);

/**
 * Decrease the reference count of the #SephonePresencePerson object and destroy it if it reaches 0.
 * @param[in] person The #SephonePresencePerson object for which the reference count is to be decreased.
 * @return The #SephonePresencePerson object if the reference count is still positive, NULL if the object has been destroyed.
 */
SEPHONE_PUBLIC SephonePresencePerson * sephone_presence_person_unref(SephonePresencePerson *person);

/**
 * Sets the user data of a #SephonePresencePerson object.
 * @param[in] person The #SephonePresencePerson object for which to set the user data.
 * @param[in] user_data A pointer to the user data to set.
 */
SEPHONE_PUBLIC void sephone_presence_person_set_user_data(SephonePresencePerson *person, void *user_data);

/**
 * Gets the user data of a #SephonePresencePerson object.
 * @param[in] person The #SephonePresencePerson object for which to get the user data.
 * @return A pointer to the user data.
 */
SEPHONE_PUBLIC void * sephone_presence_person_get_user_data(const SephonePresencePerson *person);

/**
 * Increase the reference count of the #SephonePresenceActivity object.
 * @param[in] activity The #SephonePresenceActivity object for which the reference count is to be increased.
 * @return The #SephonePresenceActivity object with the increased reference count.
 */
SEPHONE_PUBLIC SephonePresenceActivity * sephone_presence_activity_ref(SephonePresenceActivity *activity);

/**
 * Decrease the reference count of the #SephonePresenceActivity object and destroy it if it reaches 0.
 * @param[in] activity The #SephonePresenceActivity object for which the reference count is to be decreased.
 * @return The #SephonePresenceActivity object if the reference count is still positive, NULL if the object has been destroyed.
 */
SEPHONE_PUBLIC SephonePresenceActivity * sephone_presence_activity_unref(SephonePresenceActivity *activity);

/**
 * Sets the user data of a #SephonePresenceActivity object.
 * @param[in] activity The #SephonePresenceActivity object for which to set the user data.
 * @param[in] user_data A pointer to the user data to set.
 */
SEPHONE_PUBLIC void sephone_presence_activity_set_user_data(SephonePresenceActivity *activity, void *user_data);

/**
 * Gets the user data of a #SephonePresenceActivity object.
 * @param[in] activity The #SephonePresenceActivity object for which to get the user data.
 * @return A pointer to the user data.
 */
SEPHONE_PUBLIC void * sephone_presence_activity_get_user_data(const SephonePresenceActivity *activity);

/**
 * Increase the reference count of the #SephonePresenceNote object.
 * @param[in] note The #SephonePresenceNote object for which the reference count is to be increased.
 * @return The #SephonePresenceNote object with the increased reference count.
 */
SEPHONE_PUBLIC SephonePresenceNote * sephone_presence_note_ref(SephonePresenceNote *note);

/**
 * Decrease the reference count of the #SephonePresenceNote object and destroy it if it reaches 0.
 * @param[in] note The #SephonePresenceNote object for which the reference count is to be decreased.
 * @return The #SephonePresenceNote object if the reference count is still positive, NULL if the object has been destroyed.
 */
SEPHONE_PUBLIC SephonePresenceNote * sephone_presence_note_unref(SephonePresenceNote *note);

/**
 * Sets the user data of a #SephonePresenceNote object.
 * @param[in] note The #SephonePresenceNote object for which to set the user data.
 * @param[in] user_data A pointer to the user data to set.
 */
SEPHONE_PUBLIC void sephone_presence_note_set_user_data(SephonePresenceNote *note, void *user_data);

/**
 * Gets the user data of a #SephonePresenceNote object.
 * @param[in] note The #SephonePresenceNote object for which to get the user data.
 * @return A pointer to the user data.
 */
SEPHONE_PUBLIC void * sephone_presence_note_get_user_data(const SephonePresenceNote *note);


/*****************************************************************************
 * SEPHONE CORE FUNCTIONS RELATED TO PRESENCE                               *
 ****************************************************************************/

/**
 * Create a SephonePresenceActivity with the given type and description.
 * @param[in] lc #SephoneCore object.
 * @param[in] acttype The #SephonePresenceActivityType to set for the activity.
 * @param[in] description An additional description of the activity to set for the activity. Can be NULL if no additional description is to be added.
 * @return The created #SephonePresenceActivity object.
 */
SEPHONE_PUBLIC SephonePresenceActivity * sephone_core_create_presence_activity(SephoneCore *lc, SephonePresenceActivityType acttype, const char *description);

/**
 * Create a default SephonePresenceModel.
 * @param[in] lc #SephoneCore object.
 * @return The created #SephonePresenceModel object.
 */
SEPHONE_PUBLIC SephonePresenceModel * sephone_core_create_presence_model(SephoneCore *lc);

/**
 * Create a SephonePresenceModel with the given activity type and activity description.
 * @param[in] lc #SephoneCore object.
 * @param[in] acttype The #SephonePresenceActivityType to set for the activity of the created model.
 * @param[in] description An additional description of the activity to set for the activity. Can be NULL if no additional description is to be added.
 * @return The created #SephonePresenceModel object.
 */
SEPHONE_PUBLIC SephonePresenceModel * sephone_core_create_presence_model_with_activity(SephoneCore *lc, SephonePresenceActivityType acttype, const char *description);

/**
 * Create a SephonePresenceModel with the given activity type, activity description, note content and note language.
 * @param[in] lc #SephoneCore object.
 * @param[in] acttype The #SephonePresenceActivityType to set for the activity of the created model.
 * @param[in] description An additional description of the activity to set for the activity. Can be NULL if no additional description is to be added.
 * @param[in] note The content of the note to be added to the created model.
 * @param[in] lang The language of the note to be added to the created model.
 * @return The created #SephonePresenceModel object.
 */
SEPHONE_PUBLIC SephonePresenceModel * sephone_core_create_presence_model_with_activity_and_note(SephoneCore *lc, SephonePresenceActivityType acttype, const char *description, const char *note, const char *lang);

/**
 * Create a SephonePresenceNote with the given content and language.
 * @param[in] lc #SephoneCore object.
 * @param[in] content The content of the note to be created.
 * @param[in] lang The language of the note to be created.
 * @return The created #SephonePresenceNote object.
 */
SEPHONE_PUBLIC SephonePresenceNote * sephone_core_create_presence_note(SephoneCore *lc, const char *content, const char *lang);

/**
 * Create a SephonePresencePerson with the given id.
 * @param[in] lc #SephoneCore object
 * @param[in] id The id of the person to be created.
 * @return The created #SephonePresencePerson object.
 */
SEPHONE_PUBLIC SephonePresencePerson * sephone_core_create_presence_person(SephoneCore *lc, const char *id);

/**
 * Create a SephonePresenceService with the given id, basic status and contact.
 * @param[in] lc #SephoneCore object.
 * @param[in] id The id of the service to be created.
 * @param[in] basic_status The basic status of the service to be created.
 * @param[in] contact A string containing a contact information corresponding to the service to be created.
 * @return The created #SephonePresenceService object.
 */
SEPHONE_PUBLIC SephonePresenceService * sephone_core_create_presence_service(SephoneCore *lc, const char *id, SephonePresenceBasicStatus basic_status, const char *contact);

/**
 * @}
 */


#ifdef __cplusplus
}
#endif

#endif /* SEPHONEPRESENCE_H_ */
