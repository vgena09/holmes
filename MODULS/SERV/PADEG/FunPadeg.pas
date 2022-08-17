unit FunPadeg;

interface
uses
   Winapi.Windows,
   System.Classes, System.SysUtils,
   Vcl.Dialogs, Vcl.Controls,
   Data.DB, Data.Win.ADODB,
   FunType;

function  PadegFIO    (const Padeg_, FIO: String): String;
//function  PadegDLG    (const Padeg_, Str: String): String;
function  PadegAUTO   (const Padeg_, Str: String): String;
function  GetSexFIO(const FIO: String): Boolean;
function  PadegToInt(const PadegChar: String): Integer;
function  SetPredlog(const Str: String): String;
function  FIO_Initialy(const FIO: String; const IsFirstFamily: Boolean): String;

//function  GetOfficePadeg(pOffice: PChar; nPadeg: LongInt; pResult: PChar;
//                          var nLen: LongInt): Integer; stdcall; external
//                          'padeg.dll' Name 'GetOfficePadeg';

implementation

uses FunConst, FunText, FunDay, FunBD, PadegFIO_ANSI {�������� Padeg.dll};
     //FunBD_Padeg2, MSERV_LISTBOX;

{******************************************************************************}
{*************** �������������� ��������� � ����������� ���� ******************}
{******************************************************************************}


{==============================================================================}
{=================   �������� �������, ���, ��������   ========================}
{==============================================================================}
function PadegFIO(const Padeg_, FIO: String): String;
begin
    Result := GetFIOPadegFSAS(FIO, PadegToInt(Padeg_));
end;


{==============================================================================}
{=================  �������� ����� ������ � �� � �������   ====================}
{==============================================================================}
//function PadegDLG(const Padeg_, Str: String): String;
//var F: TFPadeg2;
//begin
//    F:=TFPadeg2.Create(nil);
//    Result:=F.Execute(Padeg_, Str);
//    F.Free;
//end;


{==============================================================================}
{=====================  �������������� ��������� �����  =======================}
{==============================================================================}
function PadegAUTO(const Padeg_, Str: String): String;
begin
    Result := GetOfficePadeg(Str, PadegToInt(Padeg_));
end;


{==============================================================================}
{===============    � � � � � � � � � � �   � � � �    ========================}
{========================  True - ���� �������  ===============================}
{==============================================================================}
function GetSexFIO(const FIO: String): Boolean;
var S: String;
begin
     Result:=True;
     S:=FIO;
     if Length(S)=0 then Exit;
     if GetColSlov(S,' ')>1 then S:=CutSlovo(S, 2, ' ');
     if ((S[Length(S)]='�')or(S[Length(S)]='�')or
         (S[Length(S)]='�')or(S[Length(S)]='�')) then Result:=False;
     {����������}
     if AnsiUpperCase(S)='����' then Result:=True;
     if AnsiUpperCase(S)='����' then Result:=True;
end;


{==============================================================================}
{==============================  ����� � �����    =============================}
{==============================================================================}
function PadegToInt(const PadegChar: String): Integer;
var Ch: Char;
begin
    If PadegChar='' then Ch:='�' else Ch:=PadegChar[1];
    Case Ch of
    '�': Result := 1;
    '�': Result := 2;
    '�': Result := 3;
    '�': Result := 4;
    '�': Result := 5;
    '�': Result := 6;
    else Result := 1;
    end;
end;


{==============================================================================}
{==========  ���������� ������� ��� ����������� ������: � ��� ��  =============}
{==============================================================================}
function SetPredlog(const Str: String): String;
var S: String;
begin
    {�������������}
    Result:=Str;
    If Result='' then Exit;

    S:=AnsiUpperCase(Result);
    Case S[1] of
    '�','�','�','�','�','�','�','�','�','�': Result:='�� '+Result;
    else                                     Result:='� ' +Result;
    end;
end;


{==============================================================================}
{===================  �� ������ ���: ������� + ��������  ======================}
{==============================================================================}
function FIO_Initialy(const FIO: String; const IsFirstFamily: Boolean): String;
var PFIO    : TFIOParts;
    S, Pref : String;
begin
    {�������������}
    Result:=Trim(FIO);
    If Length(Result) < 4 then Exit;

    {�������� ��������� ������� ����������� ������}
    Pref := '';
    S    := AnsiUpperCase(Result);
    If Pos('������������', S) > 0 then Exit;
    If S[1]+S[2]+S[3] = '�� '   then begin Pref:=Copy(Result, 1, 3); Delete(Result, 1, 3); end;
    If S[1]+S[2]      = '� '    then begin Pref:=Copy(Result, 1, 2); Delete(Result, 1, 2); end;


    {�������� ������������ FIO � ��������� ����}
    PFIO := GetFIOParts(Result);
    PFIO.FirstName  := Trim(PFIO.FirstName);
    PFIO.MiddleName := Trim(PFIO.MiddleName);
    PFIO.LastName   := Trim(PFIO.LastName);

    If IsFirstFamily then begin
       Result:=PFIO.LastName;
       If PFIO.FirstName  <> '' then Result:=Result+' '+CutStrPos(PFIO.FirstName,  1, 1)+'.';
       If PFIO.MiddleName <> '' then Result:=Result+    CutStrPos(PFIO.MiddleName, 1, 1)+'.';
    end else begin
       If PFIO.FirstName  <> '' then Result:=           CutStrPos(PFIO.FirstName,  1, 1)+'.';
       If PFIO.MiddleName <> '' then Result:=Result+    CutStrPos(PFIO.MiddleName, 1, 1)+'.';
       Result:=Result+PFIO.LastName;
    end;

    {��������������� ��������� �������}
    Result:=Pref+Result;
end;

(*   ��������� �� �������������
{==============================================================================}
{===================           �������� ������             ====================}
{==============================================================================}
{===================   Padeg_  - �������� ������ �������   ====================}
{==============================================================================}
function PadegSTATUS(const P: PADOTable; const Padeg_, Status_: String): String;
var T: TADOTable;

      function VerifyStatusSex(var StatusTxt: String; const List: array of String): Boolean;
      var S  : String;
          Ch : Char;
          I  : Integer;
      begin
          {�������������}
          Result:=false;

          {������}
          S:='';
          For I:=Low(List) to High(List) do S:=S+' OR (['+List[I]+']='+QuotedStr(StatusTxt)+')';
          Delete(S, 1, 4);
          SetDBFilter(@T, S);

          {������ �� �������� ������}
          If T.RecordCount=0 then Exit;

          {������������� �������� ������}
          If Padeg_<>'' then Ch:=Padeg_[1] else Ch:='�';
          Case Ch of
          '�': StatusTxt:=T.FieldByName(List[Low(List)+0]).AsString;
          '�': StatusTxt:=T.FieldByName(List[Low(List)+1]).AsString;
          '�': StatusTxt:=T.FieldByName(List[Low(List)+2]).AsString;
          '�': StatusTxt:=T.FieldByName(List[Low(List)+3]).AsString;
          '�': StatusTxt:=T.FieldByName(List[Low(List)+4]).AsString;
          '�': StatusTxt:=T.FieldByName(List[Low(List)+5]).AsString;
          end;
          Result:=true;
      end;

begin
    {�������������}
    Result := Status_;
    T      := LikeTable(P);
    try
       If VerifyStatusSex(Result, LSTATUS_MAN) then Exit;  {������� ������������}
          VerifyStatusSex(Result, LSTATUS_FEM);            {������� ������������}
    finally
       If T.Active then T.Close;  T.Free;
    end;
end;
*)

end.

