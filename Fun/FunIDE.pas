unit FunIDE;

interface
uses
   System.Classes, System.SysUtils,
   Vcl.Dialogs, Vcl.Controls,
   Data.DB, Data.Win.ADODB,
   FunType, MAIN;

type
  TID = record
      Tab : String;
      Rec : String;
  end;
  PID = ^TID;

{Физические лица.5 --> ICO_PPERSON_1}
function  IDToIco(const PUD: PBUD; const ID: String): Integer;
{ИКОНКА ЭЛЕМЕНТА УД}
function  GetIcoElementUD(const PDataSet: PADOTable; const ITable: Integer): Integer;
{Создает TID на основе ID}
function  SeparatID(const ID: String): TID;
{Физические лица.5 --> Физические лица}
function  IDToTable(const ID: String): String;
{Физические лица.5 --> 5}
function  IDToRecord(const ID: String): String;


{Устанавливает поле F_CAPTION для IDE}
//function  SetIDECaption(const PBD: PADOConnection; const IDE: TIDE): Boolean;
{Формирует TXT по записи элемента/списка}
//function  ElementToTxt(const PBD: PADOConnection; const Table, Key: String; const Args: array of const): String;
{Формирует TXT по ID}
function  IDToTxt(const PUD: PBUD; const ID: String; const Args: array of const): String;
{Опрределяет пол лица}
//function  GetSexIDE(const PBD: PADOConnection; const IDE: TIDE): Boolean;
{Строку в IDE}
//function  StrToIDE(const Str: String): TIDE;
{Формирует IDE}
//function  SetIDESimple(const Table, Key: String): TIDE;
{Сравнивает IDE}
//function  CmpIDE(const IDE1, IDE2: TIDE): Boolean;
{Очищает IDE}
//procedure ClearIDE(var IDE: TIDE);
{Пустой IDE}
//function  NullIDE: TIDE;
{Корректно ли задан ID}
function  VerifyID(ID: String): Boolean;
{Пустой ли IDE}
//function  IsNullIDE(IDE: TIDE): Boolean;
{Является ли IDE элементом структуры УД}
//function  IsIDETabElement(const IDE: TIDE): Boolean;
{Является ли IDE списком структуры УД}
//function  IsIDETabList(const IDE: TIDE): Boolean;
{Возвращает из IDE ID таблицы}
//function  IDEToIDTable(const IDE: TIDE): String;
{Формирует из IDE фильтр}
//function  IDEToFilter(const IDE: TIDE): String;

{ЯВЛЯЕТСЯ ЛИ ТАБЛИЦА ЭЛЕМЕНТОМ СТРУКТУРЫ УД}
function  IsTabUD(const Table: String): Boolean;
{ПОЗИЦИОНИРУЕТ ТАБЛИЦУ УД ПО НОМЕРУ ЗАПИСИ}
function  PosTabUD(const P: PADOTable; const Rec: String): Boolean;
{ПО НАЗВАНИЮ ТАБЛИЦЫ ОПЕРЕДЕЛЯЕТ УКАЗАТЕЛЬ НА ТАБЛИЦУ}
function  NameToTabUD(const PUD: PBUD; const Table: String): PADOTable;
{ПО НАЗВАНИЮ ТАБЛИЦЫ ОПЕРЕДЕЛЯЕТ ИНДЕКС ТАБЛИЦЫ}
function  TabUDToInd(const Table: String): Integer;
{ОБНОВЛЯЕТ ТАБЛИЦУ УД}
procedure RefreshTabUD(const PUD: PBUD; const Table: String);




implementation

uses FunConst, FunSys, FunText, FunBD, FunPadeg;



{==============================================================================}
{=================    Физические лица.5 --> ICO_PPERSON_1     =================}
{==============================================================================}
function IDToIco(const PUD: PBUD; const ID: String): Integer;
var IDE : TID;
    P   : PADOTable;
begin
    Result := ICO_PPERSON_1;
    IDE    := SeparatID(ID);

    P := NameToTabUD(PUD, IDE.Tab);
    If P = nil then Exit;
    try try
       If PosTabUD(P, IDE.Rec) then Result := GetIcoElementUD(P, TabUDToInd(IDE.Tab));
    except end;
    finally if P <> nil then SetDBFilter(P, ''); end;
end;


{==============================================================================}
{=====================       ИКОНКА ЭЛЕМЕНТА УД      ==========================}
{=====================  PDATASET - СПОЗИЦИОНИРОВАНО  ==========================}
{==============================================================================}
function GetIcoElementUD(const PDataSet: PADOTable; const ITable: Integer): Integer;
var S: String;
begin
    Result := ICO_PPERSON_1;
    Case ITable of
    LTAB_UD_PPERSON: begin
       Result := ICO_PPERSON_1;
       S := PDataSet^.FieldByName(PPERSON_STATE).AsString;
       If CmpStr(S, PPERSON_STATE_WITNESS) then begin Result := ICO_PPERSON_1; Exit; end;
       If CmpStr(S, PPERSON_STATE_VICTIM)  then begin Result := ICO_PPERSON_2; Exit; end;
       If CmpStr(S, PPERSON_STATE_SUSPECT) then begin Result := ICO_PPERSON_3; Exit; end;
       If CmpStr(S, PPERSON_STATE_ACCUSED) then begin Result := ICO_PPERSON_4; Exit; end;
       If CmpStr(S, PPERSON_STATE_STUPID)  then begin Result := ICO_PPERSON_4; Exit; end;
       Exit;
    end;
    LTAB_UD_LPERSON: begin
       Result := ICO_LPERSON_1;
       S := PDataSet^.FieldByName(LPERSON_STATE).AsString;
       If CmpStr(S, LPERSON_STATE_CLAIM)     then begin Result := ICO_LPERSON_2; Exit; end;
       If CmpStr(S, LPERSON_STATE_DEFENDANT) then begin Result := ICO_LPERSON_3; Exit; end;
       Exit;
    end;
    LTAB_UD_DPERSON: begin
       Result := ICO_DPERSON_1;
       S := PDataSet^.FieldByName(LPERSON_STATE).AsString;
       If CmpStr(S, DPERSON_STATE_ADVOCATE)  then begin Result := ICO_DPERSON_2; Exit; end;
       If CmpStr(S, DPERSON_STATE_REPRESENT) then begin Result := ICO_DPERSON_3; Exit; end;
       Exit;
    end;
    LTAB_UD_OBJECT: begin
       Result := ICO_OBJECT_1;
       If PDataSet^.FieldByName(OBJECT_VD).AsBoolean
       then Result := ICO_OBJECT_2;
       Exit;
    end;
    end;
end;


function SeparatID(const ID: String): TID;
begin
    Result.Tab := ID;
    Result.Rec := TokCharEnd(Result.Tab, '.');
end;


{==============================================================================}
{==================  Физические лица.5 --> Физические лица  ===================}
{==============================================================================}
function  IDToTable(const ID: String): String;
begin
    Result := CutSlovo(ID, 1, '.');
end;


{==============================================================================}
{==================        Физические лица.5 --> 5          ===================}
{==============================================================================}
function  IDToRecord(const ID: String): String;
begin
    Result := CutSlovoEndChar(ID, 1, '.');
end;


(*
{==============================================================================}
{=================   УСТАНАВЛИВАЕТ ПОЛЕ F_CAPTION ДЛЯ IDE   ===================}
{==============================================================================}
function SetIDECaption(const PBD: PADOConnection; const IDE: TIDE): Boolean;
var T : TADOTable;
    Q : TADOQuery;
    I : Integer;
begin
    {Инициализация и проверка на допустимость}
    Result:=false;
    If PBD            = nil   then Exit;
    If PBD^.Connected = false then Exit;
    If VerifyIDE(IDE) = false then Exit;

    {Проверка допустимости параметров}
    If CmpStrList(IDE.Table, [TABLE_RELATED])>=0 then Exit;

    {Создаем таблицу}
    T := TADOTable.Create(nil); If T=nil then Exit;
    Q := TADOQuery.Create(nil); If Q=nil then Exit;
    try
       {Открываем таблицу}
       If OpenBD('', PBD, [@T], [IDE.Table])=false then Exit;
       Q.Database:=PBD^;

       {Ищем запись IDE}
       SetDBFilter(@T, '['+F_COUNTER+']='+IDE.Key);
       If T.RecordCount<>1 then Exit;

       {Изменяем поле F_CAPTION}
       T.Edit;
       T.FieldByName(F_CAPTION).AsString:=IDEToTxt(PBD, IDE, []);
       T.UpdateRecord;
       T.Post;

       {Рекурсивный вызов для записей таблиц с обратными связями}
       For I:=Low(TAB_UD) to High(TAB_UD) do begin
          If HasRelTableDirectly(TAB_UD[I], IDE.Table)=false then Continue;
          If SetSQL(@Q, TAB_UD[I], IDE.Table, [IDE.Key], '')=false then Continue;
          Q.First;
          While Q.Eof=false do begin
             SetIDECaption(PBD, SetIDESimple(TAB_UD[I], Q.FieldByName(F_COUNTER).AsString));
             Q.Next;
          end;
       end;

       {Возвращаемый результат}
       Result:=true;
    finally
       CloseBD(nil, [@T]);
       If Q.Active then Q.Close;
       Q.Free;
       T.Free;
    end;
end;


{==============================================================================}
{============      ФОРМИРУЕТ TXT ПО ЗАПИСИ ЭЛЕМЕНТА/СПИСКА       ==============}
{==============================================================================}
{============  Table   =  Физические лица, Статусы, Меры         ==============}
{============  Key     =  5                                      ==============}
{============  Args    =  [Padeg], [Sex]                         ==============}
{============  Padeg   =  ' ' (т.е. И), 'Р', 'Д', 'В', 'Т', 'П'  ==============}
{============  Sex     =  true - мужчина                         ==============}
{==============================================================================}
function ElementToTxt(const PBD: PADOConnection; const Table, Key: String; const Args: array of const): String;
begin
    Result:=IDEToTxt(PBD, SetIDESimple(Table, Key), Args);
end;

*)
{==============================================================================}
{============               ФОРМИРУЕТ TXT ПО IDE                 ==============}
{==============================================================================}
{============  PBD     -  база данных уголовного дела            ==============}
{============  Args    =  [Padeg], [Sex]                         ==============}
{============  Padeg   =  ' ' (т.е. И), 'Р', 'Д', 'В', 'Т', 'П'  ==============}
{==============================================================================}
function IDToTxt(const PUD: PBUD; const ID: String; const Args: array of const): String;
var ArgsTyped : array [0..$fff0 div sizeof(TVarRec)] of TVarRec absolute Args;
    Padeg     : Char;
    IDE       : TID;
    P         : PADOTable;
    S         : String;
begin
    {Инициализация и проверка на допустимость}
    Result := '';
    IDE    := SeparatID(ID);

    {Определяем необязательные параметры}
    S := '';
    If Length(Args)>0 then begin
       With ArgsTyped[Low(Args)] do begin
          Case VType of
             vtString  : S   := AnsiUpperCase(VString^);
             vtChar    : S   := AnsiUpperCase(VChar);
          end;
       end;
    end;
    If S     <> ''  then Padeg:=S[1] else Padeg:=' ';
    If Padeg  = ' ' then Padeg:='И';

    try
       try
          {*** Физические лица ************************************************}
          If IDE.Tab = T_UD_PPERSON then begin
             P := @PUD^.TPPERSON; If Not PosTabUD(P, IDE.Rec) then Exit;
             Case Padeg of
             'И': Result:=P^.FieldByName(PPERSON_FIO).AsString;
             'Р': Result:=P^.FieldByName(PPERSON_FIO_RP).AsString;
             'Д': Result:=P^.FieldByName(PPERSON_FIO_DP).AsString;
             'В': Result:=P^.FieldByName(PPERSON_FIO_VP).AsString;
             'Т': Result:=P^.FieldByName(PPERSON_FIO_TP).AsString;
             'П': Result:=P^.FieldByName(PPERSON_FIO_PP).AsString;
             end;
             Exit;
          end;

          {*** Дополнительные лица ********************************************}
          If IDE.Tab = T_UD_DPERSON then begin
             P := @PUD^.TDPERSON; If Not PosTabUD(P, IDE.Rec) then Exit;
             Case Padeg of
             'И': Result:=P^.FieldByName(DPERSON_FIO).AsString;
             'Р': Result:=P^.FieldByName(DPERSON_FIO_RP).AsString;
             'Д': Result:=P^.FieldByName(DPERSON_FIO_DP).AsString;
             'В': Result:=P^.FieldByName(DPERSON_FIO_VP).AsString;
             'Т': Result:=P^.FieldByName(DPERSON_FIO_TP).AsString;
             'П': Result:=P^.FieldByName(DPERSON_FIO_PP).AsString;
             end;
             Exit;
          end;

          {*** Юридические лица ***********************************************}
          If IDE.Tab = T_UD_LPERSON then begin
             P := @PUD^.TLPERSON; If Not PosTabUD(P, IDE.Rec) then Exit;
             Case Padeg of
             'И': Result:=P^.FieldByName(LPERSON_NAME_SHORT).AsString;
             'Р': Result:=PadegAUTO('Р', P^.FieldByName(LPERSON_NAME_SHORT).AsString);
             'Д': Result:=PadegAUTO('Д', P^.FieldByName(LPERSON_NAME_SHORT).AsString);
             'В': Result:=PadegAUTO('В', P^.FieldByName(LPERSON_NAME_SHORT).AsString);
             'Т': Result:=PadegAUTO('Т', P^.FieldByName(LPERSON_NAME_SHORT).AsString);
             'П': Result:=PadegAUTO('П', P^.FieldByName(LPERSON_NAME_SHORT).AsString);
             end;
             Exit;
          end;

          {*** Объекты ********************************************************}
          If IDE.Tab = T_UD_OBJECT then begin
             P := @PUD^.TOBJECT; If Not PosTabUD(P, IDE.Rec) then Exit;
             Result:=P^.FieldByName(OBJECT_CAPTION).AsString;
             Exit;
          end;

       finally
          if P <> nil then SetDBFilter(P, '');
       end;
    except end;
end;

(*
{==============================================================================}
{=======================   ОПРЕДЕЛЯЕТ ПОЛ ЛИЦА   ==============================}
{==============================================================================}
{===========   Result = true - мужчина; false - женщина           =============}
{==============================================================================}
function GetSexIDE(const PBD: PADOConnection; const IDE: TIDE): Boolean;
var T: TADOTable;
begin
    {Инициализация и проверка на допустимость}
    Result:=true;
    If PBD            = nil   then Exit;
    If PBD^.Connected = false then Exit;
    If VerifyIDE(IDE) = false then Exit;

    {Проверка допустимости параметров}
    If (IDE.Table<>TABLE_PPERSONS) and (IDE.Table<>TABLE_DPERSONS) then Exit;

    {Создаем таблицу}
    T:=TADOTable.Create(nil); If T=nil then Exit;
    try
       {Открываем таблицу}
       If OpenBD('', PBD, [@T], [IDE.Table])=false then Exit;

       {Ищем запись}
       SetDBFilter(@T, '['+F_COUNTER+']='+IDE.Key);
       If T.RecordCount<>1 then Exit;

       {Возвращаемое значение}
       If IDE.Table=TABLE_PPERSONS then Result:=T.FieldByName(PPERSONS_SEX).AsBoolean;
       If IDE.Table=TABLE_DPERSONS then Result:=T.FieldByName(DPERSONS_SEX).AsBoolean;

    finally
       CloseBD(nil, [@T]);
       T.Free;
    end;
end;


{==============================================================================}
{==========================     СТРОКУ В IDE       ============================}
{==========================    (без проверок)      ============================}
{==============================================================================}
function StrToIDE(const Str: String): TIDE;
begin
    Result := SetIDESimple(CutSlovoChar(Str, 1, '.'), CutSlovoChar(Str, 2, '.'));
end;


{==============================================================================}
{==========================     ФОРМИРУЕТ IDE      ============================}
{==========================    (без проверок)      ============================}
{==============================================================================}
function SetIDESimple(const Table, Key: String): TIDE;
begin
    Result.Table := Table;
    Result.Key   := Key;
end;


{==============================================================================}
{=================              СРАВНИВАЕТ IDE                =================}
{==============================================================================}
function CmpIDE(const IDE1, IDE2: TIDE): Boolean;
begin
    {Инициализация}
    Result:=false;

    {Сама проверка}
    If (IDE1.Table=IDE2.Table) and (IDE1.Key=IDE2.Key) then Result:=true;
end;


{==============================================================================}
{=================                ОЧИЩАЕТ IDE                 =================}
{==============================================================================}
procedure ClearIDE(var IDE: TIDE);
begin
    IDE.Table := '';
    IDE.Key   := '';
end;


{==============================================================================}
{=================                 ПУСТОЙ IDE                 =================}
{==============================================================================}
function NullIDE: TIDE;
begin
    ClearIDE(Result);
end;
*)

{==============================================================================}
{=======================    КОРРЕКТНО ЛИ ЗАДАН ID    ==========================}
{==============================================================================}
function VerifyID(ID: String): Boolean;
var IDE: TID;
begin
    IDE    := SeparatID(ID);
    Result := IsTabUD(IDE.Tab) and IsIntegerStr(IDE.Rec);
end;

(*
{==============================================================================}
{=================               ПУСТОЙ ЛИ IDE                =================}
{==============================================================================}
function IsNullIDE(IDE: TIDE): Boolean;
begin
    If (IDE.Table='') and (IDE.Key='') then Result:=true else Result:=false
end;


{==============================================================================}
{================  ЯВЛЯЕТСЯ ЛИ IDE ЭЛЕМЕНТОМ СТРУКТУРЫ УД  ====================}
{==============================================================================}
function IsIDETabElement(const IDE: TIDE): Boolean;
begin
    If ETableToIndex(IDE.Table)>-1 then Result:=true
                                   else Result:=false;
end;


{==============================================================================}
{================   ЯВЛЯЕТСЯ ЛИ IDE СПИСКОМ СТРУКТУРЫ УД   ====================}
{==============================================================================}
function IsIDETabList(const IDE: TIDE): Boolean;
begin
    If LTableToIndex(IDE.Table)>-1 then Result:=true
                                   else Result:=false;
end;


{==============================================================================}
{====================     ВОЗВРАЩАЕТ ИЗ IDE ID ТАБЛИЦЫ     ====================}
{==============================================================================}
{====================              ФЛ  --> 3               ====================}
{==============================================================================}
function IDEToIDTable(const IDE: TIDE): String;
var I : Integer;
begin
    Result:='';
    I:=ETableToIndex(IDE.Table); If I>-1 then begin Result:=IntToStr(I); Exit; end;
    I:=LTableToIndex(IDE.Table); If I>-1 then       Result:=IntToStr(I);
end;



{==============================================================================}
{==================         ФОРМИРУЕТ ИЗ IDE ФИЛЬТР         ===================}
{==============================================================================}
{==================      ФЛ [5] --> [ФЛ].[F_COUNTER]=5      ===================}
{==============================================================================}
function IDEToFilter(const IDE: TIDE): String;
begin
    Result:='['+IDE.Table+'].['+F_COUNTER+']='+IDE.Key;
end;
*)




{==============================================================================}
{================  ЯВЛЯЕТСЯ ЛИ ТАБЛИЦА ЭЛЕМЕНТОМ СТРУКТУРЫ УД  ================}
{==============================================================================}
function IsTabUD(const Table: String): Boolean;
begin
    Result := IsStrInArray(Table, LTAB_UD);
end;


{==============================================================================}
{================  ПОЗИЦИОНИРУЕТ ТАБЛИЦУ УД ПО НОМЕРУ ЗАПИСИ  =================}
{==============================================================================}
function PosTabUD(const P: PADOTable; const Rec: String): Boolean;
    begin
        SetDBFilter(P, '['+F_COUNTER+']='+Rec);
        Result := P^.RecordCount = 1;
    end;


{==============================================================================}
{===========  ПО НАЗВАНИЮ ТАБЛИЦЫ ОПЕРЕДЕЛЯЕТ УКАЗАТЕЛЬ НА ТАБЛИЦУ  ===========}
{==============================================================================}
function NameToTabUD(const PUD: PBUD; const Table: String): PADOTable;
begin
    Result := nil;
    If CmpStr(LTAB_UD[Low(LTAB_UD)],   Table) then begin Result := @PUD.TPPERSON; Exit; end;
    If CmpStr(LTAB_UD[Low(LTAB_UD)+1], Table) then begin Result := @PUD.TLPERSON; Exit; end;
    If CmpStr(LTAB_UD[Low(LTAB_UD)+2], Table) then begin Result := @PUD.TDPERSON; Exit; end;
    If CmpStr(LTAB_UD[Low(LTAB_UD)+3], Table) then begin Result := @PUD.TOBJECT;  Exit; end;
end;



{==============================================================================}
{==============  ПО НАЗВАНИЮ ТАБЛИЦЫ ОПЕРЕДЕЛЯЕТ ИНДЕКС ТАБЛИЦЫ  ==============}
{==============================================================================}
function TabUDToInd(const Table: String): Integer;
var I: Integer;
begin
    Result := -1;
    For I:=Low(LTAB_UD) to High(LTAB_UD) do begin
       If Table = LTAB_UD[I] then begin
          Result := I;
          Break;
       end;
    end;
end;



{==============================================================================}
{==========================  ОБНОВЛЯЕТ ТАБЛИЦУ УД  ============================}
{==============================================================================}
procedure RefreshTabUD(const PUD: PBUD; const Table: String);
var P: PADOTable;
begin
    P := NameToTabUD(PUD, Table);
    If P = nil then Exit;
    P^.Active := false;
    P^.Active := true;
end;

//initialization
//   FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
//
//finalization
//   FFMAIN := nil;

end.
