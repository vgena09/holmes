unit FunSys;

interface

uses
   Winapi.Windows, Winapi.Messages, Winapi.ShlObj, Winapi.ShellApi, Winapi.ActiveX,
   System.SysUtils, System.Variants, System.Classes, System.IniFiles,
   System.Win.Registry,
   Vcl.Forms, Vcl.Controls, Vcl.Graphics, Vcl.Dialogs, Vcl.ExtCtrls {TPanel},
   Vcl.Menus,
   IdGlobal, IdGlobalProtocols,
   FunType;


type
   {������������ �����������}
   TUniqueReader = Class(TReader)
      LastRead: TComponent;
      procedure ComponentRead(Component: TComponent);
      procedure SetNameUnique(Reader: TReader; Component: TComponent; var Name: string);
   end;

   {���������� ����� ����������}
   function  GlFindComponent(const CName: TComponentName): TComponent;
   function  FindChildComponent(var CParent: TComponent; const CName: TComponentName): TComponent;

   function  DuplicateComponents(AComponent: TComponent): TComponent;
   function  StrToBoolMy(const S: String): Boolean;
   function  BoolToStrMy(const B: Boolean): String;

   procedure StartAssociatedExe(const FPath: String; const ShowCmd: Integer);
   function  StartAssociatedAndWait(const FPath: String; const ShowCmd: Integer): Boolean;
   function  ExecAndWait(const FileName, Params: String; const WinState: Word): Boolean;

   function  GetKeyState(const vKey: Integer): Boolean;

   function  CopyFileToTemp(const SSrc: String): String;

   procedure CopyMenu(const PSrc, PDesc: PMenuItem);

implementation

{!!! �� ������ ���� El-�����������, ��� ��� �������� ��� ������ �� DLL !!!}
uses FunConst, FunText, FunVcl, FunIni, FunFiles;


{==============================================================================}
{=====================  ����������  �����  ����������  ========================}
{==============================================================================}
function GlFindComponent(const CName: TComponentName): TComponent;
begin
   Result:=FindChildComponent(TComponent(Application), CName);
end;


{==============================================================================}
{=========================   �����  ����������   ==============================}
{==============================================================================}
function FindChildComponent(var CParent: TComponent; const CName: TComponentName): TComponent;
var I       : Integer;
    TComp   : TComponent;
    CNameUp : String;
begin
    {�������������}
    Result  := nil;
    CNameUp := AnsiUpperCase(CName);

    {��������� ��� ����������}
    For I:=0 to CParent.ComponentCount-1 do begin

       {��������� ��� �������������}
       If AnsiUpperCase(CParent.Components[I].Name)=CNameUP then begin
          Result:=CParent.Components[I];
          Break;
       end;

       {��������� ����� �����������������}
       TComp:=CParent.Components[I];
       TComp:=FindChildComponent(TComp, CName);
       If TComp<>nil then begin
          Result:=TComp;
          Break;
       end;
    end;
end;


{==============================================================================}
{=============  � � � � � � � � � � � �   � � � � � � � � � � �  ==============}
{==============================================================================}
procedure TUniqueReader.ComponentRead(Component: TComponent);
begin
   LastRead := Component;
end;

// ������ ���������� ��� ������������ ����������, ��������, "Panel2", ���� "Panel1" ��� ����������
procedure TUniqueReader.SetNameUnique(Reader: TReader; Component: TComponent; var Name: string);
var i        : Integer;
    tempname : string;
begin
    i := 0;
    tempname := Name;
    while Component.Owner.FindComponent(Name) <> nil do begin
       Inc(i);
       Name := Format('%s%d', [tempname, i]);
    end;
end;

function DuplicateComponents(AComponent: TComponent): TComponent;
     procedure RegisterComponentClasses(AComponent: TComponent);
     var i : integer;   
     begin
         RegisterClass(TPersistentClass(AComponent.ClassType));
         if AComponent is TWinControl then
            if TWinControl(AComponent).ControlCount > 0 then
               for i := 0 to (TWinControl(AComponent).ControlCount-1) do
                   RegisterComponentClasses(TWinControl(AComponent).Controls[i]);
     end;
var Stream       : TMemoryStream;
    UniqueReader : TUniqueReader;
    Writer       : TWriter;
begin
    result := nil;
    UniqueReader := nil;
    Writer := nil;
    Stream := TMemoryStream.Create;
    try
       RegisterComponentClasses(AComponent);
       try
          Writer := TWriter.Create(Stream, 4096);
          Writer.Root := AComponent.Owner;
          Writer.WriteSignature;
          Writer.WriteComponent(AComponent);
          Writer.WriteListEnd;
       finally
          Writer.Free;
       end;
       Stream.Position := 0;
       try
          UniqueReader := TUniqueReader.Create(Stream, 4096);     // ������� �����, ������������ ������ � ���������� � �����������
          UniqueReader.OnSetName := UniqueReader.SetNameUnique;
          UniqueReader.LastRead := nil;
          if AComponent is TWinControl then
               UniqueReader.ReadComponents(TWinControl(AComponent).Owner,
                                           TWinControl(AComponent).Parent,
                                           UniqueReader.ComponentRead)
          else UniqueReader.ReadComponents(AComponent.Owner,
                                           nil,
                                           UniqueReader.ComponentRead);
          result := UniqueReader.LastRead;
       finally
          UniqueReader.Free;
       end;
    finally
       Stream.Free;
    end;
end;


{==============================================================================}
{====================    �������  STRING  �  BOOLEAN     ======================}
{==============================================================================}
function StrToBoolMy(const S: String): Boolean;
begin
    Result:=IsStrInArray(S, ['TRUE', '������', '��']);
end;


{==============================================================================}
{====================    �������  BOOLEAN  �  STRING     ======================}
{==============================================================================}
function BoolToStrMy(const B: Boolean): String;
begin
    If B then Result:='true' else Result:='false';
end;


{==============================================================================}
{=======================  ������ �������� ����������   ========================}
{==============================================================================}
{============  ShowCmd - SW_SHOWMAXIMIZED, SW_SHOWNORMAL, ...   ===============}
{==============================================================================}
procedure StartAssociatedExe(const FPath: String; const ShowCmd: Integer);
begin
    ShellExecute(Application.Handle, 'open', PChar(FPath), nil, nil, ShowCmd);
end;


{==============================================================================}
{=======  ������ ���������������� ���������� � �������� ��� ����������  =======}
{==============================================================================}
{============  ShowCmd - SW_SHOWMAXIMIZED, SW_SHOWNORMAL, ...   ===============}
{==============================================================================}
function StartAssociatedAndWait(const FPath: String; const ShowCmd: Integer): Boolean;
var SEInfo : TShellExecuteInfo;
    ExCode : DWORD;
begin
    {�������������}
    Result:=false;
    FillChar(SEInfo, SizeOf(SEInfo), 0);
    SEInfo.cbSize := SizeOf(TShellExecuteInfo);
    With SEInfo do begin
       fMask  := SEE_MASK_NOCLOSEPROCESS;
       Wnd    := Application.Handle;
       lpFile := PChar(FPath);
       nShow  := ShowCmd;
    end;

    {��������� ����������}
    If Not ShellExecuteEx(@SEInfo) then Exit;

    {������� ���������� ����������}
    repeat GetExitCodeProcess(SEInfo.hProcess, ExCode);
    until (ExCode <> STILL_ACTIVE) or Application.Terminated;

    {������������ ���������}
    Result:=true;
end;


{==============================================================================}
{=====      ������ �������� ���������� � �������� ��� ����������         ======}
{==============================================================================}
{===== WinState - SW_HIDE, SW_MAXIMIZE, SW_MINIMIZE, SW_SHOWNORMAL       ======}
{==============================================================================}
function ExecAndWait(const FileName, Params: String; const WinState: Word): Boolean;
var StartInfo : TStartupInfo;
    ProcInfo  : TProcessInformation;
    CmdLine   : String;
begin
    {�������� ��� ����� ����� ���������, � ����������� ���� �������� � ������ Win9x }
    CmdLine := '"' + Filename + '" ' + Params;
    FillChar(StartInfo, SizeOf(StartInfo), #0);
    With StartInfo do begin
      cb          := SizeOf(StartUPInfo); //(SUInfo);
      dwFlags     := STARTF_USESHOWWINDOW;
      wShowWindow := WinState;
    end;
    Result := CreateProcess(nil, PChar(String(CmdLine)), nil, nil, false,
                            CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                            PChar(ExtractFilePath(Filename)), StartInfo, ProcInfo);

    {������� ���������� ����������}
    If Result then begin
       WaitForSingleObject(ProcInfo.hProcess, INFINITE);
       CloseHandle(ProcInfo.hProcess);
       CloseHandle(ProcInfo.hThread);
  end;
end;


{==============================================================================}
{==========================  ������ �� �������  ===============================}
{==============================================================================}
function GetKeyState(const vKey: Integer): Boolean;
begin
    Result := GetAsyncKeyState(vKey) <> 0;    // VK_LCONTROL
end;


{==============================================================================}
{=============  �������� ����� ����� SSrc �� ��������� �������  ===============}
{==============================================================================}
function CopyFileToTemp(const SSrc: String): String;
var SDect : String;
begin
    {�������������}
    Result:='';

    {������� ��������� �����}
    SDect := TempFileName(PATH_WORK_TEMP+ExtractFileNameWithoutExt(SSrc), ExtractFileExt(SSrc));
    If Not ForceDirectories(ExtractFilePath(SDect)) then begin ErrMsg('������ �������� ��������: '+ExtractFilePath(SDect)); Exit; end;
    If Not CopyFileTo(SSrc, SDect)                  then begin ErrMsg('������ �������� ����� ������: '+SDect); Exit; end;

    {������������ ���������}
    Result:=SDect;
end;



{==============================================================================}
{===========================  ���������� ����  ================================}
{==============================================================================}
procedure CopyMenu(const PSrc, PDesc: PMenuItem);
var NSrc, NDesc : TMenuItem;
    I : Integer;
begin
    If (PSrc = nil) or (PDesc = nil) then Exit;
    PDesc^.Clear;
    For I := 0 to PSrc^.Count-1 do begin
       NSrc  := PSrc^[I];
       NDesc := TMenuItem.Create(PDesc^);
       NDesc.Caption := NSrc.Caption;
       NDesc.Action  := NSrc.Action;
       PDesc^.Add(NDesc);
       If NSrc.Count > 0 then CopyMenu(@NSrc, @NDesc);
    end;
end;

end.

