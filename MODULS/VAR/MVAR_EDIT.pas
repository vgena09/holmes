unit MVAR_EDIT;

interface

uses     
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Variants,
  Vcl.ActnList, Vcl.ImgList, Vcl.Controls, Vcl.Forms, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.Dialogs, Vcl.DBCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.Graphics {clColor},
  Data.DB, Data.Win.ADODB,
  FunType, MAIN, Vcl.Mask;

type
  TFVAR_EDIT = class(TForm)
    AList: TActionList;
    AVerify: TAction;
    MList: TListBox;
    AEditList: TAction;
    LList: TLabel;
    BtnEditList: TBitBtn;
    LName: TLabel;
    PEdit: TPanel;
    MEdit: TDBEdit;
    BtnVerify: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AEditListExecute(Sender: TObject);
    procedure AVerifyExecute(Sender: TObject);
    procedure MListClick(Sender: TObject);
    procedure MEditChange(Sender: TObject);
    procedure MListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
  private
    FFMAIN   : TFMAIN;
    DS       : TDataSource;
    PQVAR    : PADOQuery;
    PTSAV    : PADOTable;
    LParam   : TStringList;
    SCatList : String;          // Категория списка подстановки

    procedure SetItem;
  public
    procedure Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
  end;

var
  FVAR_EDIT: TFVAR_EDIT;

implementation

uses FunConst, FunText, FunList, FunBD, FunBDList, FunIni, FunSys, FunVerify;

{$R *.dfm}


{******************************************************************************}
{****************************  ВНЕШНЯЯ ФУНКЦИЯ  *******************************}
{******************************************************************************}
procedure TFVAR_EDIT.Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
var IsListFree, IsListFix, IsList : Boolean;
    S : String;
begin
    {Инициализация}
    PQVAR            := PPQVAR;
    PTSAV            := PPTSAV;
    DS.DataSet       := PQVAR^;
    LParam.Text      := PQVAR^.FieldByName(F_VAR_PARAM).AsString;
    MEdit.DataSource := DS;
    MEdit.DataField  := F_VAR_VAL_STR;
    MEdit.OnChange   := MEditChange;

    {Параметр: Список}
    LSectionCopy(@LParam, @MList.Items, F_VAR_PARAM_EDIT_VARIANTS);  // Если в виде секции
    IsListFix  := MList.Count > 0;
    IsListFree := false;
    If Not IsListFix then begin                                     // Если в виде параметра
       SCatList := LRead(@LParam, F_VAR_PARAM_EDIT_VARIANTS, '');
       If SCatList <> '' then begin
           SetItem;
           IsListFree := true;
       end;
    end;
    IsList := IsListFix OR IsListFree;
    LList.Visible := IsList;
    MList.Visible := IsList;

    {Параметр: Изменение - только при опции "Список"}
    S := 'ДА';
    If IsList then S := AnsiUpperCase(LRead(@LParam, F_VAR_PARAM_EDIT_CHANGE, S));
    If S <> 'НЕТ' then begin
       MEdit.ReadOnly      := false;
       MEdit.Enabled       := true;
       AEditList.Enabled   := IsListFree; BtnEditList.Visible := IsListFree;
       AVerify.Enabled     := true;       BtnVerify.Visible   := true;
    end else begin
       MEdit.ReadOnly      := true;
       MEdit.Enabled       := false;
       AEditList.Enabled   := false;  BtnEditList.Visible := false;
       AVerify.Enabled     := false;  BtnVerify.Visible   := false;
    end;
end;


{==============================================================================}
{==========================    СОЗДАНИЕ ФОРМЫ    ==============================}
{==============================================================================}
procedure TFVAR_EDIT.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN       := TFMAIN(GlFindComponent('FMAIN'));
    DS           := TDataSource.Create(Self);
    LParam       := TStringList.Create;
    LParam.CaseSensitive := false;

    With MEdit do begin
       Color      := FFMAIN.COLOR_SEL;
       //Font.Size  := 10;
       //Font.Style := [fsBold];
    end;

    With MList do begin
       Style      := lbOwnerDrawFixed;
       ItemHeight := 19;
       Sorted     := true;
       OnDrawItem := MListDrawItem;
    end;

    AList.Images       := FFMAIN.ImgSys16;
    AVerify.ImageIndex := ICO_VERIFY;
    BtnVerify.ShowHint := true;
end;


{==============================================================================}
{=========================    РАЗРУШЕНИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFVAR_EDIT.FormDestroy(Sender: TObject);
begin
    {Записываем значение переменной}
    PQVAR^.Refresh;

    {Освобождаем память}
    DS.Free;
    LParam.Free;
end;


{==============================================================================}
{==========================    EDIT: ON_CHANGE    =============================}
{==============================================================================}
procedure TFVAR_EDIT.MEditChange(Sender: TObject);
begin
    {Записываем значение переменной}
    PQVAR^.Refresh;
end;


procedure TFVAR_EDIT.MListClick(Sender: TObject);
var NEvent : TNotifyEvent;
    P      : TPoint;
    Ind    : Integer;
begin
    {Инициализация}
    If MList.SelCount=0 then Exit;
    Ind:=-1;

    {Реакция только при нахождении курсора в области выбора}
    If Sender<>nil then begin
       If GetCursorPos(P) = false then Exit;
       P   := MList.ScreenToClient(P);
       Ind := MList.ItemAtPos(P, true);
    end;
    If Ind=-1 then Exit;

    {Записываем значение переменной}
    NEvent := MEdit.OnChange;
    MEdit.OnChange := nil;
    With PQVAR^ do begin
       Edit;
       FieldByName(F_VAR_VAL_STR).AsString := MList.Items[Ind];
       UpdateRecord;
       Post;
    end;
    MEdit.OnChange := NEvent;
end;

procedure TFVAR_EDIT.SetItem;
begin
    MList.Items.BeginUpdate;
    MList.Items.Text := GetListItem(@FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(SCatList));
    MList.Items.EndUpdate;
end;


procedure TFVAR_EDIT.AEditListExecute(Sender: TObject);
begin
    {Обновляем категорию}
    RefreshListItem(@FFMAIN.BSET_LOCAL.TLIST, SCatList);
    {Обновляем список}
    SetItem;
end;


procedure TFVAR_EDIT.AVerifyExecute(Sender: TObject);
begin
    With PQVAR^ do begin
       Edit;
       FieldByName(F_VAR_VAL_STR).AsString := VerifyText(MEdit.Text, true, true, not ReadLocalBool(INI_SET, INI_SET_CHECK_WORD, false));
       UpdateRecord;
       Post;
    end;
end;


{==============================================================================}
{=====================          MLIST: ПЕРЕРИСОВКА       ======================}
{==============================================================================}
procedure TFVAR_EDIT.MListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
    With TListBox(Control) do begin
       If (Index mod 2 = 1)   then Canvas.Brush.Color := FFMAIN.COLOR_ODD
                              else Canvas.Brush.Color := clWindow;
    end;
    If odSelected IN State then TListBox(Control).Canvas.Brush.Color := FFMAIN.COLOR_SEL;
    With TListBox(Control) do begin
       Canvas.Font.Color := clBlack;
       Canvas.FillRect(Rect);
       Canvas.TextOut(Rect.Left+4, Rect.Top + 2, Items[Index]);
    end;
    If odFocused  IN State then DrawFocusRect(TListBox(Control).Canvas.Handle, Rect);
end;

end.
