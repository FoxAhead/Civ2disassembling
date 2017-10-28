unit Civ2UIA_Options;

interface

uses
  Windows;

type
  PUIAOptions = ^TUIAOptions;

  TUIAOptions = packed record
    MasterOn: Boolean;
    // civ2patch
    HostileAiOn: Boolean;
    RetirementYearOn: Boolean;
    RetirementWarningYear: Word;
    RetirementYear: Word;
    PopulationLimitOn: Boolean;
    PopulationLimit: Cardinal;
    GoldLimitOn: Boolean;
    GoldLimit: Cardinal;
    MapSizeLimitOn: Boolean;
    MapXLimit: Word;
    MapYLimit: Word;
    MapSizeLimit: Word;
  end;

var
  Options: TUIAOptions = (
    MasterOn: True;
    HostileAiOn: True;
    RetirementYearOn: True;
    RetirementWarningYear: 3000;          // Default = 2000
    RetirementYear: 3020;                 // Default = 2020
    PopulationLimitOn: True;
    PopulationLimit: $3FFFFFFF;           // Default = 32000 (0x7D00)
    GoldLimitOn: True;
    GoldLimit: $3FFFFFFF;                 // Default = 30000 (0x7530)
    MapSizeLimitOn: True;
    MapXLimit: $1FF;                      // Default = 250   (0xFA)
    MapYLimit: $1FF;                      // Default = 250   (0xFA)
    MapSizeLimit: $7FFF;                  // Default = 10000 (0x2710)
    );
  UIAOPtions: PUIAOptions = Pointer($006560F0);

implementation

end.
