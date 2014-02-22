class MCC_artilleryDialogControls:MCC_RscControlsGroup
{
	idc = 505;
	x = 0.186 * safezoneW + safezoneX;
	y = 0.14 * safezoneH + safezoneY;
	w = 0.20625 * safezoneW;
	h = 0.274893 * safezoneH;

	class Controls
	{
	
		class MCC_artilleryDialogFrame: MCC_RscText
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.9};
			
			x = 0.270833 * safezoneW + safezoneX;
			y = 0.225107 * safezoneH + safezoneY;
			w = 0.20625 * safezoneW;
			h = 0.274893 * safezoneH;
		};

		class MCC_artilleryTitle: MCC_RscText
		{
			idc = -1;
			text = "Artillery:"; //--- ToDo: Localize;
			colorText[] = {0,1,1,1};
			
			x = 0.351042 * safezoneW + safezoneX;
			y = 0.236103 * safezoneH + safezoneY;
			w = 0.0572917 * safezoneW;
			h = 0.0329871 * safezoneH;
		};
		class MCC_artilleryTypeTitle: MCC_RscText
		{
			idc = -1;

			text = "Type:"; //--- ToDo: Localize;
			x = 0.276563 * safezoneW + safezoneX;
			y = 0.280086 * safezoneH + safezoneY;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class MCC_artillerySpreadTitle: MCC_RscText
		{
			idc = -1;

			text = "Spread:"; //--- ToDo: Localize;
			x = 0.276563 * safezoneW + safezoneX;
			y = 0.313073 * safezoneH + safezoneY;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class MCC_artilleryNumberTitle: MCC_RscText
		{
			idc = -1;

			text = "N. of Shells:"; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			
			x = 0.276563 * safezoneW + safezoneX;
			y = 0.34606 * safezoneH + safezoneY;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class MCC_artilleryType: MCC_RscCombo
		{
			idc = 30;

			x = 0.351042 * safezoneW + safezoneX;
			y = 0.280086 * safezoneH + safezoneY;
			w = 0.120313 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class MCC_artillerySpread: MCC_RscCombo
		{
			idc = 31;

			x = 0.351042 * safezoneW + safezoneX;
			y = 0.313073 * safezoneH + safezoneY;
			w = 0.120313 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class MCC_artilleryNumber: MCC_RscCombo
		{
			idc = 32;

			x = 0.351042 * safezoneW + safezoneX;
			y = 0.34606 * safezoneH + safezoneY;
			w = 0.120313 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class MCC_artilleryDelayText: MCC_RscText
		{
			idc = -1;

			text = "Delay:"; //--- ToDo: Localize;
			x = 0.276563 * safezoneW + safezoneX;
			y = 0.379047 * safezoneH + safezoneY;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class MCC_artilleryDelayCombo: MCC_RscCombo
		{
			idc = 33;

			x = 0.351042 * safezoneW + safezoneX;
			y = 0.379047 * safezoneH + safezoneY;
			w = 0.120313 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class MCC_artilleryCall: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[0] execVM '"+MCCPATH+"mcc\general_scripts\artillery\artillery_request.sqf'");

			text = "Call"; //--- ToDo: Localize;
			x = 0.276563 * safezoneW + safezoneX;
			y = 0.412034 * safezoneH + safezoneY;
			w = 0.0859375 * safezoneW;
			h = 0.0329871 * safezoneH;
			tooltip = "Call Artillery on map position"; //--- ToDo: Localize;
		};
		class MCC_artilleryAdd: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[1] execVM '"+MCCPATH+"mcc\general_scripts\artillery\artillery_request.sqf'");

			text = "Add"; //--- ToDo: Localize;
			x = 0.385417 * safezoneW + safezoneX;
			y = 0.412034 * safezoneH + safezoneY;
			w = 0.0859375 * safezoneW;
			h = 0.0329871 * safezoneH;
			tooltip = "Add artillery to MCC Console "; //--- ToDo: Localize;
		};
		class MCC_artilleryDialogClose: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[5] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\controlsHandle.sqf'");

			text = "Close"; //--- ToDo: Localize;
			x = 0.328125 * safezoneW + safezoneX;
			y = 0.456017 * safezoneH + safezoneY;
			w = 0.0859375 * safezoneW;
			h = 0.0329871 * safezoneH;
		};
	};
};