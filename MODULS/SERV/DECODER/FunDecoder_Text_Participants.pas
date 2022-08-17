{==============================================================================}
{====================     ������: ������ ����������     =======================}
{==============================================================================}
function TDECOD.FMacroParticipantsList: String;
var I, ICount : Integer;

    function SetBlock1(const I: Integer): String;
    var Str1, Str2, Str3, Str4 : String;
    begin
        {�������������}
        Result := '';

        {������}
        Str1 := AnsiLowerCase(DecodErr('{'+F_VAR_NAME_PART+'('+T_UD_DPERSON+', '+IntToStr(I)+').'+DPERSON_STATE+'.������(�)}'));
        If Str1='' then Exit;

        {���}
        Str2 := DecodErr('{���(�)}');
        If Str2='' then Exit;

        {��������}
        Str3 := DecodErr(', ������������{*(��,�)}');
        If Str3='' then Exit;

        Str4 := DecodErr('{��������()}');
        If Str4<>'' then Str4 := Str3+' '+Str4;

        {������+���+��������}
        Result := Str1+' '+Str2+Str4+', ';
    end;

    function SetBlock2(const Ind: Integer): String;
    var Str1, Str2, Str3: String;
    begin
        {�������������}
        Result := '';

        {������}
        Str1 := DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', ������)}');
        Str1 := PadegAUTO('�', Str1);
        If Str1='' then Exit;

        {���}
        Str2 := DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', ���)}');
        Str2 := PadegFIO('�', Str2);
        If Str2='' then Str2:='________________________';

        Str3 := DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', �����)}');
        If Str3<>'' then Str3:=' ('+Str3+')';

        {������+���+�����}
        Result := Str1+' '+Str2+Str3+', ';
    end;

begin
    {�������������}
    Result := '';

    {���������}
    ICount := CountPart;
    For I := 1 to ICount do Result := Result + SetBlock1(I);

    {��������������}
    ICount := CountRest;
    For I := 1 to ICount do Result := Result + SetBlock2(I);

    {��������� ����������}
    If Result <> '' then Result := '� �������� ' + Result;
end;


{==============================================================================}
{===================      ������: ����� ����������     ========================}
{==============================================================================}
function TDECOD.FMacroParticipantsRights(const Prm: TArrayStr): String;
var S, SPref  : String;
    I, ICount : Integer;
    IsFirstUp : Boolean;

    function SetBlock1(const Ind: Integer): String;
    var SFIO, Stat0, Stat, SRight: String;
    begin
        {�������������}
        Result := '';
        Stat0  := AnsiLowerCase(DecodErr('{'+F_VAR_NAME_PART+'('+T_UD_DPERSON+', '+IntToStr(Ind)+').'+DPERSON_STATE+'}'));
        If Stat0='' then Exit;

        {�����}
        SRight:=DecodErr('{'+F_VAR_NAME_REST0_PREF+Stat0+'}');
        If SRight='' then Exit;

        {�������, ��������}
        SFIO := DecodErr('{���(�).��������}');
        If SFIO='' then Exit;

        {C�����}
        Stat:=FStatus('�');
        If IsFirstUp then Stat:=MyCharUpper(Stat, ['1']);
        If Stat='' then Exit;

        {������������ ���������}
        Result:=SPref+Stat+' '+SFIO+' ���������� ����� � �����������, ��������������� '+SRight+CH_NEW;

        {�������, ��������}
        SFIO := DecodErr('{���(�).��������(-)}');

        {������������ ������}
        Stat:=MyCharUpper(Stat0, ['1']);
        If Stat='' then Exit;

        {������������ ���������}
        Result:=Result+CH_NEW+Stat+SpaceStat(Stat)+'__________________ '+SFIO+CH_NEW+CH_NEW;
    end;


    function SetBlock2(const Ind: Integer): String;
    var SFIO0, SFIO, Stat0, Stat, SRight: String;
    begin
        {�������������}
        Result:='';
        Stat0:=DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', ������)}');
        Stat0:=AnsiLowerCase(Stat0);
        If Stat0='' then Exit;

        {�����}
        SRight:=DecodErr('{'+F_VAR_NAME_REST0_PREF+Stat0+'}');
        If SRight='' then Exit;

        {������������ ������}
        Stat:=PadegAUTO('�', Stat0);
        If IsFirstUp then Stat:=MyCharUpper(Stat, ['1']);
        If Stat='' then Exit;

        {�������, ��������}
        SFIO0 := DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', ���)}');
        SFIO  := FIO_Initialy(PadegFIO('�', SFIO0), true);
        If SFIO='' then SFIO:='____________________';

        {������������ ���������}
        Result:=SPref+Stat+' '+SFIO+' ���������� ����� � �����������, ��������������� '+SRight+CH_NEW;

        {�������, ��������}
        SFIO  := FIO_Initialy(SFIO0, false);
        If SFIO='' then SFIO:='(____________________)';

        {������������ ������}
        Stat:=MyCharUpper(Stat0, ['1']);

        {������������ ���������}
        Result:=Result+CH_NEW+Stat+SpaceStat(Stat)+'__________________ '+SFIO+CH_NEW+CH_NEW;
    end;

begin
    {�������������}
    IsFirstUp:=true;
    If Prm<>nil then begin
       If Length(Prm)>0 then SPref:=Prm[Low(Prm)];
       S:=ReplStr(SPref, ' ',     '');
       S:=ReplStr(S,       Chr(13), '');
       S:=ReplStr(S,       Chr(10), '');
       IsFirstUp := (S='');
    end else begin
       SPref     := '';
    end;

    {���������}
    ICount := CountPart;
    For I := 1 to ICount do Result := Result + SetBlock1(I);

    {��������������}
    ICount := CountRest;
    For I := 1 to ICount do Result := Result + SetBlock2(I);
end;


{==============================================================================}
{===================     ������: ������� ����������    ========================}
{==============================================================================}
function TDECOD.FMacroParticipantsSign: String;
var I, ICount : Integer;

    function SetBlock1(const Ind: Integer): String;
    var SFIO, Stat: String;
    begin
        {�������������}
        Result:='';

        {������}
        Stat := MyCharUpper(AnsiLowerCase(DecodErr('{'+F_VAR_NAME_PART+'('+T_UD_DPERSON+', '+IntToStr(Ind)+').'+DPERSON_STATE+'}')), ['1']);
        If Stat='' then Exit;

        {���}
        SFIO := DecodErr('{���(�).��������(-)}');
        If SFIO='' then Exit;

        Result:=Stat+SpaceStat(Stat)+'__________________ '+SFIO+CH_NEW+CH_NEW;
    end;

    function SetBlock2(const Ind: Integer): String;
    var SFIO, Stat: String;
    begin
        {�������������}
        Result:='';

        {������}
        Stat:=DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', ������)}');
        Stat:=MyCharUpper(AnsiLowerCase(Stat), ['1']);
        If Stat='' then Exit;

        {���}
        SFIO := DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', ���)}');
        SFIO := FIO_Initialy(SFIO, false);
        If SFIO='' then SFIO:='(____________________)';

        Result:=Stat+SpaceStat(Stat)+'__________________ '+SFIO+CH_NEW+CH_NEW;
    end;

begin
    {���������}
    ICount := CountPart;
    For I := 1 to ICount do Result := Result + SetBlock1(I);

    {��������������}
    ICount := CountRest;
    For I:=1 to ICount do Result:=Result+SetBlock2(I);

    {��������� ����������}
    If Result <> '' then Result := CH_NEW+Result;
end;


{==============================================================================}
{=======================   ��������������� �������    =========================}
{==============================================================================}
function TDECOD.DecodErr(const S: String): String;
begin
    try Result := Decoder(S); finally end;
    If Err then begin Err := false; Result := ''; end;
end;

{���������� ����������}
function TDECOD.CountPart: Integer;
var L: TStringlist;
begin
    Result := 0;
    L      := TStringlist.Create;
    try     L.Text := DecodErr('{�������� ����������('+F_VAR_NAME_PART+')}');
            Result := L.Count;
    finally L.Free; end;
end;

{���������� ��������������}
function TDECOD.CountRest: Integer;
var L: TStringlist;
begin
    Result := 0;
    L      := TStringlist.Create;
    try     L.Text := DecodErr('{�������� ����������('+F_VAR_NAME_REST+')}');
            Result := L.Count Div 3;
    finally L.Free; end;
end;

{������� �������� ��������}
function TDECOD.SpaceStat(const Stat: String): String;
var I: Integer;
begin
    Result := ' ';
    For I := (Length(Stat)*2) to 41 do Result := Result + ' ';
end;


