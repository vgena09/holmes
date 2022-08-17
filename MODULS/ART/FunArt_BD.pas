{******************************************************************************}
{*******************    РАБОТА С БАЗОЙ ДАННЫХ СТАТЕЙ  *************************}
{******************************************************************************}


{==============================================================================}
{===========        ЗАГОЛОВКИ ПЕРЕЧИСЛЕННЫХ НОРМ В СТРОКУ           ===========}
{==============================================================================}
{===========  SNorms  = 'пп.2,8 ч.2 ст.139, ч.2 ст.207, ... '       ===========}
{===========  DatStart, DatEnd - период                             ===========}
{===========  Возврат = Заголовки перечисленных норм в строку       ===========}
{===========            Если заголовков несколько, то через ' / '   ===========}
{==============================================================================}
function GetUKCaption(const PBD: PADOConnection; const SNorms: String;
                      const DatStart, DatEnd : TDate): String;
var Q : TADOQuery;
begin
    {Инициализация}
    Result:='';
    If PBD=nil then Exit;
    If not PBD^.Connected then Exit;

    Q := TADOQuery.Create(nil);
    try
       {Делаем выборку}
       Q.Connection := PBD^;
       If not SetUKQuery(@Q, SNorms, DatStart, DatEnd) then Exit;

       {Просматриваем выборку}
       While not Q.Eof do begin
          Result := Result + LSEPARATOR + UKCutNorm(Q.FieldByName(UK_NORM).AsString);
          Q.Next;
       end;
       Delete(Result, 1, Length(LSEPARATOR));
    finally
       If Q.Active then Q.Close; Q.Free;
    end;
end;


{==============================================================================}
{===========         САНКЦИИ ПЕРЕЧИСЛЕННЫХ НОРМ В СПИСОК            ===========}
{==============================================================================}
{===========  SNorms  = 'пп.2,8 ч.2 ст.139, ч.2 ст.207, ... '       ===========}
{===========  DatStart, DatEnd - период                             ===========}
{===========  Возврат = Заголовки перечисленных норм в строку       ===========}
{===========            Если заголовков несколько, то через ' / '   ===========}
{==============================================================================}
function GetUKSanction(const PBD: PADOConnection; const SNorms: String;
                       const DatStart, DatEnd : TDate): TStringList;
var Q : TADOQuery;
begin
    {Инициализация}
    Result := TStringList.Create;
    If PBD=nil then Exit;
    If not PBD^.Connected then Exit;

    Q := TADOQuery.Create(nil);
    try
       {Делаем выборку}
       Q.Connection := PBD^;
       If not SetUKQuery(@Q, SNorms, DatStart, DatEnd) then Exit;
       {Просматриваем выборку}
       While not Q.Eof do begin
          Result.Add(UKCutSanction(Q.FieldByName(UK_NORM).AsString));
          Q.Next;
       end;
    finally
       If Q.Active then Q.Close; Q.Free;
    end;
end;



{******************************************************************************}
{*******************     ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ    ***************************}
{******************************************************************************}


{==============================================================================}
{============               ЗАПРОС СО СПИСКОМ НОРМ УК              ============}
{==============================================================================}
{============  SNorms  = 'пп.2,8 ч.2 ст.139, ч.2 ст.207, ... '     ============}
{==============================================================================}
function SetUKQuery(const P: PADOQuery; const SNorms: String;
                    const DatStart, DatEnd: TDate): Boolean;
var Lst1    : TStringList;
    S, SArticl : String;
    I       : Integer;
begin
    {Инициализация}
    Result := false;
    If not P^.Connection.Connected then Exit;
    If P^.Active then P^.Close; P^.SQL.Clear;
    Lst1 := nil;
    try
       {Разбиваем статьи на составляющие в формат Access без покушений и приготовлений}
       {Вход:  пп.2,5 ч.2 ст.139, ч.1 ст.139, пп.2,7 ч.2 ст.139}
       {Выход: [139 1, 139 2 2, 139 2 5, 139 2 7]}
       Lst1:=ArticlesSeparat_TA(SNorms, false);
       If Lst1       = nil then Exit;
       If Lst1.Count = 0   then Exit;

       {Формируем список статей}
       SArticl := '';
       For I:=0 to Lst1.Count-1 do SArticl:=SArticl+', '+QuotedStr(Lst1[I]);
       Delete(SArticl, 1, 2);
       If SArticl='' then Exit;
    finally
       If Lst1 <> nil then Lst1.Free;
    end;

    {Формируем запрос}
    S:='SELECT  ['+F_COUNTER+'], ['+UK_NOMER+'], ['+UK_NORM+']'+CH_NEW+
       'FROM    ['+TABLE_UK+']'+CH_NEW+
       'WHERE ((['+UK_NOMER+'] IN ('+SArticl+')) AND '+
             '((:PStart >= ['+UK_BEGIN+']) OR (:PStart Is Null) OR (['+UK_BEGIN+'] Is Null)) AND '+
             '((:PEnd   <= ['+UK_END  +']) OR (:PEnd   Is Null) OR (['+UK_END  +'] Is Null)))'+CH_NEW+
       'ORDER BY ['+UK_NOMER+'] ASC;';
    P^.SQL.Add(S);
    P^.ParamCheck := true;
    P^.Parameters.ParseSQL(P^.SQL.Text, true);
    {If DatStart <> 0 then} SetQueryParam(P, 'PStart', ftDate, DatStart);        // Устраняем глюк
    {If DatEnd   <> 0 then} SetQueryParam(P, 'PEnd',   ftDate, IncDay(DatEnd, -1));
    P^.Open;
    P^.First;
    Result := true;
end;


{==============================================================================}
{========================      ВЫРЕЗАЕТ ЗАГОЛОВОК       =======================}
{==============================================================================}
function UKCutCaption(const SNorm: String): String;
var L: TStringList;
begin
    Result := '';
    L := TStringList.Create;
    try
       L.Text := SNorm;
       If L.Count < 3 then Exit;
       Result := L[0];
       TokChar(Result, '.');
       Result := Trim(Result);
    finally
       L.Free;
    end;
end;


{==============================================================================}
{===========================      ВЫРЕЗАЕТ НОРМУ       ========================}
{==============================================================================}
function UKCutNorm(const SNorm: String): String;
var L: TStringList;
begin
    Result := '';
    L := TStringList.Create;
    try
       L.Text := SNorm;
       If L.Count <> 3 then Exit;
       Result := Trim(L[1]);
    finally
       L.Free;
    end;
end;


{==============================================================================}
{=========================      ВЫРЕЗАЕТ САНКЦИЮ       ========================}
{==============================================================================}
function UKCutSanction(const SNorm: String): String;
var L: TStringList;
begin
    Result := '';
    L := TStringList.Create;
    try
       L.Text := SNorm;
       If L.Count < 3 then Exit;
       Result := Trim(L[2]);
    finally
       L.Free;
    end;
end;







(*
{==============================================================================}
{===========      ЗАГОЛОВКИ ДЛЯ ПЕРЕЧИСЛЕННЫХ НОРМ В СТРОКУ         ===========}
{==============================================================================}
{===========  SNorms  = 'пп.2,8 ч.2 ст.139, ч.2 ст.207, ... '       ===========}
{===========  DatStart, DatEnd - период                             ===========}
{===========  Возврат = Заголовки перечисленных норм в строку       ===========}
{===========            Если заголовков несколько, то через ' / '   ===========}
{==============================================================================}
function GetNormCaption(const PBD: PADOConnection; const SNorms: String;
                        const DatStart, DatEnd: TDate): String;
var Q     : TADOQuery;
    SList : TStringList;
begin
    {Инициализация}
    Result:='';
    If PBD=nil then Exit;
    If not PBD^.Connected then Exit;

    {Формируем запрос}
    SList := TStringList.Create;
    Q     := TADOQuery.Create(nil);
    try
       Q.Connection := PBD^;
       If not SetNormCaptionSQL(@Q, SType, SNorms, DatStart, DatEnd) then Exit;

       {Просматриваем запрос}
       With Q do begin
          First;
          While not Eof do begin
             SList.Add(FieldByName(TABLE_NORMS_CAPTION).AsString);
             Next;
          end;
          Close;
       end;

       {Возвращаемый результат}
       Result:=MStrGroup(@SList, LSEPARATOR);
    finally
       Q.Free;
       SList.Free;
    end;
end;


{==============================================================================}
{===========    ФОРМИРУЕТ SQL ЗАГОЛОВКОВ ДЛЯ ПЕРЕЧИСЛЕННЫХ НОРМ     ===========}
{==============================================================================}
{===========  SNorms  = 'пп.2,8 ч.2 ст.139, ч.2 ст.207, ... '       ===========}
{===========  DatStart, DatEnd - период                             ===========}
{==============================================================================}
function SetNormCaptionSQL(const P: PADOQuery; const SNorms: String;
                           const DatStart, DatEnd: TDate): Boolean;
var SFilter, S : String;
    BD         : TADOConnection;
begin
    {Инициализация}
    Result := false;
    If P = nil then Exit;
    BD := P^.Connection;

    {Определяем список норм, для которых нужны заголовки}
    SFilter:=SetNormsFilter(@BD, SNorms, DatStart, DatEnd, true);
    If SFilter='' then Exit;

    {Формируем текст базового запроса}
    S:='SELECT DISTINCT  ['+TABLE_NORMS        +'].['+F_CAPTION   +'] AS ['+TABLE_NORMS        +'], '+
                        '['+TABLE_NORMS_CAPTION+'].['+F_CAPTION   +'] AS ['+TABLE_NORMS_CAPTION+'], '+
                        '['+TABLE_NORMS_CAPTION+'].['+F_TERM_BEGIN+'], '+
                        '['+TABLE_NORMS_CAPTION+'].['+F_TERM_END  +']'  +CH_NEW+
       'FROM             ['+TABLE_NPA_TYPES    +'] '+
            'INNER JOIN (['+TABLE_NPA          +'] '+
            'INNER JOIN (['+TABLE_NORMS_TYPES  +'] '+
            'INNER JOIN (['+TABLE_NORMS        +'] '+
            'INNER JOIN  ['+TABLE_NORMS_CAPTION+'] '+
            'ON          ['+TABLE_NORMS        +'].['+F_COUNTER+'] = ['+TABLE_NORMS_CAPTION+'].['+TABLE_NORMS      +']) '+
            'ON          ['+TABLE_NORMS_TYPES  +'].['+F_COUNTER+'] = ['+TABLE_NORMS        +'].['+TABLE_NORMS_TYPES+']) '+
            'ON          ['+TABLE_NPA          +'].['+F_COUNTER+'] = ['+TABLE_NORMS        +'].['+TABLE_NPA        +']) '+
            'ON          ['+TABLE_NPA_TYPES    +'].['+F_COUNTER+'] = ['+TABLE_NPA          +'].['+TABLE_NPA_TYPES  +']'  +CH_NEW+
       'WHERE ('+
              '(['+TABLE_NORMS        +'].['+F_COUNTER      +'] IN '+SFilter                      +') AND '+
              '(['+TABLE_NORMS        +'].['+NORMS_COMMENT  +'] =  FALSE'                         +') AND '+   // Иначе добавляются заголовки статей УК комментариев
              '(['+TABLE_NORMS_CAPTION+'].['+F_CAPTION      +'] <> '+QuotedStr('')                +') AND '+
              '(['+TABLE_NORMS_TYPES  +'].['+F_CAPTION      +'] =  '+QuotedStr(SType)             +') AND '+   // Статья
              '(['+TABLE_NPA_TYPES    +'].['+F_CAPTION_SHORT+'] =  '+QuotedStr(NPA_TYPES_KODEKS  )+') AND '+   // Кодекс
              '(['+TABLE_NPA          +'].['+F_CAPTION_SHORT+'] =  '+QuotedStr(NORMS_UK          )+') AND '+   // УК
              '((:PStart >= ['+TABLE_NORMS_CAPTION+ '].['+F_TERM_BEGIN+']) OR (:PStart Is Null) OR (['+TABLE_NORMS_CAPTION+'].['+F_TERM_BEGIN+'] Is Null)) AND '+
              '((:PEnd   <= ['+TABLE_NORMS_CAPTION+ '].['+F_TERM_END  +']) OR (:PEnd   Is Null) OR (['+TABLE_NORMS_CAPTION+'].['+F_TERM_END  +'] Is Null))'+
              ')'+CH_NEW+
       'ORDER BY ['+TABLE_NORMS        +'].['+F_CAPTION   +'] ASC, '+
                '['+TABLE_NORMS_CAPTION+'].['+F_TERM_BEGIN+'] ASC, '+
                '['+TABLE_NORMS_CAPTION+'].['+F_TERM_END  +'] ASC';

    {Запускаем запрос}
    try
       With P^ do begin
          If Active then Close;
          SQL.Clear;
          SQL.Add(S+';');
          ParamCheck := true;
          Parameters.ParseSQL(SQL.Text, true);
          If DatStart <> 0 then SetQueryParam(P, 'PStart', ftDate, DatStart);   // Устраняем глюк
          If DatEnd   <> 0 then SetQueryParam(P, 'PEnd',   ftDate, IncDay(DatEnd, -1));
          Open;
       end;
       Result:=true;
    finally end;
end;
*)

(*
{==============================================================================}
{===========      ФОРМИРУЕТ SQL САНКЦИЙ ДЛЯ ПЕРЕЧИСЛЕННЫХ НОРМ      ===========}
{==============================================================================}
{===========  SNorms  = 'пп.2,8 ч.2 ст.139, ч.2 ст.207, ... '       ===========}
{===========  DatStart, DatEnd - период                             ===========}
{==============================================================================}
function SetNormSanctionSQL(const P: PADOQuery;
                            const SNorms: String;
                            const DatStart, DatEnd: TDate): Boolean;
var SFilter : String;
    S       : String;
    BD      : TADOConnection;
begin
    {Инициализация}
    Result:=false;
    If P=nil then Exit;
    BD := P^.Connection;

    {Определяем список норм, для которых нужны санкции - без связей}
    SFilter:=SetNormsFilter(@BD, SNorms, DatStart, DatEnd, false);
    If SFilter='' then Exit;

    {Формируем текст базового запроса}
    S:='SELECT DISTINCT  ['+TABLE_NORMS          +'].['+F_CAPTION              +'] AS ['+TABLE_NORMS         +'], '+
                        '['+TABLE_NORMS_SANCTION +'].['+F_CAPTION              +'] AS ['+TABLE_NORMS_SANCTION+'], '+
                        '['+TABLE_NORMS_SANCTION +'].['+NORMS_SANCTION_TERM_MAX+'], '+
                        '['+TABLE_NORMS_SANCTION +'].['+F_TERM_BEGIN           +'], '+
                        '['+TABLE_NORMS_SANCTION +'].['+F_TERM_END             +']'+CH_NEW+
       'FROM             ['+TABLE_NPA_TYPES      +'] '+
            'INNER JOIN (['+TABLE_NPA            +'] '+
            'INNER JOIN (['+TABLE_NORMS_TYPES    +'] '+
            'INNER JOIN (['+TABLE_NORMS          +'] '+
            'INNER JOIN  ['+TABLE_NORMS_SANCTION +'] '+
            'ON          ['+TABLE_NORMS          +'].['+F_COUNTER+'] = ['+TABLE_NORMS_SANCTION +'].['+TABLE_NORMS      +']) '+
            'ON          ['+TABLE_NORMS_TYPES    +'].['+F_COUNTER+'] = ['+TABLE_NORMS          +'].['+TABLE_NORMS_TYPES+']) '+
            'ON          ['+TABLE_NPA            +'].['+F_COUNTER+'] = ['+TABLE_NORMS          +'].['+TABLE_NPA        +']) '+
            'ON          ['+TABLE_NPA_TYPES      +'].['+F_COUNTER+'] = ['+TABLE_NPA            +'].['+TABLE_NPA_TYPES  +']'+CH_NEW+
       'WHERE ('+
              '(['+TABLE_NORMS         +'].['+F_COUNTER      +'] IN '+SFilter                      +') AND '+
              '(['+TABLE_NORMS_SANCTION+'].['+F_CAPTION      +'] <> '+QuotedStr('')                +') AND '+
              '(['+TABLE_NORMS_TYPES   +'].['+F_CAPTION      +'] =  '+QuotedStr(NORMS_TYPES_NORM)  +') AND '+   // Норма
              '(['+TABLE_NPA_TYPES     +'].['+F_CAPTION_SHORT+'] =  '+QuotedStr(NPA_TYPES_KODEKS  )+') AND '+   // Кодекс
              '(['+TABLE_NPA           +'].['+F_CAPTION_SHORT+'] =  '+QuotedStr(NORMS_UK          )+') AND '+   // УК
              '((:PStart >= ['+TABLE_NORMS_SANCTION+ '].['+F_TERM_BEGIN+']) OR (:PStart Is Null) OR (['+TABLE_NORMS_SANCTION+'].['+F_TERM_BEGIN+'] Is Null)) AND '+
              '((:PEnd   <= ['+TABLE_NORMS_SANCTION+ '].['+F_TERM_END  +']) OR (:PEnd   Is Null) OR (['+TABLE_NORMS_SANCTION+'].['+F_TERM_END  +'] Is Null))'+
              ')'+CH_NEW+
       'ORDER BY ['+TABLE_NORMS          +'].['+F_CAPTION   +'] ASC, '+
                '['+TABLE_NORMS_SANCTION +'].['+F_TERM_BEGIN+'] ASC, '+
                '['+TABLE_NORMS_SANCTION +'].['+F_TERM_END  +'] ASC';

    {Запускаем запрос}
    try
       With P^ do begin
          If Active then Close;
          SQL.Clear;
          SQL.Add(S+';');
          ParamCheck := true;
          Parameters.ParseSQL(SQL.Text, true);
          If DatStart <> 0 then SetQueryParam(P, 'PStart', ftDate, DatStart);   // Устраняем глюк
          If DatEnd   <> 0 then SetQueryParam(P, 'PEnd',   ftDate, IncDay(DatEnd, -1));
          Open;
       end;
       Result:=true;
    finally end;
end;

*)


(*
{==============================================================================}
{===========         САНКЦИИ ДЛЯ ПЕРЕЧИСЛЕННЫХ НОРМ В СТРОКУ        ===========}
{==============================================================================}
{===========  SNorms  = 'пп.2,8 ч.2 ст.139, ч.2 ст.207, ... '       ===========}
{===========  DatStart, DatEnd - период                             ===========}
{===========  Возврат = Санкции перечисленных норм в строку         ===========}
{===========            Если санкций несколько, то через ' / '      ===========}
{==============================================================================}
function GetNormSanction(const PBD: PADOConnection;
                         const SNorms: String;
                         const DatStart, DatEnd: TDate): String;
var Q     : TADOQuery;
    SList : TStringList;
begin
    {Инициализация}
    Result:='';
    If PBD = nil          then Exit;
    If not PBD^.Connected then Exit;

    {Формируем запрос}
    SList := TStringList.Create;
    Q     := TADOQuery.Create(nil);
    try
       Q.Database := PBD^;
       If not SetNormSanctionSQL(@Q, SNorms, DatStart, DatEnd) then Exit;

       {Просматриваем запрос}
       With Q do begin
          First;
          While not Eof do begin
             SList.Add(FieldByName(TABLE_NORMS_SANCTION).AsString);
             Next;
          end;
          Close;
       end;

       {Возвращаемый результат}
       Result:=GroupMStr(@SList, LSEPARATOR);
    finally
       Q.Free;
       SList.Free;
    end;
end;
*)

(*
const      CH_ART_DIV          = '-';   // Разделитель таблицы и поля в некоторых запросах
{==============================================================================}
{===========   ФОРМИРУЕТ SQL КОММЕНТАРИЕВ ДЛЯ ПЕРЕЧИСЛЕННЫХ НОРМ    ===========}
{==============================================================================}
{===========  SNorms  = 'пп.2,8 ч.2 ст.139, ч.2 ст.207, ... '       ===========}
{===========  DatStart, DatEnd - период                             ===========}
{===========  SFind - искомая строка                                ===========}
{===========  SOrder- выражение сортировки                          ===========}
{==============================================================================}
function SetCommentSQL(const P: PADOQuery; const SNorms: String;
                       const DatStart, DatEnd: TDate;
                       const SFind:  String = '';
                       const SOrder: String = ''): Boolean;
var SFilter, S : String;
    BD         : TADOConnection;
begin
    {Инициализация}
    Result:=false;
    If P = nil then Exit;
    BD := P^.Connection;
    If P^.Active then P^.Close;

    {Формируем текст базового запроса} // DISTINCT не применять - обрезает комментарий
    S:='SELECT           ['+TABLE_NORMS      +'].['+F_COUNTER              +'] AS '+CH_KAV+TABLE_NORMS      +CH_ART_DIV+F_COUNTER              +CH_KAV+','+CH_NEW+
                        '['+TABLE_NORMS      +'].['+NORMS_NPA              +'] AS '+CH_KAV+TABLE_NORMS      +CH_ART_DIV+NORMS_NPA              +CH_KAV+','+CH_NEW+
                        '['+TABLE_NORMS      +'].['+NORMS_NPA_TYPES        +'] AS '+CH_KAV+TABLE_NORMS      +CH_ART_DIV+NORMS_NPA_TYPES        +CH_KAV+','+CH_NEW+
                        '['+TABLE_NORMS      +'].['+NORMS_CAPTION          +'] AS '+CH_KAV+TABLE_NORMS      +CH_ART_DIV+NORMS_CAPTION          +CH_KAV+','+CH_NEW+
                        '['+TABLE_NORMS      +'].['+NORMS_CONTENT          +'] AS '+CH_KAV+TABLE_NORMS      +CH_ART_DIV+NORMS_CONTENT          +CH_KAV+','+CH_NEW+
                        '['+TABLE_NORMS      +'].['+NORMS_COMMENT          +'] AS '+CH_KAV+TABLE_NORMS      +CH_ART_DIV+NORMS_COMMENT          +CH_KAV+','+CH_NEW+
                        '['+TABLE_NORMS      +'].['+NORMS_DATE_START       +'] AS '+CH_KAV+TABLE_NORMS      +CH_ART_DIV+NORMS_DATE_START       +CH_KAV+','+CH_NEW+
                        '['+TABLE_NORMS      +'].['+NORMS_DATE_END         +'] AS '+CH_KAV+TABLE_NORMS      +CH_ART_DIV+NORMS_DATE_END         +CH_KAV+','+CH_NEW+
                        '['+TABLE_NORMS_TYPES+'].['+F_COUNTER              +'] AS '+CH_KAV+TABLE_NORMS_TYPES+CH_ART_DIV+F_COUNTER              +CH_KAV+','+CH_NEW+
                        '['+TABLE_NORMS_TYPES+'].['+NORMS_TYPES_CAPTION    +'] AS '+CH_KAV+TABLE_NORMS_TYPES+CH_ART_DIV+NORMS_TYPES_CAPTION    +CH_KAV+','+CH_NEW+
                        '['+TABLE_NPA        +'].['+F_COUNTER              +'] AS '+CH_KAV+TABLE_NPA        +CH_ART_DIV+F_COUNTER              +CH_KAV+','+CH_NEW+
                        '['+TABLE_NPA        +'].['+NPA_TYPES              +'] AS '+CH_KAV+TABLE_NPA        +CH_ART_DIV+NPA_TYPES              +CH_KAV+','+CH_NEW+
                        '['+TABLE_NPA        +'].['+NPA_CAPTION            +'] AS '+CH_KAV+TABLE_NPA        +CH_ART_DIV+NPA_CAPTION            +CH_KAV+','+CH_NEW+
                        '['+TABLE_NPA        +'].['+NPA_CAPTION_SHORT      +'] AS '+CH_KAV+TABLE_NPA        +CH_ART_DIV+NPA_CAPTION_SHORT      +CH_KAV+','+CH_NEW+
                        '['+TABLE_NPA        +'].['+NPA_DATE               +'] AS '+CH_KAV+TABLE_NPA        +CH_ART_DIV+NPA_DATE               +CH_KAV+','+CH_NEW+
                        '['+TABLE_NPA        +'].['+NPA_NOMER              +'] AS '+CH_KAV+TABLE_NPA        +CH_ART_DIV+NPA_NOMER              +CH_KAV+','+CH_NEW+
                        '['+TABLE_NPA_TYPES  +'].['+F_COUNTER              +'] AS '+CH_KAV+TABLE_NPA_TYPES  +CH_ART_DIV+F_COUNTER              +CH_KAV+','+CH_NEW+
                        '['+TABLE_NPA_TYPES  +'].['+NPA_TYPES_CAPTION      +'] AS '+CH_KAV+TABLE_NPA_TYPES  +CH_ART_DIV+NPA_TYPES_CAPTION      +CH_KAV+','+CH_NEW+
                        '['+TABLE_NPA_TYPES  +'].['+NPA_TYPES_CAPTION_SHORT+'] AS '+CH_KAV+TABLE_NPA_TYPES  +CH_ART_DIV+NPA_TYPES_CAPTION_SHORT+CH_KAV+CH_NEW+
       'FROM            (['+TABLE_NPA_TYPES  +'] '+
            'INNER JOIN  ['+TABLE_NPA        +'] '+
            'ON          ['+TABLE_NPA_TYPES  +'].['+F_COUNTER+'] = ['+TABLE_NPA  +'].['+TABLE_NPA_TYPES+']) '+
            'INNER JOIN (['+TABLE_NORMS_TYPES+'] '+
            'INNER JOIN  ['+TABLE_NORMS      +'] '+
            'ON          ['+TABLE_NORMS_TYPES+'].['+F_COUNTER+'] = ['+TABLE_NORMS+'].['+TABLE_NORMS_TYPES+']) '+
            'ON          ['+TABLE_NPA        +'].['+F_COUNTER+'] = ['+TABLE_NORMS+'].['+NORMS_NPA        +']'+CH_NEW+
       'WHERE ('+
              '(['+TABLE_NORMS+'].['+NORMS_CONTENT+'] <> '+QuotedStr('')+') AND '+
              '(['+TABLE_NORMS+'].['+NORMS_COMMENT+'] = TRUE) AND '+
              '((:PStart >= ['+TABLE_NORMS+ '].['+F_TERM_BEGIN+']) OR (:PStart Is Null) OR (['+TABLE_NORMS+'].['+F_TERM_BEGIN+'] Is Null)) AND '+
              '((:PEnd   <= ['+TABLE_NORMS+ '].['+F_TERM_END  +']) OR (:PEnd   Is Null) OR (['+TABLE_NORMS+'].['+F_TERM_END  +'] Is Null))';

    {Cписок норм}
    If SNorms <> '' then begin
       SFilter := SetNormsFilter(@BD, SNorms, DatStart, DatEnd, true);
       If SFilter <> '' then S := S + ' AND (['+TABLE_NORMS+'].['+F_COUNTER+'] IN '+SFilter+')';
    end;

    {Фильтр}
    If SFind  <> '' then S := S + ' AND (['+TABLE_NORMS+'].['+NORMS_CONTENT+'] LIKE '+QuotedStr('%'+SFind+'%')+'))'
                    else S := S + ')';

    {Сортировка}
    If SOrder <> '' then S := S + CH_NEW + SOrder;

    {Запускаем запрос}
    try
       With P^ do begin
          SQL.Clear;
          SQL.Add(S+';');
          ParamCheck := true;
          Parameters.ParseSQL(SQL.Text, true);
          If DatStart <> 0 then SetQueryParam(P, 'PStart', ftDate, DatStart);   // Устраняем глюк
          If DatEnd   <> 0 then SetQueryParam(P, 'PEnd',   ftDate, IncDay(DatEnd, -1));
          Open;
       end;
       Result:=true;
    finally end;
end;
*)

(*
{==============================================================================}
{============          ФОРМИРУЕТ ФИЛЬТР ИНДЕКСОВ НОРМ УК           ============}
{==============================================================================}
{============  SNorms  = 'пп.2,8 ч.2 ст.139, ч.2 ст.207, ... '     ============}
{============  Возврат - список индексов норм: '(5, 11, 88)'       ============}
{==============================================================================}
function SetNormsFilter(const PBD: PADOConnection; const SNorms: String;
                        const DatStart, DatEnd: TDate): String;
var Q          : TADOQuery;
    Lst1       : TStringList;
    S, SArticl : String;
    I          : Integer;
begin
    {Инициализация}
    Result := '';
    If not PBD^.Connected then Exit;
    Q            := TADOQuery.Create(nil);
    Q.Connection := PBD^;
    Lst1         := nil;
    try
       {Разбиваем статьи на составляющие в формат Access без покушений и приготовлений}
       {Вход:  пп.2,5 ч.2 ст.139, ч.1 ст.139, пп.2,7 ч.2 ст.139}
       {Выход: [139 1, 139 2 2, 139 2 5, 139 2 7]}
       Lst1:=ArticlesSeparat_TA(SNorms, false);
       If Lst1       = nil then Exit;
       If Lst1.Count = 0   then Exit;

       {Формируем список статей}
       SArticl := '';
       For I:=0 to Lst1.Count-1 do SArticl:=SArticl+', '+QuotedStr(Lst1[I]);
       Delete(SArticl, 1, 2);
       If SArticl='' then Exit;

       {Формируем запрос}
       S:='SELECT  ['+F_COUNTER'], ['+UK_NOMER+'], ['+UK_NORM+'], ['+UK_MIN+']'+CH_NEW+
          'FROM    ['+TABLE_UK+']'+
          'WHERE ((['+UK_NOMER+'] IN ('+SArticl+')) AND '+
                '((:PStart >= ['+UK_BEGIN+']) OR (:PStart Is Null) OR (['+UK_BEGIN+'] Is Null)) AND '+
                '((:PEnd   <= ['+UK_END  +']) OR (:PEnd   Is Null) OR (['+UK_END  +'] Is Null)))'+CH_NEW+
          'ORDER BY ['+UK_NOMER+'] ASC;';
       Q.SQL.Add(S);
       Q.ParamCheck := true;
       Q.Parameters.ParseSQL(Q.SQL.Text, true);
       If DatStart <> 0 then SetQueryParam(@Q, 'PStart', ftDate, DatStart);        // Устраняем глюк
       If DatEnd   <> 0 then SetQueryParam(@Q, 'PEnd',   ftDate, IncDay(DatEnd, -1));
       Q.Open;

       {Формируем фильтр}
       Q.First;
       While not Q.Eof do begin
          Result := Result + ', ' + Q.FieldByName(F_COUNTER).AsString;
          Q.Next;
       end;
       Delete(Result, 1, 2);
       If Result='' then Result:='-1';
       Result:='('+Result+')';

    finally
       If Q.Active  then Q.Close; Q.Free;
       If Lst1<>nil then Lst1.Free;
    end;
end;
*)

(*
{==============================================================================}
{===========   ВОЗВРАЩАЕТ СПИСОК ИНДЕКСОВ ЗАВИСИМЫХ ОТ PLSRC НОРМ   ===========}
{==============================================================================}
{====  РЕКУРСИВНЫЙ ВЫЗОВ                                                   ====}
{====  PLSrc   -  зависимые нормы                                          ====}
{====  Если IsFirst=true                                                   ====}
{====  PLSrc   = '139 1, 139 2 2, 139 2 5, ... '                           ====}
{====  на время действия проверяются главные и зависимые нормы             ====}
{==============================================================================}
{====  Если IsFirst=true                                                   ====}
{====  PLSrc   = '5, 8, 15, ... '  - индексы                               ====}
{====  на время действия проверяются только главные нормы                  ====}
{==============================================================================}
{====  Возврат: PLDest = '34, 12, 55, ... '                                ====}
{====  IsFirst = false: PLDest - только индексы главных норм               ====}
{====  IsFirst = true:  PLDest - индексы PLSrc и индексы главных норм      ====}
{==============================================================================}
{====  IsLoop  = false: не искать связанные нормы (только перечисленные)   ====}
{==============================================================================}
{====  Result  - имеются ли добавления                                     ====}
{==============================================================================}
function SetNormsRel(const PBD: PADOConnection; const PLSrc, PLDest: PStringList;
                     const DatStart, DatEnd: TDate; const IsFirst, IsLoop: Boolean): Boolean;
var Q           : TADOQuery;
    S, SArticl  : String;
    I           : Integer;
begin
    {Инициализация}
    Result:=false;
    If not PBD^.Connected then Exit;
    If (PLSrc=nil) or (PLDest=nil) then Exit;

    {Формируем список статей}
    SArticl:='';
    If IsFirst then For I:=0 to PLSrc^.Count-1 do SArticl:=SArticl+', '+QuotedStr(PLSrc^[I])
               else For I:=0 to PLSrc^.Count-1 do SArticl:=SArticl+', '+PLSrc^[I];
    Delete(SArticl, 1, 2);
    If SArticl='' then Exit;

    {Формируем текст запроса}
    If IsFirst
    then S:='SELECT DISTINCT ['+TABLE_NORMS_REL+  '].['+NORMS_REL_SECOND+']'+CH_NEW+
            'FROM            ['+TABLE_NORMS+      '] AS ['+F_NFIRST+     '] '+
            'INNER JOIN     (['+TABLE_NORMS_TYPES+'] '+
            'INNER JOIN     (['+TABLE_NORMS+      '] AS ['+F_NSECOND+    '] '+
            'INNER JOIN      ['+TABLE_NORMS_REL+  '] '+
            'ON              ['+F_NSECOND+        '].['+F_COUNTER+'] = ['+TABLE_NORMS_REL+'].['+NORMS_REL_SECOND+ ']) '+
            'ON              ['+TABLE_NORMS_TYPES+'].['+F_COUNTER+'] = ['+F_NSECOND+      '].['+TABLE_NORMS_TYPES+']) '+
            'ON              ['+F_NFIRST+         '].['+F_COUNTER+'] = ['+TABLE_NORMS_REL+'].['+NORMS_REL_FIRST+  '] '+
            'WHERE (        (['+F_NSECOND+        '].['+F_CAPTION+'] IN ('+SArticl                  +')) AND '+
                           '(['+TABLE_NORMS_TYPES+'].['+F_CAPTION+'] = '+QuotedStr(NORMS_TYPES_NORM)+')  AND '+   // Норма
              '((:PStart >= ['+F_NSECOND+ '].['+F_TERM_BEGIN+']) OR (:PStart Is Null) OR (['+F_NSECOND+'].['+F_TERM_BEGIN+'] Is Null)) AND '+
              '((:PEnd   <= ['+F_NSECOND+ '].['+F_TERM_END  +']) OR (:PEnd   Is Null) OR (['+F_NSECOND+'].['+F_TERM_END  +'] Is Null)) AND '+
              '((:PStart >= ['+F_NFIRST+  '].['+F_TERM_BEGIN+']) OR (:PStart Is Null) OR (['+F_NFIRST+ '].['+F_TERM_BEGIN+'] Is Null)) AND '+
              '((:PEnd   <= ['+F_NFIRST+  '].['+F_TERM_END  +']) OR (:PEnd   Is Null) OR (['+F_NFIRST+ '].['+F_TERM_END  +'] Is Null)) '+
              ')'

    else S:='SELECT DISTINCT ['+TABLE_NORMS_REL+  '].['+NORMS_REL_FIRST+']'+CH_NEW+
            'FROM            ['+TABLE_NORMS+      '] AS ['+F_NFIRST+    '] '+
            'INNER JOIN     (['+TABLE_NORMS+      '] AS ['+F_NSECOND+   '] '+
            'INNER JOIN      ['+TABLE_NORMS_REL+  '] '+
            'ON              ['+F_NSECOND+        '].['+F_COUNTER+'] = ['+TABLE_NORMS_REL+'].['+NORMS_REL_SECOND+']) '+
            'ON              ['+F_NFIRST+         '].['+F_COUNTER+'] = ['+TABLE_NORMS_REL+'].['+NORMS_REL_FIRST+ '] '+
            'WHERE (        (['+F_NSECOND+        '].['+F_COUNTER+'] IN ('+SArticl+        ')) AND '+
              '((:PStart >= ['+F_NFIRST+  '].['+F_TERM_BEGIN+']) OR (:PStart Is Null) OR (['+F_NFIRST+ '].['+F_TERM_BEGIN+'] Is Null)) AND '+
              '((:PEnd   <= ['+F_NFIRST+  '].['+F_TERM_END  +']) OR (:PEnd   Is Null) OR (['+F_NFIRST+ '].['+F_TERM_END  +'] Is Null)) '+
              ')';
    {Создаем запрос}
    Q            := TADOQuery.Create(nil);
    Q.Connection := PBD^;
    try
       Q.SQL.Add(S+';');
       Q.ParamCheck := true;
       Q.Parameters.ParseSQL(Q.SQL.Text, true);
       If DatStart <> 0 then SetQueryParam(@Q, 'PStart', ftDate, DatStart);        // Устраняем глюк
       If DatEnd   <> 0 then SetQueryParam(@Q, 'PEnd',   ftDate, IncDay(DatEnd, -1));
       Q.Open;

       {Возвращаемый результат}
       PLSrc^.Clear;
       Q.First;
       While not Q.Eof do begin
          If IsFirst
          then S:=Q.FieldByName(NORMS_REL_SECOND).AsString
          else S:=Q.FieldByName(NORMS_REL_FIRST ).AsString;
          If PLDest^.IndexOf(S)<0 then begin
             PLDest^.Add(S);
             PLSrc^.Add(S);
             Result:=true;
          end;
          Q.Next;
       end;

       {Рекурсивный вызов}
       If Result and IsLoop then Result:=SetNormsRel(PBD, PLSrc, PLDest, DatStart, DatEnd, false, IsLoop);

       Q.Close;
    finally
       Q.Free;
    end;
end;
*)



