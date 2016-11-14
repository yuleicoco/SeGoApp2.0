/*
spc2xml.h
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

#ifndef SPC2XML_H_
#define SPC2XML_H_

#include "spconfig.h"

typedef struct _spc2xml_context spc2xml_context;

typedef enum _spc2xml_log_level {
	SPC2XML_DEBUG = 0,
	SPC2XML_MESSAGE,
	SPC2XML_WARNING,
	SPC2XML_ERROR
} spc2xml_log_level;

typedef void(*spc2xml_function)(void *ctx, spc2xml_log_level level, const char *fmt, va_list list);

spc2xml_context* spc2xml_context_new(spc2xml_function cbf, void *ctx);
void spc2xml_context_destroy(spc2xml_context*);

int spc2xml_set_spc(spc2xml_context* context, const SpConfig *lpc);

int spc2xml_convert_file(spc2xml_context* context, const char *filename);
int spc2xml_convert_fd(spc2xml_context* context, int fd);
int spc2xml_convert_string(spc2xml_context* context, char **content);


#endif //SPC2XML_H_
