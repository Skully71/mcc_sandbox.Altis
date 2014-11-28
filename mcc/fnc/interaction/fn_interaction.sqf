//==================================================================MCC_fnc_interaction===============================================================================================
// Interaction perent
//=================================================================================================================================================================================
private ["_targets","_null","_selected","_objects","_dir","_target","_vehiclePlayer","_airports","_counter","_searchArray","_sides",
		 "_positionStart","_positionEnd","_pointIntersect","_break","_interactiveObjects","_objArray","_keyName","_key","_text"];
#define MCC_barrels ["garbagebarrel","garbagebin","toiletbox","garbagecontainer","fieldtoilet","tabledesk","cashdesk"]
#define MCC_grave ["grave_forest","grave_dirt","grave_rocks"]
#define MCC_containers ["barreltrash","metalbarrel_f","cratesplastic","cargo20","cargo40","crates"]
#define MCC_food ["icebox","rack","shelves","sacks_goods","basket","sack_f"]
//#define MCC_water ["water_source"]
#define MCC_fuel ["watertank","waterbarrel","barrelwater","stallwater"]
#define MCC_plantsFruit ["neriumo","ficusc"]
#define MCC_misc ["fishinggear","crabcages","rowboat","calvary","pipes_small","woodpile","pallets_stack","wheelcart"]
#define MCC_garbage ["garbagebags","junkpile","garbagepallet","tyres","garbagewashingmachine","scrapheap"]
#define MCC_wreck ["wreck_car","wreck_truck","wreck_offroad","wreck_van"]
#define MCC_wreckMil ["wreck_ural","wreck_uaz","wreck_hmmwv","wreck_heli","wreck_hunter","wreck_brdm","wreck_bmp","wreck_t72_hull","wreck_slammer"]
#define MCC_wreckSub ["uwreck"]
#define MCC_ammoBox ["woodenbox","luggageheap","pallet_milboxes_f"]

disableSerialization;
_break = false; 

//Find out the key
_key = MCC_keyBinds select 4;
_text = "";
if (_key select 0) then {_text = "Shift + "}; 
if (_key select 1) then {_text = _text + "Ctrl + "}; 
if (_key select 2) then {_text = _text + "Alt + "}; 
_keyName = format ["%1%2",_text, keyName (_key select 3)];

//Do not fire while inside a dialog 
if (dialog) exitWith {}; 
sleep 0.3;
MCC_interactionKey_holding =  if (MCC_interactionKey_down) then {true} else {false};
//Fails safe if ui get stuck
if (time > (player getVariable ["MCC_interactionActiveTime",time-5])+20) then {player setVariable ["MCC_interactionActive",false]};

//If we are busy quit
if ((player getVariable ["MCC_interactionActive",false]) || (time < (player getVariable ["MCC_interactionActiveTime",time-5])+1)) exitWith {};
player setVariable ["MCC_interactionActive",true];   
player setVariable ["MCC_interactionActiveTime",time];

//Outside of vehicle
if (vehicle player == player) then
{
	_target = cursorTarget;
	player reveal _target;
	
	if (_target isKindof "weaponHolderSimulated") then
	{
		{
			if (_x distance _target < 2) exitWith {_target = _x}; 
		} foreach allDeadMen;
	};
	
	//Handle house
	if ((_target isKindof "house" || _target isKindof "AllVehicles" || _target isKindof "ReammoBox_F") && !(_target isKindof "CAManBase")) exitWith
	{
		//[_target] execvm "mcc\fnc\interaction\fn_interactDoor.sqf";
		_null= [_target] call MCC_fnc_interactDoor
	};
	
	//Handle supply crate
	if (typeof _target in ["MCC_ammoBox"]) exitWith
	{
		//[_target] execvm "mcc\fnc\interaction\fn_interactUtility.sqf";
		_null= [_target] call MCC_fnc_interactUtility
	};
	
	//Handle man
	if (_target isKindof "CAManBase" && (player distance _target < 30)) exitWith
	{
		_null= [_target, player,_keyName] call MCC_fnc_interactMan;
		//_null= [_target,player,_keyName] execvm "mcc\fnc\interaction\fn_interactMan.sqf";
		player setVariable ["MCC_interactionActive",false];  
		_break = true;
	};
	
	if (_break) exitWith {}; 
	
	_objects = player nearObjects [MCC_dummy,10];
	
	//Handle IED
	if (count _objects > 0) then
	{
		_selected = ([_objects,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy) select 0;
		_dir	  = [player, _selected] call BIS_fnc_relativeDirTo;
		if (_dir>340 || _dir < 20) exitWith 
		{
			//IED
			if (((_selected getVariable ["MCC_IEDtype",""]) == "ied") && !(_selected getVariable ["MCC_isInteracted",false])) then
			{
				_null= [player,_selected] call MCC_fnc_interactIED;
				//_null= [player,_selected] execvm "mcc\fnc\interaction\fn_interactIED.sqf";
				_break = true; 
			};
		};
	};
	
	if (_break) exitWith {}; 
	
	//Not MCC object
	_positionStart 	= eyePos player;
	_positionEnd 	= ATLtoASL screenToWorld [0.5,0.5];
	_pointIntersect = lineIntersectsWith [_positionStart, _positionEnd, player, objNull, true];
	if (count _pointIntersect > 0 && MCC_surviveMod && MCC_iniDBenabled) then
	{
		_selected = _pointIntersect select ((count _pointIntersect)-1);
		if (player distance _selected < 5) exitWith
		{
			_objArray = MCC_barrels + MCC_grave + MCC_containers + MCC_food + MCC_fuel + MCC_misc + MCC_plantsFruit + MCC_garbage + MCC_wreck + MCC_wreckMil + MCC_wreckSub + MCC_ammoBox;
			if ((({[_x , str _selected] call BIS_fnc_inString} count _objArray)>0) && (isNull attachedTo _selected)) exitWith
			{
				missionNameSpace setVariable ["MCC_interactionObjects", [[getpos _selected, format ["Hold %1 to search",_keyName]]]];
				//_null= [_selected] execvm "mcc\fnc\interaction\fn_interactObject.sqf";
				//[_selected] call MCC_fnc_interactObject;
				_break = true;
			};
		};
	};
	
	if (_break) exitWith {}; 
}
else
{
	MCC_fnc_vehicleCargoMenuClicked = 
	{
		private ["_ctrl","_index","_ctrlData","_object","_animation","_phase","_door","_locked"];
		disableSerialization;

		_ctrl 		= _this select 0;
		_index 		= _this select 1;
		_ctrlData	= _ctrl lbdata _index;
		_object		= vehicle player;
		
		closeDialog 0; 
		switch (true) do
		{
			case (_ctrlData in ["commander","driver"]) : {player action [format ["moveTo%1",_ctrlData], _object]};
			case (_ctrlData == "cargo") : {player action ["MoveToCargo", _object, (_object emptyPositions "cargo")-1]};
			case (_ctrlData == "load") : {[player] call MCC_fnc_loadTruckUI};
			case (_ctrlData == "dropOff") : {[] call MCC_fnc_requestDropOff};
			case (["gunner",_ctrlData] call BIS_fnc_inString) : 
			{
				call compile format ["player action ['MoveToTurret',vehicle player,%1]",([_ctrlData,"[01234567890]"] call BIS_fnc_filterString)];
			};
			case (["ils" , _ctrlData] call BIS_fnc_inString) : 
			{
				//find the right runway from the data we gave - we have to filter it
				((player getVariable ["interactWith",[]]) select call compile ([_ctrlData,"1234567890"] call BIS_fnc_filterString)) call MCC_fnc_ilsChilds;
			};
			case (_ctrlData == "abort") : {player setVariable ["MCC_ILSAbort",true]};
			case (_ctrlData == "reel") : {_object call MCC_fnc_attachPod};
			case (_ctrlData == "releasepod") : {_object call MCC_fnc_releasePod};
		};
	};
	
	_vehiclePlayer = vehicle player;
	_array 			= [];
	_displayName 	= getText (configfile >> "CfgVehicles" >> typeof _vehiclePlayer >> "displayName"); 
	_pic		 	= getText (configfile >> "CfgVehicles" >> typeof _vehiclePlayer >> "picture"); 
	
	//Generic Vehicle action
	_cargoUnits 	= assignedCargo _vehiclePlayer;
	_gunnerUnits 	= [gunner _vehiclePlayer];
	_driverUnits 	= [driver _vehiclePlayer];
	_commanderUnits = [commander _vehiclePlayer];
	{
		if ((((_vehiclePlayer emptyPositions _x)>0) ||
			(((_vehiclePlayer emptyPositions _x)==0) && (({!isPlayer _x && !isnull _x} count call compile format ["_%1Units",_x])>=1)))  &&
		    ((vectorUp _vehiclePlayer) select 2) >0 && 
			locked _vehiclePlayer <2) then 
			{
				_locked = switch (_x) do
							{
								case "driver": {if (lockedDriver _vehiclePlayer) then {true} else {false}};
								default {false};
							};
				_array set [count _array, [_x,format ["Move to %1 sit",if (_vehiclePlayer isKindof "air" && _x == "driver") then {"pilot"} else {_x}],format ["\A3\ui_f\data\igui\cfg\actions\getin%1_ca.paa",_x]]];
			};
	} foreach ["commander","driver","cargo"]; 
	
	//turrets
	private ["_i","_entry","_turrets","_path","_count"];
	_entry = configFile >> "CfgVehicles" >> typeof _vehiclePlayer;
	_turrets = [_entry >> "turrets"] call BIS_fnc_returnVehicleTurrets;	
	_path = [];
	_i = 0;
	_count 	= 0;
	while {_i < (count _turrets)} do
	{
		private ["_turretIndex", "_thisTurret","_unit"];
		_turretIndex 	= _turrets select _i;
		_thisTurret 	= _path + [_turretIndex];
		_unit 			= _vehiclePlayer turretUnit _thisTurret;
		
		if ((isNull _unit || (!isNull _unit && !isPlayer _unit)) && !(_vehiclePlayer lockedTurret _thisTurret) && (locked _vehiclePlayer <2)) then 
		{
			_array set [count _array, [format ["gunner%1",_thisTurret],format ["Move to %1",configName ((_entry >> "turrets") select _count)],"\A3\ui_f\data\igui\cfg\actions\getingunner_ca.paa"]];
		};
		_i = _i + 2;
		_count = _count + 1;
	};

	//dropOff
	if ((player in (assignedCargo  _vehiclePlayer)) && (player == leader player) && !isnull driver _vehiclePlayer  && locked _vehiclePlayer <2) then
	{
		_array set [count _array,["dropOff","Request Drop-off",_pic]];
	};
	
	//Logistics
	if ((typeof _vehiclePlayer in MCC_supplyTracks || (_vehiclePlayer isKindOf "helicopter" && ((getpos _vehiclePlayer) select 2) > 15)) && (player == driver _vehiclePlayer) && (speed _vehiclePlayer < 10) && MCC_allowlogistics) then
	{
		_array set [count _array,["load","Logistics",_pic]];
	};
	
	//MCC ILS
	if ((_vehiclePlayer isKindOf "Plane") && (player == Driver _vehiclePlayer)) then
	{
		_airports = []; 
		_counter = 0;
		_searchArray = if (MCC_isMode) then {allMissionObjects "mcc_sandbox_moduleILS"} else {allMissionObjects "logic"}; 

		{
			_sides = _x getVariable ["MCC_runwaySide",-1];
			_sides = if (_sides == -1) then {[east,west,resistance,civilian]} else {[_sides call bis_fnc_sideType]}; 
			
			if (((_x getVariable ["MCC_runwayDis",0])>0) && (playerside in _sides)) then
			{
				_airports set [_counter,[_x,(_x getVariable ["MCC_runwayName","Runway"]),(_x getVariable ["MCC_runwayDis",0]),(_x getVariable ["MCC_runwayAG",false]),(_x getVariable ["MCC_runwayCircles",true])]]; 
				_counter = _counter +1;
			};
		} foreach _searchArray;

		if (player getVariable ["MCC_ILSAbort",true]) then
		{
			{
				_array set [count _array,[format ["ils_%1",_foreachIndex],format ["Land %1",_x select 1],_pic]];
			} foreach _airports;
		}
		else
		{
			_array set [count _array,["abort","Abort ILS",_pic]];
		};
		
		player setVariable ["interactWith",_airports];
	};
	
	//Taru pods
	if ((_vehiclePlayer isKindOf "O_Heli_Transport_04_F") && (player == Driver _vehiclePlayer)&& isnull(_vehiclePlayer getVariable ["MCC_attachedPod",objnull])) then
	{
		_attachedCargo = (ropeAttachedObjects _vehiclePlayer) select 0;
		if (!isnil "_attachedCargo") then
		{
			if (_attachedCargo isKindOf "Pod_Heli_Transport_04_base_F") then
			{
				_array set [count _array,["reel",format ["Reel in %1",getText (configfile >> "CfgVehicles" >> typeof _attachedCargo >> "displayName")],_pic]];
			};
		};
	};
	
	//Taru pods
	if ((_vehiclePlayer isKindOf "O_Heli_Transport_04_F") && (player == Driver _vehiclePlayer) && !isnull(_vehiclePlayer getVariable ["MCC_attachedPod",objnull])) then
	{
			_array set [count _array,["releasepod",format ["Drop %1",getText (configfile >> "CfgVehicles" >> typeof (_vehiclePlayer getVariable ["MCC_attachedPod",objnull]) >> "displayName")],_pic]];
	};
	
	_array set [count _array,["close","Exit Menu","\A3\ui_f\data\map\markers\handdrawn\pickup_CA.paa"]];
	_ok = createDialog "MCC_INTERACTION_MENU";
	waituntil {dialog};

	_ctrl = ((uiNameSpace getVariable "MCC_INTERACTION_MENU") displayCtrl 0);
	_ctrl ctrlSetPosition [0.4,0.4,0.2 * safezoneW, 0.025* count _array* safezoneH];	
	_ctrl ctrlCommit 0;
	
	_ctrl ctrlRemoveAllEventHandlers "LBSelChanged";

	lbClear _ctrl;
	{
		_class			= _x select 0;
		_displayname 	= _x select 1;
		_pic 			= _x select 2;
		_index 			= _ctrl lbAdd _displayname;
		_ctrl lbSetPicture [_index, _pic];
		_ctrl lbSetData [_index, _class];
	} foreach _array;
	_ctrl lbSetCurSel 0;
	
	_ctrl ctrlAddEventHandler ["LBSelChanged","_this spawn MCC_fnc_vehicleCargoMenuClicked"];
	waituntil {!dialog};

};
if !(_break) then
{
	player setVariable ["MCC_interactionActive",false]; 
};