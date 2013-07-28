//// General purpose functions (2707201302)

[code]
//// Check if 64bit installation is not selected
function AMD64InstallNotSelected: Boolean;
begin
  Result := not IsComponentSelected('core\64bits');
end;

//// Returns last char of a string
function LastChar(str: String): String;
begin
  result := copy(str, Length(str), 1);
end; 

//// Starts service after installation
function LoadService(srv: String): Integer;
var resultcode: Integer;

begin
  Exec(ExpandConstant('{sys}\sc.exe'), 'start '+ srv, '', SW_HIDE, ewWaitUntilTerminated, resultcode);
  result := resultcode;
end;

//// Stops service and wait 2000ms before removing file to be sure it's not in use anymore
function UnloadService(srv: String): Integer;
var resultcode: Integer;

begin
  Exec(ExpandConstant('{sys}\sc.exe'), 'stop ' + srv, '', SW_HIDE, ewWaitUntilTerminated, resultcode);
  sleep(2000);
  result := resultcode;
end;

procedure Uninstallservice(srv: String);
var resultcode: Integer;

begin
  UnloadService(srv);
  Exec(ExpandConstant('{sys}\sc.exe'), 'delete ' + srv, '', SW_HIDE, ewWaitUntilTerminated, resultcode);
end;

//// Explode a string into an array using passed delimeter
function Explode(Text: String; Separator: String): TArrayOfString;
var
	i: integer;
  res: TArrayOfString;
  
begin
	i := 0;
	repeat
		SetArrayLength(res, i+1);
		if Pos(Separator,Text) > 0 then	begin
			res[i] := Copy(Text, 1, Pos(Separator, Text)-1);
			Text := Copy(Text, Pos(Separator,Text) + Length(Separator), Length(Text));
			i := i + 1;
		end else 
    begin
			 res[i] := Text;
			 Text := '';
		end;
	until Length(Text)=0;
  result := res;
end;

//// Implode an array into a string using a passed delimiter
function Implode(Arr: TArrayOfString; Separator: String): String;
var
  i: integer;
  res: String;
begin
  i := 0;
  res := '';
  repeat
    res := res + Arr[i] + Separator; 
    i := i + 1;
  until (i >= GetArrayLength(Arr));
  result := res;
end;

//// Returns commmand line arguments, usage: GetCommandLineParam('--test')
////("--test=value" will return "value", "-t value" will return "value", "-t" will return "yes"
function GetCommandLineParam(Param: string): String;
var
  CmdlineParamCount: Integer;
  
begin
  CmdlineParamCount := 0;
  
  while (CmdlineParamCount <= ParamCount) do
  begin
    if ((Param = Copy(ParamStr(CmdlineParamCount), 0, (Pos('=', ParamStr(CmdlineParamCount))) - 1)) or (Param = ParamStr(CmdlineParamCount))) then
    begin
      if (Pos('=',ParamStr(CmdlineParamCount)) > 0) then
      begin
        result := Copy(ParamStr(CmdlineParamCount), (Pos('=', ParamStr(CmdlineParamCount)) + 1), Length(ParamStr(CmdlineParamCount)));  
      end
      else if ((Copy(ParamStr(CmdlineParamCount + 1), 0, 1) <> '-') and (Copy(ParamStr(CmdlineParamCount + 1), 0, 1) <> '/') and (Length(ParamStr(CmdlineParamCount + 1)) > 0)) then
      //end else if ((Pos('-', ParamStr(CmdlineParamCount + 1)) <> 0) and (Length(ParamStr(CmdlineParamCount + 1)) > 0) and (Pos('/', ParamStr(CmdlineParamCount + 1)) <> 0)) then
      begin
        result := ParamStr(CmdlineParamCount + 1);
      end else
      begin
        result := 'yes';
      end;
    end;
    // and 
  //MsgBox(ParamStr(CmdlineParamCount), MbInformation, MB_OK);
  CmdlineParamCount := CmdlineParamCount + 1;
  end;
end;

// Determine if an earlier version of this program is already installed
function IsUpdateInstall(): Boolean;
begin
  Result := RegKeyExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\Uninstall\{#AppGUID}_is1') or RegKeyExists(HKEY_LOCAL_MACHINE, 'Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{#AppGUID}_is1');
end;

// Base64 encode and decode functions found at http://www.vincenzo.net/isxkb/index.php?title=Encode/Decode_Base64
const Codes64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

function Encode64(S: AnsiString): AnsiString;
var
	i: Integer;
	a: Integer;
	x: Integer;
	b: Integer;
begin
	Result := '';
	a := 0;
	b := 0;
	for i := 1 to Length(s) do
	begin
		x := Ord(s[i]);
		b := b * 256 + x;
		a := a + 8;
		while (a >= 6) do
		begin
			a := a - 6;
			x := b div (1 shl a);
			b := b mod (1 shl a);
			Result := Result + copy(Codes64,x + 1,1);
		end;
	end;
	if a > 0 then
	begin
		x := b shl (6 - a);
		Result := Result + copy(Codes64,x + 1,1);
	end;
	a := Length(Result) mod 4;
	if a = 2 then
		Result := Result + '=='
	else if a = 3 then
		Result := Result + '=';

end;

function Decode64(S: AnsiString): AnsiString;
var
	i: Integer;
	a: Integer;
	x: Integer;
	b: Integer;
begin
	Result := '';
	a := 0;
	b := 0;
	for i := 1 to Length(s) do
	begin
		x := Pos(s[i], codes64) - 1;
		if x >= 0 then
		begin
			b := b * 64 + x;
			a := a + 6;
			if a >= 8 then
			begin
				a := a - 8;
				x := b shr a;
				b := b mod (1 shl a);
				x := x mod 256;
				Result := Result + chr(x);
			end;
		end
	else
		Exit; // finish at unknown
	end;
end;