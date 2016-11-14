/*
xml2spc.h
Copyright (C) 2012 Belledonne Communications SARL

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

#ifndef XML2SPC_H_
#define XML2SPC_H_

#include "spconfig.h"

typedef struct _xml2spc_context xml2spc_context;

typedef enum _xml2spc_log_level {
	XML2SPC_DEBUG = 0,
	XML2SPC_MESSAGE,
	XML2SPC_WARNING,
	XML2SPC_ERROR
} xml2spc_log_level;

typedef void(*xml2spc_function)(void *ctx, xml2spc_log_level level, const char *fmt, va_list list);

xml2spc_context* xml2spc_context_new(xml2spc_function cbf, void *ctx);
void xml2spc_context_destroy(xml2spc_context*);

int xml2spc_set_xml_file(xml2spc_context* context, const char *filename);
int xml2spc_set_xml_fd(xml2spc_context* context, int fd);
int xml2spc_set_xml_string(xml2spc_context* context, const char *content);

int xml2spc_set_xsd_file(xml2spc_context* context, const char *filename);
int xml2spc_set_xsd_fd(xml2spc_context* context, int fd);
int xml2spc_set_xsd_string(xml2spc_context* context, const char *content);

int xml2spc_validate(xml2spc_context *context);
int xml2spc_convert(xml2spc_context *context, SpConfig *lpc);



#endif //XML2SPC_H_
