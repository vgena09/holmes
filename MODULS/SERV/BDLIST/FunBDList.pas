unit FunBDList;

interface
uses
   System.Classes, System.SysUtils,
   Vcl.Dialogs, Vcl.Controls,
   Data.DB, Data.Win.ADODB,
   FunType;

{Обновляет список вариантов подстановки}
function  RefreshListItem(const PTable: PADOTable; const Category: String): String;
{Получает список вариантов подстановки}
procedure GetListItemCBox(const PCBox: PDBComboBox; const PTable: PADOTable; const sFile: String; const sFilter: String);
function  GetListItem(const PTable: PADOTable; const sFile: String; const sFilter: String): String;

implementation

uses FunConst, FunBD,
     MBDLIST {RefreshListItem};

{******************************************************************************}
{****************  РАБОТА СО СПИСКАМИ ВАРИАНТОВ ПОДСТАНОВКИ  ******************}
{******************************************************************************}

{==============================================================================}
{================   ОБНОВЛЯЕМ СПИСОК ВАРИАНТОВ ПОДСТАНОВКИ   ==================}
{================             ТОЛЬКО ДЛЯ BUDLIST             ==================}
{==============================================================================}
function RefreshListItem(const PTable: PADOTable; const Category: String): String;
var F: TFBDLIST;
begin
    {Инициализация}
    Result:='';
    If Category='' then Exit;

    F:=TFBDLIST.Create(nil);
    try     F.Execute(PTable, Category);
    finally F.Free;
    end;

    Result:=GetListItem(PTable, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(Category));
end;


{==============================================================================}
{================    ПОЛУЧАЕМ СПИСОК ВАРИАНТОВ ПОДСТАНОВКИ   ==================}
{================             ДЛЯ ЛЮБОГО СПИСКА              ==================}
{==============================================================================}
{================ SField - поле для списка                   ==================}
{================ SFilter - условие отбора                   ==================}
{==============================================================================}
procedure GetListItemCBox(const PCBox: PDBComboBox; const PTable: PADOTable;
                          const sFile: String;     const sFilter: String);
begin
    With PCBox^.Items do begin
       BeginUpdate;
       Text := GetListItem(PTable, sFile, sFilter);
       EndUpdate;
    end;
end;

function GetListItem(const PTable: PADOTable; const sFile: String; const sFilter: String): String;
var T: TADOTable;
begin
    {Инициализация}
    Result:='';
    If PTable = nil then Exit;
    T := LikeTable(PTable); If T=nil then Exit;  //RefreshTable(@T);
    try
       If sFilter <> '' then SetDBFilter(@T, sFilter);
       T.Sort:='['+sFile+'] ASC';
       T.First;
       {Формируем список вариантов подстановки}
       While not T.Eof do begin
          Result := Result+T.FieldByName(sFile).AsString+CH_NEW;
          T.Next;
       end;
       If Result<>'' then Delete(Result, Length(Result)-1, 2);
    finally
       If T.Active then T.Close;
       T.Free;
    end;
end;

end.

