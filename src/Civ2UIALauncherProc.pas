unit Civ2UIALauncherProc;

//--------------------------------------------------------------------------------------------------
interface
//--------------------------------------------------------------------------------------------------

uses
  Controls,
  Forms,
  StdCtrls,
  SysUtils,
  ShlObj,
  ComObj,
  ActiveX,
  Windows;

var
  ExeName: string;                        // = 'D:\GAMES\Civilization II Multiplayer Gold Edition\civ2.exe';
  DllName: string;
  DllLoaded: Boolean;
  LogMemo: TMemo;

function InitializePaths(): Boolean;

function IsSilentLaunch(): Boolean;

procedure Log(Str: string);

function CheckLaunchClose(): Boolean;

function CurrentFileInfo(NameApp: string): string;

procedure CreateLnk(FileName, Path, WorkingDirectory, Description, Arguments: string);

procedure SetFileNameIfExist(var Variable: string; FileName: string);

function GetFileSize(FileName: string): Cardinal;

//--------------------------------------------------------------------------------------------------
implementation
//--------------------------------------------------------------------------------------------------

function CurrentFileInfo(NameApp: string): string;
var
  dump: DWORD;
  size: Integer;
  buffer: PChar;
  VersionPointer, TransBuffer: PChar;
  Temp: Integer;
  CalcLangCharSet: string;
begin
  size := GetFileVersionInfoSize(PChar(NameApp), dump);
  buffer := StrAlloc(size + 1);
  try
    GetFileVersionInfo(PChar(NameApp), 0, size, buffer);

    VerQueryValue(buffer, '\VarFileInfo\Translation', Pointer(TransBuffer), dump);
    if dump >= 4 then
    begin
      Temp := 0;
      StrLCopy(@Temp, TransBuffer, 2);
      CalcLangCharSet := IntToHex(Temp, 4);
      StrLCopy(@Temp, TransBuffer + 2, 2);
      CalcLangCharSet := CalcLangCharSet + IntToHex(Temp, 4);
    end;

    VerQueryValue(buffer, PChar('\StringFileInfo\' + CalcLangCharSet + '\' + 'FileVersion'), Pointer(VersionPointer), dump);
    if (dump > 1) then
    begin
      SetLength(Result, dump);
      StrLCopy(PChar(Result), VersionPointer, dump);
    end
    else
      Result := '0.0.0.0';
  finally
    StrDispose(buffer);
  end;
end;

function IsSilentLaunch(): Boolean;
begin
  Result := FindCmdLineSwitch('play');
end;

function InitializePaths(): Boolean;
var
  MyPath: string;
  i: Integer;
begin
  MyPath := ExtractFilePath(Application.ExeName);
  SetFileNameIfExist(ExeName, MyPath + 'civ2.exe');
  SetFileNameIfExist(DllName, MyPath + 'Civ2UIA.dll');
  for i := 1 to ParamCount do
  begin
    if ParamStr(i) = '-exe' then
      SetFileNameIfExist(ExeName, ParamStr(i + 1));
    if ParamStr(i) = '-dll' then
      SetFileNameIfExist(DllName, ParamStr(i + 1));
  end;
  Result := (ExeName <> '') and (DllName <> '');
end;

procedure Log(Str: string);
begin
  if LogMemo <> nil then
  begin
    while LogMemo.Lines.Count >= 100 do
      LogMemo.Lines.Delete(0);
    LogMemo.Lines.Add(Str);
    LogMemo.Text := Trim(LogMemo.Text);
  end;
end;

procedure LaunchGame();
var
  FileName: string;
  Path: string;
  StartupInfo: TStartupInfo;
  ProcessInformation: TProcessInformation;
  Context: TContext;
  Inject: packed record
    PushCommand: Byte;
    PushArgument: Cardinal;
    CallCommand: Word;
    CallAddr: Cardinal;
    JumpCommand: Byte;
    JumpOffset: Byte;
    LibraryName: array[0..$FF] of Char;   // + 0x0D
  end;
  SavedBytes: array[0..$1FF] of Byte;
  EntryPointAddress: Cardinal;
  BytesRead: Cardinal;
  BytesWritten: Cardinal;
  i: Integer;
begin
  try
    DllLoaded := False;
    FileName := ExeName;
    Path := ExtractFilePath(ExeName);
    ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
    StartupInfo.cb := SizeOf(StartupInfo);
    ZeroMemory(@ProcessInformation, SizeOf(ProcessInformation));
    if not CreateProcess(PAnsiChar(FileName), nil, nil, nil, False, CREATE_SUSPENDED, nil, PAnsiChar(Path), StartupInfo, ProcessInformation) then
      raise Exception.Create('CreateProcess: ' + IntToStr(GetLastError()));
    ZeroMemory(@Context, SizeOf(Context));
    Context.ContextFlags := CONTEXT_FULL;
    EntryPointAddress := $005F6E90;
    ZeroMemory(@Inject, SizeOf(Inject));
    Inject.PushCommand := $68;
    Inject.PushArgument := EntryPointAddress + $0D;
    Inject.CallCommand := $15FF;
    Inject.CallAddr := $006E7C30;
    Inject.JumpCommand := $EB;
    Inject.JumpOffset := $FE;
    StrPCopy(Inject.LibraryName, DllName);
    ReadProcessMemory(ProcessInformation.hProcess, Pointer(EntryPointAddress), @SavedBytes, SizeOf(SavedBytes), BytesRead);
    if not WriteProcessMemory(ProcessInformation.hProcess, Pointer(EntryPointAddress), @Inject, SizeOf(Inject), BytesWritten) then
      raise Exception.Create('WriteProcessMemory: ' + IntToStr(GetLastError()));
    Log('BytesWritten ' + IntToStr(BytesWritten));
    ResumeThread(ProcessInformation.hThread);
    for i := 1 to 50 do
    begin
      Application.ProcessMessages();
      if DllLoaded then
        Break;
      Sleep(100);
    end;
    if not DllLoaded then
      raise Exception.Create('Dll not loaded');

    SuspendThread(ProcessInformation.hThread);
    if not WriteProcessMemory(ProcessInformation.hProcess, Pointer(EntryPointAddress), @SavedBytes, SizeOf(SavedBytes), BytesWritten) then
      raise Exception.Create('WriteProcessMemory: ' + IntToStr(GetLastError()));
    Context.ContextFlags := CONTEXT_FULL;
    GetThreadContext(ProcessInformation.hThread, Context);
    Context.Eip := EntryPointAddress;
    SetThreadContext(ProcessInformation.hThread, Context);

    ResumeThread(ProcessInformation.hThread);

  except
    if (ProcessInformation.hProcess <> 0) then
      TerminateProcess(ProcessInformation.hProcess, 1);
    raise;

  end;

end;

function Check(): Boolean;
begin
  if not FileExists(ExeName) then
    raise Exception.Create('Game exe file ' + ExeName + 'does not exist');
  if not FileExists(DllName) then
    raise Exception.Create('Dll file ' + DllName + 'does not exist');
  if GetFileSize(ExeName) <> 2489344 then
    raise Exception.Create('Wrong size of game exe file (Wrong version?)');
  Result := True;
end;

function CheckLaunchClose(): Boolean;
begin
  Result := False;
  try
    Check();
    LaunchGame();
    Result := True;
    Application.Terminate();
  except
    on E: Exception do
      Log('Error: ' + E.message);
  end;
end;

procedure CreateLnk(FileName, Path, WorkingDirectory, Description, Arguments: string);
var
  ComObject: IUnknown;
  ShellLink: IShellLink;
  PersistFile: IPersistFile;
begin
  CoInitialize(nil);
  ComObject := CreateComObject(CLSID_ShellLink);
  ShellLink := ComObject as IShellLink;
  PersistFile := ComObject as IPersistFile;
  ShellLink.SetPath(PChar(Path));
  ShellLink.SetWorkingDirectory(PChar(WorkingDirectory));
  ShellLink.SetDescription(PChar(Description));
  ShellLink.SetArguments(PChar(Arguments));
  PersistFile.Save(PWideChar(WideString(FileName)), False);
  CoUninitialize();
end;

procedure SetFileNameIfExist(var Variable: string; FileName: string);
begin
  if FileExists(FileName) then
    Variable := FileName;
end;

function GetFileSize(FileName: string): Cardinal;
var
  sr: TSearchRec;
begin
  Result := 0;
  if SysUtils.FindFirst(FileName, faAnyFile, sr) = 0 then
  begin
    Result := sr.size;
    SysUtils.FindClose(sr);
  end;
end;

end.