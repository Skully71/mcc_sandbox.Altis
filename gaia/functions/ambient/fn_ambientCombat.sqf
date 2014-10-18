/*
				***		ARMA3Alpha AMBIENT COMBAT SCRIPT v2.5 - by SPUn / lostvar	***
				
			Creates ambient combat around defined objects/units with multiple customizable features.
			
		Calling the script:
		
				default: 	nul = [] execVM "LV\ambientCombat.sqf";
				custom: 	nul = [min range, max range, min delay, max delay, groups, side ratios, center unit, AI skills, 
								communication, dissapear distance, custom init, patrol type, MP] execVM "LV\ambientCombat.sqf";
								
	Parameters:
		
		min range 			= 	number 		(meters, minimum range from center unit for AI to spawn) 			DEFAULT: 450
		max range 			= 	number 		(meters, maximum range from center unit for AI to spawn) 			DEFAULT: 900
		min delay 			= 	number 		(seconds, minimum spawning delay for AI) 							DEFAULT: 30
		max delay 			= 	number 		(seconds, maximum spawning delay for AI) 							DEFAULT: 300
		groups 				= 	number 		(how many AI groups can be alive at the same time) 					DEFAULT: 6
		side ratios			=	array		([west ratio, east ratio, ind ratio])								DEFAULT: [1,1,1]
											each ratio value is number between 0.0 - 1.0
		center unit(s) 		= 	unit/array	(unit/object/array which is center of all action) 					DEFAULT: player
		AI skills 			= 	"default" 	(default AI skills) 												DEFAULT: "default"
							or	number		(0-1.0 - this value will be set to all AI skills)
							or	array		(all AI skills invidiually in array, values 0-1.0, order:)
								[aimingAccuracy, aimingShake, aimingSpeed, spotDistance, spotTime, courage, commanding, general,
								endurance,reloadSpeed]
		communication 		= 	0/1 		(if 1, then AI groups will communicate and inform each others about enemies) DEFAULT: 0
		dissapearDistance 	= 	number 		(distance from center unit where AI units/groups will dissapear) 	DEFAULT: 2500
								NOTE: Make sure this is bigger than *maxRange !		
		custom init 		= 	"init commands" (if you want something in init field of units, put it here) 	DEFAULT: nil
								NOTE: Keep it inside quotes, and if you need quotes in init commands, you MUST 
								use ' or "" instead of ". EXAMPLE: "hint 'this is hint';"
		patrol type			=	1 or array 	(1 = doMove for each unit individually)								DEFAULT: 1
								array = ["waypointBehaviour","waypointType"] = waypoint for group 
								ex: ["AWARE","SAD"]
		MP					= 	true/false	(true = 'center unit' will automatically be an array of human		DEFAULT: false
								players and everything will be synced around them)
								
		Fully customized example:
				nul = [150,600,10,30,8,[0,1,1],player,[0.2,0.3,0.1,0.55,0.25,1,1,0.25,1,1],1,800,"hint format['spawning unit: %1',this];",
					["AWARE","SAD"],false] execVM "LV\ambientCombat.sqf";
					
*/
if (!isServer)exitWith{};
private ["_patrolType","_customInit","_communication","_eastGroups","_westGroups","_skills","_syncedUnit","_groupAmount","_grp","_minRange","_maxRange","_minTime","_maxTime","_centerPos","_range","_dir","_spawnPos","_side","_menOrVehicle","_timeDelay","_skls","_spotValid","_leftSides","_fullRatio","_perRatio","_westRatio","_eastRatio","_indeRatio","_lossRatio","_indeGroups","_sideRatios","_dissapearDistance","_waterUnitChance","_landOrAir","_mp","_tempPos","_isFlat","_d1","_m","_avoidArray"];

_minRange 				 = MCC_GAIA_AMBIENT_minRange;	 
_maxRange 			   = MCC_GAIA_AMBIENT_maxRange;	 
_minTime 					 = 3;	 
_maxTime 					 = 10;	 
_groupAmount 			 = 10;
_sideRatios 			 = [0,1,0]; 
_syncedUnit 			 = [];
_skills 					 = "default";
_communication 		 = 1;	 
_dissapearDistance = _maxRange+200;
_customInit 			 = nil;	 
_patrolType 			 = 1;	
_mp = true;



if(isNil("LV_ACS_activeGroups"))then{LV_ACS_activeGroups = [];}; 
if(isNil("LV_AI_westGroups"))then{LV_AI_westGroups = [];}; 
if(isNil("LV_AI_eastGroups"))then{LV_AI_eastGroups = [];}; 
if(isNil("LV_AI_indeGroups"))then{LV_AI_indeGroups = [];}; 

if(!(isNil("ACpatrol")))then{terminate ACpatrol;};
if(!(isNil("ACcleanUp")))then{terminate ACcleanUp;};
if(_communication == 1)then{
	if(!(isNil("ACcommunication")))then{terminate ACcommunication;};
	ACcommunication = [] spawn GAIA_fnc_AIcommunication;
};
ACcleanUp = [_syncedUnit,_dissapearDistance,_mp] spawn GAIA_fnc_ACcleanUp;
ACpatrol = [_syncedUnit,_maxRange,_patrolType,_mp] spawn GAIA_fnc_ACpatrol;

while{true}do{
	if(_maxTime == _minTime)then{
		_timeDelay = _maxTime;
	}else{
		_timeDelay = (random(_maxTime - _minTime)) + _minTime;
	};
	sleep _timeDelay;
	if(count LV_ACS_activeGroups < _groupAmount)then{
		if(count LV_ACS_activeGroups == (_groupAmount - 1))then{sleep _timeDelay;};
		
			if(_mp)then{ _syncedUnit = call GAIA_fnc_GetPlayers;};
			_spotValid = false;
			while{!_spotValid}do{
				_spotValid = true;
				if(((typeName _syncedUnit) == "ARRAY")||(_mp))then{
					_centerPos = getPos (_syncedUnit call BIS_fnc_selectRandom);
				}else{
					_centerPos = getPos _syncedUnit;
				};
				
				if(_maxRange == _minRange)then{
					_range = _maxRange;
				}else{
					_range = (random(_maxRange - _minRange)) + _minRange;
				};
				_dir = random 360;
				_spawnPos = [(_centerPos select 0) + (sin _dir) * _range, (_centerPos select 1) + (cos _dir) * _range, 0];
				
				if(surfaceIsWater _spawnPos)then{
					_isFlat = []; 	
					_d1 = 0;	
					while{count _isFlat == 0}do{ //check if there's land at _maxRange
						_tempPos = [(_centerPos select 0) + (sin _d1) * _maxRange, (_centerPos select 1) + (cos _d1) * _maxRange, 0];
						_isFlat = _tempPos isflatempty [2,0,1,2,0,false];
						_d1 = _d1 + 45;
						//hint format["%1",_isFlat];
						if(_d1 == 360)exitWith{};
					};
					if(count _isFlat > 0)then{ //if land is found, spawn most groups as land / air groups
						_waterUnitChance = floor(random 5);
						if(_waterUnitChance > 3)then{ //Water units chance 1/5
							_spawnPos = _isFlat;
							//_spawnPos = [1,_centerPos,_spawnPos,_range] call GAIA_fnc_FindLandPosition;
							//_spawnPos = [_centerPos,_minRange,_maxRange,5,0,1,0] call BIS_fnc_findSafePos;
						};
					};
				};
				if(((typeName _syncedUnit) == "ARRAY")||(_mp))then{
					{
						if((_x distance _spawnPos) < _minRange)exitWith{_spotValid = false;};
					}forEach _syncedUnit;
				};
				
				_avoidArray = [];
				for "_i" from 0 to 30 do {
					if(_i == 0)then{_m = "ACavoid";}else{_m = ("ACavoid_" + str _i);};
					if(_m in allMapMarkers)then{_avoidArray set[(count _avoidArray),_m];};
				};
				{
					if([_spawnPos,_x] call GAIA_fnc_IsInMarker)exitWith{_spotValid = false;};
				}forEach _avoidArray;
				
				
			};

		//Handle side ratios -> decide side:
		_fullRatio = (_sideRatios select 0) + (_sideRatios select 1) + (_sideRatios select 2);
		_perRatio = _groupAmount / _fullRatio;
		_westRatio = floor((_sideRatios select 0) * _perRatio);
		_eastRatio = floor((_sideRatios select 1) * _perRatio);
		_indeRatio = floor((_sideRatios select 2) * _perRatio);
		_lossRatio = _groupAmount - _westRatio - _eastRatio - _indeRatio;
				//hint format["%1",(side (LV_ACS_activeGroups select (count LV_ACS_activeGroups - 1)))];
		_westGroups = {(side _x) == west} count LV_ACS_activeGroups;
		_eastGroups = {(side _x) == east} count LV_ACS_activeGroups;
		_indeGroups = {(side _x) == resistance} count LV_ACS_activeGroups;
		//hint format["w: %1, e: %2, i: %3",_westGroups,_eastGroups,_indeGroups];
		if(_westGroups < _westRatio)then{
			_side = 0;
		}else{
			if(_eastGroups < _eastRatio)then{
				_side = 1;
			}else{
				if(_indeGroups < _indeRatio)then{
					_side = 2;
				}else{
					_leftSides = [];
					if((_sideRatios select 0) > 0)then{_leftSides set[(count _leftSides),0];};
					if((_sideRatios select 1) > 0)then{_leftSides set[(count _leftSides),1];};
					if((_sideRatios select 2) > 0)then{_leftSides set[(count _leftSides),2];};
					if(count _leftSides > 1)then{
						_side = _leftSides call BIS_fnc_selectRandom;
						{
							if(_x > _side)then{ _side = _x; };
						}forEach _leftSides;
					}else{_side = _leftSides select 0;};
					//hint format["extra group's side: %1",_side];
				};
			};
		};
			
		_menOrVehicle = floor(random 10);
		if(_menOrVehicle < 4)then{
			if(surfaceIsWater _spawnPos)then{
				_grp = [_spawnPos, _side] call GAIA_fnc_fullWaterVehicle;
			}else{
				_landOrAir = floor(random 3);
				if(_landOrAir > 1)then{
					_grp = [_spawnPos, _side] call GAIA_fnc_fullAirVehicle;
				}else{
					_grp = [_spawnPos, _side] call GAIA_fnc_fullLandVehicle;
				};
			};
		}else{
			if(surfaceIsWater _spawnPos)then{
				_grp = [_spawnPos, _side, [10,3]] call GAIA_fnc_diveGroup;
			}else{
				_grp = [_spawnPos, _side, [10,3]] call GAIA_fnc_menGroup;
			};
		};
		if(typeName _skills != "STRING")then{_skls = [_grp,_skills] call GAIA_fnc_ACskills;};
		LV_ACS_activeGroups set [(count LV_ACS_activeGroups), (group _grp)];
		
		switch(_side)do{
			case 0:{
				LV_AI_eastGroups set [(count LV_AI_eastGroups), (group _grp)];
			};
			case 1:{
				LV_AI_westGroups set [(count LV_AI_westGroups), (group _grp)];
			};
			case 2:{
				LV_AI_indeGroups set [(count LV_AI_indeGroups), (group _grp)];
			};
		};
		
		if(!isNil("_customInit"))then{ 
			{
				[_x,_customInit] spawn gaia_fnc_vehicleInit;
			} forEach units group _grp;
		};
	};
};
