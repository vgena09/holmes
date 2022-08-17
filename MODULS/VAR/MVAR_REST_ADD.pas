unit MVAR_REST_ADD;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls,
  Data.DB, Data.Win.ADODB,
  FunConst, FunType, MAIN;

type
  TFVAR_REST_ADD = class(TForm)
    Bevel1: TBevel;
    PBottom: TPanel;
    BtnCancel: TBitBtn;
    BtnOk: TBitBtn;
    PFIO: TPanel;
    LFIO: TLabel;
    BtnFIO: TBitBtn;
    EFIO: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure EFIOChange(Sender: TObject);
    procedure FKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnFIOClick(Sender: TObject);
  private
    FFMAIN : TFMAIN;
    LOld   : TStringList;
    procedure RefreshListFIO;

  public
    function Execute(const PLVal: PStringList): Boolean;

  end;

var
  FVAR_REST_ADD: TFVAR_REST_ADD;

implementation

uses FunSys, FunBD, FunText, FunVcl,
     MFREE, MVAR_REST;

{$R *.dfm}


{==============================================================================}
{============================  СОЗДАТЬ ФОРМУ  =================================}
{==============================================================================}
procedure TFVAR_REST_ADD.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    EFIO.Items.Clear;
    EFIO.Text             := '';
    EFIO.DropDownCount    := 25;
    EFIO.OnKeyDown        := FKeyDown;
    EFIO.OnChange         := EFIOChange;
    BtnFIO.OnClick        := BtnFIOClick;
    BtnOk.ModalResult     := mrOk;
    BtnCancel.ModalResult := mrCancel;
end;


{******************************************************************************}
{*****************  ВНЕШНЯЯ ФУНКЦИЯ: РЕДАКТИРОВАТЬ ЭЛЕМЕНТ  *******************}
{******************************************************************************}
function TFVAR_REST_ADD.Execute(const PLVal: PStringList): Boolean;
var I: Integer;
begin
    Result := false;
    LOld   := TStringList.Create;      LOld.Sorted := false;
    FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := 'Вы можете создать как новое лицо, так и выбрать уже известное';
    try
       RefreshListFIO;
       EFIOChange(nil);

       If ShowModal <> mrOk then Exit;

       I := EFIO.ItemIndex;
       If I = -1 then begin
          PLVal^.Add(EFIO.Text);
          PLVal^.Add('понятой');
          PLVal^.Add('...');
       end else begin
          PLVal^.Add(LOld[(I*3)+0]);
          PLVal^.Add(LOld[(I*3)+1]);
          PLVal^.Add(LOld[(I*3)+2]);
       end;
       Result := true;
    finally
       LOld.Free;
       FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := '';
    end;
end;


{==============================================================================}
{=============================   EFIO: ON_CLICK   =============================}
{==============================================================================}
procedure TFVAR_REST_ADD.BtnFIOClick(Sender: TObject);
var F_FREE, F_REST : TForm;
    TVAR, TSAV     : TADOTable;
    SHint          : String;
begin
    {Инициализация}
    TVAR   := LikeTable(@FFMAIN.BSET_LOCAL.TVAR);
    TSAV   := LikeTable(@FFMAIN.BUD.TSYS);
    F_FREE := TFFREE.Create(Self);
    try
       {Позиционируем таблицу глобальных переменных}
       SetDBFilter(@TVAR, '['+F_VAR_NAME+']='+QuotedStr(F_VAR_NAME_REST0));
       If TVAR.RecordCount <> 1 then Exit;
       FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := TVAR.FieldByName(F_VAR_HINT).AsString;

       {Загружаем субформу}
       F_FREE.Caption := 'Присутствующие лица';
       F_REST := LoadSubForm(TFFREE(F_FREE).PMain, TFVAR_REST, true);
       try
          SHint := FFMAIN.StatusBar.Panels[STATUS_MAIN].Text;
          FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := TVAR.FieldByName(F_VAR_HINT).AsString;

          TFVAR_REST(F_REST).Execute(@TVAR, @TSAV);
          //TFVAR_REST(F_REST).LName.Visible := false;

          {Диалог}
          F_FREE.ShowModal();

       {Выгружаем субформу}
       finally
          FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := SHint;
          LoadSubForm(TFFREE(F_FREE).PMain, nil, true);
       end;
    finally
       F_FREE.Free;
       DestrTable(@TVAR); RefreshTable(@FFMAIN.BSET_LOCAL.TVAR);
       DestrTable(@TSAV); RefreshTable(@FFMAIN.BUD.TSYS);
    end;

    {Обновляем список}
    RefreshListFIO;
end;


{==============================================================================}
{============================   EFIO: ON_CHANGE   =============================}
{==============================================================================}
procedure TFVAR_REST_ADD.EFIOChange(Sender: TObject);
begin
    BtnOk.Enabled := (GetColSlov(EFIO.Text, ' ') > 1);
end;


{==============================================================================}
{==============================   ON_KEY_DOWN   ===============================}
{==============================================================================}
procedure TFVAR_REST_ADD.FKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    13: {Enter} If BtnOk.Enabled then ModalResult := mrOk;
    27: {ESC}   ModalResult := mrCancel;
    end;
end;


{==============================================================================}
{========================   УСТАНОВИТЬ СПИСОК EFIO   ==========================}
{==============================================================================}
procedure TFVAR_REST_ADD.RefreshListFIO;
var I : Integer;
    S : String;
begin
    LOld.Text := ReadFieldFromFilter(@FFMAIN.BSET_LOCAL.BD, FFMAIN.BSET_LOCAL.TVAR.TableName, '['+F_VAR_NAME+']='+QuotedStr(F_VAR_NAME_REST0), F_VAR_VAL_STR, true);
    S := EFIO.Text;
    EFIO.Items.Clear;
    For I := 0 to (LOld.Count Div 3) - 1 do EFIO.Items.Add(LOld[I * 3]);
    EFIO.Text := S;
end;


end.
