{==============================================================================}
{=============         ДОПОЛНИТЕЛЬНЫЙ  МОДУЛЬ  ДЕКОДЕРА          ==============}
{==============================================================================}
{=============                   Kod = Операнд                   ==============}
{==============================================================================}
function TDECOD.DopDecoderTab(var DecStr: String; const Kod: String): Boolean;
label Ex;
var Cmd : String;
    Prm : TArrayStr;
    S   : String;
begin
    {Инициализация}
    Result := false;
    If Kod = ''  then Exit;

    {Разбивает код [Kod] на команду [Cmd] и параметры [Prm]}
    SeparatKod(Kod, Cmd, Prm);
    try
       {Команды-исключения}
       If CmpStrList(Cmd, ['*', 'ДОБАВИТЬ СОВЕТ', 'УПАКОВКА', 'ИЗМЕНИТЬ ТАБЛИЦУ УД']) < 0 then Prm:=UpperArrayStr(Prm);

       If Cmd = 'ИЗМЕНИТЬ ТАБЛИЦУ УД' then begin DecStr:=''; Result := FUDChange(Prm); Goto Ex; end;
//  If Cmd = 'СТАТУСЫ ПО ДЕЛУ'   then begin DecStr:=FStatus(PUD, '', Prm);    Goto Ex; end;
//  If Cmd = 'МЕРЫ ПО ДЕЛУ'      then begin DecStr:=FMery(PUD, '', Prm);      Goto Ex; end;
       If Cmd = 'СТАТЬИ ДЕЛА'        then begin DecStr:=GetArticles;  Goto Ex; end;
//  If Cmd = 'ВЫБРАТЬ ЭЛЕМЕНТ'   then begin FSelectElement(Prm);              Goto Ex; end;

    {Установка таблицы}
    // If SetDecoderTable(Cmd) then begin DecStr:='';                         Goto Ex; end; - прямо ставить НЕЛЬЗЯ
    If PUD = nil then Exit;

    {Установка указателя на запись/число доступных записей}
//    If FScrollTable(@TUD, Cmd) then begin DecStr:='';                       Goto Ex; end;
    If Cmd='COUNT' then begin DecStr:=IntToStr(PUD^.RecordCount);             Goto Ex; end;

       S:=GetPrm(Prm, 0);


       {=======================================================================}
       {=================   ТАБЛИЦА ДЕКОДЕРА СПОЗИЦИОНИРОВАНА   ===============}
       {=======================================================================}
       If PUD^.RecordCount=0 then Exit;

       {***********************************************************************}
       {*******************  Таблица: T_UD_PPERSON      ***********************}
       {***********************************************************************}
       If CmpStr(PUD^.TableName, T_UD_PPERSON) then begin
          If Cmd = '*'                  then begin DecStr:=FSexText(Prm);     Goto Ex; end;
          If Cmd = 'ФИО'                then begin DecStr:=FFIOPP(S);         Goto Ex; end;
          If Cmd = 'СТАТУС'             then begin DecStr:=FStatus(S);        Goto Ex; end;
          If Cmd = 'СТАТУС МУЖСКОЙ'     then begin DecStr:=FStatus(S, true);  Goto Ex; end;
          If Cmd = 'АДРЕС'              then begin DecStr:=FAdressPP(S);      Goto Ex; end;
          If Cmd = 'РОЖДЕНИЕ'           then begin DecStr:=FRogdeniePP(S);    Goto Ex; end;
          If Cmd = 'ДОКУМЕНТ'           then begin DecStr:=FDocumentPP(S);    Goto Ex; end;
          If Cmd = 'ВОЗРАСТ'            then begin DecStr:=FVozrastPP(S);     Goto Ex; end;
       end;


       {***********************************************************************}
       {*******************  Таблица: T_UD_LPERSON      ***********************}
       {***********************************************************************}
       If CmpStr(PUD^.TableName, T_UD_LPERSON) then begin
          If Cmd = 'НАИМЕНОВАНИЕ'       then begin DecStr:=NameLP(S);         Goto Ex; end;
          If Cmd = 'НАИМЕНОВАНИЕ СОКР'  then begin DecStr:=NameShortLP(S);    Goto Ex; end;
          If Cmd = 'СТАТУС'             then begin DecStr:=FStatus(S, true);  Goto Ex; end;
          If Cmd = 'РУКОВОДИТЕЛЬ'       then begin DecStr:=FFIOSherifLP(S);   Goto Ex; end;
       end;


       {***********************************************************************}
       {********************  Таблица: T_UD_DPERSON      **********************}
       {***********************************************************************}
       If CmpStr(PUD^.TableName, T_UD_DPERSON) then begin
          If Cmd = '*'                  then begin DecStr:=FSexText(Prm);     Goto Ex; end;
          If Cmd = 'ФИО'                then begin DecStr:=FFIODP(S);         Goto Ex; end;
          If Cmd = 'СТАТУС'             then begin DecStr:=FStatus(S);        Goto Ex; end;
          If Cmd = 'СТАТУС МУЖСКОЙ'     then begin DecStr:=FStatus(S, true);  Goto Ex; end;
          If Cmd = 'ДОКУМЕНТ'           then begin DecStr:=FDocumentDP(S);    Goto Ex; end;
      end;

       {***********************************************************************}
       {********************  Таблица: T_UD_OBJECT       **********************}
       {***********************************************************************}
       If CmpStr(PUD^.TableName, T_UD_OBJECT) then begin
          If Cmd = 'УПАКОВКА'           then begin DecStr:=FObjectsPack(S);   Goto Ex; end;
       end;

       If IsField(Cmd)                  then begin DecStr:=ReadField(Cmd, S); Goto Ex; end;
       If Cmd = 'ТАБЛИЦА'               then begin DecStr:=PUD^.TableName;    Goto Ex; end;
       If Cmd = 'РЕДАКТИРОВАТЬ ЭЛЕМЕНТ' then begin FEditElement;              Goto Ex; end;
       Exit;

Ex:    Result:=true;
    finally
       SetLength(Prm,  0);
    end;
end;


{==============================================================================}
{====================  УСТАНАВЛИВАЕТ ТАБЛИЦУ ДЕКОДЕРА  ========================}
{==============================================================================}
function TDECOD.SetDecoderTable(const TName: String): Boolean;
begin
    Case FindStrInArray(TName, LTAB_UD) of
    LTAB_UD_PPERSON: PUD := @TPPERSON;
    LTAB_UD_LPERSON: PUD := @TLPERSON;
    LTAB_UD_DPERSON: PUD := @TDPERSON;
    LTAB_UD_OBJECT:  PUD := @TOBJECT;
    else PUD := nil;
    end;
    Result := PUD <> nil;
//    If Result then begin
//       PUD^.Filtered := false;
//       PUD^.Filter   := '';
//    end;
end;


{==============================================================================}
{==============     УСТАНАВЛИВАЕТ ЗАПИСЬ ТАБЛИЦЫ ДЕКОДЕРА     =================}
{==============================================================================}
{==============    Result=true - когда установлена 1 запись   =================}
{==============================================================================}
function TDECOD.SetDecoderKey(const Key: String): Boolean;
begin
    {Инициализация}
    Result := false;
    If not IsIntegerStr(Key) then Exit;
    If PUD = nil             then Exit;

    {Существует ли запись}
    SetDBFilter(PUD, '['+F_COUNTER+']='+Key);
    Result := (PUD^.RecordCount = 1);
    PUD^.First;
end;


{==============================================================================}
{=================  ЯВЛЯЕТСЯ ЛИ TABLE НАЗВАНИЕМ ТАБЛИЦЫ УД  ===================}
{==============================================================================}
function TDECOD.IsTableUD(const Table: String): Boolean;
begin
    Result := IsStrInArray(Table, LTAB_UD);
end;


{==============================================================================}
{==========   КОМАНДА: ИЗМЕНИТЬ ЭЛЕМЕНТЫ УД, ЗАДАННЫЕ ПЕРЕМЕННОЙ    ===========}
{==============================================================================}
{==========   1-й параметр  : переменная УД                         ===========}
{==========   2-й параметр  : поле                                  ===========}
{==========   3-й параметр  : значение                              ===========}
(*=========  '|+' замена на '{', '|-' замена на '}'                 ==========*)
{==============================================================================}
function TDECOD.FUDChange(const Prm: TArrayStr): Boolean;
var SVar, SFld, SVal : String;
    STab, SKey : String;
    P : PADOTable;
    T : TADOTable;
    I : Integer;
    L : TStringList;
begin
    {Инициализация}
    Result := false;
    If Length(Prm) < 3 then Exit;

    {Установка параметров}
    SVar := Trim(Prm[Low(Prm)+0]);    If SVar = '' then Exit;
    SFld := Trim(Prm[Low(Prm)+1]);    If SFld = '' then Exit;
    SVal := Trim(Prm[Low(Prm)+2]);    If SVal = '' then Exit;
    SVal := ReplStr(SVal, '|+', '{');
    SVal := ReplStr(SVal, '|-', '}');
    P    := VarFind(SVar);            If P = nil   then Exit;

    T    := TADOTable.Create(nil);
    L    := TStringList.Create;
    try
       T.Connection := FFMAIN.BUD.BD;
       L.Text := P^.FieldbyName(F_VAR_VAL_STR).AsString; If L.Count = 0 then Exit;

       {Просматриваем все ссылки на УД}
       For I := 0 to L.Count-1 do begin
          STab := CutSlovo(L[I], 1, '.');        If STab = '' then Continue;
          SKey := CutSlovoEndChar(L[I], 1, '.'); If SKey = '' then Continue;

          T.TableName := STab;
          SetDBFilter(@T, '['+F_COUNTER+']='+SKey);
          With T do begin
             Open;
             If RecordCount <> 1 then begin Close; Continue; end;
             Edit;
             FieldByName(SFld).AsString := SVal;
             UpdateRecord;
             Post;
             Close;
          end;
       end;
       Result := true;
    finally
       L.Free;
       DestrTable(@T);
       If PUD <> nil then PUD^.Refresh;
    end;
end;

