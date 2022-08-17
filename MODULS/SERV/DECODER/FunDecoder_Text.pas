{******************************************************************************}
{*****************  О П Е Р А Ц И И    С    Т Е К С Т О М  ********************}
{******************************************************************************}

{==============================================================================}
{=============           БАЗОВЫЙ   МОДУЛЬ  ДЕКОДЕРА              ==============}
{==============================================================================}
{=============   Kod = Операнд                                   ==============}
{=============   LDecod, PLTab - исп-ся только для 'СВЯЗЬ'       ==============}
{==============================================================================}
function TDECOD.DopDecoderBase(var DecStr: String; const Kod: String): Boolean;
label Ex, Ex0;
var Cmd : String;
    Prm : TArrayStr;
begin
    {Инициализация}
    Result:=false;
    If Kod='' then Exit;

    {Разбивает код [Kod] на команду [Cmd] и параметры [Prm]}
    SeparatKod(Kod, Cmd, Prm);

    {Команды-исключения}
    If not IsStrInArray(Cmd, ['#',
                             '**',
                             'ИНФО',
                             'ВВОД',
                             'ВВОД СТАТУСА',
                             'ДАТАВРЕМЯ В ТЕКСТ',
                             'ПРАВА УЧАСТНИКОВ',
                             'УВЕДОМЛЕНИЕ О ЗАПИСИ',
                             'УВЕДОМЛЕНИЕ О ВОСПРОИЗВЕДЕНИИ ЗАПИСИ']) then Prm:=UpperArrayStr(Prm);

    {**************************************************************************}
    {****************  FunDecoder_Text_Macro:  М А К Р О С Ы   ****************}
    {**************************************************************************}
    If Cmd = 'СПИСОК УЧАСТНИКОВ'                    then begin DecStr:=FMacroParticipantsList;        Goto Ex; end;
    If Cmd = 'ПРАВА УЧАСТНИКОВ'                     then begin DecStr:=FMacroParticipantsRights(Prm); Goto Ex; end;
    If Cmd = 'ПОДПИСИ УЧАСТНИКОВ'                   then begin DecStr:=FMacroParticipantsSign;        Goto Ex; end;
    If Cmd = 'УВЕДОМЛЕНИЕ О ЗАПИСИ'                 then begin DecStr:=FMacroMediaInform(Prm);        Goto Ex; end;
    If Cmd = 'УВЕДОМЛЕНИЕ О ВОСПРОИЗВЕДЕНИИ ЗАПИСИ' then begin DecStr:=FMacroMediaShow(Prm);          Goto Ex; end;


    {**************************************************************************}
    {*****************  FUN_COMMON:  О Б Щ И Е   Ф У Н К Ц И И  ***************}
    {**************************************************************************}
    If Cmd = 'СИМВОЛ'      then begin DecStr:=FKodChr(Prm);                     Goto Ex; end;
    If Cmd = '/N'          then begin DecStr:=CH_NEW        ;                  Goto Ex; end;
    If Cmd = '/A'          then begin DecStr:=Chr(10);                          Goto Ex; end;


    {**************************************************************************}
    {************  FunDecoder_Text:  Р А Б О Т А   С   Т Е К С Т О М   ********}
    {**************************************************************************}
    If Cmd = 'ЗАГЛ'        then begin DecStr:=MyCharUpper(DecStr, Prm);         Goto Ex; end;


    {**************************************************************************}
    {*** Обязательны 3 параметра **********************************************}
    {**************************************************************************}
    If Length(Prm)>2  then begin
       If Cmd = 'САНКЦИЯ'   then begin DecStr:=FindFromSanctionArticles(DecStr, Prm);                         Goto Ex; end;
    end;

    
    {**************************************************************************}
    {*** Обязательны 2 параметра **********************************************}
    {**************************************************************************}
    If Length(Prm)>1  then begin
       {Команда: подстановка строки в зависимости от числа преступлений}
       If Cmd = '#'         then begin DecStr:=SelTxtFromArticl(DecStr, Prm[0], Prm[1]);                      Goto Ex; end;
       {Команда: текст в зависимости от пола}
       If Cmd = '**'        then begin DecStr:=FSexPrm(DecStr, Prm);                                          Goto Ex; end;
       {Команда: поиск строк}
       If Cmd = 'ПОИСК'     then begin DecStr:=FFindPrm(Prm);                                                 Goto Ex; end;

       {***********************************************************************}
       {*** Команда: 1-й параметр - цифра *************************************}
       {***********************************************************************}
       {Команда: вырезает из фразы слово}
       If IsIntegerStr(Prm[0]) then begin
          If Cmd = 'СЛОВО'  then begin DecStr:=CutSlovo(DecStr, StrToInt(Prm[0]), AnsiLowerCase(Prm[1]));  Goto Ex; end;
       end;
    end;

    {**************************************************************************}
    {*** Обязателен 1 параметр ************************************************}
    {**************************************************************************}
    If Length(Prm)>0  then begin
       If Length(Prm[0])>0 then begin
          {Команда: устанавливаем строку для дальнейшей обработки}
          If Cmd = '!'  then begin DecStr:=FSetStr(Kod);                                                      Goto Ex; end;
          {Команда: вырезает из ФИО инициалы в обратном порядке}
          If Cmd = 'ИНИЦИАЛЫ' then begin
             If String(Prm[0][1])='-' then begin DecStr:=FIO_Initialy(DecStr, false);                         Goto Ex; end;
          end;
          {Команда: склоняет ФИО}
          If Cmd = 'ПАДЕЖ ФИО'    then begin DecStr:=PadegFIO(Prm[0][1], DecStr);                             Goto Ex; end;
          {Команда: склоняет фразу путем поиска в БД и диалога}
//          If Cmd = 'ПАДЕЖ ДИАЛОГ' then begin DecStr:=PadegDLG(Prm[0][1], DecStr);                           Goto Ex; end;
          {Команда: склоняет фразу автоматически}
          If Cmd = 'ПАДЕЖ АВТО'   then begin DecStr:=PadegAUTO(Prm[0][1], DecStr);                            Goto Ex; end;
          //{Команда: изменяет падеж статуса на указанный}  отключено за ненадобностью
          //If Cmd = 'ПАДЕЖ СТАТУСА'then begin DecStr:=PadegSTATUS(@FFMAIN.BSET_GLOBAL.TLSTATUS, Prm[0][1], DecStr); Goto Ex; end;
       end;
       {***********************************************************************}
       {*** Команда: 1-й параметр - цифра *************************************}
       {***********************************************************************}
       If IsIntegerStr(Prm[0]) then begin
          {Команда: вырезает из фразы слово}
          If Cmd = 'СЛОВО'  then begin DecStr:=CutSlovo (DecStr, StrToInt(Prm[0]), ' ');                    Goto Ex; end;
          If Cmd = 'СТРОКА' then begin DecStr:=FCutLines(DecStr, StrToInt(Prm[0]));                           Goto Ex; end;
       end;
    end;

    {**************************************************************************}
    {*** Нет параметров *******************************************************}
    {**************************************************************************}
    If Length(Prm)=0 then begin
//       If Cmd = 'ДОБАВИТЬ ПРЕДЛОГ' then begin DecStr:=SetPredlog(DecStr);        Goto Ex; end;
    end;
                                     

    {Системная команда: информационное окно}
    If Cmd = 'ИНФО'              then begin DecStr:=FMsgDlg(DecStr, Prm);         Goto Ex; end;
    {Системная команда: ввод текста}
    If Cmd = 'ВВОД'              then begin DecStr:=FInpDlg(DecStr, Prm);         Goto Ex; end;


    {Команда: вырезает из ФИО инициалы}
    If Cmd = 'ИНИЦИАЛЫ'          then begin DecStr:=FIO_Initialy(DecStr, true);   Goto Ex; end;
    {Команда: склоняет ФИО}
    If Cmd = 'ПАДЕЖ ФИО'         then begin DecStr:=PadegFIO('', DecStr);         Goto Ex; end;
    {Команда: склоняет фразу путем поиска в БД и диалога}
//    If Cmd = 'ПАДЕЖ ДИАЛОГ'      then begin DecStr:=PadegDLG('', DecStr);         Goto Ex; end;
    {Команда: склоняет фразу автоматически}
    If Cmd = 'ПАДЕЖ АВТО'        then begin DecStr:=PadegAUTO('', DecStr);        Goto Ex; end;
    //{Команда: изменяет падеж статуса на указанный}  отключено за ненадобностью
    //If Cmd = 'ПАДЕЖ СТАТУСА'     then begin DecStr:=PadegSTATUS(@FFMAIN.BSET_GLOBAL.TLSTATUS, '', DecStr);      Goto Ex; end;


    {**************************************************************************}
    {************  FunDecoder_DateTime:   Д А Т А   И   В Р Е М Я  ************}
    {**************************************************************************}
    If Cmd = 'ДАТАВРЕМЯ'         then begin DecStr:=FDateTimeNow(Prm);            Goto Ex; end;
    If Cmd = 'ДАТА'              then begin DecStr:=FDateNow(Prm);                Goto Ex; end;
    If Cmd = 'ВРЕМЯ'             then begin DecStr:=FTimeNow(Prm);                Goto Ex; end;

    If Cmd = 'ДАТАВРЕМЯ В ТЕКСТ' then begin DecStr:=SDateTimeToStr(DecStr, Prm);  Goto Ex; end;  //2-й параметр - текст в конце даты
    If Cmd = 'ДАТА В ТЕКСТ'      then begin DecStr:=SDateToStr(DecStr, '');       Goto Ex; end;  //2-й параметр - текст в конце
    If Cmd = 'ВРЕМЯ В ТЕКСТ'     then begin DecStr:=STimeToStr(DecStr);           Goto Ex; end;
    If Cmd = 'ГОД'               then begin DecStr:=CutYearStr(DecStr);           Goto Ex; end;
    If Cmd = 'ЧАСЫ'              then begin DecStr:=CutHourStr(DecStr);           Goto Ex; end;
    If Cmd = 'МИНУТЫ'            then begin DecStr:=CutMinutStr(DecStr);          Goto Ex; end;


    Goto Ex0;

Ex: {Возвращаемый результат}
    Result:=true;

Ex0:{Освобождаем память}
    SetLength(Prm,  0);                          
end;


{==============================================================================}
{================     ФУНКЦИЯ: ВЫРЕЗАЕТ ИЗ СПИСКА СТРОКУ     ==================}
{==============================================================================}
function TDECOD.FCutLines(const DecStr: String; const Num: Integer): String;
var SList: TStringList;
begin
    {Инициализация}
    Result:='';
    If Num<1 then Exit;
    SList:=TStringList.Create;
    try
       SList.Text:=DecStr;
       If SList.Count>=Num then Result:=SList[Num-1];
    finally
       SList.Free;
    end;
end;



{==============================================================================}
{==============            ФУНКЦИЯ: УСТАНОВКА СТРОКИ           ================}
{==============================================================================}
function TDECOD.FSetStr(const Kod: String): String;
begin
    {Инициализация}
    Result := Kod;

    {Удаляем !( и ) }
    Delete(Result, 1, 2);
    Delete(Result, Length(Result), 1);

    {Обрезаем возможные кавычки}
    If Length(Result)>1 then begin
       If (Result[1]=CH_KAV) and (Result[Length(Result)]=CH_KAV) then begin
          Delete(Result, 1,              1);
          Delete(Result, Length(Result), 1);
       end;
    end;
end;



{==============================================================================}
{==============             ФУНКЦИЯ: ПОИСК ТЕКСТА              ================}
{==============================================================================}
{==============  Prm[0]   - Просматриваемая строка             ================}
{==============  Prm[1..] - Искомые строки без учета регистра  ================}
{==============  Выход    - TRUE, FALSE                        ================}
{==============================================================================}
function TDECOD.FFindPrm(const Prm: array of String): String;
var S : String;
    I : Integer;
begin
    {Инициализация}
    Result := 'FALSE';
    S:=Trim(Prm[0]);

    {Поочередное сравнение}
    For I:=1 to Length(Prm)-1 do begin
       If (FindStr(Trim(Prm[I]), S)>0) or ((Prm[I]='') and (S='')) then begin
          Result:='TRUE';
          Break;
       end;
    end;
end;


{==============================================================================}
{==============     ФУНКЦИЯ: ТЕКСТ В ЗАВИСИМОСТИ ОТ ПОЛА     ==================}
{==============================================================================}
function TDECOD.FSexPrm(const DecStr: String; const Prm: array of String): String;
var SexMen, SexFam: String;
begin
    {Инициализация}
    Result:='';
    If Length(Prm)>0 then SexMen  := Prm[Low(Prm)]   else SexMen  := '';
    If Length(Prm)>1 then SexFam  := Prm[Low(Prm)+1] else SexFam  := '';

    {Выбираем текст в зависимости от пола}
    If GetSexFIO(DecStr) then Result:=SexMen else Result:=SexFam;
end;


{==============================================================================}
{==============             ФУНКЦИЯ: ОКНО СООБЩЕНИЯ          ==================}
{==============================================================================}
{==============  [1-й параметр]: Тип диалога                 ==================}
{==============  [2-й параметр]: Текст сообщения             ==================}
{==============  [3-й параметр]: Возращаемое значение ДА     ==================}
{==============  [4-й параметр]: Возращаемое значение НЕТ    ==================}
{==============================================================================}
function TDECOD.FMsgDlg(const DecStr: String; const Prm: array of String): String;
var DlgType : TMsgDlgType;
    Buttons : TMsgDlgButtons;
    Msg     : String;
    Res     : Word;
begin
    {Инициализация}                  
    Result  := '';

    {Определяем тип диалога}
    DlgType := mtInformation;
    If Length(Prm)>0 then begin
       If Prm[0]='' then DlgType := mtInformation else
       Case Prm[0][1] of
       '1': DlgType := mtWarning;
       '2': DlgType := mtError;
       '3': DlgType := mtInformation;
       '4': DlgType := mtConfirmation;
       '5': DlgType := mtCustom;
       end;
    end;

    {Определяем сообщение}
    Msg:=DecStr;
    If Length(Prm)>1 then Msg:=Prm[1];

    {Определяем кнопки}
    Buttons := [mbOk];
    If Length(Prm)>3 then Buttons := [mbYes, mbNo];

    {Окно диалога}
    Res:=MessageDlg(Msg, DlgType, Buttons, 0);

    If Length(Prm)>3 then begin
       If Res=mrYes then Result:=Prm[2]
                    else Result:=Prm[3];
    end;
end;


{==============================================================================}
{==============           ФУНКЦИЯ: ОКНО ВВОДА ТЕКСТА         ==================}
{==============================================================================}
{==============  [1-й параметр]: Заголовок окна              ==================}
{==============  [2-й параметр]: Текст пояснения             ==================}
{==============  [3-й параметр]: Текст по умолчанию          ==================}
{==============================================================================}
function TDECOD.FInpDlg(const DecStr: String; const Prm: array of String): String;
//var Dlg: TLMDInputDlg;
begin
//    {Инициализация}
//    Result := '';
//    Dlg    := TLMDInputDlg.Create(nil);
//    try
//
//       {Определяем заголовок окна}
//       If Length(Prm)>0 then Dlg.CaptionTitle:=Prm[0] else Dlg.CaptionTitle:='';
//
//       {Определяем текст пояснения}
//       If Length(Prm)>1 then Dlg.Prompt:=Prm[1] else Dlg.Prompt:='';
//
//       {Определяем текст по умолчанию}
//       If Length(Prm)>2 then Dlg.DefaultValue:=Prm[2] else Dlg.DefaultValue:='';
//
//       {Другие настройки}
//       Dlg.DefaultSelected:=true;
//
//       {Диалог}
//       If Not Dlg.Execute then Exit;
//
//       Result:=Dlg.Value;
//
//    finally
//       Dlg.Free;
//    end;
end;



{==============================================================================}
{========================  ФУНКЦИЯ: КОД СТРОКИ  ===============================}
{==============================================================================}
function TDECOD.FKodChr(const Prm: array of String): String;
var I: Integer;
    Kod: String;
begin
    {Проверка условий на допустимость}
    Result:='';
    Kod:=GetPrm(Prm, 0);
    If Kod = '' then Exit;
    For I:=1 to Length(Kod) do begin
       If IsNumeric(Kod[I])=false then Exit;
    end;

    {Получаем код}
    I:=StrToInt(Kod);
    If I<0 then Exit;

    {Возвращаем результат}
    Result:=Chr(I);
end;



{==============================================================================}
{===============      Устанавливает заглавные буквы      ======================}
{==============================================================================}
{===============  Prm[0]='1' - заглавная только 1 буква  ======================}
{==============================================================================}
function TDECOD.MyCharUpper(const StrKod: String; const Prm: array of String): String;
var StrKodUp: String;
begin
    {Если букв нет, то выход}
    Result:=StrKod;
    If Result='' then Exit;

    {Инициализация}
    StrKodUp:=AnsiUpperCase(StrKod);

    {Устанавливаем заглавные буквы согласно параметру}
    If GetPrm(Prm,0)='1' then Result[1]:=StrKodUp[1] {Заглавная только первая буква}
                         else Result:=StrKodUp;      {Все буквы заглавные}
end;


{==============================================================================}
{=========  Разбивает код [Kod] на команду [Cmd] и параметры [Prm]  ===========}
(*========  в параметрах в '...' и {...} можно исп-ть любые символы ==========*)
{=========  Cmd - в заглавный регистр; Prm - регистр не меняем      ===========}
{=========  используется в модулях декодера                         ===========}
{==============================================================================}
procedure TDECOD.SeparatKod(const Kod: String; var Cmd: String; var Prm: TArrayStr);
var PsStr : TStringList;
    I, I0 : Integer;
    S, S0 : String;
begin
    {Команда -> Cmd}
    S   := Trim(Kod);
    Cmd := AnsiUpperCase(Trim(CutSlovo(S, 1, '(')));

    {Отрезаем с конца строки возможные #$0Dh и #$0Ah}
    S:=CutEndStr(S);

    {*** Отрезаем от строки S: Cmd и крайние скобки ***************************}
    Delete (S, 1, Length(Cmd));
    S := Trim(S);
    Delete(S, 1, 1);
    Delete(S, Length(S), 1);
    S := Trim(S);

    {Заменяем в строке S блоки псевдо-операторами: |%N|%}
    PsStr  := TStringList.Create;
    try
       S := ReplPsevdoModul(S, PsStr, CH_KAV, CH_KAV);
       S := ReplPsevdoModul(S, PsStr, '{', '}');
       S := ReplStr(S, ',', ' , ');                 // т.к. ',,a' воспринимается как а

       {*** Формируем список операндов SOper0 ************************************}
       SetLength(Prm, 0);
       For I:=1 to GetColPSlovStr(S, ',') do begin
          S0:=Trim(CutPSlovoStr(S, I, ','));

          {Производим в слове S0 обратную замену}
          For I0:=PsStr.Count-1 downto 0 do S0:=ReplStr(S0, PsStr.Names[I0], PsStr.Values[PsStr.Names[I0]]);

          {Обрезаем кавычки и скобки в неизменяемом блоке}
          If Length(S0)>1 then begin
///             If (S0[1]='{')    and (S0[Length(S0)]='}') then ShowMessage('Возможна ошибка: '+S0);
             If (S0[1]=CH_KAV) and (S0[Length(S0)]=CH_KAV) then begin
///             If ((S0[1]=CH_KAV) and (S0[Length(S0)]=CH_KAV)) or
///                ((S0[1]='{')    and (S0[Length(S0)]='}'))    then begin
                Delete(S0, 1,          1);
                Delete(S0, Length(S0), 1);
                S0:=ReplStr(S0, ' ,', ',');      // возвращаем изменения
             end;
          end;

          {Запоминаем значение}
          SetLength(Prm, Length(Prm)+1);
          Prm[High(Prm)]:=S0;
       end;
    finally
       PsStr.Free;
    end;
end;


{==============================================================================}
{========================  Корректно читает параметр  =========================}
{==============================================================================}
{========================            Ind с 0          =========================}
{==============================================================================}
function TDECOD.GetPrm(const Prm: array of String; const Ind: Integer): String;
begin
    Result:='';
    If (Length(Prm)-1)<Ind then Exit;
    Result:=Prm[Ind];
end;


