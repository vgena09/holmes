unit MDOC_NEW;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl, // CommCtrl - TVIS_CUT
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus,
  Vcl.FileCtrl, //SelectDirectory
  Data.DB, Data.Win.ADODB,
  FunType, FunConst, MAIN;

type
  TFDOC_NEW = class(TForm)
    AList: TActionList;
    AOk: TAction;
    ACancel: TAction;
    AExpand: TAction;
    ACollapse: TAction;
    AFindClear: TAction;
    APath: TAction;
    PMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    PFind: TPanel;
    PPath: TPanel;
    PBottom: TPanel;
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    BtnClose: TBitBtn;
    BtnPath: TBitBtn;
    LFind: TLabel;
    LPath: TLabel;
    LInfo: TLabel;
    EFind: TEdit;
    EPath: TComboBox;
    TreeDoc: TTreeView;
    AOpenDoc: TAction;
    AOpenIni: TAction;
    N3: TMenuItem;
    NShablon: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    AOpenFolder: TAction;
    N7: TMenuItem;

    {Модуль: MDOC_NEW_PATH}
    procedure EPathChange(Sender: TObject);
    procedure APathExecute(Sender: TObject);

    {Модуль: MDOC_NEW_TREE}
    procedure TreeDocChange(Sender: TObject; Node: TTreeNode);
    procedure TreeDocDblClick(Sender: TObject);
    procedure TreeDocKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeDocCompare(Sender: TObject; Node1, Node2: TTreeNode; Data: Integer; var Compare: Integer);
    procedure AExpandExecute(Sender: TObject);
    procedure ACollapseExecute(Sender: TObject);

    {Модуль: MDOC_NEW}
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure AOkExecute(Sender: TObject);
    procedure ACancelExecute(Sender: TObject);
    procedure AFindClearExecute(Sender: TObject);
    procedure EFindChange(Sender: TObject);
    procedure AOpenDocExecute(Sender: TObject);
    procedure AOpenIniExecute(Sender: TObject);
    procedure AOpenFolderExecute(Sender: TObject);
  private
    FFMAIN : TFMAIN;

    {Модуль: MDOC_NEW_PATH}
    procedure IniPath;
    procedure SetPath(const SPath: String);

    {Модуль: MDOC_NEW_TREE}
    procedure IniTree;
    procedure RefreshTree;

    {Модуль: MDOC_NEW}
    procedure EnablAction;
  public
    function  SelectDoc: String;
  end;

const L_IND : array [0..1] of Integer = (0,        1);
      L_EXT : array [0..1] of String  = ('.doc',   '.docx');
      L_ICO : array [0..1] of Integer = (ICO_WORD, ICO_WORD);

      MAX_PATH_COUNT = 15;

var
  FDOC_NEW: TFDOC_NEW;

implementation

uses FunSys, FunBD, FunText, FunTree, FunIni, FunList;

{$R *.dfm}
{$INCLUDE MDOC_NEW_PATH}
{$INCLUDE MDOC_NEW_TREE}

{==============================================================================}
{=============================   ВНЕШНЯЯ ФУНКЦИЯ   ============================}
{==============================================================================}
{===========   Result  - полный путь, если '' - ничего не выбрано    ==========}
{==============================================================================}
function TFDOC_NEW.SelectDoc: String;
var N: TTreeNode;
begin
    Result := '';
    If ShowModal <> mrOk then Exit;

    N := TreeDoc.Selected;
    If N = nil then Exit;
    If Integer(N.Data) >= Low(L_IND) then Result := EPath.Text+ExcludeTrailingBackslash(GetNodePath(@N))+L_EXT[Integer(N.Data)];
end;


{==============================================================================}
{=============================   СОЗДАНИЕ ФОРМЫ    ============================}
{==============================================================================}
procedure TFDOC_NEW.FormCreate(Sender: TObject);
begin
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));

    With EFind do begin
       Clear;
       OnChange := EFindChange;
    end;

    IniPath;
    IniTree;
end;


{==============================================================================}
{==============================   ПОКАЗ ФОРМЫ    ==============================}
{==============================================================================}
procedure TFDOC_NEW.FormShow(Sender: TObject);
begin
    {Восстанавливаем настройки из Ini}
    LoadFormIni(Self, [fspPosition], 450, 700);
    {Заполняем Tree}
    RefreshTree;
end;


{==============================================================================}
{=============================   СКРЫТИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFDOC_NEW.FormHide(Sender: TObject);
begin
    {Сохраняем настройки в Ini}
    SaveFormIni(Self, [fspPosition]);
end;



{==============================================================================}
{==========================  ACTION: ДОСТУПНОСТЬ  =============================}
{==============================================================================}
procedure TFDOC_NEW.EnablAction;
var IsOK, IsIni : Boolean;
    N           : TTreeNode;
begin
    IsOk  := false;
    IsIni := false;
    try
       If TreeDoc.Selected = nil then Exit;
       IsOk := (Integer(TreeDoc.Selected.Data) > ID_DIR);
       If IsOk then begin
          N     := TreeDoc.Selected;
          IsIni := FileExists(EPath.Text+ExcludeTrailingBackslash(GetNodePath(@N))+'.ini');
       end;
    finally
       AOk.Enabled      := IsOk;
       AOpenDoc.Enabled := IsOk;
       AOpenIni.Enabled := IsIni;
    end;
end;


{==============================================================================}
{====================   ACTION: РЕДАКТИРОВАТЬ ШАБЛОН    =======================}
{==============================================================================}
procedure TFDOC_NEW.AOpenDocExecute(Sender: TObject);
var N : TTreeNode;
    S : String;
begin
    N := TreeDoc.Selected;
    If N = nil then Exit;
    If Integer(N.Data) <= ID_DIR then Exit;

    S := EPath.Text+ExcludeTrailingBackslash(GetNodePath(@N))+L_EXT[Integer(N.Data)];
    If FileExists(S) then StartAssociatedExe(S, SW_MAXIMIZE);
end;


{==============================================================================}
{========================   ACTION: ОТКРЫТЬ ПАПКУ    ==========================}
{==============================================================================}
procedure TFDOC_NEW.AOpenFolderExecute(Sender: TObject);
var N : TTreeNode;
    S : String;
begin
    N := TreeDoc.Selected;
    If N = nil then Exit;
    S := EPath.Text+ExcludeTrailingBackslash(GetNodePath(@N))+L_EXT[Integer(N.Data)];
    StartAssociatedExe('"'+ExtractFilePath(S)+'"', SW_SHOWNORMAL);
end;

{==============================================================================}
{===================   ACTION: РЕДАКТИРОВАТЬ НАСТРОЙКИ    ======================}
{==============================================================================}
procedure TFDOC_NEW.AOpenIniExecute(Sender: TObject);
var N : TTreeNode;
    S : String;
begin
    N := TreeDoc.Selected;
    If N = nil then Exit;
    If Integer(N.Data) <= ID_DIR then Exit;

    S := EPath.Text+ExcludeTrailingBackslash(GetNodePath(@N))+'.ini';
    If FileExists(S) then StartAssociatedExe(S, SW_SHOWNORMAL);
end;


{==============================================================================}
{=============================   ACTION: BUTTON    ============================}
{==============================================================================}
procedure TFDOC_NEW.AOkExecute(Sender: TObject);
begin
    ModalResult := mrOK;
end;

procedure TFDOC_NEW.ACancelExecute(Sender: TObject);
begin
    ModalResult := mrCancel;
end;


{==============================================================================}
{=============================   ACTION: FIND    ==============================}
{==============================================================================}
procedure TFDOC_NEW.EFindChange(Sender: TObject);
begin
    RefreshTree;
end;

procedure TFDOC_NEW.AFindClearExecute(Sender: TObject);
begin
    EFind.Text := '';
end;


end.
