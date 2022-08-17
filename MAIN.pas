unit MAIN;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.ActnList, Vcl.ToolWin, Vcl.ImgList, Vcl.StdCtrls, Vcl.Menus,
  IdGlobal, IdGlobalProtocols, {CopyFileTo}
  Data.DB, Data.Win.ADODB,
  FunType, FunSys, FunInfo;

type
  TBUD = record                 // ���� ��� - ���� ��� ������� ����
      BD       : TADOConnection;
      TSYS     : TADOTable;
      TDOC     : TADOTable;
      TVAR     : TADOTable;
      TPPERSON : TADOTable;
      TLPERSON : TADOTable;
      TDPERSON : TADOTable;
      TOBJECT  : TADOTable;
  end;
  PBUD = ^TBUD;

  TBSET_LOCAL = record          // ���� �������� ��������� - ���� ��� ������� ������������
      BD       : TADOConnection;
      TLIST    : TADOTable;
      TVAR     : TADOTable;
      TVAR_OLE : TADOTable;
  end;

  TBSET_GLOBAL = record        // ���� �������� ���������� - ����� ��� ����
      BD       : TADOConnection;
      TLSTATUS : TADOTable;
  end;

  TBEXP = record                // ���� ��������� - ����� ��� ����
      BD       : TADOConnection;
      TEXP     : TADOTable;
      TQST     : TADOTable;
      TORG     : TADOTable;
      TREL     : TADOTable;
  end;

  TBART = record                // ���� ����
      BD       : TADOConnection;
      TUK      : TADOTable;
      TCOM     : TADOTable;
//      TORG     : TADOTable;
//      TREL     : TADOTable;
  end;

  TFMAIN = class(TForm)
    StatusBar: TStatusBar;
    ImgSys16: TImageList;
    Icon: TTrayIcon;
    ActionList: TActionList;
    AVAR: TAction;
    ASET: TAction;
    PMain: TPanel;
    MainMenu: TMainMenu;
    NUD: TMenuItem;
    NDOC: TMenuItem;
    NSERV: TMenuItem;
    NSET: TMenuItem;
    NVAR: TMenuItem;
    ASET_OLE: TAction;
    AART: TAction;
    AEXP: TAction;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    TimerStart: TTimer;
    NSTRUCT: TMenuItem;
    AABOUT: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ASETExecute(Sender: TObject);
    procedure AVARExecute(Sender: TObject);
    procedure ASET_OLEExecute(Sender: TObject);
    procedure AARTExecute(Sender: TObject);
    procedure AEXPExecute(Sender: TObject);
    procedure StatusBarResize(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure AABOUTExecute(Sender: TObject);
  private

    function  IniPathUD: Boolean;

    {������:  MAIN_BD}
    function  IniBSET_LOCAL: Boolean;
    procedure FreeBSET_LOCAL;
    function  IniBSET_GLOBAL: Boolean;
    procedure FreeBSET_GLOBAL;
    function  IniBEXP: Boolean;
    procedure FreeBEXP;
    function  IniBART: Boolean;
    procedure FreeBART;
    function  IniHelp: Boolean;

  public
    WIN_VER     : TWinVer;        // ������ Windows
    OUT_VER     : Integer;        // ������ Office Outlook

    BUD         : TBUD;
    BSET_LOCAL  : TBSET_LOCAL;
    BSET_GLOBAL : TBSET_GLOBAL;
    BEXP        : TBEXP;
    BART        : TBART;

    COLOR_SEL   : TColor;
    COLOR_ODD   : TColor;

    {������:  MAIN}
    procedure IconMsg(const STitle, SMsg: String; const MsgType: TBalloonFlags);

  end;

var
  FMAIN: TFMAIN;

implementation

uses FunConst, FunBD, FunVcl, FunFiles, FunIni, FunDecoder, FunArt,
     MSPLASH, MABOUT, MCLOSE, MSET, MUD, MVAR, MVAR_OLE_EDIT;

{$R *.dfm}
{$INCLUDE MAIN_BD}


{==============================================================================}
{============================   �������� �����    =============================}
{==============================================================================}
procedure TFMAIN.FormCreate(Sender: TObject);
var F_SPLASH : TFSPLASH;

    procedure Er;
    var T : TCloseAction;
    begin
        try If (PATH_PROG<>'') then FormClose(Sender, T);
        finally
            Application.ProcessMessages;
            Application.Terminate;
            Halt;
        end;
    end;

begin
    {�������������}
    TimerStart.Enabled  := false;
    TimerStart.Interval := 2000;
    COLOR_SEL := RGB($FF, $D0, $D0);       // ���������� �������
    COLOR_ODD := RGB($F3, $F3, $FF);       // �������� �������

    {�������� �� ������ ���������}
    If GetProgRun then begin ErrMsg('��������� ��� ��������!'); Er; end;

    {���������� ��������}
    F_SPLASH := TFSPLASH.Create(Self);
    try try
       F_SPLASH.Show;

       {�������������}
       F_SPLASH.Msg('5%');

       {***  ������ Windows, Office  ******************************************}
       WIN_VER            := GetWinVer;

       {������}

       OUT_VER            := 7; //GetMSOfficeVer(msOutlook);         1.0.0.1 --> 1.0.0.2
       //If GetMSOfficeVer(msWord) = 0 then begin ErrMsg('�� ���������� Microsoft Word!'); Er; end;

       {***  ������� ���������  ***********************************************}
       PATH_PROG          := ExtractFilePath(Application.EXEName);

       {*** ������������� INI-����� ���������� �������� ***********************}
       PATH_PROG_INI      := PATH_PROG+PROG_INI;

       {*** ���� ���� ������ **************************************************}
       PATH_DATA          := PATH_PROG+FOLDER_DATA;
       PATH_DATA_DOC      := PATH_PROG+FOLDER_DATA_DOC;

       {***  ������������� �������� �������� �� ���������� ������������ *******}
       PATH_WORK          := GetPathMyDoc;
       If PATH_WORK='' then PATH_WORK := PATH_PROG
                       else PATH_WORK := PATH_WORK+'\';
       PATH_WORK          := PATH_WORK+FOLDER_MYDOC;
       If Not ForceDirectories(PATH_WORK) then begin ErrMsg('�� ���� ������� �������:'+CH_NEW+PATH_WORK); Er; end;

       {*** ������������� ���������� �������� *********************************}
       PATH_WORK_TEMP    := PATH_WORK+FOLDER_TEMP;
       DelDir(PATH_WORK_TEMP, true);
       If Not ForceDirectories(PATH_WORK_TEMP) then begin ErrMsg('�� ���� ������� �������:'+CH_NEW+PATH_WORK_TEMP); Er; end;

       {*** ������������� INI-����� ��������� �������� ************************}
       PATH_WORK_INI     := PATH_WORK+WORK_INI;

       {*** ������������� �������� � ������ ***********************************}
       If not IniPathUD then begin ASETExecute(nil); Er; end;

       {*** ����� �������������� **********************************************}
       IS_ADMIN := GetPathWritable(PATH_DATA) and ReadLocalBool(INI_SET, INI_SET_ADMIN, true); // ����� ����� ������ � ����� � ����� ���� �������
       If IS_ADMIN then StatusBar.Panels[STATUS_ADMIN].Text := '�����: �������������'
                   else StatusBar.Panels[STATUS_ADMIN].Text := '�����: ������������';

       {*** ������������� ������ **********************************************}
       F_SPLASH.Msg('25%');
       If Not IniHelp then Er;

       {*** ������������� �� �������� ��������� *******************************}
       F_SPLASH.Msg('35%');
       If Not IniBSET_LOCAL then Er;

       {*** ������������� �� �������� ���������� ******************************}
       F_SPLASH.Msg('45%');
       If Not IniBSET_GLOBAL then Er;

       {*** ������������� �� ��������� ****************************************}
       F_SPLASH.Msg('55%');
       If Not IniBEXP then Er;

       {*** ������������� �� ���� *********************************************}
       F_SPLASH.Msg('65%');
       If Not IniBART then Er;

       {*** ������������� �� ��� **********************************************}
       F_SPLASH.Msg('75%');
       BUD.BD       := TADOConnection.Create(Self);
       BUD.TSYS     := TADOTable.Create(Self);
       BUD.TDOC     := TADOTable.Create(Self);
       BUD.TVAR     := TADOTable.Create(Self);
       BUD.TPPERSON := TADOTable.Create(Self);
       BUD.TLPERSON := TADOTable.Create(Self);
       BUD.TDPERSON := TADOTable.Create(Self);
       BUD.TOBJECT  := TADOTable.Create(Self);

       NUD.Enabled  := false;
       NDOC.Enabled := false;

       {��������� ������-�����������}
       Icon.Visible := false;

       F_SPLASH.Hide;
    finally F_SPLASH.Free; end;
    except  Er;            end;
end;


{==============================================================================}
{==============================   ����� �����    ==============================}
{==============================================================================}
procedure TFMAIN.FormShow(Sender: TObject);
begin
    {��������������� ��������� �� Ini}
    LoadFormIni(Self, [fspPosition, fspState]);

    {��������� ��������}
    LoadSubForm(PMain, TFUD, true);

    {���� �� �������� ����}
    ForegroundWindow;

    {������ ������� ���������� ���������}
    TimerStart.Enabled := true;
end;


{==============================================================================}
{==========================   ������ �� �����    ==============================}
{==============================================================================}
procedure TFMAIN.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var FClose: TFCLOSE;
begin
    {������������� �� �����}
    If Sender<>nil then begin
       FCLOSE := TFCLOSE.Create(Self);
       try     CanClose := FCLOSE.Execute;
               If Not CanClose then Exit;
       finally FCLOSE.Free;
       end;
    end;

    {��������� ��������� � Ini}
    SaveFormIni(Self, [fspPosition, fspState]);
end;


{==============================================================================}
{============================   �������� �����    =============================}
{==============================================================================}
procedure TFMAIN.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    {��������� ��������}
    LoadSubForm(PMain, nil, true);

    {����������� ������}
    BUD.TSYS.Free; BUD.TDOC.Free; BUD.TVAR.Free; BUD.TPPERSON.Free;
    BUD.TLPERSON.Free; BUD.TDPERSON.Free; BUD.TOBJECT.Free;
    BUD.BD.Free;

    FreeBART;
    FreeBEXP;
    FreeBSET_LOCAL;
    FreeBSET_GLOBAL;

    {������� ��������� ����� � ������� ��������}
    DelDir(PATH_WORK_TEMP, true);
end;


{==============================================================================}
{=============================   ACTION: ASET   ===============================}
{==============================================================================}
procedure TFMAIN.ASETExecute(Sender: TObject);
var F: TFSET;
begin
    F:=TFSET.Create(Self);
    try     F.ShowModal;
    finally F.Free; end;

    {��������� ��������}
    If Sender <> nil then begin
       LoadSubForm(PMain, nil, true);
       If not IniPathUD then Exit;
       LoadSubForm(PMain, TFUD, true);
    end;
end;


{==============================================================================}
{=============================   ACTION: AVAR   ===============================}
{==============================================================================}
procedure TFMAIN.AVARExecute(Sender: TObject);
var F: TFVAR;
begin
    F := TFVAR.Create(Self);
    try     F.BtnOk.Visible := false;
            F.Caption       := AVAR.Caption;
            F.CBShowRun.Visible := true;
            F.Execute(@BSET_LOCAL.TVAR, nil, 0);
    finally F.Free;
    end;
end;


{==============================================================================}
{===========================   ACTION: ASET_OLE   =============================}
{==============================================================================}
procedure TFMAIN.ASET_OLEExecute(Sender: TObject);
var F: TFVAR_OLE_EDIT;
begin
    F := TFVAR_OLE_EDIT.Create(Self);
    try     F.ShowModal;
    finally F.Free; end;
end;


{==============================================================================}
{==========================   ACTION: ����������   ============================}
{==============================================================================}
procedure TFMAIN.AARTExecute(Sender: TObject);
begin
    InfoArt;
end;


{==============================================================================}
{==========================   ACTION: ����������   ============================}
{==============================================================================}
procedure TFMAIN.AEXPExecute(Sender: TObject);
begin
    //
end;


{==============================================================================}
{============================   ACTION: ABOUT   ===============================}
{==============================================================================}
procedure TFMAIN.AABOUTExecute(Sender: TObject);
var F: TFABOUT;
begin
    F := TFABOUT.Create(Self);
    try     F.ShowModal;
    finally F.Free;
    end;
end;



{==============================================================================}
{==============================   ���������    ================================}
{==============================================================================}
procedure TFMAIN.IconMsg(const STitle, SMsg: String; const MsgType: TBalloonFlags);
begin
    {�������������}
    If Trim(SMsg)='' then Exit;
    Icon.Animate      := true;
    Icon.Visible      := true;

    {��������� ���������}
    Icon.BalloonFlags := MsgType;
    Icon.BalloonTitle := STitle;
    Icon.BalloonHint  := SMsg;

    {���������� ���������}
    Icon.ShowBalloonHint;
end;


{==============================================================================}
{=======================   ������������� ������� ���     ======================}
{==============================================================================}
function TFMAIN.IniPathUD: Boolean;
var L: TStringList;
begin
    {�������������}
    Result  := false;
    PATH_UD := '';
    L := TStringList.Create;

    {������ ��������� ��������}
    try     If Not ReadSListIni(@L, '', INI_PATHS_UD) then Exit;
            If L.Count > 0 then PATH_UD := L[0];
    finally L.Free;
    end;

    {������ ���������� ��������}
    If PATH_UD = '' then PATH_UD := Trim(ReadGlobalString(GINI_SET, GINI_SET_PATH_UD, ''));
    If PATH_UD = '' then begin
       IconMsg('��������', '�� ������ ������� � ������.', bfWarning);
       Exit;
    end;

    {������� �������}
    If Not ForceDirectories(PATH_UD) then begin
       ErrMsg('�� ���� ������� �������:'+CH_NEW+PATH_UD);
       Exit;
    end;
    Result := true;
end;


{==============================================================================}
{=========================   STATUSBAR: ON_RESIZE     =========================}
{==============================================================================}
procedure TFMAIN.StatusBarResize(Sender: TObject);
var I, ILen: Integer;
begin
    ILen := StatusBar.ClientWidth;
    For I:=1 to StatusBar.Panels.Count-1 do ILen := ILen - StatusBar.Panels[I].Width;
    StatusBar.Panels[0].Width := ILen;
end;

{==============================================================================}
{=============================   TIMER: START     =============================}
{==============================================================================}
procedure TFMAIN.TimerStartTimer(Sender: TObject);
var SList: TStringList;
begin
    TimerStart.Enabled := false;

    {����������}
    SList := TStringList.Create;
    try     ReadGlobalSection(GINI_INFO_RUN, @SList);
            If SList.Count > 0 then IconMsg('�����!', SList.Text, bfWarning);
    finally SList.Free;
    end;

    {��������� ����������}
    If ReadLocalBool(INI_VAR, INI_VAR_SHOWRUN, true) then AVAR.Execute;
end;

end.
