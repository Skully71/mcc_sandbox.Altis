//==================================================================MCC_fnc_construction===============================================================================================
// Example:[_question, _header , _variable] call MCC_fnc_construction;
//==================================================================================================================================================================================
private ["_conType","_pos","_time","_side","_reqCrates","_vehicleType","_baseAnchor","_markerName","_markerType","_text","_complete","_newObjects","_const",
         "_bagFence","_dir"];
		 
_conType	=_this select 0;
_pos	 	=_this select 1;
_side	 	=_this select 2;
_dir	 	=call compile (_this select 3);

#define REQUIRE_MEMBERS 3
#define ANCHOR_ITEM "Land_FishingGear_01_F"
#define TIME_BEFORE_DELETE 1200

switch (_conType) do 
{
	case "fob" : 
	{
		_reqCrates = 4; 
		_vehicleType = "fob";
		_text = "FOB"
	}; 
	case "bunker" : 
	{
		_reqCrates = 2; 
		_vehicleType = "Land_BagBunker_Small_F";
		_text = "Bunker"
	}; 
	case "hmg" : 
	{
		_reqCrates = 4; 
		_vehicleType = if (_side == west) then {"B_HMG_01_F"} else {"O_HMG_01_F"}; 
		_text = "HMG"
	}; 
	case "gmg" : 
	{
		_reqCrates = 6; 
		_vehicleType = if (_side == west) then {"B_GMG_01_F"} else {"O_GMG_01_F"}; 
		_text = "GMG"
	}; 
	case "at" : 
	{
		_reqCrates = 6; 
		_vehicleType = if (_side == west) then {"B_static_AT_F"} else {"O_static_AT_F"}; 
		_text = "AT"
	}; 
	case "aa" : 
	{
		_reqCrates = 6; 
		_vehicleType = if (_side == west) then {"B_static_AA_F"} else {"O_static_AA_F"}; 
		_text = "AA"
	}; 
	case "mortar" : 
	{
		_reqCrates = 6; 
		_vehicleType = if (_side == west) then {"B_Mortar_01_F"} else {"O_Mortar_01_F"}; 
		_text = "Mortar"
	}; 
};

_bagFence = [
				[_vehicleType,[0,0,0.0237527],0.216771,1,0,{},true],
				["Land_BagFence_Long_F",[1.55859,-0.130859,-0.00100017],269.77,1,0,{}],
				["Land_BagFence_Long_F",[-2.00781,-0.216797,-0.00100017],269.77,1,0,{}],
				["Land_BagFence_Corner_F",[1.49609,-2.53125,-0.000999928],92.2384,1,0,{}],
				["Land_Mound02_8m_F",[-2.03711,1.26367,0],0,1,0,{}],
				["Land_BagFence_Corner_F",[-1.96875,-2.44336,-0.000999928],182.161,1,0,{}]
			];
			
_pos set [2,0]; 
//Create the base item
_time = time; 
_baseAnchor = ANCHOR_ITEM createVehicle _pos;
_baseAnchor setVariable ["MCC_conType",_conType,true]; 
_baseAnchor setVariable ["MCC_side",_side,true]; 


//Create marker
_markerName = format ["MCC_constractMarkerName_%1",["MCC_constractMarkerName_",1] call bis_fnc_counter];
[[[_markerName], _pos, "colorBlue", "loc_Tourism", format ["Building %1: 0/%2 crates",_text,_reqCrates],false],"BIS_fnc_markerCreate", _side,false] call BIS_fnc_MP; 

//Main loop
_complete 	= false; 
_newObjects = []; 
while {alive _baseAnchor && time < (_time + TIME_BEFORE_DELETE) && !_complete} do
{
	private ["_nearbyCrates","_nearbyMen","_prop","_propPos"]; 
	
	sleep 1; 
	
	//How many players from my side are near
	if (floor time % 10 == 0) then
	{
		_nearbyCrates = getPosATL _baseAnchor nearObjects [MCC_SUPPLY_CRATEITEM, 50];
		_nearbyMen = {alive _x && {side _x == _side}} count (getPosATL _baseAnchor nearEntities ["CAManBase", 50]);
		
		if (_nearbyMen > REQUIRE_MEMBERS && count _nearbyCrates > 0) then
		{
			_prop = _nearbyCrates select 0;
			_propPos = getposATL _prop;
			deletevehicle _prop;
			_prop = "Land_Sacks_heap_F" createvehicle _propPos;
			waituntil {!isnull _prop};
			_prop setpos _propPos;
			_newObjects set [count _newObjects, _prop];
			
			//Update marker
			[compile format ['deleteMarker "%1";',_markerName],"BIS_fnc_spawn", _side ,false] call BIS_fnc_MP; 
			sleep 1; 
			[[[_markerName], _pos, "colorBlue", "loc_Tourism", format ["Building %1: %2/%3 crates",_text, count _newObjects, _reqCrates],false],"BIS_fnc_markerCreate", _side,false] call BIS_fnc_MP; 
		};
		
		if (count _newObjects >= _reqCrates) then
		{
			_complete = true; 
		};
	};
};

sleep 5; 
//Update marker
[compile format ['deleteMarker "%1";',_markerName],"BIS_fnc_spawn", _side ,false] call BIS_fnc_MP; 

//Clear stuff
{
	deletevehicle _x;
	sleep 1;
} foreach _newObjects;

deletevehicle _baseAnchor;
sleep 0.1; 
	
//We are done - build the object
if (_complete) then
{
	if (_vehicleType != "fob") then
	{
		_const = [_pos, _dir, _bagFence] call MCC_fnc_objectMapper;
		_const setVariable ["mcc_const_name",_markerName, true]; 
		_const setVariable ["side",_side, true]; 
		
		[[[_markerName], _pos, "colorBlue", "mil_dot", _text,false],"BIS_fnc_markerCreate", _side,false] call BIS_fnc_MP; 
		
		_const addMPEventHandler ["MPKilled",{	
												private ["_obj","_mark","_flag","_side"];
												_obj = _this select 0;
												_mark = _obj getVariable ["mcc_const_name",""]; 
												_side = _obj getVariable ["side",civilian]; 
												
												[compile format ['deleteMarker "%1";',_mark],"BIS_fnc_spawn", _side ,false] call BIS_fnc_MP; 
											}];
	}
	else
	{
		[[_pos, _dir, _side ,"FOB",true,false], "CP_fnc_buildSpawnPoint", false, false] spawn BIS_fnc_MP;
	};
};			



