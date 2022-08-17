unit MVAR_EXPERT;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Variants,
  Vcl.Forms, Vcl.Buttons, Vcl.ActnList, Vcl.Menus, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Dialogs,
  Data.DB, Data.Win.ADODB,
  FunType, FunConst, MAIN;

type
  TFVAR_EXPERT = class(TForm)
    Tree: TTreeView;
    PMenu: TPopupMenu;
    BtnQst: TBitBtn;
    AList: TActionList;
    A_Helper: TAction;
    A_Del: TAction;
    A_IncExp: TAction;
    A_IncQst: TAction;
    A_Edit: TAction;
    A_DelAll: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N7: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N13: TMenuItem;
    A_IncMat_PPerson: TAction;
    A_IncMat_Object: TAction;
    N3: TMenuItem;
    AIncMatPPerson1: TMenuItem;
    AIncMatObject1: TMenuItem;

    {Модуль: MVAR_EXPERT_TREE}
    procedure TreeDblClick(Sender: TObject);
    procedure TreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure TreeDragDrop(Sender, Source: TObject; X, Y: Integer);

    {Модуль: MVAR_EXPERT}
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    {Модуль: MVAR_EXPERT_ACTION}
    procedure A_HelperExecute(Sender: TObject);
    procedure A_IncExpExecute(Sender: TObject);
    procedure A_IncQstExecute(Sender: TObject);
    procedure A_DelExecute(Sender: TObject);
    procedure A_DelAllExecute(Sender: TObject);
    procedure PMenuPopup(Sender: TObject);
    procedure TreeMouseEnter(Sender: TObject);
    procedure A_EditExecute(Sender: TObject);
    procedure A_IncMat_PPersonExecute(Sender: TObject);
    procedure A_IncMat_ObjectExecute(Sender: TObject);

  private
    FFMAIN : TFMAIN;
    PQVAR  : PADOQuery;
    PTSAV  : PADOTable;
    IDVar  : String;

    {Модуль: MVAR_EXPERT_TREE}
    procedure IniTree;
    procedure WriteVar;
    procedure ReadVar;

    {Модуль: MVAR_EXPERT_ACTION}
    procedure EnablAction;
    procedure IncElement(const Section, Element: String);
    procedure EditElement(const N: TTreeNode);
    procedure EditMat(const Element: String; const Ind: Integer);

    {Модуль: MVAR_EXPERT}

  public
    procedure Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
  end;

const
  SECTIONS : array [0..2] of String = (F_VAR_STR_EXPERT_EXP, F_VAR_STR_EXPERT_QST, F_VAR_STR_EXPERT_MAT);

var
  FVAR_EXPERT: TFVAR_EXPERT;

implementation

uses FunBD, FunText, FunList, FunSys, FunTree, FunIDE, FunMemo,
     MVAR_UD_EDIT_PPERSON, MVAR_UD_EDIT_OBJECT,
     MVAR_EXPERT_HELPER,
     MVAR_UD;

{$R *.dfm}

{$INCLUDE MVAR_EXPERT_TREE}
{$INCLUDE MVAR_EXPERT_ACTION}

{******************************************************************************}
{****************************  ВНЕШНЯЯ ФУНКЦИЯ  *******************************}
{******************************************************************************}
procedure TFVAR_EXPERT.Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
begin
    {Инициализация}
    PQVAR         := PPQVAR;
    PTSAV         := PPTSAV;
    IDVar         := PQVAR^.FieldByName(F_COUNTER).AsString;

    {Загружаем Tree}
    ReadVar;
end;


{==============================================================================}
{===========================    СОЗДАНИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFVAR_EXPERT.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    BtnQst.ShowHint := true;
    IniTree;
end;


{==============================================================================}
{=========================    РАЗРУШЕНИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFVAR_EXPERT.FormDestroy(Sender: TObject);
begin
    {Сохраняем Tree}
    WriteVar;
end;


{==============================================================================}
{========================   СОБЫТИЕ: POPUP_MENU   =============================}
{==============================================================================}
procedure TFVAR_EXPERT.PMenuPopup(Sender: TObject);
begin
    {Доступность Action}
    EnablAction;
end;



end.
