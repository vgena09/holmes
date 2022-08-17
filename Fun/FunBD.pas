unit FunBD;

interface
uses
   System.Classes, System.SysUtils,
   Vcl.Dialogs, Vcl.Controls, Vcl.OleAuto {CreateOleObject},
   Data.DB, Data.Win.ADODB, ADOInt {adAffectCurrent, adResyncAllValues},
   FunType;

{��������� ��������� ������}
function  CloneQuery(const PQuery: PADOQuery): TADOQuery;
{��������� ��������� �������}
function  CloneTable(const PTable: PADOTable): TADOTable;
{��������� ������ ��������� �������}
function  LikeQuery(const PQuery: PADOQuery): TADOQuery;
{��������� ������ ��������� �������}
function  LikeTable(const PTable: PADOTable): TADOTable;
{��������� ������ �� ���� ������}
function  SetPassBD(const BDPath, PassOld, PassNew: String): Boolean;
{������ ���� ������}
function  PackBD(const BDPath: String; const SPassword: String = ''): Boolean;
{�������� ���� ������ � ������}
function  OpenBD(const PBD        : PADOConnection;
                 const BDPath     : String;
                 const SPassword  : String;
                 const PTables    : array of PADOTable;
                 const TabNames   : array of String;
                 const IsReadOnly : Boolean = false): Boolean;
{�������� ���� ������ � ������}
procedure CloseBD(const PBD: PADOConnection; const PTables: array of PADOTable; const IsPack: Boolean = false);
{����������� ������ �� �������}
procedure DestrTable(const PTable: PADOTable);
{������� ��� ������ �������}
procedure ClearTable(const PTable: PADOTable);
{������� ��� ������ ������ ������}
procedure ClearTableList(const PTables: array of PADOTable);
{������� ��� ����������� � �������}
procedure FreeTable(const PTable: PADOTable);
{��������� ������� �� �����}
procedure UpdateTable(const PTable: PADOTable); // ������
procedure RefreshTable(const PTable: PADOTable);
{������������� DATASET}
procedure ReOpenDataSet(const P: PADODataSet);
{�������ET �������� DATASET}
//procedure RefreshDataSet(const P: PADODataSet; const IKeyField: String);
{������������� �������� �������}
function  SetQueryParam(const PQuery: PADOQuery; const PName: String; const PType: TFieldType; const PVal: Variant): Boolean;
{������������� ������ �� �������}
procedure SetDBFilter(const PTable: PADOTable; const SFilter: String);
{������������� ���������� �� �������}
procedure SetDBSort(const PTable: PADOTable; const Sort: String);
{������������� ����� �� �������}
procedure SetDBConnect(const PTable: PADOTable;
                       const PMasterSource: PDataSource;
                       const MasterFields, IndexFields: String);
{���������� ����� ������� �������� ������� �� ������� ��������}
function  CountRecord_T(const PTable : PADOTable;
                        const FNames : array of String;
                        const VNames : array of String): Integer;
{����� ������ ���� ������}
function  FindBDTables(const PBD: PADOConnection; const LTableNames: array of String): Boolean;
{����� ������, ������������ � ���� ������}
function  FindDataSet(const PBD: PADOConnection; const TName: String): TADODataSet;
{������������� ������ �� �������� ����������}
function  PosDataSet(const PDataSet: PADODataSet; const SVar: String): Boolean;
{���������� ������ (F_COUNTER) ������ �� ��������� �����}
function  GetIndRecord(const PBD: PADOConnection; const TName: String;
                       const FName, Val: array of String): String;
{������ �������� ���� ������ F_COUNTER}
function  ReadField(const PBD: PADOConnection; const TName: String; const ICounter: Integer;
                    const SField: String): String;
{������ �������� ���� SField ������, ������������ �������� SFilter}
function  ReadFieldFromFilter(const PBD: PADOConnection; const TName, SFilter, SField: String; const OnlyOneRec: Boolean): String;
{���������� �� ������, ������������ ��������: ���� ��, �� ������������� �� ��� ���������}
//function  IsExistsRec(const PData: PADODataSet; const LField, LVal: Array  of String): Boolean;


{******************************************************************************}
{***  ������:  FunBD_VAR  *****************************************************}
{******************************************************************************}
{��������� ���������� � ������� ���������� ��������}
procedure TableWriteVar(const PTable: PADOTable; const VarName: String; const Value: Variant);
{��������� ������ �������� �� �������� ������� ����������}
function  TableReadVar(const PTable: PADOTable; const VarName: String; const Value0: Variant): Variant;
{������� �� ������� ����������}
procedure TableDelVar(const PTable: PADOTable; const VarName: String);


implementation

uses FunConst, FunSys, FunText, FunDay, FunFiles;

{$INCLUDE FunBD_VAR}

{==============================================================================}
{================ ��������� ��������� ������ ==================================}
{==============================================================================}
function CloneQuery(const PQuery: PADOQuery): TADOQuery;
begin
    Result:=TADOQuery(DuplicateComponents(TComponent(PQuery^)));
end;


{==============================================================================}
{================ ��������� ��������� ������� =================================}
{==============================================================================}
function CloneTable(const PTable: PADOTable): TADOTable;
begin
    Result:=TADOTable(DuplicateComponents(TComponent(PTable^)));
end;


{==============================================================================}
{=================== ��������� ������ ��������� ������� =======================}
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
{=================== ��������� ������ ��������� ������� =======================}
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
{====================== ��������� ������ �� ���� ������ =======================}
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
       {������ �� ����������}
       BD.LoginPrompt := false;
       {������� ��}
       BD.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0; '+      // Microsoft.ACE.OLEDB.12.0;
                              'Mode=Share Deny Read|Share Deny Write; '+ // ����������� ������ � ��
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
{=========================== ������ ���� ������ ===============================}
{==============================================================================}
function PackBD(const BDPath : String; const SPassword: String = ''): Boolean;
var SSrc, SDect : String;
    BDPathTemp  : String;
    V           : Variant;
begin
    {�������������}
    Result := false;
    If not FileExists(BDPath) then Exit;
    BDPathTemp := TempFileName(ExtractFilePath(BDPath)+ExtractFileNameWithoutExt(BDPath), ExtractFileExt(BDPath));
    If BDPathTemp = '' then Exit;

    {������}
    SSrc :=  'Provider=Microsoft.Jet.OLEDB.4.0; '+
             'Data Source='+BDPath+'; '+
             'Jet OLEDB:Database Password='+SPassword+'; '+
             'Extended Properties=""';
    SDect := 'Provider=Microsoft.Jet.OLEDB.4.0; '+
             'Data Source='+BDPathTemp+'; '+
             'Jet OLEDB:Database Password='+SPassword+'; '+
             'Extended Properties=""';

    {������ �� ��������� ����}
    try
       V := CreateOleObject('jro.JetEngine');
       try      V.CompactDatabase(SSrc, SDect);
       finally  V:=0;  end;
    except end;

    {�������� ������ ���� �����}
    If not FileExists(BDPathTemp) then Exit;
    DeleteFile(BDPath);
    RenameFile(BDPathTemp, BDPath);

    {���������}
    Result := true;
end;


{==============================================================================}
{====================== �������� ���� ������ � ������ =========================}
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
    // If Length(PTables)<>Length(TabNames) then Exit; ����� ������ ���� ���� �����
    try
       {��������� ���� ������}
       If BDPath<>'' then begin
          {��������� ���������� ����}
          CloseBD(PBD, PTables);
          {���������� �� ����������� ���� ������}
          If not FileExists(BDPath) then Exit;
          {������ �� ����������}
          PBD^.LoginPrompt := false;
          {��������� ���� ������}
          S := 'Provider=Microsoft.Jet.OLEDB.4.0; '+
               'Data Source='+BDPath+'; '+
               'Jet OLEDB:Database Password='+SPassword+'; '+
               'Extended Properties=""';
          If IsReadOnly then S := S+'; Mode=Read';         //  Exclusive=No Exclusive=Yes
          PBD^.ConnectionString := S;
       end;

       {��������� �������}
       For I:=Low(PTables) to High(PTables) do begin
          PTables[I]^.Connection := PBD^;
          If TabNames[I]<>'' then PTables[I]^.TableName := TabNames[I];
          PTables[I]^.Open;
       end;

       Result:=true;
    except end;
end;


{==============================================================================}
{====================== �������� ���� ������ � ������ =========================}
{==============================================================================}
{====================== IsPack = true - �����         =========================}
{==============================================================================}
procedure CloseBD(const PBD: PADOConnection; const PTables: array of PADOTable; const IsPack: Boolean = false);
var S, SPath, SPass : String;
    I : Integer;
begin
    {��������� �������}
    For I:=Low(PTables) to High(PTables) do If PTables[I]^ <> nil then PTables[I]^.Close;

    {��������� ���� ������}
    If PBD  = nil then Exit;
    If PBD^ = nil then Exit;
    If PBD^.Connected then begin
       PBD^.Close;

       {������ ���� ������}
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
{======================== ����������� ������ �� ������� =======================}
{==============================================================================}
procedure DestrTable(const PTable: PADOTable);
begin
    With PTable^ do begin
       If Active then Close;
       Free;
    end;
end;


{==============================================================================}
{======================  ������� ��� ������ �������   =========================}
{==============================================================================}
procedure ClearTable(const PTable: PADOTable);
begin
    FreeTable(PTable);
    PTable^.Last;
    While PTable^.Bof=false do PTable^.Delete;
end;


{==============================================================================}
{===============   ������� ��� ������ ������� ������ ������   =================}
{==============================================================================}
procedure ClearTableList(const PTables: array of PADOTable);
var I: Integer;
begin
    For I:=Low(PTables) to High(PTables) do ClearTable(PTables[I]);
end;


{==============================================================================}
{===================  ������� ��� ����������� � �������  ======================}
{==============================================================================}
procedure FreeTable(const PTable: PADOTable);
begin
    SetDBFilter (PTable, '');
    SetDBSort   (PTable, '');
    SetDBConnect(PTable, nil, '', '');
end;


{==============================================================================}
{=======================  �������ET ������� �� �����  =========================}
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
{=======================  �������ET ������� �� �����  =========================}
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
{=========================  ������������� DATASET  ============================}
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
{=======================  �������ET �������� DATASET  =========================}
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
{=====================  ������������� �������� �������  =======================}
{==============================================================================}
{=======  ��������� ������ � ��������������� ����������� ���������� ===========}
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
{====================  ������������� ������ �� �������  =======================}
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
{==================  ������������� ���������� �� ������� ======================}
{==============================================================================}
procedure SetDBSort(const PTable: PADOTable; const Sort: String);
begin
    // If PTable^.Active = false then Exit;
    If PTable^.Sort<>Sort then PTable^.Sort:=Sort;
end;


{==============================================================================}
{=====================  ������������� ����� �� �������  =======================}
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
    PTable^.IndexFieldNames := IndexFields;         // ���������, �.�. ����� ��������������� ������������� ��� ��������� Master
    PTable^.Active          := IsActive;
//  !!! ������������ ����� � ����� �����������, ����� ��������� ������� ��� SQL
//    If PMasterSource<>nil then PTable^.MasterSource := PMasterSource^;
//    If PTable^.MasterFields    <> MasterFields   then PTable^.MasterFields    := MasterFields;
//    If PTable^.IndexFieldNames <> IndexFields    then PTable^.IndexFieldNames := IndexFields;
end;


{==============================================================================}
{=====  ���������� ����� ������� �������� ������� �� ������� ��������  ========}
{==============================================================================}
function CountRecord_T(const PTable : PADOTable;
                       const FNames : array of String;
                       const VNames : array of String): Integer;
var T0     : TADOTable;
    Filter : String;
    I      : Integer;
begin
    {�������������}
    Result:=0;
    If Length(FNames)<>Length(VNames) then Exit;
    If PTable<>nil then If PTable^.Active=false then Exit;
    Filter:='';

    {���������� �� ��������� � ������ ����}
    For I:=0 to Length(FNames)-1 do If PTable^.FindField(FNames[I])=nil then Exit;

    {���������� ������}
    For I:=0 to Length(FNames)-1 do Filter:=Filter+'(['+FNames[I]+']='+QuotedStr(VNames[I])+') AND ';
    Delete(Filter, Length(Filter)-3, 4);

    {������� ���� ������� ����� �� �������� �� ���������}
    T0:=CloneTable(PTable); If T0=nil then Exit;

    {���������� ����� ������� �������� �������}
    try
       SetDBFilter(@T0, Filter);
       Result:=T0.RecordCount;
    finally
       T0.Free;
    end;
end;



{==============================================================================}
{=======================   ����� ������ ���� ������   =========================}
{==============================================================================}
function FindBDTables(const PBD: PADOConnection; const LTableNames: array of String): Boolean;
var ITab  : Integer;
    SList : TStringList;
begin
    {�������������}
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
{===============   ����� ������, ������������ � ���� ������   =================}
{==============================================================================}
function FindDataSet(const PBD: PADOConnection; const TName: String): TADODataSet;
var I: Integer;
begin
    {�������������}
    Result:=nil;
    If PBD=nil then Exit;

    {������������� ������ ������}
    For I:=0 to PBD^.DataSetCount-1 do begin
       If CmpStr(TName, PBD^.DataSets[I].Name) then begin
          Result:=TADODataSet(PBD^.DataSets[I]);
          Break;
       end;
    end;
end;


{==============================================================================}
{==============  ������������� ������ �� �������� ����������  =================}
{==============================================================================}
{==============  SVar = ���������� ����.1                     =================}
{==============================================================================}
function PosDataSet(const PDataSet: PADODataSet; const SVar: String): Boolean;
var S: String;
begin
    S := CutSlovoEndChar(SVar, 1, '.');
    If S<>'' then Result := PDataSet^.Locate(F_COUNTER, S, [])
             else Result := false;
end;


{==============================================================================}
{=========  ���������� ������ (F_COUNTER) ������ �� ��������� �����  ==========}
{==============================================================================}
function GetIndRecord(const PBD: PADOConnection; const TName: String;
                      const FName, Val: array of String): String;
var SFilter : String;
    I       : Integer;
begin
    {�������������}
    Result:='';
    If PBD=nil then Exit;
    If TName='' then Exit;
    If Length(FName)<>Length(Val) then Exit;

    {������� ������}
    SFilter:='';
    For I:=Low(FName) to High(FName) do SFilter:=SFilter+' AND (['+FName[I]+']='+QuotedStr(Val[I])+')';
    Delete(SFilter, 1, 5);

    {���� � ������ ������}
    Result := ReadFieldFromFilter(PBD, TName, SFilter, F_COUNTER, true);
end;



{==============================================================================}
{==================  ������ �������� ���� ������ F_COUNTER   ==================}
{==============================================================================}
function ReadField(const PBD: PADOConnection; const TName: String; const ICounter: Integer; const SField: String): String;
begin
    Result := ReadFieldFromFilter(PBD, TName, '['+F_COUNTER+']='+IntToStr(ICounter), SField, true);
end;


{==============================================================================}
{====  ������ �������� ���� SFIELD ������, ������������ �������� SFILTER  =====}
{==============================================================================}
function ReadFieldFromFilter(const PBD: PADOConnection; const TName, SFilter, SField: String; const OnlyOneRec: Boolean): String;
var T: TADOTable;
begin
    {�������������}
    Result := '';
    T:=TADOTable.Create(nil);
    try
       {������������� �������}
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
{==============   ���������� �� ������, ������������ ��������   ===============}
{==============           ������������� �� ��� ���������        ===============}
{==============================================================================}
function IsExistsRec(const PData: PADODataSet; const LField, LVal: array of String): Boolean;
var I, IHigh : Integer;
    FList    : array of TField;
begin
    {�������������}
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

