{==============================================================================}
{=============        Д Е К О Д Е Р     П А К Е Т А     I F      ==============}
{==============================================================================}
{=============          DecStr = IF ... THEN ... ELSE ...        ==============}
{==============================================================================}
function TDECOD.DecoderPackIF(const DecStr: String): String;
var S,S1,S2,S3 : String;
    I          : Integer;
begin
    {Инициализация}
    Result:='';
    S:=DecStr;    //S:=Trim(DecStr);

    {Проверяем, что команда IF}
    If not CmpStr(Copy(S, 1, Length('IF ')), 'IF ') then Exit;

    {Выделяем условие S3}
    Delete(S, 1, Length('IF '));
    I  := InStrIf(1, S, ' THEN ');
    If I<1 then Exit;
    S3 := Copy(S, 1, I-1);  // S3 := CutSpace(Copy(S, 1, I-1));
    Delete(S, 1, I+Length(' THEN ')-1);

    {Выделяем варианты значений S1 и S2}
    I:=InStrIf(1, S, ' ELSE ');
    If I>0 then begin
       S2:=Copy(S, I+Length(' ELSE '), Length(S));
       Delete(S, I, Length(S));
    end else S2:='';
    S1:=S;

    {Замена некоторых условностей}
    If S1=CH_KAV+CH_KAV then S1:='';
    If S2=CH_KAV+CH_KAV then S2:='';

    {Выбираем по условию S3 вариант S1 или S2}
    If DecoderCondOrg(S3) then Result:=S1 else Result:=S2;

    //{Обрезаем пробелы}
    //Result:=Trim(Result);
end;


{==============================================================================}
{====              ОРГАНИЗАТОР ДЕКОДИРОВАНИЯ И АНАЛИЗА УСЛОВИЯ             ====}
{==============================================================================}
(*===      DecStr =  {STR AND STR} AND {STR AND {STR AND STR}}    или      ===*)
(*===      DecStr = {{STR AND STR} AND {STR AND {STR AND STR}}}            ===*)
{==============================================================================}
function TDECOD.DecoderCondOrg(const DecStr: String): Boolean;
var S: String;
begin
    Result:=false;
    S:=Trim(DecStr);
    If Length(S)<2 then Exit;   //<4 не работало '1=1'

    {Декодируем условие: в скобки можно не брать}
    S:=Decoder('{'+S+'}');

    {Переводим String в Boolean}
    If CmpStr(S, 'TRUE')  then begin Result:=true;  Exit; end;
    If CmpStr(S, 'FALSE') then begin Result:=false; Exit; end;
end;


{==============================================================================}
{====                            АНАЛИЗ УСЛОВИЯ                            ====}
{==============================================================================}
(*===   DecStr = STR И STR                                                 ===*)
{====   Result = false - ошибка декодирования (не найден операнд)          ====}
{==============================================================================}
function TDECOD.DecoderCond(var DecStr: String): Boolean;
const Condit : array[1..10] of String=('<=', '>=', '<>', '<', '>', '=',
                                       ' AND ', ' OR ', ' XOR ', 'NOT ');
var S0, S1, S2 : String;
    B1, B2     : Boolean;
    I,  J      : Integer;

    {*** Разбивает строку на операнды *****************************************}
    function SeparatCond(const Str: String;
                         var Str1, Str2: String; var ICond: Integer): Boolean;
    var PsStr  : TStringList;
        S      : String;
        I0, J0 : Integer;
    begin
        {Инициализация}
        Result := false;
        S      := Str;
        Str1   := Str;
        Str2   := '';
        ICond  := -1;
        PsStr  := TStringList.Create;
        try
           {Заменяем в строке S блоки псевдо-операторами: |%N|%}
           S := ReplPsevdoModul(S, PsStr, CH_KAV, CH_KAV);
           S := ReplPsevdoModul(S, PsStr, '{', '}');
           S := ReplPsevdoModul(S, PsStr, '(', ')');

           {Просматриваем все условия}
           For I0:=Low(Condit) to High(Condit) do begin
              J0:=FindStr(Condit[I0], S);  
              If J0>0 then begin
                 ICond:=I0;
                 Break;
              end;
           end;

           {Условие не найдено}
           If ICond=-1 then Exit;

           {Вырезаем операнды}
           Str1:=Trim(Copy(S, 1, J0-1));
           Str2:=Trim(Copy(S, J0+Length(Condit[I0]), Length(S)));

           {Производим в слове обратную замену}
           For I0:=PsStr.Count-1 downto 0 do begin
              Str1:=ReplStr(Str1, PsStr.Names[I0], PsStr.Values[PsStr.Names[I0]]);
              Str2:=ReplStr(Str2, PsStr.Names[I0], PsStr.Values[PsStr.Names[I0]]);
           end;
        finally
           PsStr.Free;
        end;

        {Корректируем операнды}
        If Str1=CH_KAV+CH_KAV then Str1:='';
        If Str2=CH_KAV+CH_KAV then Str2:='';

        {Обрезаем возможные круглые скобки}
        If Length(S1)>1 then begin
           If (S1[1]='(') and (S1[Length(S1)]=')') then begin
              Delete(S1, 1, 1);
              Delete(S1, Length(S1), 1);
           end;
        end;
        If Length(S2)>1 then begin
           If (S2[1]='(') and (S2[Length(S2)]=')') then begin
              Delete(S2, 1, 1);
              Delete(S2, Length(S2), 1);
           end;
        end;

        Result:=true;
    end;
    
    {*** Основная функция *****************************************************}
begin
    {Инициализация}
    Result:=false;  B1:=false; B2:=false;

    {Если DecStr=true или DecStr=false}
    If CmpStrList(DecStr, ['TRUE', 'FALSE'])>=0 then begin
       Result:=true;
       Exit;
    end;

    {Вырезаем операнды}
    If not SeparatCond(DecStr, S1, S2, I) then Exit;

    {Организуем декодирование сложных логических операций путем рекурсии}
    For J:=Low(Condit) to High(Condit) do begin
       If FindStr(Condit[J], S2)>0 then begin
          DecoderCond(S2);
          Break;
       end;
    end;

    {Декодируем операнды}
    If CmpStrList(S1, ['TRUE', 'FALSE'])<0 then begin
       S0:=Decoder(S1);
       If S0<>'' then S1:=S0;
    end else B1:=StrToBoolMy(S1);
    If CmpStrList(S2, ['TRUE', 'FALSE'])<0 then begin
       S0:=Decoder(S2);
       If S0<>'' then S2:=S0;
    end else B2:=StrToBoolMy(S2);

    {Проверяем указанное условие}
    S1 := AnsiUpperCase(S1);
    S2 := AnsiUpperCase(S2);
    DecStr:='FALSE';
    Case I of
    1:  If S1<=S2    then DecStr:='TRUE';
    2:  If S1>=S2    then DecStr:='TRUE';
    3:  If S1<>S2    then DecStr:='TRUE';
    4:  If S1<S2     then DecStr:='TRUE';
    5:  If S1>S2     then DecStr:='TRUE';
    6:  If S1=S2     then DecStr:='TRUE';
    7:  If B1 and B2 then DecStr:='TRUE';
    8:  If B1 or  B2 then DecStr:='TRUE';
    9:  If B1 xor B2 then DecStr:='TRUE';
    10: If    not B2 then DecStr:='TRUE';
    end;

    {Возвращаемый результат}
    Result:=true;
end;

