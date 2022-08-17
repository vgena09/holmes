unit FunWord;

interface
  uses Winapi.Windows,
       System.SysUtils, System.Variants,
       Vcl.Graphics, Vcl.Clipbrd, Vcl.OleCtnrs,
       FunType;

const
MAXLENWORDDOC = 999999999;

wdBorderTop=-1;
wdBorderLeft=-2;
wdBorderBottom=-3;
wdBorderRight=-4;

wdLineStyleNone=0;
wdLineStyleSingle=1;
wdLineStyleDot=2;
wdLineStyleDashSmallGap=3;
wdLineStyleDashLargeGap=4;
wdLineStyleDashDot=5;
wdLineStyleDashDotDot=6;
wdLineStyleDouble=7;
wdLineStyleTriple=8;
wdLineStyleThinThickSmallGap=9;
wdLineStyleThickThinSmallGap=10;
wdLineStyleThinThickThinSmallGap=11;
wdLineStyleThinThickMedGap=12;
wdLineStyleThickThinMedGap=13;
wdLineStyleThinThickThinMedGap=14;
wdLineStyleThinThickLargeGap=15;
wdLineStyleThickThinLargeGap=16;
wdLineStyleThinThickThinLargeGap=17;
wdLineStyleSingleWavy=18;
wdLineStyleDoubleWavy=19;
wdLineStyleDashDotStroked=20;
wdLineStyleEmboss3D=21;
wdLineStyleEngrave3D=22;

{Полный текст из закрытого WORD в Clipboard}
function WordToClip(const FPath: String): Boolean;                              StdCall
{Полный текст из закрытого WORD}
function WordToTxt(const FPath: String): AnsiString;                            StdCall


{Открыть Ole-WORD}
function OpenOle(const POle: POleContainer; const IVerb: Integer): Boolean;     StdCall
{Создать объект WORD}
function CreateWord: Boolean;                                                   StdCall
{Установить видимость WORD}
function VisibleWord(Visible: Boolean): Boolean;                                StdCall
{Установить масштаб WORD}
function ZoomWord(const IZoom: Integer): Boolean;                               StdCall
{Создать новый документ}
function AddDoc:boolean;                                                        StdCall
{Возвратить указатель на WORD}
function GetWordApplicationID: Variant;                                         StdCall
{Установить указатель на WORD}
procedure SetWordApplicationID(const ID: Variant);                              StdCall
{Вставить текст text_ в документ}
function SetTextToDoc(text_: String; InsertAfter_: Boolean): Boolean;           StdCall
{Сохранить документ}
function SaveDoc: Boolean;                                                      StdCall
{Сохранить документ в файл file_}
function SaveDocAs(file_: String): Boolean;                                     StdCall
{Сохранить документ в файл file_ в формате Unicod}
function SaveDocAsUnicod(file_:string):boolean;                                 StdCall
{Сохранить документ в файл file_ в текстовом формате}
function SaveDocAsText(file_:string):boolean;                                   StdCall
{Сохранить документ в файл file_ в DOSовском формате}
function SaveDocAsDosText(file_:string):boolean;                                StdCall
{Закрыть документ}
function CloseDoc:boolean;                                                      StdCall
{Закрыть Word}
function CloseWord:boolean;                                                     StdCall
{Открыть документ FileName}
function OpenDoc(const FileName: String): Boolean;                              StdCall
{Переместить курсор в начало документа}
function StartOfDoc:boolean;                                                    StdCall
{Переместить курсор в конец документа}
function EndOfDoc:boolean;                                                      StdCall
{Промотать документ вверх}
function ScrollStartDoc: Boolean;                                               StdCall
{Устанавливает курсор на закладку}
function GotoBookmarkDoc(const Bookmark: string):Boolean;                       StdCall
{Устанавливает курсор на закладку и возвращает позицию закладки}
function BookMarkPosDoc(const BmName: String): Integer;                         StdCall
{Устанавливает выделение между IStart и IEnd}
function SelectedDoc(const IStart, IEnd: Int64):Boolean;                        StdCall
{Возвращает текст между IStart и IEnd}
function GetSelectedTextDoc(const IStart, IEnd: Int64): String;                 StdCall
{Печать NumCopies копий документа}
function PrintOutDoc(NumCopies:integer):boolean;                                StdCall
{Поиск в документе строки text_ и её выделение}
function FindTextDoc(text_: string): Boolean;                                   StdCall
{Вставить текстовое содержимое буфера}
function PasteClipbordDoc:boolean;                                              StdCall
{Вставить любое содержимое буфера}
function PasteClipbordDocAll:boolean;                                           StdCall
{Добавить текст в документ}
function AddTextDoc(text_: String; const font_: TFont; ColorIndex: Integer): Boolean; StdCall
{Вставить текст в документ, удалив выделенный фрагмент}
function PasteTextDoc(text_:string):boolean;                                    StdCall
{Вставить текст в документ, удалив выделенный фрагмент}
function TypeTextDoc(text_:string):boolean;                                     StdCall
{Устанавливает размер выделенного текста}
function SetFontSizeSelection(Size:integer):boolean;                            StdCall
{Устанавливает шрифт имени Name на выделенный текст}
function SetFontNameSelection(Name:string):boolean;                             StdCall
{Устанавливает тип и цвет выделенного шрифта}
function SetFontSelection(font: TFont; ColorIndex: Integer): Boolean;           StdCall
{Находит в тексте и заменяет findtext_ на pastetext_}
function FindAndPasteTextDoc(findtext_,pastetext_:string):boolean;              StdCall
{Показать диалоговое окно печати}
function PrintDialogWord:boolean;                                               StdCall


{*****************************  Т А Б Л И Ц Ы  ********************************}
{Создать таблицу}
function CreateTable(NumRows, NumColumns:integer;var index:integer):boolean;    StdCall
{Установить размер строк и столбцов таблицы}
function SetSizeTable(Table:integer;RowsHeight, ColumnsWidth:real):boolean;     StdCall
{Получить размер строк и столбцов таблицы}
function GetSizeTable(Table:integer;var RowsHeight,ColumnsWidth:real):boolean;  StdCall
{Установить высоту RowHeight строки Row таблицы Table}
function SetHeightRowTable(Table,Row:integer;RowHeight:real):boolean;           StdCall
{Установить ширину ColumnWidth строки Row таблицы Table}
function SetWidthColumnTable(Table,Column:integer;ColumnWidth:real):boolean;    StdCall
{Записать текст text в ячейку Row,Column таблицы Table}
function SetTextToTable(Table:integer;Row,Column:integer;text:string):boolean;  StdCall
{Установить тип и стиль границ ячейки Row,Column таблицы Table}
function SetLineStyleBorderTable(Table:integer;Row,Column,wdBorderType,wdBorderStyle:integer):boolean;   StdCall
{Добавить ячейки Row2,Column2 к таблице после ячеек Row1,Column1}
function SetMergeCellsTable(Table:integer;Row1,Column1,Row2,Column2:integer):boolean;                    StdCall
{Выделить таблицу}
function GetSelectionTable:boolean;                                             StdCall
{Выделить следующую таблицу}
function GoToNextTable (table_:integer):boolean;                                StdCall
{Выделить предыдущую таблицу}
function GoToPreviousTable (table_:integer):boolean;                            StdCall
{Получить число строк и столбцов выделенной таблицы}
function GetColumnsRowsTable(table_:integer; var Columns,Rows:integer):boolean; StdCall
{Получить левую верхнюю ячейку выделенной области таблицы}
function GetColumnRowTable(table_:integer; var Column,Row:integer):boolean;     StdCall
{Добавить в таблицу строку}
function AddRowTableDoc (table_:integer):boolean;                               StdCall
{Добавить count_ строк после строки position_}
function InsertRowsTableDoc(table_,position_,count_:integer):boolean;           StdCall
{Добавить в таблицу в позицию position_ строку}
function InsertRowTableDoc(table_,position_:integer):boolean;                   StdCall
{Выделить ячейку}
function SelectCell(Table:integer; Row,Column:integer):boolean;                 StdCall


{*******************************  TextBox  ************************************}
{Создать объект TextBox}
function CreateTextBox(Left,Top,Width,Height:real;var name:string):boolean;     StdCall
{Вставить текст text в объект TextBox}
function TextToTextBox(TextBox:variant;text:string):boolean;                    StdCall

{*****************************      Линии   ***********************************}
{Создать линию}
function CreateLine(BeginX,BeginY,EndX,EndY:real;var name:string):boolean;      StdCall

{***************************   Внешний рисунок   ******************************}
{Вставить рисунок в документ}
function CreatePicture(FileName:string;Left,Top:real;var name:string):boolean;  StdCall
{Вставляет в документ картинку fnamepic_ и устанавливает её размер dx_,dy_ м/б=0}
function PastePicDoc(fnamepic_:string; dx_, dy_:integer):boolean;               StdCall

{*************************  Общие для формы функции  **************************}
function DeleteShape (NameShape:variant): variant;                              StdCall
function SetNewNameShape(NameShape:variant;NewNameShape:string):string;         StdCall
function GetNameIndexShape(NameIndex:variant):string;                           StdCall

{*****************************  Новые функции  ********************************}
{Выделяет верхний колонтитул документа}
function SelectHeaderDoc: Boolean;                                              StdCall
{Выделяет нижний колонтитул документа}
function SelectFooterDoc: Boolean;                                              StdCall
{Выделяет основную часть документа}
function SelectMainDoc: Boolean;                                                StdCall
{Число символов Сh в документе}
function GetCountWordChar(const Ch: Char): Integer;                             StdCall
{Ищет в документе и возвращает строку-ключ в фигурных скобках}
function FindKeyTextDoc:string;                                                 StdCall

{****************************  ФОРМАТИРОВАНИЕ  ********************************}
{Выравнивание параграфа}
function AlignmentWText(const Align: Integer):boolean;                          StdCall
{Отступ красной строки}
function FirstStrDoc(const I: Integer):boolean;                                 StdCall


var W: Variant;

implementation

uses ComObj, OleServer, Word2000,
     FunConst, FunText;


{******************************************************************************}
{**************  Полный текст из закрытого WORD в Clipboard  ******************}
{******************************************************************************}
function WordToClip(const FPath: String): Boolean;
begin
    Result:=false;
    If CmpStr(ExtractFileExt(FPath), '.DOC') = false then Exit;
    If FileExists(FPath)                     = false then Exit;
    If CreateWord                            = false then Exit;
    try
       If OpenDoc(FPath)=false then Exit;
       try     SelectedDoc(0, MAXLENWORDDOC);
               W.Selection.Copy;
       finally CloseDoc; end;
    finally CloseWord; end;
    Result:=true;
end;


{******************************************************************************}
{********************  Полный текст из закрытого WORD  ************************}
{******************************************************************************}
function WordToTxt(const FPath: String): AnsiString;
var I: Integer;
begin
    Result:='';
    If CmpStr(ExtractFileExt(FPath), '.DOC') = false then Exit;
    If FileExists(FPath)                     = false then Exit;
    If CreateWord                            = false then Exit;
    try
       If OpenDoc(FPath)=false then Exit;
       try
          Result:=GetSelectedTextDoc(0, MAXLENWORDDOC);
          For I:=Length(Result) downto 1 do begin
             If Integer(Result[I])<10 then Delete(Result, I, 1);
          end;
       finally
          CloseDoc;
       end;
    finally
       CloseWord;
    end;
end;


{******************************************************************************}
{***************************  Открыть Ole-WORD  *******************************}
{******************************************************************************}
function OpenOle(const POle: POleContainer; const IVerb: Integer): Boolean;
begin
    Result := true;
    try    POle^.DoVerb(IVerb);
           W := POle^.OleObject.Application;
    except Result := false;
    end;
end;


{******************************************************************************}
{**************************  Создать объект WORD  *****************************}
{******************************************************************************}
function CreateWord: Boolean;
begin
    Result := true;
    try    W := CreateOleObject('Word.Application');
    except Result := false;
    end;
end;


{******************************************************************************}
{***********************  Установить видимость WORD  **************************}
{******************************************************************************}
function VisibleWord(Visible: Boolean): Boolean;
begin
    Result := true;
    try    W.visible := Visible;
    except Result := false;
    end;
end;


{******************************************************************************}
{************************  Установить масштаб WORD  ***************************}
{******************************************************************************}
function ZoomWord(const IZoom: Integer): Boolean;
begin
    Result := true;
    try    W.ActiveWindow.ActivePane.View.Zoom.Percentage := IZoom;
    except Result := false;
    end;
end;


{******************************************************************************}
{**************************  Создать новый документ  **************************}
{******************************************************************************}
function AddDoc:boolean;
var Doc_: Variant;
begin
    AddDoc:=true;
    try
       Doc_:=W.Documents;
       Doc_.Add;
    except
       AddDoc:=false;
    end;
end;


{******************************************************************************}
{********************  Возвратить указатель на WORD  **************************}
{******************************************************************************}
function GetWordApplicationID: Variant;
begin
    try    Result := W;
    except Result := 0; end;
end;


{******************************************************************************}
{********************  Установить указатель на WORD  **************************}
{******************************************************************************}
procedure SetWordApplicationID(const ID: Variant);
begin
    W := ID;
end;

{******************************************************************************}
{*********************  Вставить текст text_ в документ  **********************}
{******************************************************************************}
function SetTextToDoc(text_: String; InsertAfter_: Boolean): Boolean;
var Rng: Variant;
begin
    Result:=true;
    try    Rng := W.ActiveDocument.Range;
           if InsertAfter_ then Rng.InsertAfter(text_) else Rng.InsertBefore(text_);
    except Result := false; end;
end;



{******************************************************************************}
{***************************  Сохранить документ  *****************************}
{******************************************************************************}
function SaveDoc: Boolean;
begin
    SaveDoc:=true;
    try    W.ActiveDocument.Save;
    except SaveDoc:=false; end;
end;


{******************************************************************************}
{************************  Сохранить документ в файл file_  *******************}
{******************************************************************************}
function SaveDocAs(file_: String): Boolean;
begin
    SaveDocAs:=true;
    try    ForceDirectories(ExtractFilePath(file_));
           W.ActiveDocument.SaveAs(file_);
    except SaveDocAs:=false; end;
end;


{******************************************************************************}
{************** Сохранить документ в файл file_ в формате Unicod  *************}
{******************************************************************************}
function SaveDocAsUnicod(file_:string):boolean;
const wdFormatUnicodeText=7;
begin
    SaveDocAsUnicod:=true;
    try    W.ActiveDocument.SaveAs(file_, FileFormat:=wdFormatUnicodeText);
    except SaveDocAsUnicod:=false; end;
end;


{******************************************************************************}
{*************  Сохранить документ в файл file_ в текстовом формате  **********}
{******************************************************************************}
function SaveDocAsText(file_:string):boolean;
const wdFormatText=2;
begin
    SaveDocAsText:=true;
    try    W.ActiveDocument.SaveAs(file_,FileFormat:= wdFormatText);
    except SaveDocAsText:=false; end;
end;


{******************************************************************************}
{************  Сохранить документ в файл file_ в DOSовском формате  ***********}
{******************************************************************************}
function SaveDocAsDosText(file_:string):boolean;
const wdFormatDOSText=4;
begin
    SaveDocAsDosText:=true;
    try    W.ActiveDocument.SaveAs(file_, FileFormat:= wdFormatDOSText);
    except SaveDocAsDosText:=false; end;
end;


{******************************************************************************}
{****************************  Закрыть документ  ******************************}
{******************************************************************************}
function CloseDoc:boolean;
begin
    CloseDoc := true;
    try    W.ActiveDocument.Close;
    except CloseDoc:=false; end;
end;


{******************************************************************************}
{*******************************  Закрыть Word  *******************************}
{******************************************************************************}
function CloseWord:boolean;
begin
    CloseWord:=true;
    try    W.Quit;
           W:=Unassigned;
    except CloseWord:=false; end;
End;


{******************************************************************************}
{************************  Открыть документ FileName  *************************}
{******************************************************************************}
function OpenDoc(const FileName: String): Boolean;
var Doc: Variant;
begin
    OpenDoc:=true;
    try    Doc := W.Documents;
           Doc.Open(FileName);
    except OpenDoc := false; end;
End;


{******************************************************************************}
{*******************  Переместить курсор в начало документа  ******************}
{******************************************************************************}
Function StartOfDoc: Boolean;
begin
    StartOfDoc:=true;
    try    SelectedDoc(0, 0);
    except StartOfDoc:=false; end;
End;


{******************************************************************************}
{********************  Переместить курсор в конец документа  ******************}
{******************************************************************************}
function EndOfDoc:boolean;
begin
    EndOfDoc:=true;
    try    W.Selection.EndKey(wdStory); // SelectedDoc(MAXLENWORDDOC, MAXLENWORDDOC);
    except EndOfDoc:=false; end;
End;


{******************************************************************************}
{***********************  Промотать документ вверх  ***************************}
{******************************************************************************}
function ScrollStartDoc: Boolean;
begin
    Result := true;
    try    W.Selection.Goto(0);      // параметр 0 - угадал
    except Result := false; end;
end;


{******************************************************************************}
{******************   Устанавливает курсор на закладку   **********************}
{******************************************************************************}
Function GotoBookmarkDoc(const Bookmark: string):Boolean;
begin
    GotoBookmarkDoc:=true;
    try    W.Selection.goto(What:=wdGoToBookmark, Which:=unAssigned,
                            Count:=unAssigned,    Name:=Bookmark);
    except GotoBookmarkDoc:=false; end;
end;


{******************************************************************************}
{*****  Устанавливает курсор на закладку и возвращает позицию закладки   ******}
{******************************************************************************}
function BookMarkPosDoc(const BmName: String): Integer;
begin
    try    GotoBookmarkDoc(BmName);
           Result := W.Selection.Start;
    except Result := -1; end;
end;


{******************************************************************************}
{**************  Устанавливает выделение между IStart и IEnd  *****************}
{******************************************************************************}
function SelectedDoc(const IStart, IEnd: Int64):Boolean;
begin
    Result := true;
    try    W.Selection.Start := Variant(IStart);
           W.Selection.End   := Variant(IEnd);
    except Result := false; end;
end;


{******************************************************************************}
{****************  Возвращает текст между IStart и IEnd  **********************}
{******************************************************************************}
function GetSelectedTextDoc(const IStart, IEnd: Int64): String;
begin
    Result := '';
    If not SelectedDoc(IStart, IEnd) then Exit;
    try Result := W.Selection.Text; except end;
end;


{******************************************************************************}
{***********************  Печать NumCopies копий документа  *******************}
{******************************************************************************}
function PrintOutDoc(NumCopies:integer):boolean;
begin
    Result := true;
    try    W.ActiveDocument.PrintOut(NumCopies);
    except Result := false; end;
end;


{******************************************************************************}
{****************  Поиск в документе строки text_ и её выделение  *************}
{******************************************************************************}
function FindTextDoc(text_: string): Boolean;
begin
    Result := true;
    try    W.Selection.Find.Forward:=true;
           W.Selection.Find.Text:=text_;
           Result := W.Selection.Find.Execute;
    except Result := false; end;
end;


{******************************************************************************}
{***************  Вставить текстовое содержимое буфера  ***********************}
{******************************************************************************}
function PasteClipbordDoc: Boolean;
begin
    Result := true;
    try
       If (String(Clipboard.AsText) <> String(CH_NEW)) and
          (String(Clipboard.AsText) <> '')
       then W.Selection.Paste
       else W.Selection.Delete;
    except Result := false;
    end;
end;


{******************************************************************************}
{*******************  Вставить любое содержимое буфера  ***********************}
{******************************************************************************}
function PasteClipbordDocAll:boolean;
begin
    PasteClipbordDocAll:=true;
    try    W.Selection.Delete;
           W.Selection.Paste;
    except PasteClipbordDocAll:=false; end;
end;


{******************************************************************************}
{***************************  Добавить текст в документ  **********************}
{******************************************************************************}
function AddTextDoc(text_: String; const font_: TFont; ColorIndex: Integer): Boolean;
begin
    AddTextDoc:=true;
    try    W.Selection.InsertAfter(text_);
           If font_<>nil then SetFontSelection(font_, ColorIndex);
    except AddTextDoc:=false; end;
end;


{******************************************************************************}
{************  Вставить текст в документ, удалив выделенный фрагмент  *********}
{******************************************************************************}
function PasteTextDoc(text_:string):boolean;
begin
    PasteTextDoc:=true;
    try    W.Selection.Delete;
           W.Selection.InsertAfter (text_);
    except PasteTextDoc:=false; end;
end;


{******************************************************************************}
{************  Вставить текст в документ, удалив выделенный фрагмент  *********}
{******************************************************************************}
function TypeTextDoc(text_:string):boolean;
begin
    TypeTextDoc:=true;
    try    W.Selection.Delete;
           W.Selection.TypeText(text_);
    except TypeTextDoc:=false; end;
end;


{******************************************************************************}
{*****************  Устанавливает размер выделенного текста  ******************}
{******************************************************************************}
function SetFontSizeSelection(Size:integer):boolean;
begin
    try    SetFontSizeSelection  := true;
           W.Selection.font.Size := Size;
    except SetFontSizeSelection  := false; end;
end;


{******************************************************************************}
{***********  Устанавливает шрифт имени Name на выделенный текст  *************}
{******************************************************************************}
function SetFontNameSelection(Name:string):boolean;
begin
    try    SetFontNameSelection  := true;
           W.Selection.font.Name := Name;
    except SetFontNameSelection  := false; end;
end;


{******************************************************************************}
{**********     Устанавливает тип и цвет выделенного шрифта       *************}
{******************************************************************************}
{**********        Если ColorIndex < 0 - цвет не меняется         *************}
{******************************************************************************}
function SetFontSelection(font: TFont; ColorIndex: Integer): Boolean;
    function FontToEFont(font: TFont; EFont: Variant; ColorIndex: Integer): Boolean;
    begin
        FontToEFont:=true;
        try
           EFont.Name:=font.Name;
           If fsBold      In font.Style then EFont.Bold         :=True else EFont.Bold         :=False;
           If fsItalic    In font.Style then EFont.Italic       :=True else EFont.Italic       :=False;
           If fsStrikeOut In font.Style then EFont.Strikethrough:=True else EFont.Strikethrough:=False;
           If fsUnderline In font.Style then EFont.Underline := wdUnderlineSingle // Подчеркивание
                                        else EFont.Underline := wdUnderlineNone;
           //EFont.Size:=font.Size;
           If ColorIndex>=0 then EFont.ColorIndex:=ColorIndex;
        except
           FontToEFont:=false;
        end;
    end;
begin
    SetFontSelection:=true;
    try    SetFontSelection:=FontToEFont(font, W.Selection.font, ColorIndex);
    except SetFontSelection:=false;
    end;
end;


{******************************************************************************}
{**********  Находит в тексте и заменяет findtext_ на pastetext_  *************}
{******************************************************************************}
function FindAndPasteTextDoc(findtext_,pastetext_:string):boolean;
begin
    FindAndPasteTextDoc:=true;
    try
       W.Selection.Find.Forward:=true;
       W.Selection.Find.Text:= findtext_;
       if W.Selection.Find.Execute then begin
          W.Selection.Delete;
          W.Selection.InsertAfter (pastetext_);
       end else FindAndPasteTextDoc:=false;
    except
       FindAndPasteTextDoc:=false;
    end;
end;


{******************************************************************************}
{********************  Показать диалоговое окно печати  ***********************}
{******************************************************************************}
function PrintDialogWord:boolean;
const wdDialogFilePrint=88;
begin
    PrintDialogWord:=true;
    try    W.Dialogs.Item(wdDialogFilePrint).Show;
    except PrintDialogWord:=false; end;
end;




{##############################################################################}
{######################    Т   А   Б   Л   И   Ц   Ы    #######################}
{##############################################################################}

{******************************************************************************}
{***************************  Создать таблицу  ********************************}
{******************************************************************************}
Function CreateTable(NumRows, NumColumns:integer;var index:integer):boolean;
 var sel_:variant;
begin
CreateTable:=true;
try
sel_:=W.selection;
W.ActiveDocument.Tables.Add(Range:=sel_.Range, NumRows:=NumRows, NumColumns:=NumColumns);
index:=W.ActiveDocument.Tables.Count;
except
CreateTable:=false;
end;
End;


{******************************************************************************}
{************************  Установить размер таблицы  *************************}
{******************************************************************************}
Function SetSizeTable(Table:integer;RowsHeight, ColumnsWidth:real):boolean;
begin
SetSizeTable:=true;
try
W.ActiveDocument.Tables.Item(Table).Columns.Width:=ColumnsWidth;
W.ActiveDocument.Tables.Item(Table).Rows.Height:=RowsHeight;
except
SetSizeTable:=false;
end;
End;


{******************************************************************************}
{****************  Получить размер строк и столбцов таблицы  ******************}
{******************************************************************************}
Function GetSizeTable(Table:integer;var RowsHeight,ColumnsWidth:real):boolean;
begin
GetSizeTable:=true;
try
ColumnsWidth:=W.ActiveDocument.Tables.Item(Table).Columns.Width;
RowsHeight:=W.ActiveDocument.Tables.Item(Table).Rows.Height;
except
GetSizeTable:=false;
end;
End;


{******************************************************************************}
{***********  Установить высоту RowHeight строки Row таблицы Table  ***********}
{******************************************************************************}
Function SetHeightRowTable(Table,Row:integer;RowHeight:real):boolean;
begin
SetHeightRowTable:=true;
try
W.ActiveDocument.Tables.Item(Table).Rows.item(Row).Height:=RowHeight;
except
SetHeightRowTable:=false;
end;
End;


{******************************************************************************}
{***********  Установить ширину ColumnWidth строки Row таблицы Table  *********}
{******************************************************************************}
Function SetWidthColumnTable(Table,Column:integer;ColumnWidth:real):boolean;
begin
SetWidthColumnTable:=true;
try
W.ActiveDocument.Tables.Item(Table).Columns.Item(Column).Width:=ColumnWidth;
except
SetWidthColumnTable:=false;
end;
End;


{******************************************************************************}
{**********  Записать текст text в ячейку Row,Column таблицы Table  ***********}
{******************************************************************************}
Function SetTextToTable(Table:integer;Row,Column:integer;text:string):boolean;
begin
SetTextToTable:=true;
try
W.ActiveDocument.Tables.Item(Table).Columns.Item(Column).Cells.Item(Row).Range.Text:=text;
except
SetTextToTable:=false;
end;
End;


{******************************************************************************}
{******  Установить тип и стиль границ ячейки Row,Column таблицы Table  *******}
{******************************************************************************}
Function SetLineStyleBorderTable(Table:integer;Row,Column,wdBorderType,wdBorderStyle:integer):boolean;
begin
SetLineStyleBorderTable:=true;
try
W.ActiveDocument.Tables.Item(Table).Columns.Item(Column).Cells.Item(Row).Borders.Item(wdBorderType).LineStyle:=wdBorderStyle;
except
SetLineStyleBorderTable:=false;
end;
End;


{******************************************************************************}
{*****  Добавить ячейки Row2,Column2 к таблице после ячеек Row1,Column1  ******}
{******************************************************************************}
Function SetMergeCellsTable(Table:integer;Row1,Column1,Row2,Column2:integer):boolean;
 var cel_:variant;
begin
SetMergeCellsTable:=true;
try
cel_:=W.ActiveDocument.Tables.Item(Table).Cell(Row2,Column2);
W.ActiveDocument.Tables.Item(Table).Cell(Row1,Column1).Merge(cel_);
except
SetMergeCellsTable:=false;
end;
End;


{******************************************************************************}
{**************************  Выделить таблицу  ********************************}
{******************************************************************************}
Function GetSelectionTable:boolean;
 const wdWithInTable=12;
begin
try
GetSelectionTable :=W.Selection.Information[wdWithInTable];
except
GetSelectionTable :=false;
end;
End;


{******************************************************************************}
{************************  Выделить следующую таблицу  ************************}
{******************************************************************************}
Function GoToNextTable (table_:integer):boolean;
 const wdGoToTable=2;
begin
GoToNextTable:=true;
try
W.Selection.GoToNext (wdGoToTable);
except
GoToNextTable:=false;
end;
End;


{******************************************************************************}
{***********************  Выделить предыдущую таблицу  ************************}
{******************************************************************************}
Function GoToPreviousTable (table_:integer):boolean;
 const wdGoToTable=2;
begin
GoToPreviousTable:=true;
try
W.Selection.GoToPrevious(wdGoToTable);
except
GoToPreviousTable:=false;
end;
End;


{******************************************************************************}
{************  Получить число строк и столбцов выделенной таблицы  ************}
{******************************************************************************}
Function GetColumnsRowsTable(table_:integer; var Columns,Rows:integer):boolean;
 const
    wdMaximumNumberOfColumns=18;
    wdMaximumNumberOfRows=15;
begin
GetColumnsRowsTable:=true;
try
Columns:=W.Selection.Information[wdMaximumNumberOfColumns];
Rows:=W.Selection.Information[wdMaximumNumberOfRows];
except
GetColumnsRowsTable:=false;
end;
End;


{******************************************************************************}
{************  Получить левую верхнюю ячейку выделенной области таблицы  ******}
{******************************************************************************}
Function GetColumnRowTable(table_:integer; var Column,Row:integer):boolean;
 const
   wdStartOfRangeColumnNumber=16;
   wdStartOfRangeRowNumber=13;
begin
GetColumnRowTable:=true;
try
Column:=W.Selection.Information[wdStartOfRangeColumnNumber];
Row:=W.Selection.Information[wdStartOfRangeRowNumber];
except
GetColumnRowTable:=false;
end;
End;


{******************************************************************************}
{*************************  Добавить в таблицу строку  ************************}
{******************************************************************************}
Function AddRowTableDoc (table_:integer):boolean;
begin
 AddRowTableDoc:=true;
 try
   W.ActiveDocument.Tables.Item(table_).Rows.Add;
 except
 AddRowTableDoc:=false;
 end;
End;


{******************************************************************************}
{**************  Добавить count_ строк после строки position_  ****************}
{******************************************************************************}
Function InsertRowsTableDoc(table_,position_,count_:integer):boolean;
begin
 InsertRowsTableDoc:=true;
 try
  W.ActiveDocument.Tables.Item(table_).Rows.Item(position_).Select;
  W.Selection.InsertRows (count_);
 except
 InsertRowsTableDoc:=false;
 end;
End;


{******************************************************************************}
{***************  Добавить в таблицу в позицию position_ строку  **************}
{******************************************************************************}
Function InsertRowTableDoc(table_,position_:integer):boolean;
 var row_:variant;
begin
 InsertRowTableDoc:=true;
 try
 row_:=W.ActiveDocument.Tables.Item(table_).Rows.Item(position_);
 W.ActiveDocument.Tables.Item(table_).Rows.Add(row_);
 except
 InsertRowTableDoc:=false;
 end;
End;


{******************************************************************************}
{*****************************  Выделить ячейку  ******************************}
{******************************************************************************}
Function SelectCell(Table:integer; Row,Column:integer):boolean;
begin
SelectCell:=true;
try
W.ActiveDocument.Tables.Item(Table).Columns.Item(Column).Cells.Item(Row).Select;
except
SelectCell:=false;
end;
End;





{##############################################################################}
{#####################    T   E   X   T        B   O   X    ###################}
{##############################################################################}

{******************************************************************************}
{*************************  Создать объект TextBox  ***************************}
{******************************************************************************}
Function CreateTextBox(Left,Top,Width,Height:real;var name:string):boolean;
 const msoTextOrientationHorizontal=1;
begin
CreateTextBox:=true;
try
name:=W.ActiveDocument.Shapes.AddTextbox(msoTextOrientationHorizontal,Left,Top,Width,Height).Name;
except
CreateTextBox:=false;
end;
End;


{******************************************************************************}
{*********************  Вставить текст text в объект TextBox  *****************}
{******************************************************************************}
Function TextToTextBox(TextBox:variant;text:string):boolean;
 const msoTextBox=17;
begin
TextToTextBox:=true;
try
if w.ActiveDocument.Shapes.Item(TextBox).Type = msoTextBox then
   W.ActiveDocument.Shapes.Item(TextBox).TextFrame.TextRange.Text:=Text
   else TextToTextBox:=false;
except
TextToTextBox:=false;
end;
End;





{##############################################################################}
{###############################    Л  И  Н  И  И    ##########################}
{##############################################################################}

{******************************************************************************}
{***************************  Создать линию  **********************************}
{******************************************************************************}
Function CreateLine(BeginX,BeginY,EndX,EndY:real;var name:string):boolean;
begin
CreateLine:=true;
try
name:=W.ActiveDocument.Shapes.AddLine(BeginX,BeginY,EndX,EndY).Name;
except
CreateLine:=false;
end;
End;





{##############################################################################}
{############   В  Н  Е  Ш  Н  И  Й      Р  И  С  У  Н  О  К    ###############}
{##############################################################################}

{******************************************************************************}
{*********************   Вставить рисунок в документ   ************************}
{******************************************************************************}
Function CreatePicture(FileName:string;Left,Top:real;var name:string):boolean;
//var K, DX, DY:real;
begin
CreatePicture:=true;
try
name:=W.ActiveDocument.Shapes.AddPicture(FileName).Name;
W.ActiveDocument.Shapes.Item(name).Left:=Left;
W.ActiveDocument.Shapes.Item(name).Top:=Top;
{DX:=W.ActiveDocument.Shapes.Item(name).Width;
DY:=W.ActiveDocument.Shapes.Item(name).Height;
K:=DX/DY;
If (DX0=0.0) and(DY0=0.0)  then begin DX:=DX0; DY:=DY0; end;
If (DX0<>0.0)and(DY0=0.0)  then DY:=DX/K;
If (DX0=0.0) and(DY0<>0.0) then DX:=DY*K;
W.ActiveDocument.Shapes.Item(name).Width:=DX;
W.ActiveDocument.Shapes.Item(name).Height:=DY;
}except
CreatePicture:=false;
end;
End;


{******************************************************************************}
{Вставляет в документ картинку fnamepic_ и устанавливает её размер dx_,dy_ м/б=0}
{******************************************************************************}
Function PastePicDoc(fnamepic_:string; dx_, dy_:integer):boolean;
var V: Variant;
begin
try
PastePicDoc:=true;            //LinkToFile:=False, SaveWithDocument:=True
V:=W.Selection.InlineShapes.AddPicture(fnamepic_,false,true);
if dx_<>0 then V.Width  := dx_;
if dy_<>0 then V.Height := dy_;
except
PastePicDoc:=false;
end;
End;



{******************************************************************************}
{******************************************************************************}
Function GetNameIndexShape(NameIndex:variant):string;
begin
try
GetNameIndexShape:=W.ActiveDocument.Shapes.Item(NameIndex).Name;
except
GetNameIndexShape:='';
end;
End;



{******************************************************************************}
{******************************************************************************}
Function SetNewNameShape(NameShape:variant;NewNameShape:string):string;
begin
try
W.ActiveDocument.Shapes.Item(NameShape).Name:=NewNameShape;
SetNewNameShape:=NewNameShape;
except
SetNewNameShape:='';
end;
End;


{******************************************************************************}
{******************************************************************************}
Function DeleteShape (NameShape:variant): variant;
Begin
DeleteShape:=true;
try
W.ActiveDocument.Shapes.Item(NameShape).Delete;
except
DeleteShape:=false;
end;
End;






{##############################################################################}
{#################    Н  О  В  Ы  Е     Ф  У  Н  К  Ц  И  И     ###############}
{##############################################################################}

{******************************************************************************}
{****************  Выделяет верхний колонтитул документа  *********************}
{******************************************************************************}
function SelectHeaderDoc: Boolean;
begin
    try    Result := true;
           W.ActiveWindow.ActivePane.View.SeekView := wdSeekCurrentPageHeader;
    except Result := false; end;
end;


{******************************************************************************}
{*****************  Выделяет нижний колонтитул документа  *********************}
{******************************************************************************}
function SelectFooterDoc: Boolean;
begin
    try    Result := true;
           W.ActiveWindow.ActivePane.View.SeekView := wdSeekCurrentPageFooter;
    except Result := false; end;
end;


{******************************************************************************}
{********************  Выделяет основную часть документа  *********************}
{******************************************************************************}
function SelectMainDoc: Boolean;
begin
    try    Result := true;
           W.ActiveWindow.ActivePane.View.SeekView := wdSeekMainDocument;
    except Result := false; end;
end;


{******************************************************************************}
{*******  Ищет в документе и возвращает строку-ключ в фигурных скобках  *******}
{******************************************************************************}
Function FindKeyTextDoc:String;
const BUF_SIZE = 1500;
var Interat: Integer;  {Число вложеных процессов}
    I      : Integer;
    S      : String;
    MyStart, MyEnd: Integer;
begin
    FindKeyTextDoc:='';
    try
       {Убираем предыдущее выделение}
       W.Selection.Start:=W.Selection.End;

       {Устанавливаем параметры поиска}
       W.Selection.Find.ClearFormatting;
       W.Selection.Find.Forward := true;
       W.Selection.Find.Text    := AnsiString(CH1);
       W.Selection.Find.Wrap    := wdFindContinue;
       W.Selection.Find.Format  := false;
       // W.Selection.Find.MatchCase := false;
       // W.Selection.Find.MatchWholeWord := false;
       // W.Selection.Find.MatchWildcards := false;
       // W.Selection.Find.MatchSoundsLike := false;
       // W.Selection.Find.MatchAllWordForms := false;

       {Ищем первый символ - если есть}
       if W.Selection.Find.Execute then begin
          {Определяем границы области: MyStart - MyEnd}
          MyStart := W.Selection.Start;
          W.Selection.End:=W.Selection.Start + BUF_SIZE;
          S := W.Selection.Text;
          I := InStrMy(1, S, CH1);                           If I = 0 then Exit;
          Delete(S, 1, I-1);
          Interat := 0;
          MyEnd   := 0;
          For I:=1 to Length(S) do begin
             If S[I] = CH1 then Inc(Interat);
             If S[I] = CH2 then Dec(Interat);
             If Interat=0 then break;
             Inc(MyEnd);
          end;
          If Interat<>0 then Exit;
          MyEnd:=MyStart+MyEnd+1;

          {Выделяем в WORD-е установленную область: MyStart - MyEnd}
          W.Selection.Start:=MyStart;
          if W.Selection.Find.Execute then begin
             W.Selection.End:=MyEnd;
             FindKeyTextDoc:=W.Selection.Text;
          end;
       end;
    except
    end;
end;



{******************************************************************************}
{*********************  Число символов С в документе  *************************}
{******************************************************************************}
Function GetCountWordChar(const Ch: Char): Integer;
begin
    Result:=GetColChar(GetSelectedTextDoc(0, MAXLENWORDDOC), Ch);
End;


{******************************************************************************}
{***********************  Выравнивание параграфа  *****************************}
{******************************************************************************}
Function AlignmentWText(const Align: Integer):boolean;
begin
    Result:=true;
    try
    W.Selection.ParagraphFormat.CharacterUnitFirstLineIndent:=2;
    W.Selection.ParagraphFormat.Alignment:=Align;
    except
       Result:=false;
    end;
end;


{******************************************************************************}
{***********************  Отступ красной строки   *****************************}
{******************************************************************************}
Function FirstStrDoc(const I: Integer):boolean;
begin
    Result:=true;
    try
    W.Selection.ParagraphFormat.CharacterUnitFirstLineIndent:=I;
    except
       Result:=false;
    end;
end;


end.
