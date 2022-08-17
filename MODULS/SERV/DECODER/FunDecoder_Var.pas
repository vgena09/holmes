{==============================================================================}
{=============         ДОПОЛНИТЕЛЬНЫЙ  МОДУЛЬ  ДЕКОДЕРА          ==============}
{==============================================================================}
{=============                   Kod = Операнд                   ==============}
{==============================================================================}
function TDECOD.DopDecoderVar(var DecStr: String; const Kod: String): Boolean;
var L1, L2, L3    : TStringList;
    VType, Filter : String;
    Cmd, Prm0     : String;
    Prm           : TArrayStr;
    S             : String;
    I, I0, I1     : Integer;
    D             : TDateTime;
begin
    {Инициализация}
    Result := false;

    {Разбивает код [Kod] на команду [Cmd] и параметры [Prm]}
    If Kod = '' then Exit;
    SeparatKod(Kod, Cmd, Prm);
    If Length(Prm) > 0 then Prm0 := AnsiUpperCase(Prm[Low(Prm)]) else Prm0:='';
    try

       {УПРАВЛЯЮЩИЕ КОМАНДЫ}
//     If Cmd ='СОЗДАТЬ ПЕРЕМЕННУЮ'  then begin DecStr:=FVarAdd(PVAR, Prm);         Result:=true; Exit; end;
       If Cmd ='ИЗМЕНИТЬ ПЕРЕМЕННУЮ' then begin DecStr:=FVarChange(Prm);            Result:=true; Exit; end;
//     If Cmd ='УДАЛИТЬ ПЕРЕМЕННУЮ'  then begin DecStr:=FVarDel(PVAR, Prm);         Result:=true; Exit; end;
//     If Cmd ='СОХРАНИТЬ ЗНАЧЕНИЕ'  then begin DecStr:=FSavVal(DecStr, PVAR, Prm); Result:=true; Exit; end;
//     If Cmd ='СОХРАНИТЬ ЭЛЕМЕНТ'   then begin DecStr:=FSavRec(PVAR, PUD, Prm);    Result:=true; Exit; end;
       If Cmd ='ДОБАВИТЬ ПРИМЕЧАНИЕ' then begin Result:=FDocAddHint(Prm[Low(Prm)]); DecStr:='';   Exit; end;
       If Cmd ='КОНТРОЛЬ СРОКА'      then begin Result:=FDocControlTerm(Prm);       DecStr:='';   Exit; end;
       If Cmd ='КОНТРОЛЬ ДАТЫ'       then begin Result:=FDocControlDate(Prm);       DecStr:='';   Exit; end;
       If Cmd ='ЗАГОЛОВОК ДОКУМЕНТА' then begin Result:=FDocCaption(Prm);           DecStr:='';   Exit; end;

       If Cmd ='ЗНАЧЕНИЕ ПЕРЕМЕННОЙ' then begin DecStr:=FVarVal(Prm);               Result:=true; Exit; end;
       If Cmd ='ПЕРЕМЕННАЯ ПУСТА'    then begin DecStr:=FVarEmpty(Prm);             Result:=true; Exit; end;
//    If Cmd ='НАЛИЧИЕ ПЕРЕМЕННОЙ'  then begin DecStr:=FVarExsists (PVAR, @T_VAR, Prm); Result:=true; Exit; end;

       {Список параметров заглавными буквами}
       Prm:=UpperArrayStr(Prm);
       //If Length(Prm) > 0 then Prm0:=Prm[Low(Prm)] else Prm0:='';

       {Ищем переменную по ее имени: сначала TVAR, потом TVAR_COMMON}
       PVAR := VarFind(Cmd);
       If PVAR = nil then Exit;

       // PVAR^.First;


       {Создаем список для хранения значения переменной}
       L1 := TStringList.Create;
       L2 := TStringList.Create;
       L3 := TStringList.Create;
       try
          VType   := AnsiUpperCase(Trim(PVAR^.FieldByName(F_VAR_TYPE).AsString)); // Тип переменной
          L1.Text := PVAR^.FieldByName(F_VAR_VAL_STR).AsString;                   // Значение переменной

          {********************  Для UD переменной   **************************}
          If CmpStrList(VType, [F_VAR_TYPE_UD]) >= 0 then begin
             DecStr := '';
             If L1.Count > 0 then begin
                {Определяем таблицу}
                If Length(Prm) > 0 then S := Prm[0]
                                   else S := CutSlovo(L1[0], 1, '.');
                If not SetDecoderTable(S) then Exit;

                {Определяем элементы в L1}
                LKeySel(@L1, S);                              // L1.Count = 0 не ошибка
                If Length(Prm) > 1 then begin
                   If not IsIntegerStr(Prm[1]) then Exit;
                   I := StrToInt(Prm[1]);
                   If (I < 0) or (I > L1.Count) then Exit;
                   If I <> 0 then L1.Text := L1[I - 1];       // I = 0 все элементы
                end;

                {Формируем фильтр}
                Filter := '';
                For I0 := 0 to L1.Count-1 do
                   Filter:=Filter+' OR (['+F_COUNTER+']='+Trim(CutSlovo(L1[I0], 2, '.'))+')';
                Delete(Filter, 1, 4);
                SetDBFilter(PUD, Filter);
                PUD^.First;

             {L1.Count = 0 не ошибка}
             end else begin
                PUD := nil;
             end;

             Result:=true;
             Exit;
          end;

          {*****************  Для DATE переменной  ****************************}
          If CmpStrList(VType,[F_VAR_TYPE_DATE])>=0 then begin
             If (L1.Count>0) then DecStr:=L1.Strings[0];
             {Коррекция}
             try
                If Length(Prm)>=1 then S:=Prm[0] else S:='0'; If IsIntegerStr(S) then I  := StrToInt(S) else I  := 0; // Месяцы
                If Length(Prm)>=2 then S:=Prm[1] else S:='0'; If IsIntegerStr(S) then I0 := StrToInt(S) else I0 := 0; // Дни
                If Length(Prm)>=3 then S:=Prm[2] else S:='0'; If IsIntegerStr(S) then I1 := StrToInt(S) else I1 := 0; // Часы
                If (I <> 0) or (I0 <> 0) or (I1 <> 0) then begin
                   D := StrToDateTime(DecStr);
                   D := DateTimeCorrect(D, 0, I, I0, I1, 0);
                   DecStr := DateTimeToStr(D);
                end;
             except end;
             Result:=true;
             Exit;
          end;


          {*****************  Для EDIT, RIGHT переменной  *********************}
          If CmpStrList(VType,[F_VAR_TYPE_EDIT])>=0 then begin
             If (L1.Count>0) then DecStr:=L1.Strings[0];
             Result:=true;
             Exit;
          end;


          {**********************  Для MEMO переменной  ***********************}
          If CmpStrList(VType,[F_VAR_TYPE_MEMO, F_VAR_TYPE_SELECT])>=0 then begin
             DecStr:=CutEndStr(L1.Text);  // Удаляем 0Dh+0Ah, т.к. в Word меняется выравнивание параграфа
             Result:=true;
             Exit;
          end;

          {*******************  Для EXPERT переменной   ***********************}
          If CmpStrList(VType,[F_VAR_TYPE_EXPERT])>=0 then begin
             DecStr:='';
             If Length(Prm)>=1 then S:=Prm[0] else S:='ЭКСПЕРТИЗА';

             {Если параметр - экспертиза}
             If CmpStr(S, 'ЭКСПЕРТИЗА') then begin
                {Копируем секцию названий экспертиз}
                LSectionCopy(@L1, @L2, F_VAR_STR_EXPERT_EXP);
                {Если экспертиза не задана}
                If L2.Count=0 then DecStr:='___________________ экспертиза';
                {Если задана 1 экспертиза}
                If L2.Count=1 then DecStr:=L2[0];
                {Если комплексаная экспертиза}
                If L2.Count>1 then begin
                   For I:=0 to L2.Count-1 do DecStr:=DecStr+L2[I]+', ';
                   Delete(DecStr, Length(DecStr)-1, 2);
                   DecStr:='комплексная экспертиза ('+DecStr+')';
                end;
                Result:=true;
             end;
             {Если параметр - вопросы}
             If CmpStr(S, 'ВОПРОСЫ') then begin
                {Копируем секцию вопросов}
                LSectionCopy(@L1, @L2, F_VAR_STR_EXPERT_QST);
                DecStr:=CutEndStr(L2.Text); // Удаляем 0Dh+0Ah, т.к. в Word в конце пустой вопрос
                Result:=true;
             end;
             {Если параметр - вопросы}
             If CmpStr(S, 'МАТЕРИАЛЫ') then begin
                {Просматриваем материалы}
                For I:=Low(LTAB_MAT) to High(LTAB_MAT) do begin
                   {Получаем список индексов}
                   LSectionCopy(@L1, @L2, F_VAR_STR_EXPERT_MAT);
                   LElementCopyKey(@L2, @L3, LTAB_MAT[I]);
                   {Если имеются записи}
                   If L3.Count=0 then Continue;
                   {Для Физических лиц}
                   If CmpStr(LTAB_MAT[I], T_UD_PPERSON) then begin
                         //  {Читаем названия экспертиз}
                         //  LSectionCopy(@L1, @L2, F_VAR_STR_EXPERT_EXP);
                         //  {Освидетельствование, исследование трупа}
                         //  If (Pos('МЕДИЦ',  AnsiUpperCase(L2.Text)) > 1) or
                         // (Pos('ПСИХ',   AnsiUpperCase(L2.Text)) > 1) then
                         For I0:=0 to L3.Count-1 do DecStr:=DecStr+'возможность освидетельствовать '+IDToTxt(@FFMAIN.BUD, T_UD_PPERSON+'.'+L3[I0], ['В'])+';'+CH_NEW;
                         Continue;
                   end;
                   {Для объектов}
                   If CmpStrList(LTAB_MAT[I], [T_UD_OBJECT])>=0 then begin
                      For I0:=0 to L3.Count-1 do DecStr:=DecStr+LowerStrPart(IDToTxt(@FFMAIN.BUD, T_UD_OBJECT+'.'+L3[I0], []), 1, 1)+';'+CH_NEW;
                   end;
                end;
                Delete(DecStr, Length(DecStr)-2, 3);
                Result:=true;
             end;
             Exit;
          end;


          {**********************  Для REST переменной  ***********************}
          If CmpStrList(VType,[F_VAR_TYPE_REST])>=0 then begin
             If Length(Prm) <> 2 then Exit;
             {Параметр 1}
             If Prm[0] = '' then Prm[0] := '1';
             If not IsIntegerStr(Prm[0]) then Exit;
             I := StrToInt(Prm[0]);
             {Параметр 2}
             If Prm[1] = ''       then Prm[1] := '1';
             If Prm[1] = 'ФИО'    then Prm[1] := '1';
             If Prm[1] = 'СТАТУС' then Prm[1] := '2';
             If Prm[1] = 'МЕСТО'  then Prm[1] := '3';
             If not IsIntegerStr(Prm[1]) then Exit;
             I0 := StrToint(Prm[1]);
             {Значение}
             I := ((I - 1) * 3) + (I0 - 1);
             If I < L1.Count
             then DecStr := CutEndStr(L1[I])  // Удаляем 0Dh+0Ah, т.к. в Word меняется выравнивание параграфа
             else DecStr := '';
             Result:=true;
             Exit;
          end;

          {**********************  Для OLE переменной  ************************}
          If CmpStrList(VType,[F_VAR_TYPE_OLE])>=0 then begin
             {Для комплексной OLE-переменной}
             If IsStrInArray(Prm0, ['', 'БЛОК']) then begin
                DecStr := '';
                IsOLE  := true;
                Result := FieldOleToClipboard(FFMAIN, PADODataSet(PVAR));
                Exit;
             end;

             {Для комплексной текстовой-переменной}
             If IsStrInArray(Prm0, ['И','Р','Д','В','Т','П']) then begin
                L2.Text:=PVAR^.FieldByName(F_VAR_VAL_STR).AsString;
                If (Prm0='И') and (L2.Count>0) then begin
                   DecStr:=L2[0];
                   Result:=true;
                   Exit;
                end;
                If (Prm0='Р') and (L2.Count>1) then begin
                   DecStr:=L2[1];
                   Result:=true;
                   Exit;
                end;
                If (Prm0='Д') and (L2.Count>2) then begin
                   DecStr:=L2[2];
                   Result:=true;
                   Exit;
                end;
                If (Prm0='В') and (L2.Count>3) then begin
                   DecStr:=L2[3];
                   Result:=true;
                   Exit;
                end;
                If (Prm0='Т') and (L2.Count>4) then begin
                   DecStr:=L2[4];
                   Result:=true;
                   Exit;
                end;
                If (Prm0='П') and (L2.Count>5) then begin
                   DecStr:=L2[5];
                   Result:=true;
                   Exit;
                end;
             end;
             Exit;
          end;
          {********************************************************************}
       finally
          L1.Free; L2.Free; L3.Free;
       end;
    finally
       SetLength(Prm, 0);
    end;
end;


{==============================================================================}
{===================   НАЙТИ ПЕРЕМЕННУЮ ПО ИМЕНИ   ============================}
{==============================================================================}
function TDECOD.VarFind(const VarName: String): PADOTable;
begin
    Result := nil;

    {Ищем в TVAR}
    If ID_DOC <> '' then begin
       SetDBFilter(@TVAR, '(['+F_VAR_DOC+']='+ID_DOC+' AND ['+F_VAR_NAME+']='+QuotedStr(VarName)+') OR (['+F_VAR_DOC+']=NULL AND ['+F_VAR_NAME+']='+QuotedStr(VarName)+')');
       //SetDBFilter(@TVAR, '['+F_VAR_DOC+']='+ID_DOC+' AND ['+F_VAR_NAME+']='+QuotedStr(VarName));
       If TVAR.RecordCount = 1 then begin Result := @TVAR; Exit; end;
    end;

    {Ищем в TVAR_COMMON}
    SetDBFilter(@TVAR_COMMON, '['+F_VAR_NAME+']='+QuotedStr(VarName));
    If TVAR_COMMON.RecordCount = 1 then Result := @TVAR_COMMON;
end;


{==============================================================================}
{==========             КОМАНДА: STR-ЗНАЧЕНИЕ ПЕРЕМЕННОЙ            ===========}
{==============================================================================}
{==========              1-й параметр  : Имя переменной             ===========}
{==============================================================================}
function TDECOD.FVarVal(const Prm: TArrayStr): String;
begin
    Result := '';
    If Length(Prm)=0 then Exit;
    PVAR := VarFind(Prm[Low(Prm)]);
    If PVAR = nil then Exit;
    Result := PVAR^.FieldByName(F_VAR_VAL_STR).AsString;
end;


{==============================================================================}
{==========        КОМАНДА: ПУСТО ЛИ STR-ЗНАЧЕНИЕ ПЕРЕМЕННОЙ        ===========}
{==============================================================================}
{==========              1-й параметр  : Имя переменной             ===========}
{==============================================================================}
function TDECOD.FVarEmpty(const Prm: TArrayStr): String;
begin
    Result := 'FALSE';
    If Length(Prm)=0 then Exit;
    PVAR := VarFind(Prm[Low(Prm)]);
    If PVAR = nil then Exit;
    If PVAR^.FieldByName(F_VAR_VAL_STR).AsString = '' then Result := 'TRUE';
end;

{==============================================================================}
{==========        КОМАНДА: ИЗМЕНИТЬ ПЕРЕМЕННУЮ ТАБЛИЦЫ TVAR        ===========}
{==============================================================================}
{==========   1-й параметр  : Имя переменной                        ===========}
{==========  [2-й параметр] : Название изменяемого поля БД          ===========}
{==========  [3-й параметр] : Новое значение поля                   ===========}
(*=========  '|+' замена на '{', '|-' замена на '}'                 ==========*)
{==============================================================================}
function TDECOD.FVarChange(const Prm: TArrayStr): String;
var T : TADOTable;
    SNam, SFld, SVal : String;
begin
    {Инициализация}
    Result := '';
    If (Length(Prm) < 1) or (ID_DOC = '') then Exit;

    {Установка параметров}
    SNam  := Trim(Prm[Low(Prm)]); If SNam = '' then Exit;
    If Length(Prm) > 1 then SFld := Trim(Prm[Low(Prm)+1]) else SFld := ''; If SFld = '' then SFld := F_VAR_VAL_STR;
    If Length(Prm) > 2 then SVal := Trim(Prm[Low(Prm)+2]) else SVal := ''; If SVal = '' then SVal := '';
    SVal := ReplStr(SVal, '|+', '{');
    SVal := ReplStr(SVal, '|-', '}');

    T := LikeTable(@TVAR);
    try
       {Настройка таблицы}
       SetDBFilter(@T, '(['+F_VAR_DOC+']='+ID_DOC+' AND ['+F_VAR_NAME+']='+QuotedStr(SNam)+') OR (['+F_VAR_DOC+']=NULL AND ['+F_VAR_NAME+']='+QuotedStr(SNam)+')');
       //SetDBFilter(@T, '['+F_VAR_DOC+']='+ID_DOC+' AND ['+F_VAR_NAME+']='+QuotedStr(SNam));
       If T.RecordCount < 1 then Exit;
       T.RecNo := 1;

       {Выбираем эту же запись по ключу, т.к. имя можно поменять}
       SetDBFilter(@T, '['+F_COUNTER+']='+T.FieldByName(F_COUNTER).AsString);

       {Запись значения}
       With T do begin
          Edit;
          FieldByName(SFld).AsString := SVal;
          UpdateRecord;
          Post;
       end;
    finally
       DestrTable(@T);
       SetDBFilter(@TVAR, ''); // Таблица может быть спозиционирована по имени, а имя изменено
       TVAR.Close; TVAR.Open;  // RefreshTable(@TVAR); выдает ошибку при первом документе
    end;
end;



{==============================================================================}
{============        КОМАНДА: ДОБАВИТЬ ПРИМЕЧАНИЕ ДОКУМЕНТА        ============}
{==============================================================================}
function TDECOD.FDocAddHint(const SText: String): Boolean;
var S: String;
begin
    Result := false;
    If SText = '' then begin Result := true; Exit; end;
    try
       With TDOC do begin
          If RecordCount <> 1 then Exit;
          Edit;
          S := FieldByName(F_UD_DOC_HINT).AsString;
          If S <> '' then S := S + CH_NEW + CH_NEW;
          S := S + SText;
          FieldByName(F_UD_DOC_HINT).AsString := S;
          UpdateRecord;
          Post;
       end;
       RefreshTable(@TDOC);
       Result := true;
    finally
    end;
end;


{==============================================================================}
{=================    КОМАНДА: КОНТРОЛЬ СРОКА ДОКУМЕНТА      ==================}
{==============================================================================}
{===== 1 параметр - дата-время, относительно которs[ устанавливается срок  ====}
{===== 2-4 параметр - срок в месяцах, днях, часах                          ====}
{==============================================================================}
function TDECOD.FDocControlTerm(const Prm: TArrayStr): Boolean;
var Hours, Days, Months: Integer;
    Dat  : TDatetime;
    SDat : String;

   function GetPrm(const I: Integer): Integer;
   begin
       Result := 0;
       If I >= Length(Prm)         then Exit;
       If not IsIntegerStr(Prm[I]) then Exit;
       Result := StrToInt(Prm[I]);
   end;

begin
    Result := false;
    If TDOC.Filter = '' then Exit;

    SDat := Prm[Low(Prm)];
    If ValidDateTime(SDat) then Dat := StrToDateTime(SDat)
                           else Dat := Now;
    Months := GetPrm(1);
    Days   := GetPrm(2);
    Hours  := GetPrm(3);

    {УПК: если срок исчисляется сутками и месяцами, то с 0 часов следующего дня}
    If (Hours = 0) and ((Months <> 0) or (Days <> 0)) then begin
       Dat := DateTimeCorrect(Dat, 0, 0, 1, 0, 0);
       Dat := Trunc(Dat);
    end;

    {УПК: если срок исчисляется часами, то по истечении часа}
    If (Hours <> 0) and (Months = 0) and (Days = 0) then begin
       Dat := DateTimeCorrect(Dat, 0, 0, 0, 1, 0);
    end;

    try
       With TDOC do begin
          Edit;
          FieldByName(F_UD_DOC_CONTROL).AsDateTime := DateTimeCorrect(Dat, 0, Months, Days, Hours, 0);
          UpdateRecord;
          Post;
       end;
       RefreshTable(@FFMAIN.BUD.TDOC);
       Result := true;
    finally
    end;
end;


{==============================================================================}
{==================    КОМАНДА: КОНТРОЛЬ ДАТЫ ДОКУМЕНТА      ==================}
{==============================================================================}
{===== 1 параметр - дата-время, относительно которs[ устанавливается срок  ====}
{==============================================================================}
function TDECOD.FDocControlDate(const Prm: TArrayStr): Boolean;
var Dat  : TDatetime;
    SDat : String;
begin
    Result := false;
    If TDOC.Filter = '' then Exit;
    If Length(Prm) <> 1 then Exit;
    SDat := Prm[Low(Prm)];

    If ValidDateTime(SDat) then Dat := StrToDateTime(SDat)
                           else Exit;
    try
       With TDOC do begin
          Edit;
          FieldByName(F_UD_DOC_CONTROL).AsDateTime := Dat;
          UpdateRecord;
          Post;
       end;
       RefreshTable(@FFMAIN.BUD.TDOC);
       Result := true;
    finally
    end;
end;


{==============================================================================}
{====================    КОМАНДА: ЗАГОЛОВОК ДОКУМЕНТА      ====================}
{==============================================================================}
function TDECOD.FDocCaption(const Prm: TArrayStr): Boolean;
var S: String;
begin
    Result := false;
    If TDOC.Filter = '' then Exit;
    If Length(Prm) <> 1 then Exit;
    try
       S := Decoder(Trim(Prm[Low(Prm)]));
       With TDOC do begin
          Edit;
          FieldByName(F_UD_DOC_CAPTION).AsString := CutLongStr(S, 145);
          UpdateRecord;
          Post;
       end;
       RefreshTable(@FFMAIN.BUD.TDOC);
       Result := true;
    finally
    end;
end;
