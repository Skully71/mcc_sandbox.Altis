//---------------------------------------------------------------------------------------------------------------------------------------------------------
//											AT
//---------------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------Primary----------------------------------------------------------------

//West 
CP_ATWeaponWest = ["SERVER_AT", "primary", "CP_ATWeaponWest", "ARRAY"] call iniDB_read;
if (count CP_ATWeaponWest == 0) then
{		
	CP_ATWeaponWest 	= call compileFinal str	[
							[0,"arifle_TRG20_F",["30Rnd_556x45_Stanag",9]],
							[10,"arifle_Mk20C_F",["30Rnd_556x45_Stanag",9]],
							[20,"arifle_MXC_F",["30Rnd_65x39_caseless_mag",9]]
						   ]; 
	["SERVER_AT", "primary", "CP_ATWeaponWest",CP_ATWeaponWest, "ARRAY"] call iniDB_write;
};
publicvariable "CP_ATWeaponWest";

{
	_weapon = _x select 1;
	if (!isnil "_weapon") then
	{
		_weaponAttachments = ["SERVER_AT", "primary_attachments_west", format ["CP_%1",_weapon] , "ARRAY"] call iniDB_read; 
		if (count _weaponAttachments == 0) then
		{
			_weaponAttachments	=	call compileFinal str[
									[[20,""],[23,"optic_Aco"],[24,"optic_Holosight"],[25,"optic_MRCO"],[28,"optic_Hamr"],[29,"optic_Arco"]], //optics
									[[20,""],[29,"muzzle_snds_h"]], //Barrel
									[[20,""],[25,"acc_flashlight"],[29,"acc_pointer_IR"]]	//Attach
									];
			["SERVER_AT", "primary_attachments_west", format ["CP_%1",_weapon], _weaponAttachments, "ARRAY"] call iniDB_write;
		};
		 missionNamespace setvariable [format ["CP_%1",_weapon], _weaponAttachments];
	};
} foreach CP_ATWeaponWest;
publicvariable format ["CP_%1",_weapon];




//East
CP_ATWeaponEast = ["SERVER_AT", "primary", "CP_ATWeaponEast", "ARRAY"] call iniDB_read;
if (count CP_ATWeaponEast == 0) then
{							   
	CP_ATWeaponEast 	= call compileFinal str 	[
							[0,"arifle_Katiba_C_F",["30Rnd_65x39_caseless_green",9]],
							[10,"arifle_Mk20C_F",["30Rnd_556x45_Stanag",9]],
							[20,"arifle_MX_F",["30Rnd_65x39_caseless_mag",9]]
							]; 
	["SERVER_AT", "primary", "CP_ATWeaponEast",CP_ATWeaponEast, "ARRAY"] call iniDB_write;
};
publicvariable "CP_ATWeaponEast";

{
	_weapon = _x select 1;
	if (!isnil "_weapon") then
	{
		_weaponAttachments = ["SERVER_AT", "primary_attachments_east", format ["CP_%1",_weapon] , "ARRAY"] call iniDB_read; 
		if (count _weaponAttachments == 0) then
		{
			_weaponAttachments	=	call compileFinal str[
									[[0,""],[3,"optic_ACO_grn"],[4,"optic_Holosight"],[5,"optic_MRCO"],[8,"optic_Hamr"],[9,"optic_Arco"]], //optics
									[[0,""],[9,"muzzle_snds_h"]], //Barrel
									[[0,""],[5,"acc_flashlight"],[9,"acc_pointer_IR"]]	//Attach
									];
			["SERVER_AT", "primary_attachments_east", format ["CP_%1",_weapon], _weaponAttachments, "ARRAY"] call iniDB_write;
		};
		 missionNamespace setvariable [format ["CP_%1",_weapon], _weaponAttachments];
	};
} foreach CP_ATWeaponEast;
publicvariable format ["CP_%1",_weapon];



//GUER
CP_ATWeaponGuer = ["SERVER_AT", "primary", "CP_ATWeaponGuer", "ARRAY"] call iniDB_read;
if (count CP_ATWeaponGuer == 0) then
{
	CP_ATWeaponGuer 	= call compileFinal str	[
							[0,"arifle_TRG20_F",["30Rnd_556x45_Stanag",9]],
							[10,"arifle_Mk20C_F",["30Rnd_556x45_Stanag",9]],
							[20,"arifle_MXC_F",["30Rnd_65x39_caseless_mag"]]
							];
	["SERVER_AT", "primary", "CP_ATWeaponGuer",CP_ATWeaponGuer, "ARRAY"] call iniDB_write;
};
publicvariable "CP_ATWeaponGuer";

{
	_weapon = _x select 1;
	if (!isnil "_weapon") then
	{
		_weaponAttachments = ["SERVER_AT", "primary_attachments_guer", format ["CP_%1",_weapon] , "ARRAY"] call iniDB_read; 
		if (count _weaponAttachments == 0) then
		{
			_weaponAttachments	=	call compileFinal str[
									[[10,""],[13,"optic_Aco"],[14,"optic_Holosight"],[15,"optic_MRCO"],[18,"optic_Hamr"],[19,"optic_Arco"]], //optics
									[[10,""],[19,"muzzle_snds_M"]], //Barrel
									[[10,""],[15,"acc_flashlight"],[19,"acc_pointer_IR"]]	//Attach
									];
			["SERVER_AT", "primary_attachments_guer", format ["CP_%1",_weapon], _weaponAttachments, "ARRAY"] call iniDB_write;
		};
		 missionNamespace setvariable [format ["CP_%1",_weapon], _weaponAttachments];
	};
} foreach CP_ATWeaponGuer;
publicvariable format ["CP_%1",_weapon];

//----------------------------------------------------Secondery----------------------------------------------------------------	
//west
CP_ATWeaponSecWest = ["SERVER_AT", "secondery", "CP_ATWeaponSecWest", "ARRAY"] call iniDB_read;
if (count CP_ATWeaponSecWest == 0) then
{				   		   
	CP_ATWeaponSecWest 	= call compileFinal str	[
							[0,"launch_NLAW_F",["NLAW_F",2]],
							[10,"launch_B_Titan_F",["Titan_AA",2]],
							[20,"launch_B_Titan_short_F",["Titan_AT",2]]];
	["SERVER_AT", "secondery", "CP_ATWeaponSecWest",CP_ATWeaponSecWest, "ARRAY"] call iniDB_write;
};
publicvariable "CP_ATWeaponSecWest";

//East
CP_ATWeaponSecEast = ["SERVER_AT", "secondery", "CP_ATWeaponSecEast", "ARRAY"] call iniDB_read;
if (count CP_ATWeaponSecEast == 0) then
{
	CP_ATWeaponSecEast 	= call compileFinal str	[
							[0,"launch_RPG32_F",["RPG32_F",2]],
							[10,"launch_B_Titan_F",["Titan_AA",2]],
							[20,"launch_B_Titan_short_F",["Titan_AT",2]]];
	["SERVER_AT", "secondery", "CP_ATWeaponSecEast",CP_ATWeaponSecEast, "ARRAY"] call iniDB_write;
};
publicvariable "CP_ATWeaponSecEast";

//Guer
CP_ATWeaponSecGuer = ["SERVER_AT", "secondery", "CP_ATWeaponSecGuer", "ARRAY"] call iniDB_read;
if (count CP_ATWeaponSecGuer == 0) then
{
	CP_ATWeaponSecGuer 	= call compileFinal str	[
							[0,"launch_NLAW_F",["NLAW_F",2]],
							[10,"launch_B_Titan_F",["Titan_AA",2]],
							[20,"launch_B_Titan_short_F",["Titan_AT",2]]];
	["SERVER_AT", "secondery", "CP_ATWeaponSecGuer",CP_ATWeaponSecGuer, "ARRAY"] call iniDB_write;
};
publicvariable "CP_ATWeaponSecGuer";
//------------------------------------------------------------------------------Items---------------------------------------------------------------------------	
CP_ATItmes1 = ["SERVER_AT", "items", "CP_ATItmes1", "ARRAY"] call iniDB_read;
if (count CP_ATItmes1 == 0) then
{
	CP_ATItmes1		= call compileFinal str	[
									[0,"", []],
									[10,"Binocular", []],
									[20,"Rangefinder", []]
									];

	["SERVER_AT", "items", "CP_ATItmes1",CP_ATItmes1, "ARRAY"] call iniDB_write;
}; 
publicvariable "CP_ATItmes1"; 


CP_ATItmes2 = ["SERVER_AT", "items", "CP_ATItmes2", "ARRAY"] call iniDB_read;
if (count CP_ATItmes2 == 0) then
{
	CP_ATItmes2		= call compileFinal str	[
									[0,"",0],
									[0,"30Rnd_556x45_Stanag",6],
									[10,"30Rnd_65x39_caseless_mag",6],
									[15,"150Rnd_762x51_Box",2],
									[12,"200Rnd_65x39_cased_Box",2],
									[5,"100Rnd_65x39_caseless_mag_Tracer",2]
									];

	["SERVER_AT", "items", "CP_ATItmes2",CP_ATItmes2, "ARRAY"] call iniDB_write;
}; 
publicvariable "CP_ATItmes2"; 

CP_ATItmes3 = ["SERVER_AT", "items", "CP_ATItmes3", "ARRAY"] call iniDB_read;
if (count CP_ATItmes3 == 0) then
{
	CP_ATItmes3		= call compileFinal str	[
									[0,"MiniGrenade",2],
									[3,"SmokeShell",0],
									[5,"HandGrenade",2],
									[7,"SmokeShellRed",2],
									[9,"SmokeShellGreen",2],
									[11,"Chemlight_green",4],
									[11,"Chemlight_red",4],
									[11,"Chemlight_yellow",4],
									[15,"B_IR_Grenade",2]];

	["SERVER_AT", "items", "CP_ATItmes3",CP_ATItmes3, "ARRAY"] call iniDB_write;
}; 
publicvariable "CP_ATItmes3"; 

//------------------------------------------------------------------------------Gear---------------------------------------------------------------------------

CP_ATUniformsWest = ["SERVER_AT", "gear", "CP_ATUniformsWest", "ARRAY"] call iniDB_read;
if (count CP_ATUniformsWest == 0) then
{
	CP_ATUniformsWest	= call compileFinal str	[
										[[0,""],[20,"NVGoggles"]],		//NV
										[[0,"H_HelmetB_plain_mcamo"],[10,"H_HelmetB_light"],[20,"H_HelmetB"]],	//Head
										[[0,""],[0,"G_Combat"],[10,"G_Tactical_Black"],[20,"G_Sport_Blackred"]],	//Goggles
										[[0,"V_PlateCarrier1_rgr"],[10,"V_PlateCarrierGL_rgr"],[20,"V_TacVest_oli"]],	//Vest
										[[0,"B_AssaultPack_mcamo"],[10,"B_Kitbag_mcamo"],[20,"B_Bergen_mcamo"]],	//Backpack
										[[0,"U_B_CombatUniform_mcam"],[10,"U_B_CombatUniform_mcam_tshirt"],[20,"U_B_CombatUniform_mcam_vest"]]	//Uniforms
									];
	["SERVER_AT", "gear", "CP_ATUniformsWest",CP_ATUniformsWest, "ARRAY"] call iniDB_write;	
};
publicvariable "CP_ATUniformsWest";

CP_ATUniformsEast = ["SERVER_AT", "gear", "CP_ATUniformsEast", "ARRAY"] call iniDB_read;
if (count CP_ATUniformsEast == 0) then
{								
	CP_ATUniformsEast	= call compileFinal str	[
										[[0,""],[20,"NVGoggles"]],		//NV
										[[0,"H_HelmetO_ocamo"],[10,"H_HelmetO_oucamo"],[20,"H_HelmetSpecO_blk"]],	//Head
										[[0,""],[0,"G_Combat"],[10,"G_Tactical_Black"],[20,"G_Sport_Blackred"]],	//Goggles
										[[0,"V_BandollierB_khk"],[10,"V_HarnessOGL_gry"],[20,"V_HarnessOSpec_gry"]],	//Vest
										[[0,"B_AssaultPack_ocamo"],[10,"B_FieldPack_ocamo"],[20,"B_Carryall_ocamo"]],	//Backpack
										[[0,"U_O_CombatUniform_ocamo"],[10,"U_O_SpecopsUniform_ocamo"],[20,"U_O_SpecopsUniform_blk"]]	//Uniforms
									];
	["SERVER_AT", "gear", "CP_ATUniformsEast",CP_ATUniformsEast, "ARRAY"] call iniDB_write;
};
publicvariable "CP_ATUniformsEast";

CP_ATUniformsGuar = ["SERVER_AT", "gear", "CP_ATUniformsGuar", "ARRAY"] call iniDB_read;
if (count CP_ATUniformsGuar == 0) then
{	
	CP_ATUniformsGuar	= call compileFinal str	[
										[[0,""],[20,"NVGoggles"]],		//NV
										[[0,"H_HelmetIA"],[10,"H_HelmetIA_net"],[20,"H_HelmetIA_camo"]],	//Head
										[[0,""],[0,"G_Combat"],[10,"G_Tactical_Black"],[20,"G_Sport_Blackred"]],	//Goggles
										[[0,"V_PlateCarrier1_rgr"],[10,"V_PlateCarrierSpec_rgr"],[20,"V_TacVest_oli"]],	//Vest
										[[0,"B_AssaultPack_mcamo"],[10,"B_Kitbag_mcamo"],[20,"B_Bergen_mcamo"]],	//Backpack
										[[0,"U_I_CombatUniform"],[10,"U_I_CombatUniform_tshirt"]]	//Uniforms
									];
	["SERVER_AT", "gear", "CP_ATUniformsGuar",CP_ATUniformsGuar, "ARRAY"] call iniDB_write;
};
publicvariable "CP_ATUniformsGuar";