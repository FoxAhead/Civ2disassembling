unit Civ2UIA_Options;

interface



type
  PUIAOptions = ^TUIAOptions;

  TUIAOptions = packed record
    UIAEnable: Boolean;
    Patch64bitOn: Boolean;
    DisableCDCheckOn: Boolean;
    CpuUsageOn: Boolean;
    SocketBufferOn: Boolean;
    // civ2patch
    civ2patchEnable: Boolean;
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
    // CPU Throttling Tweaks
    PurgeMessagesIntervalMs: Cardinal;
    MessageWaitTimeoutMinMs: Cardinal;
    MessageWaitTimeoutMaxMs: Cardinal;
    MessageWaitTimeoutThresholdMs: Cardinal;
  end;

var
  Options: TUIAOptions = (
    UIAEnable: True;
    Patch64bitOn: True;
    DisableCDCheckOn: True;
    CpuUsageOn: True;
    SocketBufferOn: True;
    // civ2patch
    civ2patchEnable: True;
    HostileAiOn: True;
    RetirementYearOn: False;
    RetirementWarningYear: 2000;          // Default = 2000
    RetirementYear: 2020;                 // Default = 2020
    PopulationLimitOn: True;
    PopulationLimit: $3FFFFFFF;           // Default = 32000 (0x7D00)
    GoldLimitOn: True;
    GoldLimit: $3FFFFFFF;                 // Default = 30000 (0x7530)
    MapSizeLimitOn: True;
    MapXLimit: $1FF;                      // Default = 250   (0xFA)
    MapYLimit: $1FF;                      // Default = 250   (0xFA)
    MapSizeLimit: $7FFF;                  // Default = 10000 (0x2710)
    // CPU Throttling Tweaks
    PurgeMessagesIntervalMs: 3000;
    MessageWaitTimeoutMinMs: 1;
    MessageWaitTimeoutMaxMs: 10;
    MessageWaitTimeoutThresholdMs: 1000;
    );
  UIAOPtions: PUIAOptions = Pointer($006560F0);

implementation

end.
