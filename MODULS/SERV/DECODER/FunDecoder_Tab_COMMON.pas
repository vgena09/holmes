{******************************************************************************}
{***************           ОПЕРАЦИИ С ТАБЛИЦАМИ УД           ******************}
{***************                ОБЩИЕ ФУНКЦИИ                ******************}
{******************************************************************************}


{==============================================================================}
{==============================  НАЛИЧИЕ ПОЛЯ  ================================}
{==============================================================================}
function TDECOD.IsField(const SField: String): Boolean;
begin
    Result := PUD^.FieldList.IndexOf(SField) > -1;
end;


{==============================================================================}
{==============================  ЧИТАЕТ ПОЛЕ  =================================}
{==============================================================================}
function TDECOD.ReadField(const SField: String; const SCount: String): String;
var ICount, I: Integer;
begin
    Result := Trim(PUD^.FieldByName(SField).AsString);
    If (Result = '') and IsIntegerStr(SCount) then begin
       ICount := StrToInt(SCount);
       For I := 1 to ICount do Result := Result + '_';
    end;
end;


{==============================================================================}
{=======================  ТЕКСТ В ЗАВИСИМОСТИ ОТ ПОЛА   =======================}
{==============================================================================}
{===============  если Prm из 3 параметров - исследуем и число   ==============}
{==============================================================================}
function TDECOD.FSexText(const Prm: TArrayStr): String;
var SexMen, SexFam: String;
begin
    {Инициализация}
    Result := '';

    {Если имеется параметр для множественного числа}
    If Length(Prm) > 2 then begin
       If PUD^.RecordCount > 1 then begin
          Result:=Prm[Low(Prm)+2];
          Exit;
       end;
    end;

    {Стандартный режим}
    If Length(Prm)>0 then SexMen := Prm[Low(Prm)]   else SexMen := '';
    If Length(Prm)>1 then SexFam := Prm[Low(Prm)+1] else SexFam := '';
    If FReadSex then Result:=SexMen else Result:=SexFam;
end;


{==============================================================================}
{==========================  ЧИТАЕТ ИЗ ТАБЛИЦЫ ПОЛ  ===========================}
{==========================      true - мужчина     ===========================}
{==============================================================================}
function TDECOD.FReadSex: Boolean;
begin
    Result := true;
    If CmpStr(PUD^.TableName, T_UD_PPERSON) then Result:=PUD^.FieldByName(PPERSON_SEX).AsBoolean;
    If CmpStr(PUD^.TableName, T_UD_DPERSON) then Result:=PUD^.FieldByName(DPERSON_SEX).AsBoolean;
end;


{==============================================================================}
{=========  ФУНКЦИЯ ДЕКОДЕРА: СТАТУС В ПАДЕЖЕ В ЗАВИСИМОСТИ ОТ ПОЛА  ==========}
{=========              OnlyMan - только мужские статусы             ==========}
{==============================================================================}
function TDECOD.FStatus(const SPadeg: String; const OnlyMan: Boolean = false): String;
const TAB : array[1..3, 1..2] of String = ((PPERSON_STATE, LSTATUS_PPERSON),
                                           (DPERSON_STATE, LSTATUS_DPERSON),
                                           (LPERSON_STATE, LSTATUS_LPERSON));
var T  : TADOTable;
    P  : Array of String;
    ID : Integer;
    S  : String;
    Ch : Char;
begin
    {Инициализация}
    Result := '';
    If CmpStr(PUD^.TableName, T_UD_PPERSON) then ID := 1 else
    If CmpStr(PUD^.TableName, T_UD_DPERSON) then ID := 2 else
    If CmpStr(PUD^.TableName, T_UD_LPERSON) then ID := 3 else Exit;

    {Статус без склонения}
    S := PUD^.FieldByName(TAB[ID][1]).AsString;
    If S = '' then Exit;

    T := LikeTable(@FFMAIN.BSET_GLOBAL.TLSTATUS);
    try
      {Фильтр}
      S := '(['+TAB[ID][2]+']=TRUE) AND (['+LSTATUS_MIP+']='+QuotedStr(S)+')';
      SetDBFilter(@T, S);
      If T.RecordCount <> 1 then Exit;

      {Список статусов}
      P := @LSTATUS_MAN;
      If not OnlyMan then begin
         Case ID of
         1, 2: If not PUD^.FieldByName(PPERSON_SEX).AsBoolean then P := @LSTATUS_FEM;
         end;
      end;

      {Значение}
      If SPadeg<>'' then Ch:=SPadeg[1] else Ch:='И';
      Case Ch of
         'И': Result := T.FieldByName(P[Low(P)+0]).AsString;
         'Р': Result := T.FieldByName(P[Low(P)+1]).AsString;
         'Д': Result := T.FieldByName(P[Low(P)+2]).AsString;
         'В': Result := T.FieldByName(P[Low(P)+3]).AsString;
         'Т': Result := T.FieldByName(P[Low(P)+4]).AsString;
         'П': Result := T.FieldByName(P[Low(P)+5]).AsString;
      end;
    finally
       If T.Active then T.Close; T.Free;
    end;
end;


{==============================================================================}
{===================  ФУНКЦИЯ ДЕКОДЕРА: ВЫБРАТЬ ЭЛЕМЕНТ  ======================}
{==============================================================================}
{===================  Prm - Таблица УД                   ======================}
{==============================================================================}
//procedure TDECOD.FSelectElement(const Prm: TArrayStr);
//var F : TFUD_STRUCT_EDIT_SELELEMENT;
//    IDE : TIDE;
//begin
//    {Инициализация}
//    If Length(Prm)=0 then Exit;
//    IDE:=NullIDE;
//    If P_DECOD^.Active then begin
//       If P_DECOD^.RecordCount>0 then IDE:=SetIDESimple(P_DECOD^.TableName, P_DECOD^.FieldByName(F_COUNTER).AsString);
//    end;
//
//    {Окно: выбор элемента}
//    F:=TFUD_STRUCT_EDIT_SELELEMENT.Create(Self);
//    try IDE:=F.Execute(Prm, IDE);
//    finally F.Free; end;
//
//    {Устанавливаем таблицу PUD^ на выбранный элемент IDE}
//    If P_DECOD^.Active then P_DECOD.Close;
//    SetDecoderIDE(P_DECOD, IDE);
//end;


{==============================================================================}
{=================  ФУНКЦИЯ ДЕКОДЕРА: РЕДАКТИРОВАТЬ ЭЛЕМЕНТ  ==================}
{==============================================================================}
procedure TDECOD.FEditElement;
var F: TForm;
begin
    If PUD^.RecordCount < 1 then Exit;
    case CmpStrList(PUD^.TableName, LTAB_UD) of
       LTAB_UD_PPERSON: begin
          F := TFVAR_UD_EDIT_PPERSON.Create(nil);
          try     TFVAR_UD_EDIT_PPERSON(F).Execute(PADODataSet(PUD));
          finally F.Free; end;
          Exit;
       end;
       LTAB_UD_LPERSON: begin
          F := TFVAR_UD_EDIT_LPERSON.Create(nil);
          try     TFVAR_UD_EDIT_LPERSON(F).Execute(PADODataSet(PUD));
          finally F.Free; end;
          Exit;
       end;
       LTAB_UD_DPERSON: begin
          F := TFVAR_UD_EDIT_DPERSON.Create(nil);
          try     TFVAR_UD_EDIT_DPERSON(F).Execute(PADODataSet(PUD));
          finally F.Free; end;
          Exit;
       end;
       LTAB_UD_OBJECT: begin
          F := TFVAR_UD_EDIT_OBJECT.Create(nil);
          try     TFVAR_UD_EDIT_OBJECT(F).Execute(PADODataSet(PUD));
          finally F.Free; end;
          Exit;
       end;
    end;
end;


