unit FunClip;

{******************************************************************************}
{************************ ����������� ������ CLIPBOARD ************************}
{******************************************************************************}

interface
uses
   Winapi.Windows, System.SysUtils, System.Classes, Vcl.Clipbrd;

    {�������� ������ S � ����� ������}
    procedure PutStringInClipboard(const S: String);
    {��������� ������ S �� ������ ������}
    function  GetStringFromClipboard: String;
    {������� ������ ������}
    procedure ClearClipboard;
    {���������� ������ ������ �� ��������� ����}
    function  SaveClipboard: Boolean;
    {�������������� ������ ������ �� ���������� �����}
    function  LoadClipboard: Boolean;

implementation

uses FunConst;


{==============================================================================}
{===================  �������� ������ S � ����� ������  =======================}
{==============================================================================}
procedure PutStringInClipboard(const S: String);
begin
    Clipboard.Open;
    Clipboard.AsText := S;
    Clipboard.Close;
end;


{==============================================================================}
{==================  ��������� ������ S �� ������ ������  =====================}
{==============================================================================}
function GetStringFromClipboard: String;
begin
    Result:='';
    if not IsClipboardFormatAvailable(CF_Text) then begin      //CF_UNICODETEXT - ����� ��������� ���������
       Result:=Clipboard.AsText;
    end;
end;



{==============================================================================}
{========================  ������� ������ ������  =============================}
{==============================================================================}
procedure ClearClipboard;
begin
    Clipboard.Open;
    Clipboard.Clear;
    Clipboard.Close;
//    OpenClipboard(0);  ������� �� ����
//    EmptyClipboard;
//    CloseClipboard;
end;


{==============================================================================}
{====================  ���������� ������ ������ � ���� ========================}
{==============================================================================}
function SaveClipboard: Boolean;
var CBF     : Cardinal;
    CBFList : TList;
    FName   : String;
    I       : Integer;
    h       : THandle;
    p       : Pointer;
    CBBlockLength, Temp: Cardinal;
    FStream : TFileStream;
begin
    {�������������}
    Result := false;

    {����}
    FName  := PATH_WORK_TEMP + FILE_CLIPBOARD;
    If FileExists(FName) then If not DeleteFile(FName) then Exit;
    If not ForceDirectories(ExtractFilePath(FName))    then Exit;

    If not OpenClipboard(0) then Exit;
    try try
       {������� ����-�����}
       FStream:=TFileStream.Create(FName, fmCreate, fmShareExclusive);

       {��������� ������ ������}
       CBFList:=TList.Create;
       CBF:=0;
       repeat CBF:=EnumClipboardFormats(CBF);
              If CBF<>0 then CBFList.Add(pointer(CBF));
       until  CBF=0;

       {���� ������� ���� ���� ����}
       If CBFList.Count>0 then begin

          {���������� ����� ������}
          Temp := CBFList.Count;
          FStream.Write(Temp, SizeOf(Integer));

          {���������� ���� �����}
          for I := 0 to CBFList.Count - 1 do begin
             {���������� Handle �����}
             h := GetClipboardData(Cardinal(CBFList[I]));
             if h > 0 then begin
                CBBlockLength := GlobalSize(h);
                if h > 0 then begin
                   p:=GlobalLock(h);
                   if p<>nil then begin
                      Temp := Cardinal(CBFList[I]);
                      FStream.Write(Temp, SizeOf(Cardinal));
                      FStream.Write(CBBlockLength, SizeOf(Cardinal));
                      FStream.Write(p^, CBBlockLength);
                   end;
                   GlobalUnlock(h);
                end;
             end;
          end;
       end;
       Result:=true;
    except end;
    finally
       {���������� ������}
       If FStream <> nil then FStream.Free;
       If CBFList <> nil then CBFList.Free;
       CloseClipBoard;
    end;
end;


{==============================================================================}
{===============  �������������� ������ ������ �� �����  ======================}
{==============================================================================}
function LoadClipboard: Boolean;
var h             : THandle;
    p             : Pointer;
    CBF           : Cardinal;
    CBBlockLength : Cardinal;
    FName         : String;
    I, CBCount    : Integer;
    FStream       : TFileStream;
begin
    {�������������}
    Result := false;
    ClearClipboard;
    FName  := PATH_WORK_TEMP + FILE_CLIPBOARD;
    If not FileExists(FName) then Exit;
    If not OpenClipboard(0)  then Exit;
    try
       {��������� ����}
       FStream:=TFileStream.Create(FName, fmOpenRead);
       If FStream.Size=0 then Exit;

       {������ ����� ������}
       FStream.Read(CBCount, sizeOf(Integer));
       If CBCount=0 then Exit;

       {����� �� ������� �����}
       For I := 1 to CBCount do begin
          FStream.Read(CBF, SizeOf(Cardinal));
          FStream.Read(CBBlockLength, SizeOf(Cardinal));
          {������ Handle �����}
          h:=GlobalAlloc(GMEM_MOVEABLE or GMEM_SHARE or GMEM_ZEROINIT, CBBlockLength);
          If h > 0 then begin
             p:=GlobalLock(h);
             If p=nil then GlobalFree(h)
                      else begin
                         FStream.Read(p^, CBBlockLength);
                         GlobalUnlock(h);
                         SetClipboardData(CBF, h);
             end;
          end;
       end;
       Result:=true;

    {���������� ������}
    finally
       If FStream <> nil then FStream.Free;
       CloseClipBoard;
       DeleteFile(FName);
    end;
end;

end.
