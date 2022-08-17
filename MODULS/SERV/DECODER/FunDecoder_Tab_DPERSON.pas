{******************************************************************************}
{***************           �������� � ��������� ��           ******************}
{***************             �������������� ����             ******************}
{******************************************************************************}


{==============================================================================}
{==================  ������� ��������: �������, ���, ��������  ================}
{==============================================================================}
function TDECOD.FFIODP(const S: String): String;
begin
    Result:='';
    If (S='�')or(S='')
             then Result:=PUD^.FieldByName(DPERSON_FIO).AsString    else
    If S='�' then Result:=PUD^.FieldByName(DPERSON_FIO_RP).AsString else
    If S='�' then Result:=PUD^.FieldByName(DPERSON_FIO_DP).AsString else
    If S='�' then Result:=PUD^.FieldByName(DPERSON_FIO_VP).AsString else
    If S='�' then Result:=PUD^.FieldByName(DPERSON_FIO_TP).AsString else
    If S='�' then Result:=PUD^.FieldByName(DPERSON_FIO_PP).AsString;

    If Result='' then Result:=PUD^.FieldByName(DPERSON_FIO).AsString;
    If Result='' then Result:='_________________________________________';
end;


{==============================================================================}
{=====================  ������� ��������: ��������  ===========================}
{==============================================================================}
function TDECOD.FDocumentDP(const S: String): String;
var S0,S1: String;
begin
    {������������}
    Result:='';

    If (S='��') or (S='') then begin
       {----- ��� ��������� ---------------------------------------------------}
       Result:=PUD^.FieldByName(DPERSON_DOC_TYPE).AsString;
       If Result<>'' then Result:=Result+':';
       {----- ����� ��������� -------------------------------------------------}
       S0:=PUD^.FieldByName(DPERSON_DOC_NOMER).AsString;
       If S0<>'' then begin
          If Result<>'' then Result:=Result+' ';
          Result:=Result+S0;
       end;
       {----- ��� ����� + ���� ������ -----------------------------------------}
       S0:=PadegAUTO('�', PUD^.FieldByName(DPERSON_DOC_PLACE).AsString);
       S1:=SDateToStr(DateToStr(PUD^.FieldByName(DPERSON_DOC_DATE).AsDateTime),'');
       If (S0<>'') or (S1<>'') then begin
          If Result<>'' then Result:=Result+' ';
          Result:=Result+'���.';
          If S0<>'' then Result:=Result+' '+S0;
          If S1<>'' then Result:=Result+' '+S1+' �.';
       end;
    end;

    If S='������' then begin
       {----- ��� ��������� ---------------------------------------------------}
       S0:=PUD^.FieldByName(DPERSON_DOC_TYPE).AsString;
       If S0='' then S0:= '__________';
       Result:=S0+':';
       {----- ����� ��������� -------------------------------------------------}
       S0:=PUD^.FieldByName(DPERSON_DOC_NOMER).AsString;
       If S0='' then S0:='________';
       Result:=Result+S0;
       {----- ��� ����� + ���� ������ -----------------------------------------}
       S0:=PadegAUTO('�', PUD^.FieldByName(DPERSON_DOC_PLACE).AsString);
       S1:=SDateToStr(DateToStr(PUD^.FieldByName(DPERSON_DOC_DATE).AsDateTime),'');
       If S0='' then S0:='___________________';
       If S1='' then S1:='''___'' ___________ _____';
       Result:=Result+' ���. '+S0+' '+S1+' �.';
    end;
end;

