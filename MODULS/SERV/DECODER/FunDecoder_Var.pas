{==============================================================================}
{=============         ��������������  ������  ��������          ==============}
{==============================================================================}
{=============                   Kod = �������                   ==============}
{==============================================================================}
function TDECOD.DopDecoderVar(var DecStr: String; const Kod: String): Boolean;
var L1, L2, L3    : TStringList;
    VType, Filter : String;
    Cmd, Prm0     : String;
    Prm           : TArrayStr;
    S             : String;
    I, I0, I1     : Integer;
    D             : TDateTime;
begin
    {�������������}
    Result := false;

    {��������� ��� [Kod] �� ������� [Cmd] � ��������� [Prm]}
    If Kod = '' then Exit;
    SeparatKod(Kod, Cmd, Prm);
    If Length(Prm) > 0 then Prm0 := AnsiUpperCase(Prm[Low(Prm)]) else Prm0:='';
    try

       {����������� �������}
//     If Cmd ='������� ����������'  then begin DecStr:=FVarAdd(PVAR, Prm);         Result:=true; Exit; end;
       If Cmd ='�������� ����������' then begin DecStr:=FVarChange(Prm);            Result:=true; Exit; end;
//     If Cmd ='������� ����������'  then begin DecStr:=FVarDel(PVAR, Prm);         Result:=true; Exit; end;
//     If Cmd ='��������� ��������'  then begin DecStr:=FSavVal(DecStr, PVAR, Prm); Result:=true; Exit; end;
//     If Cmd ='��������� �������'   then begin DecStr:=FSavRec(PVAR, PUD, Prm);    Result:=true; Exit; end;
       If Cmd ='�������� ����������' then begin Result:=FDocAddHint(Prm[Low(Prm)]); DecStr:='';   Exit; end;
       If Cmd ='�������� �����'      then begin Result:=FDocControlTerm(Prm);       DecStr:='';   Exit; end;
       If Cmd ='�������� ����'       then begin Result:=FDocControlDate(Prm);       DecStr:='';   Exit; end;
       If Cmd ='��������� ���������' then begin Result:=FDocCaption(Prm);           DecStr:='';   Exit; end;

       If Cmd ='�������� ����������' then begin DecStr:=FVarVal(Prm);               Result:=true; Exit; end;
       If Cmd ='���������� �����'    then begin DecStr:=FVarEmpty(Prm);             Result:=true; Exit; end;
//    If Cmd ='������� ����������'  then begin DecStr:=FVarExsists (PVAR, @T_VAR, Prm); Result:=true; Exit; end;

       {������ ���������� ���������� �������}
       Prm:=UpperArrayStr(Prm);
       //If Length(Prm) > 0 then Prm0:=Prm[Low(Prm)] else Prm0:='';

       {���� ���������� �� �� �����: ������� TVAR, ����� TVAR_COMMON}
       PVAR := VarFind(Cmd);
       If PVAR = nil then Exit;

       // PVAR^.First;


       {������� ������ ��� �������� �������� ����������}
       L1 := TStringList.Create;
       L2 := TStringList.Create;
       L3 := TStringList.Create;
       try
          VType   := AnsiUpperCase(Trim(PVAR^.FieldByName(F_VAR_TYPE).AsString)); // ��� ����������
          L1.Text := PVAR^.FieldByName(F_VAR_VAL_STR).AsString;                   // �������� ����������

          {********************  ��� UD ����������   **************************}
          If CmpStrList(VType, [F_VAR_TYPE_UD]) >= 0 then begin
             DecStr := '';
             If L1.Count > 0 then begin
                {���������� �������}
                If Length(Prm) > 0 then S := Prm[0]
                                   else S := CutSlovo(L1[0], 1, '.');
                If not SetDecoderTable(S) then Exit;

                {���������� �������� � L1}
                LKeySel(@L1, S);                              // L1.Count = 0 �� ������
                If Length(Prm) > 1 then begin
                   If not IsIntegerStr(Prm[1]) then Exit;
                   I := StrToInt(Prm[1]);
                   If (I < 0) or (I > L1.Count) then Exit;
                   If I <> 0 then L1.Text := L1[I - 1];       // I = 0 ��� ��������
                end;

                {��������� ������}
                Filter := '';
                For I0 := 0 to L1.Count-1 do
                   Filter:=Filter+' OR (['+F_COUNTER+']='+Trim(CutSlovo(L1[I0], 2, '.'))+')';
                Delete(Filter, 1, 4);
                SetDBFilter(PUD, Filter);
                PUD^.First;

             {L1.Count = 0 �� ������}
             end else begin
                PUD := nil;
             end;

             Result:=true;
             Exit;
          end;

          {*****************  ��� DATE ����������  ****************************}
          If CmpStrList(VType,[F_VAR_TYPE_DATE])>=0 then begin
             If (L1.Count>0) then DecStr:=L1.Strings[0];
             {���������}
             try
                If Length(Prm)>=1 then S:=Prm[0] else S:='0'; If IsIntegerStr(S) then I  := StrToInt(S) else I  := 0; // ������
                If Length(Prm)>=2 then S:=Prm[1] else S:='0'; If IsIntegerStr(S) then I0 := StrToInt(S) else I0 := 0; // ���
                If Length(Prm)>=3 then S:=Prm[2] else S:='0'; If IsIntegerStr(S) then I1 := StrToInt(S) else I1 := 0; // ����
                If (I <> 0) or (I0 <> 0) or (I1 <> 0) then begin
                   D := StrToDateTime(DecStr);
                   D := DateTimeCorrect(D, 0, I, I0, I1, 0);
                   DecStr := DateTimeToStr(D);
                end;
             except end;
             Result:=true;
             Exit;
          end;


          {*****************  ��� EDIT, RIGHT ����������  *********************}
          If CmpStrList(VType,[F_VAR_TYPE_EDIT])>=0 then begin
             If (L1.Count>0) then DecStr:=L1.Strings[0];
             Result:=true;
             Exit;
          end;


          {**********************  ��� MEMO ����������  ***********************}
          If CmpStrList(VType,[F_VAR_TYPE_MEMO, F_VAR_TYPE_SELECT])>=0 then begin
             DecStr:=CutEndStr(L1.Text);  // ������� 0Dh+0Ah, �.�. � Word �������� ������������ ���������
             Result:=true;
             Exit;
          end;

          {*******************  ��� EXPERT ����������   ***********************}
          If CmpStrList(VType,[F_VAR_TYPE_EXPERT])>=0 then begin
             DecStr:='';
             If Length(Prm)>=1 then S:=Prm[0] else S:='����������';

             {���� �������� - ����������}
             If CmpStr(S, '����������') then begin
                {�������� ������ �������� ���������}
                LSectionCopy(@L1, @L2, F_VAR_STR_EXPERT_EXP);
                {���� ���������� �� ������}
                If L2.Count=0 then DecStr:='___________________ ����������';
                {���� ������ 1 ����������}
                If L2.Count=1 then DecStr:=L2[0];
                {���� ������������ ����������}
                If L2.Count>1 then begin
                   For I:=0 to L2.Count-1 do DecStr:=DecStr+L2[I]+', ';
                   Delete(DecStr, Length(DecStr)-1, 2);
                   DecStr:='����������� ���������� ('+DecStr+')';
                end;
                Result:=true;
             end;
             {���� �������� - �������}
             If CmpStr(S, '�������') then begin
                {�������� ������ ��������}
                LSectionCopy(@L1, @L2, F_VAR_STR_EXPERT_QST);
                DecStr:=CutEndStr(L2.Text); // ������� 0Dh+0Ah, �.�. � Word � ����� ������ ������
                Result:=true;
             end;
             {���� �������� - �������}
             If CmpStr(S, '���������') then begin
                {������������� ���������}
                For I:=Low(LTAB_MAT) to High(LTAB_MAT) do begin
                   {�������� ������ ��������}
                   LSectionCopy(@L1, @L2, F_VAR_STR_EXPERT_MAT);
                   LElementCopyKey(@L2, @L3, LTAB_MAT[I]);
                   {���� ������� ������}
                   If L3.Count=0 then Continue;
                   {��� ���������� ���}
                   If CmpStr(LTAB_MAT[I], T_UD_PPERSON) then begin
                         //  {������ �������� ���������}
                         //  LSectionCopy(@L1, @L2, F_VAR_STR_EXPERT_EXP);
                         //  {�������������������, ������������ �����}
                         //  If (Pos('�����',  AnsiUpperCase(L2.Text)) > 1) or
                         // (Pos('����',   AnsiUpperCase(L2.Text)) > 1) then
                         For I0:=0 to L3.Count-1 do DecStr:=DecStr+'����������� ������������������ '+IDToTxt(@FFMAIN.BUD, T_UD_PPERSON+'.'+L3[I0], ['�'])+';'+CH_NEW;
                         Continue;
                   end;
                   {��� ��������}
                   If CmpStrList(LTAB_MAT[I], [T_UD_OBJECT])>=0 then begin
                      For I0:=0 to L3.Count-1 do DecStr:=DecStr+LowerStrPart(IDToTxt(@FFMAIN.BUD, T_UD_OBJECT+'.'+L3[I0], []), 1, 1)+';'+CH_NEW;
                   end;
                end;
                Delete(DecStr, Length(DecStr)-2, 3);
                Result:=true;
             end;
             Exit;
          end;


          {**********************  ��� REST ����������  ***********************}
          If CmpStrList(VType,[F_VAR_TYPE_REST])>=0 then begin
             If Length(Prm) <> 2 then Exit;
             {�������� 1}
             If Prm[0] = '' then Prm[0] := '1';
             If not IsIntegerStr(Prm[0]) then Exit;
             I := StrToInt(Prm[0]);
             {�������� 2}
             If Prm[1] = ''       then Prm[1] := '1';
             If Prm[1] = '���'    then Prm[1] := '1';
             If Prm[1] = '������' then Prm[1] := '2';
             If Prm[1] = '�����'  then Prm[1] := '3';
             If not IsIntegerStr(Prm[1]) then Exit;
             I0 := StrToint(Prm[1]);
             {��������}
             I := ((I - 1) * 3) + (I0 - 1);
             If I < L1.Count
             then DecStr := CutEndStr(L1[I])  // ������� 0Dh+0Ah, �.�. � Word �������� ������������ ���������
             else DecStr := '';
             Result:=true;
             Exit;
          end;

          {**********************  ��� OLE ����������  ************************}
          If CmpStrList(VType,[F_VAR_TYPE_OLE])>=0 then begin
             {��� ����������� OLE-����������}
             If IsStrInArray(Prm0, ['', '����']) then begin
                DecStr := '';
                IsOLE  := true;
                Result := FieldOleToClipboard(FFMAIN, PADODataSet(PVAR));
                Exit;
             end;

             {��� ����������� ���������-����������}
             If IsStrInArray(Prm0, ['�','�','�','�','�','�']) then begin
                L2.Text:=PVAR^.FieldByName(F_VAR_VAL_STR).AsString;
                If (Prm0='�') and (L2.Count>0) then begin
                   DecStr:=L2[0];
                   Result:=true;
                   Exit;
                end;
                If (Prm0='�') and (L2.Count>1) then begin
                   DecStr:=L2[1];
                   Result:=true;
                   Exit;
                end;
                If (Prm0='�') and (L2.Count>2) then begin
                   DecStr:=L2[2];
                   Result:=true;
                   Exit;
                end;
                If (Prm0='�') and (L2.Count>3) then begin
                   DecStr:=L2[3];
                   Result:=true;
                   Exit;
                end;
                If (Prm0='�') and (L2.Count>4) then begin
                   DecStr:=L2[4];
                   Result:=true;
                   Exit;
                end;
                If (Prm0='�') and (L2.Count>5) then begin
                   DecStr:=L2[5];
                   Result:=true;
                   Exit;
                end;
             end;
             Exit;
          end;
          {********************************************************************}
       finally
          L1.Free; L2.Free; L3.Free;
       end;
    finally
       SetLength(Prm, 0);
    end;
end;


{==============================================================================}
{===================   ����� ���������� �� �����   ============================}
{==============================================================================}
function TDECOD.VarFind(const VarName: String): PADOTable;
begin
    Result := nil;

    {���� � TVAR}
    If ID_DOC <> '' then begin
       SetDBFilter(@TVAR, '(['+F_VAR_DOC+']='+ID_DOC+' AND ['+F_VAR_NAME+']='+QuotedStr(VarName)+') OR (['+F_VAR_DOC+']=NULL AND ['+F_VAR_NAME+']='+QuotedStr(VarName)+')');
       //SetDBFilter(@TVAR, '['+F_VAR_DOC+']='+ID_DOC+' AND ['+F_VAR_NAME+']='+QuotedStr(VarName));
       If TVAR.RecordCount = 1 then begin Result := @TVAR; Exit; end;
    end;

    {���� � TVAR_COMMON}
    SetDBFilter(@TVAR_COMMON, '['+F_VAR_NAME+']='+QuotedStr(VarName));
    If TVAR_COMMON.RecordCount = 1 then Result := @TVAR_COMMON;
end;


{==============================================================================}
{==========             �������: STR-�������� ����������            ===========}
{==============================================================================}
{==========              1-� ��������  : ��� ����������             ===========}
{==============================================================================}
function TDECOD.FVarVal(const Prm: TArrayStr): String;
begin
    Result := '';
    If Length(Prm)=0 then Exit;
    PVAR := VarFind(Prm[Low(Prm)]);
    If PVAR = nil then Exit;
    Result := PVAR^.FieldByName(F_VAR_VAL_STR).AsString;
end;


{==============================================================================}
{==========        �������: ����� �� STR-�������� ����������        ===========}
{==============================================================================}
{==========              1-� ��������  : ��� ����������             ===========}
{==============================================================================}
function TDECOD.FVarEmpty(const Prm: TArrayStr): String;
begin
    Result := 'FALSE';
    If Length(Prm)=0 then Exit;
    PVAR := VarFind(Prm[Low(Prm)]);
    If PVAR = nil then Exit;
    If PVAR^.FieldByName(F_VAR_VAL_STR).AsString = '' then Result := 'TRUE';
end;

{==============================================================================}
{==========        �������: �������� ���������� ������� TVAR        ===========}
{==============================================================================}
{==========   1-� ��������  : ��� ����������                        ===========}
{==========  [2-� ��������] : �������� ����������� ���� ��          ===========}
{==========  [3-� ��������] : ����� �������� ����                   ===========}
(*=========  '|+' ������ �� '{', '|-' ������ �� '}'                 ==========*)
{==============================================================================}
function TDECOD.FVarChange(const Prm: TArrayStr): String;
var T : TADOTable;
    SNam, SFld, SVal : String;
begin
    {�������������}
    Result := '';
    If (Length(Prm) < 1) or (ID_DOC = '') then Exit;

    {��������� ����������}
    SNam  := Trim(Prm[Low(Prm)]); If SNam = '' then Exit;
    If Length(Prm) > 1 then SFld := Trim(Prm[Low(Prm)+1]) else SFld := ''; If SFld = '' then SFld := F_VAR_VAL_STR;
    If Length(Prm) > 2 then SVal := Trim(Prm[Low(Prm)+2]) else SVal := ''; If SVal = '' then SVal := '';
    SVal := ReplStr(SVal, '|+', '{');
    SVal := ReplStr(SVal, '|-', '}');

    T := LikeTable(@TVAR);
    try
       {��������� �������}
       SetDBFilter(@T, '(['+F_VAR_DOC+']='+ID_DOC+' AND ['+F_VAR_NAME+']='+QuotedStr(SNam)+') OR (['+F_VAR_DOC+']=NULL AND ['+F_VAR_NAME+']='+QuotedStr(SNam)+')');
       //SetDBFilter(@T, '['+F_VAR_DOC+']='+ID_DOC+' AND ['+F_VAR_NAME+']='+QuotedStr(SNam));
       If T.RecordCount < 1 then Exit;
       T.RecNo := 1;

       {�������� ��� �� ������ �� �����, �.�. ��� ����� ��������}
       SetDBFilter(@T, '['+F_COUNTER+']='+T.FieldByName(F_COUNTER).AsString);

       {������ ��������}
       With T do begin
          Edit;
          FieldByName(SFld).AsString := SVal;
          UpdateRecord;
          Post;
       end;
    finally
       DestrTable(@T);
       SetDBFilter(@TVAR, ''); // ������� ����� ���� ���������������� �� �����, � ��� ��������
       TVAR.Close; TVAR.Open;  // RefreshTable(@TVAR); ������ ������ ��� ������ ���������
    end;
end;



{==============================================================================}
{============        �������: �������� ���������� ���������        ============}
{==============================================================================}
function TDECOD.FDocAddHint(const SText: String): Boolean;
var S: String;
begin
    Result := false;
    If SText = '' then begin Result := true; Exit; end;
    try
       With TDOC do begin
          If RecordCount <> 1 then Exit;
          Edit;
          S := FieldByName(F_UD_DOC_HINT).AsString;
          If S <> '' then S := S + CH_NEW + CH_NEW;
          S := S + SText;
          FieldByName(F_UD_DOC_HINT).AsString := S;
          UpdateRecord;
          Post;
       end;
       RefreshTable(@TDOC);
       Result := true;
    finally
    end;
end;


{==============================================================================}
{=================    �������: �������� ����� ���������      ==================}
{==============================================================================}
{===== 1 �������� - ����-�����, ������������ �����s[ ��������������� ����  ====}
{===== 2-4 �������� - ���� � �������, ����, �����                          ====}
{==============================================================================}
function TDECOD.FDocControlTerm(const Prm: TArrayStr): Boolean;
var Hours, Days, Months: Integer;
    Dat  : TDatetime;
    SDat : String;

   function GetPrm(const I: Integer): Integer;
   begin
       Result := 0;
       If I >= Length(Prm)         then Exit;
       If not IsIntegerStr(Prm[I]) then Exit;
       Result := StrToInt(Prm[I]);
   end;

begin
    Result := false;
    If TDOC.Filter = '' then Exit;

    SDat := Prm[Low(Prm)];
    If ValidDateTime(SDat) then Dat := StrToDateTime(SDat)
                           else Dat := Now;
    Months := GetPrm(1);
    Days   := GetPrm(2);
    Hours  := GetPrm(3);

    {���: ���� ���� ����������� ������� � ��������, �� � 0 ����� ���������� ���}
    If (Hours = 0) and ((Months <> 0) or (Days <> 0)) then begin
       Dat := DateTimeCorrect(Dat, 0, 0, 1, 0, 0);
       Dat := Trunc(Dat);
    end;

    {���: ���� ���� ����������� ������, �� �� ��������� ����}
    If (Hours <> 0) and (Months = 0) and (Days = 0) then begin
       Dat := DateTimeCorrect(Dat, 0, 0, 0, 1, 0);
    end;

    try
       With TDOC do begin
          Edit;
          FieldByName(F_UD_DOC_CONTROL).AsDateTime := DateTimeCorrect(Dat, 0, Months, Days, Hours, 0);
          UpdateRecord;
          Post;
       end;
       RefreshTable(@FFMAIN.BUD.TDOC);
       Result := true;
    finally
    end;
end;


{==============================================================================}
{==================    �������: �������� ���� ���������      ==================}
{==============================================================================}
{===== 1 �������� - ����-�����, ������������ �����s[ ��������������� ����  ====}
{==============================================================================}
function TDECOD.FDocControlDate(const Prm: TArrayStr): Boolean;
var Dat  : TDatetime;
    SDat : String;
begin
    Result := false;
    If TDOC.Filter = '' then Exit;
    If Length(Prm) <> 1 then Exit;
    SDat := Prm[Low(Prm)];

    If ValidDateTime(SDat) then Dat := StrToDateTime(SDat)
                           else Exit;
    try
       With TDOC do begin
          Edit;
          FieldByName(F_UD_DOC_CONTROL).AsDateTime := Dat;
          UpdateRecord;
          Post;
       end;
       RefreshTable(@FFMAIN.BUD.TDOC);
       Result := true;
    finally
    end;
end;


{==============================================================================}
{====================    �������: ��������� ���������      ====================}
{==============================================================================}
function TDECOD.FDocCaption(const Prm: TArrayStr): Boolean;
var S: String;
begin
    Result := false;
    If TDOC.Filter = '' then Exit;
    If Length(Prm) <> 1 then Exit;
    try
       S := Decoder(Trim(Prm[Low(Prm)]));
       With TDOC do begin
          Edit;
          FieldByName(F_UD_DOC_CAPTION).AsString := CutLongStr(S, 145);
          UpdateRecord;
          Post;
       end;
       RefreshTable(@FFMAIN.BUD.TDOC);
       Result := true;
    finally
    end;
end;
