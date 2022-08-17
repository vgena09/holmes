{==============================================================================}
{=============       � � � � � � �    � � � � � �   L O O P      ==============}
{==============================================================================}
(*============            DecStr = LOOP ... {...} ...            =============*)
{==============================================================================}
function TDECOD.DecoderPackLoop(const DecStr: String): String;
var PVAR0           : PADOTable;
    STable, SFilter : String;
    S1, S2, S3, S4  : String;
    IRec, ICount    : Integer;

    {*** ������� ���������� F_VAR_NAME_LOOP: $VAR *****************************}
    procedure DeleteTempVar;
    begin
        SetDBFilter(PVAR, '['+F_VAR_NAME+']='+QuotedStr(F_VAR_NAME_LOOP));
        PVAR^.First;
        While not PVAR^.Eof do PVAR^.Delete;
    end;

    {*** ������� ���������� F_VAR_NAME_LOOP: $VAR *****************************}
    procedure CreateTempVar;
    begin
        DeleteTempVar;
        FreeTable(PVAR);
        PVAR^.Insert;
        PVAR^.FieldByName(F_VAR_DOC ).AsString := ID_DOC;
        PVAR^.FieldByName(F_VAR_NAME).AsString := F_VAR_NAME_LOOP;
        PVAR^.FieldByName(F_VAR_TYPE).AsString := F_VAR_TYPE_UD;
        PVAR^.FieldByName(F_VAR_HINT).AsString := 'SYS: �������� Loop';
        PVAR^.UpdateRecord;
        PVAR^.Post;
    end;

    {*** ������������� ���������� F_VAR_NAME_LOOP: $VAR ***********************}
    procedure SetTempVar;
    begin
        SetDBFilter(PVAR, '['+F_VAR_NAME+']='+QuotedStr(F_VAR_NAME_LOOP));
        With PVAR^ do begin
           If RecordCount=1 then begin
              Edit;
              FieldByName(F_VAR_VAL_STR).AsString:=PUD^.TableName+'.'+PUD^.FieldByName(F_COUNTER).AsString;
              UpdateRecord;
              Post;
           end;
        end;
    end;

    {*** ��������� ������ �� �������� *****************************************}
    function SeparatOperand(const Str: String; var Str1, Str2, Str3, Str4: String): Boolean;
    var PsStr : TStringList;
        S     : String;
        I     : Integer;
    begin
        {�������������}
        Result := false;
        If AnsiUpperCase(Copy(Str, 1, Length('LOOP '))) <> 'LOOP ' then Exit;
        Str1   := Str;
        Str2   := '';
        Str3   := '';
        Str4   := '';
        Result := true;
        PsStr  := TStringList.Create;
        try
           {�������� LOOP}
           Delete(Str1, 1, Length('LOOP '));

           {�������� � ������ Str1 ����� ������-�����������: |%N|%}
           Str1 := ReplPsevdoModul(Str1, PsStr, CH_KAV, CH_KAV);
           Str1 := ReplPsevdoModul(Str1, PsStr, '{', '}');
           Str1 := ReplPsevdoModul(Str1, PsStr, '(', ')');

           {�������� ����������� � S}
           I:=FindStr(' UNION ', Str1);
           If I<=0 then Exit;
           S    := Copy(Str1, I+Length(' UNION '), Length(Str1));
           Str1 := Copy(Str1, 1, I-1);

           {������ �����������}
           I:=FindStr('/', S);
           If I>0 then begin
              Str2 := Copy(S, 1,   I-1);
              S    := Copy(S, I+1, Length(S));
           end else begin
              Str2 := S;
              S    := '';
           end;

           {������������� � ��������� �����������}
           I:=FindStr('/', S);
           If I>0 then begin
              Str3 := Copy(S, 1,   I-1);
              Str4 := Copy(S, I+1, Length(S));
           end else begin
              Str3 := S;
           end;

        finally
           {���������� �������� ������}
           For I:=PsStr.Count-1 downto 0 do begin
              Str1 := ReplStr(Str1, PsStr.Names[I], PsStr.Values[PsStr.Names[I]]);
              Str2 := ReplStr(Str2, PsStr.Names[I], PsStr.Values[PsStr.Names[I]]);
              Str3 := ReplStr(Str3, PsStr.Names[I], PsStr.Values[PsStr.Names[I]]);
              Str4 := ReplStr(Str4, PsStr.Names[I], PsStr.Values[PsStr.Names[I]]);
           end;

           {���� ������������� ����������� �����������}
           If Str3='' then Str3 := Str2;

           {����������� ������}
           PsStr.Free;
        end;
    end;

    {*** �������� ������� *****************************************************}
begin
    {�������������}
    Result := '';
    If (PUD = nil) or (PVAR = nil) then Exit;

    {�������� �������� ������� LOOP}
    If not SeparatOperand(DecStr, S1, S2, S3, S4) then begin Err:=true; Exit; end;

    try
       {������� ���������� AVAR_NAME_LOOP: $VAR}
       CreateTempVar;

       {�������������}
       STable  := PUD^.TableName;
       SFilter := PUD^.Filter;
       PVAR0   := PVAR;

       {���������� ����� ���������� ��� ������ ������ PUD^}
       ICount := PUD^.RecordCount;
       For IRec := 1 to ICount do begin
          {������������� PUD}
          With PUD^ do begin
             Close;
             TableName := STable;
             Filter    := SFilter;
             Filtered  := true;
             Open;
             RecNo     := IRec;
          end;

          {������������� ���������� AVAR_NAME_LOOP: $VAR}
          SetTempVar;

          {���������� �����}
          Result := Result + Decoder(S1);     // ��������� PUD^ ����� ���� ��������
          If IRec < (ICount-1) then Result := Result + Decoder(S2);
          If IRec = (ICount-1) then Result := Result + Decoder(S3);
          If IRec = ICount     then Result := Result + Decoder(S4);

          PVAR := PVAR0;

          {���� ������, �� ��������� ���������}
          If Err then Break;
       end;
    finally
       {������� ���������� AVAR_NAME_LOOP: $VAR}
       DeleteTempVar;
    end;
end;




