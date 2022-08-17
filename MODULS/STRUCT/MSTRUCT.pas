unit MSTRUCT;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl {TVIS_BOLD},
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Data.DB, Data.Win.ADODB,
  FunType, FunConst, MAIN, Vcl.ComCtrls, Vcl.Menus, Vcl.ActnList;

type
  TFSTRUCT = class(TForm)
    Tree: TTreeView;
    PMenu: TPopupMenu;
    AList: TActionList;
    AAdd_PPerson: TAction;
    AAdd_LPerson: TAction;
    AAdd_DPerson: TAction;
    AAdd_Object: TAction;
    ADel: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    AOpen: TAction;
    N7: TMenuItem;

    {Модуль: MSTRUCT_TREE}
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure TreeDblClick(Sender: TObject);
    procedure TreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TreeMouseEnter(Sender: TObject);

    {Модуль: MSTRUCT}
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AAdd_PPersonExecute(Sender: TObject);
    procedure AAdd_LPersonExecute(Sender: TObject);
    procedure AAdd_DPersonExecute(Sender: TObject);
    procedure AAdd_ObjectExecute(Sender: TObject);
    procedure ADelExecute(Sender: TObject);
    procedure AOpenExecute(Sender: TObject);
  private
    FFMAIN   : TFMAIN;

    {Модуль: MSTRUCT_TREE}
    procedure IniTree;
    procedure SaveSel;
    procedure LoadSel;

    {Модуль: MSTRUCT}
    procedure EnablAction;
    procedure AAdd(const IDTable: Integer);

  public
    {Модуль: MSTRUCT_TREE}
    procedure RefreshTree;

  end;

var
  FSTRUCT : TFSTRUCT;

implementation

uses FunSys, FunBD, FunTree, FunIDE, FunInfo, FunText,
     MVAR_UD_EDIT_PPERSON, MVAR_UD_EDIT_LPERSON, MVAR_UD_EDIT_DPERSON,
     MVAR_UD_EDIT_OBJECT;

{$R *.dfm}
{$INCLUDE MSTRUCT_TREE}


{==============================================================================}
{============================   СОЗДАНИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFSTRUCT.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));

    CopyMenu(@PMenu.Items, @FFMAIN.NSTRUCT);
    FFMAIN.NSTRUCT.Enabled := true;

    IniTree;
end;


{==============================================================================}
{============================   ЗАКРЫТИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFSTRUCT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    FFMAIN.NSTRUCT.Enabled := false;
    FFMAIN.NSTRUCT.Clear;
    FFMAIN.StatusBar.Panels[STATUS_STRUCT].Text := '';
end;




{==============================================================================}
{==========================  ACTION: ДОСТУПНОСТЬ  =============================}
{==============================================================================}
procedure TFSTRUCT.EnablAction;
var IsSel : Boolean;
    N     : TTreeNode;
begin
    IsSel := false;
    N := Tree.Selected;
    If N <> nil then IsSel := (N.Level = 1);

    AOpen.Enabled := IsSel;
    ADel.Enabled  := IsSel;
end;


{==============================================================================}
{============================  ACTION: ДОБАВИТЬ  ==============================}
{==============================================================================}
procedure TFSTRUCT.AAdd_PPersonExecute(Sender: TObject);
begin AAdd(LTAB_UD_PPERSON); end;

procedure TFSTRUCT.AAdd_LPersonExecute(Sender: TObject);
begin AAdd(LTAB_UD_LPERSON); end;

procedure TFSTRUCT.AAdd_DPersonExecute(Sender: TObject);
begin AAdd(LTAB_UD_DPERSON); end;

procedure TFSTRUCT.AAdd_ObjectExecute(Sender: TObject);
begin AAdd(LTAB_UD_OBJECT); end;

procedure TFSTRUCT.AAdd(const IDTable: Integer);
var Q : TADOQuery;
    S : String;
    I : Integer;
begin
    S := Trim(InputBox('Создание элемента: '+LTAB_UD[IDTable], LTAB_UD_KEY[IDTable], ''));
    If S = '' then Exit;
    Q := TADOQuery.Create(Self);
    try
       With Q do begin
          Connection := FFMAIN.BUD.BD;
          SQL.Text := 'SELECT * FROM ['+LTAB_UD[IDTable]+'];';
          Open;
          Insert;
          FieldByName(LTAB_UD_KEY[IDTable]).AsString := S;
          Case IDTable of
          LTAB_UD_PPERSON: FieldByName(PPERSON_STATE).AsString := PPERSON_STATE_WITNESS;
          LTAB_UD_LPERSON: FieldByName(LPERSON_STATE).AsString := LPERSON_STATE_CLAIM;
          LTAB_UD_DPERSON: FieldByName(DPERSON_STATE).AsString := DPERSON_STATE_ADVOCATE;
          end;
          UpdateRecord;
          Post;
          I := FieldByName(F_COUNTER).AsInteger;
       end;
    finally
       If Q.Active then Q.Close;
       Q.Free;
    end;
    {Обязательно обновляем таблицу}
    RefreshTabUD(@FFMAIN.BUD, LTAB_UD[IDTable]);
    {Выделение на созданный элемент}
    TableWriteVar(@FFMAIN.BUD.TSYS, F_UD_SYS_STRUCT_SEL, IntToStr(IDTable) + ' ' + IntToStr(I));
    {Обновляем дерево}
    RefreshTree;
    {Редактируем созданный элемент}
    TreeDblClick(nil);
end;

{==============================================================================}
{=============================  ACTION: УДАЛИТЬ  ==============================}
{==============================================================================}
procedure TFSTRUCT.ADelExecute(Sender: TObject);
var Q : TADOQuery;
    IDTable, IDElement : Integer;

   function CanDelElementUD: Boolean;
   var QDOC : TADOQuery;
       S    : String;
       I    : Integer;
   begin
       {Инициализация}
       Result := false;

       {Формируем запрос на поиск всех переменных, содержащих элемент, за исключением IDVar}
       QDOC := TADOQuery.Create(Self);
       try
          With QDOC do begin
             Connection := FFMAIN.BUD.BD;
             S := 'SELECT DISTINCT ['+T_UD_DOC+'].['+F_COUNTER+'], ['+T_UD_DOC+'].['+F_UD_DOC_CAPTION+'],'+CH_NEW+
                                  '['+T_UD_VAR+'].['+F_COUNTER+'], ['+T_UD_VAR+'].['+F_VAR_CAPTION+']'+CH_NEW+
                           'FROM   ['+T_UD_DOC+'] INNER JOIN ['+T_UD_VAR+'] ON ['+T_UD_DOC+'].['+F_COUNTER+'] = ['+T_UD_VAR+'].['+F_VAR_DOC+']'+CH_NEW+
                           'WHERE (['+T_UD_VAR+'].['+F_VAR_TYPE+'] IN ('+QuotedStr(F_VAR_TYPE_UD)+', '+QuotedStr(F_VAR_TYPE_EXPERT)+'))'+CH_NEW+
                             'AND (['+T_UD_VAR+'].['+F_VAR_VAL_STR+'] LIKE ('+QuotedStr('%'+LTAB_UD[IDTable]+'.'+IntToStr(IDElement)+CH_NEW+'%')+'))'+CH_NEW+
                         'ORDER BY ['+T_UD_DOC+'].['+F_UD_DOC_CAPTION+'] ASC, ['+T_UD_VAR+'].['+F_VAR_CAPTION+'] ASC;';
             SQL.Text := S;
             Open; First;
             S := ''; I := 0;
             If RecordCount > 0 then begin
                While not EOF do begin
                   S:=S+'['+CutLongStr(FieldByName(T_UD_DOC+'.'+F_UD_DOC_CAPTION).AsString, 50)+'].'+
                        '['+CutLongStr(FieldByName(T_UD_VAR+'.'+F_VAR_CAPTION   ).AsString, 50)+']'+CH_NEW;
                   I:=I+1; If I=10 then Break;
                   Next;
                end;
             end;
          end;
       finally
          If QDOC.Active then QDOC.Close;
          QDOC.Free;
       end;

       {Если имеются связанные документы - удаление невозможно}
       Delete(S, Length(S)-1, 2);
       If S <> '' then MessageDlg('Удаление невозможно!'+CH_NEW+'['+Tree.Selected.Text+'] связан с:'+CH_NEW+S, mtError, [mbOK], 0)
                  else Result := true;
   end;

begin
    {Инициализация}
    IDTable   := Integer(Tree.Selected.Parent.Data);
    IDElement := Integer(Tree.Selected.Data);
    If Not CanDelElementUD then Exit;

    {Удаляем элемент}
    Q := TADOQuery.Create(Self);
    try
       With Q do begin
          Connection := FFMAIN.BUD.BD;
          SQL.Text := 'SELECT * FROM ['+LTAB_UD[IDTable]+'] WHERE ['+F_COUNTER+']='+IntToStr(IDElement)+';';
          Open;
          If RecordCount <> 1    then Exit;
          If MessageDlg('Подтвердите удаление:'+CH_NEW+'['+Tree.Selected.Text+']', mtWarning, [mbOK, mbCancel], 0) <> mrOk then Exit;
          Delete;
       end;
    finally
       If Q.Active then Q.Close;
       Q.Free;
    end;

    {Обновляем таблицу}
    RefreshTabUD(@FFMAIN.BUD, LTAB_UD[IDTable]);

    {Обновляем дерево}
    RefreshTree;
end;


{==============================================================================}
{=============================  ACTION: ОТКРЫТЬ  ==============================}
{==============================================================================}
procedure TFSTRUCT.AOpenExecute(Sender: TObject);
begin
    TreeDblClick(nil);
end;

end.
