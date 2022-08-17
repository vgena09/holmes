unit MVAR_OLE;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Variants,
  Vcl.Forms, Vcl.Buttons, Vcl.StdCtrls, Vcl.Controls, Vcl.OleCtnrs,
  Vcl.ExtCtrls, Vcl.Menus, Vcl.ActnList, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Dialogs,
  Data.DB, Data.Win.ADODB,
  FunConst, FunType,
  MAIN, MVAR_OLE_EDIT;

type
  TFVAR_OLE = class(TForm)
    AList: TActionList;
    AEdit: TAction;
    AClear: TAction;
    EOle: TOleContainer;
    PBottom: TPanel;
    Nav: TDBNavigator;
    BtnClear: TBitBtn;
    PMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AClearExecute(Sender: TObject);
    procedure AEditExecute(Sender: TObject);
    procedure EOleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TAfterInsert(DataSet: TDataSet);
    procedure TAfterScroll(DataSet: TDataSet);
  private
    FFMAIN        : TFMAIN;
    DSSrc, DSDect : TDataSource;
    TSrc          : TADOTable;
    PQVAR         : PADOQuery;    // PTSAV      : PADOTable;
    SCat          : String;
    IsCategory    : Boolean;      // Тип режима категории/memo
  public
    procedure Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
  end;

var
  FVAR_OLE: TFVAR_OLE;

implementation

uses FunSys, FunStream, FunBD, FunOle, FunText;

{$R *.dfm}


{******************************************************************************}
{****************************  ВНЕШНЯЯ ФУНКЦИЯ  *******************************}
{******************************************************************************}
procedure TFVAR_OLE.Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
var LParam : TStringList;
    SSel   : String;
begin
    {Инициализация}
    PQVAR          := PPQVAR; //PTSAV        := PPTSAV;
    DSDect.DataSet := PQVAR^;

    {Читаем OLE}
    FieldToOle(PADODataSet(PQVAR), @EOle);

    {Читаем параметры}
    LParam := TStringList.Create;
    LParam.CaseSensitive := false;
    try     LParam.Text := PQVAR^.FieldByName(F_VAR_PARAM).AsString;
            SCat := LParam.Values[F_VAR_PARAM_KEY_CATEGORY];
            SSel := LParam.Values[F_VAR_PARAM_KEY_SELECT];
            IsCategory := LParam.IndexOfName(F_VAR_PARAM_KEY_CATEGORY) >= 0;
    finally LParam.Free;
    end;

    {Режим категорий}
    If IsCategory then begin
       AEdit.Enabled         := true;
       AClear.Enabled        := false;
       AClear.Visible        := false;

       PBottom.Visible       := true;
       BtnClear.Visible      := false;

       {Устанавливаем таблицу-источник}
       If SCat <> '' then SetDBFilter(@TSrc, '['+F_VAR_OLE_CAT+']='+QuotedStr(SCat))
                     else SetDBFilter(@TSrc, '');
       If IsIntegerStr(SSel) then TSrc.Locate(F_COUNTER, SSel, []) else TSrc.First;
       TSrc.AfterInsert := TAfterInsert;
       TSrc.AfterScroll := TAfterScroll;
       TAfterScroll(nil);


    {Режим memo}
    end else begin
       AEdit.Enabled         := false;
       AEdit.Visible         := false;
       AClear.Enabled        := true;

       PBottom.Visible       := false;
       BtnClear.Visible      := true;

       TSrc.AfterScroll := nil;
       TSrc.AfterInsert := nil;

       If EOle.State = osEmpty then BlankWordToOle(@EOle);
    end;
end;


{==============================================================================}
{==========================    СОЗДАНИЕ ФОРМЫ    ==============================}
{==============================================================================}
procedure TFVAR_OLE.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));

    TSrc   := LikeTable(@FFMAIN.BSET_LOCAL.TVAR_OLE);
    DSSrc  := TDataSource.Create(Self);
    DSDect := TDataSource.Create(Self);

    DSSrc.DataSet      := TSrc;
    Nav.VisibleButtons := [nbFirst,nbPrior,nbNext,nbLast,nbInsert,nbDelete];
    Nav.DataSource     := DSSrc;
    Nav.ShowHint       := true;

    EOle.PopupMenu     := PMenu;
    EOle.Cursor        := crHandPoint;
    EOle.OnMouseDown   := EOleMouseDown;
end;



{==============================================================================}
{=========================    РАЗРУШЕНИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFVAR_OLE.FormDestroy(Sender: TObject);
begin
    {Сохраняем OLE}
    OleToField(@EOle, PADODataSet(PQVAR));
    ClearOle(@EOle);
    {Освобождаем память}
    DSSrc.Free; DSDect.Free;
    If TSrc.Active then TSrc.Close; TSrc.Free;
end;


{==============================================================================}
{============================  EOLE: ON_MOUSE_DOWN  ===========================}
{==============================================================================}
procedure TFVAR_OLE.EOleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    If Button <> mbLeft then Exit;
    If IsCategory then AEdit.OnExecute(Sender)
                  else EOle.DoVerb(ovPrimary);
end;


{==============================================================================}
{=========================  ACTION: РЕДАКТИРОВАТЬ  ============================}
{==============================================================================}
procedure TFVAR_OLE.AEditExecute(Sender: TObject);
var F : TFVAR_OLE_EDIT;
begin
    F := TFVAR_OLE_EDIT.Create(Self);
    try
       With F do begin
          {Редактируем}
          T.Close;          // Устраняем глюк с BeforeScroll
          SetDBFilter(@T, '['+F_COUNTER+']='+TSrc.FieldByName(F_COUNTER).AsString);
          T.Open;
          If T.RecordCount <> 1 then Exit;
          Nav.Enabled  := false;
          Nav.Visible  := false;
          PCat.Visible := false;
          ShowModal;
       end;
    finally
       F.Free;
    end;

    TSrc.Refresh;
    TAfterScroll(nil);
end;



{==============================================================================}
{=============================  ACTION: ОЧИСТИТЬ  =============================}
{==============================================================================}
procedure TFVAR_OLE.AClearExecute(Sender: TObject);
begin
    If MessageDlg('Очистить блок?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
    BlankWordToOle(@EOle);
end;


{==============================================================================}
{=======================   TABLE: СОЗДАЕМ ЗАПИСЬ TSRC  ========================}
{==============================================================================}
procedure TFVAR_OLE.TAfterInsert(DataSet: TDataSet);
begin
    If SCat=''then Exit;
    With TSrc do begin
       Edit;
       FieldByName(F_VAR_OLE_CAT).AsString := SCat;
       UpdateRecord;
       Post;
    end;
    BlankWordToOle(@EOle);
    OleToField(@EOle, @TSrc);
    EOleMouseDown(nil, mbLeft, [], 0, 0);
end;

{==============================================================================}
{=====================   TABLE: ПРИХОДИМ НА ЗАПИСЬ TSRC  ======================}
{==============================================================================}
procedure TFVAR_OLE.TAfterScroll(DataSet: TDataSet);
var L : TStringList;
begin
    L := TStringList.Create;
    try
      {Читаем TSrc}
      With TSrc do begin
         L.Text := FieldByName(F_VAR_OLE_IP).AsString+CH_NEW+
                   FieldByName(F_VAR_OLE_RP).AsString+CH_NEW+
                   FieldByName(F_VAR_OLE_DP).AsString+CH_NEW+
                   FieldByName(F_VAR_OLE_VP).AsString+CH_NEW+
                   FieldByName(F_VAR_OLE_TP).AsString+CH_NEW+
                   FieldByName(F_VAR_OLE_PP).AsString;
      end;

      {Обновляем PQVAR^}
      With PQVAR^ do begin
         DisableControls;
         Edit;

         {Сохраняем значения STR и OLE}
         FieldByName(F_VAR_VAL_STR).AsString := L.Text;
         FieldByName(F_VAR_VAL_OLE).Assign(TSrc.FieldByName(F_VAR_OLE_OLE));

         {Сохраняем позицию TSrc}
         L.Text := FieldByName(F_VAR_PARAM).AsString;
         L.Values[F_VAR_PARAM_KEY_SELECT] := TSrc.FieldByName(F_COUNTER).AsString;
         FieldByName(F_VAR_PARAM).AsString := L.Text;

         UpdateRecord;
         Post;
         EnableControls;
      end;

   finally L.Free;
   end;

   {Загружаем OLE}
   FieldToOle(PADODataSet(PQVAR), @EOle);
end;

end.
