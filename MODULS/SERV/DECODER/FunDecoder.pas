{==============================================================================}
{=============                  Д Е К О Д Е Р                    ==============}
{==============================================================================}
unit FunDecoder;

interface
uses
   System.Classes, System.SysUtils,
   Vcl.Forms, Vcl.Dialogs, Vcl.Controls,
   IdGlobal,
   Data.DB, Data.Win.ADODB,
   MAIN,
   FunType, FunText, FunIDE;

type
   TDECOD = class(TObject)

  public
    Err    : Boolean;               // признак ошибки

    constructor Create(const IDDocument: String);
    destructor  Destroy; override;

    {************************  Внешние функции  *******************************}
    {Модуль:  FunDecoder}
    function  DecoderOle (const DecStr: String): String;        // декодер OLE
    function  DecoderList(const PList   : PStringList): String; // декодер списка
    function  Decoder    (const DecStr  : String): String;      // декодер базовый

  private
    ID_DOC    : String;                                                    // идентификатор обрабатываемого документа
    FFMAIN    : TFMAIN;
    PUD, PVAR : PADOTable;                                                 // указатель на текущую таблицу декодера
    TPPERSON, TLPERSON, TDPERSON, TOBJECT : TADOTable;
    TVAR_COMMON, TVAR, TDOC               : TADOTable;
    IsOLE     : Boolean;                                                   // признак срабатывания OLE-декодера

    function  DecoderPack     (const DecStr : String): String;             // декодер пакетов

    {Модуль:  FunDecoder_Function}
//   function  PrmToPrmRec     (const PPrm    : PArrayStr;
//                              const PPrmRec : PArrayPrmRec;
//                              const LDecod  : array of TFunDecod;
//                              const PLTab   : array of PADOTable): Integer;
//   procedure GetTabDecoder   (const PLTab   : array of PADOTable; var PUD, PVAR: PADOTable);


    {Модуль:  FunDecoder_Pack_IF}
    function  DecoderCondOrg  (const DecStr  : String): Boolean;           // организатор декодирования и анализа выражения-условия


    {************************  Внутренние функции  *****************************}
    {Модуль:  FunDecoder}
    function  DecoderBlock    (var  DecStr    : String): Boolean;
    function  DecoderOperand  (var DecStr     : String; const Kod: String): Boolean;

    {Модуль:  FunDecoder_Pack_IF}
    function  DecoderPackIF   (const DecStr   : String): String;
    function  DecoderCond     (var   DecStr   : String): Boolean;

    {Модуль:  FunDecoder_Pack_LOOP}
    function  DecoderPackLoop (const DecStr   : String): String;

    {Модуль:  FunDecoder_Pack_PROG}
//   function  DecoderPackPROG (const DecStr   : String;
//                              const LDecod   : array of TFunDecod;
//                              const PLTab    : array of PADOTable;
//                              const PErr     : PBoolean): String;
//   function  DecoderProg     (var   DecStr   : String;
//                              const LDecod   : array of TFunDecod;
//                              const PLTab    : array of PADOTable): Boolean;
//   function  DecoderProgStep (var   DecStr   : String;
//                              const LDecod   : array of TFunDecod;
//                              const PLTab    : array of PADOTable): Boolean;

    {Субмодуль: FunDecoder_Pack_PROG_Function}
//   function  FProgUDAdd      (const TName     : String;
//                              const PrmRec    : TArrayPrmRec;
//                              const PVAR, PUD : PADOTable): String;
//   function  FProgUDRel      (const TName     : String;
//                              const PrmRec    : TArrayPrmRec;
//                              const PVAR, PUD : PADOTable): String;
//   function  FProgUDDel      (const TName     : String;
//                              const PrmRec    : TArrayPrmRec;
//                              const PVAR, PUD : PADOTable): String;


    {Модуль:  FunDecoder_DateTime}
    function  FDateTimeNow(const Prm: array of String): String;
    function  FDateNow(const Prm: array of String): String;
    function  FTimeNow(const Prm: array of String): String;
    function  StrDateTimeCorrect(const T0: TDateTime; const Prm: array of String): TDateTime;
    function  StrTimeCorrect(const T0: TDateTime; const Prm: array of String): TDateTime;

    {Модуль:  FunDecoder_Articles}
    function  GetArticles: String;
    function  FindFromSanctionArticles(const DecStr: String; const Prm: array of String): String;

    {Модуль:  FunDecoder_Text}
    function  DopDecoderBase(var   DecStr : String;
                             const Kod    : String): Boolean;     //дополнительный модуль декодера
    function  FCutLines(const DecStr: String; const Num: Integer): String;
    function  FSetStr(const Kod: String): String;
    function  FFindPrm(const Prm: array of String): String;
    function  FSexPrm(const DecStr: String; const Prm: array of String): String;
    function  FMsgDlg(const DecStr: String; const Prm: array of String): String;
    function  FInpDlg(const DecStr: String; const Prm: array of String): String;
    function  FKodChr(const Prm: array of String): String;
    function  MyCharUpper(const StrKod: String; const Prm: array of String): String;
    procedure SeparatKod(const Kod: String; var Cmd: String; var Prm: TArrayStr);
    function  GetPrm(const Prm: array of String; const Ind: Integer): String;


    {Модуль:  FunDecoder_Text_Participants}
    function  FMacroParticipantsList: String;
    function  FMacroParticipantsRights(const Prm: TArrayStr): String;
    function  FMacroParticipantsSign: String;
    function  DecodErr(const S: String): String;
    function  CountPart: Integer;
    function  CountRest: Integer;
    function  SpaceStat(const Stat: String): String;

    {Модуль:  FunDecoder_Text_Fixation}
    function  FMacroMediaInform(const Prm: TArrayStr): String;
    function  FMacroMediaShow  (const Prm: TArrayStr): String;

    {Модуль: FunDecoder_Var}
    function  DopDecoderVar(var DecStr: String; const Kod: String): Boolean;
    function  VarFind(const VarName: String): PADOTable;
    function  FVarVal(const Prm: TArrayStr): String;
    function  FVarEmpty(const Prm: TArrayStr): String;
    function  FVarChange (const Prm: TArrayStr): String;
    function  FDocAddHint(const SText: String): Boolean;
    function  FDocControlTerm(const Prm: TArrayStr): Boolean;
    function  FDocControlDate(const Prm: TArrayStr): Boolean;
    function  FDocCaption(const Prm: TArrayStr): Boolean;

    {Модуль: FunDecoder_Tab}
    function  DopDecoderTab(var DecStr: String; const Kod: String): Boolean;
    function  SetDecoderTable(const TName: String): Boolean;
    function  SetDecoderKey(const Key: String): Boolean;

    function  IsTableUD(const Table: String): Boolean;
    function  FUDChange(const Prm: TArrayStr): Boolean;

    {Модуль: FunDecoder_Tab_COMMON}
    function  IsField(const SField: String): Boolean;
    function  ReadField(const SField: String; const SCount: String): String;
    function  FSexText(const Prm: TArrayStr): String;
    function  FReadSex: Boolean;
    function  FStatus(const SPadeg: String; const OnlyMan: Boolean = false): String;
    procedure FEditElement;

    {Модуль: FunDecoder_Tab_PPERSON}
    function  FFIOPP(const S: String): String;
    function  FAdressPP(const S: String): String;
    function  FRogdeniePP(const S: String): String;
    function  FDocumentPP(const S: String): String;
    function  FVozrastPP(const S: String): String;

    {Модуль: FunDecoder_Tab_LPERSON}
    function  NameLP(const S: String): String;
    function  NameShortLP(const S: String): String;
    function  FFIOSherifLP(const S: String): String;

    {Модуль: FunDecoder_Tab_DPERSON}
    function  FFIODP(const S: String): String;
    function  FDocumentDP(const S: String): String;

    {Модуль: FunDecoder_Tab_OBJECT}
    function  FObjectsPack(const S: String): String;


end;

implementation

uses FunConst, FunSys, FunBD, FunDay, FunPadeg, FunList, FunOle, FunVcl,
     FunClip, FunArt,
     MVAR_UD_EDIT_PPERSON, MVAR_UD_EDIT_LPERSON, MVAR_UD_EDIT_DPERSON,
     MVAR_UD_EDIT_OBJECT;

//{$INCLUDE FunDecoder_Function}
{$INCLUDE FunDecoder_Pack_IF}
{$INCLUDE FunDecoder_Pack_LOOP}
//{$INCLUDE FunDecoder_Pack_PROG}
//{$INCLUDE FunDecoder_Pack_PROG_Function}
{$INCLUDE FunDecoder_DateTime}
{$INCLUDE FunDecoder_Articles}
{$INCLUDE FunDecoder_Text}
{$INCLUDE FunDecoder_Text_Participants}
{$INCLUDE FunDecoder_Text_Fixation}

{$INCLUDE FunDecoder_Var}
{$INCLUDE FunDecoder_Tab}
{$INCLUDE FunDecoder_Tab_COMMON}
{$INCLUDE FunDecoder_Tab_PPERSON}
{$INCLUDE FunDecoder_Tab_LPERSON}
{$INCLUDE FunDecoder_Tab_DPERSON}
{$INCLUDE FunDecoder_Tab_OBJECT}


{==============================================================================}
{========================  К О Н С Т Р У К Т О Р  =============================}
{==============================================================================}
constructor TDECOD.Create(const IDDocument: String);
begin
    // inherited(IDDocument);
    FFMAIN      := TFMAIN(GlFindComponent('FMAIN'));
    TPPERSON    := LikeTable(@FFMAIN.BUD.TPPERSON);
    TLPERSON    := LikeTable(@FFMAIN.BUD.TLPERSON);
    TDPERSON    := LikeTable(@FFMAIN.BUD.TDPERSON);
    TOBJECT     := LikeTable(@FFMAIN.BUD.TOBJECT);
    PUD         := nil;
    PVAR        := nil;
    TVAR_COMMON := LikeTable(@FFMAIN.BSET_LOCAL.TVAR);
    TVAR        := LikeTable(@FFMAIN.BUD.TVAR);
    TDOC        := LikeTable(@FFMAIN.BUD.TDOC);
    ID_DOC      := IDDocument;
    If ID_DOC <> '' then SetDBFilter(@TDOC, '['+F_COUNTER+']='+ID_DOC)
                    else SetDBFilter(@TDOC, '');
end;

{==============================================================================}
{=========================  Д Е С Т Р У К Т О Р  ==============================}
{==============================================================================}
destructor TDECOD.Destroy;
begin
    PUD  := nil;
    PVAR := nil;
    DestrTable(@TPPERSON);
    DestrTable(@TLPERSON);
    DestrTable(@TDPERSON);
    DestrTable(@TOBJECT);
    DestrTable(@TVAR_COMMON);
    DestrTable(@TVAR);
    DestrTable(@TDOC);
    inherited;
end;


{==============================================================================}
{============================    ДЕКОДЕР OLE   ================================}
{==============================================================================}
(*========  DecStr = ___ { __ { ___ } ___ { ___ { ___ } ___} } ____ ==========*)
{==============================================================================}
{====  Результат: в Result и в [Clipboard]                                 ====}
(*===  Не обрабатывает в поток: {текст {OLE} текст}                        ===*)
(*===                   только: {OLE}                                      ===*)
{==============================================================================}
function TDECOD.DecoderOle(const DecStr: String): String;
begin
    IsOLE  := false;
    Result := Decoder(DecStr);
    If not IsOLE then PutStringInClipboard(Result);
end;


{==============================================================================}
{==========================    ДЕКОДЕР СПИСКА   ===============================}
{==============================================================================}
function TDECOD.DecoderList(const PList: PStringList): String;
var S : String;
    I : Integer;
begin
    {Инициализация}
    Err := false;
    If PList = nil then Exit;

    For I:=0 to PList^.Count-1 do begin
       S := Trim(PList^[I]);
       If S=''               then Continue;   {Пустая строка недопустима}
       If Copy(S, 1, 2)='//' then Continue;   {Комментарий недопустим}

       Result := Decoder('{'+S+'}');
       If Err then begin ErrMsg('Ошибка декодера DecoderList:'+CH_NEW+S); Break; end;
       If CmpStr(Result, 'СТОП') then Break;
    end;
end;


{==============================================================================}
{=========================    ДЕКОДЕР БАЗОВЫЙ   ===============================}
{==============================================================================}
{====      ПЕРЕМЕННЫЕ-ПОТОКИ ОБРАБАТЫВАЮТСЯ В ДОПОЛНИТЕЛЬНЫХ ФУНКЦИЯХ      ====}
{====          (ПРИ ЭТОМ OLE В CLIPBOARD, А RESULT=FALSE)                  ====}
{==============================================================================}
(*===  DecStr = ___ { __ { ___ } ___ { ___ { ___ } ___} } ____             ===*)
{==============================================================================}
function TDECOD.Decoder(const DecStr: String): String;
var S  : String;
    S0 : String;
    B  : Boolean;
begin
    {Инициализация}
    Result := DecStr;
    Err    := false;
    If Trim(Result)='' then Exit;

    {Обработка пакетов}
    Result:=DecoderPack(Result);

    {Читаем первый блок}
    S:=CutModulChar(Result, CH1, CH2);             // S = Операнд1.Операнд2. ...

    {Декодируем блоки}
    While S<>'' do begin

    {==========================================================================}
    {==================   ЗАДАНИЕ НА ПЕРСПЕКТИВУ  =============================}
    {==========================================================================}
    {=======  Если S содержит функцию                                  ========}
    {=======  ее не следует рассматривать как: Операнд1.Операнд2. ...  ========}
    {=======  ее следует просто выполнить                              ========}
    {==========================================================================}

       {Если это условие, то проверяем его}
       S0:=S;
       If DecoderCond(S0) then begin
          S:=S0; B:=true;
       end else
       {Иначе декодируем один блок в фигурных скобках}
       begin
          B:=DecoderBlock(S);
       end;

       {Производим замену на декодированную строку}
       Result:=ReplModulChar(Result, S, CH1, CH2);

       {Если ошибка, то незачем далее обрабатывать строку}
       If not B then begin
          Err:=true;
          Break;
       end;

       {Следующий блок}
       S:=CutModulChar(Result, CH1, CH2);
    end;
end;


{==============================================================================}
{==========              Д Е К О Д Е Р     П А К Е Т А                =========}
{==============================================================================}
(*=========        DecStr = {If выражение then aaaaa else bbbb}       ========*)
(*=========        DecStr =  If выражение then aaaaa else bbbb        ========*)
{==============================================================================}
function TDECOD.DecoderPack(const DecStr : String): String;
const SPACK_TYPE_LIST : array[0..5] of String = ('LOOP', 'IF ', 'ADD', 'REL', 'DEL', 'PRIORITET');        // Недопустимо с 1..
      BLOCK = 'IF';
var SPack   : String;
    IndType : Integer;

begin
    {Инициализация}
    Result:=DecStr;
    If Trim(Result)='' then Exit;

    {Читаем первый пакет SPack}
    IndType:=CutModulPackList(Result, SPACK_TYPE_LIST, SPack);

    {Декодируем пакеты}
    While IndType>-1 do begin

       {Декодируем один пакет в фигурных скобках в зависимости от типа}
       Case IndType of
       {LOOP}      0:     SPack:=DecoderPackLOOP (SPack);
       {IF}        1:     SPack:=DecoderPackIF   (SPack);
//       {PROG}      2,3,4: SPack:=DecoderPackPROG (SPack, LDecod, PLTab, PErr);
       {PRIORITET} 5:     SPack:=Decoder('{'+CutModulChar(SPack, '(', ')')+'}');
       else Break;
       end;

       {Производим замену на декодированную строку}
       Result:=ReplModulPack(Result, SPack, SPACK_TYPE_LIST[IndType]);

       {Если ошибка, то незачем далее обрабатывать строку}
       If Err then Break;

       {Следующий пакет}
       IndType:=CutModulPackList(Result, SPACK_TYPE_LIST, SPack);
    end;
end;



{==============================================================================}
{=============            Д Е К О Д Е Р     Б Л О К А            ==============}
{==============================================================================}
{=============          DecStr = Операнд1.Операнд2. ...          ==============}
{==============================================================================}
function TDECOD.DecoderBlock(var DecStr : String): Boolean;
var S, S0: String;
begin
    {Инициализация}
    Result := true;
    S0     := DecStr;
    DecStr := '';

    {Поочередно просматриваем все операнды блока}
    S := CutClass(S0);
    While S <> '' do begin
       {Декодируем очередной операнд}
       Result := DecoderOperand(DecStr, S);

       {Если ошибка, то незачем далее обрабатывать строку}
       If not Result then Break;

       {Следующий операнд}
       S := CutClass(S0);
    end;
end;



{==============================================================================}
{=============         Д Е К О Д Е Р     О П Е Р А Н Д А         ==============}
{==============================================================================}
{=============                   Kod = Операнд                   ==============}
{==============================================================================}
function TDECOD.DecoderOperand(var DecStr: String; const Kod: String): Boolean;
begin
    {Инициализация}
    Result:=true;
    If Kod='' then begin Result:=false; Exit; end;

    {Запускаем дополнительные декодеры}
    If DopDecoderVar(DecStr,  Kod) then Exit;
    If DopDecoderTab(DecStr,  Kod) then Exit;
    If DopDecoderBase(DecStr, Kod) then Exit;

    {Ошибка: ни один декодер не сработал}
    Result:=false;
    DecStr:=Kod;
end;


end.

