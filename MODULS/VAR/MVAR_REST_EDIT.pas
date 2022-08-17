unit MVAR_REST_EDIT;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.Graphics, Vcl.Dialogs,
  Data.DB, Data.Win.ADODB,
  FunType, MAIN, Vcl.ActnList;

type
  TFVAR_REST_EDIT = class(TForm)
    PBottom: TPanel;
    BtnCancel: TBitBtn;
    PStatus: TPanel;
    LStatus: TLabel;
    BtnStatus: TBitBtn;
    PPlace: TPanel;
    LPlace: TLabel;
    BtnPlace: TBitBtn;
    PFIO: TPanel;
    LFIO: TLabel;
    BtnFIO: TBitBtn;
    EFIO: TComboBox;
    EStatus: TComboBox;
    EPlace: TComboBox;
    BtnOk: TBitBtn;
    Bevel1: TBevel;
    ActionList1: TActionList;
    ARight: TAction;
    AOk: TAction;
    ACancel: TAction;
    PRight: TPanel;
    LRight: TLabel;
    BtnRight: TBitBtn;
    ERight: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnListClick(Sender: TObject);
    procedure EFIOChange(Sender: TObject);
    procedure KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ARightExecute(Sender: TObject);
    procedure AOkExecute(Sender: TObject);
    procedure ACancelExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FFMAIN : TFMAIN;
    TVAR   : TADOTable;
    procedure CBoxSetItem;

  public
    procedure Execute(const PLVal: PStringList; const ISel: Integer);
  end;

var
  FVAR_REST_EDIT: TFVAR_REST_EDIT;

implementation

uses FunConst, FunSys, FunBDList, FunDay, FunText, FunPadeg, FunBD, FunVcl,
     MFREE, MVAR_MEMO;

{$R *.dfm}


{******************************************************************************}
{*****************  ВНЕШНЯЯ ФУНКЦИЯ: РЕДАКТИРОВАТЬ ЭЛЕМЕНТ  *******************}
{******************************************************************************}
procedure TFVAR_REST_EDIT.Execute(const PLVal: PStringList; const ISel: Integer);
begin
    EFIO.Text      := PLVal^[ISel];
    EStatus.Text   := PLVal^[ISel+1];
    EPlace.Text    := PLVal^[ISel+2];
    EFIOChange(nil);

    If ShowModal <> mrOk then Exit;

    PLVal^[ISel]   := EFIO.Text;
    PLVal^[ISel+1] := EStatus.Text;
    PLVal^[ISel+2] := EPlace.Text;
end;


{==============================================================================}
{=============================  СОЗДАНИЕ ФОРМЫ   ==============================}
{==============================================================================}
procedure TFVAR_REST_EDIT.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    TVAR   := LikeTable(@FFMAIN.BSET_LOCAL.TVAR);

    BtnFIO   .OnClick := BtnListClick;   EFIO   .DropDownCount := 25;  EFIO.OnKeyDown    := KeyDown; EFIO.OnChange    := EFIOChange;
    BtnStatus.OnClick := BtnListClick;   EStatus.DropDownCount := 25;  EStatus.OnKeyDown := KeyDown; EStatus.OnChange := EFIOChange;
    BtnPlace .OnClick := BtnListClick;   EPlace .DropDownCount := 25;  EPlace.OnKeyDown  := KeyDown; EPlace.OnChange  := EFIOChange;
    CBoxSetItem;

    BtnOk.Action      := AOk;
    BtnCancel.Action  := ACancel;
    BtnRight.Action   := ARight;
    ERight.Enabled    := false;
end;


{==============================================================================}
{============================  РАЗРУШЕНИЕ ФОРМЫ   =============================}
{==============================================================================}
procedure TFVAR_REST_EDIT.FormDestroy(Sender: TObject);
begin
    DestrTable(@TVAR);
end;


{==============================================================================}
{=====================   КОРРЕКТИРОВКА СПИСКОВ CBOX    ========================}
{==============================================================================}
procedure TFVAR_REST_EDIT.BtnListClick(Sender: TObject);
var CBox : TDBComboBox;
    SID  : String;
begin
    {Инициализация}
    CBox := TDBComboBox(Sender);
    SID  := '';
    If CBox.Name='BtnFIO'     then SID:=LIST_REST_FIO;
    If CBox.Name='BtnStatus'  then SID:=LIST_REST_STATUS;
    If CBox.Name='BtnPlace'   then SID:=LIST_REST_PLACE;
    If SID='' then Exit;

    RefreshListItem(@FFMAIN.BSET_LOCAL.TLIST, SID);
    CBoxSetItem;
end;


{==============================================================================}
{=======================   УСТАНОВКА СПИСКОВ CBOX    ==========================}
{==============================================================================}
procedure TFVAR_REST_EDIT.CBoxSetItem;
begin
    GetListItemCBox(@EFIO,    @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_REST_FIO));
    GetListItemCBox(@EStatus, @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_REST_STATUS));
    GetListItemCBox(@EPlace,  @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_REST_PLACE));
end;


{==============================================================================}
{============================   EFIO: ON_CHANGE   =============================}
{==============================================================================}
procedure TFVAR_REST_EDIT.EFIOChange(Sender: TObject);
begin
    Caption := 'Редактировать: '+EFIO.Text;
    AOk.Enabled := (GetColSlov(EFIO.Text, ' ') > 1) and
                   (Trim(EStatus.Text) <> '') and
                   (Trim(EPlace.Text)  <> '');

    {Позиционируем таблицу глобальных переменных}
    SetDBFilter(@TVAR, '['+F_VAR_NAME+']='+QuotedStr(F_VAR_NAME_REST0_PREF+Trim(EStatus.Text)));
    If TVAR.RecordCount > 0 then ERight.Text := TVAR.FieldByName(F_VAR_VAL_STR).AsString
                            else ERight.Text := '';
end;


{==============================================================================}
{==============================   ON_KEY_DOWN   ===============================}
{==============================================================================}
procedure TFVAR_REST_EDIT.KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    13: {Enter} AOk.Execute;
    27: {ESC}   ACancel.Execute;
    end;
end;


{==============================================================================}
{=============================   ACTION: ОК   =================================}
{==============================================================================}
procedure TFVAR_REST_EDIT.AOkExecute(Sender: TObject);
begin ModalResult := mrOk; end;

{==============================================================================}
{============================   ACTION: ОТМЕНА   ==============================}
{==============================================================================}
procedure TFVAR_REST_EDIT.ACancelExecute(Sender: TObject);
begin ModalResult := mrCancel; end;

{==============================================================================}
{=======================   ACTION: РАЗЪЯСНЕНИЕ ПРАВ   =========================}
{==============================================================================}
procedure TFVAR_REST_EDIT.ARightExecute(Sender: TObject);
var F_FREE, F_MEMO : TForm;
    TSAV           : TADOTable;
    SHint          : String;
begin
    {Инициализация}
    TSAV   := LikeTable(@FFMAIN.BUD.TSYS);
    F_FREE := TFFREE.Create(Self);
    try
       {Если надо создать переменную}
       If TVAR.RecordCount = 0 then begin
          If MessageDlg('Права для статуса'+CH_NEW+'['+Trim(EStatus.Text)+']'+CH_NEW+'не заданы.'+CH_NEW+CH_NEW+
                        'Вы уверены, что законодательство требут разъяснения прав данному лицу?', mtWarning, [mbOK, mbCancel], 0) <> mrOk then Exit;
          With TVAR do begin
             Edit;
             FieldByName(F_VAR_NAME).AsString    := F_VAR_NAME_REST0_PREF+Trim(EStatus.Text);
             FieldByName(F_VAR_TYPE).AsString    := F_VAR_TYPE_EDIT;
             FieldByName(F_VAR_PARAM).AsString   := F_VAR_PARAM_VALUE+'=Да'+CH_NEW+F_VAR_PARAM_SHOW+'=Нет';
             FieldByName(F_VAR_VAL_STR).AsString := 'ст.___ УПК Республики Беларусь.';
             UpdateRecord;
             Post;
          end;
          RefreshTable(@FFMAIN.BSET_LOCAL.TVAR);
       end;
       If TVAR.RecordCount <> 1 then Exit;

       {Загружаем субформу}
       F_FREE.Caption := 'Разъяснение прав: '+Trim(EStatus.Text);
       F_MEMO := LoadSubForm(TFFREE(F_FREE).PMain, TFVAR_MEMO, true);
       try
          SHint := FFMAIN.StatusBar.Panels[STATUS_MAIN].Text;
          FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := TVAR.FieldByName(F_VAR_HINT).AsString;

          TFVAR_MEMO(F_MEMO).Execute(@TVAR, @TSAV);
          //TFVAR_MEMO(F_MEMO).LName.Visible := false;

          {Диалог}
          F_FREE.ShowModal();

       {Выгружаем субформу}
       finally
          FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := SHint;
          LoadSubForm(TFFREE(F_FREE).PMain, nil, true);
       end;
    finally
       F_FREE.Free;
       RefreshTable(@FFMAIN.BSET_LOCAL.TVAR);
       DestrTable(@TSAV); RefreshTable(@FFMAIN.BUD.TSYS);
    end;

    {Обновляем}
    EFIOChange(nil);
end;


end.
