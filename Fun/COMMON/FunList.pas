unit FunList;

interface

uses System.SysUtils, System.Classes, System.Math,
     Vcl.Dialogs, IdGlobal,
     FunType;


{ОПЕРАЦИИ СО STRING_LIST}

{Читает значение из списка TStringList}
function  LRead(const PList: PStringList; const SKey: String; const SVal0: String): String;
{Добавляет в Plist уникальные записи PListAdd}
procedure LAddUniq(const PList, PListAdd: PStringList);

{ОПЕРАЦИИ С SECTION}

{Копирует секцию Section (без заголовка) из списка PSrc^ в список PDest^}
function  LSectionCopy(const PSrc, PDest: PStringList; const Section: String): Boolean;
{Удаляет из списка PLsit^ секцию Section}
function  LSectionDel(const PList: PStringList; const Section: String): Boolean;

{ОПЕРАЦИИ С ELEMENT}

{Добавляет значение в список}
procedure LElementAdd(const PList: PStringList; const Section: String; const Element: String);
{Удаляет значение из списка}
procedure LElementDel(const PList: PStringList; const Section: String; const Element: String);

{ОПЕРАЦИИ С KEY}

{Заменяет в списке PList^ секции Section все Key на PKey^}
procedure LKeyReplace(const PList, PKey: PStringList; const Section, Key: String);
{Оставляет в списке PLsit^ только элементы Key.*}
procedure LKeySel(const PList: PStringList; const Key: String);
{Удаляет в списке PList^ только элементы Key.*}
procedure LKeyDel(const PList: PStringList; const Key: String);
{Количество в списке PList^ элементов Key.*}
function  LKeyCount(const PList: PStringList; const Key: String): Integer;
{Копирует значения элемента из списка в новый список}
function  LElementCopyKey(const PSrc, PDest: PStringList; const Element: String): Boolean;

{ОПЕРАЦИИ С МУЛЬТИСТРОКОЙ}

{Разделяет мультистроку в массив}
function  MStrSeparat(const MStr: String; const PLStr: PStringList; const Separator: String): Boolean;
{Собирает массив в мультистроку}
function  MStrGroup(const PLStr: PStringList; const Separator: String): String;
{Читает ILine (0, 1, ...) строку мультистроки MStr}
function  MStrRead(const MStr: String; const ILine: Integer): String;

implementation

uses FunConst, FunText;


{******************************************************************************}
{*********************   ОПЕРАЦИИ СО STRING_LIST   ****************************}
{******************************************************************************}

{==============================================================================}
{=================  Читает значение из списка TStringList  ====================}
{==============================================================================}
function LRead(const PList: PStringList; const SKey: String; const SVal0: String): String;
var I: Integer;
begin
    I := PList^.IndexOfName(SKey);
    If I > -1 then Result := Trim(PList^.ValueFromIndex[I])
              else Result := SVal0;
end;

{==============================================================================}
{==============  Добавляет в Plist уникальные записи PListAdd  ================}
{==============================================================================}
procedure LAddUniq(const PList, PListAdd: PStringList);
var I: Integer;
begin
    For I:=0 to PListAdd^.Count-1 do begin
       If PList^.IndexOf(PListAdd^[I]) < 0 then PList^.Add(PListAdd^[I]);
    end;
end;



{******************************************************************************}
{************************   ОПЕРАЦИИ С SECTION   ******************************}
{******************************************************************************}


{==============================================================================}
{=== Копирует секцию Section (без заголовка) из списка PSrc^ в список PDest^ ==}
{==============================================================================}
{============  [Секция 1]             =========================================}
{============  ...           --> ...  =========================================}
{============  [Секция 2]             =========================================}
{============  ...                    =========================================}
{==============================================================================}
function LSectionCopy(const PSrc, PDest: PStringList; const Section: String): Boolean;
var I     : Integer;
    B     : Boolean;
    S, S0 : String;
begin
    {Инициализация}
    Result:=false;
    If (PSrc=nil) or (PDest=nil) then Exit;
    PDest^.Clear;
    S0:=AnsiUpperCase(Section);
    B:=false;

    For I:=0 to PSrc^.Count-1 do begin
       S:=Trim(CutModulChar(Trim(PSrc^[I]), '[', ']'));
       If S <> '' then B := (AnsiUpperCase(S) = S0)
                  else If B then PDest^.Add(PSrc^[I]);
    end;
    Result:=true;
end;


{==============================================================================}
{============  Удаляет из списка PList^ секцию Section  =======================}
{==============================================================================}
{============  [Секция 1]        X    =========================================}
{============  ...               X    =========================================}
{============  [Секция 2]             =========================================}
{============  ...                    =========================================}
{==============================================================================}
function LSectionDel(const PList: PStringList; const Section: String): Boolean;
label Nx;
var I     : Integer;
    B     : Boolean;
    S, S0 : String;
begin
    {Инициализация}
    Result := false;
    If PList=nil then Exit;
    S0     := AnsiUpperCase(Section);
    B      := false;
    I      := 0;

Nx: If I <= PList^.Count-1 then begin
       {Проверяем название секции}
       S := Trim(CutModulChar(Trim(PList^[I]), '[', ']'));
       If S <> '' then B := (AnsiUpperCase(S) = S0);
       {Удаляем запись или переходим к следующей}
       If B then PList^.Delete(I)
            else I:=I+1;
       {Следующая запись}
       Goto Nx;
    end;

    {Возвращаемый результат}
    Result:=true;
end;



{******************************************************************************}
{************************   ОПЕРАЦИИ С ELEMENT   ******************************}
{******************************************************************************}

{==============================================================================}
{=======================  Добавляет значение в список  ========================}
{==============================================================================}
procedure LElementAdd(const PList: PStringList; const Section: String; const Element: String);
var L: TStringList;
begin
    L := TStringList.Create;
    try
       LSectionCopy(PList, @L, Section);
       LSectionDel(PList, Section);
       L.Add(Element);
       PList^.Text := PList^.Text+'['+Section+']'+CH_NEW+L.Text;
    finally L.Free;
    end;
end;


{==============================================================================}
{=======================  Удаляет значение из списка     ======================}
{=======================  Element = '' - удаляет секцию  ======================}
{==============================================================================}
procedure LElementDel(const PList: PStringList; const Section: String; const Element: String);
var L : TStringList;
    I : Integer;
begin
    L := TStringList.Create;
    try
       LSectionCopy(PList, @L, Section);
       LSectionDel(PList, Section);
       If Element = '' then Exit;
       I := L.IndexOf(Element);
       If I > -1 then L.Delete(I);
       If L.Count = 0 then Exit;
       PList^.Text := PList^.Text+'['+Section+']'+CH_NEW+L.Text;
    finally L.Free;
    end;
end;



{******************************************************************************}
{**************************   ОПЕРАЦИИ С KEY   ********************************}
{******************************************************************************}

{==============================================================================}
{========  Заменяет в списке PList^ секции Section все Key на PKey^  ==========}
{========  Если после обновления секция пуста, то она удаляется      ==========}
{========  Сортирует добавляемые данные                              ==========}
{==============================================================================}
procedure LKeyReplace(const PList, PKey: PStringList; const Section, Key: String);
var LSection : TStringList;
    I        : Integer;
begin
    LSection := TStringList.Create;
    try
       LSectionCopy(PList, @LSection, Section);
       LKeyDel(@LSection, Key);
       LSectionDel(PList, Section);
       If (LSection.Count > 0) or (PKey^.Count > 0) then begin
          LSection.Text := LSection.Text+PKey^.Text;
          LSection.Sort;
          PList^.Text := PList^.Text+'['+Section+']'+CH_NEW+LSection.Text;
          For I := PList^.Count-1 downto 0 do If PList^[I]='' then PList^.Delete(I);
       end;
    finally
       LSection.Free;
    end;
end;


{==============================================================================}
{===========   Оставляет в списке PList^ только элементы Key.*  ===============}
{==============================================================================}
{============  Key1.Val1 <-- Key=Key1                           ===============}
{============  Key1.Val2 <--                                    ===============}
{============  Key2.Val3                                        ===============}
{============  Key2.Val4                                        ===============}
{==============================================================================}
procedure LKeySel(const PList: PStringList; const Key: String);
var I: Integer;
begin
    For I:=PList^.Count-1 downto 0 do begin
       If Not CmpStr(CutSlovo(PList^[I], 1, '.'), Key) then PList^.Delete(I);
    end;
end;


{==============================================================================}
{===========   Удаляет в списке PList^ только элементы Key.*    ===============}
{==============================================================================}
procedure LKeyDel(const PList: PStringList; const Key: String);
var I: Integer;
begin
    For I:=PList^.Count-1 downto 0 do begin
       If CmpStr(CutSlovo(PList^[I], 1, '.'), Key) then PList^.Delete(I);
    end;
end;


{==============================================================================}
{===========   Количество в списке PList^ элементов Key.*       ===============}
{==============================================================================}
function LKeyCount(const PList: PStringList; const Key: String): Integer;
var L: TStringList;
begin
    L := TStringList.Create;
    try     L.Text := PList^.Text;
            LKeySel(@L, Key);
            Result := L.Count;
    finally L.Free;
    end;
end;


{==============================================================================}
{==========   Копирует значения элемента из списка в новый список  ============}
{==============================================================================}
{============  Элемент1.Значение1                                 =============}
{============  Элемент1.Значение2                                 =============}
{============  Элемент2.Значение3 --> Значение3                   =============}
{============  Элемент2.Значение4 --> Значение3                   =============}
{==============================================================================}
function LElementCopyKey(const PSrc, PDest: PStringList; const Element: String): Boolean;
var I, J  : Integer;
    S, S0 : String;
begin
    {Инициализация}
    Result:=false;
    If (PSrc=nil) or (PDest=nil) then Exit;
    If PSrc=PDest then Exit;
    PDest^.Clear;
    S0:=AnsiUpperCase(Element);

    For I:=0 to PSrc^.Count-1 do begin
       S:=AnsiUpperCase(CutSlovo(PSrc^[I], 1, '.'));
       If S=S0 then begin
          J:=InStrMy(1, PSrc^[I], '.');
          If J>=0 then begin
             S:=PSrc^[I];
             Delete(S, 1, J);
             PDest^.Add(Trim(S));
          end;
       end;
    end;

    {Возвращаемый результат}
    Result:=true;
end;



{******************************************************************************}
{*********************   ОПЕРАЦИИ С МУЛЬТИСТРОКОЙ   ***************************}
{******************************************************************************}

{==============================================================================}
{=====================  Разделяет мультистроку в массив  ======================}
{==============================================================================}
function MStrSeparat(const MStr: String; const PLStr: PStringList; const Separator: String): Boolean;
var S: String;
    I: Integer;
begin
    {Инициализация}
    Result:=false;
    If PLStr=nil then Exit;
    PLStr^.Clear;

    {Просматриваем все статусы и формируем список}
    I:=1; S:=CutSlovo(MStr, I, Separator);
    While S<>'' do begin
       Result:=true;
       PLStr^.Add(S);
       Inc(I); S:=CutSlovo(MStr, I, Separator);
    end;
end;


{==============================================================================}
{=====================  Собирает массив в мультистроку   ======================}
{==============================================================================}
function MStrGroup(const PLStr: PStringList; const Separator: String): String;
var I: Integer;
begin
    {Инициализация}
    Result:='';
    If PLStr=nil then Exit;

    {Просматриваем все статусы и формируем строку}
    For I:=0 to PLStr^.Count-1 do Result:=Result+Separator+PLStr^[I];

    {Удаляем последние символа разделителя}
    If Result<>'' then Delete(Result, 1, Length(Separator));
end;


{==============================================================================}
{==============  Читает ILine (0, 1, ...) строку мультистроки MStr  ===========}
{==============================================================================}
function MStrRead(const MStr: String; const ILine: Integer): String;
var SList: TStringList;
begin
    Result := '';
    SList  := TStringList.Create;
    try
       SList.Text := MStr;
       If (SList.Count < 0) or (ILine >= SList.Count) then Exit;
       Result := SList[ILine];
    finally
       SList.Free;
    end;
end;


end.

