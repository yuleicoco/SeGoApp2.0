/*
  The oRTP library is an RTP (Realtime Transport Protocol - rfc3550) stack.
  Copyright (C) 2001  Simon MORLAT simon.morlat@linphone.org

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

/**
 * \file logging.h
 * \brief Logging API.
 *
**/

#ifndef ORTP_LOGGING_H
#define ORTP_LOGGING_H

#include <ortp/port.h>
#ifdef HAVE_SLOG3
#include <LOG.h>
#endif // HAVE_SLOG3

#ifdef __cplusplus
extern "C"
{
#endif

typedef enum {
	ORTP_TRACE=0, // 将trace调为第1级
	ORTP_DEBUG=1,
	ORTP_MESSAGE=2,
	ORTP_WARNING=3,
	ORTP_ERROR=4,
	ORTP_FATAL=5,
	ORTP_LOGLEV_END=6
} OrtpLogLevel;


ORTP_PUBLIC void ortp_init_log_file(char *fpath);
ORTP_PUBLIC void ortp_set_log_file(FILE *file);

typedef void (*OrtpLogFunc)(int lev, const char *fmt, va_list args);

ORTP_PUBLIC void ortp_set_log_handler(OrtpLogFunc func);
//ORTP_PUBLIC OrtpLogFunc ortp_get_log_handler();
//ORTP_VAR_PUBLIC OrtpLogFunc ortp_logv_out;

#define ortp_log_level_enabled(level)	(ortp_get_log_level() >= (level))

/**
 * Flushes the log output queue.
 * WARNING: Must be called from the thread that has been defined with ortp_set_log_thread_id().
 */
ORTP_PUBLIC void ortp_logv_flush(void);

ORTP_PUBLIC void ortp_set_log_level(int level);
ORTP_PUBLIC int ortp_get_log_level(void);

/**
 * Tell oRTP the id of the thread used to output the logs.
 * This is meant to output all the logs from the same thread to prevent deadlock problems at the application level.
 * @param[in] thread_id The id of the thread that will output the logs (can be obtained using ortp_thread_self()).
 */
ORTP_PUBLIC void ortp_set_log_thread_id(unsigned long thread_id);

ORTP_PUBLIC int ortp_hex_snprintf(char *buff, size_t bufflen, char *data, size_t datalen, const char *fmt, ...);

#ifdef __GNUC__
#define CHECK_FORMAT_ARGS(m,n) __attribute__((format(printf,m,n)))
#else
#define CHECK_FORMAT_ARGS(m,n)
#endif
#ifdef __clang__
/*in case of compile with -g static inline can produce this type of warning*/
#pragma GCC diagnostic ignored "-Wunused-function"
#endif

#ifdef HAVE_SLOG3

//#ifdef ORTP_DEBUG_MODE
#define ortp_debug(...)		DebugLogG(__FILE__, __LINE__, __VA_ARGS__)
//#else // ORTP_DEBUG_MODE
//#define ortp_debug(...)
//#endif // ORTP_DEBUG_MODE
#define ortp_func()			ortp_debug("@func %s", __FUNCTION__)
#define ortp_infunc()		ortp_debug(">func %s", __FUNCTION__)
#define ortp_outfunc()		ortp_debug("<func %s", __FUNCTION__)

//#ifdef ORTP_NOMESSAGE_MODE
//#define ortp_log(...)
//#define ortp_message(...)
//#define ortp_warning(...)
//#else // ORTP_NOMESSAGE_MODE
#define ortp_log(_log_level_, ...)		WriteLogG(__FILE__, __LINE__, _log_level_, __VA_ARGS__)
#define ortp_message(...)	InfoLogG(__FILE__, __LINE__, __VA_ARGS__ )
#define ortp_warning(...)	WarnLogG(__FILE__, __LINE__, __VA_ARGS__ )
//#endif // ORTP_NOMESSAGE_MODE

#define ortp_error(...)		ErrorLogG(__FILE__, __LINE__, __VA_ARGS__)
#define ortp_fatal(...)		FatalLogG(__FILE__, __LINE__, __VA_ARGS__)

#else // HAVE_SLOG3

ORTP_PUBLIC void ortp_logv(int level, const char *fmt, va_list args);

#ifdef ORTP_DEBUG_MODE
static ORTP_INLINE void CHECK_FORMAT_ARGS(1,2) ortp_debug(const char *fmt,...)
{
  va_list args;
  va_start (args, fmt);
  ortp_logv(ORTP_DEBUG, fmt, args);
  va_end (args);
}
#else // ORTP_DEBUG_MODE
#define ortp_debug(...)
#endif // ORTP_DEBUG_MODE
#define ortp_func()			ortp_debug("@func %s", __FUNCTION__)
#define ortp_infunc()		ortp_debug(">func %s", __FUNCTION__)
#define ortp_outfunc()		ortp_debug("<func %s", __FUNCTION__)

#ifdef ORTP_NOMESSAGE_MODE

#define ortp_log(...)
#define ortp_message(...)
#define ortp_warning(...)

#else // ORTP_NOMESSAGE_MODE

static ORTP_INLINE void CHECK_FORMAT_ARGS(2,3) ortp_log(OrtpLogLevel lev, const char *fmt,...) {
	va_list args;
	va_start (args, fmt);
	ortp_logv(lev, fmt, args);
	va_end (args);
}

static ORTP_INLINE void CHECK_FORMAT_ARGS(1,2) ortp_message(const char *fmt,...)
{
	va_list args;
	va_start (args, fmt);
	ortp_logv(ORTP_MESSAGE, fmt, args);
	va_end (args);
}

static ORTP_INLINE void CHECK_FORMAT_ARGS(1,2) ortp_warning(const char *fmt,...)
{
	va_list args;
	va_start (args, fmt);
	ortp_logv(ORTP_WARNING, fmt, args);
	va_end (args);
}

#endif // ORTP_NOMESSAGE_MODE

static ORTP_INLINE void CHECK_FORMAT_ARGS(1,2) ortp_error(const char *fmt,...)
{
	va_list args;
	va_start (args, fmt);
	ortp_logv(ORTP_ERROR, fmt, args);
	va_end (args);
}

static ORTP_INLINE void CHECK_FORMAT_ARGS(1,2) ortp_fatal(const char *fmt,...)
{
	va_list args;
	va_start (args, fmt);
	ortp_logv(ORTP_FATAL, fmt, args);
	va_end (args);
}

#ifdef __QNX__
void ortp_qnx_log_handler(const char *domain, OrtpLogLevel lev, const char *fmt, va_list args);
#endif

#endif // HAVE_SLOG3


#ifdef __cplusplus
}
#endif

#endif
