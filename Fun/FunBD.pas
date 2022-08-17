unit FunBD;

interface
uses
   System.Classes, System.SysUtils,
   Vcl.Dialogs, Vcl.Controls, Vcl.OleAuto {CreateOleObject},
   Data.DB, Data.Win.ADODB, ADOInt {adAffectCurrent, adResyncAllValues},
   FunType;

{Клонирует указанный запрос}
function  CloneQuery(const PQuery: PADOQuery): TADOQuery;
{Клонирует указанную таблицу}
function  CloneTable(const PTable: PADOTable): TADOTable;
{Открывает второй экземпляр запроса}
function  LikeQuery(const PQuery: PADOQuery): TADOQuery;
{Открывает второй экземпляр таблицы}
function  LikeTable(const PTable: PADOTable): TADOTable;
{УСТАНОВКА ПАРОЛЯ НА БАЗУ ДАННЫХ}
function  SetPassBD(const BDPath, PassOld, PassNew: String): Boolean;
{СЖАТИЕ БАЗЫ ДАННЫХ}
function  PackBD(const BDPath: String; const SPassword: String = ''): Boolean;
{Открытие базы данных и таблиц}
function  OpenBD(const PBD        : PADOConnection;
                 const BDPath     : String;
                 const SPassword  : String;
                 const PTables    : array of PADOTable;
                 const TabNames   : array of String;
                 const IsReadOnly : Boolean = false): Boolean;
{Закрытие базы данных и таблиц}
procedure CloseBD(const PBD: PADOConnection; const PTables: array of PADOTable; const IsPack: Boolean = false);
{Уничтожение ссылки на таблицу}
procedure DestrTable(const PTable: PADOTable);
{Удаляет все записи таблицы}
procedure ClearTable(const PTable: PADOTable);
{Удаляет все записи списка таблиц}
procedure ClearTableList(const PTables: array of PADOTable);
{Снимает все ограничения с таблицы}
procedure FreeTable(const PTable: PADOTable);
{Обновляет таблицу на диске}
procedure UpdateTable(const PTable: PADOTable); // УБРАТЬ
procedure RefreshTable(const PTable: PADOTable);
{ПЕРЕОТКРЫВАЕТ DATASET}
procedure ReOpenDataSet(const P: PADODataSet);
{ОБНОВЛЯET ОТКРЫТЫЙ DATASET}
//procedure RefreshDataSet(const P: PADODataSet; const IKeyField: String);
{УСТАНАВЛИВАЕТ ПАРАМЕТР ЗАПРОСА}
function  SetQueryParam(const PQuery: PADOQuery; const PName: String; const PType: TFieldType; const PVal: Variant): Boolean;
{Устанавливает фильтр на таблицу}
procedure SetDBFilter(const PTable: PADOTable; const SFilter: String);
{Устанавливает сортировку на таблицу}
procedure SetDBSort(const PTable: PADOTable; const Sort: String);
{Устанавливает связь на таблицу}
procedure SetDBConnect(const PTable: PADOTable;
                       const PMasterSource: PDataSource;
                       const MasterFields, IndexFields: String);
{Определяет число записей открытой таблицы не нарушая настроек}
function  CountRecord_T(const PTable : PADOTable;
                        const FNames : array of String;
                        const VNames : array of String): Integer;
{Поиск таблиц базы данных}
function  FindBDTables(const PBD: PADOConnection; const LTableNames: array of String): Boolean;
{Поиск таблиц, подключенных к базе данных}
function  FindDataSet(const PBD: PADOConnection; const TName: String): TADODataSet;
{Позиционирует запрос по значению переменной}
function  PosDataSet(const PDataSet: PADODataSet; const SVar: String): Boolean;
{Определяет индекс (F_COUNTER) записи по значениям полей}
function  GetIndRecord(const PBD: PADOConnection; const TName: String;
                       const FName, Val: array of String): String;
{Читает значение поля записи F_COUNTER}
function  ReadField(const PBD: PADOConnection; const TName: String; const ICounter: Integer;
                    const SField: String): String;
{Читает значение поля SField записи, определенной фильтром SFilter}
function  ReadFieldFromFilter(const PBD: PADOConnection; const TName, SFilter, SField: String; const OnlyOneRec: Boolean): String;
{Существует ли запись, определенная фильтром: если да, то позиционирует на нее указатель}
//function  IsExistsRec(const PData: PADODataSet; const LField, LVal: Array  of String): Boolean;


{******************************************************************************}
{***  Модуль:  FunBD_VAR  *****************************************************}
{******************************************************************************}
{Корректно записывает в таблицу переменных значение}
procedure TableWriteVar(const PTable: PADOTable; const VarName: String; const Value: Variant);
{Корректно читает значение из открытой таблицы переменных}
function  TableReadVar(const PTable: PADOTable; const VarName: String; const Value0: Variant): Variant;
{Удаляет из таблицы переменную}
procedure TableDelVar(const PTable: PADOTable; const VarName: String);


implementation

uses FunConst, FunSys, FunText, FunDay, FunFiles;

{$INCLUDE FunBD_VAR}

{==============================================================================}
{================ Клонирует указанный запрос ==================================}
{==============================================================================}
function CloneQuery(const PQuery: PADOQuery): TADOQuery;
begin
    Result:=TADOQuery(DuplicateComponents(TComponent(PQuery^)));
end;


{==============================================================================}
{================ Клонирует указанную таблицу =================================}
{==============================================================================}
function CloneTable(const PTable: PADOTable): TADOTable;
begin
    Result:=TADOTable(DuplicateComponents(TComponent(PTable^)));
end;


{==============================================================================}
{=================== Открывает второй экземпляр запроса =======================}
{==============================================================================}
function LikeQuery(const PQuery: PADOQuery): TADOQuery;
begin
    Result:=TADOQuery.Create(PQuery^.Owner);
    If Result = nil then Exit;
    Result.Connection := PQuery^.Connection;
    Result.SQL.Text   := PQuery^.SQL.Text;
    Result.Open;
end;


{==============================================================================}
{=================== Открывает второй экземпляр таблицы =======================}
{==============================================================================}
function LikeTable(const PTable: PADOTable): TADOTable;
begin
    Result:=TADOTable.Create(PTable^.Owner);
    If Result = nil then Exit;
    Result.Connection := PTable^.Connection;
    Result.TableName  := PTable^.TableName;
    Result.Open;
end;


{==============================================================================}
{====================== УСТАНОВКА ПАРОЛЯ НА БАЗУ ДАННЫХ =======================}
{==============================================================================}
function SetPassBD(const BDPath, PassOld, PassNew: String): Boolean;
var BD  : TADOConnection;
    Com : TADOCommand;
    SOld, SNew : String;
begin
    Result := false;
    BD  := TADOConnection.Create(nil);
    Com := TADOCommand.Create(nil);
    try
       {Пароль не спрашивать}
       BD.LoginPrompt := false;
       {Открыть БД}
       BD.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0; '+      // Microsoft.ACE.OLEDB.12.0;
                              'Mode=Share Deny Read|Share Deny Write; '+ // Монопольный доступ к БД
                              'Data Source='+BDPath+'; '+
                              'Jet OLEDB:Database Password='+PassOld+'; '+
                              'Extended Properties=""';
       BD.Open;

       If PassOld <> '' then SOld := '['+PassOld+']' else SOld := 'NULL';
       If PassNew <> '' then SNew := '['+PassNew+']' else SNew := 'NULL';
       With Com do begin
          Commandtext := 'ALTER DATABASE PASSWORD '+SNew+' '+SOld;
          Connection  := BD;
          Execute;
       end;
       Result := true;
    finally
       Com.Free;
       If BD.Connected then BD.Close; BD.Free;
    end;
end;


{==============================================================================}
{=========================== СЖАТИЕ БАЗЫ ДАННЫХ ===============================}
{==============================================================================}
function PackBD(const BDPath : String; const SPassword: String = ''): Boolean;
var SSrc, SDect : String;
    BDPathTemp  : String;
    V           : Variant;
begin
    {Инициализация}
    Result := false;
    If not FileExists(BDPath) then Exit;
    BDPathTemp := TempFileName(ExtractFilePath(BDPath)+ExtractFileNameWithoutExt(BDPath), ExtractFileExt(BDPath));
    If BDPathTemp = '' then Exit;

    {Строки}
    SSrc :=  'Provider=Microsoft.Jet.OLEDB.4.0; '+
             'Data Source='+BDPath+'; '+
             'Jet OLEDB:Database Password='+SPassword+'; '+
             'Extended Properties=""';
    SDect := 'Provider=Microsoft.Jet.OLEDB.4.0; '+
             'Data Source='+BDPathTemp+'; '+
             'Jet OLEDB:Database Password='+SPassword+'; '+
             'Extended Properties=""';

    {Пакуем во временный файл}
    try
       V := CreateOleObject('jro.JetEngine');
       try      V.CompactDatabase(SSrc, SDect);
       finally  V:=0;  end;
    except end;

    {Заменяем старый файл новым}
    If not FileExists(BDPathTemp) then Exit;
    DeleteFile(BDPath);
    RenameFile(BDPathTemp, BDPath);

    {Результат}
    Result := true;
end;


{==============================================================================}
{====================== ОТКРЫТИЕ БАЗЫ ДАННЫХ И ТАБЛИЦ =========================}
{==============================================================================}
function OpenBD(const PBD        : PADOConnection;
                const BDPath     : String;
                const SPassword  : String;
                const PTables    : array of PADOTable;
                const TabNames   : array of String;
                const IsReadOnly : Boolean = false): Boolean;
var S : String;
    I : Integer;
begin
    Result := false;
    If PBD=nil then Exit;
    // If Length(PTables)<>Length(TabNames) then Exit; чтобы ошибки были явно видны
    try
       {Открываем базу данных}
       If BDPath<>'' then begin
          {Закрываем предыдущую базу}
          CloseBD(PBD, PTables);
          {Существует ли открываемая база данных}
          If not FileExists(BDPath) then Exit;
          {Пароль не спрашивать}
          PBD^.LoginPrompt := false;
          {Открываем базу данных}
          S := 'Provider=Microsoft.Jet.OLEDB.4.0; '+
               'Data Source='+BDPath+'; '+
               'Jet OLEDB:Database Password='+SPassword+'; '+
               'Extended Properties=""';
          If IsReadOnly then S := S+'; Mode=Read';         //  Exclusive=No Exclusive=Yes
          PBD^.ConnectionString := S;
       end;

       {Открываем таблицы}
       For I:=Low(PTables) to High(PTables) do begin
          PTables[I]^.Connection := PBD^;
          If TabNames[I]<>'' then PTables[I]^.TableName := TabNames[I];
          PTables[I]^.Open;
       end;

       Result:=true;
    except end;
end;


{==============================================================================}
{====================== ЗАКРЫТИЕ БАЗЫ ДАННЫХ И ТАБЛИЦ =========================}
{==============================================================================}
{====================== IsPack = true - сжвть         =========================}
{==============================================================================}
procedure CloseBD(const PBD: PADOConnection; const PTables: array of PADOTable; const IsPack: Boolean = false);
var S, SPath, SPass : String;
    I : Integer;
begin
    {Закрываем таблицы}
    For I:=Low(PTables) to High(PTables) do If PTables[I]^ <> nil then PTables[I]^.Close;

    {Закрываем базу данных}
    If PBD  = nil then Exit;
    If PBD^ = nil then Exit;
    If PBD^.Connected then begin
       PBD^.Close;

       {Пакуем базу данных}
       If IsPack then begin
          S := PBD^.ConnectionString;
          TokStr(S, 'Data Source=');
          SPath := TokChar(S, ';');
          TokStr(S, 'Password=');
          SPass := TokChar(S, ';');
          PackBD(SPath, SPass);
       end;
    end;
end;


{==============================================================================}
{======================== Уничтожение ссылки на таблицу =======================}
{==============================================================================}
procedure DestrTable(const PTable: PADOTable);
begin
    With PTable^ do begin
       If Active then Close;
       Free;
    end;
end;


{==============================================================================}
{======================  УДАЛЯЕТ ВСЕ ЗАПИСИ ТАБЛИЦЫ   =========================}
{==============================================================================}
procedure ClearTable(const PTable: PADOTable);
begin
    FreeTable(PTable);
    PTable^.Last;
    While PTable^.Bof=false do PTable^.Delete;
end;


{==============================================================================}
{===============   УДАЛЯЕТ ВСЕ ЗАПИСИ ТАБЛИЦЫ СПИСКА ТАБЛИЦ   =================}
{==============================================================================}
procedure ClearTableList(const PTables: array of PADOTable);
var I: Integer;
begin
    For I:=Low(PTables) to High(PTables) do ClearTable(PTables[I]);
end;


{==============================================================================}
{===================  СНИМАЕТ ВСЕ ОГРАНИЧЕНИЯ С ТАБЛИЦЫ  ======================}
{==============================================================================}
procedure FreeTable(const PTable: PADOTable);
begin
    SetDBFilter (PTable, '');
    SetDBSort   (PTable, '');
    SetDBConnect(PTable, nil, '', '');
end;


{==============================================================================}
{=======================  ОБНОВЛЯET ТАБЛИЦУ НА ДИСКЕ  =========================}
{==============================================================================}
procedure UpdateTable(const PTable: PADOTable);
begin
    With PTable^ do begin
       If Active then begin
          Edit;
          UpdateRecord;
          Post;
       end;
    end;
end;


{==============================================================================}
{=======================  ОБНОВЛЯET ТАБЛИЦУ НА ДИСКЕ  =========================}
{==============================================================================}
procedure RefreshTable(const PTable: PADOTable);
begin
    With PTable^ do begin
       If Active then begin
          UpdateCursorPos;
          Recordset.Resync(adAffectCurrent, adResyncAllValues);
          Resync([rmExact]);
       end;
    end;
end;


{==============================================================================}
{=========================  ПЕРЕОТКРЫВАЕТ DATASET  ============================}
{==============================================================================}
procedure ReOpenDataSet(const P: PADODataSet);
begin
    With P^ do begin
       try     DisableControls;
               Close;
       finally Open;
               EnableControls;
       end;
    end;
end;


(*
{==============================================================================}
{=======================  ОБНОВЛЯET ОТКРЫТЫЙ DATASET  =========================}
{==============================================================================}
procedure RefreshDataSet(const P: PADODataSet; const IKeyField: String);
var EBefore, EAfter: TDataSetNotifyEvent;
    ID: String;
begin
    With P^ do begin
       DisableControls;
       EBefore := BeforeScroll; BeforeScroll := nil;
       EAfter  := AfterScroll;  AfterScroll  := nil;
       try     ID := FieldByName(IKeyField).AsString;
               Close;
               Open;
               P^.Locate(IKeyField, ID, [])

       finally
          BeforeScroll := EBefore;
          AfterScroll  := EAfter;
          EnableControls;
       end;
    end;
end;
*)

{==============================================================================}
{=====================  УСТАНАВЛИВАЕТ ПАРАМЕТР ЗАПРОСА  =======================}
{==============================================================================}
{=======  УСТРАНЯЕТ ОШИБКУ С НЕДОПУСТИМОСТЬЮ ОДНОИМЕННЫХ ПАРАМЕТРОВ ===========}
{==============================================================================}
function SetQueryParam(const PQuery: PADOQuery; const PName: String; const PType: TFieldType; const PVal: Variant): Boolean;
var I: Integer;
begin
    Result := true;
    try
       With PQuery^ do begin
          For I:= 0 to Parameters.Count-1 do begin
             If Parameters[I].Name = PName then begin
                //Parameters[I].Direction := pdInput;
                Parameters[I].DataType := PType;
                Parameters[I].Value    := PVal;
             end;
          end;
       end;
    except Result := false;
    end;
end;


{==============================================================================}
{====================  УСТАНАВЛИВАЕТ ФИЛЬТР НА ТАБЛИЦУ  =======================}
{==============================================================================}
procedure SetDBFilter(const PTable: PADOTable; const SFilter: String);
begin
    With PTable^ do begin
       If Filtered and (Filter = SFilter) then Exit;
       If Filtered then Filtered:=false;
       Filter := SFilter;
       If Filter <> '' then Filtered:=true;
    end;
end;


{==============================================================================}
{==================  УСТАНАВЛИВАЕТ СОРТИРОВКУ НА ТАБЛИЦУ ======================}
{==============================================================================}
procedure SetDBSort(const PTable: PADOTable; const Sort: String);
begin
    // If PTable^.Active = false then Exit;
    If PTable^.Sort<>Sort then PTable^.Sort:=Sort;
end;


{==============================================================================}
{=====================  УСТАНАВЛИВАЕТ СВЯЗЬ НА ТАБЛИЦУ  =======================}
{==============================================================================}
procedure SetDBConnect(const PTable                    : PADOTable;
                       const PMasterSource             : PDataSource;
                       const MasterFields, IndexFields : String);
var IsActive : Boolean;
begin
    IsActive                := PTable^.Active;
    If PTable^.Active then PTable^.Active := false;
    PTable^.IndexFieldNames := '';
    PTable^.MasterSource    := nil;
    If PMasterSource <> nil then PTable^.MasterSource := PMasterSource^
                            else PTable^.MasterSource := nil;
    PTable^.MasterFields    := MasterFields;
    PTable^.IndexFieldNames := IndexFields;         // Последний, т.к. может устанавливаться автоматически при изменении Master
    PTable^.Active          := IsActive;
//  !!! одновременно связь и поиск недопустимы, нужно применять фильтры или SQL
//    If PMasterSource<>nil then PTable^.MasterSource := PMasterSource^;
//    If PTable^.MasterFields    <> MasterFields   then PTable^.MasterFields    := MasterFields;
//    If PTable^.IndexFieldNames <> IndexFields    then PTable^.IndexFieldNames := IndexFields;
end;


{==============================================================================}
{=====  ОПРЕДЕЛЯЕТ ЧИСЛО ЗАПИСЕЙ ОТКРЫТОЙ ТАБЛИЦЫ НЕ НАРУШАЯ НАСТРОЕК  ========}
{==============================================================================}
function CountRecord_T(const PTable : PADOTable;
                       const FNames : array of String;
                       const VNames : array of String): Integer;
var T0     : TADOTable;
    Filter : String;
    I      : Integer;
begin
    {Инициализация}
    Result:=0;
    If Length(FNames)<>Length(VNames) then Exit;
    If PTable<>nil then If PTable^.Active=false then Exit;
    Filter:='';

    {Существуют ли указанные в списке поля}
    For I:=0 to Length(FNames)-1 do If PTable^.FindField(FNames[I])=nil then Exit;

    {Определяем фильтр}
    For I:=0 to Length(FNames)-1 do Filter:=Filter+'(['+FNames[I]+']='+QuotedStr(VNames[I])+') AND ';
    Delete(Filter, Length(Filter)-3, 4);

    {Создаем клон таблицы чтобы не изменять ее установки}
    T0:=CloneTable(PTable); If T0=nil then Exit;

    {Определяем число записей согласно фильтра}
    try
       SetDBFilter(@T0, Filter);
       Result:=T0.RecordCount;
    finally
       T0.Free;
    end;
end;



{==============================================================================}
{=======================   ПОИСК ТАБЛИЦ БАЗЫ ДАННЫХ   =========================}
{==============================================================================}
function FindBDTables(const PBD: PADOConnection; const LTableNames: array of String): Boolean;
var ITab  : Integer;
    SList : TStringList;
begin
    {Инициализация}
    Result := false;
    If PBD=nil then Exit;
    SList := TStringList.Create;
    try
       PBD^.GetTableNames(SList, false);
       Result := true;
       For ITab:=Low(LTableNames) to High(LTableNames) do begin
          Result := (SList.IndexOf(LTableNames[ITab]) >= 0);
          If Not Result then Break;
       end;
    finally
       SList.Free;
    end;
end;


{==============================================================================}
{===============   ПОИСК ТАБЛИЦ, ПОДКЛЮЧЕННЫХ К БАЗЕ ДАННЫХ   =================}
{==============================================================================}
function FindDataSet(const PBD: PADOConnection; const TName: String): TADODataSet;
var I: Integer;
begin
    {Инициализация}
    Result:=nil;
    If PBD=nil then Exit;

    {Просматриваем список таблиц}
    For I:=0 to PBD^.DataSetCount-1 do begin
       If CmpStr(TName, PBD^.DataSets[I].Name) then begin
          Result:=TADODataSet(PBD^.DataSets[I]);
          Break;
       end;
    end;
end;


{==============================================================================}
{==============  ПОЗИЦИОНИРУЕТ ЗАПРОС ПО ЗНАЧЕНИЮ ПЕРЕМЕННОЙ  =================}
{==============================================================================}
{==============  SVar = Физические лица.1                     =================}
{==============================================================================}
function PosDataSet(const PDataSet: PADODataSet; const SVar: String): Boolean;
var S: String;
begin
    S := CutSlovoEndChar(SVar, 1, '.');
    If S<>'' then Result := PDataSet^.Locate(F_COUNTER, S, [])
             else Result := false;
end;


{==============================================================================}
{=========  ОПРЕДЕЛЯЕТ ИНДЕКС (F_COUNTER) ЗАПИСИ ПО ЗНАЧЕНИЯМ ПОЛЕЙ  ==========}
{==============================================================================}
function GetIndRecord(const PBD: PADOConnection; const TName: String;
                      const FName, Val: array of String): String;
var SFilter : String;
    I       : Integer;
begin
    {Инициализация}
    Result:='';
    If PBD=nil then Exit;
    If TName='' then Exit;
    If Length(FName)<>Length(Val) then Exit;

    {Создаем фильтр}
    SFilter:='';
    For I:=Low(FName) to High(FName) do SFilter:=SFilter+' AND (['+FName[I]+']='+QuotedStr(Val[I])+')';
    Delete(SFilter, 1, 5);

    {Ищем и читаем запись}
    Result := ReadFieldFromFilter(PBD, TName, SFilter, F_COUNTER, true);
end;



{==============================================================================}
{==================  ЧИТАЕТ ЗНАЧЕНИЕ ПОЛЯ ЗАПИСИ F_COUNTER   ==================}
{==============================================================================}
function ReadField(const PBD: PADOConnection; const TName: String; const ICounter: Integer; const SField: String): String;
begin
    Result := ReadFieldFromFilter(PBD, TName, '['+F_COUNTER+']='+IntToStr(ICounter), SField, true);
end;


{==============================================================================}
{====  ЧИТАЕТ ЗНАЧЕНИЕ ПОЛЯ SFIELD ЗАПИСИ, ОПРЕДЕЛЕННОЙ ФИЛЬТРОМ SFILTER  =====}
{==============================================================================}
function ReadFieldFromFilter(const PBD: PADOConnection; const TName, SFilter, SField: String; const OnlyOneRec: Boolean): String;
var T: TADOTable;
begin
    {Инициализация}
    Result := '';
    T:=TADOTable.Create(nil);
    try
       {Инициализация запроса}
       T.Connection := PBD^;
       T.TableName  := TName;
       T.Filter     := SFilter;
       T.Filtered   := true;
       T.Open;
       If OnlyOneRec then begin
          If T.RecordCount=1 then Result:=T.FieldByName(SField).AsString;
       end else begin
          If T.RecordCount>0 then begin
             T.First;
             Result:=T.FieldByName(SField).AsString;
          end;
       end;
    finally
       If T.Active then T.Close;
       T.Free;
    end;
end;

(*
{==============================================================================}
{==============   СУЩЕСТВУЕТ ЛИ ЗАПИСЬ, ОПРЕДЕЛЕННАЯ ФИЛЬТРОМ   ===============}
{==============           ПОЗИЦИОНИРУЕТ НА НЕЕ УКАЗАТЕЛЬ        ===============}
{==============================================================================}
function IsExistsRec(const PData: PADODataSet; const LField, LVal: array of String): Boolean;
var I, IHigh : Integer;
    FList    : array of TField;
begin
    {Инициализация}
    Result := false;
    If Not PData^.Active then Exit;
    IHigh  := High(LField);

    try
       SetLength(FList, Length(LField));
       For I:=0 to IHigh do FList[I]:=PData^.FindField(LField[I]);

       With PData^ do begin
          First;
          While Not Eof do begin
             For I:=0 to IHigh do begin
                If FList[I].AsString <> LVal[I] then Break;
                If I=IHigh then begin
                   Result:=true;
                   Exit;
                end;
             end;
             Next;
          end;
       end;
    finally
       SetLength(FList, 0);
    end;
end;
*)


end.

