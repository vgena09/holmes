unit MUK;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Tabs, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Data.Win.ADODB,
  FunConst, MAIN;

type
  TFUK = class(TForm)
    PBottom: TPanel;
    BtnClose: TBitBtn;
    Nav: TDBNavigator;
    ENorm: TDBMemo;
    Tab: TTabSet;
    PTop: TPanel;
    PDateStart: TPanel;
    LDateStart: TLabel;
    PDateEnd: TPanel;
    LDateEnd: TLabel;
    EDateEnd: TDBText;
    EDateStart: TDBText;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TabChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure QAfterScroll(DataSet: TDataSet);
  private
    FFMAIN  : TFMAIN;
    Q       : TADOQuery;
    DS      : TDataSource;
    LSel    : TStringList;
  public
    procedure Execute(const SNorms: String);
  end;

var
  FUK: TFUK;

implementation
uses FunSys, FunIni, FunArt;

{$R *.dfm}


{==============================================================================}
{============================   СОЗДАНИЕ ФОРМЫ   ==============================}
{==============================================================================}
procedure TFUK.FormCreate(Sender: TObject);
begin
    {Инициализация}
    LSel          := TStringList.Create;
    FFMAIN        := TFMAIN(GlFindComponent('FMAIN'));
    Q             := TADOQuery.Create(Self);
    Q.Connection  := FFMAIN.BART.BD;
    DS            := TDataSource.Create(Self);
    DS.DataSet    := Q;

    With Nav do begin
       DataSource     := DS;
       VisibleButtons := [nbFirst,nbPrior,nbNext,nbLast];
    end;

    With ENorm do begin
       ReadOnly       := true;
       DataSource     := DS;
       DataField      := UK_NORM;
    end;

    With EDateStart do begin
       DataSource     := DS;
       DataField      := UK_BEGIN;
    end;

    With EDateEnd do begin
       DataSource     := DS;
       DataField      := UK_END;
    end;

    BtnClose.ModalResult := mrClose;

    {Восстанавливаем настройки из Ini}
    LoadFormIni(Self, [fspPosition], Screen.Width Div 2, Screen.Height Div 2);
end;


{==============================================================================}
{============================   ЗАКРЫТИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFUK.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    {Сохраняем настройки в Ini}
    SaveFormIni(Self, [fspPosition]);

    {Освобождаем память}
    LSel.Free;
    DS.Free;
    If Q.Active then Q.Close; Q.Free;
end;



{******************************************************************************}
{****************************  ВНЕШНЯЯ ФУНКЦИЯ  *******************************}
{******************************************************************************}
{***********   SNorms  = 'пп.2,8 ч.2 ст.139, ч.2 ст.207, ... '    *************}
{******************************************************************************}
procedure TFUK.Execute(const SNorms: String);
var S: String;
begin
    {Инициализация}
    DS.Enabled    := false;
    Tab.OnChange  := nil;
    LSel.Clear; Tab.Tabs.Clear;
    With Q do begin
       AfterScroll := nil;

       {Закладки}
       If not SetUKQuery(@Q, SNorms, Now, Now) then Exit;
       While not Eof do begin
          LSel.Add(FieldByName(F_COUNTER).AsString);
          Tab.Tabs.Add(ArticlesConvert_AT(FieldByName(UK_NOMER).AsString));
          Next;
       end;
       Close; SQL.Clear;

       {Все нормы}
       S:='SELECT * FROM ['+TABLE_UK+'] ORDER BY ['+UK_NOMER+'] ASC, ['+UK_BEGIN+'] ASC;';
       SQL.Add(S);
       ParamCheck   := false;
       DS.Enabled   := true;
       Tab.OnChange := TabChange;
       AfterScroll  := QAfterScroll;
       Open;
       First;
    end;

    {По умолчанию выбираем первую закладку}
    If Tab.Tabs.Count > 0 then Tab.TabIndex := 0;

    {Показ модального окна}
    ShowModal;
end;


{==============================================================================}
{==============================   ВЫБОР НОРМЫ    ==============================}
{==============================================================================}
procedure TFUK.TabChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
    Q.Locate(F_COUNTER, LSel[NewTab], []);
end;


{==============================================================================}
{==========================   ИЗМЕНЕНИЕ ПОЗИЦИИ   =============================}
{==============================================================================}
procedure TFUK.QAfterScroll(DataSet: TDataSet);
begin
    If Q.Active and (Q.FieldByName(UK_END).AsString='')
    then ENorm.Font.Color := clBlack
    else ENorm.Font.Color := clGray;
end;

end.
