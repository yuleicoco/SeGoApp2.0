/* Utils.m
 *
 * Copyright (C) 2012  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or   
 *  (at your option) any later version.                                 
 *                                                                      
 *  This program is distributed in the hope that it will be useful,     
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of      
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       
 *  GNU General Public License for more details.                
 *                                                                      
 *  You should have received a copy of the GNU General Public License   
 *  along with this program; if not, write to the Free Software         
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */   


#import "SephoneUtils.h"
#include "sephone/sephonecore.h"


@implementation SephoneLogger


+ (void)logv:(SephoneLoggerSeverity)severity format:(NSString*)format args:(va_list)args{
    NSString *str = [[NSString alloc] initWithFormat: format arguments:args];
    if(severity <= SephoneLoggerDebug) {
        ms_debug("%s", [str UTF8String]);
    } else  if(severity <= SephoneLoggerLog) {
        ms_message("%s", [str UTF8String]);
    } else if(severity <= SephoneLoggerWarning) {
        ms_warning("%s", [str UTF8String]);
    } else if(severity <= SephoneLoggerError) {
        ms_error("%s", [str UTF8String]);
    } else if(severity <= SephoneLoggerFatal) {
        ms_fatal("%s", [str UTF8String]);
    }
    [str release];
}

+ (void)log:(SephoneLoggerSeverity) severity format:(NSString *)format,... {
    va_list args;
	va_start (args, format);
    [SephoneLogger logv:severity format:format args:args];
    va_end (args);
}

+ (void)logc:(SephoneLoggerSeverity) severity format:(const char *)format,... {
    va_list args;
	va_start (args, format);
    if(severity <= SephoneLoggerDebug) {
        ortp_logv(ORTP_DEBUG, format, args);
    } else if(severity <= SephoneLoggerLog) {
        ortp_logv(ORTP_MESSAGE, format, args);
    } else if(severity <= SephoneLoggerWarning) {
        ortp_logv(ORTP_WARNING, format, args);
    } else if(severity <= SephoneLoggerError) {
        ortp_logv(ORTP_ERROR, format, args);
    } else if(severity <= SephoneLoggerFatal) {
        ortp_logv(ORTP_FATAL, format, args);
    }
	va_end (args);
}

@end

@implementation SephoneUtils

+ (BOOL)findAndResignFirstResponder:(UIView*)view {
    if (view.isFirstResponder) {
        [view resignFirstResponder];
        return YES;
    }
    for (UIView *subView in view.subviews) {
        if ([SephoneUtils findAndResignFirstResponder:subView])
            return YES;
    }
    return NO;
}

+ (void)adjustFontSize:(UIView*)view mult:(float)mult{
    if([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel*)view;
        UIFont *font = [label font];
        [label setFont:[UIFont fontWithName:font.fontName size:font.pointSize * mult]];
    } else if([view isKindOfClass:[UITextField class]]) {
        UITextField *label = (UITextField*)view;
        UIFont *font = [label font];
        [label setFont:[UIFont fontWithName:font.fontName size:font.pointSize * mult]];
    } else if([view isKindOfClass:[UIButton class]]) {
        UIButton* button = (UIButton*)view;
        UIFont* font = button.titleLabel.font;
        [button.titleLabel setFont:[UIFont fontWithName:font.fontName size:font.pointSize*mult]];
    } else {
        for(UIView *subView in [view subviews]) {
            [SephoneUtils adjustFontSize:subView mult:mult];
        }
    }
}

+ (void)buttonFixStates:(UIButton*)button {
    // Set selected+over title: IB lack !
    [button setTitle:[button titleForState:UIControlStateSelected]
                 forState:(UIControlStateHighlighted | UIControlStateSelected)];
    
    // Set selected+over titleColor: IB lack !
    [button setTitleColor:[button titleColorForState:UIControlStateHighlighted]
                      forState:(UIControlStateHighlighted | UIControlStateSelected)];
    
    // Set selected+disabled title: IB lack !
    [button setTitle:[button titleForState:UIControlStateSelected]
                 forState:(UIControlStateDisabled | UIControlStateSelected)];
    
    // Set selected+disabled titleColor: IB lack !
    [button setTitleColor:[button titleColorForState:UIControlStateDisabled]
                      forState:(UIControlStateDisabled | UIControlStateSelected)];
}

+ (void)buttonFixStatesForTabs:(UIButton*)button {
    // Set selected+over title: IB lack !
    [button setTitle:[button titleForState:UIControlStateSelected]
            forState:(UIControlStateHighlighted | UIControlStateSelected)];
    
    // Set selected+over titleColor: IB lack !
    [button setTitleColor:[button titleColorForState:UIControlStateSelected]
                 forState:(UIControlStateHighlighted | UIControlStateSelected)];
    
    // Set selected+disabled title: IB lack !
    [button setTitle:[button titleForState:UIControlStateSelected]
            forState:(UIControlStateDisabled | UIControlStateSelected)];
    
    // Set selected+disabled titleColor: IB lack !
    [button setTitleColor:[button titleColorForState:UIControlStateDisabled]
                 forState:(UIControlStateDisabled | UIControlStateSelected)];
}

+ (void)buttonMultiViewAddAttributes:(NSMutableDictionary*)attributes button:(UIButton*)button {
    [SephoneUtils addDictEntry:attributes item:[button titleForState:UIControlStateNormal] key:@"title-normal"];
    [SephoneUtils addDictEntry:attributes item:[button titleForState:UIControlStateHighlighted] key:@"title-highlighted"];
    [SephoneUtils addDictEntry:attributes item:[button titleForState:UIControlStateDisabled] key:@"title-disabled"];
    [SephoneUtils addDictEntry:attributes item:[button titleForState:UIControlStateSelected] key:@"title-selected"];
    [SephoneUtils addDictEntry:attributes item:[button titleForState:UIControlStateDisabled | UIControlStateHighlighted] key:@"title-disabled-highlighted"];
    [SephoneUtils addDictEntry:attributes item:[button titleForState:UIControlStateSelected | UIControlStateHighlighted] key:@"title-selected-highlighted"];
    [SephoneUtils addDictEntry:attributes item:[button titleForState:UIControlStateSelected | UIControlStateDisabled] key:@"title-selected-disabled"];
    
    [SephoneUtils addDictEntry:attributes item:[button titleColorForState:UIControlStateNormal] key:@"title-color-normal"];
    [SephoneUtils addDictEntry:attributes item:[button titleColorForState:UIControlStateHighlighted] key:@"title-color-highlighted"];
    [SephoneUtils addDictEntry:attributes item:[button titleColorForState:UIControlStateDisabled] key:@"title-color-disabled"];
    [SephoneUtils addDictEntry:attributes item:[button titleColorForState:UIControlStateSelected] key:@"title-color-selected"];
    [SephoneUtils addDictEntry:attributes item:[button titleColorForState:UIControlStateDisabled | UIControlStateHighlighted] key:@"title-color-disabled-highlighted"];
    [SephoneUtils addDictEntry:attributes item:[button titleColorForState:UIControlStateSelected | UIControlStateHighlighted] key:@"title-color-selected-highlighted"];
    [SephoneUtils addDictEntry:attributes item:[button titleColorForState:UIControlStateSelected | UIControlStateDisabled] key:@"title-color-selected-disabled"];
    
	[SephoneUtils addDictEntry:attributes item:NSStringFromUIEdgeInsets([button titleEdgeInsets]) key:@"title-edge"];
	[SephoneUtils addDictEntry:attributes item:NSStringFromUIEdgeInsets([button contentEdgeInsets]) key:@"content-edge"];
	[SephoneUtils addDictEntry:attributes item:NSStringFromUIEdgeInsets([button imageEdgeInsets]) key:@"image-edge"];
	
    [SephoneUtils addDictEntry:attributes item:[button imageForState:UIControlStateNormal] key:@"image-normal"];
    [SephoneUtils addDictEntry:attributes item:[button imageForState:UIControlStateHighlighted] key:@"image-highlighted"];
    [SephoneUtils addDictEntry:attributes item:[button imageForState:UIControlStateDisabled] key:@"image-disabled"];
    [SephoneUtils addDictEntry:attributes item:[button imageForState:UIControlStateSelected] key:@"image-selected"];
    [SephoneUtils addDictEntry:attributes item:[button imageForState:UIControlStateDisabled | UIControlStateHighlighted] key:@"image-disabled-highlighted"];
    [SephoneUtils addDictEntry:attributes item:[button imageForState:UIControlStateSelected | UIControlStateHighlighted] key:@"image-selected-highlighted"];
    [SephoneUtils addDictEntry:attributes item:[button imageForState:UIControlStateSelected | UIControlStateDisabled] key:@"image-selected-disabled"];
    
    [SephoneUtils addDictEntry:attributes item:[button backgroundImageForState:UIControlStateNormal] key:@"background-normal"];
    [SephoneUtils addDictEntry:attributes item:[button backgroundImageForState:UIControlStateHighlighted] key:@"background-highlighted"];
    [SephoneUtils addDictEntry:attributes item:[button backgroundImageForState:UIControlStateDisabled] key:@"background-disabled"];
    [SephoneUtils addDictEntry:attributes item:[button backgroundImageForState:UIControlStateSelected] key:@"background-selected"];
    [SephoneUtils addDictEntry:attributes item:[button backgroundImageForState:UIControlStateDisabled | UIControlStateHighlighted] key:@"background-disabled-highlighted"];
    [SephoneUtils addDictEntry:attributes item:[button backgroundImageForState:UIControlStateSelected | UIControlStateHighlighted] key:@"background-selected-highlighted"];
    [SephoneUtils addDictEntry:attributes item:[button backgroundImageForState:UIControlStateSelected | UIControlStateDisabled] key:@"background-selected-disabled"];
}

+ (void)buttonMultiViewApplyAttributes:(NSDictionary*)attributes button:(UIButton*)button {
    [button setTitle:[SephoneUtils getDictEntry:attributes key:@"title-normal"] forState:UIControlStateNormal];
    [button setTitle:[SephoneUtils getDictEntry:attributes key:@"title-highlighted"] forState:UIControlStateHighlighted];
    [button setTitle:[SephoneUtils getDictEntry:attributes key:@"title-disabled"] forState:UIControlStateDisabled];
    [button setTitle:[SephoneUtils getDictEntry:attributes key:@"title-selected"] forState:UIControlStateSelected];
    [button setTitle:[SephoneUtils getDictEntry:attributes key:@"title-disabled-highlighted"] forState:UIControlStateDisabled | UIControlStateHighlighted];
    [button setTitle:[SephoneUtils getDictEntry:attributes key:@"title-selected-highlighted"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [button setTitle:[SephoneUtils getDictEntry:attributes key:@"title-selected-disabled"] forState:UIControlStateSelected | UIControlStateDisabled];
    
    [button setTitleColor:[SephoneUtils getDictEntry:attributes key:@"title-color-normal"] forState:UIControlStateNormal];
    [button setTitleColor:[SephoneUtils getDictEntry:attributes key:@"title-color-highlighted"] forState:UIControlStateHighlighted];
    [button setTitleColor:[SephoneUtils getDictEntry:attributes key:@"title-color-disabled"] forState:UIControlStateDisabled];
    [button setTitleColor:[SephoneUtils getDictEntry:attributes key:@"title-color-selected"] forState:UIControlStateSelected];
    [button setTitleColor:[SephoneUtils getDictEntry:attributes key:@"title-color-disabled-highlighted"] forState:UIControlStateDisabled | UIControlStateHighlighted];
    [button setTitleColor:[SephoneUtils getDictEntry:attributes key:@"title-color-selected-highlighted"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [button setTitleColor:[SephoneUtils getDictEntry:attributes key:@"title-color-selected-disabled"] forState:UIControlStateSelected | UIControlStateDisabled];
    
	[button setTitleEdgeInsets:UIEdgeInsetsFromString([SephoneUtils getDictEntry:attributes key:@"title-edge"])];
	[button setContentEdgeInsets:UIEdgeInsetsFromString([SephoneUtils getDictEntry:attributes key:@"content-edge"])];
	[button setImageEdgeInsets:UIEdgeInsetsFromString([SephoneUtils getDictEntry:attributes key:@"image-edge"])];

    [button setImage:[SephoneUtils getDictEntry:attributes key:@"image-normal"] forState:UIControlStateNormal];
    [button setImage:[SephoneUtils getDictEntry:attributes key:@"image-highlighted"] forState:UIControlStateHighlighted];
    [button setImage:[SephoneUtils getDictEntry:attributes key:@"image-disabled"] forState:UIControlStateDisabled];
    [button setImage:[SephoneUtils getDictEntry:attributes key:@"image-selected"] forState:UIControlStateSelected];
    [button setImage:[SephoneUtils getDictEntry:attributes key:@"image-disabled-highlighted"] forState:UIControlStateDisabled | UIControlStateHighlighted];
    [button setImage:[SephoneUtils getDictEntry:attributes key:@"image-selected-highlighted"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [button setImage:[SephoneUtils getDictEntry:attributes key:@"image-selected-disabled"] forState:UIControlStateSelected | UIControlStateDisabled];
    
    [button setBackgroundImage:[SephoneUtils getDictEntry:attributes key:@"background-normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[SephoneUtils getDictEntry:attributes key:@"background-highlighted"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[SephoneUtils getDictEntry:attributes key:@"background-disabled"] forState:UIControlStateDisabled];
    [button setBackgroundImage:[SephoneUtils getDictEntry:attributes key:@"background-selected"] forState:UIControlStateSelected];
    [button setBackgroundImage:[SephoneUtils getDictEntry:attributes key:@"background-disabled-highlighted"] forState:UIControlStateDisabled | UIControlStateHighlighted];
    [button setBackgroundImage:[SephoneUtils getDictEntry:attributes key:@"background-selected-highlighted"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [button setBackgroundImage:[SephoneUtils getDictEntry:attributes key:@"background-selected-disabled"] forState:UIControlStateSelected | UIControlStateDisabled];
}


+ (void)addDictEntry:(NSMutableDictionary*)dict item:(id)item key:(id)key {
    if(item != nil && key != nil) {
        [dict setObject:item forKey:key];
    }
}

+ (id)getDictEntry:(NSDictionary*)dict key:(id)key {
    if(key != nil) {
        return [dict objectForKey:key];
    }
    return nil;
}

@end

@implementation NSNumber (HumanReadableSize)

- (NSString*)toHumanReadableSize {
    float floatSize = [self floatValue];
	if (floatSize < 1023)
		return([NSString stringWithFormat:@"%1.0f bytes",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize < 1023)
		return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize < 1023)
		return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
	floatSize = floatSize / 1024;
    
	return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

@end

#define LOGV(level, argstart)   \
    va_list args;               \
    va_start(args, argstart);   \
    [SephoneLogger logv:level format:argstart args:args]; \
    va_end(args);

void LOGI(NSString* format, ...){
    LOGV(SephoneLoggerLog, format);
}

void LOGD(NSString* format, ...){
    LOGV(SephoneLoggerDebug, format);
}

void LOGW(NSString* format, ...){
    LOGV(SephoneLoggerWarning, format);
}

void LOGE(NSString* format, ...){
    LOGV(SephoneLoggerError, format);
}

void LOGF(NSString* format, ...){
    LOGV(SephoneLoggerFatal, format);
}
