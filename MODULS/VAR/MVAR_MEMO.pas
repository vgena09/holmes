unit MVAR_MEMO;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Variants,
  Vcl.ActnList, Vcl.ImgList, Vcl.Controls, Vcl.Forms, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.Dialogs, Vcl.DBCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Data.Win.ADODB,
  FunType, MAIN;

type
  TFVAR_MEMO = class(TForm)
    AList: TActionList;
    AVerify: TAction;
    ACut: TAction;
    ACopy: TAction;
    APaste: TAction;
    AUndo: TAction;
    MMemo: TDBMemo;
    BtnVer: TBitBtn;
    PMenu: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AVerifyExecute(Sender: TObject);
    procedure ACutExecute(Sender: TObject);
    procedure ACopyExecute(Sender: TObject);
    procedure APasteExecute(Sender: TObject);
    procedure AUndoExecute(Sender: TObject);
    procedure MMemoChange(Sender: TObject);
  private
    FFMAIN : TFMAIN;
    DS     : TDataSource;
    PQVAR  : PADOQuery;
    PTSAV  : PADOTable;
    IDVar  : String;
  public
    procedure Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
  end;

var
  FVAR_MEMO: TFVAR_MEMO;

implementation

uses FunConst, FunBD, FunSys, FunVerify;

{$R *.dfm}


{******************************************************************************}
{****************************  ВНЕШНЯЯ ФУНКЦИЯ  *******************************}
{******************************************************************************}
procedure TFVAR_MEMO.Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
begin
    {Инициализация}
    PQVAR   := PPQVAR;
    PTSAV   := PPTSAV;
    IDVar   := PQVAR^.FieldByName(F_COUNTER).AsString;

    DS.DataSet      := PQVAR^;
    MMemo.DataField := F_VAR_VAL_STR;
    MMemo.OnChange  := MMemoChange;

    {Восстанавливаем выделение текста}
    MMemo.SelStart  := TableReadVar(PTSAV, IDVar+': '+F_UD_SYS_MEMO_SEL1, 0);
    MMemo.SelLength := TableReadVar(PTSAV, IDVar+': '+F_UD_SYS_MEMO_SEL2, 0);
end;


{==============================================================================}
{==========================    СОЗДАНИЕ ФОРМЫ    ==============================}
{==============================================================================}
procedure TFVAR_MEMO.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    DS     := TDataSource.Create(Self);
    MMemo.DataSource := DS;

    AList.Images := FFMAIN.ImgSys16;
    AVerify.ImageIndex := ICO_VERIFY;
    ACut   .ImageIndex := ICO_CUT;
    ACopy  .ImageIndex := ICO_COPY;
    APaste .ImageIndex := ICO_PASTE;
    AUndo  .ImageIndex := ICO_UNDO;
end;


{==============================================================================}
{=========================    РАЗРУШЕНИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFVAR_MEMO.FormDestroy(Sender: TObject);
begin
    {Записываем значение переменной}
    PQVAR^.Refresh;

    {Сохраняем выделение текста}
    TableWriteVar(PTSAV, IDVar+': '+F_UD_SYS_MEMO_SEL1, MMemo.SelStart);
    TableWriteVar(PTSAV, IDVar+': '+F_UD_SYS_MEMO_SEL2, MMemo.SelLength);

    DS.Free;
end;


{==============================================================================}
{==========================    MEMO: ON_CHANGE    =============================}
{==============================================================================}
procedure TFVAR_MEMO.MMemoChange(Sender: TObject);
begin
    {Записываем значение переменной}
    PQVAR^.Refresh;
end;


{==============================================================================}
{==============================    ACTION    ==================================}
{==============================================================================}
procedure TFVAR_MEMO.AVerifyExecute(Sender: TObject);
begin
    With MMemo.DataSource.DataSet do begin
       Edit;
       FieldByName(MMemo.DataField).AsString:=VerifyText(MMemo.Lines.Text, true, true, true);
       UpdateRecord;
       Post;
    end;
end;

procedure TFVAR_MEMO.ACutExecute(Sender: TObject);
begin
    MMemo.CutToClipboard;
end;

procedure TFVAR_MEMO.ACopyExecute(Sender: TObject);
begin
    MMemo.CopyToClipboard;
end;

procedure TFVAR_MEMO.APasteExecute(Sender: TObject);
begin
    MMemo.PasteFromClipboard;
end;

procedure TFVAR_MEMO.AUndoExecute(Sender: TObject);
begin
    MMemo.Undo;
end;

end.
