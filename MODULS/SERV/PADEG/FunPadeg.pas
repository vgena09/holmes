unit FunPadeg;

interface
uses
   Winapi.Windows,
   System.Classes, System.SysUtils,
   Vcl.Dialogs, Vcl.Controls,
   Data.DB, Data.Win.ADODB,
   FunType;

function  PadegFIO    (const Padeg_, FIO: String): String;
//function  PadegDLG    (const Padeg_, Str: String): String;
function  PadegAUTO   (const Padeg_, Str: String): String;
function  GetSexFIO(const FIO: String): Boolean;
function  PadegToInt(const PadegChar: String): Integer;
function  SetPredlog(const Str: String): String;
function  FIO_Initialy(const FIO: String; const IsFirstFamily: Boolean): String;

//function  GetOfficePadeg(pOffice: PChar; nPadeg: LongInt; pResult: PChar;
//                          var nLen: LongInt): Integer; stdcall; external
//                          'padeg.dll' Name 'GetOfficePadeg';

implementation

uses FunConst, FunText, FunDay, FunBD, PadegFIO_ANSI {адаптеры Padeg.dll};
     //FunBD_Padeg2, MSERV_LISTBOX;

{******************************************************************************}
{*************** АВТОМАТИЧЕСКОЕ СКЛОНЕНИЕ И ОПРЕДЕЛЕНИЕ ПОЛА ******************}
{******************************************************************************}


{==============================================================================}
{=================   СКЛОНЯЕТ ФАМИЛИЮ, ИМЯ, ОТЧЕСТВО   ========================}
{==============================================================================}
function PadegFIO(const Padeg_, FIO: String): String;
begin
    Result := GetFIOPadegFSAS(FIO, PadegToInt(Padeg_));
end;


{==============================================================================}
{=================  СКЛОНЯЕТ ПУТЕМ ПОИСКА В БД И ДИАЛОГА   ====================}
{==============================================================================}
//function PadegDLG(const Padeg_, Str: String): String;
//var F: TFPadeg2;
//begin
//    F:=TFPadeg2.Create(nil);
//    Result:=F.Execute(Padeg_, Str);
//    F.Free;
//end;


{==============================================================================}
{=====================  АВТОМАТИЧЕСКОЕ СКЛОНЕНИЕ ФРАЗЫ  =======================}
{==============================================================================}
function PadegAUTO(const Padeg_, Str: String): String;
begin
    Result := GetOfficePadeg(Str, PadegToInt(Padeg_));
end;


{==============================================================================}
{===============    О П Р Е Д Е Л Е Н И Е   П О Л А    ========================}
{========================  True - если мужчина  ===============================}
{==============================================================================}
function GetSexFIO(const FIO: String): Boolean;
var S: String;
begin
     Result:=True;
     S:=FIO;
     if Length(S)=0 then Exit;
     if GetColSlov(S,' ')>1 then S:=CutSlovo(S, 2, ' ');
     if ((S[Length(S)]='а')or(S[Length(S)]='я')or
         (S[Length(S)]='А')or(S[Length(S)]='Я')) then Result:=False;
     {Исключения}
     if AnsiUpperCase(S)='ФОМА' then Result:=True;
     if AnsiUpperCase(S)='ЛУКА' then Result:=True;
end;


{==============================================================================}
{==============================  ПАДЕЖ В ЦИФРУ    =============================}
{==============================================================================}
function PadegToInt(const PadegChar: String): Integer;
var Ch: Char;
begin
    If PadegChar='' then Ch:='И' else Ch:=PadegChar[1];
    Case Ch of
    'И': Result := 1;
    'Р': Result := 2;
    'Д': Result := 3;
    'В': Result := 4;
    'Т': Result := 5;
    'П': Result := 6;
    else Result := 1;
    end;
end;


{==============================================================================}
{==========  ОПРЕДЕЛЯЕТ ПРЕДЛОГ ДЛЯ ПРЕДЛОЖНОГО ПАДЕЖА: О ИЛИ ОБ  =============}
{==============================================================================}
function SetPredlog(const Str: String): String;
var S: String;
begin
    {Инициализация}
    Result:=Str;
    If Result='' then Exit;

    S:=AnsiUpperCase(Result);
    Case S[1] of
    'А','Я','Е','Ё','О','У','И','Ы','Э','Ю': Result:='об '+Result;
    else                                     Result:='о ' +Result;
    end;
end;


{==============================================================================}
{===================  Из полных ФИО: Фамилия + инициалы  ======================}
{==============================================================================}
function FIO_Initialy(const FIO: String; const IsFirstFamily: Boolean): String;
var PFIO    : TFIOParts;
    S, Pref : String;
begin
    {Инициализация}
    Result:=Trim(FIO);
    If Length(Result) < 4 then Exit;

    {Обрезаем возможный предлог предложного падежа}
    Pref := '';
    S    := AnsiUpperCase(Result);
    If Pos('НЕУСТАНОВЛЕН', S) > 0 then Exit;
    If S[1]+S[2]+S[3] = 'ОБ '   then begin Pref:=Copy(Result, 1, 3); Delete(Result, 1, 3); end;
    If S[1]+S[2]      = 'О '    then begin Pref:=Copy(Result, 1, 2); Delete(Result, 1, 2); end;


    {Выделяем составляющие FIO и устраняем глюк}
    PFIO := GetFIOParts(Result);
    PFIO.FirstName  := Trim(PFIO.FirstName);
    PFIO.MiddleName := Trim(PFIO.MiddleName);
    PFIO.LastName   := Trim(PFIO.LastName);

    If IsFirstFamily then begin
       Result:=PFIO.LastName;
       If PFIO.FirstName  <> '' then Result:=Result+' '+CutStrPos(PFIO.FirstName,  1, 1)+'.';
       If PFIO.MiddleName <> '' then Result:=Result+    CutStrPos(PFIO.MiddleName, 1, 1)+'.';
    end else begin
       If PFIO.FirstName  <> '' then Result:=           CutStrPos(PFIO.FirstName,  1, 1)+'.';
       If PFIO.MiddleName <> '' then Result:=Result+    CutStrPos(PFIO.MiddleName, 1, 1)+'.';
       Result:=Result+PFIO.LastName;
    end;

    {Восстанавливаем возможный предлог}
    Result:=Pref+Result;
end;

(*   ОТКЛЮЧЕНО ЗА НЕНАДОБНОСТЬЮ
{==============================================================================}
{===================           СКЛОНЯЕТ СТАТУС             ====================}
{==============================================================================}
{===================   Padeg_  - название любого статуса   ====================}
{==============================================================================}
function PadegSTATUS(const P: PADOTable; const Padeg_, Status_: String): String;
var T: TADOTable;

      function VerifyStatusSex(var StatusTxt: String; const List: array of String): Boolean;
      var S  : String;
          Ch : Char;
          I  : Integer;
      begin
          {Инициализация}
          Result:=false;

          {Фильтр}
          S:='';
          For I:=Low(List) to High(List) do S:=S+' OR (['+List[I]+']='+QuotedStr(StatusTxt)+')';
          Delete(S, 1, 4);
          SetDBFilter(@T, S);

          {Найден ли исходный статус}
          If T.RecordCount=0 then Exit;

          {Устанавливаем конечный статус}
          If Padeg_<>'' then Ch:=Padeg_[1] else Ch:='И';
          Case Ch of
          'И': StatusTxt:=T.FieldByName(List[Low(List)+0]).AsString;
          'Р': StatusTxt:=T.FieldByName(List[Low(List)+1]).AsString;
          'Д': StatusTxt:=T.FieldByName(List[Low(List)+2]).AsString;
          'В': StatusTxt:=T.FieldByName(List[Low(List)+3]).AsString;
          'Т': StatusTxt:=T.FieldByName(List[Low(List)+4]).AsString;
          'П': StatusTxt:=T.FieldByName(List[Low(List)+5]).AsString;
          end;
          Result:=true;
      end;

begin
    {Инициализация}
    Result := Status_;
    T      := LikeTable(P);
    try
       If VerifyStatusSex(Result, LSTATUS_MAN) then Exit;  {Мужская транскрипция}
          VerifyStatusSex(Result, LSTATUS_FEM);            {Женская транскрипция}
    finally
       If T.Active then T.Close;  T.Free;
    end;
end;
*)

end.

