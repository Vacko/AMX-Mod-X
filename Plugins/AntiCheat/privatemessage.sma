#include <amxmodx>
#include <amxmisc>

#define PLUGIN "Private Message"
#define VERSION "2.0"
#define AUTHOR "Vacko"
#define ADMIN_CHECK ADMIN_KICK

new maxplayers

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR);
	register_clcmd("amx_pmessage", "send_message", 0, "<player> <message> - user sends a message to another user.");
	register_clcmd("amx_amessage", "send_admin_message", 0, "<message> - leave a message for the admin.");	
    maxplayers = get_maxplayers()
}


public send_message(id, level, cid) 
{	
	if (!cmd_access(id, level, cid, 3))
		return PLUGIN_HANDLED
	
	new user[32], uid
	read_argv(1, user, 31)
	new message[256]
	read_argv(2, message, 255);
	new sendername[32]
	get_user_name(id, sendername, 31)
	uid = find_player("bhl", user)
	new name[32];
	get_user_name(uid, name, 31)
	
	if (uid == 0) 
        { 
	    console_print(id, "[AMXX] Sorry, unable to find player with that name.")
	    return PLUGIN_HANDLED;
	}
	
	if(!is_user_alive(id)) 
        { 
	    client_print(id,print_chat,"[AMXX] Can't send PMs while dead!")
	    return PLUGIN_HANDLED;
	}
	
	new basedir[64]
	get_basedir(basedir, 63)
	
	new LOG_FILE[164];
	format(LOG_FILE, 163, "%s/logs/pms.log", basedir)
	
	new log[256]
	format(log,255,"Message from %s to %s: %s",sendername,name,message)
	write_file(LOG_FILE,log)
	
	console_print(id,  "[AMXX] Message sent to %s!", name)
	console_print(uid, "** [AMXX] You've recieved a message from %s! **", sendername)
	
	client_print(uid, print_chat, "** Message from %s: %s **", sendername, message)
	
	return PLUGIN_HANDLED
}


public send_admin_message(id, level, cid) 
{	
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED
	
	new adminnames[33][32]
	new idm, count, x, xid
	
	new total[256]
	read_args(total, 255)
	remove_quotes(total)
	new left[92],right[92]
	strtok(total,left,91,right,91)	
	
	new basedir[64]
	get_basedir(basedir, 63)
	
	new sendername[32], sendersteam[32]
	get_user_name(id, sendername, 31)
	get_user_authid(id, sendersteam ,31)
	
	for(idm = 1 ; idm <= maxplayers ; idm++)
		if(is_user_connected(idm))
			if(get_user_flags(idm) & ADMIN_CHECK)
				get_user_name(idm, adminnames[count++], 31)	
			
	if(count > 0) 
        {
	    for(x = 0 ; x < count ; x++) 
            {
		get_user_name(xid, adminnames[x], 31)
			
                if (!id == xid) 
		{ 
                   client_print(xid, print_chat, "** Message from %s: %s **", sendername, left)
		   return PLUGIN_HANDLED;
	        }				
	    }

	}
        else
        {
	   new LOG_FILE[164]
	   format(LOG_FILE, 163, "%s/logs/admins_offline.log", basedir)
	   new log[256];
	   format(log,255,"Message from %s(%s): %s",sendername,sendersteam,left)
	   write_file(LOG_FILE,log);
        }

	return PLUGIN_HANDLED
}
	