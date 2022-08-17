{==============================================================================}
{====================     МАКРОС: СПИСОК УЧАСТНИКОВ     =======================}
{==============================================================================}
function TDECOD.FMacroParticipantsList: String;
var I, ICount : Integer;

    function SetBlock1(const I: Integer): String;
    var Str1, Str2, Str3, Str4 : String;
    begin
        {Инициализация}
        Result := '';

        {Статус}
        Str1 := AnsiLowerCase(DecodErr('{'+F_VAR_NAME_PART+'('+T_UD_DPERSON+', '+IntToStr(I)+').'+DPERSON_STATE+'.Статус(Р)}'));
        If Str1='' then Exit;

        {ФИО}
        Str2 := DecodErr('{ФИО(Р)}');
        If Str2='' then Exit;

        {Документ}
        Str3 := DecodErr(', представивше{*(го,й)}');
        If Str3='' then Exit;

        Str4 := DecodErr('{Документ()}');
        If Str4<>'' then Str4 := Str3+' '+Str4;

        {Статус+ФИО+Документ}
        Result := Str1+' '+Str2+Str4+', ';
    end;

    function SetBlock2(const Ind: Integer): String;
    var Str1, Str2, Str3: String;
    begin
        {Инициализация}
        Result := '';

        {Статус}
        Str1 := DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', Статус)}');
        Str1 := PadegAUTO('Р', Str1);
        If Str1='' then Exit;

        {ФИО}
        Str2 := DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', ФИО)}');
        Str2 := PadegFIO('Р', Str2);
        If Str2='' then Str2:='________________________';

        Str3 := DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', Место)}');
        If Str3<>'' then Str3:=' ('+Str3+')';

        {Статус+ФИО+Место}
        Result := Str1+' '+Str2+Str3+', ';
    end;

begin
    {Инициализация}
    Result := '';

    {Участники}
    ICount := CountPart;
    For I := 1 to ICount do Result := Result + SetBlock1(I);

    {Присутствующие}
    ICount := CountRest;
    For I := 1 to ICount do Result := Result + SetBlock2(I);

    {Коррекция результата}
    If Result <> '' then Result := 'с участием ' + Result;
end;


{==============================================================================}
{===================      МАКРОС: ПРАВА УЧАСТНИКОВ     ========================}
{==============================================================================}
function TDECOD.FMacroParticipantsRights(const Prm: TArrayStr): String;
var S, SPref  : String;
    I, ICount : Integer;
    IsFirstUp : Boolean;

    function SetBlock1(const Ind: Integer): String;
    var SFIO, Stat0, Stat, SRight: String;
    begin
        {Инициализация}
        Result := '';
        Stat0  := AnsiLowerCase(DecodErr('{'+F_VAR_NAME_PART+'('+T_UD_DPERSON+', '+IntToStr(Ind)+').'+DPERSON_STATE+'}'));
        If Stat0='' then Exit;

        {Права}
        SRight:=DecodErr('{'+F_VAR_NAME_REST0_PREF+Stat0+'}');
        If SRight='' then Exit;

        {Фамилия, инициалы}
        SFIO := DecodErr('{ФИО(Д).Инициалы}');
        If SFIO='' then Exit;

        {Cтатус}
        Stat:=FStatus('Д');
        If IsFirstUp then Stat:=MyCharUpper(Stat, ['1']);
        If Stat='' then Exit;

        {Возвращаемый результат}
        Result:=SPref+Stat+' '+SFIO+' разъяснены права и обязанности, предусмотренные '+SRight+CH_NEW;

        {Фамилия, инициалы}
        SFIO := DecodErr('{ФИО(И).Инициалы(-)}');

        {Корректируем статус}
        Stat:=MyCharUpper(Stat0, ['1']);
        If Stat='' then Exit;

        {Возвращаемый результат}
        Result:=Result+CH_NEW+Stat+SpaceStat(Stat)+'__________________ '+SFIO+CH_NEW+CH_NEW;
    end;


    function SetBlock2(const Ind: Integer): String;
    var SFIO0, SFIO, Stat0, Stat, SRight: String;
    begin
        {Инициализация}
        Result:='';
        Stat0:=DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', Статус)}');
        Stat0:=AnsiLowerCase(Stat0);
        If Stat0='' then Exit;

        {Права}
        SRight:=DecodErr('{'+F_VAR_NAME_REST0_PREF+Stat0+'}');
        If SRight='' then Exit;

        {Корректируем статус}
        Stat:=PadegAUTO('Д', Stat0);
        If IsFirstUp then Stat:=MyCharUpper(Stat, ['1']);
        If Stat='' then Exit;

        {Фамилия, инициалы}
        SFIO0 := DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', ФИО)}');
        SFIO  := FIO_Initialy(PadegFIO('Д', SFIO0), true);
        If SFIO='' then SFIO:='____________________';

        {Возвращаемый результат}
        Result:=SPref+Stat+' '+SFIO+' разъяснены права и обязанности, предусмотренные '+SRight+CH_NEW;

        {Фамилия, инициалы}
        SFIO  := FIO_Initialy(SFIO0, false);
        If SFIO='' then SFIO:='(____________________)';

        {Корректируем статус}
        Stat:=MyCharUpper(Stat0, ['1']);

        {Возвращаемый результат}
        Result:=Result+CH_NEW+Stat+SpaceStat(Stat)+'__________________ '+SFIO+CH_NEW+CH_NEW;
    end;

begin
    {Инициализация}
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

    {Участники}
    ICount := CountPart;
    For I := 1 to ICount do Result := Result + SetBlock1(I);

    {Присутствующие}
    ICount := CountRest;
    For I := 1 to ICount do Result := Result + SetBlock2(I);
end;


{==============================================================================}
{===================     МАКРОС: ПОДПИСИ УЧАСТНИКОВ    ========================}
{==============================================================================}
function TDECOD.FMacroParticipantsSign: String;
var I, ICount : Integer;

    function SetBlock1(const Ind: Integer): String;
    var SFIO, Stat: String;
    begin
        {Инициализация}
        Result:='';

        {Статус}
        Stat := MyCharUpper(AnsiLowerCase(DecodErr('{'+F_VAR_NAME_PART+'('+T_UD_DPERSON+', '+IntToStr(Ind)+').'+DPERSON_STATE+'}')), ['1']);
        If Stat='' then Exit;

        {ФИО}
        SFIO := DecodErr('{ФИО(И).Инициалы(-)}');
        If SFIO='' then Exit;

        Result:=Stat+SpaceStat(Stat)+'__________________ '+SFIO+CH_NEW+CH_NEW;
    end;

    function SetBlock2(const Ind: Integer): String;
    var SFIO, Stat: String;
    begin
        {Инициализация}
        Result:='';

        {Статус}
        Stat:=DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', Статус)}');
        Stat:=MyCharUpper(AnsiLowerCase(Stat), ['1']);
        If Stat='' then Exit;

        {ФИО}
        SFIO := DecodErr('{'+F_VAR_NAME_REST+'('+IntToStr(Ind)+', ФИО)}');
        SFIO := FIO_Initialy(SFIO, false);
        If SFIO='' then SFIO:='(____________________)';

        Result:=Stat+SpaceStat(Stat)+'__________________ '+SFIO+CH_NEW+CH_NEW;
    end;

begin
    {Участники}
    ICount := CountPart;
    For I := 1 to ICount do Result := Result + SetBlock1(I);

    {Присутствующие}
    ICount := CountRest;
    For I:=1 to ICount do Result:=Result+SetBlock2(I);

    {Коррекция результата}
    If Result <> '' then Result := CH_NEW+Result;
end;


{==============================================================================}
{=======================   ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ    =========================}
{==============================================================================}
function TDECOD.DecodErr(const S: String): String;
begin
    try Result := Decoder(S); finally end;
    If Err then begin Err := false; Result := ''; end;
end;

{Количество участников}
function TDECOD.CountPart: Integer;
var L: TStringlist;
begin
    Result := 0;
    L      := TStringlist.Create;
    try     L.Text := DecodErr('{Значение переменной('+F_VAR_NAME_PART+')}');
            Result := L.Count;
    finally L.Free; end;
end;

{Количество присутствующих}
function TDECOD.CountRest: Integer;
var L: TStringlist;
begin
    Result := 0;
    L      := TStringlist.Create;
    try     L.Text := DecodErr('{Значение переменной('+F_VAR_NAME_REST+')}');
            Result := L.Count Div 3;
    finally L.Free; end;
end;

{Сколько добавить пробелов}
function TDECOD.SpaceStat(const Stat: String): String;
var I: Integer;
begin
    Result := ' ';
    For I := (Length(Stat)*2) to 41 do Result := Result + ' ';
end;


