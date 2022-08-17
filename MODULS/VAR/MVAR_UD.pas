unit MVAR_UD;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Controls,
  Vcl.ImgList, Vcl.ExtCtrls, Vcl.Menus, Vcl.ActnList, Vcl.Graphics, Vcl.DBCtrls,
  Vcl.Dialogs,
  Data.DB, Data.Win.ADODB,
  FunConst, FunType, MAIN;

type
  TGridAccess = class(TCustomGrid);
  TFVAR_UD = class(TForm)
    ActionList1: TActionList;
    A_Add: TAction;
    A_Del: TAction;
    PMenu: TPopupMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    DBGrid: TDBGrid;
    BtnAdd: TBitBtn;
    PBottom: TPanel;
    BtnOk: TBitBtn;
    A_UnCheckAll: TAction;
    N2: TMenuItem;
    N4: TMenuItem;

    {Модуль: MVAR_UD_GRID}
    procedure DBGridResize(Sender: TObject);
    procedure QAfterScroll(DataSet: TDataSet);
    procedure DBGridTitleClick(Column: TColumn);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridMouseEnter(Sender: TObject);
    procedure DBGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    {Модуль: MVAR_UD}
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PMenuPopup(Sender: TObject);
    procedure A_AddClick(Sender: TObject);
    procedure A_DelClick(Sender: TObject);
    procedure A_UnCheckAllExecute(Sender: TObject);

  private
    FFMAIN       : TFMAIN;
    DS           : TDataSource;
    Q            : TADOQuery;
    PQVAR        : PADOQuery;
    // PTSAV     : PADOTable;
    IDVar        : Integer;

    LCheck       : TStringList;
    ParamTable   : String;
    ParamFilter  : String;
    ParamMSelect : Boolean;
    ITable       : Integer;
    GRID_COL     : array [0..2] of String;

    procedure EnablAction;

    {Модуль: MVAR_UD_GRID}
    procedure IniGrid;
    procedure RefreshGrid;
    procedure SaveCheck;
    procedure LoadCheck;

  public
    procedure Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
    procedure ExecuteCheck(const PList: PStringList; const ITableUD, IVarID: Integer);
  end;

const
  SCOL_CHECK  = F_COUNTER;       // для последующей подмены
  COLCHECK_WIDTH = 20;
  ICOL_CHECK = 0;
  ICOL_1     = 1;
  ICOL_2     = 2;

  LField1 : array [0..3] of String = (PPERSON_FIO,   LPERSON_NAME_SHORT, DPERSON_FIO,   OBJECT_CAPTION);
  LField2 : array [0..3] of String = (PPERSON_STATE, LPERSON_STATE,      DPERSON_STATE, OBJECT_CONF_PLACE);

var
  FVAR_UD : TFVAR_UD;

implementation

uses FunSys, FunText, FunList, FunBD, FunIni, FunIDE,
     MVAR_UD_EDIT_PPERSON, MVAR_UD_EDIT_LPERSON, MVAR_UD_EDIT_DPERSON,
     MVAR_UD_EDIT_OBJECT;

{$R *.dfm}

{$INCLUDE MVAR_UD_GRID}

{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
{!!!!!!!!!!!  В ЛОКАЛЬНЫХ НАСТРОЙКАХ СОХРАНЯЕМ ТОЛЬКО ОФОРМЛЕНИЕ  !!!!!!!!!!!!!}
{!!!!!!!!!!!  ОСТАЛЬНОЕ - В БАЗЕ ДАННЫХ ДЕЛА                      !!!!!!!!!!!!!}
{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}


{******************************************************************************}
{****************************  ВНЕШНЯЯ ФУНКЦИЯ  *******************************}
{******************************************************************************}
procedure TFVAR_UD.Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
var LParam: TStringList;
begin
    {Настройка окна}
    Position        := poDefault;
    Align           := alClient;
    BtnAdd.Visible  := true;
    PBottom.Visible := false;

    {Инициализация}
    PQVAR := PPQVAR;  // PTSAV := PPTSAV;
    IDVar := PQVAR^.FieldByName(F_COUNTER).AsInteger;

    {Анализ параметров}
    LParam := TStringList.Create;
    try
       LParam.Text := PQVAR^.FieldByName(F_VAR_PARAM).AsString;

       {Параметр: Таблица}
       ParamTable := LRead(@LParam, F_VAR_PARAM_KEY_TABLE, '');
       If ParamTable = '' then Exit;
       ITable := CmpStrList(ParamTable, LTAB_UD);
       If (ITable < Low(LTAB_UD)) OR (ITable > High(LTAB_UD)) then Exit;
       GRID_COL[Low(GRID_COL)]   := SCOL_CHECK;
       GRID_COL[Low(GRID_COL)+1] := LField1[ITable];
       GRID_COL[Low(GRID_COL)+2] := LField2[ITable];

       {Параметр: Фильтр}
       ParamFilter := LRead(@LParam, F_VAR_PARAM_KEY_FILTER, '');

       {Параметр: Мультивыбор}
       ParamMSelect := CmpStr(LRead(@LParam, F_VAR_PARAM_KEY_MSELECT, ''), 'ДА');
    finally
       LParam.Free;
    end;

    IniGrid;
    RefreshGrid;
end;

{==============================================================================}
{================  PList    = Физические лица.5     ===========================}
{================             Физические лица.8     ===========================}
{================             ...                   ===========================}
{================  ITableUD = LTAB_UD_PPERSON       ===========================}
{================  IVarID   = F_COUNTER переменной  ===========================}
{==============================================================================}
procedure TFVAR_UD.ExecuteCheck(const PList: PStringList; const ITableUD, IVarID: Integer);
begin
    {Настройка окна}
    BorderStyle       := bsSizeable;
    Position          := poScreenCenter;
    Align             := alNone;
    Caption           := 'Кого исследуем?';
    BtnOk.ModalResult := mrOk;
    PBottom.Visible   := true;
    BtnAdd.Visible    := false;
    Width             := FFMAIN.Width  Div 3 * 2;
    Height            := FFMAIN.Height Div 3 * 2;

    {Инициализация}
    PQVAR         := nil;      // PTSAV := nil;
    LCheck.Text   := PList^.Text;
    IDVar         := IVarID;

    {Установка параметров}
    {Параметр: Таблица}
    ITable       := ITableUD;
    ParamTable   := LTAB_UD[ITableUD];
    GRID_COL[Low(GRID_COL)]   := SCOL_CHECK;
    GRID_COL[Low(GRID_COL)+1] := LField1[ITable];
    GRID_COL[Low(GRID_COL)+2] := LField2[ITable];

    {Параметр: Фильтр}
    ParamFilter := '';

    {Параметр: Мультивыбор}
    ParamMSelect := true;

    IniGrid;
    RefreshGrid;

    {Показываем окно}
    LoadFormIni(Self, [fspPosition]);
    ShowModal;
    SaveFormIni(Self, [fspPosition]);

    {Обновляем результат}
    PList^.Text := LCheck.Text;
end;


{==============================================================================}
{==========================    СОЗДАНИЕ ФОРМЫ    ==============================}
{==============================================================================}
procedure TFVAR_UD.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN        := TFMAIN(GlFindComponent('FMAIN'));
    Q             := TADOQuery.Create(Self);
    Q.Connection  := FFMAIN.BUD.BD;
    DS            := TDataSource.Create(Self);
    DS.DataSet    := Q;
    LCheck        := TStringList.Create;
    BtnAdd.Action := A_Add;
end;


{==============================================================================}
{=========================    РАЗРУШЕНИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFVAR_UD.FormDestroy(Sender: TObject);
begin
    {Записываем значение переменной}
    If PQVAR <> nil then PQVAR^.Refresh;

    {Освобождаем память}
    DS.Free;
    If Q.Active then Q.Close; Q.Free;
    LCheck.Free;
end;


{==============================================================================}
{=====================  ПЕРЕД ВЫПАДЕНИЕМ POPUP-МЕНЮ  ==========================}
{==============================================================================}
procedure TFVAR_UD.PMenuPopup(Sender: TObject);
begin
    {Устанавливаем Action}
    EnablAction;
end;


{==============================================================================}
{====================  ДОСТУПНОСТЬ ЭЛЕМЕНТОВ ACTION  ==========================}
{==============================================================================}
procedure TFVAR_UD.EnablAction;
begin
    A_Del.Enabled        := Q.RecordCount > 0;
    A_UnCheckAll.Enabled := LCheck.Count  > 0;
end;


{==============================================================================}
{======================   ACTION: ДОБАВИТЬ ЭЛЕМЕНТ   ==========================}
{==============================================================================}
procedure TFVAR_UD.A_AddClick(Sender: TObject);
var Event : TDataSetNotifyEvent;
    S, STab, SVal : String;
begin
    S := Trim(InputBox('Создание элемента: '+ParamTable, GRID_COL[ICOL_1], ''));
    If S = '' then Exit;
    With Q do begin
       DisableControls;
       Event := AfterScroll; AfterScroll := nil;
       Insert;
       FieldByName(GRID_COL[ICOL_1]).AsString := S;
       If ParamTable = T_UD_PPERSON then FieldByName(PPERSON_STATE).AsString := PPERSON_STATE_WITNESS;
       If ParamTable = T_UD_DPERSON then FieldByName(DPERSON_STATE).AsString := DPERSON_STATE_ADVOCATE;
       If ParamTable = T_UD_LPERSON then FieldByName(LPERSON_STATE).AsString := LPERSON_STATE_CLAIM;
       If ParamFilter <> '' then begin
          STab := Trim(CutModulChar(ParamFilter, '[', ']'));
          SVal := Trim(CutModulChar(ParamFilter, CH_KAV, CH_KAV));
          If (STab <> '') and (SVal <> '') then begin
             try    Q.FieldByName(STab).AsString := SVal;
             except end;
          end;
       end;
       UpdateRecord;
       Post;
       RefreshTabUD(@FFMAIN.BUD, ParamTable);    // При создании элемента обязательно обновляем таблицу
       If not ParamMSelect then begin
          QAfterScroll(Q);
          Close;
          Open;
          LoadCheck;
       end;
       AfterScroll := Event;
       EnableControls;
    end;
    DBGridDblClick(Sender);
end;


{==============================================================================}
{======================   ACTION: УДАЛИТЬ ЭЛЕМЕНТ   ===========================}
{==============================================================================}
procedure TFVAR_UD.A_DelClick(Sender: TObject);

   function CanDelElementUD: Boolean;
   var QDOC : TADOQuery;
       S    : String;
       I    : Integer;
   begin
       {Инициализация}
       Result := false;
       If Q.RecordCount = 0 then Exit;

       {Формируем запрос на поиск всех переменных, содержащих элемент, за исключением IDVar}
       QDOC := TADOQuery.Create(Self);
       try
          With QDOC do begin
             Connection := FFMAIN.BUD.BD;
             S := 'SELECT DISTINCT ['+T_UD_DOC+'].['+F_COUNTER+'], ['+T_UD_DOC+'].['+F_UD_DOC_CAPTION+'],'+CH_NEW+
                                  '['+T_UD_VAR+'].['+F_COUNTER+'], ['+T_UD_VAR+'].['+F_VAR_CAPTION+']'+CH_NEW+
                           'FROM   ['+T_UD_DOC+'] INNER JOIN ['+T_UD_VAR+'] ON ['+T_UD_DOC+'].['+F_COUNTER+'] = ['+T_UD_VAR+'].['+F_VAR_DOC+']'+CH_NEW+
                           'WHERE (['+T_UD_VAR+'].['+F_VAR_TYPE+'] IN ('+QuotedStr(F_VAR_TYPE_UD)+', '+QuotedStr(F_VAR_TYPE_EXPERT)+'))'+CH_NEW+
                             'AND (['+T_UD_VAR+'].['+F_VAR_VAL_STR+'] LIKE ('+QuotedStr('%'+ParamTable+'.'+Q.FieldByName(F_COUNTER).AsString+CH_NEW+'%')+'))'+CH_NEW+
                             'AND (['+T_UD_VAR+'].['+F_COUNTER+']<>'+IntToStr(IDVar)+')'+CH_NEW+
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
       If S <> '' then MessageDlg('Удаление невозможно!'+CH_NEW+'['+Q.FieldByName(GRID_COL[ICOL_1]).AsString+'] связан с:'+CH_NEW+S, mtError, [mbOK], 0)
                  else Result := true;
   end;

   procedure DelLCheck;
   var I: Integer;
   begin
       I := LCheck.IndexOf(ParamTable+'.'+Q.FieldByName(F_COUNTER).AsString);
       If I > -1 then LCheck.Delete(I);
       SaveCheck;
   end;

begin
    If Not CanDelElementUD then Exit;
    If MessageDlg('Подтвердите удаление:'+CH_NEW+'['+Q.FieldByName(GRID_COL[ICOL_1]).AsString+']', mtWarning, [mbOK, mbCancel], 0) <> mrOk then Exit;

    DelLCheck;
    Q.Delete;
    RefreshGrid;
end;


{==============================================================================}
{======================   ACTION: ОТМЕНИТЬ ВСЕ CHECKED   ======================}
{==============================================================================}
procedure TFVAR_UD.A_UnCheckAllExecute(Sender: TObject);
begin
    LCheck.Clear;
    RefreshGrid;
end;


end.
