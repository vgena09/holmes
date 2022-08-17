unit MCOM;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Forms, Vcl.Controls,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ActnList, Vcl.DBCtrls, Vcl.Graphics,
  Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls,
  Data.DB, Data.Win.ADODB,
  FunType, FunConst, FunArt, MAIN;

type
  TGridAccess = class(TCustomGrid);
  TFCOM = class(TForm)
    AList: TActionList;
    AWord: TAction;
    PBottom: TPanel;
    BtnWord: TBitBtn;
    BtnClose: TBitBtn;
    LInfo: TLabel;
    PFilter: TPanel;
    LFilter: TLabel;
    EFilter: TEdit;
    EGrid: TDBGrid;
    Splitter1: TSplitter;
    EContent: TRichEdit;
    ANext: TAction;
    APrev: TAction;
    BtnNext: TBitBtn;
    BtnPrev: TBitBtn;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EFilterChange(Sender: TObject);
    procedure QAfterScroll(DataSet: TDataSet);
    procedure AWordExecute(Sender: TObject);
    procedure KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EGridResize(Sender: TObject);
    procedure ANextExecute(Sender: TObject);
    procedure APrevExecute(Sender: TObject);

  private
    FFMAIN : TFMAIN;
    Q      : TADOQuery;
    DS     : TDataSource;
  public

  end;

const MIN_FIND = 2;

var
  FCOM: TFCOM;

implementation

uses FunBD, FunText, FunSys, FunIni, FunRichEdit, FunWord, FunClip;

{$R *.dfm}

{==============================================================================}
{============================   СОЗДАНИЕ ФОРМЫ   ==============================}
{==============================================================================}
procedure TFCOM.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN        := TFMAIN(GlFindComponent('FMAIN'));
    Q             := TADOQuery.Create(Self);
    Q.Connection  := FFMAIN.BART.BD;
    Q.AfterScroll := QAfterScroll;
    DS            := TDataSource.Create(Self);
    DS.DataSet    := Q;

    With EGrid do begin
       Options    := Options + [dgRowSelect, dgAlwaysShowSelection]
                             - [dgTitleClick, dgTitleHotTrack, dgEditing, dgIndicator, dgMultiSelect];
       ReadOnly   := true;
       Color      := clBtnFace;
       DataSource := DS;
       OnKeyDown  := KeyDown;
       Columns.Clear;
       With Columns.Add do begin
           FieldName  := COM_CAPTION;
       end;
    end;
    With TGridAccess(EGrid) do begin
       Options    := Options - [goColMoving];
       ScrollBars := ssNone;
       OnResize   := EGridResize;
    end;

    With EContent do begin
       ReadOnly   := true;
       ScrollBars := ssVertical;
       Font.Name  := 'Times New Roman';
       Font.Size  := 14;
       Color      := clBtnFace;
       OnKeyDown  := KeyDown;
    end;

    With EFilter do begin
       Text       := ReadLocalString(INI_COM, INI_COM_FILTER, '');
       OnChange   := EFilterChange;
       OnKeyDown  := KeyDown;
    end;
    EFilterChange(nil);

    BtnWord .OnKeyDown   := KeyDown;
    BtnClose.OnKeyDown   := KeyDown;
    BtnClose.ModalResult := mrClose;

    {Восстанавливаем настройки из Ini}
    LoadFormIni(Self, [fspPosition], Screen.Width Div 4 * 3, Screen.Height Div 6 * 5);
    EGrid.Height := ReadLocalInteger(INI_COM, INI_COM_SEPARATOR, EGrid.Height);
end;


{==============================================================================}
{============================   ЗАКРЫТИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFCOM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    {Сохраняем настройки в Ini}
    SaveFormIni(Self, [fspPosition]);
    WriteLocalInteger(INI_COM, INI_COM_SEPARATOR, EGrid.Height);
    WriteLocalString (INI_COM, INI_COM_FILTER,    EFilter.Text);

    {Освобождаем память}
    DS.Free;
    If Q.Active then Q.Close; Q.Free;
end;


{==============================================================================}
{=======================    EFILTER: ON_CHANGE     ============================}
{==============================================================================}
procedure TFCOM.EFilterChange(Sender: TObject);
var S, SFind: String;
begin
    SFind := Trim(EFilter.Text);
    With Q do begin
       try
          DisableControls;
          If Active then Close;
          SQL.Clear;

          S := 'SELECT * FROM ['+TABLE_COM+'] ';
          If Length(SFind) >= MIN_FIND then S := S + 'WHERE ['+COM_BODY+'] LIKE '+QuotedStr('%'+SFind+'%')+' '
                                       else S := S + 'WHERE FALSE ';
          S := S+'ORDER BY ['+COM_CAPTION+'] ASC;';
          SQL.Add(S);

          AfterScroll := QAfterScroll;
          Open;
          First;
       finally
          EnableControls;
       end;
    end;
end;


{==============================================================================}
{===========================   Q: AFTER_SCROLL   ==============================}
{==============================================================================}
procedure TFCOM.QAfterScroll(DataSet: TDataSet);
var SFind        : String;
    IPos, IFocus : Integer;
    B            : Boolean;
begin
    {Инициализация}
    IPos  := 0;
    SFind := Trim(EFilter.Text);
    With EContent do begin
       Lines.BeginUpdate;
       try
          {Синхронизация текста}
          Clear;
          If Q.Active then Text := Q.FieldByName(COM_BODY).AsString;

          {Когда текст не короткий}
          If Length(SFind) >= MIN_FIND then begin

             {Выделяем найденное}
             IPos  := FindText(SFind, IPos, Length(Lines.CommaText), []);
             While IPos > -1 do begin
                SelStart  := IPos;
                SelLength := Length(SFind);
                RichEditSetColor(@EContent, clRed, clYellow, true);
                SelLength := 0; // не обязательно, если enabled = false
                IPos      := FindText(SFind, IPos+1, Length(Lines.CommaText), []);
             end;

             {Скролл на первое выделение}
             IFocus := 3;
             If EFilter .Focused then IFocus := 1;
             If EGrid   .Focused then IFocus := 2;
             If BtnClose.Focused then IFocus := 4;
             SelStart  := FindText(SFind, 0, Length(Lines.CommaText), []);
             RichEditScrollToCursor(@EContent, Self.Visible);
             SelLength := Length(SFind);
             If Self.Visible then begin
                Case IFocus of
                1: begin EFilter.SetFocus;
                         EFilter.SelStart:=Length(EFilter.Text);
                         EFilter.SelLength:=0;
                   end;
                2: EGrid   .SetFocus;
                4: BtnClose.SetFocus;
                end;
             end;
          end;
       finally
          Lines.EndUpdate;
       end;
    end;

    {Информатор}
    If Q.Active then begin
       LInfo.Caption := IntToStr(Q.RecNo)+' из '+IntToStr(Q.RecordCount);
       B := Q.RecordCount > 0;
       AWord.Enabled := B;
       ANext.Enabled := B;
       APrev.Enabled := B;
    end else begin
       LInfo.Caption := '';
       AWord.Enabled := false;
       ANext.Enabled := false;
       APrev.Enabled := false;
    end;
end;


{==============================================================================}
{=======================      ACTION: ПОИСК      ==============================}
{==============================================================================}
procedure TFCOM.ANextExecute(Sender: TObject);
begin RichEditFindSel(@EContent, Trim(Trim(EFilter.Text)), true);
end;

procedure TFCOM.APrevExecute(Sender: TObject);
begin RichEditFindSel(@EContent, Trim(Trim(EFilter.Text)), false);
end;



{==============================================================================}
{===================      ACTION: КОПИРОВАТЬ В WORD      ======================}
{==============================================================================}
procedure TFCOM.AWordExecute(Sender: TObject);
var WFont  : TFont;
    S      : String;
    IsClip : Boolean;
begin
    {Инициализация}
    If not Q.Active      then Exit;
    If Q.RecordCount = 0 then Exit;
    AWord.Enabled := false;
    try
       {Сохраним Clipboard}
       IsClip:=SaveClipboard;

       {Создаем Word}
       FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := 'Открытие Word ...';
       CreateWord;
       AddDoc;
       ZoomWord(ReadLocalInteger(INI_SET, INI_SET_ZOOM_WORD, 100));

       {Создаем шрифт}
       WFont:=TFont.Create;
       try
          WFont.Name  := 'Times New Roman';
          WFont.Size  := 15;

          {Вставляем в Word текст}
          FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := 'Вставка текста ...';
          S := EContent.Text;
          SetFontSelection(WFont, 0);
          PasteTextDoc(S);
          SetFontSelection(WFont, 0);
          AlignmentWText(3);
          FirstStrDoc(2);

          {Показываем Word}
          ScrollStartDoc;
          StartOfDoc;
          VisibleWord(true);

       finally
          WFont.Free;
          FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := '';
          If IsClip then LoadClipboard else ClearClipboard;
       end;
    finally
       AWord.Enabled := true;
    end;
end;


{==============================================================================}
{============================   GRID: KEY_DOWN   ==============================}
{==============================================================================}
procedure TFCOM.KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    27: {ESC} ModalResult := mrClose;
    end;
end;


{==============================================================================}
{===========================   GRID: ON_RESIZE    =============================}
{==============================================================================}
procedure TFCOM.EGridResize(Sender: TObject);
begin
    EGrid.Columns[0].Width := EGrid.ClientWidth;
end;

end.
