unit FunIDE;

interface
uses
   System.Classes, System.SysUtils,
   Vcl.Dialogs, Vcl.Controls,
   Data.DB, Data.Win.ADODB,
   FunType, MAIN;

type
  TID = record
      Tab : String;
      Rec : String;
  end;
  PID = ^TID;

{���������� ����.5 --> ICO_PPERSON_1}
function  IDToIco(const PUD: PBUD; const ID: String): Integer;
{������ �������� ��}
function  GetIcoElementUD(const PDataSet: PADOTable; const ITable: Integer): Integer;
{������� TID �� ������ ID}
function  SeparatID(const ID: String): TID;
{���������� ����.5 --> ���������� ����}
function  IDToTable(const ID: String): String;
{���������� ����.5 --> 5}
function  IDToRecord(const ID: String): String;


{������������� ���� F_CAPTION ��� IDE}
//function  SetIDECaption(const PBD: PADOConnection; const IDE: TIDE): Boolean;
{��������� TXT �� ������ ��������/������}
//function  ElementToTxt(const PBD: PADOConnection; const Table, Key: String; const Args: array of const): String;
{��������� TXT �� ID}
function  IDToTxt(const PUD: PBUD; const ID: String; const Args: array of const): String;
{����������� ��� ����}
//function  GetSexIDE(const PBD: PADOConnection; const IDE: TIDE): Boolean;
{������ � IDE}
//function  StrToIDE(const Str: String): TIDE;
{��������� IDE}
//function  SetIDESimple(const Table, Key: String): TIDE;
{���������� IDE}
//function  CmpIDE(const IDE1, IDE2: TIDE): Boolean;
{������� IDE}
//procedure ClearIDE(var IDE: TIDE);
{������ IDE}
//function  NullIDE: TIDE;
{��������� �� ����� ID}
function  VerifyID(ID: String): Boolean;
{������ �� IDE}
//function  IsNullIDE(IDE: TIDE): Boolean;
{�������� �� IDE ��������� ��������� ��}
//function  IsIDETabElement(const IDE: TIDE): Boolean;
{�������� �� IDE ������� ��������� ��}
//function  IsIDETabList(const IDE: TIDE): Boolean;
{���������� �� IDE ID �������}
//function  IDEToIDTable(const IDE: TIDE): String;
{��������� �� IDE ������}
//function  IDEToFilter(const IDE: TIDE): String;

{�������� �� ������� ��������� ��������� ��}
function  IsTabUD(const Table: String): Boolean;
{������������� ������� �� �� ������ ������}
function  PosTabUD(const P: PADOTable; const Rec: String): Boolean;
{�� �������� ������� ����������� ��������� �� �������}
function  NameToTabUD(const PUD: PBUD; const Table: String): PADOTable;
{�� �������� ������� ����������� ������ �������}
function  TabUDToInd(const Table: String): Integer;
{��������� ������� ��}
procedure RefreshTabUD(const PUD: PBUD; const Table: String);




implementation

uses FunConst, FunSys, FunText, FunBD, FunPadeg;



{==============================================================================}
{=================    ���������� ����.5 --> ICO_PPERSON_1     =================}
{==============================================================================}
function IDToIco(const PUD: PBUD; const ID: String): Integer;
var IDE : TID;
    P   : PADOTable;
begin
    Result := ICO_PPERSON_1;
    IDE    := SeparatID(ID);

    P := NameToTabUD(PUD, IDE.Tab);
    If P = nil then Exit;
    try try
       If PosTabUD(P, IDE.Rec) then Result := GetIcoElementUD(P, TabUDToInd(IDE.Tab));
    except end;
    finally if P <> nil then SetDBFilter(P, ''); end;
end;


{==============================================================================}
{=====================       ������ �������� ��      ==========================}
{=====================  PDATASET - ����������������  ==========================}
{==============================================================================}
function GetIcoElementUD(const PDataSet: PADOTable; const ITable: Integer): Integer;
var S: String;
begin
    Result := ICO_PPERSON_1;
    Case ITable of
    LTAB_UD_PPERSON: begin
       Result := ICO_PPERSON_1;
       S := PDataSet^.FieldByName(PPERSON_STATE).AsString;
       If CmpStr(S, PPERSON_STATE_WITNESS) then begin Result := ICO_PPERSON_1; Exit; end;
       If CmpStr(S, PPERSON_STATE_VICTIM)  then begin Result := ICO_PPERSON_2; Exit; end;
       If CmpStr(S, PPERSON_STATE_SUSPECT) then begin Result := ICO_PPERSON_3; Exit; end;
       If CmpStr(S, PPERSON_STATE_ACCUSED) then begin Result := ICO_PPERSON_4; Exit; end;
       If CmpStr(S, PPERSON_STATE_STUPID)  then begin Result := ICO_PPERSON_4; Exit; end;
       Exit;
    end;
    LTAB_UD_LPERSON: begin
       Result := ICO_LPERSON_1;
       S := PDataSet^.FieldByName(LPERSON_STATE).AsString;
       If CmpStr(S, LPERSON_STATE_CLAIM)     then begin Result := ICO_LPERSON_2; Exit; end;
       If CmpStr(S, LPERSON_STATE_DEFENDANT) then begin Result := ICO_LPERSON_3; Exit; end;
       Exit;
    end;
    LTAB_UD_DPERSON: begin
       Result := ICO_DPERSON_1;
       S := PDataSet^.FieldByName(LPERSON_STATE).AsString;
       If CmpStr(S, DPERSON_STATE_ADVOCATE)  then begin Result := ICO_DPERSON_2; Exit; end;
       If CmpStr(S, DPERSON_STATE_REPRESENT) then begin Result := ICO_DPERSON_3; Exit; end;
       Exit;
    end;
    LTAB_UD_OBJECT: begin
       Result := ICO_OBJECT_1;
       If PDataSet^.FieldByName(OBJECT_VD).AsBoolean
       then Result := ICO_OBJECT_2;
       Exit;
    end;
    end;
end;


function SeparatID(const ID: String): TID;
begin
    Result.Tab := ID;
    Result.Rec := TokCharEnd(Result.Tab, '.');
end;


{==============================================================================}
{==================  ���������� ����.5 --> ���������� ����  ===================}
{==============================================================================}
function  IDToTable(const ID: String): String;
begin
    Result := CutSlovo(ID, 1, '.');
end;


{==============================================================================}
{==================        ���������� ����.5 --> 5          ===================}
{==============================================================================}
function  IDToRecord(const ID: String): String;
begin
    Result := CutSlovoEndChar(ID, 1, '.');
end;


(*
{==============================================================================}
{=================   ������������� ���� F_CAPTION ��� IDE   ===================}
{==============================================================================}
function SetIDECaption(const PBD: PADOConnection; const IDE: TIDE): Boolean;
var T : TADOTable;
    Q : TADOQuery;
    I : Integer;
begin
    {������������� � �������� �� ������������}
    Result:=false;
    If PBD            = nil   then Exit;
    If PBD^.Connected = false then Exit;
    If VerifyIDE(IDE) = false then Exit;

    {�������� ������������ ����������}
    If CmpStrList(IDE.Table, [TABLE_RELATED])>=0 then Exit;

    {������� �������}
    T := TADOTable.Create(nil); If T=nil then Exit;
    Q := TADOQuery.Create(nil); If Q=nil then Exit;
    try
       {��������� �������}
       If OpenBD('', PBD, [@T], [IDE.Table])=false then Exit;
       Q.Database:=PBD^;

       {���� ������ IDE}
       SetDBFilter(@T, '['+F_COUNTER+']='+IDE.Key);
       If T.RecordCount<>1 then Exit;

       {�������� ���� F_CAPTION}
       T.Edit;
       T.FieldByName(F_CAPTION).AsString:=IDEToTxt(PBD, IDE, []);
       T.UpdateRecord;
       T.Post;

       {����������� ����� ��� ������� ������ � ��������� �������}
       For I:=Low(TAB_UD) to High(TAB_UD) do begin
          If HasRelTableDirectly(TAB_UD[I], IDE.Table)=false then Continue;
          If SetSQL(@Q, TAB_UD[I], IDE.Table, [IDE.Key], '')=false then Continue;
          Q.First;
          While Q.Eof=false do begin
             SetIDECaption(PBD, SetIDESimple(TAB_UD[I], Q.FieldByName(F_COUNTER).AsString));
             Q.Next;
          end;
       end;

       {������������ ���������}
       Result:=true;
    finally
       CloseBD(nil, [@T]);
       If Q.Active then Q.Close;
       Q.Free;
       T.Free;
    end;
end;


{==============================================================================}
{============      ��������� TXT �� ������ ��������/������       ==============}
{==============================================================================}
{============  Table   =  ���������� ����, �������, ����         ==============}
{============  Key     =  5                                      ==============}
{============  Args    =  [Padeg], [Sex]                         ==============}
{============  Padeg   =  ' ' (�.�. �), '�', '�', '�', '�', '�'  ==============}
{============  Sex     =  true - �������                         ==============}
{==============================================================================}
function ElementToTxt(const PBD: PADOConnection; const Table, Key: String; const Args: array of const): String;
begin
    Result:=IDEToTxt(PBD, SetIDESimple(Table, Key), Args);
end;

*)
{==============================================================================}
{============               ��������� TXT �� IDE                 ==============}
{==============================================================================}
{============  PBD     -  ���� ������ ���������� ����            ==============}
{============  Args    =  [Padeg], [Sex]                         ==============}
{============  Padeg   =  ' ' (�.�. �), '�', '�', '�', '�', '�'  ==============}
{==============================================================================}
function IDToTxt(const PUD: PBUD; const ID: String; const Args: array of const): String;
var ArgsTyped : array [0..$fff0 div sizeof(TVarRec)] of TVarRec absolute Args;
    Padeg     : Char;
    IDE       : TID;
    P         : PADOTable;
    S         : String;
begin
    {������������� � �������� �� ������������}
    Result := '';
    IDE    := SeparatID(ID);

    {���������� �������������� ���������}
    S := '';
    If Length(Args)>0 then begin
       With ArgsTyped[Low(Args)] do begin
          Case VType of
             vtString  : S   := AnsiUpperCase(VString^);
             vtChar    : S   := AnsiUpperCase(VChar);
          end;
       end;
    end;
    If S     <> ''  then Padeg:=S[1] else Padeg:=' ';
    If Padeg  = ' ' then Padeg:='�';

    try
       try
          {*** ���������� ���� ************************************************}
          If IDE.Tab = T_UD_PPERSON then begin
             P := @PUD^.TPPERSON; If Not PosTabUD(P, IDE.Rec) then Exit;
             Case Padeg of
             '�': Result:=P^.FieldByName(PPERSON_FIO).AsString;
             '�': Result:=P^.FieldByName(PPERSON_FIO_RP).AsString;
             '�': Result:=P^.FieldByName(PPERSON_FIO_DP).AsString;
             '�': Result:=P^.FieldByName(PPERSON_FIO_VP).AsString;
             '�': Result:=P^.FieldByName(PPERSON_FIO_TP).AsString;
             '�': Result:=P^.FieldByName(PPERSON_FIO_PP).AsString;
             end;
             Exit;
          end;

          {*** �������������� ���� ********************************************}
          If IDE.Tab = T_UD_DPERSON then begin
             P := @PUD^.TDPERSON; If Not PosTabUD(P, IDE.Rec) then Exit;
             Case Padeg of
             '�': Result:=P^.FieldByName(DPERSON_FIO).AsString;
             '�': Result:=P^.FieldByName(DPERSON_FIO_RP).AsString;
             '�': Result:=P^.FieldByName(DPERSON_FIO_DP).AsString;
             '�': Result:=P^.FieldByName(DPERSON_FIO_VP).AsString;
             '�': Result:=P^.FieldByName(DPERSON_FIO_TP).AsString;
             '�': Result:=P^.FieldByName(DPERSON_FIO_PP).AsString;
             end;
             Exit;
          end;

          {*** ����������� ���� ***********************************************}
          If IDE.Tab = T_UD_LPERSON then begin
             P := @PUD^.TLPERSON; If Not PosTabUD(P, IDE.Rec) then Exit;
             Case Padeg of
             '�': Result:=P^.FieldByName(LPERSON_NAME_SHORT).AsString;
             '�': Result:=PadegAUTO('�', P^.FieldByName(LPERSON_NAME_SHORT).AsString);
             '�': Result:=PadegAUTO('�', P^.FieldByName(LPERSON_NAME_SHORT).AsString);
             '�': Result:=PadegAUTO('�', P^.FieldByName(LPERSON_NAME_SHORT).AsString);
             '�': Result:=PadegAUTO('�', P^.FieldByName(LPERSON_NAME_SHORT).AsString);
             '�': Result:=PadegAUTO('�', P^.FieldByName(LPERSON_NAME_SHORT).AsString);
             end;
             Exit;
          end;

          {*** ������� ********************************************************}
          If IDE.Tab = T_UD_OBJECT then begin
             P := @PUD^.TOBJECT; If Not PosTabUD(P, IDE.Rec) then Exit;
             Result:=P^.FieldByName(OBJECT_CAPTION).AsString;
             Exit;
          end;

       finally
          if P <> nil then SetDBFilter(P, '');
       end;
    except end;
end;

(*
{==============================================================================}
{=======================   ���������� ��� ����   ==============================}
{==============================================================================}
{===========   Result = true - �������; false - �������           =============}
{==============================================================================}
function GetSexIDE(const PBD: PADOConnection; const IDE: TIDE): Boolean;
var T: TADOTable;
begin
    {������������� � �������� �� ������������}
    Result:=true;
    If PBD            = nil   then Exit;
    If PBD^.Connected = false then Exit;
    If VerifyIDE(IDE) = false then Exit;

    {�������� ������������ ����������}
    If (IDE.Table<>TABLE_PPERSONS) and (IDE.Table<>TABLE_DPERSONS) then Exit;

    {������� �������}
    T:=TADOTable.Create(nil); If T=nil then Exit;
    try
       {��������� �������}
       If OpenBD('', PBD, [@T], [IDE.Table])=false then Exit;

       {���� ������}
       SetDBFilter(@T, '['+F_COUNTER+']='+IDE.Key);
       If T.RecordCount<>1 then Exit;

       {������������ ��������}
       If IDE.Table=TABLE_PPERSONS then Result:=T.FieldByName(PPERSONS_SEX).AsBoolean;
       If IDE.Table=TABLE_DPERSONS then Result:=T.FieldByName(DPERSONS_SEX).AsBoolean;

    finally
       CloseBD(nil, [@T]);
       T.Free;
    end;
end;


{==============================================================================}
{==========================     ������ � IDE       ============================}
{==========================    (��� ��������)      ============================}
{==============================================================================}
function StrToIDE(const Str: String): TIDE;
begin
    Result := SetIDESimple(CutSlovoChar(Str, 1, '.'), CutSlovoChar(Str, 2, '.'));
end;


{==============================================================================}
{==========================     ��������� IDE      ============================}
{==========================    (��� ��������)      ============================}
{==============================================================================}
function SetIDESimple(const Table, Key: String): TIDE;
begin
    Result.Table := Table;
    Result.Key   := Key;
end;


{==============================================================================}
{=================              ���������� IDE                =================}
{==============================================================================}
function CmpIDE(const IDE1, IDE2: TIDE): Boolean;
begin
    {�������������}
    Result:=false;

    {���� ��������}
    If (IDE1.Table=IDE2.Table) and (IDE1.Key=IDE2.Key) then Result:=true;
end;


{==============================================================================}
{=================                ������� IDE                 =================}
{==============================================================================}
procedure ClearIDE(var IDE: TIDE);
begin
    IDE.Table := '';
    IDE.Key   := '';
end;


{==============================================================================}
{=================                 ������ IDE                 =================}
{==============================================================================}
function NullIDE: TIDE;
begin
    ClearIDE(Result);
end;
*)

{==============================================================================}
{=======================    ��������� �� ����� ID    ==========================}
{==============================================================================}
function VerifyID(ID: String): Boolean;
var IDE: TID;
begin
    IDE    := SeparatID(ID);
    Result := IsTabUD(IDE.Tab) and IsIntegerStr(IDE.Rec);
end;

(*
{==============================================================================}
{=================               ������ �� IDE                =================}
{==============================================================================}
function IsNullIDE(IDE: TIDE): Boolean;
begin
    If (IDE.Table='') and (IDE.Key='') then Result:=true else Result:=false
end;


{==============================================================================}
{================  �������� �� IDE ��������� ��������� ��  ====================}
{==============================================================================}
function IsIDETabElement(const IDE: TIDE): Boolean;
begin
    If ETableToIndex(IDE.Table)>-1 then Result:=true
                                   else Result:=false;
end;


{==============================================================================}
{================   �������� �� IDE ������� ��������� ��   ====================}
{==============================================================================}
function IsIDETabList(const IDE: TIDE): Boolean;
begin
    If LTableToIndex(IDE.Table)>-1 then Result:=true
                                   else Result:=false;
end;


{==============================================================================}
{====================     ���������� �� IDE ID �������     ====================}
{==============================================================================}
{====================              ��  --> 3               ====================}
{==============================================================================}
function IDEToIDTable(const IDE: TIDE): String;
var I : Integer;
begin
    Result:='';
    I:=ETableToIndex(IDE.Table); If I>-1 then begin Result:=IntToStr(I); Exit; end;
    I:=LTableToIndex(IDE.Table); If I>-1 then       Result:=IntToStr(I);
end;



{==============================================================================}
{==================         ��������� �� IDE ������         ===================}
{==============================================================================}
{==================      �� [5] --> [��].[F_COUNTER]=5      ===================}
{==============================================================================}
function IDEToFilter(const IDE: TIDE): String;
begin
    Result:='['+IDE.Table+'].['+F_COUNTER+']='+IDE.Key;
end;
*)




{==============================================================================}
{================  �������� �� ������� ��������� ��������� ��  ================}
{==============================================================================}
function IsTabUD(const Table: String): Boolean;
begin
    Result := IsStrInArray(Table, LTAB_UD);
end;


{==============================================================================}
{================  ������������� ������� �� �� ������ ������  =================}
{==============================================================================}
function PosTabUD(const P: PADOTable; const Rec: String): Boolean;
    begin
        SetDBFilter(P, '['+F_COUNTER+']='+Rec);
        Result := P^.RecordCount = 1;
    end;


{==============================================================================}
{===========  �� �������� ������� ����������� ��������� �� �������  ===========}
{==============================================================================}
function NameToTabUD(const PUD: PBUD; const Table: String): PADOTable;
begin
    Result := nil;
    If CmpStr(LTAB_UD[Low(LTAB_UD)],   Table) then begin Result := @PUD.TPPERSON; Exit; end;
    If CmpStr(LTAB_UD[Low(LTAB_UD)+1], Table) then begin Result := @PUD.TLPERSON; Exit; end;
    If CmpStr(LTAB_UD[Low(LTAB_UD)+2], Table) then begin Result := @PUD.TDPERSON; Exit; end;
    If CmpStr(LTAB_UD[Low(LTAB_UD)+3], Table) then begin Result := @PUD.TOBJECT;  Exit; end;
end;



{==============================================================================}
{==============  �� �������� ������� ����������� ������ �������  ==============}
{==============================================================================}
function TabUDToInd(const Table: String): Integer;
var I: Integer;
begin
    Result := -1;
    For I:=Low(LTAB_UD) to High(LTAB_UD) do begin
       If Table = LTAB_UD[I] then begin
          Result := I;
          Break;
       end;
    end;
end;



{==============================================================================}
{==========================  ��������� ������� ��  ============================}
{==============================================================================}
procedure RefreshTabUD(const PUD: PBUD; const Table: String);
var P: PADOTable;
begin
    P := NameToTabUD(PUD, Table);
    If P = nil then Exit;
    P^.Active := false;
    P^.Active := true;
end;

//initialization
//   FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
//
//finalization
//   FFMAIN := nil;

end.
