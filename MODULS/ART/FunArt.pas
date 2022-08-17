unit FunArt;

interface

uses System.SysUtils, System.Classes, System.Math, System.DateUtils,
     IdGlobal,
     Data.DB, Data.Win.ADODB,
     FunType;


{******************************************************************************}
{***  Модуль:  FunArt  ********************************************************}
{******************************************************************************}
{ОКНО УК}
procedure InfoUK(const SNorms: String);
{ОКНО КОММЕНТАРИЕВ}
procedure InfoArt;


{******************************************************************************}
{***  Модуль:  FunArt_Text  ***************************************************}
{******************************************************************************}
{Корректирование (группировка) списка статей}
function ArticlesGroup_TT(const Str: String): String;
{РАЗБИВАЕТ СТАТЬИ НА СОСТАВЛЯЮЩИЕ}
function ArticlesSeparat_TT(const Str: String): TStringList;
{РАЗБИВАЕТ СТАТЬИ НА СОСТАВЛЯЮЩИЕ}
function ArticlesSeparat_TA(const Str: String; const IsFull: Boolean): TStringList;
{Перевод списка статей для Access: Norms}
function ArticlesConvert_AT(const Str: String): String;
{Разделяет мультистроку в массив}
function SeparatMStr(const MStr: String; const PLStr: PStringList; const Separator: String): Boolean;
{Преобразует блок из Access в Txt}
function ArticlesConvertBlock_AT(const Str: String): String;
{ПРОВЕРЯЕТ ПРАВИЛЬНОСТЬ НАПИСАНИЯ СТАТЕЙ}
function VerifyArticles(const Str: String): Boolean;
{ВЫРЕЗАЕТ ИЗ СТРОКИ СТАТЕЙ ПЕРВЫЙ БЛОК}
function TokArticl(var Art: String): String;
{Выбор S1 или S2 в зависимости от числа статей в SArticl}
function SelTxtFromArticl(const SArticl, S1, S2: String): String;


{******************************************************************************}
{***  Модуль:  FunArt_BD  *****************************************************}
{******************************************************************************}
{ЗАПРОС СО СПИСКОМ НОРМ УК}
function SetUKQuery(const P: PADOQuery; const SNorms: String;
                    const DatStart, DatEnd: TDate): Boolean;

{ЗАГОЛОВКИ ПЕРЕЧИСЛЕННЫХ НОРМ В СТРОКУ}
function GetUKCaption(const PBD: PADOConnection; const SNorms: String;
                      const DatStart, DatEnd: TDate): String;
{САНКЦИИ ПЕРЕЧИСЛЕННЫХ НОРМ В СПИСОК}
function GetUKSanction(const PBD: PADOConnection; const SNorms: String;
                       const DatStart, DatEnd : TDate): TStringList;


{ВЫРЕЗАЕТ ЗАГОЛОВОК}
function UKCutCaption(const SNorm: String): String;
{ВЫРЕЗАЕТ НОРМУ}
function UKCutNorm(const SNorm: String): String;
{ВЫРЕЗАЕТ САНКЦИЮ}
function UKCutSanction(const SNorm: String): String;




const LARTICLUK_SEPARATOR = ', ';  // Разделитель для статей УК

{$INCLUDE FunArt_Const}

implementation

uses FunConst, FunText, FunBD, FunList,
     MUK, MCOM;

{$INCLUDE FunArt_Text}
{$INCLUDE FunArt_BD}


{==============================================================================}
{================================   ОКНО УК    ================================}
{==============================================================================}
{===========  SNorms  = 'пп.2,8 ч.2 ст.139, ч.2 ст.207, ... '       ===========}
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
{===========================   ОКНО КОММЕНТАРИЕВ    ===========================}
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

