; smartmontools for Windows package

#define BuildNumber "2018032701"
#define AppName "smartmontools for Windows"
#define AppShortName "smartmontools-win"
#define MajorVersion "6.6"
#define MinorVersion "1"
#define SubBuild "3"
; Define build type -dev -beta -rc for WIP, leave empty for RTM
#define BuildType ""
#define AppPublisher "Orsiris de Jong"
#define AppURL "http://www.netpower.fr"
#define CopyrightYears="2012-2018"

#define BaseDir "C:\ODJ\BTC\Smartmontools for Windows"
#define SmartmonToolsDir "smartmontools-6.6-1.win32-setup"
#define smartdPynguiDir "smartd-pyngui"
;#define erroractionGuiDir "erroraction-gui"
#define SendEmailDir "sendEmail-v156"
#define MailsendDir "mailsend1.19"
#define GzipDir "gzip-1.3.12-1-bin"
#define ddDir "dd-0.6beta3"
#define vcRedistDir "VCREDIST"
#define wgetDir "wget"
#define SmartServiceName "smartd"
#define AppGUID "{487E2D86-AB76-467B-8EC0-0AF89EC38F5C}"

[Setup]
; Aribtrary chosen GUID
AppId={{#AppGUID}
AppName={#AppName}
AppVersion={#MajorVersion}-{#MinorVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
DefaultDirName={pf}\{#AppName}
DefaultGroupName=smartmontools for Windows
LicenseFile={#BaseDir}\LICENSE.TXT
OutputDir={#BaseDir}\Build
OutputBaseFilename={#AppShortName}-{#MajorVersion}-{#MinorVersion}{#BuildType}
Compression=lzma2/max
SolidCompression=yes
VersionInfoCopyright=Written in {#CopyrightYears} by {#AppPublisher} {#AppURL}
VersionInfoVersion="{#MajorVersion}.{#MinorVersion}.{#SubBuild}"
MinVersion=0,5.0
CloseApplications=no
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: en; MessagesFile: "compiler:Default.isl"; InfoBeforeFile: "{#BaseDir}\README.md";
Name: fr; MessagesFile: "compiler:Languages\French.isl"; InfoBeforeFile: "{#BaseDir}\README-FR.TXT";
Name: de; MessagesFile: "compiler:Languages\German.isl"; InfoBeforeFile: "{#BaseDir}\README-DE.TXT";
;Name: ru; MessagesFile: "compiler:Languages\Russian.isl"; InfoBeforeFile: "{#BaseDir}\README-RU.TXT";

[CustomMessages]
#include "smartmontools for windows strings.iss"

[Types]
Name: full; Description: "{cm:FullInstall}";
Name: custom; Description: "{cm:CustomInstall}"; Flags: iscustom;
Name: smartd-pyngui; Description: "{cm:SmartdPynguiInstall}";

[Components]
Name: core; Description: "{cm:coredescription}"; Types: full; Flags: exclusive
Name: core\service; Description: "{cm:coreservice}"; Types: full;
Name: core\service\gui; Description: "{cm:servicegui}"; Types: full;
Name: core\service\mailalert; Description: "{cm:mailsupport}"; Types: full;
Name: core\service\localalert; Description: "{cm:localsupport}"; Types: full;
Name: core\scheduledtestalerts; Description: "{cm:scheduledtestalerts}"; Types: custom;
Name: core\regext; Description: "{cm:regext}"; Types: full;
Name: core\regext\info; Description: "{cm:smartinfo}"; Types: Full;
Name: core\regext\tests; Description: "{cm:smarttests}"; Types: Full;
Name: core\updatedb; Description: "{cm:updatedb}"; Types: Full;
Name: smartdpyngui; Description: "{cm:smartdpyngui}"; Types: smartd-pyngui; Flags: exclusive
Name: fixbadsecttools; Description: "{cm:fixbadsecttools}"; Types: custom;
Name: authorlinks; Description: "{cm:authorlinks}"; Types: full;
Name: statistics; Description: "{cm:statistics}"; Types: full smartd-pyngui;

[Files]
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin\drivedb.h"; DestDir: "{app}\bin"; Components: core;
;Source: "{#BaseDir}\{#SmartmontoolsDir}\bin\runcmda.exe.manifest"; DestDir: "{app}\bin"; Components: core;
;Source: "{#BaseDir}\{#SmartmontoolsDir}\bin\runcmdu.exe.manifest"; DestDir: "{app}\bin"; Components: core;
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin\update-smart-drivedb.exe"; DestDir: "{app}\bin"; Components: core;
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin\smartd_warning.cmd"; DestDir: "{app}\bin"; Components: core\service;
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin\smartd.conf"; DestDir: "{app}\bin"; DestName: smartd.conf.example; Components: core; Flags: ignoreversion
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin\runcmda.exe"; DestDir: "{app}\bin"; Components: core; Check: IsWin32()
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin\runcmdu.exe"; DestDir: "{app}\bin"; Components: core; Check: IsWin32()
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin\smartctl.exe"; DestDir: "{app}\bin"; Components: core; Check: IsWin32()
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin\smartctl-nc.exe"; DestDir: "{app}\bin"; Components: core; Check: IsWin32()
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin\smartd.exe"; DestDir: "{app}\bin"; Components: core; Check: IsWin32(); AfterInstall: TestForExistingSmartdUpstream();
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin\wtssendmsg.exe"; DestDir: "{app}\bin"; Components: core; Check: IsWin32()
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin64\runcmda.exe"; DestDir: "{app}\bin"; Components: core; Flags: 64bit; Check: IsWin64
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin64\runcmdu.exe"; DestDir: "{app}\bin"; Components: core; Flags: 64bit; Check: IsWin64
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin64\smartctl.exe"; DestDir: "{app}\bin"; Components: core; Flags: 64bit; Check: IsWin64
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin64\smartctl-nc.exe"; DestDir: "{app}\bin"; Components: core; Flags: 64bit; Check: IsWin64
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin64\smartd.exe"; DestDir: "{app}\bin"; Components: core; Flags: 64bit; Check: IsWin64; AfterInstall: TestForExistingSmartdUpstream();
Source: "{#BaseDir}\{#SmartmontoolsDir}\bin64\wtssendmsg.exe"; DestDir: "{app}\bin"; Components: core\service\localalert; Flags: 64bit; Check: IsWin64
Source: "{#BaseDir}\{#SmartmontoolsDir}\doc\*"; DestDir: "{app}\doc\smartmontools"; Components: core; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#BaseDir}\{#smartdPynguiDir}\*"; Excludes: "tzdata,demos,msgs,images"; DestDir: "{app}\bin\{#smartdPynguiDir}"; Components: core\service\gui; Flags: recursesubdirs createallsubdirs
;Source: "{#BaseDir}\{#erroractionGuiDir}\*"; DestDir: "{app}\bin\{#smartdPynguiDir}"; Components: core\service\gui; Flags: recursesubdirs createallsubdirs
Source: "{#BaseDir}\{#vcRedistDir}\msvcr100.dll"; DestDir: "{app}\bin\{#smartdPynguiDir}"; Components: core\service\gui;
Source: "{#BaseDir}\{#MailSendDir}\mailsend.exe"; DestDir: "{app}\bin"; Components: core\service\mailalert;
Source: "{#BaseDir}\{#MailSendDir}\COPYRIGHT.TXT"; DestDir: "{app}\doc\mailsend"; Components: core\service\mailalert;
Source: "{#BaseDir}\{#GzipDir}\bin\gzip.exe"; DestDir: "{app}\bin"; Components: core\service\mailalert;
Source: "{#BaseDir}\{#GzipDir}\man\cat1\gzip.1.txt"; DestDir: "{app}\doc\gzip"; Components: core\service\mailalert;
Source: "{#BaseDir}\base64.exe"; DestDir: "{app}\bin"; Components: core\service\mailalert;
Source: "{#BaseDir}\{#ddDir}\dd.exe"; DestDir: "{app}\bin"; Components: fixbadsecttools;
Source: "{#BaseDir}\{#ddDir}\Copying.txt"; DestDir: "{app}\doc\dd"; Components: fixbadsecttools;
Source: "{#BaseDir}\{#ddDir}\ddchanges.txt"; DestDir: "{app}\doc\dd"; Components: fixbadsecttools;
Source: "{#BaseDir}\{#wgetDir}\wget-1.14.exe"; DestDir: "{tmp}"; Components: statistics; AfterInstall: SendInstallerStats();
Source: "{#BaseDir}\fix_badsectors.cmd"; DestDir: "{app}\bin"; Components: fixbadsecttools;
Source: "{#BaseDir}\README.md"; DestDir: "{app}\doc\Smartmontools for Windows package"; Components: core;
;Source: "{#BaseDir}\README-RU.TXT"; DestDir: "{app}\doc\Smartmontools for Windows package"; Components: core;
Source: "{#BaseDir}\README-FR.TXT"; DestDir: "{app}\doc\Smartmontools for Windows package"; Components: core;
Source: "{#BaseDir}\README-DE.TXT"; DestDir: "{app}\doc\Smartmontools for Windows package"; Components: core;
Source: "{#BaseDir}\LICENSE.TXT"; DestDir: "{app}\doc\Smartmontools for Windows package"; Components: core;
Source: "{#BaseDir}\erroraction.cmd"; DestDir: "{app}\bin"; Components: core\service;
Source: "{#BaseDir}\erroraction_config.cmd"; DestDir: "{app}\bin"; Components: core\service; Flags: confirmoverwrite; Check: NoExternalErroractionFile(); AfterInstall: UpdateErroractionConfFile();
Source: "{#BaseDir}\ScheduledTask.xml"; DestDir: "{app}\bin"; Components: core\scheduledtestalerts; AfterInstall: WriteScheduledTest();
Source: "{#BaseDir}\smartd.conf"; DestDir: "{app}\bin"; Components: core\service; Flags: confirmoverwrite; Check: NoExternalSmartdFile(); AfterInstall: UpdateSmartdConfFile();
Source: "{#BaseDir}\{#smartdPynguiDir}\*"; Excludes: "tzdata,demos,msgs,images"; DestDir: "{app}\bin\{#smartdPynguiDir}"; Components: smartdpyngui; Flags: recursesubdirs createallsubdirs

[Run]
Filename: {app}\bin\update-smart-drivedb.exe; Parameters: "/S"; Components: core\updatedb; StatusMSG: "Updating drive database."; Flags: waituntilterminated
Filename: {app}\bin\{#smartdPynguiDir}\smartd_pyngui.exe; Parameters: "-c ""{app}\bin\smartd.conf"""; Components: core\service\gui; StatusMSG: "Setup Smartd service"; Flags: waituntilterminated skipifsilent
Filename: {app}\bin\{#smartdPynguiDir}\smartd_pyngui.exe; Components: smartdpyngui; StatusMSG: "Setup Smartd service"; Flags: waituntilterminated skipifsilent
Filename: {app}\bin\{#smartdPynguiDir}\erroraction_config.exe; Parameters: "-c ""{app}\bin\erroraction_config.cmd"""; Components: core\service\gui; StatusMSG: "Setup alert settings"; Flags: waituntilterminated skipifsilent
Filename: {app}\bin\scheduled_send.cmd; Components: core\scheduledtestalerts; StatusMsg: "Setting up scheduled test send"; Flags: runhidden

[Icons]
Name: {group}\Reconfigure SMART service; Filename: "{app}\bin\{#smartdPynguiDir}\smartd_pyngui.exe"; Parameters: "-c ""{app}\bin\smartd.conf"""; Components: core\service\gui;
Name: {group}\Reconfigure SMART service; Filename: "{app}\bin\{#smartdPynguiDir}\smartd_pyngui.exe"; Components: smartdpyngui;
Name: {group}\Reconfigure SMART Alert settings; Filename: "{app}\bin\{#smartdPynguiDir}\erroraction_config.exe"; Parameters:  "-c ""{app}\bin\erroraction_config.cmd"""; Components: core\service\gui;
Name: {group}\Visit NetPower.fr; Filename: http://www.netpower.fr; Components: authorlinks;
Name: {group}\Visit smartmontools Site; Filename: http://smartmontools.sourceforge.net; Components: authorlinks;
;Name: {group}\Fix Bad sectors (use at own risk!); Filename: "{app}\bin\fix_badsectors.cmd"; Components: fixbadsecttools
Name: "{group}\{cm:UninstallProgram, {#=AppName}}"; Filename: {uninstallexe}; 

[Registry]
Root: HKLM; Subkey: SOFTWARE\Classes\Drive\shell\smartctlinfo\; ValueType: String; ValueData: {cm:smartinfo}; Components: core\regext\info; Flags: uninsdeletekey
Root: HKLM; Subkey: SOFTWARE\Classes\Drive\shell\smartctlinfo\command; ValueType: String; ValueData: """{app}\bin\runcmda.exe"" ""{app}\bin\smartctl.exe"" -d auto -a %L"; Components: core\regext\info; Flags: uninsdeletevalue
Root: HKLM; Subkey: SOFTWARE\Classes\Drive\shell\smartctlshorttest\; ValueType: String; ValueData: {cm:smarttestshort}; Components: core\regext\tests; Flags: uninsdeletekey
Root: HKLM; Subkey: SOFTWARE\Classes\Drive\shell\smartctlshorttest\command; ValueType: String; ValueData: """{app}\bin\runcmda.exe"" ""{app}\bin\smartctl.exe"" -d auto -t short %L"; Components: core\regext\tests; Flags: uninsdeletevalue
Root: HKLM; Subkey: SOFTWARE\Classes\Drive\shell\smartctllongtest\; ValueType: String; ValueData: {cm:smarttestlong}; Components: core\regext\tests; Flags: uninsdeletekey
Root: HKLM; Subkey: SOFTWARE\Classes\Drive\shell\smartctllongtest\command; ValueType: String; ValueData: """{app}\bin\runcmda.exe"" ""{app}\bin\smartctl.exe"" -d auto -t long %L"; Components: core\regext\tests; Flags: uninsdeletevalue

[UninstallRun]
; TODO: check if smartd should remain because of upstream package
;Filename: {sys}\sc.exe; Parameters: "delete ""{#SmartServiceName}"""; Components: core\service; Flags: runhidden

; Remove earlier versions of smartd-pyngui in order to avoid python conflicts
[InstallDelete]
Type: filesandordirs; Name: "{app}\bin\{#smartdPynguiDir}";

[UninstallDelete]
Type: Files; Name: "{app}\bin\erroraction.cmd";
Type: Files; Name: "{app}\bin\erroraction_config.cmd";
Type: Files; Name: "{app}\bin\smartd.conf";
Type: Files; Name: "{app}\bin\drivedb.h.old";
Type: Files; Name: "{app}\bin\scheduled_send.cmd";
Type: Files; Name: "{app}\bin\{#smartdPynguiDir}\*.log";
Type: dirifempty; Name: "{app}\bin";
Type: dirifempty; Name: "{app}";

[Code]
var 
  InitialLogFile: String;
  //pageid: integer;

#include "smartmontools for Windows includes.iss"

procedure UpdateSmartdConfFile();
begin
  /// Modifiy app path for smartd.conf
  FileReplaceString(ExpandConstant('{app}\bin\smartd.conf'), '[PATH]', ExpandConstant('{app}\bin'));
end;

function NoExternalSmartdFile(): Boolean;
begin
  if (FileExists(Expandconstant('{src}\smartd.conf'))) then
  begin
    FileCopy(ExpandConstant('{src}\smartd.conf'), ExpandConstant('{app}\bin\smartd.conf'), False);
    UpdateSmartdConfFile();
    result := false;
  end else
    result := true;
end;

procedure UpdateErroractionConfFile();
begin
  //// Modify erroraction_config.cmd with app path and warning message
  FileReplaceString(ExpandConstant('{app}\bin\erroraction_config.cmd'), '[PATH]', ExpandConstant('{app}\bin'));
  FileReplaceString(ExpandConstant('{app}\bin\erroraction_config.cmd'), '[WARNING_MESSAGE]', ExpandConstant('{cm:warningmessage}'));

  //// Depending on options selected, set MAIL_ALERT=yes/no and LOCAL_ALERT=yes/no in erroraction_config.cmd
  //// To lazy to find out how to use wildcards with FileReplaceString --> old disgusting way
  if (IsComponentSelected('core\service\mailalert')) then
  begin
    FileReplaceString(ExpandConstant('{app}\bin\erroraction_config.cmd'), 'MAIL_ALERT=no', 'MAIL_ALERT=yes');
    FileReplaceString(ExpandConstant('{app}\bin\erroraction_config.cmd'), 'MAIL_ALERT=' + #13#10, 'MAIL_ALERT=yes');
  end else
    FileReplaceString(ExpandConstant('{app}\bin\erroraction_config.cmd'), 'MAIL_ALERT=yes', 'MAIL_ALERT=no');  
    FileReplaceString(ExpandConstant('{app}\bin\erroraction_config.cmd'), 'MAIL_ALERT=' + #13#10, 'MAIL_ALERT=no');

  if (IsComponentSelected('core\service\localalert')) then
  begin
    FileReplaceString(ExpandConstant('{app}\bin\erroraction_config.cmd'), 'LOCAL_ALERT=no', 'LOCAL_ALERT=yes');
    FileReplaceString(ExpandConstant('{app}\bin\erroraction_config.cmd'), 'LOCAL_ALERT=' + #13#10, 'LOCAL_ALERT=yes');
  end else
    FileReplaceString(ExpandConstant('{app}\bin\erroraction_config.cmd'), 'LOCAL_ALERT=yes', 'LOCAL_ALERT=no');
    FileReplaceString(ExpandConstant('{app}\bin\erroraction_config.cmd'), 'LOCAL_ALERT=' + #13#10, 'LOCAL_ALERT=no');   
end;

function NoExternalErroractionFile(): Boolean;
begin
  if (FileExists(Expandconstant('{src}\erroraction_config.cmd'))) then
  begin
    FileCopy(ExpandConstant('{src}\erroraction_config.cmd'), ExpandConstant('{app}\bin\erroraction_config.cmd'), False);
    UpdateErroractionConfFile();
    Result := false;
  end
  else
    Result := true;
end;

//// Create a file called smart.(version).log including info about all disks
function CreateInitialLog(): Boolean;
var
  resultcode: Integer;

begin
  ////TODO: detect smartd.conf drives
  InitialLogFile := ExpandConstant('{app}\smartmontools-install-{#MajorVersion}-{#MinorVersion}.log');
  SaveStringToFile(InitialLogFile, '# Smartmontools for Windows installed on ' + GetDateTimeString('dd mmm yyyy hh:nn:ss', #0, #0) + #13#10 + #13#10, True);
    ShellExec('', ExpandConstant('{cmd}') ,ExpandConstant('/c for /f "delims= " %i in (' + #39 + '"{app}\bin\smartctl" --scan' + #39 +') do "{app}\bin\smartctl.exe" -a %i >> "' + InitialLogFile + '"'), '', SW_HIDE, ewWaitUntilTerminated, resultcode)
end;

//// ScheduledTask command file
procedure WriteScheduledTest();
begin
  //// Create scheduled tasks configuration file
  SaveStringToFile(ExpandConstant('{app}\bin\scheduled_send.cmd'), ':: This file was generated on ' + GetDateTimeString('dd mmm yyyy', #0, #0) + ' by smartmontools for Windows package' + #13#10, False);
  SaveStringToFile(ExpandConstant('{app}\bin\scheduled_send.cmd'), ':: http://www.netpower.fr' + #13#10#13#10, True);
  SaveStringToFile(ExpandConstant('{app}\bin\scheduled_send.cmd'), '@echo off' + #13#10, True);
  SaveStringToFile(ExpandConstant('{app}\bin\scheduled_send.cmd'), ':: Attention: schtasks cannot set Run if missed' + #13#10, True);
  SaveStringToFile(ExpandConstant('{app}\bin\scheduled_send.cmd'), ExpandConstant('schtasks /CREATE /TN "Smartmontools for Windows Test" /XML "{app}\bin\ScheduledTask.xml" /RU System /F') + #13#10, True);

  //// Modify Scheduled task file with app path
  FileReplaceString(ExpandConstant('{app}\bin\ScheduledTask.xml'), '[PATH]', ExpandConstant('{app}\bin'));
end;

// TODO
procedure TestForExistingSmartdUpstream();
begin
  if ((FileExists(ExpandConstant('{pf32}\smartmontools\bin\smartd.exe'))) or (FileExists(ExpandConstant('{pf}\smartmontools\bin\smartd.exe')))) then
  begin
     if (ServiceExists('{#SmartServiceName}') = true) then
     begin
       if (MsgBox('Upstream smartd service is installed. Do you want to replace the upstream service ?', mbConfirmation, MB_YESNO) = IDYES) then
       begin
         UninstallService('{#SmartServiceName}');
         InstallService;
       end
     end
     else
       InstallService; 
  end 
  else
    if (ServiceExists('{#SmartServiceName}') = true) then
      UninstallService('{#SmartServiceName}')
    InstallService;     
end;

procedure SendInstallerStats();
var
  Version: TWindowsVersion;
  WindowsString: String;
  Parameters: String;
  ResultCode: Integer;

begin
  GetWindowsVersionEx(Version);
  WindowsString := IntToStr(Version.Major) + '.' + IntToStr(Version.Minor) + ' build ' + IntToStr(Version.Build) + ' SP ' + IntToStr(Version.ServicePackMajor) + '.' + IntToStr(Version.ServicePackMinor)
  
  if (Version.NTPlatform = true) then
    WindowsString := WindowsString + ' NT'

  if (Version.ProductType = VER_NT_WORKSTATION) then
    WindowsString := WindowsString + ' NT_WORKSTATION'
  else if (Version.ProductType = VER_NT_DOMAIN_CONTROLLER) then
    WindowsString := WindowsString + ' NT_DOMAIN_CONTROLLER'
  else if (Version.ProductType = VER_NT_SERVER) then
    WindowsString := WindowsString + ' NT_SERVER'

  if (Version.SuiteMask = VER_SUITE_BACKOFFICE) then
     WindowsString := WindowsString + ' SUITE_BACKOFFICE'
   else if (Version.SuiteMask = VER_SUITE_BLADE) then
     WindowsString := WindowsString + ' SUITE_BLADE'
   else if (Version.SuiteMask = VER_SUITE_DATACENTER) then
     WindowsString := WindowsString + ' SUITE_DATACENTER'
   else if (Version.SuiteMask = VER_SUITE_ENTERPRISE) then
     WindowsString := WindowsString + ' SUITE_ENTERPRISE'
   else if (Version.SuiteMask = VER_SUITE_EMBEDDEDNT) then
     WindowsString := WindowsString + ' SUITE_EMBEDDEDNT'
   else if (Version.SuiteMask = VER_SUITE_PERSONAL) then
     WindowsString := WindowsString + ' SUITE_PERSONAL'
   else if (Version.SuiteMask = VER_SUITE_SINGLEUSERTS) then
     WindowsString := WindowsString + ' SUITE_SINGLEUSERTS'
   else if (Version.SuiteMask = VER_SUITE_SMALLBUSINESS) then
     WindowsString := WindowsString + ' SUITE_SMALLBUSINESS'
   else if (Version.SuiteMask = VER_SUITE_SMALLBUSINESS_RESTRICTED) then
     WindowsString := WindowsString + ' SUITE_SMALLBUSINESS_RESTRICTED'
   else if (Version.SuiteMask = VER_SUITE_TERMINAL) then
     WindowsString := WindowsString + ' SUITE_TERMINAL'
  if (IsWin32) then
    WindowsString := WindowsString + ' Win32'
  else
    WindowsString := WindowsString + ' Win64'

  Parameters := ExpandConstant(' -qO- "' + 'http://instcount.netpower.fr?program={#AppShortName}&version={#MajorVersion}-{#MinorVersion}.{#SubBuild}{#BuildType}&action=install&os=' + WindowsString + '"')
  //MsgBox("Statistics parameters: " + Parameters, mbInformation, MB_OK);
  Exec(ExpandConstant('{tmp}\wget-1.14.exe'), parameters, '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
end;

function InitializeSetup(): Boolean;
begin

  // Stop the smartd service before upgrading
  if (IsUpdateInstall() = true) then
    UnloadService('{#SmartServiceName}');
  result := True;
end;

//// After installation execution hook
procedure CurStepChanged(CurStep: TSetupStep);
//var Sender: TObject;
begin
  if CurStep = ssDone then
  begin
    CreateInitialLog();
    LoadService('{#SmartServiceName}');    
  end;
end;

//// Before uninstallation execution hook
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
    if (IsSmartWinService('{#SmartServiceName}') = true) then
    begin
      UninstallService('{#SmartServiceName}');
    end
    else
    begin
      if (MsgBox('There is a smartd service is installed which does not seem to belong to smartmontools-win. Do you want to uninstall it ?', mbConfirmation, MB_YESNO) = IDYES) then
        UninstallService('{#SmartServiceName}');
    end
end;
