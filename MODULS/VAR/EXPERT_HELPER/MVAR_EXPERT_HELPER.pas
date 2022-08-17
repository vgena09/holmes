unit MVAR_EXPERT_HELPER;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl, // CommCtrl - TVIS_CUT
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.ActnList, Vcl.Menus, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Dialogs, Vcl.DBCtrls, Vcl.CheckLst,
  Vcl.Graphics {clRed},
  Data.DB, Data.Win.ADODB,
  FunType, FunDecoder, MAIN;

type
  TFVAR_EXPERT_HELPER = class(TForm)
    PMenu: TPopupMenu;
    AList: TActionList;
    A_DeselAll: TAction;
    A_SelAll: TAction;
    A_Mat: TAction;
    N6: TMenuItem;
    N3: TMenuItem;
    PBtn: TPanel;
    BtnCancel: TBitBtn;
    BtnOk: TBitBtn;
    PTop: TPanel;
    PMat: TPanel;
    LMat: TLabel;
    BtnMat: TBitBtn;
    PInv: TPanel;
    LInv: TLabel;
    BtnInv: TBitBtn;
    PExp: TPanel;
    LExp: TLabel;
    BtnExp: TBitBtn;
    EInv: TComboBox;
    EExp: TComboBox;
    LExpInfo: TLabel;
    LMatInfo: TLabel;
    LInvInfo: TLabel;
    EMat: TEdit;
    AExpInfo: TAction;
    Tree: TTreeView;
    LInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    {Модуль: MVAR_EXPERT_HELPER_TREE}
    procedure TreeClick(Sender: TObject);
    procedure TreeDblClick(Sender: TObject);
    procedure TreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure TreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure A_SelAllExecute(Sender: TObject);
    procedure A_DeselAllExecute(Sender: TObject);

    {Модуль: MVAR_EXPERT_HELPER_EDIT}
    procedure RefreshMAT;
    procedure EInvChange(Sender: TObject);
    procedure EExpChange(Sender: TObject);
    procedure A_MatExecute(Sender: TObject);
    procedure AExpInfoExecute(Sender: TObject);
    procedure BtnListClick(Sender: TObject);
    procedure CBoxSetItem;
    procedure LInfoClick(Sender: TObject);

    {Модуль: MVAR_EXPERT_HELPER}


  private
    FFMAIN     : TFMAIN;
    DS         : TDataSource;
    PQVAR      : PADOQuery;
    PTSAV      : PADOTable;
    QExp, QQst : TADOQuery;

    LOldMat, LOldExp, LOldQst: TStringList;  // Старые значения
    LNewMat, LNewExp, LNewQst: TStringList;  // Новые  значения


    {Модуль: MVAR_EXPERT_HELPER_TREE}
    procedure IniTREE;
    procedure FreeTREE;
    procedure RefreshTREE;
    procedure EditElement(const N: TTreeNode);
    procedure SetAllChk(const Val: Boolean);

    {Модуль: MVAR_EXPERT_HELPER_EDIT}
    procedure IniEDIT;
    procedure FreeEDIT;

    {Модуль: MVAR_EXPERT_HELPER_SQL}
    function  SetSQLExp: Boolean;
    function  SetSQLQst: Boolean;

    {Модуль: MVAR_EXPERT_HELPER}
    procedure EnablAction;

  public
    procedure Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
  end;

const TEMP_VAR_NAME = 'QST';
      S_SEPARAT     = ': ';
var
  FVAR_EXPERT_HELPER: TFVAR_EXPERT_HELPER;

implementation

uses FunConst, FunSys, FunBD, FunText, FunList, FunBDList, FunIni, FunIDE,
     FunMemo, FunVcl, FunTree, FunInfo,
     MVAR_UD;

{$R *.dfm}

{$INCLUDE MVAR_EXPERT_HELPER_EDIT}
{$INCLUDE MVAR_EXPERT_HELPER_TREE}
{$INCLUDE MVAR_EXPERT_HELPER_SQL}


{******************************************************************************}
{****************************  ВНЕШНЯЯ ФУНКЦИЯ  *******************************}
{******************************************************************************}
procedure TFVAR_EXPERT_HELPER.Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
var LResult : TStringList;
    IsOk    : Boolean;
    I       : Integer;
begin
    {Инициализация}
    PQVAR      := PPQVAR;
    PTSAV      := PPTSAV;
    DS.DataSet := PQVAR^;

    LResult := TStringList.Create;
    try
       LResult.Text := PQVAR^.FieldByName(F_VAR_VAL_STR).AsString;
       LSectionCopy(@LResult, @LOldMat, F_VAR_STR_EXPERT_MAT);
       LSectionCopy(@LResult, @LOldExp, F_VAR_STR_EXPERT_EXP);
       LSectionCopy(@LResult, @LOldQst, F_VAR_STR_EXPERT_QST);
       LResult.Clear;

       LNewMat.Text := LOldMat.Text;
       LNewExp.Clear;
       LNewQst.Clear;

       RefreshMAT;
       If not SetSQLExp then Exit;

       {Исследование не задано}
       EInv.Text:='';
       EInvChange(nil);

       {Восстанавливаем настройки из Ini}
       LoadFormIni(Self, [fspPosition], Screen.Width Div 4 * 3, Screen.Height Div 6 * 5);

       {Показ формы}
       IsOk := ShowModal = mrOk;

       {Если изменены материалы, то сохранение по-любому}
       If (not IsOk) and CmpStr(LOldMat.Text, LNewMat.Text) then Exit;

       {Получаем результаты}
       LNewExp.Text := Trim(CutSlovo(EExp.Text, 1, S_SEPARAT));
       For I:=0 to Tree.Items.Count-1 do If GetTreeNodeCheck(Tree.Items[I]) then LNewQst.Add(Tree.Items[I].Text);

       {Собираем результаты в структуру}
       LOldMat.Text := LNewMat.Text;
       LAddUniq(@LOldExp, @LNewExp);
       LAddUniq(@LOldQst, @LNewQst);

       If LOldMat.Count > 0 then LResult.Text := LResult.Text+'['+F_VAR_STR_EXPERT_MAT+']'+CH_NEW+LOldMat.Text;
       If LOldExp.Count > 0 then LResult.Text := LResult.Text+'['+F_VAR_STR_EXPERT_EXP+']'+CH_NEW+LOldExp.Text;
       If LOldQst.Count > 0 then LResult.Text := LResult.Text+'['+F_VAR_STR_EXPERT_QST+']'+CH_NEW+LOldQst.Text;

       {Сохраняем структуру}
       With PQVAR^ do begin
          Edit;
          FieldByName(F_VAR_VAL_STR).AsString := LResult.Text;
          UpdateRecord;
          Post;
       end;

    finally
       LResult.Free;
    end;
end;


{==============================================================================}
{==========================    СОЗДАНИЕ ФОРМЫ    ==============================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN  := TFMAIN(GlFindComponent('FMAIN'));
    DS      := TDataSource.Create(Self);

    LOldMat := TStringList.Create;      LNewMat := TStringList.Create;
    LOldExp := TStringList.Create;      LNewExp := TStringList.Create;
    LOldQst := TStringList.Create;      LNewQst := TStringList.Create;

    QExp    := TADOQuery.Create(Self);  QExp.Connection := FFMAIN.BEXP.BD;
    QQst    := TADOQuery.Create(Self);  QQst.Connection := FFMAIN.BEXP.BD;

    IniTREE;
    IniEDIT;

    BtnOk.ModalResult     := mrOk;
    BtnCancel.ModalResult := mrCancel;
end;


{==============================================================================}
{=========================    РАЗРУШЕНИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.FormDestroy(Sender: TObject);
begin
    {Сохраняем настройки в Ini}
    SaveFormIni(Self, [fspPosition]);
    FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := '';

    {Освобождаем память}
    FreeEDIT;
    FreeTREE;

    LOldMat.Free; LOldExp.Free; LOldQst.Free;
    LNewMat.Free; LNewExp.Free; LNewQst.Free;

    If QExp.Active then QExp.Close; QExp.Free;
    If QQst.Active then QQst.Close; QQst.Free;

    DS.DataSet.Refresh;  //Для обновления редактируемых перед закрытием полей
    DS.Free;
end;


{==============================================================================}
{====================  ДОСТУПНОСТЬ ЭЛЕМЕНТОВ ACTION  ==========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.EnablAction;
var IsSelAll, IsDeselAll : Boolean;
    I : Integer;
begin
    AExpInfo.Enabled :=  EExp.Text <> '';
    IsSelAll         := false;
    IsDeselAll       := false;

    {Action: Всё Checked}
    For I:=0 to Tree.Items.Count-1 do begin
       If not GetTreeNodeCheck(Tree.Items[I]) then begin
          IsSelAll:=true;
          Break;
       end;
    end;

    {Action: Всё UnChecked}
    For I:=0 to Tree.Items.Count-1 do begin
       If GetTreeNodeCheck(Tree.Items[I]) then begin
          IsDeselAll:=true;
          Break;
       end;
    end;

    {Доступность Action}
    A_SelAll.Enabled   := IsSelAll;
    A_DeselAll.Enabled := IsDeselAll;
    BtnOk.Enabled      := IsDeselAll;
end;

end.
