unit MSET;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.FileCtrl, Vcl.Graphics {clRed},
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Data.DB, Data.Win.ADODB,
  MAIN, Vcl.ActnList;

type
  TFSET = class(TForm)
    PBottom: TPanel;
    BtnClose: TBitBtn;
    BtnReset: TBitBtn;
    AList: TActionList;
    AReset: TAction;
    PControl: TPageControl;
    TSUser: TTabSheet;
    TSAdmin: TTabSheet;
    PUser: TPanel;
    PPathUD: TPanel;
    LPathUD: TLabel;
    BtnPathUD: TBitBtn;
    EPathUD: TComboBox;
    PPack: TPanel;
    LPack: TLabel;
    EPack: TComboBox;
    PWordZoom: TPanel;
    LWordZoom: TLabel;
    EWordZoom: TEdit;
    UpDownWordZoom: TUpDown;
    PWordInterface: TPanel;
    LWordInterface: TLabel;
    CBWordInterface: TCheckBox;
    PAdministrator: TPanel;
    LAdministrator: TLabel;
    CBAdministrator: TCheckBox;
    PAdmin: TPanel;
    PContact: TPanel;
    LContact: TLabel;
    EContact: TEdit;
    PInfo: TPanel;
    LInfo: TLabel;
    EInfo: TMemo;
    PBase: TPanel;
    LBase: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    ABDExpert: TAction;
    ABDNorm: TAction;
    ABDSetLocal: TAction;
    ABDNewUD: TAction;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ABDSetGlobal: TAction;
    POutlook: TPanel;
    LOutlook: TLabel;
    CBOutlook: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure CBWordInterfaceClick(Sender: TObject);
    procedure CBWordInterfaceKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CBAdministratorClick(Sender: TObject);
    procedure CBAdministratorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EWordZoomChange(Sender: TObject);
    procedure BtnPathUDClick(Sender: TObject);
    procedure EPathUDChange(Sender: TObject);
    procedure EPackChange(Sender: TObject);
    procedure KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AResetExecute(Sender: TObject);
    procedure ABDExpertExecute(Sender: TObject);
    procedure ABDNormExecute(Sender: TObject);
    procedure ABDSetLocalExecute(Sender: TObject);
    procedure ABDNewUDExecute(Sender: TObject);
    procedure ABDSetGlobalExecute(Sender: TObject);
    procedure CBOutlookClick(Sender: TObject);
    procedure CBOutlookKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FFMAIN  : TFMAIN;
    IsWrite : Boolean;
  public

  end;

var
  FSET : TFSET;

implementation

uses FunConst, FunSys, FunVcl, FunText, FunBD, FunIni, FunFiles, FunArt;

{$R *.dfm}


{==============================================================================}
{=============================   СОЗДАНИЕ ФОРМЫ    ============================}
{==============================================================================}
procedure TFSET.FormCreate(Sender: TObject);
begin
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := ' Настройка программы';
    IsWrite := GetPathWritable(PATH_DATA);

    With EPathUD do begin
       Style         := csDropDownList;
       DropDownCount := 20;
       OnChange      := EPathUDChange;
    end;

    With EPack do begin
       Style         := csDropDownList;
       Items.Text    := 'Всегда'+CH_NEW+'Иногда'+CH_NEW+'Никогда';
       OnChange      := EPackChange;
    end;

    With CBWordInterface do begin
       OnClick       := CBWordInterfaceClick;
       OnKeyDown     := CBWordInterfaceKeyDown;
    end;

    With CBOutlook do begin
       OnClick       := CBOutlookClick;
       OnKeyDown     := CBOutlookKeyDown;
    end;

    With CBAdministrator do begin
       OnClick       := CBAdministratorClick;
       OnKeyDown     := CBAdministratorKeyDown;
    end;

    BtnPathUD.Hint        := 'Редактировать каталог';
    BtnPathUD.ShowHint    := true;

    BtnClose.OnKeyDown    := KeyDown;

    BtnReset.Action       := AReset;
    BtnReset.Font.Color   := clRed;

    TSAdmin.Brush.Color   := clGray;
end;


{==============================================================================}
{===============================   ПОКАЗ ФОРМЫ    =============================}
{==============================================================================}
procedure TFSET.FormShow(Sender: TObject);
begin
    ReadCBListIni(@EPathUD, INI_PATHS_UD);
    If EPathUD.Items.Count=0 then EPathUD.Items.Add(Trim(ReadGlobalString(GINI_SET, GINI_SET_PATH_UD, PATH_PROG+'УД\')));
    EPathUD.ItemIndex := 0;

    EPack.ItemIndex         := ReadLocalInteger(INI_SET, INI_SET_PACK_UD,    1);
    CBWordInterface.Checked := ReadLocalBool   (INI_SET, INI_SET_CHECK_WORD, false);

    With CBOutlook do begin
       Checked          := ReadLocalBool(INI_SET, INI_SET_OUTLOOK, false);
       Enabled          := FFMAIN.OUT_VER <> 0;
       LOutlook.Enabled := FFMAIN.OUT_VER <> 0;
    end;

    CBAdministrator.Checked := IS_ADMIN;
    PAdministrator.Visible  := IsWrite;

    With UpDownWordZoom do begin
       Min       := 30;
       Max       := 300;
       Associate := EWordZoom;
    end;

    With EWordZoom do begin
       ReadOnly       := true;
       OnChange       := nil;
       Text           := ReadLocalString(INI_SET, INI_SET_ZOOM_WORD, '100');
       OnChange       := EWordZoomChange;
    end;

    {Администратор}
    EContact.Text     := ReadGlobalString(GINI_SET, GINI_SET_CONTACT, '');
    ReadGlobalSection(GINI_INFO_RUN, @EInfo.Lines);

    ABDSetLocal.Enabled := false;


    TSAdmin.TabVisible  := IS_ADMIN;
    PControl.ActivePage := TSUser;

    BtnClose.Left     := (PBottom.ClientWidth - BtnClose.Width) Div 2;
end;


{==============================================================================}
{==============================   СКРЫТИЕ ФОРМЫ    ============================}
{==============================================================================}
procedure TFSET.FormHide(Sender: TObject);
begin
    If IsWrite then begin
       WriteGlobalString(GINI_SET, GINI_SET_CONTACT, EContact.Text);
       WriteGlobalSection(GINI_INFO_RUN, @EInfo.Lines);
    end;
    FFMAIN.StatusBar.Panels[STATUS_MAIN].Text:='';
end;


{==============================================================================}
{======================   ЗАКЛАДКА: ОСНОВНЫЕ НАСТРОЙКИ   ======================}
{==============================================================================}

{==============================================================================}
{============================   ПУТЬ К ДЕЛАМ   ================================}
{==============================================================================}
procedure TFSET.BtnPathUDClick(Sender: TObject);
var SPath : String;
    IFind : Integer;
begin
    {Диалог выбора каталога}
    SPath := EPathUD.Text;
    If not SelectDirectory('Расположение уголовных дел', '\', SPath, [sdNewFolder, sdNewUI, sdShowEdit, sdValidateDir]) then Exit;    //, sdShowShares
    SPath := IncludeTrailingBackslash(Trim(SPath));
    Refresh;

    {Корректируем список}
    IFind := EPathUD.Items.IndexOf(SPath);
    If IFind >= 0 then EPathUD.Items.Delete(IFind);
    EPathUD.Items.Insert(0, SPath);
    For IFind:=EPathUD.Items.Count-1 downto 20 do EPathUD.Items.Delete(IFind);
    EPathUD.ItemIndex := 0;

    {Сохраняем список}
    WriteCBListIni(@EPathUD, INI_PATHS_UD);
end;

procedure TFSET.EPathUDChange(Sender: TObject);
begin
    {Корректируем список}
    If EPathUD.ItemIndex = 0 then Exit;
    EPathUD.Items.Move(EPathUD.ItemIndex, 0);
    EPathUD.ItemIndex := 0;

    {Сохраняем список}
    WriteCBListIni(@EPathUD, INI_PATHS_UD);
end;


{==============================================================================}
{=========================   СЖАТИЕ ФАЙЛА ДЕЛА   ==============================}
{==============================================================================}
procedure TFSET.EPackChange(Sender: TObject);
begin
    WriteLocalInteger(INI_SET, INI_SET_PACK_UD, EPack.ItemIndex);
end;


{==============================================================================}
{=============================   WORD-МАСШТАБ   ===============================}
{==============================================================================}
procedure TFSET.EWordZoomChange(Sender: TObject);
begin
    WriteLocalString(INI_SET, INI_SET_ZOOM_WORD, EWordZoom.Text);
end;


{==============================================================================}
{=========================   WORD-ИНТЕРФЕЙС ПРВЕРКИ   =========================}
{==============================================================================}
procedure TFSET.CBWordInterfaceClick(Sender: TObject);
begin
    WriteLocalBool(INI_SET, INI_SET_CHECK_WORD, CBWordInterface.Checked);
end;

procedure TFSET.CBWordInterfaceKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    CBWordInterfaceClick(Sender);
end;




{==============================================================================}
{========================   КОНТРОЛЬ СРОКОВ В OUTLOOK   =========================}
{==============================================================================}
procedure TFSET.CBOutlookClick(Sender: TObject);
begin
    WriteLocalBool(INI_SET, INI_SET_OUTLOOK, CBOutlook.Checked);
end;

procedure TFSET.CBOutlookKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    CBOutlookClick(Sender);
end;



{==============================================================================}
{=======================   РЕЖИМ АДМИНИСТРАТОРА   =============================}
{==============================================================================}
procedure TFSET.CBAdministratorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    CBAdministratorClick(Sender);
end;

procedure TFSET.CBAdministratorClick(Sender: TObject);
begin
    If CBAdministrator.Checked=IS_ADMIN then Exit;
    If MessageDlg('Подтвердите изменение признака работы в сети!'+CH_NEW+'Потребуется перезапуск программы.', mtInformation, [mbYes, mbNo], 0)=mrYes then begin
       WriteLocalBool(INI_SET, INI_SET_ADMIN, CBAdministrator.Checked);
       Hide;
       Application.ProcessMessages;
       Application.Terminate;
    end else begin
       CBAdministrator.Checked:=IS_ADMIN;
    end;
end;



{==============================================================================}
{========================   ОТКРЫТЬ БАЗУ ДАННЫХ   =============================}
{==============================================================================}
procedure TFSET.ABDExpertExecute(Sender: TObject);
begin StartAssociatedExe(PATH_DATA+FILE_BD_EXP, SW_MAXIMIZE); end;

procedure TFSET.ABDNewUDExecute(Sender: TObject);
begin StartAssociatedExe(PATH_DATA+FILE_BD_UD, SW_MAXIMIZE); end;

procedure TFSET.ABDNormExecute(Sender: TObject);
begin StartAssociatedExe(PATH_DATA+FILE_BD_ART, SW_MAXIMIZE); end;

procedure TFSET.ABDSetGlobalExecute(Sender: TObject);
begin StartAssociatedExe(PATH_DATA+FILE_BD_SET_GLOBAL, SW_MAXIMIZE); end;

procedure TFSET.ABDSetLocalExecute(Sender: TObject);
begin StartAssociatedExe(PATH_DATA+FILE_BD_SET_LOCAL, SW_MAXIMIZE); end;


{==============================================================================}
{===============================   KEY_DOWN   =================================}
{==============================================================================}
procedure TFSET.KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    27: {ESC} ModalResult := mrClose;
    end;
end;


{==============================================================================}
{=====================   ACTION: СБРОСИТЬ НАСТРОЙКИ   =========================}
{==============================================================================}
procedure TFSET.AResetExecute(Sender: TObject);
var Action: TCloseAction;
begin
    If MessageDlg('Подтвердите сброс индивидуальных настроек!'+CH_NEW+'Потребуется перезапуск программы.', mtInformation, [mbYes, mbNo], 0)=mrYes then begin
       Hide;
       Application.ProcessMessages;
       Action := caNone;
       FFMAIN.FormClose(nil, Action);
       DelDir(PATH_WORK, true);
       Application.ProcessMessages;
       Application.Terminate;
       Halt;
    end;
end;


end.
