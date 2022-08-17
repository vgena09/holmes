unit FunClip;

{******************************************************************************}
{************************ ОРГАНИЗАЦИЯ РАБОТЫ CLIPBOARD ************************}
{******************************************************************************}

interface
uses
   Winapi.Windows, System.SysUtils, System.Classes, Vcl.Clipbrd;

    {ПОМЕЩАЕТ СТРОКУ S В БУФЕР ОБМЕНА}
    procedure PutStringInClipboard(const S: String);
    {ИЗВЛЕКАЕТ СТРОКУ S ИЗ БУФЕРА ОБМЕНА}
    function  GetStringFromClipboard: String;
    {ОЧИСТКА БУФЕРА ОБМЕНА}
    procedure ClearClipboard;
    {СОХРАНЕНИЕ БУФЕРА ОБМЕНА ВО ВРЕМЕННЫЙ ФАЙЛ}
    function  SaveClipboard: Boolean;
    {ВОССТАНОВЛЕНИЕ БУФЕРА ОБМЕНА ИЗ ВРЕМЕННОГО ФАЙЛА}
    function  LoadClipboard: Boolean;

implementation

uses FunConst;


{==============================================================================}
{===================  ПОМЕЩАЕТ СТРОКУ S В БУФЕР ОБМЕНА  =======================}
{==============================================================================}
procedure PutStringInClipboard(const S: String);
begin
    Clipboard.Open;
    Clipboard.AsText := S;
    Clipboard.Close;
end;


{==============================================================================}
{==================  ИЗВЛЕКАЕТ СТРОКУ S ИЗ БУФЕРА ОБМЕНА  =====================}
{==============================================================================}
function GetStringFromClipboard: String;
begin
    Result:='';
    if not IsClipboardFormatAvailable(CF_Text) then begin      //CF_UNICODETEXT - могут появиться иероглифы
       Result:=Clipboard.AsText;
    end;
end;



{==============================================================================}
{========================  ОЧИСТКА БУФЕРА ОБМЕНА  =============================}
{==============================================================================}
procedure ClearClipboard;
begin
    Clipboard.Open;
    Clipboard.Clear;
    Clipboard.Close;
//    OpenClipboard(0);  разницы не знаю
//    EmptyClipboard;
//    CloseClipboard;
end;


{==============================================================================}
{====================  СОХРАНЕНИЕ БУФЕРА ОБМЕНА В ФАЙЛ ========================}
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
    {Инициализация}
    Result := false;

    {Файл}
    FName  := PATH_WORK_TEMP + FILE_CLIPBOARD;
    If FileExists(FName) then If not DeleteFile(FName) then Exit;
    If not ForceDirectories(ExtractFilePath(FName))    then Exit;

    If not OpenClipboard(0) then Exit;
    try try
       {Создаем файл-поток}
       FStream:=TFileStream.Create(FName, fmCreate, fmShareExclusive);

       {Формируем список блоков}
       CBFList:=TList.Create;
       CBF:=0;
       repeat CBF:=EnumClipboardFormats(CBF);
              If CBF<>0 then CBFList.Add(pointer(CBF));
       until  CBF=0;

       {Если имеется хоть один блок}
       If CBFList.Count>0 then begin

          {Записываем число блоков}
          Temp := CBFList.Count;
          FStream.Write(Temp, SizeOf(Integer));

          {Записываем сами блоки}
          for I := 0 to CBFList.Count - 1 do begin
             {Определяем Handle блока}
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
       {Завершение работы}
       If FStream <> nil then FStream.Free;
       If CBFList <> nil then CBFList.Free;
       CloseClipBoard;
    end;
end;


{==============================================================================}
{===============  ВОССТАНОВЛЕНИЕ БУФЕРА ОБМЕНА ИЗ ФАЙЛА  ======================}
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
    {Инициализация}
    Result := false;
    ClearClipboard;
    FName  := PATH_WORK_TEMP + FILE_CLIPBOARD;
    If not FileExists(FName) then Exit;
    If not OpenClipboard(0)  then Exit;
    try
       {Открываем файл}
       FStream:=TFileStream.Create(FName, fmOpenRead);
       If FStream.Size=0 then Exit;

       {Читаем число блоков}
       FStream.Read(CBCount, sizeOf(Integer));
       If CBCount=0 then Exit;

       {Читам по очереди блоки}
       For I := 1 to CBCount do begin
          FStream.Read(CBF, SizeOf(Cardinal));
          FStream.Read(CBBlockLength, SizeOf(Cardinal));
          {Читаем Handle блока}
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

    {Завершение работы}
    finally
       If FStream <> nil then FStream.Free;
       CloseClipBoard;
       DeleteFile(FName);
    end;
end;

end.
