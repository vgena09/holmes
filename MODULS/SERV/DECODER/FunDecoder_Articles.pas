{******************************************************************************}
{***************  � � � � � � � �    � �    � � � � � � � �   *****************}
{******************************************************************************}


{==============================================================================}
{===========================   ������ �� ����   ===============================}
{==============================================================================}
{==============   Result    = '�.2 �.2 ��.139, �.1 ��.339-1'    ===============}
{==============================================================================}
function TDECOD.GetArticles: String;
var Q  : TADOQuery;
    S  : String;
begin
    {�������������}
    Result:='';

    {������� ������}
    S:='SELECT ['+PPERSON_ARTICLES+']'+CH_NEW+
       'FROM   ['+T_UD_PPERSON+']'+CH_NEW+
       'WHERE  ['+PPERSON_STATE+'] IN ('+QuotedStr(PPERSON_STATE_SUSPECT)+', '+
                                         QuotedStr(PPERSON_STATE_ACCUSED)+', '+
                                         QuotedStr(PPERSON_STATE_STUPID)+');';
    {������ �� ������� ������}
    Q:=TADOQuery.Create(nil);
    try
       Q.Connection := FFMAIN.BUD.BD;
       Q.SQL.Add(S);
       Q.Open;
       Q.First;
       While not Q.Eof do begin
          S := Trim(Q.FieldByName(PPERSON_ARTICLES).AsString);
          If S <> '' then Result := Result + LARTICLUK_SEPARATOR + S;
          Q.Next;
       end;
    finally
       If Q.Active then Q.Close; Q.Free;
    end;

    If Length(Result) > 0 then Delete(Result, 1, Length(LARTICLUK_SEPARATOR));
    Result:=ArticlesGroup_TT(Result);
end;


{==============================================================================}
{=================   ������������ ������� ������ ������ ��   ==================}
{==============================================================================}
{======  DecStr:    ��.2,5,12 �.2 ��.139, ��.2,7,9 �.2 ��.139            ======}
{======  Prm[0]:    00.00.0000, 00.00.0000 00:00 - ������ �������        ======}
{======  Prm[1]:    00.00.0000, 00.00.0000 00:00 - �����  �������        ======}
{======  Prm[2..]:  [����, �������� �������]        (���)                ======}
{======  �����:     TRUE, FALSE                                          ======}
{==============================================================================}
function TDECOD.FindFromSanctionArticles(const DecStr: String; const Prm: array of String): String;
var L                : TStringList;
    DatStart, DatEnd : TDate;
    IPrm, IList      : Integer;
begin
    {�������������}
    Result := 'FALSE';
    If (Trim(DecStr)='') or (Length(Prm)<3) then Exit;

    try
       If Prm[0]<>'' then DatStart := StrToDate(Prm[0]) else DatStart := Date;
       If Prm[1]<>'' then DatEnd   := StrToDate(Prm[1]) else DatEnd   := Date;
    except
       Exit;
    end;

    {�������� � ����������� ������ �������}
    L := GetUKSanction(@FFMAIN.BART.BD, DecStr, DatStart, DatEnd);
    try
       For IList := 0 to L.Count-1 do begin
          For IPrm := 2 to Length(Prm)-1 do begin
              If FindStr(Prm[IPrm], L[IList]) > 0 then begin
                 Result:='TRUE';
                 Break;
              end;
          end;
          If Result='TRUE' then Break;
       end;
    finally
       L.Free;
    end;
end;


