#define MCCSTARTWEST 1015
#define MCCSTARTEAST 1016
#define MCCSTARTGUAR 1017
#define MCCSTARTCIV 1018
#define MCCENABLECP 1027

private ["_side","_null"];

_side = _this select 0;

if (mcc_missionmaker == (name player)) then {
	if !mcc_isloading then 
		{
			switch (_side) do
				{
					case 0:	//West
					{ 
						hint "click on map where you want your start location"; 
						onMapSingleClick "	
								MCC_START_WEST  = _pos;
								publicVariable ""MCC_START_WEST"";
								[[_pos, 0, 'west','HQ',false], 'CP_fnc_buildSpawnPoint', false, false] spawn BIS_fnc_MP;
								onMapSingleClick """";
								mcc_safe=mcc_safe + FORMAT [""
															MCC_START_WEST  = %1;
															publicVariable 'MCC_START_WEST';
															[[MCC_START_WEST, 0, 'west','HQ',false], 'CP_fnc_buildSpawnPoint', false, false] spawn BIS_fnc_MP;
															""							  
															,MCC_START_WEST
															];
								hint ""Start WEST location updated.""
							";
						 ctrlEnable [MCCSTARTWEST,false];
						 MCC_enable_west=false; 
					};
					
					case 1:	//East
					{ 
						hint "click on map where you want your start location"; 
						onMapSingleClick "	
								MCC_START_EAST  = _pos;
								publicVariable ""MCC_START_EAST"";
								[[_pos, 0, 'east','HQ',false], 'CP_fnc_buildSpawnPoint', false, false] spawn BIS_fnc_MP;
								onMapSingleClick """";
								mcc_safe=mcc_safe + FORMAT [""
															MCC_START_EAST  = %1;
															publicVariable 'MCC_START_EAST';
															[[_pos, 0, 'east','HQ',false], 'CP_fnc_buildSpawnPoint', false, false] spawn BIS_fnc_MP;
															""							  
															,MCC_START_EAST
															];
								hint ""Start East location updated.""
							";
						 ctrlEnable [MCCSTARTEAST,false];
						 MCC_enable_east=false; 
					};
					
					case 2:	//Guer
					{ 
						hint "click on map where you want your start location"; 
						onMapSingleClick "	
								MCC_START_GUER  = _pos;
								publicVariable ""MCC_START_GUER"";
								[[_pos, 0, 'GUAR','HQ',false], 'CP_fnc_buildSpawnPoint', false, false] spawn BIS_fnc_MP;
								onMapSingleClick """";
								mcc_safe=mcc_safe + FORMAT [""
															MCC_START_GUER  = %1;
															publicVariable 'MCC_START_GUER';
															[[_pos, 0, 'GUAR','HQ',false], 'CP_fnc_buildSpawnPoint', false, false] spawn BIS_fnc_MP;
															""							  
															,MCC_START_GUER
															];
								hint ""Start Guer location updated.""
							";
						 ctrlEnable [MCCSTARTGUAR,false];
						 MCC_enable_gue=false; 
					};
					
					case 3:	//Civ
					{ 
						hint "click on map where you want your start location"; 
						onMapSingleClick "	
								MCC_START_CIV  = _pos;
								publicVariable ""MCC_START_CIV"";
								onMapSingleClick """";
								mcc_safe=mcc_safe + FORMAT [""
															MCC_START_CIV  = %1;
															publicVariable 'MCC_START_GUER';
															""							  
															,MCC_START_CIV
															];
								hint ""Start Guer location updated.""
							";
						 ctrlEnable [MCCSTARTCIV,false];
						 MCC_enable_gue=false; 
					};
					
					case 4:	//Disable respawn
					{ 
						MCC_TRAINING = FALSE;
						publicVariable "MCC_TRAINING";
						[["Mission started, respawn is off"],'MCC_fnc_globalHint',true,true] spawn BIS_fnc_MP;
						MCC_enable_respawn=false;
					};
					
					case 5:	//Start on LHD
					{ 
						if (MCCLHDSpawned) then {
							_pos = deck modelToWorld [0,0,0];
							MCC_START_GUER  = _pos;
							MCC_START_EAST  = _pos;
							MCC_START_WEST  = _pos;
							MCC_START_LHD	= _pos; 
							publicVariable "MCC_START_GUER";
							publicVariable "MCC_START_WEST";
							publicVariable "MCC_START_EAST";
							publicVariable "MCC_START_LHD";
							mcc_safe=mcc_safe + FORMAT ["
														MCC_START_GUER  = %1;
														MCC_START_EAST  = %2;
														MCC_START_WEST  = %3;
														publicVariable 'MCC_START_GUER';
														publicVariable 'MCC_START_WEST';
														publicVariable 'MCC_START_EAST';
														"							  
														,MCC_START_GUER
														,MCC_START_EAST
														,MCC_START_WEST
														];
							hint "Start location updated.";
							ctrlEnable [START_GUE,false];
							ctrlEnable [START_EAST,false];
							ctrlEnable [START_WEST,false];
							ctrlEnable [START_LHD,false];
							MCC_enable_gue=false; 
							MCC_enable_east=false;
							MCC_enable_west=false; 	
							MCC_enable_LHD=false;						
						} else {hint "Spawn a LHD first"}; 
					};
					
					case 6:	//Enable CP
					{ 
						CP_activated = true;
						publicVariable "CP_activated";
						ctrlEnable [MCCENABLECP,false];
					};
				};
			closeDialog 0;
			_null = [] execVM MCC_path + "mcc\dialogs\mcc_PopupMenu.sqf";
		};
} else {player globalchat "Access Denied"};
		


