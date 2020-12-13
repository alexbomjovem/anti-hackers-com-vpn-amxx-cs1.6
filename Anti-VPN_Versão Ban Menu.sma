#include <amxmodx>
#include <amxmisc>
#include <fvault>

// BUG Contato: 061991883344 (Alex)

// Agradecimentos Contribuição No Plugins
// AdamRichard21st = Menu so Players CS Piratas 

#define PLUGIN "Anti- Player VPN"
#define VERSION "1.3"
#define AUTHOR "alex rafael"
#define EXPIREDAYS 30

new const g_vault_name[] = "Anti-VPN"; // NÃO MEXER AQUI. É O BANCO DE DADOS
new g_players_novo[33];
new g_isNonSteam[33]; // salva se o jogador é non steam

new g_players[33];
new g_faca, g_desativaCurWeapon

new const MenuPrefixvpn[] = "BAN Quarentena"  // coloque o nome do menu do seu claN
#define PREFIXCHAT "BAN Quarentena" // coloque o nome do menu do seu claN NO CHAT
#define isAdmin(%1)		(get_user_flags(%1) & ADMIN_CFG) // letra H


public plugin_init() 
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
    register_clcmd("say /vpn", "AdminMenuvpn")
    disable_event((g_desativaCurWeapon = register_event("CurWeapon","eCurWeapon","be","1=1")));
    fvault_prune( g_vault_name , 0 , get_systime( ) - ( 86400 * EXPIREDAYS ) )
    register_clcmd("say /teste", "teste")
}

public teste(id)
{
    client_print_color( id, print_team_default, "^4 Anti-VPN")
    client_print_color( id, print_team_default, "^4 MODO ATIVADO^1  [^4%i^1]", g_faca)
    client_print_color( id, print_team_default, "^4 Players Salvos^1  [^4%i^1]", g_players[id])
    client_print_color( id, print_team_default, "^4 Players nao salvo^1  [^4%i^1]", g_players_novo[id])
    client_print_color( id, print_team_default, "^4 isNonSteam^1  [^4%i^1]", g_isNonSteam[id])
}

public client_authorized(id)
{
	new xGetAuth[64];
	get_user_authid(id, xGetAuth, charsmax(xGetAuth));

	g_isNonSteam[id] = 0;

	if(equal(xGetAuth, "STEAM_", 6) )
		return PLUGIN_HANDLED;

	if(equal(xGetAuth, "VALVE_", 6) )
	{
		new szIP[6];
		get_user_ip( id, szIP, charsmax(szIP), 1 );

		g_players[id] = 1;
		load_data(id);

		// salva se o jogador é non steam para não
		// precisar verificar o id novamente
		g_isNonSteam[id] = 1;
	}

	return PLUGIN_HANDLED;
}

public client_disconnected(id)
{
	static xGetAuth[64]
	get_user_authid(id, xGetAuth, charsmax(xGetAuth))

	if(g_isNonSteam[id])
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
		new szMenu[50], szItem[32]
		formatex(szMenu, charsmax(szMenu), "\y[ \w%s \rMENU Anti-VPN CS PIRATA\y]", MenuPrefixvpn)
		new iMenu = menu_create(szMenu, "AdminMenuHandlervpn")
		
		formatex(szItem, charsmax(szItem),"- MODO QUARENTENA %s%s",g_faca ? "\y": "\r", g_faca ? "[ON]": "[OFF]")
		menu_additem(iMenu, szItem)
		formatex(szItem, charsmax(szItem),"- Liberação de Players")
		menu_additem(iMenu, szItem)
		formatex(szItem, charsmax(szItem),"- BAN \r[\dID\r]\w/\r[\dIP\r]")
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
		return PLUGIN_CONTINUE;
	}
	
	
	switch(iItem)
	{
		case 0:
		{
			new xPName[32]
			get_user_name(id, xPName, charsmax(xPName))

			g_faca = g_faca ? false : true
			
			if(g_faca)
			{        
				client_print_color( 0, print_team_default, "^4[%s] ^3 %s ^1 Ativou ^4Modo Quarentena ^1no servidor.", PREFIXCHAT, xPName)
				enable_event(g_desativaCurWeapon);
			}

			else
			{
				client_print_color( 0, print_team_default, "^4[%s] ^3 %s ^1 Desativou  ^4Modo Quarentena ^1no servidor.", PREFIXCHAT, xPName)
				disable_event(g_desativaCurWeapon);
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

		case 2:
		{
			menuvpnban( id )           
		}
	
	}
	menu_destroy(iMenu)

	return PLUGIN_HANDLED
}




load_data(id)
{
    new authid[35];
    get_user_authid(id, authid, charsmax(authid));
    
    new data[16];
    if( fvault_get_data(g_vault_name, authid, data, charsmax(data)) )
    {
        g_players[id] = str_to_num(data);
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
    get_user_authid(id, authid, charsmax(authid));
    
    new data[16];
    num_to_str(g_players[id], data, charsmax(data));
    
    fvault_set_data(g_vault_name, authid, data);
}

public eCurWeapon(id)
{
	if(!is_user_alive(id))
		return
	
	if(g_faca)
	{
        if(g_isNonSteam[id] && g_players_novo[id])
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
    new menu = menu_create("\rMENU LIBERAÇÃO - CS Pirata NO- STEAM", "_handler");

    new players[ 32 ];
    new num;
    get_players(players, num, "ch");


    for (new i = 0; i < num; i++)
    {
        new authid[ 64 ];
        new player = players[i];
        new name[ 32 ];

        get_user_authid(player, authid, charsmax(authid));
        get_user_name(player, name, charsmax( name) );

        if ( !equal(authid, "STEAM_", 6) )
        {
            menu_additem(menu, name, authid);
        }
    }


    if ( !menu_items(menu) )
    {
        menu_addtext2(menu, "Nenhum non-steam conectado");
    }

    menu_display(id, menu);
}

public _handler( id, menu, item )
{
    if ( item == MENU_EXIT )
    {
        menu_destroy(menu);

        return PLUGIN_HANDLED;
    }

    new authid[ 64 ];
    new name[ 32 ];

    new result = menu_item_getinfo(menu, item, _, authid, charsmax(authid), name, charsmax(name));

    menu_destroy(menu);

    if ( !result )
    {
        client_print(id, print_chat, "Erro interno, por favor, tente mais tarde");

        return PLUGIN_HANDLED;
    }

    new player = find_player("c", authid);

    if ( player )
    {
		new iname[ 32 ];
		get_user_name( id, iname, charsmax( iname) );
		g_players_novo[player] = false 
		g_players[player] = 1;
		load_save(player)
		client_print_color(0,print_team_default,"^1[^4%s^1] ^1Admin ^3%s^1 Deu A Liberação para^3 %s", PREFIXCHAT, iname, name);
    }
    else
    {
        client_print(id, print_chat, "O jogador %s<%s> já não está mais conectado", name, authid);
    }

    return PLUGIN_HANDLED;
}


public menuvpnban( id )
{
    new menu = menu_create("\rBAN VPN - NO- STEAM", "_handlerban");

    new players[ 32 ];
    new num;
    get_players(players, num, "ch");
    


    for (new i = 0; i < num; i++)
    {
        new authid[ 64 ];
        new player = players[i];
        new name[ 32 ];

        get_user_authid(player, authid, charsmax(authid));
        get_user_name(player, name, charsmax( name) );

        if ( !equal(authid, "STEAM_", 6) )
        {
            menu_additem(menu, name, authid);
        }
    }


    if ( !menu_items(menu) )
    {
        menu_addtext2(menu, "Nenhum non-steam conectado");
    }

    menu_display(id, menu);
}

public _handlerban( id, menu, item )
{
    if ( item == MENU_EXIT )
    {
        menu_destroy(menu);

        return PLUGIN_HANDLED;
    }

    new authid[ 64 ];
    new name[ 32 ];

    new result = menu_item_getinfo(menu, item, _, authid, charsmax(authid), name, charsmax(name));

    menu_destroy(menu);

    if ( !result )
    {
        client_print(id, print_chat, "Erro interno, por favor, tente novamente..");

        return PLUGIN_HANDLED;
    }

    new player = find_player("c", authid);

    if ( player )
    {
		new iname[ 32 ]; 
		get_user_name( id, iname, charsmax( iname) );
		
		server_cmd("amx_banip ^"%s^"^"0^"^"Ban Anti-VPNt ^"", name) //BAN IP
		server_cmd("amx_addban ^"%s^"^"0^"^"Ban Anti-VPN ^"", authid ) // add BAN ID
		server_cmd("amx_ban ^"%s^"^"2^"^"Ban Anti-VPN ^"", authid ) // BAN ID
		log_to_file("ban_Anti-VPN.txt","Admin <%s> BAN <%s> authid <%s>", iname, name, authid);
    }
    else
    {
        client_print(id, print_chat, "O jogador %s<%s> já não está mais conectado", name, authid);
    }

    return PLUGIN_HANDLED;
}
