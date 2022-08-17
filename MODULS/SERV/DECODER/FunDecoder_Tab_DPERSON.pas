{******************************************************************************}
{***************           ноепюжхх я рюакхжюлх сд           ******************}
{***************             днонкмхрекэмше кхжю             ******************}
{******************************************************************************}


{==============================================================================}
{==================  тсмйжхъ дейндепю: тюлхкхъ, хлъ, нрвеярбн  ================}
{==============================================================================}
function TDECOD.FFIODP(const S: String): String;
begin
    Result:='';
    If (S='х')or(S='')
             then Result:=PUD^.FieldByName(DPERSON_FIO).AsString    else
    If S='п' then Result:=PUD^.FieldByName(DPERSON_FIO_RP).AsString else
    If S='д' then Result:=PUD^.FieldByName(DPERSON_FIO_DP).AsString else
    If S='б' then Result:=PUD^.FieldByName(DPERSON_FIO_VP).AsString else
    If S='р' then Result:=PUD^.FieldByName(DPERSON_FIO_TP).AsString else
    If S='о' then Result:=PUD^.FieldByName(DPERSON_FIO_PP).AsString;

    If Result='' then Result:=PUD^.FieldByName(DPERSON_FIO).AsString;
    If Result='' then Result:='_________________________________________';
end;


{==============================================================================}
{=====================  тсмйжхъ дейндепю: днйслемр  ===========================}
{==============================================================================}
function TDECOD.FDocumentDP(const S: String): String;
var S0,S1: String;
begin
    {хМХЖЮКХГЮЖХЪ}
    Result:='';

    If (S='нй') or (S='') then begin
       {----- рхо днйслемрю ---------------------------------------------------}
       Result:=PUD^.FieldByName(DPERSON_DOC_TYPE).AsString;
       If Result<>'' then Result:=Result+':';
       {----- мнлеп днйслемрю -------------------------------------------------}
       S0:=PUD^.FieldByName(DPERSON_DOC_NOMER).AsString;
       If S0<>'' then begin
          If Result<>'' then Result:=Result+' ';
          Result:=Result+S0;
       end;
       {----- йел бшдюм + дюрю бшдювх -----------------------------------------}
       S0:=PadegAUTO('р', PUD^.FieldByName(DPERSON_DOC_PLACE).AsString);
       S1:=SDateToStr(DateToStr(PUD^.FieldByName(DPERSON_DOC_DATE).AsDateTime),'');
       If (S0<>'') or (S1<>'') then begin
          If Result<>'' then Result:=Result+' ';
          Result:=Result+'БШД.';
          If S0<>'' then Result:=Result+' '+S0;
          If S1<>'' then Result:=Result+' '+S1+' Ц.';
       end;
    end;

    If S='ьюакнм' then begin
       {----- рхо днйслемрю ---------------------------------------------------}
       S0:=PUD^.FieldByName(DPERSON_DOC_TYPE).AsString;
       If S0='' then S0:= '__________';
       Result:=S0+':';
       {----- мнлеп днйслемрю -------------------------------------------------}
       S0:=PUD^.FieldByName(DPERSON_DOC_NOMER).AsString;
       If S0='' then S0:='________';
       Result:=Result+S0;
       {----- йел бшдюм + дюрю бшдювх -----------------------------------------}
       S0:=PadegAUTO('р', PUD^.FieldByName(DPERSON_DOC_PLACE).AsString);
       S1:=SDateToStr(DateToStr(PUD^.FieldByName(DPERSON_DOC_DATE).AsDateTime),'');
       If S0='' then S0:='___________________';
       If S1='' then S1:='''___'' ___________ _____';
       Result:=Result+' БШД. '+S0+' '+S1+' Ц.';
    end;
end;

