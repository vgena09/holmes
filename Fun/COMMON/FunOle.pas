unit FunOle;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.OleCtnrs,
   Data.DB, Data.Win.ADODB,
   FunType;

   {КОПИРОВАТЬ ПОЛЕ В OLE}
   procedure FieldToOle(const P: PADODataSet; const POle: POleContainer);
   {КОПИРОВАТЬ OLE В ПОЛЕ}
   procedure OleToField(const POle: POleContainer; const P: PADODataSet);
   {ОЧИСТИТЬ OLE}
   procedure ClearOle(const POle: POleContainer);
   {ЗАГРУЗИТЬ В OLE БЛАНК ДОКУМЕНТА WORD-STREAM}
   procedure BlankWordToOle(const POle: POleContainer);
   {ДОКУМЕНТ WORD В OLE}
   function  WordToOle(const POle: POleContainer; const FileName: String): Boolean;
   {ТЕКСТ ИЗ OLE}
   function  GetOleText(const POle: POleContainer): String;
   {КОПИРОВАТЬ ПОЛЕ-OLEWORD В CLIPBOARD}
   function  FieldOleToClipboard(F: TForm; const P: PADODataSet): Boolean;
   {СОЗДАТЬ OLE}
   function  CreateOLE(F: TForm): TOleContainer;
   {КОПИРОВАТЬ OLE}
   procedure CopyOLE(const POLE1, POLE2: POleContainer);


implementation

uses FunConst, FunBD, FunVcl, FunClip;

{==============================================================================}
{=======================  КОПИРОВАТЬ ПОЛЕ В OLE  ==============================}
{==============================================================================}
procedure FieldToOle(const P: PADODataSet; const POle: POleContainer);
var Stream: TMemoryStream;
begin
    try
       ClearOle(POle);
       If P^.FieldByName(F_VAR_OLE_OLE).IsNull then Exit;

       Stream := TMemoryStream.Create;
       try     TBLOBField(P^.FieldByName(F_VAR_OLE_OLE)).SaveToStream(Stream);  // Field в поток
               Stream.Position := 0;
               POle^.LoadFromStream(Stream);                                    // поток в OLE
       finally Stream.Free;
       end;
    finally
       POle.Enabled := POle^.State <> osEmpty;
    end;
end;


{==============================================================================}
{=======================  КОПИРОВАТЬ OLE В ПОЛЕ  ==============================}
{==============================================================================}
procedure OleToField(const POle: POleContainer; const P: PADODataSet);
var Stream: TMemoryStream;
begin
    Stream := TMemoryStream.Create;
    try If POle^.State <> osEmpty then POle^.SaveToStream(Stream);              // OLE в поток
        Stream.Position := 0;        
        With P^ do begin
           DisableControls;
           Edit;
           If POle^.State = osEmpty then TBLOBField(FieldByName(F_VAR_OLE_OLE)).Clear
                                    else TBLOBField(FieldByName(F_VAR_OLE_OLE)).LoadFromStream(Stream);
           UpdateRecord;
           Post;
           EnableControls;
        end;
    finally Stream.Free;
    end;
end;


{==============================================================================}
{=============================  ОЧИСТИТЬ OLE  =================================}
{==============================================================================}
procedure ClearOle(const POle: POleContainer);
begin
    With POle^ do begin 
       If State <> osEmpty then DestroyObject;
       Enabled := false;
    end;
end;


{==============================================================================}
{===================  ЗАГРУЗИТЬ В OLE БЛАНК ДОКУМЕНТА WORD  ===================}
{==============================================================================}
procedure BlankWordToOle(const POle: POleContainer);
begin
    WordToOle(POle, PATH_DATA+FILE_BLANK_WORD);
end;


{==============================================================================}
{========================  ДОКУМЕНТ WORD В OLE  ===============================}
{==============================================================================}
function WordToOle(const POle: POleContainer; const FileName: String): Boolean;
begin
    Result := false;
    try     POle^.CreateObjectFromFile(FileName, false);
            Result := true;
    finally POle.Enabled := POle^.State <> osEmpty;
    end;
end;


{==============================================================================}
{=============================  ТЕКСТ ИЗ OLE  =================================}
{==============================================================================}
function GetOleText(const POle: POleContainer): String;
var W : Variant;
    I : Integer;
    B : Boolean;
begin
    {Инициализация}
    Result:='';
    If POle^.State = osEmpty then Exit;

    POle^.DoVerb(ovPrimary);              // Открываем Word
    W := POle^.OleObject.Application;
    W.Selection.WholeStory;               // Выделяем всё
    W.Selection.End := W.Selection.End-1; // Уменьшаем область выделения на 1 символ
    Result := W.Selection.Text;           // Читаем текст
    W.Quit;                               // Закрываем Word
    W:=Unassigned;

    {***  Преобразовываем строку   ********************************************}

    Result:=Result+Chr(0);
    {Убираем спецсимволы}
    For I:=Length(Result)-1 downto 0 do begin
       If (Result[I]<=Chr(13)) and (Result[I]>Chr(0)) then Result[I]:=' ';
    end;
    {Убираем пробелы подряд}
    B:=true;
    While B do begin
       B:=false;
       For I:=Length(Result)-2 downto 0 do begin
          If Result[I]+Result[I+1]='  ' then begin
             Delete(Result, I, 1);
             B:=true;
             Break;
          end;
       end;
    end;
    {Убираем пробелы по бокам}
    Delete(Result, Length(Result), 1);
    Result:=Trim(Result);
end;


{==============================================================================}
{==================  КОПИРОВАТЬ ПОЛЕ-OLEWORD В CLIPBOARD  =====================}
{==============================================================================}
function FieldOleToClipboard(F: TForm; const P: PADODataSet): Boolean;
var OLE : TOleContainer;
    W   : Variant;
begin
    {Инициализация}
    Result := false;
    ClearClipboard;
    If P^.FieldByName(F_VAR_OLE_OLE).IsNull then Exit;

    try
       BeginScreenUpdate(F.Handle);
       OLE := CreateOLE(F);
       FieldToOle(P, @OLE);
       OLE.DoVerb(ovShow);
       W := OLE.OleObject.Application;
       W.Selection.WholeStory;
       W.Selection.End:=W.Selection.End-1;
       If Long(W.Selection.Start) >= Long(W.Selection.End) then Exit;
       W.Selection.Copy;
       W      := Unassigned;
       Result := true;
    finally
       If OLE.State <> osEmpty then begin
          OLE.Close;
          OLE.DestroyObject;
       end;
       OLE.Free;
       EndScreenUpdate(F.Handle);
    end;
end;


{==============================================================================}
{==============================  СОЗДАТЬ OLE  =================================}
{==============================================================================}
function CreateOLE(F: TForm): TOleContainer;
begin
    Result := TOleContainer.Create(TComponent(F));
    With Result do begin
       Parent         := F;
       // Align          := alNone;
       // Width          := 600;
       // Height         := 1000;
       Left           := 1000000;
       AllowInPlace   := true;           // открывать в Ole
       Iconic         := false;
       AllowActiveDoc := false;          // без поддержки интерфейса IOleDocumentSite
       AutoActivate   := aaManual;       // без автоактивации
       AutoVerbMenu   := false;          // без меню OLE-сервера
       CopyOnSave     := true;           // сжимать перед сохранением
       SizeMode       := smScale;
    end;
end;


{==============================================================================}
{============================  КОПИРОВАТЬ OLE  ================================}
{==============================================================================}
procedure CopyOLE(const POLE1, POLE2: POleContainer);
var Stream: TMemoryStream;
begin
    Stream:=TMemoryStream.Create;
    try     POle1^.SaveToStream(Stream);
            Stream.Position := 0;
            POle2^.LoadFromStream(Stream);
    finally Stream.Free;
    end;
end;

end.

