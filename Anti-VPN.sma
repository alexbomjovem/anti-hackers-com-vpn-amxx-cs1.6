#include <amxmodx>
#include <amxmisc>
#include <fvault>

// BUG Contato: 061991883344 (Alex)

#define PLUGIN "Anti- Player VPN"
#define VERSION "1.1"
#define AUTHOR "alex rafael"
#define EXPIREDAYS 30

new const g_vault_name[] = "Anti-VPN"; // NÃO MEXER AQUI E O BANCO DE DADOS
new g_players_novo[33];

new g_players[33];
new g_faca, g_desativaCurWeapon

new const MenuPrefixvpn[] = "BAN Quarentena"  // coloqueo o nome do menu do seu claN
#define PREFIXCHAT "BAN Quarentena" // coloqueo o nome do menu do seu claN NO CHAT
#define isAdmin(%1)		(get_user_flags(%1) & ADMIN_CFG) // letra H


public plugin_init() 
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
    register_clcmd("say /vpn", "AdminMenuvpn")
    disable_event((g_desativaCurWeapon = register_event("CurWeapon","eCurWeapon","be","1=1")));
    fvault_prune( g_vault_name , 0 , get_systime( ) - ( 86400 * EXPIREDAYS ) )
}


public client_connect(id)
{
    static xGetAuth[64]
    get_user_authid(id, xGetAuth, charsmax(xGetAuth))

    if(equal(xGetAuth, "STEAM_", 6) )
        return PLUGIN_HANDLED;


    if(equal(xGetAuth, "VALVE_", 6) )
    {
		new szIP[6];
		get_user_ip ( id, szIP, charsmax(szIP) , 1 )

		g_players[id] = 1;
		load_data(id)

    }

    return PLUGIN_HANDLED;
}

public client_disconnected(id)
{
	static xGetAuth[64]
	get_user_authid(id, xGetAuth, charsmax(xGetAuth))

	if(equal(xGetAuth, "VALVE_", 6) )
	{
		if( g_players[id] == 0 )
		{
			g_players[id] = 1;

			if(!g_faca)
			{
				load_save(id);
				g_players[id] = 0;
				g_players_novo[id] = false
			}
			return PLUGIN_HANDLED;
		}
	}
	return PLUGIN_HANDLED;
}

public AdminMenuvpn(id)
{
	if(isAdmin(id))
	{
		static szMenu[50], szItem[32]
		formatex(szMenu, charsmax(szMenu), "\y[ \w%s \rMENU Anti-VPN CS PIRATA\y]", MenuPrefixvpn)
		new iMenu = menu_create(szMenu, "AdminMenuHandlervpn")
		
		formatex(szItem, charsmax(szItem),"- MODO QUARENTENA %s%s",g_faca ? "\y": "\r", g_faca ? "[ON]": "[OFF]")
		menu_additem(iMenu, szItem)
		formatex(szItem, charsmax(szItem),"- Liberação de Players")
		menu_additem(iMenu, szItem)

		if ( is_user_connected( id ) )
		{
			menu_display(id, iMenu)
		}
	}
	else
	{
		client_print_color( id, print_team_default, "^4[%s] ^1 Voce nao tem acesso a este comando.", PREFIXCHAT)
	}
	
	return PLUGIN_HANDLED
}

public AdminMenuHandlervpn(id, iMenu, iItem)
{
	if(iItem == MENU_EXIT)
	{
		menu_destroy(iMenu)
		return
	}
	
	static xPName[32]
	get_user_name(id, xPName, charsmax(xPName))
	
	switch(iItem)
	{
		case 0:
		{
            {
                g_faca = g_faca ? false : true
                
                if(g_faca)
                {               
					client_print_color( 0, print_team_default, "^4[%s] ^3 %s ^1 Ativou ^4Modo Quarentena  ^1no servidor.", PREFIXCHAT, xPName)
					enable_event(g_desativaCurWeapon);
                }

                else
                {
					client_print_color( 0, print_team_default, "^4[%s] ^3 %s ^1 Desativou  ^4Modo Quarentena  ^1no servidor.", PREFIXCHAT, xPName)
					disable_event(g_desativaCurWeapon);
                }
		    }

		}

		case 1:
		{
            if(g_faca)
            {   
				menuvpnlibera( id )            
            }
            else
            {
                client_print_color( id, print_team_default, "^4[%s] ^1O Modo Quarentena^1 não Esta.. ^4[^3 ATIVADO^4]^1 no servidor.", PREFIXCHAT)
            }
		}
	
	}
	menu_destroy(iMenu)
}




load_data(id)
{
    new authid[35];
    get_user_authid(id, authid, sizeof(authid) - 1);
    
    new data[16];
    if( fvault_get_data(g_vault_name, authid, data, sizeof(data) - 1) )
    {
        g_players[id]  = str_to_num(data);
    }
    else
    {
		g_players[id] = 0;
		g_players_novo[id] = true
	}
	
}

load_save(id)
{
    new authid[35];
    get_user_authid(id, authid, sizeof(authid) - 1);
    
    new data[16];
    num_to_str(g_players[id], data, sizeof(data) - 1);
    
    fvault_set_data(g_vault_name, authid, data);
}

public eCurWeapon(id)
{
	if(!is_user_alive(id))
	return
	
	if(g_faca)
	{
        static xGetAuth[64]
        get_user_authid(id , xGetAuth, charsmax(xGetAuth))
        

        if(equal(xGetAuth, "STEAM_", 6) )
        return
        
        if(g_players_novo[id])
        {
            engclient_cmd(id, "weapon_knife")
            msg_libera(id)
        }
	}

	return
}

public msg_libera(id)
{  
    client_print(id, print_center, "... Servidor Modo Defesa contra Hackers, Peça admin A liberação ...");

}

public menuvpnlibera( id )
{
new menu = menu_create( "\rMENU LIBERAÇÃO - CS Pirata NO- STEAM", "submenunative" );

new players[ 32 ], pnum, tempid;
new szName[ 32 ], szTempid[ 10 ];


get_players( players, pnum, "" );

for( new i; i< pnum; i++ )
{
tempid = players[ i ];

get_user_name( tempid, szName, 31 );
num_to_str( tempid, szTempid, 9 );
menu_additem( menu, szName, szTempid, 0 );
}

menu_display( id, menu );
return PLUGIN_HANDLED;
}


public submenunative( const id, const menu, const item )
{
    if( item == MENU_EXIT )
    {
        menu_destroy( menu );
        return PLUGIN_HANDLED;
    }

    new data[ 6 ], iName[ 64 ];
    new access, callback;
    menu_item_getinfo( menu, item, access, data,5, iName, 63, callback );

    new tempid = str_to_num( data );
    new name[ 32 ];
    get_user_name( id, name, charsmax( name ) );
         
    if(tempid )
    {
		g_players_novo[tempid] = false 
		g_players[tempid] = 1;
		load_save(tempid)
		client_print_color(0,print_team_default,"^1[^4%s^1] ^1Admin ^3%s^1 Deu A Liberação para^3 %s", PREFIXCHAT, name, iName);
    }

    menu_destroy( menu );
    return PLUGIN_HANDLED;
}
