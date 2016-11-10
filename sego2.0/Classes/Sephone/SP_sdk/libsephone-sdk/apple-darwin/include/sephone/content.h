/*
content.h
Copyright (C) 2010-2014 Belledonne Communications SARL

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

#ifndef SEPHONE_CONTENT_H_
#define SEPHONE_CONTENT_H_


#ifdef __cplusplus
extern "C" {
#endif


/**
 * @addtogroup misc
 * @{
 */

/**
 * The SephoneContent object holds data that can be embedded in a signaling message.
**/
struct _SephoneContent;
/**
 * The SephoneContent object holds data that can be embedded in a signaling message.
**/
typedef struct _SephoneContent SephoneContent;

/**
 * @deprecated Use SephoneContent objects instead of this structure.
 */
struct _SephoneContentPrivate{
	char *type; /**<mime type for the data, for example "application"*/
	char *subtype; /**<mime subtype for the data, for example "html"*/
	void *data; /**<the actual data buffer, usually a string. Null when provided by callbacks #SephoneCoreFileTransferSendCb or #SephoneCoreFileTransferRecvCb*/
	size_t size; /**<the size of the data buffer, excluding null character despite null character is always set for convenience.
				When provided by callback #SephoneCoreFileTransferSendCb or #SephoneCoreFileTransferRecvCb, it states the total number of bytes of the transfered file*/
	char *encoding; /**<The encoding of the data buffer, for example "gzip"*/
	char *name; /**< used by RCS File transfer messages to store the original filename of the file to be downloaded from server */
	char *key; /**< used by RCS File transfer messages to store the key to encrypt file if needed */
	size_t keyLength; /**< Length of key in bytes */
	void *cryptoContext; /**< crypto context used to encrypt file for RCS file transfer */
};

/**
 * Alias to the SephoneContentPrivate struct.
 * @deprecated
**/
typedef struct _SephoneContentPrivate SephoneContentPrivate;

/**
 * Convert a SephoneContentPrivate structure to a SephoneContent object.
 * @deprecated Utility macro to ease porting existing code from SephoneContentPrivate structure (old SephoneContent structure) to new SephoneContent object.
 */
#define SEPHONE_CONTENT(lcp) sephone_content_private_to_sephone_content(lcp)

/**
 * Convert a SephoneContentPrivate structure to a SephoneContent object.
 * @deprecated Utility function to ease porting existing code from SephoneContentPrivate structure (old SephoneContent structure) to new SephoneContent object.
 */
SEPHONE_PUBLIC SephoneContent * sephone_content_private_to_sephone_content(const SephoneContentPrivate *lcp);

/**
 * Convert a SephoneContent object to a SephoneContentPrivate structure.
 * @deprecated Utility macro to ease porting existing code from SephoneContentPrivate structure (old SephoneContent structure) to new SephoneContent object.
 */
#define SEPHONE_CONTENT_PRIVATE(lc) sephone_content_to_sephone_content_private(lc)

/**
 * Convert a SephoneContent object to a SephoneContentPrivate structure.
 * @deprecated Utility function to ease porting existing code from SephoneContentPrivate structure (old SephoneContent structure) to new SephoneContent object.
 */
SEPHONE_PUBLIC SephoneContentPrivate * sephone_content_to_sephone_content_private(const SephoneContent *content);

/**
 * Create a content with default values from Sephone core.
 * @param[in] lc SephoneCore object
 * @return SephoneContent object with default values set
 */
SEPHONE_PUBLIC SephoneContent * sephone_core_create_content(SephoneCore *lc);

/**
 * Acquire a reference to the content.
 * @param[in] content SephoneContent object.
 * @return The same SephoneContent object.
**/
SEPHONE_PUBLIC SephoneContent * sephone_content_ref(SephoneContent *content);

/**
 * Release reference to the content.
 * @param[in] content SephoneContent object.
**/
SEPHONE_PUBLIC void sephone_content_unref(SephoneContent *content);

/**
 * Retrieve the user pointer associated with the content.
 * @param[in] content SephoneContent object.
 * @return The user pointer associated with the content.
**/
SEPHONE_PUBLIC void *sephone_content_get_user_data(const SephoneContent *content);

/**
 * Assign a user pointer to the content.
 * @param[in] content SephoneContent object.
 * @param[in] ud The user pointer to associate with the content.
**/
SEPHONE_PUBLIC void sephone_content_set_user_data(SephoneContent *content, void *ud);

/**
 * Get the mime type of the content data.
 * @param[in] content SephoneContent object.
 * @return The mime type of the content data, for example "application".
 */
SEPHONE_PUBLIC const char * sephone_content_get_type(const SephoneContent *content);

/**
 * Set the mime type of the content data.
 * @param[in] content SephoneContent object.
 * @param[in] type The mime type of the content data, for example "application".
 */
SEPHONE_PUBLIC void sephone_content_set_type(SephoneContent *content, const char *type);

/**
 * Get the mime subtype of the content data.
 * @param[in] content SephoneContent object.
 * @return The mime subtype of the content data, for example "html".
 */
SEPHONE_PUBLIC const char * sephone_content_get_subtype(const SephoneContent *content);

/**
 * Set the mime subtype of the content data.
 * @param[in] content SephoneContent object.
 * @param[in] subtype The mime subtype of the content data, for example "html".
 */
SEPHONE_PUBLIC void sephone_content_set_subtype(SephoneContent *content, const char *subtype);

/**
 * Get the content data buffer, usually a string.
 * @param[in] content SephoneContent object.
 * @return The content data buffer.
 */
SEPHONE_PUBLIC void * sephone_content_get_buffer(const SephoneContent *content);

/**
 * Set the content data buffer, usually a string.
 * @param[in] content SephoneContent object.
 * @param[in] buffer The content data buffer.
 * @param[in] size The size of the content data buffer.
 */
SEPHONE_PUBLIC void sephone_content_set_buffer(SephoneContent *content, const void *buffer, size_t size);

/**
 * Get the string content data buffer.
 * @param[in] content SephoneContent object
 * @return The string content data buffer.
 */
SEPHONE_PUBLIC const char * sephone_content_get_string_buffer(const SephoneContent *content);

/**
 * Set the string content data buffer.
 * @param[in] content SephoneContent object.
 * @param[in] buffer The string content data buffer.
 */
SEPHONE_PUBLIC void sephone_content_set_string_buffer(SephoneContent *content, const char *buffer);

/**
 * Get the content data buffer size, excluding null character despite null character is always set for convenience.
 * @param[in] content SephoneContent object.
 * @return The content data buffer size.
 */
SEPHONE_PUBLIC size_t sephone_content_get_size(const SephoneContent *content);

/**
 * Set the content data size, excluding null character despite null character is always set for convenience.
 * @param[in] content SephoneContent object
 * @param[in] size The content data buffer size.
 */
SEPHONE_PUBLIC void sephone_content_set_size(SephoneContent *content, size_t size);

/**
 * Get the encoding of the data buffer, for example "gzip".
 * @param[in] content SephoneContent object.
 * @return The encoding of the data buffer.
 */
SEPHONE_PUBLIC const char * sephone_content_get_encoding(const SephoneContent *content);

/**
 * Set the encoding of the data buffer, for example "gzip".
 * @param[in] content SephoneContent object.
 * @param[in] encoding The encoding of the data buffer.
 */
SEPHONE_PUBLIC void sephone_content_set_encoding(SephoneContent *content, const char *encoding);

/**
 * Get the name associated with a RCS file transfer message. It is used to store the original filename of the file to be downloaded from server.
 * @param[in] content SephoneContent object.
 * @return The name of the content.
 */
SEPHONE_PUBLIC const char * sephone_content_get_name(const SephoneContent *content);

/**
 * Set the name associated with a RCS file transfer message. It is used to store the original filename of the file to be downloaded from server.
 * @param[in] content SephoneContent object.
 * @param[in] name The name of the content.
 */
SEPHONE_PUBLIC void sephone_content_set_name(SephoneContent *content, const char *name);

/**
 * @}
 */


#ifdef __cplusplus
}
#endif

#endif /* SEPHONE_CONTENT_H_ */
