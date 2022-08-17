{******************************************************************************}
{***************           �������� � ��������� ��           ******************}
{***************               ����������� ����              ******************}
{******************************************************************************}


{==============================================================================}
{===========  ������� ��������: ������ ������������ �����������  ==============}
{==============================================================================}
function TDECOD.NameLP(const S: String): String;
begin
    Result:='';
    If (S='�') or (S='')
             then Result:=PUD^.FieldByName(LPERSON_NAME).AsString    else
    If S='�' then Result:=PUD^.FieldByName(LPERSON_NAME_RP).AsString else
    If S='�' then Result:=PUD^.FieldByName(LPERSON_NAME_DP).AsString else
    If S='�' then Result:=PUD^.FieldByName(LPERSON_NAME_VP).AsString else
    If S='�' then Result:=PUD^.FieldByName(LPERSON_NAME_TP).AsString else
    If S='�' then Result:=PUD^.FieldByName(LPERSON_NAME_PP).AsString;

    If Result='' then Result:=PUD^.FieldByName(LPERSON_NAME).AsString;
    If Result='' then Result:='_________________________________________';
end;


{==============================================================================}
{=========  ������� ��������: ����������� ������������ �����������  ===========}
{==============================================================================}
function TDECOD.NameShortLP(const S: String): String;
var SVal: String;
begin
    {�������������}
    Result := '';
    SVal   := PUD^.FieldByName(LPERSON_NAME_SHORT).AsString;
    If (S='�') or (S='') then Result:=SVal else Result:=PadegAUTO(S, SVal);
    If Result='' then Result:=SVal;
    If Result='' then Result:='_____________________________';
end;


{==============================================================================}
{==============  �������: �������, ���, �������� ������������  ================}
{==============================================================================}
function TDECOD.FFIOSherifLP(const S: String): String;
var SVal: String;
begin
    {�������������}
    Result := '';
    SVal   := PUD^.FieldByName(LPERSON_BOSS).AsString;
    If (S='�') or (S='') then Result:=SVal else Result:=PadegAUTO(S, SVal);
    If Result='' then Result:=SVal;
    If Result='' then Result:='_________________________________________';
end;
