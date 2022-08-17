unit MDECOD_OLE;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IniFiles {TMemIniFile},
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtnrs,
  Vcl.ActnList, Vcl.Menus, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Data.Win.ADODB,
  FunType, FunConst, FunDecoder, MAIN;

type
  TFDECOD_OLE = class(TForm)
    AList: TActionList;
    AStop: TAction;
    AClose: TAction;
    ASaveReport: TAction;
    PMenu: TPopupMenu;
    N1: TMenuItem;
    TimerStart: TTimer;
    SaveDlg: TSaveDialog;
    Tree: TTreeView;
    PTop: TPanel;
    Image1: TImage;
    PTopMain: TPanel;
    PBar: TProgressBar;
    LInfo: TLabel;
    PBottom: TPanel;
    Btn: TBitBtn;
    Bevel: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure ASaveReportExecute(Sender: TObject);
    procedure AStopExecute(Sender: TObject);
    procedure ACloseExecute(Sender: TObject);
    procedure PBottomResize(Sender: TObject);
  private
    FFMAIN   : TFMAIN;              // Класс главного окна
    FDECOD   : TDECOD;              // Класс декодера
    OLE      : TOleContainer;
    QDOC_UD  : TADOQuery;
    QVAR_UD  : TADOQuery;
    IS_STOP  : Boolean;

    {Вспомогательные функции}
    procedure AddInfo(const Msg: String; const IndIco: Integer);
    procedure SetInfo(const IVal: Integer; const SText: String);

    {Модуль: MDECOD_OLE_SCAN}
    function  ScanDoc: Boolean;
    function  ScanXls: Boolean;

  public
    function Execute(const IDDoc: String): Boolean;

  end;

const
  HEIGHT_MIN = 135;
  HEIGHT_MAX = 300;

var
  FDECOD_OLE: TFDECOD_OLE;

implementation

uses FunSys, FunText, FunWord, FunOle, FunClip, FunVcl, FunIni, FunBD,
     FunDay;
     //FunExcel;

{$R *.dfm}

{$INCLUDE MDECOD_OLE_SCAN}


{==============================================================================}
{=============================  СОЗДАНИЕ ФОРМЫ  ===============================}
{==============================================================================}
procedure TFDECOD_OLE.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    FDECOD := nil;

    {Инициализация интерфейса}
    Height            := HEIGHT_MIN;
    PBar.Min          := 0;
    PBar.Max          := 100;
    SetInfo(0, 'Инициализация');

    With Tree do begin
       Items.Clear;
       Images      := FFMAIN.ImgSys16;
       ShowRoot    := false;
       ShowButtons := false;
       PopupMenu   := PMenu;
       Visible     := false;
    end;

    PBottom.OnResize := PBottomResize;
    PBottomResize(Sender);
end;


{==============================================================================}
{==============  ВНЕШНЯЯ ФУНКЦИЯ: ОТКРЫТЬ ТЕКУЩИЙ ДОКУМЕТ  ====================}
{==============================================================================}
function TFDECOD_OLE.Execute(const IDDoc: String): Boolean;
begin
    {Инициализация}
    Result  := false;
    OLE     := CreateOLE(Self);
    QDOC_UD := TADOQuery.Create(Self);
    QVAR_UD := TADOQuery.Create(Self);
    FDECOD  := TDECOD.Create(IDDoc);
    try
       {УД.mdb : Документы}
       With QDOC_UD do begin
          Connection := FFMAIN.BUD.BD;
          SQL.Text   := 'SELECT * FROM ['+T_UD_DOC+'] WHERE ['+F_COUNTER+']='+IDDoc+';';
          Open;
          If RecordCount <> 1 then Exit;
       end;

       {УД.mdb : Переменные}
       With QVAR_UD do begin
          Connection := FFMAIN.BUD.BD;
          SQL.Text   := 'SELECT * FROM ['+T_UD_VAR+'] WHERE ['+F_VAR_DOC+']='+IDDoc+';';
          Open;
       end;

       {Окно декодера}
       Caption := 'Создание документа: '+QDOC_UD.FieldByName(F_UD_DOC_CAPTION).AsString;

       {Декодируем}
       FieldToOle(PADODataSet(@QDOC_UD), @OLE);
       Result  := ShowModal=mrOk;
       OleToField(@OLE, PADODataSet(@QDOC_UD));

    finally
       If OLE.State <> osEmpty then OLE.DestroyObject; OLE.Free;

       FDECOD.Free; FDECOD := nil;
       If QVAR_UD.Active then QVAR_UD.Close; QVAR_UD.Free;
       If QDOC_UD.Active then QDOC_UD.Close; QDOC_UD.Free;
    end;
end;


{==============================================================================}
{=============================  ОТКРЫТИЕ ФОРМЫ  ===============================}
{==============================================================================}
procedure TFDECOD_OLE.FormShow(Sender: TObject);
begin
    {Запускаем процесс}
    TimerStart.Enabled:=true;
end;


{==============================================================================}
{============================  ЗАПУСК ПРОЦЕССА  ===============================}
{==============================================================================}
procedure TFDECOD_OLE.TimerStartTimer(Sender: TObject);
var FIni  : TMemIniFile;
    IsOk  : Boolean;
    LProg : TStringlist;
    D     : TDate;
    T     : TADOTable;
    S     : String;
begin
    TimerStart.Enabled := false;
    IsOk := false;
    If FindStr(OLE.OleClassName, 'Word.Document')     > -1 then IsOk := ScanDoc else
    If FindStr(OLE.OleClassName, 'Excel.Application') > -1 then IsOk := ScanXls;          //Excel.Sheet

    If IsOk then begin
       {Определяем дату документа}
       D := Date;
       T := LikeTable(@FFMAIN.BUD.TVAR);
       try     SetDBFilter(@T, '(['+F_VAR_NAME+']='+QuotedStr(F_VAR_NAME_DATE)+') AND (['+F_VAR_DOC+']='+QDOC_UD.FieldByName(F_COUNTER).AsString+')');
               If T.RecordCount=1 then begin
                  S := CutDateStr(T.FieldByName(F_VAR_VAL_STR).AsString);
                  If ValidDate(S) then D:=StrToDate(S);
               end;
       finally DestrTable(@T);
       end;

       {Изменяем дату документа и признак его готовности}
       With QDOC_UD do begin
          Edit;
          FieldByName(F_UD_DOC_OK  ).AsBoolean  := true;
          FieldByName(F_UD_DOC_DATE).AsDateTime := D;
          UpdateRecord;
          Post;
       end;

       {Выполняем программу 2}
       S := QDOC_UD.FieldByName(F_UD_DOC_PATH_FULL).AsString;
       If not FileExists(S) then S := PATH_DATA_DOC + QDOC_UD.FieldByName(F_UD_DOC_PATH_FULL).AsString;
       S := ChangeFileExt(S, '.ini');
       If FileExists(S) then begin
          FIni := TMemIniFile.Create(S);
          LProg := TStringList.Create;
          try
             FIni.ReadSectionValues(LINI_PROG2, LProg);
             If LProg.Count > 0 then begin
                AddInfo('Выполнение программы 2', ICO_INFO); SetInfo(100, 'Выполнение программы 2');
                FDECOD.DecoderList(@LProg);
             end;
          finally
             LProg.Free;
             FIni.Free;
          end;
       end;
       AddInfo('Готово', ICO_INFO); SetInfo(100, 'Готово');
    end;

    If not Tree.Visible then ModalResult := mrOk;
end;


{==============================================================================}
{===========================   ACTION: СТОП    ================================}
{==============================================================================}
procedure TFDECOD_OLE.AStopExecute(Sender: TObject);
begin
    IS_STOP := true;
end;


{==============================================================================}
{==========================   ACTION: ЗАКРЫТЬ    ==============================}
{==============================================================================}
procedure TFDECOD_OLE.ACloseExecute(Sender: TObject);
begin
    ModalResult := mrClose;
end;


{==============================================================================}
{=====================   ACTION: ОТЧЁТ ОБ ОЩИБКАХ    ==========================}
{==============================================================================}
procedure TFDECOD_OLE.ASaveReportExecute(Sender: TObject);
begin
    SaveDlg.InitialDir := PATH_WORK;
    If SaveDlg.Execute then Tree.SaveToFile(SaveDlg.FileName);
end;



{==============================================================================}
{============================   СТРОКУ В ОТЧЕТ   ==============================}
{==============================================================================}
procedure TFDECOD_OLE.AddInfo(const Msg: String; const IndIco: Integer);
var SM: TWMVScroll;
begin
    Tree.Items.BeginUpdate;
    With Tree.Items.Add(nil, Msg) do begin
       ImageIndex    := IndIco;
       SelectedIndex := IndIco;
    end;
    Tree.Items.EndUpdate;

    {Прокрутка окна вниз}
    SM.Msg        := WM_VScroll;
    SM.ScrollCode := sb_LineDown;
    SM.Pos        := 0;
    Tree.Dispatch(SM);
    Tree.Dispatch(SM);
    Tree.Dispatch(SM);
    Tree.Refresh;

    {Видимость отчeта}
    Case IndIco of
    ICO_WARN, ICO_ERR: begin
          Bevel.Visible := false;
          Tree.Visible  := true;
          Height        := HEIGHT_MAX;
       end;
    end;

    {Возможность прерывания}
    Btn.SetFocus;
    Application.ProcessMessages;
end;


{==============================================================================}
{=============================  ИНФОРМАТОР  ===================================}
{==============================================================================}
procedure TFDECOD_OLE.SetInfo(const IVal: Integer; const SText: String);
begin
    PBar.Position := IVal;  PBar.Refresh;
    LInfo.Caption := SText; LInfo.Refresh;
end;


{==============================================================================}
{==========================  КНОПКУ ПО ЦЕНТРУ  ================================}
{==============================================================================}
procedure TFDECOD_OLE.PBottomResize(Sender: TObject);
begin
    Btn.Left := (PBottom.ClientWidth - Btn.Width) div 2;
end;


end.
