unit FunArt;

interface

uses System.SysUtils, System.Classes, System.Math, System.DateUtils,
     IdGlobal,
     Data.DB, Data.Win.ADODB,
     FunType;


{******************************************************************************}
{***  ������:  FunArt  ********************************************************}
{******************************************************************************}
{���� ��}
procedure InfoUK(const SNorms: String);
{���� ������������}
procedure InfoArt;


{******************************************************************************}
{***  ������:  FunArt_Text  ***************************************************}
{******************************************************************************}
{��������������� (�����������) ������ ������}
function ArticlesGroup_TT(const Str: String): String;
{��������� ������ �� ������������}
function ArticlesSeparat_TT(const Str: String): TStringList;
{��������� ������ �� ������������}
function ArticlesSeparat_TA(const Str: String; const IsFull: Boolean): TStringList;
{������� ������ ������ ��� Access: Norms}
function ArticlesConvert_AT(const Str: String): String;
{��������� ������������ � ������}
function SeparatMStr(const MStr: String; const PLStr: PStringList; const Separator: String): Boolean;
{����������� ���� �� Access � Txt}
function ArticlesConvertBlock_AT(const Str: String): String;
{��������� ������������ ��������� ������}
function VerifyArticles(const Str: String): Boolean;
{�������� �� ������ ������ ������ ����}
function TokArticl(var Art: String): String;
{����� S1 ��� S2 � ����������� �� ����� ������ � SArticl}
function SelTxtFromArticl(const SArticl, S1, S2: String): String;


{******************************************************************************}
{***  ������:  FunArt_BD  *****************************************************}
{******************************************************************************}
{������ �� ������� ���� ��}
function SetUKQuery(const P: PADOQuery; const SNorms: String;
                    const DatStart, DatEnd: TDate): Boolean;

{��������� ������������� ���� � ������}
function GetUKCaption(const PBD: PADOConnection; const SNorms: String;
                      const DatStart, DatEnd: TDate): String;
{������� ������������� ���� � ������}
function GetUKSanction(const PBD: PADOConnection; const SNorms: String;
                       const DatStart, DatEnd : TDate): TStringList;


{�������� ���������}
function UKCutCaption(const SNorm: String): String;
{�������� �����}
function UKCutNorm(const SNorm: String): String;
{�������� �������}
function UKCutSanction(const SNorm: String): String;




const LARTICLUK_SEPARATOR = ', ';  // ����������� ��� ������ ��

{$INCLUDE FunArt_Const}

implementation

uses FunConst, FunText, FunBD, FunList,
     MUK, MCOM;

{$INCLUDE FunArt_Text}
{$INCLUDE FunArt_BD}


{==============================================================================}
{================================   ���� ��    ================================}
{==============================================================================}
{===========  SNorms  = '��.2,8 �.2 ��.139, �.2 ��.207, ... '       ===========}
{==============================================================================}
procedure InfoUK(const SNorms: String);
var F: TFUK;
begin
    F := TFUK.Create(nil);
    try     F.Execute(SNorms);
    finally F.Free;
    end;
end;


{==============================================================================}
{===========================   ���� ������������    ===========================}
{==============================================================================}
procedure InfoArt;
var F: TFCOM;
begin
    F := TFCOM.Create(nil);
    try     F.ShowModal;
    finally F.Free;
    end;
end;

end.

