unit FunStream;

interface

uses System.SysUtils, System.Classes, System.Variants,
     Vcl.Dialogs, Vcl.OleCtnrs;

   {Добавляет один поток в другой}
   procedure AddToStream(var Source, Dest: TStream);
   {Копирует часть потока в другой поток}
   procedure GetFromStream(var Source, Dest: TStream);
   
   {Добавляет список переменных в поток}
   procedure AddVarToStream(const VSource: array of const; var Dest: TStream);
   {Извлекает Integer-переменную из потока}
   function  GetIntegerFromStream(var Source: TStream; const ValErr: Integer): Integer;
   {Извлекает Boolean-переменную из потока}
   function  GetBooleanFromStream(var Source: TStream; const ValErr: Boolean): Boolean;
   {Извлекает Char-переменную из потока}
   function  GetCharFromStream(var Source: TStream; const ValErr: Char): Char;
   {Извлекает String-переменную из потока}
   function  GetStringFromStream(var Source: TStream; const ValErr: String): String;

implementation
uses FunConst, FunWord, FunText;

{==============================================================================}
{=================  О П Е Р А Ц И И   С   П О Т О К А М И  ====================}
{==============================================================================}


{==============================================================================}
{====================  Добавляет один поток в другой  =========================}
{==============================================================================}
procedure AddToStream(var Source, Dest: TStream);
var Size : Integer;
begin
    Source.Position := 0;
    {Сохраняем размер, помещая его в первый байт}
    Size:=Source.Size;
    Dest.Write(Size, SizeOf(Integer));
    Dest.CopyFrom(Source, Source.size);
end;

{==============================================================================}
{=================  Копирует часть потока в другой поток  =====================}
{==============================================================================}
procedure GetFromStream(var Source, Dest: TStream);
var Size: Integer;
begin
    {Очищаем буфер у Dest}
    Dest.Position:=0;
    Dest.Size:=0;
    {Получаем желаемый размер файла}
    Source.Read(Size, SizeOf(Integer));
    {Получаем данные}
    Dest.CopyFrom(Source, Size);
    {Корректируем указатель}
    Dest.Position:=0;
end;


{==============================================================================}
{=================  Добавляет список переменных в поток   =====================}
{==============================================================================}
procedure AddVarToStream(const VSource: array of const; var Dest: TStream);
var ArgsTyped: array [0..$fff0 div sizeof(TVarRec)] of TVarRec absolute VSource;
    Size, I : Integer;
    S       : String;
    procedure WriteSize(const Size_: Integer);
    begin
        Size:=Size_;
        Dest.Write(Size, SizeOf(Integer));
    end;
begin
    For I := Low(VSource) to High(VSource) do
       with ArgsTyped[I] do begin
          case VType of
          vtInteger:    begin {writeln(VInteger);}
                           WriteSize(SizeOf(Integer));
                           Dest.Write(VInteger, Size);
                        end;
          vtBoolean:    begin {writeln(VBoolean);}
                           WriteSize(SizeOf(Boolean));
                           Dest.Write(VBoolean, Size);
                        end;
          vtChar:       begin {writeln(VChar);}
                           WriteSize(SizeOf(Char));
                           Dest.Write(VChar, Size);
                        end;
          vtString,           {writeln(VString^);}
          vtAnsiString: begin {writeln(VAnsiString);}
                           If VType=vtString then S:=VString^
                                             else S:=String(VAnsiString);
                           WriteSize(Length(S));
                           If S<>'' then Dest.Write(S[1], Size);
                        end;
       end;
    end;
end;


{==============================================================================}
{=================  Извлекает Integer-переменную из потока  ===================}
{==============================================================================}
function GetIntegerFromStream(var Source: TStream; const ValErr: Integer): Integer;
var Size: Integer;
begin
    Result:=ValErr;
    Source.Read(Size, SizeOf(Integer));
    If Size=SizeOf(Integer) then Source.Read(Result, Size);
end;


{==============================================================================}
{=================  Извлекает Boolean-переменную из потока  ===================}
{==============================================================================}
function GetBooleanFromStream(var Source: TStream; const ValErr: Boolean): Boolean;
var Size: Integer;
begin
    Result:=ValErr;
    Source.Read(Size, SizeOf(Integer));
    If Size=SizeOf(Boolean) then Source.Read(Result, Size);
end;

{==============================================================================}
{===================  Извлекает Char-переменную из потока  ====================}
{==============================================================================}
function GetCharFromStream(var Source: TStream; const ValErr: Char): Char;
var Size: Integer;
begin
    Result:=ValErr;
    Source.Read(Size, SizeOf(Integer));
    If Size=SizeOf(Char) then Source.Read(Result, Size);
end;

{==============================================================================}
{===================  Извлекает String-переменную из потока  ==================}
{==============================================================================}
function GetStringFromStream(var Source: TStream; const ValErr: String): String;
var Size: Integer;
begin
    Result:=ValErr;
    Source.Read(Size, SizeOf(Integer));
    If Size>0 then begin
       SetLength(Result, Size);
       Source.Read(Result[1], Size);
    end;
end;


end.

