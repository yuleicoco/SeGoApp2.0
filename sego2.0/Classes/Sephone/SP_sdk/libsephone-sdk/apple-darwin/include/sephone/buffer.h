/*
buffer.h
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

#ifndef SEPHONE_BUFFER_H_
#define SEPHONE_BUFFER_H_


#ifdef __cplusplus
extern "C" {
#endif


/**
 * @addtogroup misc
 * @{
 */

/**
 * The SephoneContent object representing a data buffer.
**/
typedef struct _SephoneBuffer SephoneBuffer;


/**
 * Create a new empty SephoneBuffer object.
 * @return A new SephoneBuffer object.
 */
SEPHONE_PUBLIC SephoneBuffer * sephone_buffer_new(void);

/**
 * Create a new SephoneBuffer object from existing data.
 * @param[in] data The initial data to store in the SephoneBuffer.
 * @param[in] size The size of the initial data to stroe in the SephoneBuffer.
 * @return A new SephoneBuffer object.
 */
SEPHONE_PUBLIC SephoneBuffer * sephone_buffer_new_from_data(const uint8_t *data, size_t size);

/**
 * Create a new SephoneBuffer object from a string.
 * @param[in] data The initial string content of the SephoneBuffer.
 * @return A new SephoneBuffer object.
 */
SEPHONE_PUBLIC SephoneBuffer * sephone_buffer_new_from_string(const char *data);

/**
 * Acquire a reference to the buffer.
 * @param[in] buffer SephoneBuffer object.
 * @return The same SephoneBuffer object.
**/
SEPHONE_PUBLIC SephoneBuffer * sephone_buffer_ref(SephoneBuffer *buffer);

/**
 * Release reference to the buffer.
 * @param[in] buffer SephoneBuffer object.
**/
SEPHONE_PUBLIC void sephone_buffer_unref(SephoneBuffer *buffer);

/**
 * Retrieve the user pointer associated with the buffer.
 * @param[in] buffer SephoneBuffer object.
 * @return The user pointer associated with the buffer.
**/
SEPHONE_PUBLIC void *sephone_buffer_get_user_data(const SephoneBuffer *buffer);

/**
 * Assign a user pointer to the buffer.
 * @param[in] buffer SephoneBuffer object.
 * @param[in] ud The user pointer to associate with the buffer.
**/
SEPHONE_PUBLIC void sephone_buffer_set_user_data(SephoneBuffer *buffer, void *ud);

/**
 * Get the content of the data buffer.
 * @param[in] buffer SephoneBuffer object.
 * @return The content of the data buffer.
 */
SEPHONE_PUBLIC const uint8_t * sephone_buffer_get_content(const SephoneBuffer *buffer);

/**
 * Set the content of the data buffer.
 * @param[in] buffer SephoneBuffer object.
 * @param[in] content The content of the data buffer.
 * @param[in] size The size of the content of the data buffer.
 */
SEPHONE_PUBLIC void sephone_buffer_set_content(SephoneBuffer *buffer, const uint8_t *content, size_t size);

/**
 * Get the string content of the data buffer.
 * @param[in] buffer SephoneBuffer object
 * @return The string content of the data buffer.
 */
SEPHONE_PUBLIC const char * sephone_buffer_get_string_content(const SephoneBuffer *buffer);

/**
 * Set the string content of the data buffer.
 * @param[in] buffer SephoneBuffer object.
 * @param[in] content The string content of the data buffer.
 */
SEPHONE_PUBLIC void sephone_buffer_set_string_content(SephoneBuffer *buffer, const char *content);

/**
 * Get the size of the content of the data buffer.
 * @param[in] buffer SephoneBuffer object.
 * @return The size of the content of the data buffer.
 */
SEPHONE_PUBLIC size_t sephone_buffer_get_size(const SephoneBuffer *buffer);

/**
 * Set the size of the content of the data buffer.
 * @param[in] buffer SephoneBuffer object
 * @param[in] size The size of the content of the data buffer.
 */
SEPHONE_PUBLIC void sephone_buffer_set_size(SephoneBuffer *buffer, size_t size);

/**
 * Tell whether the SephoneBuffer is empty.
 * @param[in] buffer SephoneBuffer object
 * @return A boolean value telling whether the SephoneBuffer is empty or not.
 */
SEPHONE_PUBLIC bool_t sephone_buffer_is_empty(const SephoneBuffer *buffer);

/**
 * @}
 */


#ifdef __cplusplus
}
#endif

#endif /* SEPHONE_CONTENT_H_ */
