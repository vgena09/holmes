unit FunStream;

interface

uses System.SysUtils, System.Classes, System.Variants,
     Vcl.Dialogs, Vcl.OleCtnrs;

   {��������� ���� ����� � ������}
   procedure AddToStream(var Source, Dest: TStream);
   {�������� ����� ������ � ������ �����}
   procedure GetFromStream(var Source, Dest: TStream);
   
   {��������� ������ ���������� � �����}
   procedure AddVarToStream(const VSource: array of const; var Dest: TStream);
   {��������� Integer-���������� �� ������}
   function  GetIntegerFromStream(var Source: TStream; const ValErr: Integer): Integer;
   {��������� Boolean-���������� �� ������}
   function  GetBooleanFromStream(var Source: TStream; const ValErr: Boolean): Boolean;
   {��������� Char-���������� �� ������}
   function  GetCharFromStream(var Source: TStream; const ValErr: Char): Char;
   {��������� String-���������� �� ������}
   function  GetStringFromStream(var Source: TStream; const ValErr: String): String;

implementation
uses FunConst, FunWord, FunText;

{==============================================================================}
{=================  � � � � � � � �   �   � � � � � � � �  ====================}
{==============================================================================}


{==============================================================================}
{====================  ��������� ���� ����� � ������  =========================}
{==============================================================================}
procedure AddToStream(var Source, Dest: TStream);
var Size : Integer;
begin
    Source.Position := 0;
    {��������� ������, ������� ��� � ������ ����}
    Size:=Source.Size;
    Dest.Write(Size, SizeOf(Integer));
    Dest.CopyFrom(Source, Source.size);
end;

{==============================================================================}
{=================  �������� ����� ������ � ������ �����  =====================}
{==============================================================================}
procedure GetFromStream(var Source, Dest: TStream);
var Size: Integer;
begin
    {������� ����� � Dest}
    Dest.Position:=0;
    Dest.Size:=0;
    {�������� �������� ������ �����}
    Source.Read(Size, SizeOf(Integer));
    {�������� ������}
    Dest.CopyFrom(Source, Size);
    {������������ ���������}
    Dest.Position:=0;
end;


{==============================================================================}
{=================  ��������� ������ ���������� � �����   =====================}
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
{=================  ��������� Integer-���������� �� ������  ===================}
{==============================================================================}
function GetIntegerFromStream(var Source: TStream; const ValErr: Integer): Integer;
var Size: Integer;
begin
    Result:=ValErr;
    Source.Read(Size, SizeOf(Integer));
    If Size=SizeOf(Integer) then Source.Read(Result, Size);
end;


{==============================================================================}
{=================  ��������� Boolean-���������� �� ������  ===================}
{==============================================================================}
function GetBooleanFromStream(var Source: TStream; const ValErr: Boolean): Boolean;
var Size: Integer;
begin
    Result:=ValErr;
    Source.Read(Size, SizeOf(Integer));
    If Size=SizeOf(Boolean) then Source.Read(Result, Size);
end;

{==============================================================================}
{===================  ��������� Char-���������� �� ������  ====================}
{==============================================================================}
function GetCharFromStream(var Source: TStream; const ValErr: Char): Char;
var Size: Integer;
begin
    Result:=ValErr;
    Source.Read(Size, SizeOf(Integer));
    If Size=SizeOf(Char) then Source.Read(Result, Size);
end;

{==============================================================================}
{===================  ��������� String-���������� �� ������  ==================}
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

