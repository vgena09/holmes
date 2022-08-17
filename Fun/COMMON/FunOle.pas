unit FunOle;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.OleCtnrs,
   Data.DB, Data.Win.ADODB,
   FunType;

   {���������� ���� � OLE}
   procedure FieldToOle(const P: PADODataSet; const POle: POleContainer);
   {���������� OLE � ����}
   procedure OleToField(const POle: POleContainer; const P: PADODataSet);
   {�������� OLE}
   procedure ClearOle(const POle: POleContainer);
   {��������� � OLE ����� ��������� WORD-STREAM}
   procedure BlankWordToOle(const POle: POleContainer);
   {�������� WORD � OLE}
   function  WordToOle(const POle: POleContainer; const FileName: String): Boolean;
   {����� �� OLE}
   function  GetOleText(const POle: POleContainer): String;
   {���������� ����-OLEWORD � CLIPBOARD}
   function  FieldOleToClipboard(F: TForm; const P: PADODataSet): Boolean;
   {������� OLE}
   function  CreateOLE(F: TForm): TOleContainer;
   {���������� OLE}
   procedure CopyOLE(const POLE1, POLE2: POleContainer);


implementation

uses FunConst, FunBD, FunVcl, FunClip;

{==============================================================================}
{=======================  ���������� ���� � OLE  ==============================}
{==============================================================================}
procedure FieldToOle(const P: PADODataSet; const POle: POleContainer);
var Stream: TMemoryStream;
begin
    try
       ClearOle(POle);
       If P^.FieldByName(F_VAR_OLE_OLE).IsNull then Exit;

       Stream := TMemoryStream.Create;
       try     TBLOBField(P^.FieldByName(F_VAR_OLE_OLE)).SaveToStream(Stream);  // Field � �����
               Stream.Position := 0;
               POle^.LoadFromStream(Stream);                                    // ����� � OLE
       finally Stream.Free;
       end;
    finally
       POle.Enabled := POle^.State <> osEmpty;
    end;
end;


{==============================================================================}
{=======================  ���������� OLE � ����  ==============================}
{==============================================================================}
procedure OleToField(const POle: POleContainer; const P: PADODataSet);
var Stream: TMemoryStream;
begin
    Stream := TMemoryStream.Create;
    try If POle^.State <> osEmpty then POle^.SaveToStream(Stream);              // OLE � �����
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
{=============================  �������� OLE  =================================}
{==============================================================================}
procedure ClearOle(const POle: POleContainer);
begin
    With POle^ do begin 
       If State <> osEmpty then DestroyObject;
       Enabled := false;
    end;
end;


{==============================================================================}
{===================  ��������� � OLE ����� ��������� WORD  ===================}
{==============================================================================}
procedure BlankWordToOle(const POle: POleContainer);
begin
    WordToOle(POle, PATH_DATA+FILE_BLANK_WORD);
end;


{==============================================================================}
{========================  �������� WORD � OLE  ===============================}
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
{=============================  ����� �� OLE  =================================}
{==============================================================================}
function GetOleText(const POle: POleContainer): String;
var W : Variant;
    I : Integer;
    B : Boolean;
begin
    {�������������}
    Result:='';
    If POle^.State = osEmpty then Exit;

    POle^.DoVerb(ovPrimary);              // ��������� Word
    W := POle^.OleObject.Application;
    W.Selection.WholeStory;               // �������� ��
    W.Selection.End := W.Selection.End-1; // ��������� ������� ��������� �� 1 ������
    Result := W.Selection.Text;           // ������ �����
    W.Quit;                               // ��������� Word
    W:=Unassigned;

    {***  ��������������� ������   ********************************************}

    Result:=Result+Chr(0);
    {������� �����������}
    For I:=Length(Result)-1 downto 0 do begin
       If (Result[I]<=Chr(13)) and (Result[I]>Chr(0)) then Result[I]:=' ';
    end;
    {������� ������� ������}
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
    {������� ������� �� �����}
    Delete(Result, Length(Result), 1);
    Result:=Trim(Result);
end;


{==============================================================================}
{==================  ���������� ����-OLEWORD � CLIPBOARD  =====================}
{==============================================================================}
function FieldOleToClipboard(F: TForm; const P: PADODataSet): Boolean;
var OLE : TOleContainer;
    W   : Variant;
begin
    {�������������}
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
{==============================  ������� OLE  =================================}
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
       AllowInPlace   := true;           // ��������� � Ole
       Iconic         := false;
       AllowActiveDoc := false;          // ��� ��������� ���������� IOleDocumentSite
       AutoActivate   := aaManual;       // ��� �������������
       AutoVerbMenu   := false;          // ��� ���� OLE-�������
       CopyOnSave     := true;           // ������� ����� �����������
       SizeMode       := smScale;
    end;
end;


{==============================================================================}
{============================  ���������� OLE  ================================}
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

