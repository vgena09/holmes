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

{������ ����� �� ��������� WORD � Clipboard}
function WordToClip(const FPath: String): Boolean;                              StdCall
{������ ����� �� ��������� WORD}
function WordToTxt(const FPath: String): AnsiString;                            StdCall


{������� Ole-WORD}
function OpenOle(const POle: POleContainer; const IVerb: Integer): Boolean;     StdCall
{������� ������ WORD}
function CreateWord: Boolean;                                                   StdCall
{���������� ��������� WORD}
function VisibleWord(Visible: Boolean): Boolean;                                StdCall
{���������� ������� WORD}
function ZoomWord(const IZoom: Integer): Boolean;                               StdCall
{������� ����� ��������}
function AddDoc:boolean;                                                        StdCall
{���������� ��������� �� WORD}
function GetWordApplicationID: Variant;                                         StdCall
{���������� ��������� �� WORD}
procedure SetWordApplicationID(const ID: Variant);                              StdCall
{�������� ����� text_ � ��������}
function SetTextToDoc(text_: String; InsertAfter_: Boolean): Boolean;           StdCall
{��������� ��������}
function SaveDoc: Boolean;                                                      StdCall
{��������� �������� � ���� file_}
function SaveDocAs(file_: String): Boolean;                                     StdCall
{��������� �������� � ���� file_ � ������� Unicod}
function SaveDocAsUnicod(file_:string):boolean;                                 StdCall
{��������� �������� � ���� file_ � ��������� �������}
function SaveDocAsText(file_:string):boolean;                                   StdCall
{��������� �������� � ���� file_ � DOS������ �������}
function SaveDocAsDosText(file_:string):boolean;                                StdCall
{������� ��������}
function CloseDoc:boolean;                                                      StdCall
{������� Word}
function CloseWord:boolean;                                                     StdCall
{������� �������� FileName}
function OpenDoc(const FileName: String): Boolean;                              StdCall
{����������� ������ � ������ ���������}
function StartOfDoc:boolean;                                                    StdCall
{����������� ������ � ����� ���������}
function EndOfDoc:boolean;                                                      StdCall
{��������� �������� �����}
function ScrollStartDoc: Boolean;                                               StdCall
{������������� ������ �� ��������}
function GotoBookmarkDoc(const Bookmark: string):Boolean;                       StdCall
{������������� ������ �� �������� � ���������� ������� ��������}
function BookMarkPosDoc(const BmName: String): Integer;                         StdCall
{������������� ��������� ����� IStart � IEnd}
function SelectedDoc(const IStart, IEnd: Int64):Boolean;                        StdCall
{���������� ����� ����� IStart � IEnd}
function GetSelectedTextDoc(const IStart, IEnd: Int64): String;                 StdCall
{������ NumCopies ����� ���������}
function PrintOutDoc(NumCopies:integer):boolean;                                StdCall
{����� � ��������� ������ text_ � � ���������}
function FindTextDoc(text_: string): Boolean;                                   StdCall
{�������� ��������� ���������� ������}
function PasteClipbordDoc:boolean;                                              StdCall
{�������� ����� ���������� ������}
function PasteClipbordDocAll:boolean;                                           StdCall
{�������� ����� � ��������}
function AddTextDoc(text_: String; const font_: TFont; ColorIndex: Integer): Boolean; StdCall
{�������� ����� � ��������, ������ ���������� ��������}
function PasteTextDoc(text_:string):boolean;                                    StdCall
{�������� ����� � ��������, ������ ���������� ��������}
function TypeTextDoc(text_:string):boolean;                                     StdCall
{������������� ������ ����������� ������}
function SetFontSizeSelection(Size:integer):boolean;                            StdCall
{������������� ����� ����� Name �� ���������� �����}
function SetFontNameSelection(Name:string):boolean;                             StdCall
{������������� ��� � ���� ����������� ������}
function SetFontSelection(font: TFont; ColorIndex: Integer): Boolean;           StdCall
{������� � ������ � �������� findtext_ �� pastetext_}
function FindAndPasteTextDoc(findtext_,pastetext_:string):boolean;              StdCall
{�������� ���������� ���� ������}
function PrintDialogWord:boolean;                                               StdCall


{*****************************  � � � � � � �  ********************************}
{������� �������}
function CreateTable(NumRows, NumColumns:integer;var index:integer):boolean;    StdCall
{���������� ������ ����� � �������� �������}
function SetSizeTable(Table:integer;RowsHeight, ColumnsWidth:real):boolean;     StdCall
{�������� ������ ����� � �������� �������}
function GetSizeTable(Table:integer;var RowsHeight,ColumnsWidth:real):boolean;  StdCall
{���������� ������ RowHeight ������ Row ������� Table}
function SetHeightRowTable(Table,Row:integer;RowHeight:real):boolean;           StdCall
{���������� ������ ColumnWidth ������ Row ������� Table}
function SetWidthColumnTable(Table,Column:integer;ColumnWidth:real):boolean;    StdCall
{�������� ����� text � ������ Row,Column ������� Table}
function SetTextToTable(Table:integer;Row,Column:integer;text:string):boolean;  StdCall
{���������� ��� � ����� ������ ������ Row,Column ������� Table}
function SetLineStyleBorderTable(Table:integer;Row,Column,wdBorderType,wdBorderStyle:integer):boolean;   StdCall
{�������� ������ Row2,Column2 � ������� ����� ����� Row1,Column1}
function SetMergeCellsTable(Table:integer;Row1,Column1,Row2,Column2:integer):boolean;                    StdCall
{�������� �������}
function GetSelectionTable:boolean;                                             StdCall
{�������� ��������� �������}
function GoToNextTable (table_:integer):boolean;                                StdCall
{�������� ���������� �������}
function GoToPreviousTable (table_:integer):boolean;                            StdCall
{�������� ����� ����� � �������� ���������� �������}
function GetColumnsRowsTable(table_:integer; var Columns,Rows:integer):boolean; StdCall
{�������� ����� ������� ������ ���������� ������� �������}
function GetColumnRowTable(table_:integer; var Column,Row:integer):boolean;     StdCall
{�������� � ������� ������}
function AddRowTableDoc (table_:integer):boolean;                               StdCall
{�������� count_ ����� ����� ������ position_}
function InsertRowsTableDoc(table_,position_,count_:integer):boolean;           StdCall
{�������� � ������� � ������� position_ ������}
function InsertRowTableDoc(table_,position_:integer):boolean;                   StdCall
{�������� ������}
function SelectCell(Table:integer; Row,Column:integer):boolean;                 StdCall


{*******************************  TextBox  ************************************}
{������� ������ TextBox}
function CreateTextBox(Left,Top,Width,Height:real;var name:string):boolean;     StdCall
{�������� ����� text � ������ TextBox}
function TextToTextBox(TextBox:variant;text:string):boolean;                    StdCall

{*****************************      �����   ***********************************}
{������� �����}
function CreateLine(BeginX,BeginY,EndX,EndY:real;var name:string):boolean;      StdCall

{***************************   ������� �������   ******************************}
{�������� ������� � ��������}
function CreatePicture(FileName:string;Left,Top:real;var name:string):boolean;  StdCall
{��������� � �������� �������� fnamepic_ � ������������� � ������ dx_,dy_ �/�=0}
function PastePicDoc(fnamepic_:string; dx_, dy_:integer):boolean;               StdCall

{*************************  ����� ��� ����� �������  **************************}
function DeleteShape (NameShape:variant): variant;                              StdCall
function SetNewNameShape(NameShape:variant;NewNameShape:string):string;         StdCall
function GetNameIndexShape(NameIndex:variant):string;                           StdCall

{*****************************  ����� �������  ********************************}
{�������� ������� ���������� ���������}
function SelectHeaderDoc: Boolean;                                              StdCall
{�������� ������ ���������� ���������}
function SelectFooterDoc: Boolean;                                              StdCall
{�������� �������� ����� ���������}
function SelectMainDoc: Boolean;                                                StdCall
{����� �������� �h � ���������}
function GetCountWordChar(const Ch: Char): Integer;                             StdCall
{���� � ��������� � ���������� ������-���� � �������� �������}
function FindKeyTextDoc:string;                                                 StdCall

{****************************  ��������������  ********************************}
{������������ ���������}
function AlignmentWText(const Align: Integer):boolean;                          StdCall
{������ ������� ������}
function FirstStrDoc(const I: Integer):boolean;                                 StdCall


var W: Variant;

implementation

uses ComObj, OleServer, Word2000,
     FunConst, FunText;


{******************************************************************************}
{**************  ������ ����� �� ��������� WORD � Clipboard  ******************}
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
{********************  ������ ����� �� ��������� WORD  ************************}
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
{***************************  ������� Ole-WORD  *******************************}
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
{**************************  ������� ������ WORD  *****************************}
{******************************************************************************}
function CreateWord: Boolean;
begin
    Result := true;
    try    W := CreateOleObject('Word.Application');
    except Result := false;
    end;
end;


{******************************************************************************}
{***********************  ���������� ��������� WORD  **************************}
{******************************************************************************}
function VisibleWord(Visible: Boolean): Boolean;
begin
    Result := true;
    try    W.visible := Visible;
    except Result := false;
    end;
end;


{******************************************************************************}
{************************  ���������� ������� WORD  ***************************}
{******************************************************************************}
function ZoomWord(const IZoom: Integer): Boolean;
begin
    Result := true;
    try    W.ActiveWindow.ActivePane.View.Zoom.Percentage := IZoom;
    except Result := false;
    end;
end;


{******************************************************************************}
{**************************  ������� ����� ��������  **************************}
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
{********************  ���������� ��������� �� WORD  **************************}
{******************************************************************************}
function GetWordApplicationID: Variant;
begin
    try    Result := W;
    except Result := 0; end;
end;


{******************************************************************************}
{********************  ���������� ��������� �� WORD  **************************}
{******************************************************************************}
procedure SetWordApplicationID(const ID: Variant);
begin
    W := ID;
end;

{******************************************************************************}
{*********************  �������� ����� text_ � ��������  **********************}
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
{***************************  ��������� ��������  *****************************}
{******************************************************************************}
function SaveDoc: Boolean;
begin
    SaveDoc:=true;
    try    W.ActiveDocument.Save;
    except SaveDoc:=false; end;
end;


{******************************************************************************}
{************************  ��������� �������� � ���� file_  *******************}
{******************************************************************************}
function SaveDocAs(file_: String): Boolean;
begin
    SaveDocAs:=true;
    try    ForceDirectories(ExtractFilePath(file_));
           W.ActiveDocument.SaveAs(file_);
    except SaveDocAs:=false; end;
end;


{******************************************************************************}
{************** ��������� �������� � ���� file_ � ������� Unicod  *************}
{******************************************************************************}
function SaveDocAsUnicod(file_:string):boolean;
const wdFormatUnicodeText=7;
begin
    SaveDocAsUnicod:=true;
    try    W.ActiveDocument.SaveAs(file_, FileFormat:=wdFormatUnicodeText);
    except SaveDocAsUnicod:=false; end;
end;


{******************************************************************************}
{*************  ��������� �������� � ���� file_ � ��������� �������  **********}
{******************************************************************************}
function SaveDocAsText(file_:string):boolean;
const wdFormatText=2;
begin
    SaveDocAsText:=true;
    try    W.ActiveDocument.SaveAs(file_,FileFormat:= wdFormatText);
    except SaveDocAsText:=false; end;
end;


{******************************************************************************}
{************  ��������� �������� � ���� file_ � DOS������ �������  ***********}
{******************************************************************************}
function SaveDocAsDosText(file_:string):boolean;
const wdFormatDOSText=4;
begin
    SaveDocAsDosText:=true;
    try    W.ActiveDocument.SaveAs(file_, FileFormat:= wdFormatDOSText);
    except SaveDocAsDosText:=false; end;
end;


{******************************************************************************}
{****************************  ������� ��������  ******************************}
{******************************************************************************}
function CloseDoc:boolean;
begin
    CloseDoc := true;
    try    W.ActiveDocument.Close;
    except CloseDoc:=false; end;
end;


{******************************************************************************}
{*******************************  ������� Word  *******************************}
{******************************************************************************}
function CloseWord:boolean;
begin
    CloseWord:=true;
    try    W.Quit;
           W:=Unassigned;
    except CloseWord:=false; end;
End;


{******************************************************************************}
{************************  ������� �������� FileName  *************************}
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
{*******************  ����������� ������ � ������ ���������  ******************}
{******************************************************************************}
Function StartOfDoc: Boolean;
begin
    StartOfDoc:=true;
    try    SelectedDoc(0, 0);
    except StartOfDoc:=false; end;
End;


{******************************************************************************}
{********************  ����������� ������ � ����� ���������  ******************}
{******************************************************************************}
function EndOfDoc:boolean;
begin
    EndOfDoc:=true;
    try    W.Selection.EndKey(wdStory); // SelectedDoc(MAXLENWORDDOC, MAXLENWORDDOC);
    except EndOfDoc:=false; end;
End;


{******************************************************************************}
{***********************  ��������� �������� �����  ***************************}
{******************************************************************************}
function ScrollStartDoc: Boolean;
begin
    Result := true;
    try    W.Selection.Goto(0);      // �������� 0 - ������
    except Result := false; end;
end;


{******************************************************************************}
{******************   ������������� ������ �� ��������   **********************}
{******************************************************************************}
Function GotoBookmarkDoc(const Bookmark: string):Boolean;
begin
    GotoBookmarkDoc:=true;
    try    W.Selection.goto(What:=wdGoToBookmark, Which:=unAssigned,
                            Count:=unAssigned,    Name:=Bookmark);
    except GotoBookmarkDoc:=false; end;
end;


{******************************************************************************}
{*****  ������������� ������ �� �������� � ���������� ������� ��������   ******}
{******************************************************************************}
function BookMarkPosDoc(const BmName: String): Integer;
begin
    try    GotoBookmarkDoc(BmName);
           Result := W.Selection.Start;
    except Result := -1; end;
end;


{******************************************************************************}
{**************  ������������� ��������� ����� IStart � IEnd  *****************}
{******************************************************************************}
function SelectedDoc(const IStart, IEnd: Int64):Boolean;
begin
    Result := true;
    try    W.Selection.Start := Variant(IStart);
           W.Selection.End   := Variant(IEnd);
    except Result := false; end;
end;


{******************************************************************************}
{****************  ���������� ����� ����� IStart � IEnd  **********************}
{******************************************************************************}
function GetSelectedTextDoc(const IStart, IEnd: Int64): String;
begin
    Result := '';
    If not SelectedDoc(IStart, IEnd) then Exit;
    try Result := W.Selection.Text; except end;
end;


{******************************************************************************}
{***********************  ������ NumCopies ����� ���������  *******************}
{******************************************************************************}
function PrintOutDoc(NumCopies:integer):boolean;
begin
    Result := true;
    try    W.ActiveDocument.PrintOut(NumCopies);
    except Result := false; end;
end;


{******************************************************************************}
{****************  ����� � ��������� ������ text_ � � ���������  *************}
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
{***************  �������� ��������� ���������� ������  ***********************}
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
{*******************  �������� ����� ���������� ������  ***********************}
{******************************************************************************}
function PasteClipbordDocAll:boolean;
begin
    PasteClipbordDocAll:=true;
    try    W.Selection.Delete;
           W.Selection.Paste;
    except PasteClipbordDocAll:=false; end;
end;


{******************************************************************************}
{***************************  �������� ����� � ��������  **********************}
{******************************************************************************}
function AddTextDoc(text_: String; const font_: TFont; ColorIndex: Integer): Boolean;
begin
    AddTextDoc:=true;
    try    W.Selection.InsertAfter(text_);
           If font_<>nil then SetFontSelection(font_, ColorIndex);
    except AddTextDoc:=false; end;
end;


{******************************************************************************}
{************  �������� ����� � ��������, ������ ���������� ��������  *********}
{******************************************************************************}
function PasteTextDoc(text_:string):boolean;
begin
    PasteTextDoc:=true;
    try    W.Selection.Delete;
           W.Selection.InsertAfter (text_);
    except PasteTextDoc:=false; end;
end;


{******************************************************************************}
{************  �������� ����� � ��������, ������ ���������� ��������  *********}
{******************************************************************************}
function TypeTextDoc(text_:string):boolean;
begin
    TypeTextDoc:=true;
    try    W.Selection.Delete;
           W.Selection.TypeText(text_);
    except TypeTextDoc:=false; end;
end;


{******************************************************************************}
{*****************  ������������� ������ ����������� ������  ******************}
{******************************************************************************}
function SetFontSizeSelection(Size:integer):boolean;
begin
    try    SetFontSizeSelection  := true;
           W.Selection.font.Size := Size;
    except SetFontSizeSelection  := false; end;
end;


{******************************************************************************}
{***********  ������������� ����� ����� Name �� ���������� �����  *************}
{******************************************************************************}
function SetFontNameSelection(Name:string):boolean;
begin
    try    SetFontNameSelection  := true;
           W.Selection.font.Name := Name;
    except SetFontNameSelection  := false; end;
end;


{******************************************************************************}
{**********     ������������� ��� � ���� ����������� ������       *************}
{******************************************************************************}
{**********        ���� ColorIndex < 0 - ���� �� ��������         *************}
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
           If fsUnderline In font.Style then EFont.Underline := wdUnderlineSingle // �������������
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
{**********  ������� � ������ � �������� findtext_ �� pastetext_  *************}
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
{********************  �������� ���������� ���� ������  ***********************}
{******************************************************************************}
function PrintDialogWord:boolean;
const wdDialogFilePrint=88;
begin
    PrintDialogWord:=true;
    try    W.Dialogs.Item(wdDialogFilePrint).Show;
    except PrintDialogWord:=false; end;
end;




{##############################################################################}
{######################    �   �   �   �   �   �   �    #######################}
{##############################################################################}

{******************************************************************************}
{***************************  ������� �������  ********************************}
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
{************************  ���������� ������ �������  *************************}
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
{****************  �������� ������ ����� � �������� �������  ******************}
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
{***********  ���������� ������ RowHeight ������ Row ������� Table  ***********}
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
{***********  ���������� ������ ColumnWidth ������ Row ������� Table  *********}
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
{**********  �������� ����� text � ������ Row,Column ������� Table  ***********}
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
{******  ���������� ��� � ����� ������ ������ Row,Column ������� Table  *******}
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
{*****  �������� ������ Row2,Column2 � ������� ����� ����� Row1,Column1  ******}
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
{**************************  �������� �������  ********************************}
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
{************************  �������� ��������� �������  ************************}
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
{***********************  �������� ���������� �������  ************************}
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
{************  �������� ����� ����� � �������� ���������� �������  ************}
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
{************  �������� ����� ������� ������ ���������� ������� �������  ******}
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
{*************************  �������� � ������� ������  ************************}
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
{**************  �������� count_ ����� ����� ������ position_  ****************}
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
{***************  �������� � ������� � ������� position_ ������  **************}
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
{*****************************  �������� ������  ******************************}
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
{*************************  ������� ������ TextBox  ***************************}
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
{*********************  �������� ����� text � ������ TextBox  *****************}
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
{###############################    �  �  �  �  �    ##########################}
{##############################################################################}

{******************************************************************************}
{***************************  ������� �����  **********************************}
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
{############   �  �  �  �  �  �  �      �  �  �  �  �  �  �    ###############}
{##############################################################################}

{******************************************************************************}
{*********************   �������� ������� � ��������   ************************}
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
{��������� � �������� �������� fnamepic_ � ������������� � ������ dx_,dy_ �/�=0}
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
{#################    �  �  �  �  �     �  �  �  �  �  �  �     ###############}
{##############################################################################}

{******************************************************************************}
{****************  �������� ������� ���������� ���������  *********************}
{******************************************************************************}
function SelectHeaderDoc: Boolean;
begin
    try    Result := true;
           W.ActiveWindow.ActivePane.View.SeekView := wdSeekCurrentPageHeader;
    except Result := false; end;
end;


{******************************************************************************}
{*****************  �������� ������ ���������� ���������  *********************}
{******************************************************************************}
function SelectFooterDoc: Boolean;
begin
    try    Result := true;
           W.ActiveWindow.ActivePane.View.SeekView := wdSeekCurrentPageFooter;
    except Result := false; end;
end;


{******************************************************************************}
{********************  �������� �������� ����� ���������  *********************}
{******************************************************************************}
function SelectMainDoc: Boolean;
begin
    try    Result := true;
           W.ActiveWindow.ActivePane.View.SeekView := wdSeekMainDocument;
    except Result := false; end;
end;


{******************************************************************************}
{*******  ���� � ��������� � ���������� ������-���� � �������� �������  *******}
{******************************************************************************}
Function FindKeyTextDoc:String;
const BUF_SIZE = 1500;
var Interat: Integer;  {����� �������� ���������}
    I      : Integer;
    S      : String;
    MyStart, MyEnd: Integer;
begin
    FindKeyTextDoc:='';
    try
       {������� ���������� ���������}
       W.Selection.Start:=W.Selection.End;

       {������������� ��������� ������}
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

       {���� ������ ������ - ���� ����}
       if W.Selection.Find.Execute then begin
          {���������� ������� �������: MyStart - MyEnd}
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

          {�������� � WORD-� ������������� �������: MyStart - MyEnd}
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
{*********************  ����� �������� � � ���������  *************************}
{******************************************************************************}
Function GetCountWordChar(const Ch: Char): Integer;
begin
    Result:=GetColChar(GetSelectedTextDoc(0, MAXLENWORDDOC), Ch);
End;


{******************************************************************************}
{***********************  ������������ ���������  *****************************}
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
{***********************  ������ ������� ������   *****************************}
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
