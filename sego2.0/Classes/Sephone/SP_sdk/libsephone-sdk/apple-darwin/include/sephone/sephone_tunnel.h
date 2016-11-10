/***************************************************************************
 *            sephone_tunnel.h
 *
 *  Fri Dec 9, 2011
 *  Copyright  2011  Belledonne Communications
 *  Author: Guillaume Beraudo
 *  Email: guillaume.beraudo@linphone.org
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
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#ifndef SEPHONETUNNEL_H
#define SEPHONETUNNEL_H

#include "sephonecore.h"


/**
 * @addtogroup tunnel
 * @{
**/

	/**
	 * Sephone tunnel aims is to bypass IP traffic blocking due to aggressive firewalls which typically only authorize TCP traffic with destination port 443.
	 * <br> Its principle is tunneling all SIP and/or RTP traffic through a single secure https connection up to a detunnelizer server.
	 * <br> This set of methods enhance  SephoneCore functionalities in order to provide an easy to use API to
	 * \li provision tunnel servers IP addresses and ports. This functionality is an option not implemented under GPL. Availability can be check at runtime using function #sephone_core_tunnel_available
	 * \li start/stop the tunneling service
	 * \li perform auto-detection whether tunneling is required, based on a test of sending/receiving a flow of UDP packets.
	 *
	 * It takes in charge automatically the SIP registration procedure when connecting or disconnecting to a tunnel server.
	 * No other action on SephoneCore is required to enable full operation in tunnel mode.
	 *
	 * <br> Provision is done using object #SephoneTunnelConfig created by function #sephone_tunnel_config_new(). Functions #sephone_tunnel_config_set_host
	 *  and #sephone_tunnel_config_set_port allow to point to tunnel server IP/port. Once set, use function #sephone_tunnel_add_server to provision a tunnel server.
	 *  <br> Finally  tunnel mode configuration is achieved by function #sephone_tunnel_set_mode.
	 *  <br> Tunnel connection status can be checked using function #sephone_tunnel_connected.
	 *
	 * Bellow pseudo code that can be use to configure, enable, check state and disable tunnel functionality:
	 *
	 * \code
	SephoneTunnel *tunnel = sephone_core_get_tunnel(sephone_core);
	SephoneTunnelConfig *config=sephone_tunnel_config_new(); //instantiate tunnel configuration
	sephone_tunnel_config_set_host(config, "tunnel.linphone.org"); //set tunnel server host address
	sephone_tunnel_config_set_port(config, 443); //set tunnel server port
	sephone_tunnel_add_server(tunnel, config); //provision tunnel config
	sephone_tunnel_set_mode(tunnel, SephoneTunnelModeEnable); //activate the tunnel unconditional

	while (!sephone_tunnel_connected(tunnel)) { //wait for tunnel to be ready
		sephone_core_iterate(sephone_core); //schedule core main loop
		ms_sleep(100); //wait 100ms
	}

	SephoneCall *call = sephone_core_invite(sephone_core,"sip:foo@example.org"); //place an outgoing call
	sephone_call_ref(call); //acquire a reference on the call to avoid deletion after completion
	//...
	sephone_core_terminate_call(sephone_core,call);

	while (sephone_call_get_state(call) != SephoneCallReleased) { //wait for call to be in release state
		sephone_core_iterate(sephone_core); //schedule core main loop
		ms_sleep(100); //wait 100ms
	}

	sephone_tunnel_set_mode(tunnel, SephoneTunnelModeDisable); //deactivate tunnel
	sephone_call_unref(call); //release reference on the call

	\endcode
*
*	**/

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct _SephoneTunnelConfig SephoneTunnelConfig;

/**
 * Enum describing the tunnel modes.
**/
typedef enum _SephoneTunnelMode {
	SephoneTunnelModeDisable,	/**< The tunnel is disabled. */
	SephoneTunnelModeEnable,	/**< The tunnel is enabled. */
	SephoneTunnelModeAuto	/**< The tunnel is enabled automatically if it is required. */
} SephoneTunnelMode;

/**
 * Convert a string into SephoneTunnelMode enum
 * @param string String to convert
 * @return An SephoneTunnelMode enum. If the passed string is NULL or
 * does not match with any mode, the SephoneTunnelModeDisable is returned.
 */
SEPHONE_PUBLIC SephoneTunnelMode sephone_tunnel_mode_from_string(const char *string);

/**
 * Convert a tunnel mode enum into string
 * @param mode Enum to convert
 * @return "disable", "enable" or "auto"
 */
SEPHONE_PUBLIC const char *sephone_tunnel_mode_to_string(SephoneTunnelMode mode);

/**
 * Create a new tunnel configuration
 */
SEPHONE_PUBLIC SephoneTunnelConfig *sephone_tunnel_config_new(void);

/**
 * Set the IP address or hostname of the tunnel server.
 * @param tunnel SephoneTunnelConfig object
 * @param host The tunnel server IP address or hostname
 */
SEPHONE_PUBLIC void sephone_tunnel_config_set_host(SephoneTunnelConfig *tunnel, const char *host);

/**
 * Get the IP address or hostname of the tunnel server.
 * @param tunnel SephoneTunnelConfig object
 * @return The tunnel server IP address or hostname
 */
SEPHONE_PUBLIC const char *sephone_tunnel_config_get_host(const SephoneTunnelConfig *tunnel);

/**
 * Set tls port of server.
 * @param tunnel SephoneTunnelConfig object
 * @param port The tunnel server TLS port, recommended value is 443
 */
SEPHONE_PUBLIC void sephone_tunnel_config_set_port(SephoneTunnelConfig *tunnel, int port);

/**
 * Get the TLS port of the tunnel server.
 * @param tunnel SephoneTunnelConfig object
 * @return The TLS port of the tunnel server
 */
SEPHONE_PUBLIC int sephone_tunnel_config_get_port(const SephoneTunnelConfig *tunnel);

/**
 * Set the remote port on the tunnel server side used to test UDP reachability.
 * This is used when the mode is set auto, to detect whether the tunnel has to be enabled or not.
 * @param tunnel SephoneTunnelConfig object
 * @param remote_udp_mirror_port The remote port on the tunnel server side used to test UDP reachability, set to -1 to disable the feature
 */
SEPHONE_PUBLIC void sephone_tunnel_config_set_remote_udp_mirror_port(SephoneTunnelConfig *tunnel, int remote_udp_mirror_port);

/**
 * Get the remote port on the tunnel server side used to test UDP reachability.
 * This is used when the mode is set auto, to detect whether the tunnel has to be enabled or not.
 * @param tunnel SephoneTunnelConfig object
 * @return The remote port on the tunnel server side used to test UDP reachability
 */
SEPHONE_PUBLIC int sephone_tunnel_config_get_remote_udp_mirror_port(const SephoneTunnelConfig *tunnel);

/**
 * Set the UDP packet round trip delay in ms for a tunnel configuration.
 * @param tunnel SephoneTunnelConfig object
 * @param delay The UDP packet round trip delay in ms considered as acceptable (recommended value is 1000 ms).
 */
SEPHONE_PUBLIC void sephone_tunnel_config_set_delay(SephoneTunnelConfig *tunnel, int delay);

/**
 * Get the UDP packet round trip delay in ms for a tunnel configuration.
 * @param tunnel SephoneTunnelConfig object
 * @return The UDP packet round trip delay in ms.
 */
SEPHONE_PUBLIC int sephone_tunnel_config_get_delay(const SephoneTunnelConfig *tunnel);

/**
 * Destroy a tunnel configuration
 * @param tunnel SephoneTunnelConfig object
 */
SEPHONE_PUBLIC void sephone_tunnel_config_destroy(SephoneTunnelConfig *tunnel);

/**
 * Add a tunnel server configuration.
 * @param tunnel SephoneTunnel object
 * @param tunnel_config SephoneTunnelConfig object
 */
SEPHONE_PUBLIC void sephone_tunnel_add_server(SephoneTunnel *tunnel, SephoneTunnelConfig *tunnel_config);

/**
 * Remove a tunnel server configuration.
 * @param tunnel SephoneTunnel object
 * @param tunnel_config SephoneTunnelConfig object
 */
SEPHONE_PUBLIC void sephone_tunnel_remove_server(SephoneTunnel *tunnel, SephoneTunnelConfig *tunnel_config);

/**
 * Get added servers
 * @param tunnel SephoneTunnel object
 * @return \mslist{SephoneTunnelConfig}
 */
SEPHONE_PUBLIC const MSList *sephone_tunnel_get_servers(const SephoneTunnel *tunnel);

/**
 * Remove all tunnel server addresses previously entered with sephone_tunnel_add_server()
 * @param tunnel SephoneTunnel object
**/
SEPHONE_PUBLIC void sephone_tunnel_clean_servers(SephoneTunnel *tunnel);

/**
 * Set the tunnel mode.
 * The tunnel mode can be 'enable', 'disable' or 'auto'
 * If the mode is set to 'auto', the tunnel manager will try to established an RTP session
 * with the tunnel server on the UdpMirrorPort. If the connection fail, the tunnel is automatically
 * activated whereas the tunnel is automatically disabled if the connection succeed.
 * @param tunnel SephoneTunnel object
 * @param mode The desired SephoneTunnelMode
**/
SEPHONE_PUBLIC void sephone_tunnel_set_mode(SephoneTunnel *tunnel, SephoneTunnelMode mode);

/**
 * Get the tunnel mode
 * @param tunnel SephoneTunnel object
 * @return The current SephoneTunnelMode
**/
SEPHONE_PUBLIC SephoneTunnelMode sephone_tunnel_get_mode(const SephoneTunnel *tunnel);

/**
 * Returns whether the tunnel is activated. If mode is set to auto, this gives indication whether the automatic detection determined
 * that tunnel was necessary or not.
 * @param tunnel the tunnel
 * @return TRUE if tunnel is in use, FALSE otherwise.
**/
SEPHONE_PUBLIC bool_t sephone_tunnel_get_activated(const SephoneTunnel *tunnel);


/**
 * Check whether the tunnel is connected
 * @param tunnel SephoneTunnel object
 * @return A boolean value telling if the tunnel is connected
**/
SEPHONE_PUBLIC bool_t sephone_tunnel_connected(const SephoneTunnel *tunnel);

/**
 * Force reconnection to the tunnel server.
 * This method is useful when the device switches from wifi to Edge/3G or vice versa. In most cases the tunnel client socket
 * won't be notified promptly that its connection is now zombie, so it is recommended to call this method that will cause
 * the lost connection to be closed and new connection to be issued.
 * @param tunnel SephoneTunnel object
**/
SEPHONE_PUBLIC void sephone_tunnel_reconnect(SephoneTunnel *tunnel);

/**
 * Set whether SIP packets must be directly sent to a UA or pass through the tunnel
 * @param tunnel SephoneTunnel object
 * @param enable If true, SIP packets shall pass through the tunnel
 */
SEPHONE_PUBLIC void sephone_tunnel_enable_sip(SephoneTunnel *tunnel, bool_t enable);

/**
 * Check whether tunnel is set to transport SIP packets
 * @param tunnel SephoneTunnel object
 * @return A boolean value telling whether SIP packets shall pass through the tunnel
 */
SEPHONE_PUBLIC bool_t sephone_tunnel_sip_enabled(const SephoneTunnel *tunnel);

/**
 * Set an optional http proxy to go through when connecting to tunnel server.
 * @param tunnel SephoneTunnel object
 * @param host http proxy host
 * @param port http proxy port
 * @param username Optional http proxy username if the proxy request authentication. Currently only basic authentication is supported. Use NULL if not needed.
 * @param passwd Optional http proxy password. Use NULL if not needed.
 **/
SEPHONE_PUBLIC void sephone_tunnel_set_http_proxy(SephoneTunnel *tunnel, const char *host, int port, const char* username,const char* passwd);

/**
 * Retrieve optional http proxy configuration previously set with sephone_tunnel_set_http_proxy().
 * @param tunnel SephoneTunnel object
 * @param host http proxy host
 * @param port http proxy port
 * @param username Optional http proxy username if the proxy request authentication. Currently only basic authentication is supported. Use NULL if not needed.
 * @param passwd Optional http proxy password. Use NULL if not needed.
 **/
SEPHONE_PUBLIC void sephone_tunnel_get_http_proxy(SephoneTunnel*tunnel,const char **host, int *port, const char **username, const char **passwd);

/**
 * Set authentication info for the http proxy
 * @param tunnel SephoneTunnel object
 * @param username User name
 * @param passwd Password
 */
SEPHONE_PUBLIC void sephone_tunnel_set_http_proxy_auth_info(SephoneTunnel*tunnel, const char* username,const char* passwd);

/**
 * Sets whether tunneling of SIP and RTP is required.
 * @param tunnel object
 * @param enabled If true enter in tunneled mode, if false exits from tunneled mode.
 * The TunnelManager takes care of refreshing SIP registration when switching on or off the tunneled mode.
 * @deprecated Replaced by sephone_tunnel_set_mode()
**/
SEPHONE_PUBLIC void sephone_tunnel_enable(SephoneTunnel *tunnel, bool_t enabled);

/**
 * Check whether tunnel is enabled
 * @param tunnel Tunnel object
 * @return Returns a boolean indicating whether tunneled operation is enabled.
 * @deprecated Replaced by sephone_tunnel_get_mode()
**/
SEPHONE_PUBLIC bool_t sephone_tunnel_enabled(const SephoneTunnel *tunnel);

/**
 * Start tunnel need detection.
 * @param  tunnel object
 * In auto detect mode, the tunnel manager try to establish a real time rtp communication with the tunnel server on  specified port.
 * <br>In case of success, the tunnel is automatically turned off. Otherwise, if no udp communication is feasible, tunnel mode is turned on.
 * <br> Call this method each time to run the auto detection algorithm
 * @deprecated Replaced by sephone_tunnel_set_mode(SephoneTunnelModeAuto)
 */
SEPHONE_PUBLIC void sephone_tunnel_auto_detect(SephoneTunnel *tunnel);

/**
 * Tell whether tunnel auto detection is enabled.
 * @param[in] tunnel SephoneTunnel object.
 * @return TRUE if auto detection is enabled, FALSE otherwise.
 * @deprecated Replaced by sephone_tunnel_get_mode()
 */
SEPHONE_PUBLIC bool_t sephone_tunnel_auto_detect_enabled(SephoneTunnel *tunnel);

/**
 * @}
**/

#ifdef __cplusplus
}
#endif


#endif //SEPHONETUNNEL_H

