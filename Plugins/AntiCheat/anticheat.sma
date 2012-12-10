#include <amxmodx>
#include <amxmisc>

#define PLUGIN "AntiCheat"    
#define VERSION "2.0"
#define AUTHOR "Vacko"


public plugin_init()
{
   register_plugin(PLUGIN, VERSION, AUTHOR)
}
public client_connect(id)
{
   //client_print(id, print_chat,"Server is using Anticheat by Vacko"); 
   client_cmd(id, "bind F12 ^"amx_amessage F12^"");
   client_cmd(id, "bind F11 ^"amx_amessage F11^"");  
   client_cmd(id, "bind DEL ^"amx_amessage DEL^"");
   client_cmd(id, "bind END ^"amx_amessage END^"");
}