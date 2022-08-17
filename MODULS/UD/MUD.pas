unit MUD;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl {TVIS_CUT},
  System.SysUtils, System.Variants, System.Classes, System.Math {RandomRange},
  IdGlobalProtocols, {CopyFileTo}
  DateUtils, {TimeOf}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Dialogs, Vcl.ActnList, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.OleServer, OutlookXP,
  Data.DB, Data.Win.ADODB,
  FunConst, FunType, MAIN;

type
  TFUD = class(TForm)
    Splitter1: TSplitter;
    PMain: TPanel;
    PUD: TPanel;
    TreeUD: TTreeView;
    PFinder: TPanel;
    AList: TActionList;
    AUDAdd: TAction;
    AUDCopy: TAction;
    AUDMove: TAction;
    ARefresh: TAction;
    AOpenDir: TAction;
    AFind: TAction;
    ABreak: TAction;
    AFinder: TAction;
    AFinderHide: TAction;
    PMenu: TPopupMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    SaveDlg: TSaveDialog;
    TimerOpenUD: TTimer;
    AUDPass: TAction;
    N9: TMenuItem;
    AUDDat: TAction;
    N11: TMenuItem;
    N5: TMenuItem;
    N10: TMenuItem;
    N2: TMenuItem;
    BtnClose: TBitBtn;
    BtnFind: TButton;
    EFind: TComboBox;
    AOutlook: TAction;
    NOutlook: TMenuItem;

    {Модуль: MUD_TREE}
    procedure TreeUDChange(Sender: TObject; Node: TTreeNode);
    procedure TreeUDCompare(Sender: TObject; Node1, Node2: TTreeNode; Data: Integer; var Compare: Integer);
    procedure TreeUDCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TreeUDMouseEnter(Sender: TObject);

    {Модуль: MUD_FINDER}
    procedure AFinderExecute(Sender: TObject);
    procedure AFinderHideExecute(Sender: TObject);
    procedure AFindExecute(Sender: TObject);
    procedure ABreakExecute(Sender: TObject);
    procedure EFindKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EFindChange(Sender: TObject);

    {Модуль: MUD_OUTLOOK}
    procedure AOutlookExecute(Sender: TObject);

    {Модуль: MUD}
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AUDAddExecute(Sender: TObject);
    procedure AUDCopyExecute(Sender: TObject);
    procedure AUDMoveExecute(Sender: TObject);
    procedure ARefreshExecute(Sender: TObject);
    procedure AOpenDirExecute(Sender: TObject);
    procedure TimerOpenUDTimer(Sender: TObject);
    procedure PUDResize(Sender: TObject);
    procedure AUDPassExecute(Sender: TObject);
    procedure AUDDatExecute(Sender: TObject);

  private
    FFMAIN    : TFMAIN;
    IsBreak   : Boolean;
    IsOpenVar : Boolean;   // Автоматически запускать окно переменных при открытии
    SPathUD   : String;

    {Модуль: MUD_TREE}
    procedure IniTree;
    procedure RefreshTreeUD;
    function  GetSelectedPath: String;
    function  FullPathToTreePath(const SPath: String): String;

    {Модуль: MUD_FINDER}
    procedure IniFinder;

    {Модуль: MUD_OUTLOOK}
    procedure SyncControl;


    {Модуль: MUD}
    procedure EnablAction;
    procedure OpenUD(const SPath: String);
    procedure CloseUD;
  public

  end;

const ID_MDB  = 0;
      L_IND : array [0..0] of Integer = (ID_MDB);
      L_EXT : array [0..0] of String  = ('.mdb');
      L_ICO : array [0..0] of Integer = (ICO_UD);

var
  FUD: TFUD;

implementation

uses FunSys, FunVcl, FunText, FunIni, FunBD, FunTree, FunInfo, FunFiles,
     FunOutlook, FunWait,
     MDOC, MPASS, MVAR;

{$R *.dfm}
{$INCLUDE MUD_TREE}
{$INCLUDE MUD_FINDER}
{$INCLUDE MUD_OUTLOOK}


{==============================================================================}
{============================   СОЗДАНИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFUD.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    TimerOpenUD.Enabled := false;
    IsOpenVar           := false;
    SPathUD             := '';
    SaveDlg.Filter      := 'Дела (*.mdb)|*.mdb';
    SaveDlg.DefaultExt  := '.mdb';

    NOutlook.Visible    := false;
    CopyMenu(@PMenu.Items, @FFMAIN.NUD);
    FFMAIN.NUD.Enabled := true;

    IniTree;
    IniFinder;

    PUD.Width    := ReadLocalInteger(INI_UD, INI_UD_WIDTH, PUD.Width);
    PUD.Align    := alLeft;
    PUD.OnResize := PUDResize;
end;

{==============================================================================}
{==============================   ПОКАЗ ФОРМЫ    ==============================}
{==============================================================================}
procedure TFUD.FormShow(Sender: TObject);
begin
    //
end;



{==============================================================================}
{============================   ЗАКРЫТИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFUD.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    FFMAIN.NUD.Enabled := false;
    FFMAIN.NUD.Clear;
    CloseUD();
    FFMAIN.StatusBar.Panels[STATUS_UD].Text := '';
end;


{==============================================================================}
{==========================  ACTION: ДОСТУПНОСТЬ  =============================}
{==============================================================================}
procedure TFUD.EnablAction;
var IsPath, IsUD : Boolean;
begin
    IsPath := PATH_UD <> '';
    AUDAdd.Enabled := IsPath;
    AFind.Enabled  := IsPath and (Trim(EFind.Text) <> '') and (TreeUD.Items.Count > 0);

    IsUD := false;
    try
       If TreeUD.Selected = nil then Exit;
       IsUD := TreeUD.Selected.ImageIndex = ICO_UD;
    finally
       AUDCopy.Enabled := IsUD;
       AUDMove.Enabled := IsUD;

       AUDDat .Enabled := IsUD;
       AUDPass.Enabled := IsUD;
    end;
end;


{==============================================================================}
{=========================  ACTION: СОЗДАТЬ ДЕЛО  =============================}
{==============================================================================}
procedure TFUD.AUDAddExecute(Sender: TObject);
var SSrc, SDect: String;
begin
    {Инициализация}
    If PATH_UD = '' then Exit;

    {Выбираем дело}
    SaveDlg.Title      := 'Создать дело';
    SaveDlg.InitialDir := PATH_UD;
    SaveDlg.FileName   := '';
    If Not SaveDlg.Execute then Exit;
    SDect := SaveDlg.FileName;

    {Копируем эталонное дело}
    SSrc := PATH_DATA+FILE_BD_UD;
    If Not FileExists(SSrc)        then begin ErrMsg('Не найден файл:'+CH_NEW+SSrc); Exit; end;
    If Not CopyFileTo(SSrc, SDect) then begin ErrMsg('Ошибка копирования:'+CH_NEW+'из: '+SSrc+CH_NEW+'в:  '+SDect); Exit; end;
    try FileSetAttr(SDect, 0); except end; {Убираем возможные атрибуты !!!!! ПРИ ЛЮБОМ ИЗМЕНЕНИИ ТРЕБУЕТСЯ ПОЛНАЯ ПЕРЕКОМПИЛЯЦИЯ С КОМПОНЕНТАМИ !!!!!}

    {Открываем новое дело}
    WriteLocalString(INI_UD, INI_UD_SELECT_TREE, FullPathToTreePath(SDect));
    IsOpenVar := true;   // автоматически открыть окно переменных
    RefreshTreeUD;
end;


{==============================================================================}
{========================  ACTION: КОПИРОВАТЬ ДЕЛО  ===========================}
{==============================================================================}
procedure TFUD.AUDCopyExecute(Sender: TObject);
var SSrc, SDect: String;
begin
    {Инициализация}
    SSrc := GetSelectedPath;
    If SSrc = '' then Exit;

    {Выбираем дело}
    With SaveDlg do begin
       Title      := 'Копировать дело';
       InitialDir := ExtractFilePath(SSrc);
       FileName   := ExtractFileName(SSrc);
       If Not Execute then Exit;
       SDect := FileName;
    end;

    {Предупреждение при наличии файла}
    If FileExists(SDect) then begin
       If MessageDlg('Файл назначения ['+SDect+']'+CH_NEW+'уже существует и будет заменен.'+CH_NEW+CH_NEW+
                     'Подтвердите замену!' , mtWarning, [mbOK, mbCancel], 0) <> mrOk then Exit;
    end;

    {Копируем дело}
    CloseUD();
    try
       If Not CopyFileTo(SSrc, SDect) then begin ErrMsg('Ошибка копирования:'+CH_NEW+'из: '+SSrc+CH_NEW+'в:  '+SDect); Exit; end;
       try FileSetAttr(SDect, 0); except end; {Убираем возможные атрибуты !!!!! ПРИ ЛЮБОМ ИЗМЕНЕНИИ ТРЕБУЕТСЯ ПОЛНАЯ ПЕРЕКОМПИЛЯЦИЯ С КОМПОНЕНТАМИ !!!!!}
       RefreshTreeUD;
    finally
       OpenUD(SSrc);
    end;
end;


{==============================================================================}
{========================  ACTION: ПЕРЕМЕСТИТЬ ДЕЛО  ==========================}
{==============================================================================}
procedure TFUD.AUDMoveExecute(Sender: TObject);
var SSrc, SDect : String;
begin
    {Инициализация}
    SSrc := GetSelectedPath;
    If SSrc = '' then Exit;

    {Выбираем дело}
    SaveDlg.Title      := 'Переместить дело';
    SaveDlg.InitialDir := ExtractFilePath(SSrc);
    SaveDlg.FileName   := ExtractFileName(SSrc);
    If Not SaveDlg.Execute then Exit;
    SDect := SaveDlg.FileName;

    {Предупреждение при наличии файла}
    If FileExists(SDect) then begin
       If MessageDlg('Файл назначения ['+SDect+']'+CH_NEW+'уже существует и будет заменен.'+CH_NEW+CH_NEW+
                     'Подтвердите замену!' , mtWarning, [mbOK, mbCancel], 0) <> mrOk then Exit;
    end;

    {Перемещаем дело}
    CloseUD();
    try
       If Not CopyFileTo(SSrc, SDect) then begin ErrMsg('Ошибка перемещения:'+CH_NEW+'из: '+SSrc+CH_NEW+'в:  '+SDect); Exit; end;
       try FileSetAttr(SDect, 0); except end; {Убираем возможные атрибуты !!!!! ПРИ ЛЮБОМ ИЗМЕНЕНИИ ТРЕБУЕТСЯ ПОЛНАЯ ПЕРЕКОМПИЛЯЦИЯ С КОМПОНЕНТАМИ !!!!!}
       DeleteFile(SSrc);
       WriteLocalString(INI_UD, INI_UD_SELECT_TREE, FullPathToTreePath(SDect));
       RefreshTreeUD;
    finally
       OpenUD(SDect);
    end;
end;


{==============================================================================}
{==========================  ACTION: ПЕРЕМЕННЫЕ  ==============================}
{==============================================================================}
procedure TFUD.AUDDatExecute(Sender: TObject);
var F : TFVAR;
    Q : TADOQuery;
begin
    F := TFVAR.Create(Self);
    Q := TADOQuery.Create(Self);
    try
       Q.Connection := FFMAIN.BUD.BD;
       Q.SQL.Text   :=
          'SELECT * FROM ['+T_UD_VAR+'] '+
          'WHERE ['+F_VAR_DOC+'] is Null '+
          'ORDER BY ['+F_VAR_CAPTION+'] ASC;';
       Q.Open;
       F.BtnOk.Visible := false;
       F.Caption       := AUDDat.Caption;
       F.Execute(@Q, nil, 0);
    finally
       If Q.Active then Q.Close; Q.Free;
       F.Free;
    end;
end;


{==============================================================================}
{============================  ACTION: ПАРОЛЬ  ================================}
{==============================================================================}
procedure TFUD.AUDPassExecute(Sender: TObject);
var FPASS: TFPASS;
    SSrc, SOld, SNew: String;
begin
    {Инициализация}
    SSrc := GetSelectedPath;
    If SSrc = '' then Exit;

    {Спрашиваем пароли}
    FPASS := TFPASS.Create(Self);
    try     If not FPASS.Execute(SOld, SNew) then Exit;  //SOld := Trim(InputBox('Старый пароль', #30+'', ''));
    finally FPASS.Free; end;

    {Смена пароля}
    CloseUD();
    SetPassBD(SSrc, SOld, SNew);
    OpenUD(SSrc);
end;


{==============================================================================}
{============================  ACTION: ОБНОВИТЬ  ==============================}
{==============================================================================}
procedure TFUD.ARefreshExecute(Sender: TObject);
begin
    SaveTreeSelect(@TreeUD, INI_UD, INI_UD_SELECT_TREE);
    RefreshTreeUD;
end;


{==============================================================================}
{=========================  ACTION: ОТКРЫТЬ ПАПКУ  ============================}
{==============================================================================}
procedure TFUD.AOpenDirExecute(Sender: TObject);
var N : TTreeNode;
    S : String;
begin
    N:=TreeUD.Selected;
    If N = nil then Exit;
    S := PATH_UD+GetNodePath(@N);
    If N.ImageIndex = ICO_UD then begin
       N := N.Parent;
       S := PATH_UD+GetNodePath(@N);
    end;
    StartAssociatedExe('"'+S+'"', SW_SHOWNORMAL);
end;


{==============================================================================}
{=============================  ОТКРЫТИЕ ДЕЛА   ===============================}
{==============================================================================}
procedure TFUD.OpenUD(const SPath: String);
begin
    SPathUD             := SPath;
    TimerOpenUD.Enabled := true;
end;

{==============================================================================}
{=========================  TIMER: ОТКРЫТИЕ ДЕЛА   ============================}
{==============================================================================}
procedure TFUD.TimerOpenUDTimer(Sender: TObject);
var S: String;
   function FunOpen(const SPas: String): Boolean;
   begin
      Result  := OpenBD(@FFMAIN.BUD.BD, SPathUD, SPas,
                [@FFMAIN.BUD.TSYS, @FFMAIN.BUD.TDOC,   @FFMAIN.BUD.TVAR, @FFMAIN.BUD.TPPERSON, @FFMAIN.BUD.TLPERSON, @FFMAIN.BUD.TDPERSON, @FFMAIN.BUD.TOBJECT],
                [T_UD_SYS,         T_UD_DOC,           T_UD_VAR,         T_UD_PPERSON,         T_UD_LPERSON,         T_UD_DPERSON,         T_UD_OBJECT]);
   end;
begin
    TimerOpenUD.Enabled:= false;
    CloseUD();

    {Если дело не открыто}
    If not FunOpen('') then begin
       {Может нужен пароль}
       TreeUD.Items.EndUpdate;
       try     S := Trim(InputBox('Возможно дело защищено паролем', #30+'Пароль для дела'+CH_NEW+'[ '+ExtractFileNameWithoutExt(SPathUD)+' ]', ''));
       finally TreeUD.Items.BeginUpdate; end;
       If S = '' then Exit;
       If not FunOpen(S) then begin PMain.Caption := 'Ошибка открытия дела: '+CH_NEW+SPathUD; Exit; end;
    end;

    {Синхронизация}
    SyncControl;
    FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := '';

    {Отображаем документы}
    PMain.Caption := SPathUD;
    LoadSubForm(PMain, TFDOC, true);

    {Открытие окна переменных}
    If IsOpenVar then begin
       IsOpenVar := false;
       AUDDat.Execute;
    end;
end;


{==============================================================================}
{=============================  ЗАКРЫТИЕ ДЕЛА   ===============================}
{==============================================================================}
procedure TFUD.CloseUD;
var IsPack: Boolean;
begin
    TimerOpenUD.Enabled:= false;
    LoadSubForm(PMain, nil, true);
    SyncControl;
    Case ReadLocalInteger(INI_SET, INI_SET_PACK_UD, 1) of
    0:   IsPack := true;
    1:   IsPack := (RandomRange(0, 10) > 7);
    else IsPack := false;
    end;
    CloseBD(@FFMAIN.BUD.BD, [@FFMAIN.BUD.TSYS, @FFMAIN.BUD.TDOC, @FFMAIN.BUD.TVAR, @FFMAIN.BUD.TPPERSON, @FFMAIN.BUD.TLPERSON, @FFMAIN.BUD.TDPERSON, @FFMAIN.BUD.TOBJECT], IsPack);
    PMain.Caption := 'Дело не выбрано';
end;


{==============================================================================}
{======================  ИЗМЕНЕНИЕ РАЗМЕРОВ ОКНА UD   =========================}
{==============================================================================}
procedure TFUD.PUDResize(Sender: TObject);
begin
    WriteLocalInteger(INI_UD, INI_UD_WIDTH, PUD.Width);
end;

end.
