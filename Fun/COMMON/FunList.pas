unit FunList;

interface

uses System.SysUtils, System.Classes, System.Math,
     Vcl.Dialogs, IdGlobal,
     FunType;


{�������� �� STRING_LIST}

{������ �������� �� ������ TStringList}
function  LRead(const PList: PStringList; const SKey: String; const SVal0: String): String;
{��������� � Plist ���������� ������ PListAdd}
procedure LAddUniq(const PList, PListAdd: PStringList);

{�������� � SECTION}

{�������� ������ Section (��� ���������) �� ������ PSrc^ � ������ PDest^}
function  LSectionCopy(const PSrc, PDest: PStringList; const Section: String): Boolean;
{������� �� ������ PLsit^ ������ Section}
function  LSectionDel(const PList: PStringList; const Section: String): Boolean;

{�������� � ELEMENT}

{��������� �������� � ������}
procedure LElementAdd(const PList: PStringList; const Section: String; const Element: String);
{������� �������� �� ������}
procedure LElementDel(const PList: PStringList; const Section: String; const Element: String);

{�������� � KEY}

{�������� � ������ PList^ ������ Section ��� Key �� PKey^}
procedure LKeyReplace(const PList, PKey: PStringList; const Section, Key: String);
{��������� � ������ PLsit^ ������ �������� Key.*}
procedure LKeySel(const PList: PStringList; const Key: String);
{������� � ������ PList^ ������ �������� Key.*}
procedure LKeyDel(const PList: PStringList; const Key: String);
{���������� � ������ PList^ ��������� Key.*}
function  LKeyCount(const PList: PStringList; const Key: String): Integer;
{�������� �������� �������� �� ������ � ����� ������}
function  LElementCopyKey(const PSrc, PDest: PStringList; const Element: String): Boolean;

{�������� � �������������}

{��������� ������������ � ������}
function  MStrSeparat(const MStr: String; const PLStr: PStringList; const Separator: String): Boolean;
{�������� ������ � ������������}
function  MStrGroup(const PLStr: PStringList; const Separator: String): String;
{������ ILine (0, 1, ...) ������ ������������ MStr}
function  MStrRead(const MStr: String; const ILine: Integer): String;

implementation

uses FunConst, FunText;


{******************************************************************************}
{*********************   �������� �� STRING_LIST   ****************************}
{******************************************************************************}

{==============================================================================}
{=================  ������ �������� �� ������ TStringList  ====================}
{==============================================================================}
function LRead(const PList: PStringList; const SKey: String; const SVal0: String): String;
var I: Integer;
begin
    I := PList^.IndexOfName(SKey);
    If I > -1 then Result := Trim(PList^.ValueFromIndex[I])
              else Result := SVal0;
end;

{==============================================================================}
{==============  ��������� � Plist ���������� ������ PListAdd  ================}
{==============================================================================}
procedure LAddUniq(const PList, PListAdd: PStringList);
var I: Integer;
begin
    For I:=0 to PListAdd^.Count-1 do begin
       If PList^.IndexOf(PListAdd^[I]) < 0 then PList^.Add(PListAdd^[I]);
    end;
end;



{******************************************************************************}
{************************   �������� � SECTION   ******************************}
{******************************************************************************}


{==============================================================================}
{=== �������� ������ Section (��� ���������) �� ������ PSrc^ � ������ PDest^ ==}
{==============================================================================}
{============  [������ 1]             =========================================}
{============  ...           --> ...  =========================================}
{============  [������ 2]             =========================================}
{============  ...                    =========================================}
{==============================================================================}
function LSectionCopy(const PSrc, PDest: PStringList; const Section: String): Boolean;
var I     : Integer;
    B     : Boolean;
    S, S0 : String;
begin
    {�������������}
    Result:=false;
    If (PSrc=nil) or (PDest=nil) then Exit;
    PDest^.Clear;
    S0:=AnsiUpperCase(Section);
    B:=false;

    For I:=0 to PSrc^.Count-1 do begin
       S:=Trim(CutModulChar(Trim(PSrc^[I]), '[', ']'));
       If S <> '' then B := (AnsiUpperCase(S) = S0)
                  else If B then PDest^.Add(PSrc^[I]);
    end;
    Result:=true;
end;


{==============================================================================}
{============  ������� �� ������ PList^ ������ Section  =======================}
{==============================================================================}
{============  [������ 1]        X    =========================================}
{============  ...               X    =========================================}
{============  [������ 2]             =========================================}
{============  ...                    =========================================}
{==============================================================================}
function LSectionDel(const PList: PStringList; const Section: String): Boolean;
label Nx;
var I     : Integer;
    B     : Boolean;
    S, S0 : String;
begin
    {�������������}
    Result := false;
    If PList=nil then Exit;
    S0     := AnsiUpperCase(Section);
    B      := false;
    I      := 0;

Nx: If I <= PList^.Count-1 then begin
       {��������� �������� ������}
       S := Trim(CutModulChar(Trim(PList^[I]), '[', ']'));
       If S <> '' then B := (AnsiUpperCase(S) = S0);
       {������� ������ ��� ��������� � ���������}
       If B then PList^.Delete(I)
            else I:=I+1;
       {��������� ������}
       Goto Nx;
    end;

    {������������ ���������}
    Result:=true;
end;



{******************************************************************************}
{************************   �������� � ELEMENT   ******************************}
{******************************************************************************}

{==============================================================================}
{=======================  ��������� �������� � ������  ========================}
{==============================================================================}
procedure LElementAdd(const PList: PStringList; const Section: String; const Element: String);
var L: TStringList;
begin
    L := TStringList.Create;
    try
       LSectionCopy(PList, @L, Section);
       LSectionDel(PList, Section);
       L.Add(Element);
       PList^.Text := PList^.Text+'['+Section+']'+CH_NEW+L.Text;
    finally L.Free;
    end;
end;


{==============================================================================}
{=======================  ������� �������� �� ������     ======================}
{=======================  Element = '' - ������� ������  ======================}
{==============================================================================}
procedure LElementDel(const PList: PStringList; const Section: String; const Element: String);
var L : TStringList;
    I : Integer;
begin
    L := TStringList.Create;
    try
       LSectionCopy(PList, @L, Section);
       LSectionDel(PList, Section);
       If Element = '' then Exit;
       I := L.IndexOf(Element);
       If I > -1 then L.Delete(I);
       If L.Count = 0 then Exit;
       PList^.Text := PList^.Text+'['+Section+']'+CH_NEW+L.Text;
    finally L.Free;
    end;
end;



{******************************************************************************}
{**************************   �������� � KEY   ********************************}
{******************************************************************************}

{==============================================================================}
{========  �������� � ������ PList^ ������ Section ��� Key �� PKey^  ==========}
{========  ���� ����� ���������� ������ �����, �� ��� ���������      ==========}
{========  ��������� ����������� ������                              ==========}
{==============================================================================}
procedure LKeyReplace(const PList, PKey: PStringList; const Section, Key: String);
var LSection : TStringList;
    I        : Integer;
begin
    LSection := TStringList.Create;
    try
       LSectionCopy(PList, @LSection, Section);
       LKeyDel(@LSection, Key);
       LSectionDel(PList, Section);
       If (LSection.Count > 0) or (PKey^.Count > 0) then begin
          LSection.Text := LSection.Text+PKey^.Text;
          LSection.Sort;
          PList^.Text := PList^.Text+'['+Section+']'+CH_NEW+LSection.Text;
          For I := PList^.Count-1 downto 0 do If PList^[I]='' then PList^.Delete(I);
       end;
    finally
       LSection.Free;
    end;
end;


{==============================================================================}
{===========   ��������� � ������ PList^ ������ �������� Key.*  ===============}
{==============================================================================}
{============  Key1.Val1 <-- Key=Key1                           ===============}
{============  Key1.Val2 <--                                    ===============}
{============  Key2.Val3                                        ===============}
{============  Key2.Val4                                        ===============}
{==============================================================================}
procedure LKeySel(const PList: PStringList; const Key: String);
var I: Integer;
begin
    For I:=PList^.Count-1 downto 0 do begin
       If Not CmpStr(CutSlovo(PList^[I], 1, '.'), Key) then PList^.Delete(I);
    end;
end;


{==============================================================================}
{===========   ������� � ������ PList^ ������ �������� Key.*    ===============}
{==============================================================================}
procedure LKeyDel(const PList: PStringList; const Key: String);
var I: Integer;
begin
    For I:=PList^.Count-1 downto 0 do begin
       If CmpStr(CutSlovo(PList^[I], 1, '.'), Key) then PList^.Delete(I);
    end;
end;


{==============================================================================}
{===========   ���������� � ������ PList^ ��������� Key.*       ===============}
{==============================================================================}
function LKeyCount(const PList: PStringList; const Key: String): Integer;
var L: TStringList;
begin
    L := TStringList.Create;
    try     L.Text := PList^.Text;
            LKeySel(@L, Key);
            Result := L.Count;
    finally L.Free;
    end;
end;


{==============================================================================}
{==========   �������� �������� �������� �� ������ � ����� ������  ============}
{==============================================================================}
{============  �������1.��������1                                 =============}
{============  �������1.��������2                                 =============}
{============  �������2.��������3 --> ��������3                   =============}
{============  �������2.��������4 --> ��������3                   =============}
{==============================================================================}
function LElementCopyKey(const PSrc, PDest: PStringList; const Element: String): Boolean;
var I, J  : Integer;
    S, S0 : String;
begin
    {�������������}
    Result:=false;
    If (PSrc=nil) or (PDest=nil) then Exit;
    If PSrc=PDest then Exit;
    PDest^.Clear;
    S0:=AnsiUpperCase(Element);

    For I:=0 to PSrc^.Count-1 do begin
       S:=AnsiUpperCase(CutSlovo(PSrc^[I], 1, '.'));
       If S=S0 then begin
          J:=InStrMy(1, PSrc^[I], '.');
          If J>=0 then begin
             S:=PSrc^[I];
             Delete(S, 1, J);
             PDest^.Add(Trim(S));
          end;
       end;
    end;

    {������������ ���������}
    Result:=true;
end;



{******************************************************************************}
{*********************   �������� � �������������   ***************************}
{******************************************************************************}

{==============================================================================}
{=====================  ��������� ������������ � ������  ======================}
{==============================================================================}
function MStrSeparat(const MStr: String; const PLStr: PStringList; const Separator: String): Boolean;
var S: String;
    I: Integer;
begin
    {�������������}
    Result:=false;
    If PLStr=nil then Exit;
    PLStr^.Clear;

    {������������� ��� ������� � ��������� ������}
    I:=1; S:=CutSlovo(MStr, I, Separator);
    While S<>'' do begin
       Result:=true;
       PLStr^.Add(S);
       Inc(I); S:=CutSlovo(MStr, I, Separator);
    end;
end;


{==============================================================================}
{=====================  �������� ������ � ������������   ======================}
{==============================================================================}
function MStrGroup(const PLStr: PStringList; const Separator: String): String;
var I: Integer;
begin
    {�������������}
    Result:='';
    If PLStr=nil then Exit;

    {������������� ��� ������� � ��������� ������}
    For I:=0 to PLStr^.Count-1 do Result:=Result+Separator+PLStr^[I];

    {������� ��������� ������� �����������}
    If Result<>'' then Delete(Result, 1, Length(Separator));
end;


{==============================================================================}
{==============  ������ ILine (0, 1, ...) ������ ������������ MStr  ===========}
{==============================================================================}
function MStrRead(const MStr: String; const ILine: Integer): String;
var SList: TStringList;
begin
    Result := '';
    SList  := TStringList.Create;
    try
       SList.Text := MStr;
       If (SList.Count < 0) or (ILine >= SList.Count) then Exit;
       Result := SList[ILine];
    finally
       SList.Free;
    end;
end;


end.

