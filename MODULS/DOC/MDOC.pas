unit MDOC;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ActnList, Vcl.Buttons, Vcl.ExtCtrls, Vcl.DBGrids, Vcl.Menus, Vcl.ComCtrls,
  Vcl.DBCtrls, Vcl.OleCtnrs,
  Data.DB, Data.Win.ADODB,
  FunType, FunConst, MAIN, MOLE, MSTRUCT;

type
  TGridAccess = class(TCustomGrid);
  TFDOC = class(TForm)
    AList: TActionList;
    AAddDir: TAction;
    ADel: TAction;
    AProp: TAction;
    AFinder: TAction;
    AFinderHide: TAction;
    AHint: TAction;
    PMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    PFinder: TPanel;
    SplitStruct: TSplitter;
    PLeft: TPanel;
    PGrid: TPanel;
    DBGrid: TDBGrid;
    AOpen: TAction;
    N7: TMenuItem;
    N8: TMenuItem;
    Ole: TOleContainer;
    AOk: TAction;
    N12: TMenuItem;
    PStruct: TPanel;
    LFind: TLabel;
    BtnClose: TBitBtn;
    EFind: TEdit;
    AAddFile: TAction;
    N4: TMenuItem;

    {Модуль: MDOC_GRID}
    procedure QAfterScroll(DataSet: TDataSet);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridTitleClick(Column: TColumn);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridResize(Sender: TObject);
    procedure DBGridMouseEnter(Sender: TObject);
    procedure QGetText(Sender: TField; var Text: String; DispalayText: Boolean);

    {Модуль: MDOC_FINDER}
    procedure AFinderExecute(Sender: TObject);
    procedure AFinderHideExecute(Sender: TObject);
    procedure EFindChange(Sender: TObject);

    {Модуль: MDOC_HINT}
    procedure AHintExecute(Sender: TObject);

    {Модуль: MDOC_STRUCT}
    procedure PStructResize(Sender: TObject);

    {Модуль: MDOC}
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AAddDirExecute(Sender: TObject);
    procedure ADelExecute(Sender: TObject);
    procedure APropExecute(Sender: TObject);
    procedure AOpenExecute(Sender: TObject);
    procedure AOkExecute(Sender: TObject);
    procedure AAddFileExecute(Sender: TObject);

  private
    FFMAIN   : TFMAIN;
    FFSTRUCT : TFSTRUCT;
    FHINT    : TFORM;
    EHINT    : TDBRichEdit;
    DS       : TDataSource;
    Q        : TADOQuery;
    LOpenDoc : array of TForm;       // Список указателей на формы открытых документов

    {Модуль: MDOC_GRID}
    procedure IniGrid;
    procedure RefreshGrid;
    procedure SaveSel(const ICounter: Integer);
    procedure LoadSel;

    {Модуль: MDOC_FINDER}
    procedure IniFinder;

    {Модуль: MDOC_HINT}
    procedure IniHint;

    {Модуль: MDOC_STRUCT}
    procedure IniStruct;
    procedure FreeStruct;

    {Модуль: MDOC}
    procedure EnablAction;
    procedure FileNew(const SPath: String);

    procedure DocAdd(const IDDoc: Integer; const IsForceDecod: Boolean);
    procedure DocDel(const F: TForm);
    procedure EventCloseDoc(const F: TForm);
    procedure DocDelAll;
    function  IsDocFirstCopy(const ID: Integer): Boolean;

  public
    {Модуль: MDOC_HINT}
    procedure HintClose(Sender: TObject; var Action: TCloseAction);
  end;

const GRID_COL : array [0..2] of String = (F_UD_DOC_CAPTION, F_UD_DOC_DATE, F_UD_DOC_CONTROL);
      GRID_COL_CAPTION  = 0;
      GRID_COL_DATE     = 1;
      GRID_COL_CONTROL  = 2;

var
  FDOC: TFDOC;

implementation

uses FunSys, FunIni, FunText, FunBD, FunDecoder, FunDay, FunList, FunVcl,
     MDOC_NEW, MDOC_PROP, MVAR;

{$R *.dfm}
{$INCLUDE MDOC_GRID}
{$INCLUDE MDOC_FINDER}
{$INCLUDE MDOC_HINT}
{$INCLUDE MDOC_STRUCT}

{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
{!!!  В ЛОКАЛЬНЫХ НАСТРОЙКАХ СОХРАНЯЕМ ТОЛЬКО СОРТИРОВКУ, ПОИСК, ПРИМЕЧАНИЕ  !!}
{!!!  ОСТАЛЬНОЕ - В БАЗЕ ДАННЫХ ДЕЛА                                         !!}
{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}

{==============================================================================}
{============================   СОЗДАНИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFDOC.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN           := TFMAIN(GlFindComponent('FMAIN'));
    FHINT            := nil;
    EHINT            := nil;
    Q                := TADOQuery.Create(Self);
    Q.Connection     := FFMAIN.BUD.BD;
    DS               := TDataSource.Create(Self);
    DS.DataSet       := Q;
    SetLength(LOpenDoc, 0);

    CopyMenu(@PMenu.Items, @FFMAIN.NDOC);
    FFMAIN.NDOC.Enabled := true;

    With Ole do begin
       Left           := 100000;
       AllowInPlace   := true;          // открывать в OLE
       Iconic         := false;
       AllowActiveDoc := false;         // без поддержки интерфейса IOleDocumentSite
       AutoActivate   := aaManual;      // без автоактивации
       AutoVerbMenu   := false;         // без меню OLE-сервера
       CopyOnSave     := true;          // сжимать перед сохранением
    end;

    IniGrid;
    IniFinder;
    IniHint;
    IniStruct;
 end;


{==============================================================================}
{============================   ЗАКРЫТИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFDOC.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    {Закрываем примечание}
    AHint.Checked := false;
    AHintExecute(nil);
    {Выгружаем субформу}
    FreeStruct;
    {Удаляем ссылки на открытые документы}
    DocDelAll;
    {Отключаем главное меню}
    FFMAIN.NDOC.Enabled := false;
    FFMAIN.NDOC.Clear;
    {Синхронизируем и отключаем БД}
    With Q do begin
       If Active then begin
          If RecordCount > 0 then begin
             Edit; UpdateRecord; Post;
          end;
          Close;
       end;
       Free;
    end;
    DS.Free;
    {Освобождаем OLE-контейнер}
    If Ole.State <> osEmpty then Ole.Close; Ole.DestroyObject;
    {Разное}
    FFMAIN.StatusBar.Panels[STATUS_DOC].Text := '';
end;


{==============================================================================}
{==========================  ACTION: ДОСТУПНОСТЬ  =============================}
{==============================================================================}
procedure TFDOC.EnablAction;
var IsSQL, IsReady, IsClose : Boolean;
begin
    If Q.Active then IsSQL   := Q.RecordCount > 0
                else IsSQL   := false;
    If IsSQL    then IsReady := Q.FieldByName(F_UD_DOC_OK).AsBoolean
                else IsReady := false;
    IsClose := IsDocFirstCopy(Q.FieldByName(F_COUNTER).AsInteger);

    //AFind.Enabled  := Trim(CBFind.Text) <> '';
    ADel .Enabled  := IsSQL and IsClose and (not IsReady);
    AProp.Enabled  := IsSQL and IsClose;
    AOpen.Enabled  := IsSQL and IsClose;
    AOk.Enabled    := IsSQL and IsClose;
    AOk.Checked    := IsReady;
    If EHINT <> nil then EHINT.Enabled  := IsSQL;
end;


{==============================================================================}
{========================   ACTION: СОЗДАТЬ БЛАНК   ===========================}
{==============================================================================}
// Автодокумент может располагаться в ЛЮБОМ месте
// Признак автодокумента - наличие переменных в его ini-файле
// Бланк простого документа декодируется при создании
// Сначала пытаемся читать полный путь, при отсутствии там файла - относительный

procedure TFDOC.AAddDirExecute(Sender: TObject);
var FDOC  : TFDOC_NEW;
    SPath : String;
begin
//    {Дополнительная возможность: выбор файла}
//    If GetKeyState(VK_SHIFT) then begin
//       AAddFile.Execute;
//       Exit;
//    end;

    {Инициализация}
    Refresh;

    {Выбираем файл бланка документа}
    FDOC := TFDOC_NEW.Create(Self);
    try     SPath := FDOC.SelectDoc;
    finally FDOC.Free; end;

    {Создаем документ}
    If SPath <> '' then FileNew(SPath);
end;

procedure TFDOC.AAddFileExecute(Sender: TObject);
var Dlg   : TOpenDialog;
    SPath : String;
begin
    {Выбираем файл бланка документа}
    FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := 'Выбор файла ...';
    FFMAIN.Refresh;
    Dlg := TOpenDialog.Create(Self);
    try
       With Dlg do begin
          Filter     := 'Документы Word (*.doc, *.docx)|*.doc;*.docx';
          DefaultExt := '.doc';
          Options    := Dlg.Options  + [ofPathMustExist, ofFileMustExist] - [ofHideReadOnly];
          Title      := 'Выбор файла';
          InitialDir := PATH_DATA_DOC;
          If not Execute then Exit;
          SPath      := FileName;
       end;
    finally
       Dlg.Free;
       FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := '';
    end;

    {Создаем документ}
    If SPath <> '' then FileNew(SPath);
end;


procedure TFDOC.FileNew(const SPath: String);
const VAR_COPY : array [0..4] of String = (F_VAR_VAL_STR, F_VAR_CAPTION,        // !!! F_VAR_VAL_STR должно быть первым чтобы потом можно было перекрыть
                 F_VAR_TYPE, F_VAR_PARAM, F_VAR_HINT);
var F                 : TFOLE;
    FDECOD            : TDECOD;
    TVAR_GLOBAL       : TADOTable;     // Таблица глобальных переменных
    TDOC,  TVAR       : TADOTable;     // Таблицы БД "Дела"
    IDDoc, ISec, IVar : Integer;
    SVal, S           : String;
    FIni              : TMemIniFile;
    LSection, LProg   : TStringList;

    {Читает значение ключа}
    function ReadFIniVal(const Section, Key, Val0: String): String;
    begin
        If FIni <> nil then Result := FIni.ReadString(Section, Key, Val0)
                       else Result := Val0;
    end;

    {Читает значение секции}
    function ReadFIniList(const Section: String): String;
    var L: TStringList;
    begin
        Result := '';
        If FIni = nil then Exit;
        L := TStringList.Create;
        try     FIni.ReadSectionValues(Section, L);
                Result := L.Text;
        finally L.Free; end;
    end;

begin
    {Инициализация}
    Refresh;

    {Инициализируем файл ini}
    S := ChangeFileExt(SPath, '.ini');
    If FileExists(S) then FIni := TMemIniFile.Create(S) else FIni := nil;

    TDOC := FFMAIN.BUD.TDOC; //LikeTable(@FFMAIN.BUD.TDOC);
    TVAR := FFMAIN.BUD.TVAR; //LikeTable(@FFMAIN.BUD.TVAR);
    TVAR_GLOBAL := LikeTable(@FFMAIN.BSET_LOCAL.TVAR);
    LSection := TStringList.Create;
    try
       {Список секций-переменных}
       If FIni <> nil then begin
          FIni.ReadSections(LSection);
          For ISec := LSection.Count-1 downto 0 do begin
             If LSection[ISec]    = ''  then begin LSection.Delete(ISec); Continue; end;
             If LSection[ISec][1] = ':' then begin LSection.Delete(ISec); Continue; end;
          end;
       end;

       {Регистрируем документ в БД дела}
       With TDOC do begin
          Insert;
          FieldByName(F_UD_DOC_CAPTION).AsString    := ReadFIniVal (LINI_DOC, LINI_DOC_CAPTION, ExtractFileNameWithoutExt(SPath));
          FieldByName(F_UD_DOC_AUTO).AsBoolean      := LSection.Count > 0;
          FieldByName(F_UD_DOC_OK).AsBoolean        := not (LSection.Count > 0);
          FieldByName(F_UD_DOC_DATE).AsDateTime     := Date;
          FieldByName(F_UD_DOC_HINT).AsString       := ReadFIniList(LINI_HINT);
          FieldByName(F_UD_DOC_MODIFY).AsDateTime   := Now;
          FieldByName(F_UD_DOC_PATH_FULL).AsString  := SPath;
          IVar := FindStr(PATH_DATA_DOC, SPath);
          If IVar = 1 then FieldByName(F_UD_DOC_PATH_SHORT).AsString := Copy(SPath, Length(PATH_DATA_DOC)+1, Length(SPath))
                      else FieldByName(F_UD_DOC_PATH_SHORT).AsString := '';
          UpdateRecord;
          Post;
          IDDoc := FieldByName(F_COUNTER).AsInteger;
       end;
       SaveSel(IDDoc);
       RefreshTable(@FFMAIN.BUD.TDOC);

       try
          FDECOD := TDECOD.Create(IntToStr(IDDoc));

          {********************************************************************}
          {*** Для автодокумента - заполняем таблицу переменных ***************}
          {********************************************************************}
          If LSection.Count > 0 then begin
             For ISec := 0 to LSection.Count-1 do begin
                With TVAR do begin
                   Insert;
                   FieldByName(F_VAR_DOC) .AsInteger := IDDoc;
                   FieldByName(F_VAR_NAME).AsString  := LSection[ISec];
                   For IVar := Low(VAR_COPY) to High(VAR_COPY) do begin
                      SVal := FIni.ReadString(LSection[ISec], VAR_COPY[IVar], '');
                      If (VAR_COPY[IVar] = F_VAR_CAPTION) and (SVal = '') then SVal := LSection[ISec];
                      If SVal = ''  then Continue;

                      // STR = {Переменная} - копируем STR и OLE
                      If VAR_COPY[IVar] = F_VAR_VAL_STR then begin
                         S := Trim(CutModulChar(SVal, '{', '}'));
                         If S <> '' then begin
                            SetDBFilter(@TVAR_GLOBAL, '['+F_VAR_NAME+']='+QuotedStr(S));
                            If TVAR_GLOBAL.RecordCount = 1 then begin
                               TVAR.FieldByName(F_VAR_TYPE   ).Assign(TVAR_GLOBAL.FieldByName(F_VAR_TYPE   ));
                               //TVAR.FieldByName(F_VAR_PARAM  ).Assign(TVAR_GLOBAL.FieldByName(F_VAR_PARAM  ));
                               TVAR.FieldByName(F_VAR_PARAM).AsString := F_VAR_PARAM_VALUE+'=ДА' +CH_NEW+
                                                                         F_VAR_PARAM_SHOW +'=НЕТ'+CH_NEW+
                                                                         TVAR_GLOBAL.FieldByName(F_VAR_PARAM).AsString;
                               TVAR.FieldByName(F_VAR_VAL_STR).Assign(TVAR_GLOBAL.FieldByName(F_VAR_VAL_STR));
                               TVAR.FieldByName(F_VAR_VAL_OLE).Assign(TVAR_GLOBAL.FieldByName(F_VAR_VAL_OLE));
                               TVAR.FieldByName(F_VAR_HINT   ).Assign(TVAR_GLOBAL.FieldByName(F_VAR_HINT   ));
                               Continue;
                            end;
                         end;
                      end;
                      FieldByName(VAR_COPY[IVar]).AsString := FDECOD.Decoder(SVal);
                   end;
                   UpdateRecord;
                   Post;
                end;
             end;
             RefreshTable(@TVAR); // SetDBFilter(@TVAR, '');
          end;


          {********************************************************************}
          {*** При наличии выполняем программу 1 ******************************}
          {********************************************************************}
          If FIni <> nil then begin
             LProg := TStringList.Create;
             try     FIni.ReadSectionValues(LINI_PROG1, LProg);
                     FDECOD.DecoderList(@LProg);
             finally LProg.Free; end;
          end;


          {********************************************************************}
          {*** Для простого документа - импорт + декодитрование ***************}
          {********************************************************************}
          If LSection.Count = 0 then begin
             F := TFOLE.Create(Self);
             try     If not F.ImportDoc(IDDoc, SPath) then Exit;
             finally F.Free; end;
          end;

       finally
          FDECOD.Free;
       end;
    finally
       If FIni <> nil then FIni.Free;
       LSection.Free;
       // If TDOC.Active then TDOC.Close; TDOC.Free; //RefreshTable(@FFMAIN.BUD.TDOC);
       // If TVAR.Active then TVAR.Close; TVAR.Free; //RefreshTable(@FFMAIN.BUD.TVAR);
       SetDBFilter(@TVAR_GLOBAL, '');
       If TVAR_GLOBAL.Active then TVAR_GLOBAL.Close; TVAR_GLOBAL.Free;
       RefreshTable(@FFMAIN.BUD.TDOC);
       RefreshTable(@FFMAIN.BUD.TVAR);
       RefreshGrid;
    end;

    {Открыть документ + окно переменных для автодокумента}
    AOpen.Execute;
end;


{==============================================================================}
{=======================   ACTION: УДАЛИТЬ ДОКУМЕНТ   =========================}
{==============================================================================}
procedure TFDOC.ADelExecute(Sender: TObject);
var TVAR  : TADOTable;
    IDDoc : Integer;
begin
    {Инициализация}
    Refresh;
    If Q.RecordCount = 0 then Exit;
    If MessageDlg('Подтвердите удаление документа:'+CH_NEW+
       Q.FieldByName(F_CAPTION).AsString, mtInformation, [mbYes, mbNo], 0)<>mrYes then Exit;
    IDDoc := Q.FieldByName(F_COUNTER).AsInteger;
    {Удаляем связанные переменные}
    TVAR  := LikeTable(@FFMAIN.BUD.TVAR);
    try
       SetDBFilter(@TVAR, '['+F_VAR_DOC+']='+IntToStr(IDDoc));
       While TVAR.RecordCount > 0 do TVAR.Delete;
    finally
       If TVAR.Active then TVAR.Close; TVAR.Free; //RefreshTable(@FFMAIN.BUD.TVAR);
    end;
    {Удаляем документ}
    Q.Delete;
    FFMAIN.BUD.TVAR.Close; FFMAIN.BUD.TVAR.Open;  // RefreshTable(@FFMAIN.BUD.TVAR);
    FFMAIN.BUD.TDOC.Close; FFMAIN.BUD.TDOC.Open;  // RefreshTable(@FFMAIN.BUD.TDOC);
    RefreshGrid;
end;


{==============================================================================}
{=====================   ACTION: СВОЙСТВА ДОКУМЕНТА   =========================}
{==============================================================================}
procedure TFDOC.APropExecute(Sender: TObject);
var F: TFDOC_PROP;
begin
    F := TFDOC_PROP.Create(Self);
    try     F.Execute(Q.FieldByName(F_COUNTER).AsString);
    finally F.Free; end;
    Q.Refresh;
    RefreshTable(@FFMAIN.BUD.TDOC);
    RefreshGrid;
end;


{==============================================================================}
{======================   ACTION: ОТКРЫТЬ ДОКУМЕНТ   ==========================}
{==============================================================================}
procedure TFDOC.AOpenExecute(Sender: TObject);
var FVAR    : TFVAR;
    QVAR    : TADOQuery;
    S       : String;
    mResult : Integer;
begin
    {Инициализация}
    Refresh;
    If DBGrid.SelectedIndex < 0 then Exit;

    {*** Время модификации ****************************************************}
    With Q do begin
       Edit;
       FieldByName(F_UD_DOC_MODIFY).AsDateTime := Now;
       UpdateRecord;
       Post;
    end;

    {*** Простой документ *****************************************************}
    If     Q.FieldByName(F_UD_DOC_OK)  .AsBoolean or
      (not Q.FieldByName(F_UD_DOC_AUTO).AsBoolean) then begin
       DocAdd(Q.FieldByName(F_COUNTER).AsInteger, false);

    {*** Автодокумент *********************************************************}
    end else begin
       QVAR            := TADOQuery.Create(Self);
       QVAR.Connection := FFMAIN.BUD.BD;
       FVAR            := TFVAR.Create(Self);
       try
          S := 'SELECT * FROM ['+T_UD_VAR+'] '+
               'WHERE ['+F_VAR_DOC+']='+Q.FieldByName(F_COUNTER).AsString+' '+
               'ORDER BY ['+F_VAR_CAPTION+'] ASC;';
          QVAR.SQL.Text := S;
          QVAR.Open;
          If QVAR.RecordCount = 0 then Exit;

          FVAR.Caption := 'Переменные документа: ' + ReadField(@FFMAIN.BUD.BD, T_UD_DOC,
                          QVAR.FieldByName(F_VAR_DOC).AsInteger, F_UD_DOC_CAPTION);
          mResult := FVAR.Execute(@QVAR, @FFMAIN.BUD.TSYS, Q.FieldByName(F_COUNTER).AsInteger);
       finally
          FVAR.Free;
          If QVAR.Active then QVAR.Close; QVAR.Free;
       end;
       RefreshTable(@FFMAIN.BUD.TVAR);

       {Построение документа}
       If mResult = mrOk then begin
          Application.ProcessMessages;
          DocAdd(Q.FieldByName(F_COUNTER).AsInteger, true);
       end;

       {Обновить структуру элементов дела}
       If FFSTRUCT <> nil then FFSTRUCT.RefreshTree;
   end;
end;


{==============================================================================}
{=====================   ACTION: ГОТОВНОСТЬ ДОКУМЕНТА  ========================}
{==============================================================================}
procedure TFDOC.AOkExecute(Sender: TObject);
begin
    With Q do begin
       Edit;
       FieldByName(F_UD_DOC_OK).AsBoolean      := not FieldByName(F_UD_DOC_OK).AsBoolean;
       FieldByName(F_UD_DOC_MODIFY).AsDateTime := Now;
       UpdateRecord;
       Post;
    end;
    RefreshTable(@FFMAIN.BUD.TDOC);
    RefreshGrid;
end;


{==============================================================================}
{==============   РАБОТА С УКАЗАТЕЛЯМИ НА ОТКРЫТЫЕ ДОКУМЕНТЫ   ================}
{==============================================================================}
procedure TFDOC.DocAdd(const IDDoc: Integer; const IsForceDecod: Boolean);
var F: TFOLE;
begin
    {Документ должен быть закрыт}
    If not IsDocFirstCopy(IDDoc) then begin
       FFMAIN.IconMsg('Внимание', 'Данный документ уже открыт.', bfWarning);
       Exit;
    end;

    {Создание OLE}
    F := TFOLE.Create(Self);
    If not F.OpenDoc(IDDoc, IsForceDecod, EventCloseDoc) then F.Free
    else begin
       SetLength(LOpenDoc, Length(LOpenDoc)+1);
       LOpenDoc[High(LOpenDoc)] := F;
    end;

    {Обновляем список документов}
    RefreshGrid;
end;

procedure TFDOC.DocDel(const F: TForm);
var I, J: Integer;
begin
    For I:=Low(LOpenDoc) to High(LOpenDoc) do begin
       If LOpenDoc[I] <> F then Continue;
       TFOLE(LOpenDoc[I]).Free;
       For J:=I to High(LOpenDoc)-1 do LOpenDoc[J]:=LOpenDoc[J+1];
       SetLength(LOpenDoc, Length(LOpenDoc)-1);
       Break;
    end;
    EnablAction;
    DBGrid.Repaint;
end;

procedure TFDOC.EventCloseDoc(const F: TForm);
begin
    Application.ProcessMessages;
    DocDel(F);
end;

procedure TFDOC.DocDelAll;
var I: Integer;
begin
    For I:=Low(LOpenDoc) to High(LOpenDoc) do TFOLE(LOpenDoc[I]).Free;
    SetLength(LOpenDoc, 0);
end;

function TFDOC.IsDocFirstCopy(const ID: Integer): Boolean;
var I: Integer;
begin
    Result := true;
    For I:=Low(LOpenDoc) to High(LOpenDoc) do begin
       If TFOLE(LOpenDoc[I]).IDDoc <> ID then Continue;
       Result := false;
       Break;
    end;
end;


end.
