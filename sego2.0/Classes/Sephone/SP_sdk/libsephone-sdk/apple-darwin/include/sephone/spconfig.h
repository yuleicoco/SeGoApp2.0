/***************************************************************************
 *            spconfig.h
 *
 *  Thu Mar 10 15:02:49 2005
 *  Copyright  2005  Simon Morlat
 *  Email simon.morlat@linphone.org
 ****************************************************************************/

/*
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#ifndef SPCONFIG_H
#define SPCONFIG_H
#include <mediastreamer2/mscommon.h>
#include <ortp/port.h>

#ifndef SEPHONE_PUBLIC
	#define SEPHONE_PUBLIC MS2_PUBLIC
#endif

/**
 * The SpConfig object is used to manipulate a configuration file.
 *
 * @ingroup misc
 * The format of the configuration file is a .ini like format:
 * - sections are defined in []
 * - each section contains a sequence of key=value pairs.
 *
 * Example:
 * @code
 * [sound]
 * echocanceler=1
 * playback_dev=ALSA: Default device
 *
 * [video]
 * enabled=1
 * @endcode
**/
typedef struct _SpConfig SpConfig;

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Instantiates a SpConfig object from a user config file.
 * The caller of this constructor owns a reference. sp_config_unref() must be called when this object is no longer needed.
 * @ingroup misc
 * @param filename the filename of the config file to read to fill the instantiated SpConfig
 * @see sp_config_new_with_factory
 */
SEPHONE_PUBLIC SpConfig * sp_config_new(const char *filename);

/**
 * Instantiates a SpConfig object from a user provided buffer.
 * The caller of this constructor owns a reference. sp_config_unref() must be called when this object is no longer needed.
 * @ingroup misc
 * @param buffer the buffer from which the spconfig will be retrieved. We expect the buffer to be null-terminated.
 * @see sp_config_new_with_factory
 * @see sp_config_new
 */
SEPHONE_PUBLIC SpConfig * sp_config_new_from_buffer(const char *buffer);

/**
 * Instantiates a SpConfig object from a user config file and a factory config file.
 * The caller of this constructor owns a reference. sp_config_unref() must be called when this object is no longer needed.
 * @ingroup misc
 * @param config_filename the filename of the user config file to read to fill the instantiated SpConfig
 * @param factory_config_filename the filename of the factory config file to read to fill the instantiated SpConfig
 * @see sp_config_new
 *
 * The user config file is read first to fill the SpConfig and then the factory config file is read.
 * Therefore the configuration parameters defined in the user config file will be overwritten by the parameters
 * defined in the factory config file.
 */
SEPHONE_PUBLIC SpConfig * sp_config_new_with_factory(const char *config_filename, const char *factory_config_filename);

/**
 * Reads a user config file and fill the SpConfig with the read config values.
 * @ingroup misc
 * @param spconfig The SpConfig object to fill with the content of the file
 * @param filename The filename of the config file to read to fill the SpConfig
 */
SEPHONE_PUBLIC int sp_config_read_file(SpConfig *spconfig, const char *filename);

/**
 * Retrieves a configuration item as a string, given its section, key, and default value.
 *
 * @ingroup misc
 * The default value string is returned if the config item isn't found.
**/
SEPHONE_PUBLIC const char *sp_config_get_string(const SpConfig *spconfig, const char *section, const char *key, const char *default_string);

/**
 * Retrieves a configuration item as a range, given its section, key, and default min and max values.
 *
 * @ingroup misc
 * @return TRUE if the value is successfully parsed as a range, FALSE otherwise.
 * If FALSE is returned, min and max are filled respectively with default_min and default_max values.
 */
SEPHONE_PUBLIC bool_t sp_config_get_range(const SpConfig *spconfig, const char *section, const char *key, int *min, int *max, int default_min, int default_max);

/**
 * Retrieves a configuration item as an integer, given its section, key, and default value.
 *
 * @ingroup misc
 * The default integer value is returned if the config item isn't found.
**/
SEPHONE_PUBLIC int sp_config_get_int(const SpConfig *spconfig,const char *section, const char *key, int default_value);

/**
 * Retrieves a configuration item as a 64 bit integer, given its section, key, and default value.
 *
 * @ingroup misc
 * The default integer value is returned if the config item isn't found.
**/
SEPHONE_PUBLIC int64_t sp_config_get_int64(const SpConfig *spconfig,const char *section, const char *key, int64_t default_value);

/**
 * Retrieves a configuration item as a float, given its section, key, and default value.
 *
 * @ingroup misc
 * The default float value is returned if the config item isn't found.
**/
SEPHONE_PUBLIC float sp_config_get_float(const SpConfig *spconfig,const char *section, const char *key, float default_value);

/**
 * Sets a string config item
 *
 * @ingroup misc
**/
SEPHONE_PUBLIC void sp_config_set_string(SpConfig *spconfig,const char *section, const char *key, const char *value);

/**
 * Sets a range config item
 *
 * @ingroup misc
 */
SEPHONE_PUBLIC void sp_config_set_range(SpConfig *spconfig, const char *section, const char *key, int min_value, int max_value);

/**
 * Sets an integer config item
 *
 * @ingroup misc
**/
SEPHONE_PUBLIC void sp_config_set_int(SpConfig *spconfig,const char *section, const char *key, int value);

/**
 * Sets an integer config item, but store it as hexadecimal
 *
 * @ingroup misc
**/
SEPHONE_PUBLIC void sp_config_set_int_hex(SpConfig *spconfig,const char *section, const char *key, int value);

/**
 * Sets a 64 bits integer config item
 *
 * @ingroup misc
**/
SEPHONE_PUBLIC void sp_config_set_int64(SpConfig *spconfig,const char *section, const char *key, int64_t value);

/**
 * Sets a float config item
 *
 * @ingroup misc
**/
SEPHONE_PUBLIC void sp_config_set_float(SpConfig *spconfig,const char *section, const char *key, float value);

/**
 * Writes the config file to disk.
 *
 * @ingroup misc
**/
SEPHONE_PUBLIC int sp_config_sync(SpConfig *spconfig);

/**
 * Returns 1 if a given section is present in the configuration.
 *
 * @ingroup misc
**/
SEPHONE_PUBLIC int sp_config_has_section(const SpConfig *spconfig, const char *section);

/**
 * Removes every pair of key,value in a section and remove the section.
 *
 * @ingroup misc
**/
SEPHONE_PUBLIC void sp_config_clean_section(SpConfig *spconfig, const char *section);

/**
 * Call a function for each section present in the configuration.
 *
 * @ingroup misc
**/
void sp_config_for_each_section(const SpConfig *spconfig, void (*callback)(const char *section, void *ctx), void *ctx);

/**
 * Call a function for each entry present in a section configuration.
 *
 * @ingroup misc
**/
void sp_config_for_each_entry(const SpConfig *spconfig, const char *section, void (*callback)(const char *entry, void *ctx), void *ctx);

/*tells whether uncommited (with sp_config_sync()) modifications exist*/
int sp_config_needs_commit(const SpConfig *spconfig);

SEPHONE_PUBLIC void sp_config_destroy(SpConfig *cfg);

/**
 * Retrieves a default configuration item as an integer, given its section, key, and default value.
 *
 * @ingroup misc
 * The default integer value is returned if the config item isn't found.
**/
SEPHONE_PUBLIC int sp_config_get_default_int(const SpConfig *spconfig, const char *section, const char *key, int default_value);

/**
 * Retrieves a default configuration item as a 64 bit integer, given its section, key, and default value.
 *
 * @ingroup misc
 * The default integer value is returned if the config item isn't found.
**/
SEPHONE_PUBLIC int64_t sp_config_get_default_int64(const SpConfig *spconfig, const char *section, const char *key, int64_t default_value);

/**
 * Retrieves a default configuration item as a float, given its section, key, and default value.
 *
 * @ingroup misc
 * The default float value is returned if the config item isn't found.
**/
SEPHONE_PUBLIC float sp_config_get_default_float(const SpConfig *spconfig, const char *section, const char *key, float default_value);

/**
 * Retrieves a default configuration item as a string, given its section, key, and default value.
 *
 * @ingroup misc
 * The default value string is returned if the config item isn't found.
**/
SEPHONE_PUBLIC const char* sp_config_get_default_string(const SpConfig *spconfig, const char *section, const char *key, const char *default_value);

/**
 * Retrieves a section parameter item as a string, given its section and key.
 *
 * @ingroup misc
 * The default value string is returned if the config item isn't found.
**/
SEPHONE_PUBLIC const char* sp_config_get_section_param_string(const SpConfig *spconfig, const char *section, const char *key, const char *default_value);


/**
 * increment reference count
 * @ingroup misc
**/
SEPHONE_PUBLIC SpConfig *sp_config_ref(SpConfig *spconfig);

/**
 * Decrement reference count, which will eventually free the object.
 * @ingroup misc
**/
SEPHONE_PUBLIC void sp_config_unref(SpConfig *spconfig);

/**
 * @brief Write a string in a file placed relatively with the Sephone configuration file.
 * @param spconfig SpConfig instance used as a reference
 * @param filename Name of the file where to write data. The name is relative to the place of the config file
 * @param data String to write
 */
SEPHONE_PUBLIC void sp_config_write_relative_file(const SpConfig *spconfig, const char *filename, const char *data);

/**
 * @brief Read a string from a file placed beside the Sephone configuration file
 * @param spconfig SpConfig instance used as a reference
 * @param filename Name of the file where data will be read from. The name is relative to the place of the config file
 * @param data Buffer where read string will be stored
 * @param max_length Length of the buffer
 * @return 0 on success, -1 on failure
 */
SEPHONE_PUBLIC int sp_config_read_relative_file(const SpConfig *spconfig, const char *filename, char *data, size_t max_length);

#ifdef __cplusplus
}
#endif

#endif
