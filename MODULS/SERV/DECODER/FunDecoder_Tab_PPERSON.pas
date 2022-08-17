{******************************************************************************}
{***************           ноепюжхх я рюакхжюлх сд           ******************}
{***************               тхгхвеяйхе кхжю               ******************}
{******************************************************************************}


{==============================================================================}
{=================  тсмйжхъ дейндепю: тюлхкхъ, хлъ, нрвеярбн  =================}
{==============================================================================}
function TDECOD.FFIOPP(const S: String): String;
begin
    Result:='';
    If(S='х') or (S='')
             then Result:=PUD^.FieldByName(PPERSON_FIO).AsString    else
    If S='п' then Result:=PUD^.FieldByName(PPERSON_FIO_RP).AsString else
    If S='д' then Result:=PUD^.FieldByName(PPERSON_FIO_DP).AsString else
    If S='б' then Result:=PUD^.FieldByName(PPERSON_FIO_VP).AsString else
    If S='р' then Result:=PUD^.FieldByName(PPERSON_FIO_TP).AsString else
    If S='о' then Result:=PUD^.FieldByName(PPERSON_FIO_PP).AsString else
    If S='0' then begin Result:=PUD^.FieldByName(PPERSON_FIO_OLD).AsString; Exit; end;

    If Result='' then Result:=PUD^.FieldByName(PPERSON_FIO).AsString;
    If Result='' then Result:='_________________________________________';
end;


{==============================================================================}
{========================  тсмйжхъ дейндепю: юдпея  ===========================}
{==============================================================================}
function TDECOD.FAdressPP(const S: String): String;
var S0: String;
begin
    Result:='';

    {юдпея леярю фхрекэярбю}
    If (S='лф') or (S='') then begin
       S0:=Trim(PUD^.FieldByName(PPERSON_LIV_PLACE).AsString);
       If S0<>'' then begin Result:=S0; Exit; end;
    end;

    {юдпея леярю пецхярпюжхх}
    If S='пец' then begin
       S0:=Trim(PUD^.FieldByName(PPERSON_REG_PLACE).AsString);
       If S0<>'' then Result:=S0;
    end;

    If Result='' then Result:='______________________________________';
end;


{==============================================================================}
{=======================  тсмйжхъ дейндепю: пнфдемхе  =========================}
{==============================================================================}
function TDECOD.FRogdeniePP(const S: String): String;
var S0: String;
begin
    Result:='';

    If (S='леярн') or (S='') then begin
       S0:=PUD^.FieldByName(PPERSON_BORN_PLACE).AsString;
       If S0 <> '' then Result:=S0 else Result:='_________________________________________';
       Exit;
    end;

    If S='дюрю' then begin
       S0 := DateToStr(PUD^.FieldByName(PPERSON_BORN_DATE).AsDateTime);
       If S0 <> '' then Result:=S0 else Result:='__.__.____';
    end;
end;


{==============================================================================}
{=====================  тсмйжхъ дейндепю: днйслемр  ===========================}
{==============================================================================}
function TDECOD.FDocumentPP(const S: String): String;
var S0,S1: String;
begin
    {хМХЖЮКХГЮЖХЪ}
    Result:='';

    If (S='нй') or (S='') then begin
       {----- рхо днйслемрю ---------------------------------------------------}
       Result:=PUD^.FieldByName(PPERSON_DOC_TYPE).AsString;
       If Result<>'' then Result:=Result+':';
       {----- мнлеп днйслемрю -------------------------------------------------}
       S0:=PUD^.FieldByName(PPERSON_DOC_NOMER).AsString;
       If S0<>'' then begin
          If Result<>'' then Result:=Result+' ';
          Result:=Result+S0;
       end;
       {----- йел бшдюм + дюрю бшдювх -----------------------------------------}
       S0:=PadegAUTO('р', PUD^.FieldByName(PPERSON_DOC_PLACE).AsString);
       S1:=SDateToStr(DateToStr(PUD^.FieldByName(PPERSON_DOC_DATE).AsDateTime),'');
       If (S0<>'') or (S1<>'') then begin
          If Result<>'' then Result:=Result+' ';
          Result:=Result+'БШД.';
          If S0<>'' then Result:=Result+' '+S0;
          If S1<>'' then Result:=Result+' '+S1+' Ц.';
       end;
       {----- кхвмши мнлеп ----------------------------------------------------}
       S0:=PUD^.FieldByName(PPERSON_PERSNOMER).AsString;
       If S0<>'' then begin
          If Result<>'' then Result:=Result+', ';
          Result:=Result+'КХВМШИ МНЛЕП: '+S0;
       end;
    end;

    If S='ьюакнм' then begin
       {----- рхо днйслемрю ---------------------------------------------------}
       S0:=PUD^.FieldByName(PPERSON_DOC_TYPE).AsString;
       If S0='' then S0:= '__________';
       Result:=S0+':';
       {----- мнлеп днйслемрю -------------------------------------------------}
       S0:=PUD^.FieldByName(PPERSON_DOC_NOMER).AsString;
       If S0='' then S0:='________';
       Result:=Result+S0;
       {----- йел бшдюм + дюрю бшдювх -----------------------------------------}
       S0:=PadegAUTO('р', PUD^.FieldByName(PPERSON_DOC_PLACE).AsString);
       S1:=SDateToStr(DateToStr(PUD^.FieldByName(PPERSON_DOC_DATE).AsDateTime),'');
       If S0='' then S0:='___________________';
       If S1='' then S1:='''___'' ___________ _____';
       Result:=Result+' БШД. '+S0+' '+S1+' Ц.';
       {----- кхвмши мнлеп ----------------------------------------------------}
       S0:=PUD^.FieldByName(PPERSON_PERSNOMER).AsString;
       If S0='' then S0:='______________';
       Result:=Result+', КХВМШИ МНЛЕП: '+S0;
    end;
end;


{==============================================================================}
{=====================    тсмйжхъ дейндепю: бнгпюяр     =======================}
{==============================================================================}
{=====================  S = 14, 16, [18], 70 Х Р.Д.     =======================}
{=====================  бнгбпюр = TRUE хкх FALSE        =======================}
{==============================================================================}
function TDECOD.FVozrastPP(const S: String): String;
var Year, Mounth, Day, Hour: Integer;
    S0 : String;
begin
    {хМХЖЮКХГЮЖХЪ}
    Result := 'FALSE';
    If S='' then S0:='18' else S0:=S;
    If Not IsIntegerStr(S0) then Exit;
    DateTimeDiff0(PUD^.FieldByName(PPERSON_BORN_DATE).AsDateTime, Now, Hour, Day, Mounth, Year);
    If Year<0 then Exit;

    Result:=AnsiUpperCase(BoolToStrMy(Year>=StrToInt(S0)));
end;

