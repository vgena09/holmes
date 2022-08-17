{==============================================================================}
{=============                  � � � � � � �                    ==============}
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
    Err    : Boolean;               // ������� ������

    constructor Create(const IDDocument: String);
    destructor  Destroy; override;

    {************************  ������� �������  *******************************}
    {������:  FunDecoder}
    function  DecoderOle (const DecStr: String): String;        // ������� OLE
    function  DecoderList(const PList   : PStringList): String; // ������� ������
    function  Decoder    (const DecStr  : String): String;      // ������� �������

  private
    ID_DOC    : String;                                                    // ������������� ��������������� ���������
    FFMAIN    : TFMAIN;
    PUD, PVAR : PADOTable;                                                 // ��������� �� ������� ������� ��������
    TPPERSON, TLPERSON, TDPERSON, TOBJECT : TADOTable;
    TVAR_COMMON, TVAR, TDOC               : TADOTable;
    IsOLE     : Boolean;                                                   // ������� ������������ OLE-��������

    function  DecoderPack     (const DecStr : String): String;             // ������� �������

    {������:  FunDecoder_Function}
//   function  PrmToPrmRec     (const PPrm    : PArrayStr;
//                              const PPrmRec : PArrayPrmRec;
//                              const LDecod  : array of TFunDecod;
//                              const PLTab   : array of PADOTable): Integer;
//   procedure GetTabDecoder   (const PLTab   : array of PADOTable; var PUD, PVAR: PADOTable);


    {������:  FunDecoder_Pack_IF}
    function  DecoderCondOrg  (const DecStr  : String): Boolean;           // ����������� ������������� � ������� ���������-�������


    {************************  ���������� �������  *****************************}
    {������:  FunDecoder}
    function  DecoderBlock    (var  DecStr    : String): Boolean;
    function  DecoderOperand  (var DecStr     : String; const Kod: String): Boolean;

    {������:  FunDecoder_Pack_IF}
    function  DecoderPackIF   (const DecStr   : String): String;
    function  DecoderCond     (var   DecStr   : String): Boolean;

    {������:  FunDecoder_Pack_LOOP}
    function  DecoderPackLoop (const DecStr   : String): String;

    {������:  FunDecoder_Pack_PROG}
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

    {���������: FunDecoder_Pack_PROG_Function}
//   function  FProgUDAdd      (const TName     : String;
//                              const PrmRec    : TArrayPrmRec;
//                              const PVAR, PUD : PADOTable): String;
//   function  FProgUDRel      (const TName     : String;
//                              const PrmRec    : TArrayPrmRec;
//                              const PVAR, PUD : PADOTable): String;
//   function  FProgUDDel      (const TName     : String;
//                              const PrmRec    : TArrayPrmRec;
//                              const PVAR, PUD : PADOTable): String;


    {������:  FunDecoder_DateTime}
    function  FDateTimeNow(const Prm: array of String): String;
    function  FDateNow(const Prm: array of String): String;
    function  FTimeNow(const Prm: array of String): String;
    function  StrDateTimeCorrect(const T0: TDateTime; const Prm: array of String): TDateTime;
    function  StrTimeCorrect(const T0: TDateTime; const Prm: array of String): TDateTime;

    {������:  FunDecoder_Articles}
    function  GetArticles: String;
    function  FindFromSanctionArticles(const DecStr: String; const Prm: array of String): String;

    {������:  FunDecoder_Text}
    function  DopDecoderBase(var   DecStr : String;
                             const Kod    : String): Boolean;     //�������������� ������ ��������
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


    {������:  FunDecoder_Text_Participants}
    function  FMacroParticipantsList: String;
    function  FMacroParticipantsRights(const Prm: TArrayStr): String;
    function  FMacroParticipantsSign: String;
    function  DecodErr(const S: String): String;
    function  CountPart: Integer;
    function  CountRest: Integer;
    function  SpaceStat(const Stat: String): String;

    {������:  FunDecoder_Text_Fixation}
    function  FMacroMediaInform(const Prm: TArrayStr): String;
    function  FMacroMediaShow  (const Prm: TArrayStr): String;

    {������: FunDecoder_Var}
    function  DopDecoderVar(var DecStr: String; const Kod: String): Boolean;
    function  VarFind(const VarName: String): PADOTable;
    function  FVarVal(const Prm: TArrayStr): String;
    function  FVarEmpty(const Prm: TArrayStr): String;
    function  FVarChange (const Prm: TArrayStr): String;
    function  FDocAddHint(const SText: String): Boolean;
    function  FDocControlTerm(const Prm: TArrayStr): Boolean;
    function  FDocControlDate(const Prm: TArrayStr): Boolean;
    function  FDocCaption(const Prm: TArrayStr): Boolean;

    {������: FunDecoder_Tab}
    function  DopDecoderTab(var DecStr: String; const Kod: String): Boolean;
    function  SetDecoderTable(const TName: String): Boolean;
    function  SetDecoderKey(const Key: String): Boolean;

    function  IsTableUD(const Table: String): Boolean;
    function  FUDChange(const Prm: TArrayStr): Boolean;

    {������: FunDecoder_Tab_COMMON}
    function  IsField(const SField: String): Boolean;
    function  ReadField(const SField: String; const SCount: String): String;
    function  FSexText(const Prm: TArrayStr): String;
    function  FReadSex: Boolean;
    function  FStatus(const SPadeg: String; const OnlyMan: Boolean = false): String;
    procedure FEditElement;

    {������: FunDecoder_Tab_PPERSON}
    function  FFIOPP(const S: String): String;
    function  FAdressPP(const S: String): String;
    function  FRogdeniePP(const S: String): String;
    function  FDocumentPP(const S: String): String;
    function  FVozrastPP(const S: String): String;

    {������: FunDecoder_Tab_LPERSON}
    function  NameLP(const S: String): String;
    function  NameShortLP(const S: String): String;
    function  FFIOSherifLP(const S: String): String;

    {������: FunDecoder_Tab_DPERSON}
    function  FFIODP(const S: String): String;
    function  FDocumentDP(const S: String): String;

    {������: FunDecoder_Tab_OBJECT}
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
{========================  � � � � � � � � � � �  =============================}
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
{=========================  � � � � � � � � � �  ==============================}
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
{============================    ������� OLE   ================================}
{==============================================================================}
(*========  DecStr = ___ { __ { ___ } ___ { ___ { ___ } ___} } ____ ==========*)
{==============================================================================}
{====  ���������: � Result � � [Clipboard]                                 ====}
(*===  �� ������������ � �����: {����� {OLE} �����}                        ===*)
(*===                   ������: {OLE}                                      ===*)
{==============================================================================}
function TDECOD.DecoderOle(const DecStr: String): String;
begin
    IsOLE  := false;
    Result := Decoder(DecStr);
    If not IsOLE then PutStringInClipboard(Result);
end;


{==============================================================================}
{==========================    ������� ������   ===============================}
{==============================================================================}
function TDECOD.DecoderList(const PList: PStringList): String;
var S : String;
    I : Integer;
begin
    {�������������}
    Err := false;
    If PList = nil then Exit;

    For I:=0 to PList^.Count-1 do begin
       S := Trim(PList^[I]);
       If S=''               then Continue;   {������ ������ �����������}
       If Copy(S, 1, 2)='//' then Continue;   {����������� ����������}

       Result := Decoder('{'+S+'}');
       If Err then begin ErrMsg('������ �������� DecoderList:'+CH_NEW+S); Break; end;
       If CmpStr(Result, '����') then Break;
    end;
end;


{==============================================================================}
{=========================    ������� �������   ===============================}
{==============================================================================}
{====      ����������-������ �������������� � �������������� ��������      ====}
{====          (��� ���� OLE � CLIPBOARD, � RESULT=FALSE)                  ====}
{==============================================================================}
(*===  DecStr = ___ { __ { ___ } ___ { ___ { ___ } ___} } ____             ===*)
{==============================================================================}
function TDECOD.Decoder(const DecStr: String): String;
var S  : String;
    S0 : String;
    B  : Boolean;
begin
    {�������������}
    Result := DecStr;
    Err    := false;
    If Trim(Result)='' then Exit;

    {��������� �������}
    Result:=DecoderPack(Result);

    {������ ������ ����}
    S:=CutModulChar(Result, CH1, CH2);             // S = �������1.�������2. ...

    {���������� �����}
    While S<>'' do begin

    {==========================================================================}
    {==================   ������� �� �����������  =============================}
    {==========================================================================}
    {=======  ���� S �������� �������                                  ========}
    {=======  �� �� ������� ������������� ���: �������1.�������2. ...  ========}
    {=======  �� ������� ������ ���������                              ========}
    {==========================================================================}

       {���� ��� �������, �� ��������� ���}
       S0:=S;
       If DecoderCond(S0) then begin
          S:=S0; B:=true;
       end else
       {����� ���������� ���� ���� � �������� �������}
       begin
          B:=DecoderBlock(S);
       end;

       {���������� ������ �� �������������� ������}
       Result:=ReplModulChar(Result, S, CH1, CH2);

       {���� ������, �� ������� ����� ������������ ������}
       If not B then begin
          Err:=true;
          Break;
       end;

       {��������� ����}
       S:=CutModulChar(Result, CH1, CH2);
    end;
end;


{==============================================================================}
{==========              � � � � � � �     � � � � � �                =========}
{==============================================================================}
(*=========        DecStr = {If ��������� then aaaaa else bbbb}       ========*)
(*=========        DecStr =  If ��������� then aaaaa else bbbb        ========*)
{==============================================================================}
function TDECOD.DecoderPack(const DecStr : String): String;
const SPACK_TYPE_LIST : array[0..5] of String = ('LOOP', 'IF ', 'ADD', 'REL', 'DEL', 'PRIORITET');        // ����������� � 1..
      BLOCK = 'IF';
var SPack   : String;
    IndType : Integer;

begin
    {�������������}
    Result:=DecStr;
    If Trim(Result)='' then Exit;

    {������ ������ ����� SPack}
    IndType:=CutModulPackList(Result, SPACK_TYPE_LIST, SPack);

    {���������� ������}
    While IndType>-1 do begin

       {���������� ���� ����� � �������� ������� � ����������� �� ����}
       Case IndType of
       {LOOP}      0:     SPack:=DecoderPackLOOP (SPack);
       {IF}        1:     SPack:=DecoderPackIF   (SPack);
//       {PROG}      2,3,4: SPack:=DecoderPackPROG (SPack, LDecod, PLTab, PErr);
       {PRIORITET} 5:     SPack:=Decoder('{'+CutModulChar(SPack, '(', ')')+'}');
       else Break;
       end;

       {���������� ������ �� �������������� ������}
       Result:=ReplModulPack(Result, SPack, SPACK_TYPE_LIST[IndType]);

       {���� ������, �� ������� ����� ������������ ������}
       If Err then Break;

       {��������� �����}
       IndType:=CutModulPackList(Result, SPACK_TYPE_LIST, SPack);
    end;
end;



{==============================================================================}
{=============            � � � � � � �     � � � � �            ==============}
{==============================================================================}
{=============          DecStr = �������1.�������2. ...          ==============}
{==============================================================================}
function TDECOD.DecoderBlock(var DecStr : String): Boolean;
var S, S0: String;
begin
    {�������������}
    Result := true;
    S0     := DecStr;
    DecStr := '';

    {���������� ������������� ��� �������� �����}
    S := CutClass(S0);
    While S <> '' do begin
       {���������� ��������� �������}
       Result := DecoderOperand(DecStr, S);

       {���� ������, �� ������� ����� ������������ ������}
       If not Result then Break;

       {��������� �������}
       S := CutClass(S0);
    end;
end;



{==============================================================================}
{=============         � � � � � � �     � � � � � � � �         ==============}
{==============================================================================}
{=============                   Kod = �������                   ==============}
{==============================================================================}
function TDECOD.DecoderOperand(var DecStr: String; const Kod: String): Boolean;
begin
    {�������������}
    Result:=true;
    If Kod='' then begin Result:=false; Exit; end;

    {��������� �������������� ��������}
    If DopDecoderVar(DecStr,  Kod) then Exit;
    If DopDecoderTab(DecStr,  Kod) then Exit;
    If DopDecoderBase(DecStr, Kod) then Exit;

    {������: �� ���� ������� �� ��������}
    Result:=false;
    DecStr:=Kod;
end;


end.

