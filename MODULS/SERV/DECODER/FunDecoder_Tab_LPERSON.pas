{******************************************************************************}
{***************           ноепюжхх я рюакхжюлх сд           ******************}
{***************               чпхдхвеяйхе кхжю              ******************}
{******************************************************************************}


{==============================================================================}
{===========  тсмйжхъ дейндепю: онкмне мюхлемнбюмхе нпцюмхгюжхх  ==============}
{==============================================================================}
function TDECOD.NameLP(const S: String): String;
begin
    Result:='';
    If (S='х') or (S='')
             then Result:=PUD^.FieldByName(LPERSON_NAME).AsString    else
    If S='п' then Result:=PUD^.FieldByName(LPERSON_NAME_RP).AsString else
    If S='д' then Result:=PUD^.FieldByName(LPERSON_NAME_DP).AsString else
    If S='б' then Result:=PUD^.FieldByName(LPERSON_NAME_VP).AsString else
    If S='р' then Result:=PUD^.FieldByName(LPERSON_NAME_TP).AsString else
    If S='о' then Result:=PUD^.FieldByName(LPERSON_NAME_PP).AsString;

    If Result='' then Result:=PUD^.FieldByName(LPERSON_NAME).AsString;
    If Result='' then Result:='_________________________________________';
end;


{==============================================================================}
{=========  тсмйжхъ дейндепю: янйпюыеммне мюхлемнбюмхе нпцюмхгюжхх  ===========}
{==============================================================================}
function TDECOD.NameShortLP(const S: String): String;
var SVal: String;
begin
    {хМХЖХЮКХГЮЖХЪ}
    Result := '';
    SVal   := PUD^.FieldByName(LPERSON_NAME_SHORT).AsString;
    If (S='х') or (S='') then Result:=SVal else Result:=PadegAUTO(S, SVal);
    If Result='' then Result:=SVal;
    If Result='' then Result:='_____________________________';
end;


{==============================================================================}
{==============  тсмйжхъ: тюлхкхъ, хлъ, нрвеярбн псйнбндхрекъ  ================}
{==============================================================================}
function TDECOD.FFIOSherifLP(const S: String): String;
var SVal: String;
begin
    {хМХЖХЮКХГЮЖХЪ}
    Result := '';
    SVal   := PUD^.FieldByName(LPERSON_BOSS).AsString;
    If (S='х') or (S='') then Result:=SVal else Result:=PadegAUTO(S, SVal);
    If Result='' then Result:=SVal;
    If Result='' then Result:='_________________________________________';
end;
