{******************************************************************************}
{***************           �������� � ��������� ��           ******************}
{***************               ���������� ����               ******************}
{******************************************************************************}


{==============================================================================}
{=================  ������� ��������: �������, ���, ��������  =================}
{==============================================================================}
function TDECOD.FFIOPP(const S: String): String;
begin
    Result:='';
    If(S='�') or (S='')
             then Result:=PUD^.FieldByName(PPERSON_FIO).AsString    else
    If S='�' then Result:=PUD^.FieldByName(PPERSON_FIO_RP).AsString else
    If S='�' then Result:=PUD^.FieldByName(PPERSON_FIO_DP).AsString else
    If S='�' then Result:=PUD^.FieldByName(PPERSON_FIO_VP).AsString else
    If S='�' then Result:=PUD^.FieldByName(PPERSON_FIO_TP).AsString else
    If S='�' then Result:=PUD^.FieldByName(PPERSON_FIO_PP).AsString else
    If S='0' then begin Result:=PUD^.FieldByName(PPERSON_FIO_OLD).AsString; Exit; end;

    If Result='' then Result:=PUD^.FieldByName(PPERSON_FIO).AsString;
    If Result='' then Result:='_________________________________________';
end;


{==============================================================================}
{========================  ������� ��������: �����  ===========================}
{==============================================================================}
function TDECOD.FAdressPP(const S: String): String;
var S0: String;
begin
    Result:='';

    {����� ����� ����������}
    If (S='��') or (S='') then begin
       S0:=Trim(PUD^.FieldByName(PPERSON_LIV_PLACE).AsString);
       If S0<>'' then begin Result:=S0; Exit; end;
    end;

    {����� ����� �����������}
    If S='���' then begin
       S0:=Trim(PUD^.FieldByName(PPERSON_REG_PLACE).AsString);
       If S0<>'' then Result:=S0;
    end;

    If Result='' then Result:='______________________________________';
end;


{==============================================================================}
{=======================  ������� ��������: ��������  =========================}
{==============================================================================}
function TDECOD.FRogdeniePP(const S: String): String;
var S0: String;
begin
    Result:='';

    If (S='�����') or (S='') then begin
       S0:=PUD^.FieldByName(PPERSON_BORN_PLACE).AsString;
       If S0 <> '' then Result:=S0 else Result:='_________________________________________';
       Exit;
    end;

    If S='����' then begin
       S0 := DateToStr(PUD^.FieldByName(PPERSON_BORN_DATE).AsDateTime);
       If S0 <> '' then Result:=S0 else Result:='__.__.____';
    end;
end;


{==============================================================================}
{=====================  ������� ��������: ��������  ===========================}
{==============================================================================}
function TDECOD.FDocumentPP(const S: String): String;
var S0,S1: String;
begin
    {������������}
    Result:='';

    If (S='��') or (S='') then begin
       {----- ��� ��������� ---------------------------------------------------}
       Result:=PUD^.FieldByName(PPERSON_DOC_TYPE).AsString;
       If Result<>'' then Result:=Result+':';
       {----- ����� ��������� -------------------------------------------------}
       S0:=PUD^.FieldByName(PPERSON_DOC_NOMER).AsString;
       If S0<>'' then begin
          If Result<>'' then Result:=Result+' ';
          Result:=Result+S0;
       end;
       {----- ��� ����� + ���� ������ -----------------------------------------}
       S0:=PadegAUTO('�', PUD^.FieldByName(PPERSON_DOC_PLACE).AsString);
       S1:=SDateToStr(DateToStr(PUD^.FieldByName(PPERSON_DOC_DATE).AsDateTime),'');
       If (S0<>'') or (S1<>'') then begin
          If Result<>'' then Result:=Result+' ';
          Result:=Result+'���.';
          If S0<>'' then Result:=Result+' '+S0;
          If S1<>'' then Result:=Result+' '+S1+' �.';
       end;
       {----- ������ ����� ----------------------------------------------------}
       S0:=PUD^.FieldByName(PPERSON_PERSNOMER).AsString;
       If S0<>'' then begin
          If Result<>'' then Result:=Result+', ';
          Result:=Result+'������ �����: '+S0;
       end;
    end;

    If S='������' then begin
       {----- ��� ��������� ---------------------------------------------------}
       S0:=PUD^.FieldByName(PPERSON_DOC_TYPE).AsString;
       If S0='' then S0:= '__________';
       Result:=S0+':';
       {----- ����� ��������� -------------------------------------------------}
       S0:=PUD^.FieldByName(PPERSON_DOC_NOMER).AsString;
       If S0='' then S0:='________';
       Result:=Result+S0;
       {----- ��� ����� + ���� ������ -----------------------------------------}
       S0:=PadegAUTO('�', PUD^.FieldByName(PPERSON_DOC_PLACE).AsString);
       S1:=SDateToStr(DateToStr(PUD^.FieldByName(PPERSON_DOC_DATE).AsDateTime),'');
       If S0='' then S0:='___________________';
       If S1='' then S1:='''___'' ___________ _____';
       Result:=Result+' ���. '+S0+' '+S1+' �.';
       {----- ������ ����� ----------------------------------------------------}
       S0:=PUD^.FieldByName(PPERSON_PERSNOMER).AsString;
       If S0='' then S0:='______________';
       Result:=Result+', ������ �����: '+S0;
    end;
end;


{==============================================================================}
{=====================    ������� ��������: �������     =======================}
{==============================================================================}
{=====================  S = 14, 16, [18], 70 � �.�.     =======================}
{=====================  ������� = TRUE ��� FALSE        =======================}
{==============================================================================}
function TDECOD.FVozrastPP(const S: String): String;
var Year, Mounth, Day, Hour: Integer;
    S0 : String;
begin
    {������������}
    Result := 'FALSE';
    If S='' then S0:='18' else S0:=S;
    If Not IsIntegerStr(S0) then Exit;
    DateTimeDiff0(PUD^.FieldByName(PPERSON_BORN_DATE).AsDateTime, Now, Hour, Day, Mounth, Year);
    If Year<0 then Exit;

    Result:=AnsiUpperCase(BoolToStrMy(Year>=StrToInt(S0)));
end;

