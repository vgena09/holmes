{==============================================================================}
{=============         ��������������  ������  ��������          ==============}
{==============================================================================}
{=============                   Kod = �������                   ==============}
{==============================================================================}
function TDECOD.DopDecoderTab(var DecStr: String; const Kod: String): Boolean;
label Ex;
var Cmd : String;
    Prm : TArrayStr;
    S   : String;
begin
    {�������������}
    Result := false;
    If Kod = ''  then Exit;

    {��������� ��� [Kod] �� ������� [Cmd] � ��������� [Prm]}
    SeparatKod(Kod, Cmd, Prm);
    try
       {�������-����������}
       If CmpStrList(Cmd, ['*', '�������� �����', '��������', '�������� ������� ��']) < 0 then Prm:=UpperArrayStr(Prm);

       If Cmd = '�������� ������� ��' then begin DecStr:=''; Result := FUDChange(Prm); Goto Ex; end;
//  If Cmd = '������� �� ����'   then begin DecStr:=FStatus(PUD, '', Prm);    Goto Ex; end;
//  If Cmd = '���� �� ����'      then begin DecStr:=FMery(PUD, '', Prm);      Goto Ex; end;
       If Cmd = '������ ����'        then begin DecStr:=GetArticles;  Goto Ex; end;
//  If Cmd = '������� �������'   then begin FSelectElement(Prm);              Goto Ex; end;

    {��������� �������}
    // If SetDecoderTable(Cmd) then begin DecStr:='';                         Goto Ex; end; - ����� ������� ������
    If PUD = nil then Exit;

    {��������� ��������� �� ������/����� ��������� �������}
//    If FScrollTable(@TUD, Cmd) then begin DecStr:='';                       Goto Ex; end;
    If Cmd='COUNT' then begin DecStr:=IntToStr(PUD^.RecordCount);             Goto Ex; end;

       S:=GetPrm(Prm, 0);


       {=======================================================================}
       {=================   ������� �������� ����������������   ===============}
       {=======================================================================}
       If PUD^.RecordCount=0 then Exit;

       {***********************************************************************}
       {*******************  �������: T_UD_PPERSON      ***********************}
       {***********************************************************************}
       If CmpStr(PUD^.TableName, T_UD_PPERSON) then begin
          If Cmd = '*'                  then begin DecStr:=FSexText(Prm);     Goto Ex; end;
          If Cmd = '���'                then begin DecStr:=FFIOPP(S);         Goto Ex; end;
          If Cmd = '������'             then begin DecStr:=FStatus(S);        Goto Ex; end;
          If Cmd = '������ �������'     then begin DecStr:=FStatus(S, true);  Goto Ex; end;
          If Cmd = '�����'              then begin DecStr:=FAdressPP(S);      Goto Ex; end;
          If Cmd = '��������'           then begin DecStr:=FRogdeniePP(S);    Goto Ex; end;
          If Cmd = '��������'           then begin DecStr:=FDocumentPP(S);    Goto Ex; end;
          If Cmd = '�������'            then begin DecStr:=FVozrastPP(S);     Goto Ex; end;
       end;


       {***********************************************************************}
       {*******************  �������: T_UD_LPERSON      ***********************}
       {***********************************************************************}
       If CmpStr(PUD^.TableName, T_UD_LPERSON) then begin
          If Cmd = '������������'       then begin DecStr:=NameLP(S);         Goto Ex; end;
          If Cmd = '������������ ����'  then begin DecStr:=NameShortLP(S);    Goto Ex; end;
          If Cmd = '������'             then begin DecStr:=FStatus(S, true);  Goto Ex; end;
          If Cmd = '������������'       then begin DecStr:=FFIOSherifLP(S);   Goto Ex; end;
       end;


       {***********************************************************************}
       {********************  �������: T_UD_DPERSON      **********************}
       {***********************************************************************}
       If CmpStr(PUD^.TableName, T_UD_DPERSON) then begin
          If Cmd = '*'                  then begin DecStr:=FSexText(Prm);     Goto Ex; end;
          If Cmd = '���'                then begin DecStr:=FFIODP(S);         Goto Ex; end;
          If Cmd = '������'             then begin DecStr:=FStatus(S);        Goto Ex; end;
          If Cmd = '������ �������'     then begin DecStr:=FStatus(S, true);  Goto Ex; end;
          If Cmd = '��������'           then begin DecStr:=FDocumentDP(S);    Goto Ex; end;
      end;

       {***********************************************************************}
       {********************  �������: T_UD_OBJECT       **********************}
       {***********************************************************************}
       If CmpStr(PUD^.TableName, T_UD_OBJECT) then begin
          If Cmd = '��������'           then begin DecStr:=FObjectsPack(S);   Goto Ex; end;
       end;

       If IsField(Cmd)                  then begin DecStr:=ReadField(Cmd, S); Goto Ex; end;
       If Cmd = '�������'               then begin DecStr:=PUD^.TableName;    Goto Ex; end;
       If Cmd = '������������� �������' then begin FEditElement;              Goto Ex; end;
       Exit;

Ex:    Result:=true;
    finally
       SetLength(Prm,  0);
    end;
end;


{==============================================================================}
{====================  ������������� ������� ��������  ========================}
{==============================================================================}
function TDECOD.SetDecoderTable(const TName: String): Boolean;
begin
    Case FindStrInArray(TName, LTAB_UD) of
    LTAB_UD_PPERSON: PUD := @TPPERSON;
    LTAB_UD_LPERSON: PUD := @TLPERSON;
    LTAB_UD_DPERSON: PUD := @TDPERSON;
    LTAB_UD_OBJECT:  PUD := @TOBJECT;
    else PUD := nil;
    end;
    Result := PUD <> nil;
//    If Result then begin
//       PUD^.Filtered := false;
//       PUD^.Filter   := '';
//    end;
end;


{==============================================================================}
{==============     ������������� ������ ������� ��������     =================}
{==============================================================================}
{==============    Result=true - ����� ����������� 1 ������   =================}
{==============================================================================}
function TDECOD.SetDecoderKey(const Key: String): Boolean;
begin
    {�������������}
    Result := false;
    If not IsIntegerStr(Key) then Exit;
    If PUD = nil             then Exit;

    {���������� �� ������}
    SetDBFilter(PUD, '['+F_COUNTER+']='+Key);
    Result := (PUD^.RecordCount = 1);
    PUD^.First;
end;


{==============================================================================}
{=================  �������� �� TABLE ��������� ������� ��  ===================}
{==============================================================================}
function TDECOD.IsTableUD(const Table: String): Boolean;
begin
    Result := IsStrInArray(Table, LTAB_UD);
end;


{==============================================================================}
{==========   �������: �������� �������� ��, �������� ����������    ===========}
{==============================================================================}
{==========   1-� ��������  : ���������� ��                         ===========}
{==========   2-� ��������  : ����                                  ===========}
{==========   3-� ��������  : ��������                              ===========}
(*=========  '|+' ������ �� '{', '|-' ������ �� '}'                 ==========*)
{==============================================================================}
function TDECOD.FUDChange(const Prm: TArrayStr): Boolean;
var SVar, SFld, SVal : String;
    STab, SKey : String;
    P : PADOTable;
    T : TADOTable;
    I : Integer;
    L : TStringList;
begin
    {�������������}
    Result := false;
    If Length(Prm) < 3 then Exit;

    {��������� ����������}
    SVar := Trim(Prm[Low(Prm)+0]);    If SVar = '' then Exit;
    SFld := Trim(Prm[Low(Prm)+1]);    If SFld = '' then Exit;
    SVal := Trim(Prm[Low(Prm)+2]);    If SVal = '' then Exit;
    SVal := ReplStr(SVal, '|+', '{');
    SVal := ReplStr(SVal, '|-', '}');
    P    := VarFind(SVar);            If P = nil   then Exit;

    T    := TADOTable.Create(nil);
    L    := TStringList.Create;
    try
       T.Connection := FFMAIN.BUD.BD;
       L.Text := P^.FieldbyName(F_VAR_VAL_STR).AsString; If L.Count = 0 then Exit;

       {������������� ��� ������ �� ��}
       For I := 0 to L.Count-1 do begin
          STab := CutSlovo(L[I], 1, '.');        If STab = '' then Continue;
          SKey := CutSlovoEndChar(L[I], 1, '.'); If SKey = '' then Continue;

          T.TableName := STab;
          SetDBFilter(@T, '['+F_COUNTER+']='+SKey);
          With T do begin
             Open;
             If RecordCount <> 1 then begin Close; Continue; end;
             Edit;
             FieldByName(SFld).AsString := SVal;
             UpdateRecord;
             Post;
             Close;
          end;
       end;
       Result := true;
    finally
       L.Free;
       DestrTable(@T);
       If PUD <> nil then PUD^.Refresh;
    end;
end;

