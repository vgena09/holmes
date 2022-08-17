unit MDOC_PROP;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Data.Win.ADODB,
  FunDateTimePicker,
  FunType, MAIN;

type
  TDateTimePicker = class(TMyDateTimePicker);
  TFDOC_PROP = class(TForm)
    PBottom: TPanel;
    BtnClose: TBitBtn;
    PCaption: TPanel;
    LCaption: TLabel;
    ECaption: TDBEdit;
    PDate: TPanel;
    LDate: TLabel;
    PControl: TPanel;
    LControl: TLabel;
    LControlOld: TLabel;
    Bevel1: TBevel;
    POk: TPanel;
    LOk: TLabel;
    EOk: TDBCheckBox;
    EControl: TDateTimePicker;
    CBControl: TCheckBox;
    EDate: TDateTimePicker;
    LDay: TLabel;

    {Модуль: MDOC_PROP_CONTROL}
    procedure EControlChange(Sender: TObject);
    procedure CBControlClick(Sender: TObject);
    procedure CBControlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    {Модуль: MDOC_PROP}
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EDateChange(Sender: TObject);
    procedure EKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    FFMAIN   : TFMAIN;
    DS       : TDataSource;
    Q        : TADOQuery;

    {Модуль: MDOC_PROP_CONTROL}
    procedure ControlIni;
    procedure ControlWrite;
    procedure ControlRead;
    function  ControlVal: String;
  public
    procedure Execute(const ID_DOC: String);
  end;

var
  FDOC_PROP: TFDOC_PROP;

implementation

uses FunConst, FunSys, FunDay, FunBD;

{$R *.dfm}
{$INCLUDE MDOC_PROP_CONTROL}

{==============================================================================}
{============================   СОЗДАНИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFDOC_PROP.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN           := TFMAIN(GlFindComponent('FMAIN'));
    Q                := TADOQuery.Create(Self);
    Q.Connection     := FFMAIN.BUD.BD;
    DS               := TDataSource.Create(Self);
    DS.DataSet       := Q;

    ControlIni;
    With EDate do begin
       Format    := 'dd MMMM yyyy г.';
       OnChange  := EDateChange;
       OnKeyDown := EKeyDown;
    end;

    ECaption.DataSource := DS; ECaption.DataField := F_UD_DOC_CAPTION; ECaption.OnKeyDown := EKeyDown;
    EOk.DataSource      := DS; EOk.DataField      := F_UD_DOC_OK;

    BtnClose.Left := (PBottom.ClientWidth - BtnClose.Width) Div 2;     BtnClose.OnKeyDown := EKeyDown;
end;


{==============================================================================}
{===========================   РАЗРУШЕНИЕ ФОРМЫ    ============================}
{==============================================================================}
procedure TFDOC_PROP.FormDestroy(Sender: TObject);
begin
    {Изменяем время модификации}
    With Q do begin
       Edit;
       FieldByName(F_UD_DOC_MODIFY).AsDateTime := Now;
       UpdateRecord;
       Post;
    end;

    {Записываем значения}
    Q.Refresh;
    DS.Free;
    If Q.Active then Q.Close; Q.Free;
end;


{******************************************************************************}
{*************************   ВНЕШНЯЯ ФУНКЦИЯ    *******************************}
{******************************************************************************}
procedure TFDOC_PROP.Execute(const ID_DOC: String);
begin
    With Q do begin
       SQL.Text := 'SELECT * FROM ['+T_UD_DOC+'] WHERE ['+F_COUNTER+']='+ID_DOC+';';
       Open;
       If RecordCount <> 1 then Exit;
    end;

    ControlRead;
    EDate.Date   := Q.FieldByName(F_UD_DOC_DATE).AsDateTime;
    LDay.Caption := FormatDateTime('dddd', EDate.Date);

    ShowModal;
end;


{==============================================================================}
{=======================   EDATE: ИЗМЕНЕНИЕ ДАТЫ   ============================}
{==============================================================================}
procedure TFDOC_PROP.EDateChange(Sender: TObject);
begin
    LDay.Caption := FormatDateTime('dddd', EDate.Date);
    If Q.Active then begin
       With Q do begin
          Edit;
          FieldByName(F_UD_DOC_DATE).AsString := DateToStr(EDate.Date);
          UpdateRecord;
          Post;
       end;
    end;
    RefreshTable(@FFMAIN.BUD.TDOC);
end;


{==============================================================================}
{==========================   TEXT: ON_KEY_DOWN   =============================}
{==============================================================================}
procedure TFDOC_PROP.EKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    27: {ESC} BtnClose.Click;
    end;
end;

end.
