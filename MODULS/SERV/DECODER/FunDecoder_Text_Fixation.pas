{==============================================================================}
{================   ������: ����������� � ���������� ������   =================}
{==============================================================================}
function TDECOD.FMacroMediaInform(const Prm: TArrayStr): String;
var S, SPref, SMedia, SRight : String;
    IsFirstUp, B1, B2, B3    : Boolean;
    ICount                   : Integer;

begin
    {�������������}
    Result    := '';
    IsFirstUp := true;
    If Prm<>nil then begin
       If Length(Prm)>0 then SPref:=Prm[Low(Prm)];
       S:=ReplStr(SPref, ' ',     '');
       S:=ReplStr(S,     Chr(13), '');
       S:=ReplStr(S,     Chr(10), '');
       IsFirstUp := (S='');
    end else begin
       SPref     := '';
    end;

    {������ �������� �����-����������}
    SMedia:=DecodErr('{�������� ����������('+F_VAR_NAME_FIXATION+')}');
    If SMedia='' then Exit;
    ICount:=0;
    B1 := FindStr(F_VAR_VAL_STR_FIXATION_VIDEO, SMedia) > 0; If B1 then Inc(ICount);
    B2 := FindStr(F_VAR_VAL_STR_FIXATION_AUDIO, SMedia) > 0; If B2 then Inc(ICount);
    B3 := FindStr(F_VAR_VAL_STR_FIXATION_PHOTO, SMedia) > 0; If B3 then Inc(ICount);
    If ICount=0 then Exit;

    {������ �������� ������ ���}
    SRight := DecodErr('{�������� ����������('+F_VAR_NAME_NOTICE+')}');
    If SRight = '' then Exit;

    {��������� ���������}
    Result:='��� ��������� ������������� �������� ���������� � ���������� � ������������ �� ';
    If IsFirstUp then Result:=MyCharUpper(Result, ['1']);
    Result:=SPref+Result+SRight+' ';

    If B1 then Result:=Result+'�����������, ';
    If B2 then Result:=Result+'�����������, ';
    If B3 then Result:=Result+'����������, ';

    If ICount=1 then Result:=Result+'��������������' else Result:=Result+'��������������';

    Result:=Result+' � ������� ______________________________.'+CH_NEW+CH_NEW+
    '________________________________________________________'+CH_NEW+CH_NEW+CH_NEW;
end;


{==============================================================================}
{=============   ������: ����������� � ��������������� ������   ===============}
{==============================================================================}
function TDECOD.FMacroMediaShow(const Prm: TArrayStr): String;
var S, SPref, SMedia      : String;
    IsFirstUp, B1, B2, B3 : Boolean;
    ICount                : Integer;
begin
    {�������������}
    Result    := '';
    IsFirstUp := true;
    If Prm<>nil then begin
       If Length(Prm)>0 then SPref:=Prm[Low(Prm)];
       S:=ReplStr(SPref, ' ',     '');
       S:=ReplStr(S,     Chr(13), '');
       S:=ReplStr(S,     Chr(10), '');
       IsFirstUp := (S='');
    end else begin
       SPref     := '';
    end;

    {������ �������� �����-����������}
    SMedia:=DecodErr('{�������� ����������('+F_VAR_NAME_FIXATION+')}');
    If SMedia='' then Exit;
    ICount:=0;
    B1 := FindStr(F_VAR_VAL_STR_FIXATION_VIDEO, SMedia) > 0; If B1 then Inc(ICount);
    B2 := FindStr(F_VAR_VAL_STR_FIXATION_AUDIO, SMedia) > 0; If B2 then Inc(ICount);
    B3 := FindStr(F_VAR_VAL_STR_FIXATION_PHOTO, SMedia) > 0; If B3 then Inc(ICount);
    If ICount=0 then Exit;

    {��������� ���������}
    Result:='���������� ';
    If IsFirstUp then Result:=MyCharUpper(Result, ['1']);
    Result:=SPref+Result;

    If B1 then Result:=Result+'��������������, ';
    If B2 then Result:=Result+'��������������, ';
    If B3 then Result:=Result+'�������������, ';
    Delete(Result, Length(Result)-1, 2);

    Result:=Result+' ������������������ ���� ���������� ������������� ��������.'+CH_NEW+CH_NEW;
end;
