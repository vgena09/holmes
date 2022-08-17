{******************************************************************************}
{*************************    РАБОТА С ТЕКСТОМ   ******************************}
{******************************************************************************}


{==============================================================================}
{================  Корректирование (группировка) списка статей  ===============}
{==============================================================================}
{===  Вход:  пп.2,5,12 ч.2 ст.139, ст.14 - ч.1 ст.139, пп.2,7,9 ч.2 ст.139  ===}
{===  Выход: ст.14 - ч.1 ст.139, пп.2,5,7,9,12 ч.2 ст.139                   ===}
{==============================================================================}
{===  Вход:  ч.2 ст.206, ч.1 ст.206, чч.1,3 ст.206, ч.1 ст.14 - ст.401      ===}
{===  Выход: чч.1,2,3 ст.206, ч.1 ст.14 - ст.401                            ===}
{==============================================================================}
function ArticlesGroup_TT(const Str: String): String;
var SList : TStringList;

    {**************************************************************************}
    {*** Удаляет из списка дублирование ***************************************}
    {**************************************************************************}
    procedure RemoveDublicate;
    var I, I0         : Integer;
        S, S0, SVal   : String;
        S1, S2, S3    : String;
        S01, S02, S03 : String;

       {***********************************************************************}
       {*** Выделяет части статьи *********************************************}
       {***********************************************************************}
       {*** Str  = 14 1 - 139 2 1 *********************************************}
       {*** PS1^ = 14 1 - 139     *********************************************}
       {*** PS2^ = 2              *********************************************}
       {*** PS3^ = 1              *********************************************}
       {***********************************************************************}
       procedure SeparatParts(const Str: String; const PS1, PS2, PS3: PString);
       var S : String;
           I : Integer;
       begin
           {Инициализация}
           PS1^:=''; PS2^:=''; PS3^:='';
           S   :=Str;

           {Определяем S1}
           I:=Pos(' - ', S);
           If I>0 then begin
              PS1^ := Copy(S, 1, I+2);
              Delete(S, 1, I+2);
           end;
           PS1^ := PS1^ + CutSlovo(S, 1, ' ');
           PS2^ := PS2^ + CutSlovo(S, 2, ' ');
           PS3^ := PS3^ + CutSlovo(S, 3, ' ');
       end;

    begin
        {Устранение ошибки сортировки: 12<2 --> 12>02 - делаем все цифры трехзначными}
        For I:=0 to SList.Count-1 do begin
           SVal := '';
           S    := SList[I];
           S0   := TokChar(S, ' ');
           While S0<>'' do begin
              If S0<>'-' then For I0:=Length(S0) to 2 do Insert('0', S0, 1);
              SVal := SVal+' '+S0;
              S0   := TokChar(S, ' ');
           end;
           Delete(SVal, 1, 1);
           SList[I]:=SVal;
        end;

        {Сортируем список}
        SList.Sort;

        {Удаляем лишние нули}
        For I:=0 to SList.Count-1 do begin
           SVal := '';
           S    := SList[I];
           For I0:=1 to GetColSlov(S, ' ') do begin
              S0:=CutSlovo(S, I0, ' ');
              If (S0<>'-') and IsIntegerStr(S0) then S0:=IntToStr(StrToInt(S0));
              SVal := SVal+' '+S0;
           end;
           Delete(SVal, 1, 1);
           SList[I]:=SVal;
        end;

        {Удаляем одинаковые статьи}
        For I:=SList.Count-1 downto 1 do begin
           If SList[I]=SList[I-1] then SList.Delete(I);
        end;

        {Объединяем одинаковые части и пункты}
        For I:=SList.Count-1 downto 1 do begin
           {Разбиваем блок и предыдущий блок на составляющие}
           SeparatParts(SList[I],   @S1,  @S2,  @S3);
           SeparatParts(SList[I-1], @S01, @S02, @S03);

           {Если первые части не равны, то незачем дальше сравнивать}
           If S1<>S01 then Continue;

           {Если есть объединение частей - S2}
           If (S2<>S02) and (S3='') and (S03='') then begin
              SList[I-1]:=S1+' '+S02+','+S2;
              SList.Delete(I);
              Continue;
           end;

           {Если есть объединение пунктов - S3}
           If (S2=S02) and (S3<>S03) then begin
              SList[I-1]:=S1+' '+S2+' '+S03+','+S3;
              SList.Delete(I);
              Continue;
           end;

           {Если полное объединение}
           If (S2=S02) and (S3=S03) then SList.Delete(I);
        end;
    end;

    {**************************************************************************}
    {*** Формирует из списка строку статей ************************************}
    {**************************************************************************}
    function GetArticlStr: String;
    var S : String;
        I : Integer;
    begin
        {Инициализация}
        Result:='';

        {Просматриваем список}
        For I:=0 to SList.Count-1 do begin
           S:=ArticlesConvertBlock_AT(SList[I]);
           If S<>'' then Result:=Result+', '+S;
        end;

        {Корректируем результат}
        Delete(Result, 1, 2);
    end;

{******************************************************************************}
{*** Основная функция *********************************************************}
{******************************************************************************}
begin
    {Инициализация}
    Result:='';

    try
       {Разбиваем исходную строку на блоки в формате Access (с приготовлениями и покушениями) и создаем список SList}
       SList:=ArticlesSeparat_TA(Str, true);

       {Удаляет из списка дублирование}
       RemoveDublicate;

       {Формируем из списка строку статей}
       Result:=GetArticlStr;
    finally
       If SList<>nil then SList.Free;
    end;
end;


{==============================================================================}
{==================    РАЗБИВАЕТ СТАТЬИ НА СОСТАВЛЯЮЩИЕ     ===================}
{==============================================================================}
{===  Вход:  пп.2,5 ч.2 ст.139, ч.1 ст.14 - ч.1 ст.139, пп.2,7 ч.2 ст.139  ====}
{===  Выход: ч.1 ст.14 - ч.1 ст.139, п.2 ч.2 ст.139, п.5 ч.2 ст.139, ...   ====}
{==============================================================================}
function ArticlesSeparat_TT(const Str: String): TStringList;
var SList : TStringList;
    I     : Integer;
begin
    {Инициализация}
    Result:=nil;

    {Разбиваем список статей на блоки в формате Access (с приготовлениями и покушениями)}
    SList:=ArticlesSeparat_TA(Str, true);
    If SList=nil then Exit;
    Result:=TStringList.Create;

    {Преобразуем блок из Access в Txt}
    For I:=0 to SList.Count-1 do Result.Add(ArticlesConvertBlock_AT(SList[I]));
end;


{==============================================================================}
{==================    РАЗБИВАЕТ СТАТЬИ НА СОСТАВЛЯЮЩИЕ     ===================}
{==============================================================================}
{===  Вход:  пп.2,5 ч.2 ст.139, ч.1 ст.14 - ч.1 ст.139, пп.2,7 ч.2 ст.139  ====}
{===  Выход: 14 1 - 139 1, 139 2 2, 139 2 5, 139 2 7  - IsFull=true        ====}
{===  Выход:        139 1, 139 2 2, 139 2 5, 139 2 7  - IsFull=false       ====}
{==============================================================================}
function ArticlesSeparat_TA(const Str: String; const IsFull: Boolean): TStringList;
var SList : TStringList;
    Str0  : String;
    I     : Integer;


    {**************************************************************************}
    {*** Разбивает блок на составляющие статьи и заносит в список SList *******}
    {**************************************************************************}
    {Art = ч.1 ст.14 - пп.2,7, 9 ч.2 ст.139}
    {Art = ст.14 - ст.145}
    {Art = пп.2,7, 9 ч.2 ст.139}
    {Art = чч.1,3, 8 ст.206}
    {Art = ст.326}
    procedure AddArticlToSList(const Art: String);
    var SList0 : TStringList;
        S, S0  : String;
        I      : Integer;

       {***********************************************************************}
       {***  Разбивает строку на составляющие статьи в новом формате  *********}
       {***********************************************************************}
       {Str = 2,7,9 2 139  -->  139 2 2  /  139 2 7  /  139 2 9 }
       {Str = 1,3,8 206    -->  206 1    /  206 3    /  206 8   }
       {Str = 326          -->  326                             }
       procedure GetNewForm(const Str: String; const PList: PStringList);
       var S, S1, S2, S3 : String;
           I             : Integer;
       begin
           {Инициализация}
           If PList=nil then Exit;
           PList^.Clear;
           S1:=''; S2:=''; S3:='';
           S := Trim(Str);

           {Число слов}
           I := GetColSlov(S, ' ');
           If I=0 then Exit;

           {Статья: S1='139'; Часть: S2='2'; Пункт: S3='2,7,9'}
                       S1 := CutSlovo(S, I, ' ');
           If I>1 then S2 := CutSlovo(S, I-1, ' ');
           If I>2 then S3 := CutSlovo(S, I-2, ' ');

           {Возвращаемый результат}
           If S3<>'' then begin
              If GetColSlov(S3, ',')>0 then begin
                 For I:=1 to GetColSlov(S3, ',') do begin
                    PList^.Add(S1+' '+S2+' '+CutSlovo(S3, I, ','));
                 end;
              end else begin
                 PList^.Add(S1+' '+S2+' '+S3);
              end;
              Exit;
           end;
           If S2<>'' then begin
              If GetColSlov(S2, ',')>1 then begin
                 For I:=1 to GetColSlov(S2, ',') do begin
                    PList^.Add(S1+' '+CutSlovo(S2, I, ','));
                 end;
              end else begin
                 PList^.Add(S1+' '+S2);
              end;
              Exit;
           end;
           PList^.Add(S1);
       end;

    begin
        {Инициализация}
        S:=''; S0:='';
        SList0:=TStringList.Create;
        try
           {Убираем из блока не нужные символы + инвертирование строки: S='1 14 - 2,7,9 2 139'}
           For I:=1 to Length(Art) do begin
              Case Art[I] of
              'п','ч','с','т','.': S:=S+' ';
              else S:=S+Art[I];
              end;
           end;

           {Убираем лишние символы}
           S := ReplStrLoop(S, '  ', ' ');                // '2,    7,9 2 139' --> '2, 7,9 2 139'
           S := ReplStrLoop(S, ', ', ',');                // '2, 7,9 2 139'    --> '2,7,9 2 139'

           {Вырезаем приготовление и покушение в S0 = '14 1 - '}
           I:=Pos('-', S);
           If I>0 then begin
              {Если учитываем приготовление и покушение}
              If IsFull then begin
                 S0 := Copy(S, 1, I-1);
                 Delete(S, 1, I);

                 {Переводим в новый формат}
                 GetNewForm(S0, @SList0);                 // '1 14'  -->  '14 1'
                 If SList0.Count>0 then S0 := SList0[0]+' - '
                                   else S0 := '';

              {Если не учитываем приготовление и покушение}
              end else begin
                 Delete(S, 1, I);
              end;
           end;

           {Разбиваем на составляющие статьи в новом формате}
           GetNewForm(S, @SList0);

           {Формируем результат}
           For I:=0 to SList0.Count-1 do SList.Add(S0+SList0[I]);
        finally
           SList0.Free;
        end;
    end;


{******************************************************************************}
{*** Основная функция *********************************************************}
{******************************************************************************}
begin
    {Для совместимости: если статьи разделены #0D#0A}
    Str0:=Str;
    For I:=1 to Length(Str0)-1 do begin
       If (Str0[I]=Chr(13)) and (Str0[I+1]=Chr(10)) then begin
          Str0[I]:=',';
          Str0[I+1]:=' ';
       end;
    end;

    {Инициализация}
    Result:=nil;
    SList:=TStringList.Create;
    try
       {Разбиваем исходную строку на блоки и создаем список SList}
       While Str0<>'' do AddArticlToSList(TokArticl(Str0));

       {Возвращаемое значение}
       If SList.Count=1 then If SList[0]='' then Exit;
       Result:=SList;
       Result.Sort;
    except
       SList.Free;
    end;
end;


{==============================================================================}
{================  Перевод списка статей для Access: Norms  ===================}
{==============================================================================}
{======  Вход:  139 1, 139 2 2, 139 2 5, 139 2 7                         ======}
{======  Выход: пп.2,5 ч.2 ст.139, ч.1 ст.139, пп.2,7 ч.2 ст.139         ======}
{==============================================================================}
function ArticlesConvert_AT(const Str: String): String;
label Nx;
var SList : TStringList;
    S     : String;
    I     : Integer;
begin
    {Инициализация}
    Result := '';
    SList  := TStringList.Create;
    try
       If Not SeparatMStr(Str, @SList, ', ') then Exit;

       {Конвертируем каждый блок}
       For I:=0 to SList.Count-1 do begin
          S:=ArticlesConvertBlock_AT(SList[I]);
          If S<>'' then Result:=Result+', '+S;
       end;
       Delete(Result, 1, 2);

       {Корректируем строку}
       Result:=ArticlesGroup_TT(Result);
    finally
       SList.Free;
    end;
end;


{==============================================================================}
{=====================  Разделяет мультистроку в массив  ======================}
{==============================================================================}
function SeparatMStr(const MStr: String; const PLStr: PStringList; const Separator: String): Boolean;
var S: String;
    I: Integer;
begin
    {Инициализация}
    Result:=false;
    If PLStr=nil then Exit;
    PLStr^.Clear;

    {Просматриваем все статусы и формируем список}
    I:=1; S:=Trim(CutSlovo(MStr, I, Separator));
    While S<>'' do begin
       Result:=true;
       PLStr^.Add(S);
       Inc(I); S:=Trim(CutSlovo(MStr, I, Separator));
    end;
end;


{==============================================================================}
{==========            Преобразует блок из Access в Txt            ============}
{==============================================================================}
{==========  14 1 - 139 2 5,8  -->  ч.1 ст.14 - пп.5,8 ч.2 ст.139  ============}
{==============================================================================}
function ArticlesConvertBlock_AT(const Str: String): String;
var S, S0 : String;
    I     : Integer;

    {**************************************************************************}
    {***************  Преобразует часть блока из Access в Txt  ****************}
    {**************************************************************************}
    {***************        14 1     -->  ч.1 ст.14            ****************}
    {***************        139 2 5  -->  п.5 ч.2 ст.139       ****************}
    {**************************************************************************}
    function ConvertPartBlock(const Str: String): String;
    var S: String;
    begin
        {Инициализация}
        Result := 'ст.'+CutSlovo(Str, 1, ' ');

        {Определяем части}
        S      := CutSlovo(Str, 2, ' ');
        If S<>'' then begin
           If Pos(',', S)>0 then Result:='чч.'+S+' '+Result
                            else Result:='ч.' +S+' '+Result;
        end;

        {Определяем пункты}
        S      := CutSlovo(Str, 3, ' ');
        If S<>'' then begin
           If Pos(',', S)>0 then Result:='пп.'+S+' '+Result
                            else Result:='п.'+S+' '+Result;
        end;
    end;
begin
    {Инициализация}
    S  := Str;
    S0 := '';

    {Определяем статьи приготовления и покушения}
    I:=Pos(' - ', S);
    If I>0 then begin
       S0 := Copy(S, 1, I-1);
       S0 := ConvertPartBlock(S0)+' - ';
       Delete(S, 1, I+Length(' - ')-1);
    end;

    {Определяем остальные части}
    Result:=S0+ConvertPartBlock(S);
end;


{==============================================================================}
{==============    ПРОВЕРЯЕТ ПРАВИЛЬНОСТЬ НАПИСАНИЯ СТАТЕЙ     ================}
{==============================================================================}
function VerifyArticles(const Str: String): Boolean;
var SListNum, SListTxt : TStringList;
    SNum, STxt, S, S0  : String;
    I, I0 : Integer;
begin
    {Инициализация}
    Result:=false;
    STxt:=Trim(Str);
    If STxt='' then Exit;

    {Разбиваем статьи на составляющие}
    SListNum := ArticlesSeparat_TA(Str, true);
    SListTxt := ArticlesSeparat_TT(Str);
    try
       If (SListNum=nil) or (SListTxt=nil) then Exit;
       If SListNum.Count = 0               then Exit;
       If SListNum.Count <> SListTxt.Count then Exit;
       Result:=true;

       {Просматриваем каждый блок статей}
       For I:=0 to SListNum.Count-1 do begin
          SNum := SListNum[I];
          STxt := AnsiLowerCase(SListTxt[I]);
          If GetColSlov(SNum, ' ')<>GetColSlov(STxt, ' ') then begin Result:=false; Break; end;
          If FindStr('ст.', STxt)<1                       then begin Result:=false; Break; end;

          {Просматриваем каждый элемент статей}
          For I0:=1 to GetColSlov(SNum, ' ') do begin
             {Если элемент - цифра, то ОК}
             S:=CutSlovo(SNum, I0, ' ');
             If IsIntegerStr(S) then Continue;

             {Иначе: цифра_цифра}
             If I0=1 then begin
                S0:=CutSlovo(S, 1, '_');
                If IsIntegerStr(S0) then begin
                   S0:=CutSlovo(S, 2, '_');
                   If IsIntegerStr(S0) then Continue;
                 end;
             end;

             {Недопустимое значение}
             Result:=false;
             Break;
          end;

          If Result=false then Break;
       end;
    finally
       If SListTxt <> nil then SListTxt.Free;
       If SListNum <> nil then SListNum.Free;
    end;
end;


{==============================================================================}
{================   ВЫРЕЗАЕТ ИЗ СТРОКИ СТАТЕЙ ПЕРВЫЙ БЛОК    ==================}
{==============================================================================}
{=======  Art = пп.2,4, 7 ч.2 ст.139, ст.14 - ч.1 ст.139, ч.1 ст.145,  ========}
{==============================================================================}
{================  Result = ч.1 ст.14 - пп.2,7,9 ч.2 ст.139  ==================}
{================  Result = ст.14 - пп.2,7,9 ч.2 ст.139      ==================}
{================  Result = пп.2,7,9 ч.2 ст.139              ==================}
{================  Result = чч.1,3 ст.206                    ==================}
{================  Result = ст.326                           ==================}
{==============================================================================}
function TokArticl(var Art: String): String;
label Nx;
var S1, S2 : String;
    I      : Integer;
begin
    {Инициализация}
    Result := '';
    Art:=Trim(Art);
    If Art='' then Exit;

    {Поиск первого сепаратора}
    I:=1;
Nx: I:=InStrMy(I, Art, ', ');

    {Предполагаемый сепаратор найден}
    If I>0 then begin
       {Определяем блоки до и после сепаратора}
       S1:=Copy(Art, 1,   I-1);
       S2:=Trim(Copy(Art, I+1, Length(Art)-I));

       {Если блок после сепаратора начинается с цифры, то не верный сепаратор - ищем дальше}
       If Length(S2)>0 then If IsNumeric(S2[1]) then begin
          I:=I+1;
          Goto Nx;
       end;

       {Вырезаем блок}
       Result:=S1;
       Delete(Art, 1, Length(S1+', '));

    {Сепаратор не найден}
    end else begin
       If FindStr('ст.', Art)>0 then Result:=Art else Result:='';
       Art:='';
    end;

    {Убираем возможные псевдооператоры}
    Result:=ReplStr(Result, ', ', ',');

    {Возвращаемый результат}
    If Length(Result)>0 then If Result[Length(Result)]=',' then Delete(Result, Length(Result), 1);
end;


{==============================================================================}
{========  Выбор S1 или S2 в зависимости от числа статей в SArticl  ===========}
{==============================================================================}
function  SelTxtFromArticl(const SArticl, S1, S2: String): String;
var SList : TStringList;
    S     : String;
begin
    {Инициализация}
    Result:=S1;

    {SArticl м/б в кавычках}
    S:=CutModulChar(SArticl, CH_KAV, CH_KAV);
    If S='' then S:=SArticl;

    {Разбиваем список статей на блоки в формате Access (без приготовлений и покушений)}
    SList:=ArticlesSeparat_TA(S, false);

    If SList=nil then Exit;
    If SList.Count>1 then Result:=S2;
    SList.Free;
end;
