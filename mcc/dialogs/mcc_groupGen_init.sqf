private ["_mccdialog","_comboBox","_displayname","_pic", "_index", "_array", "_class"];
// By: Shay_gman
// Version: 1.1 (April 2012)
#define groupGen_IDD 2994
#define MCC_MINIMAP 9000

#define MCC_FACTION 8008
#define UNIT_TYPE 3010
#define UNIT_CLASS 3011
#define MCC_GGUNIT_TYPE 3012
#define MCC_GGUNIT_BEHAVIOR 3030
#define MCC_GroupGenCurrentGroup_IDD 9003
	
#define MCC_GroupGenInfoText_IDC 9013
#define MCC_GroupGenWPBckgr_IDC 9014
#define MCC_GroupGenWPCombo_IDC 9015
#define MCC_GroupGenWPformationCombo_IDC 9016
#define MCC_GroupGenWPspeedCombo_IDC 9017
#define MCC_GroupGenWPbehaviorCombo_IDC 9018
#define MCC_GroupGenWPAdd_IDC 9019
#define MCC_GroupGenWPReplace_IDC 9020
#define MCC_GroupGenWPClear_IDC 9021

#define MCC_GGListBoxIDC 3013
#define MCC_GGADDIDC 3014
#define MCC_GGCLEARIDC 3015
#define MCC_GGUNIT_EMPTY 3016
#define MCC_GGUNIT_EMPTYTITLE 3017
#define mcc_groupGen_CurrentgroupNameTittle_IDC 3018
#define mcc_groupGen_CurrentgroupNameText_IDC 3019
#define MCC_GGSAVE_GROUPIDC 3020


disableSerialization;

ctrlShow [MCC_GroupGenInfoText_IDC,false];
ctrlShow [MCC_GroupGenWPBckgr_IDC,false];
ctrlShow [MCC_GroupGenWPCombo_IDC,false];
ctrlShow [MCC_GroupGenWPformationCombo_IDC,false];
ctrlShow [MCC_GroupGenWPspeedCombo_IDC,false];
ctrlShow [MCC_GroupGenWPbehaviorCombo_IDC,false];
ctrlShow [MCC_GroupGenWPAdd_IDC,false];
ctrlShow [MCC_GroupGenWPReplace_IDC,false];
ctrlShow [MCC_GroupGenWPClear_IDC,false];

_mccdialog = findDisplay groupGen_IDD;
MCC_groupGenCurrenGroupArray = []; 		//Reset the current group
_comboBox = _mccdialog displayCtrl MCC_FACTION; //fill combobox CFG factions
lbClear _comboBox;
	{
		_displayname = format ["%1(%2)",_x select 0,_x select 1];
		_comboBox lbAdd _displayname;
	} foreach U_FACTIONS;
_comboBox lbSetCurSel MCC_faction_index;

_comboBox = _mccdialog displayCtrl UNIT_TYPE;		//fill combobox CFG unit
lbClear _comboBox;
{
	_displayname =  _x;
	_index = _comboBox lbAdd _displayname;
} foreach ["Infantry", "Vehicles", "Tracked", "Motorcycle", "Helicopter", "Fixed-wing", "Ship"];
_comboBox lbSetCurSel MCC_class_index;

_comboBox = _mccdialog displayCtrl MCC_GGUNIT_TYPE;		
lbClear _comboBox;
{
	_displayname =  _x;
	_index = _comboBox lbAdd _displayname;
} foreach ["Units", "Groups"];
_comboBox lbSetCurSel 0;

_comboBox = _mccdialog displayCtrl MCC_GGUNIT_BEHAVIOR;		
lbClear _comboBox;
{
	_displayname = format ["%1",_x select 0];
	_index = _comboBox lbAdd _displayname;
} foreach MCC_spawn_behavior;
_comboBox lbSetCurSel MCC_behavior_index;

_comboBox = _mccdialog displayCtrl MCC_GGUNIT_EMPTY;		
lbClear _comboBox;
{
	_displayname = format ["%1",_x select 0];
	_comboBox lbAdd _displayname;
} foreach MCC_spawn_empty;
_comboBox lbSetCurSel MCC_empty_index;
//----------------------------------------------------------- GROUPs ----------------------------------------------------------------------------
	
[] call MCC_fnc_groupGenRefresh; 	