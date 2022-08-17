{******************************************************************************}
{********************************   EDIT   ************************************}
{******************************************************************************}

{==============================================================================}
{==========================   EDIT: ИНИЦИАЛИЗАЦИЯ   ===========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.IniEdit;
begin
    EMat.Text             := '';
    EMat.Enabled          := false;
    LMatInfo.Caption      := '0';
    BtnMat.Action         := A_Mat;
    BtnMat.ShowHint       := true;

    EInv.OnChange         := EInvChange;
    EInv.DropDownCount    := 20;
    BtnInv.OnClick        := BtnListClick;
    LInvInfo.Caption      := '';

    EExp.Style            := csDropDownList;
    EExp.DropDownCount    := 45;
    EExp.OnChange         := EExpChange;
    BtnExp.Action         := AExpInfo;
    BtnExp.ShowHint       := true;
    LExpInfo.Caption      := '0';

    {Устанавливаем списки CBox.Item}
    CBoxSetItem;
end;


{==============================================================================}
{=========================   EDIT: ДЕИНИЦИАЛИЗАЦИЯ   ==========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.FreeEdit;
begin
    //
end;


{==============================================================================}
{===========================   EMAT: ОБНОВЛЕНИЕ   =============================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.RefreshMAT;
var L : TStringList;
    S : String;
    I : Integer;
begin
    S := '';
    L := TStringList.Create;
    try
       L.Text := LNewMat.Text;
       LKeySel(@L, T_UD_PPERSON);
       LMatInfo.Caption := IntToStr(L.Count);
       For I:=0 to L.Count-1 do S := S + IDToTxt(@FFMAIN.BUD, L[I], []) + ', ';
    finally
       L.Free;
    end;
    Delete(S, Length(S)-1, 2);
    If S = '' then S := CBVAL_NULL;
    EMat.Text := CutLongStr(S, 150);
end;


{==============================================================================}
{====================   СОБЫТИЕ: ИЗМЕНЕНИЕ ИССЛЕДОВАНИЯ   =====================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.EInvChange(Sender: TObject);
var S, Sav : String;
    I      : Integer;
begin
    EExp.Items.BeginUpdate;
    try
       Sav := EExp.Text; EExp.Text := '';
       EExp.Items.Clear;
       If not SetSQLExp then Exit;

       With QExp do begin
          First;
          While not Eof do begin
             S := Trim(FieldByName(F_EXP_INV).AsString);
             If S <> '' then S := Trim(FieldByName(F_EXP_CAPTION).AsString)+S_SEPARAT+S
                        else S := Trim(FieldByName(F_EXP_CAPTION).AsString);
             EExp.Items.Add(S);
             Next;
          end;
          LExpInfo.Caption := IntToStr(RecordCount);
       end;

       {Значение по умолчанию}
       If EExp.Items.Count > 0 then begin
          I := EExp.Items.IndexOf(Sav);
          If I = -1 then I := 0;
          EExp.ItemIndex := I;
       end;
    finally
       EExp.Items.EndUpdate;
       EExpChange(Sender);
    end;
end;


{==============================================================================}
{=====================   СОБЫТИЕ: ИЗМЕНЕНИЕ ЭКСПЕРТИЗЫ   ======================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.EExpChange(Sender: TObject);
begin
    If not SetSQLQst then Exit;
    RefreshTree;
end;


{==============================================================================}
{======================   ACTION: СПИСОК МАТЕРИАЛОВ   =========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.A_MatExecute(Sender: TObject);
var F      : TFVAR_UD;
    L1, L2 : TStringList;
begin
    F  := TFVAR_UD.Create(Self);
    L1 := TStringList.Create;
    L2 := TStringList.Create;
    try
       L1.Text := LNewMat.Text;  LKeySel(@L1, T_UD_PPERSON);
       L2.Text := LNewMat.Text;  LKeyDel(@L2, T_UD_PPERSON);
       F.ExecuteCheck(@L1, LTAB_UD_PPERSON, PQVAR^.FieldByName(F_COUNTER).AsInteger);
       LNewMat.Text := L1.Text + L2.Text;
    finally L1.Free; L2.Free; F.Free;
    end;

    {Перерисовываем список материалов}
    RefreshMAT;

    {Обновляем список вопросов}
    EInvChange(Sender);
end;

{==============================================================================}
{=================  ACTION: ИНФОРМАЦИЯ О ВЫБРАННОЙ ЭКСПЕРТИЗЕ  ================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.AExpInfoExecute(Sender: TObject);
var T : TADOTable;
    S, S1, S2: String;
begin
    S2 := Trim(EExp.Text);
    S1 := TokStr(S2, S_SEPARAT);
    S  := '(['+F_EXP_CAPTION+']='+QuotedStr(S1)+')';
    If S2<>'' then S := S+ ' AND (['+F_EXP_INV+']='+QuotedStr(S2)+')';
    try     SetDBFilter(@QExp, S);
            If QExp.RecordCount <> 1 then Exit;
            S := QExp.FieldbyName(F_COUNTER).AsString;
    finally SetDBFilter(@QExp, '');
    end;

    T := LikeTable(@FFMAIN.BEXP.TEXP);
    try     SetDBFilter(@T, '['+F_COUNTER+']='+S);
            If T.RecordCount <> 1 then Exit;
            EditMemoDB(UpperStrPart(EExp.Text, 1, 1), @T, F_EXP_HINT, true);
            // UpdateTable(@T);
    finally If T.Active then T.Close; T.Free;
    end;
end;



{==============================================================================}
{=====================   КОРРЕКТИРОВКА СПИСКОВ CBOX    ========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.BtnListClick(Sender: TObject);
var CBox : TDBComboBox;
    SID  : String;
begin
    {Инициализация}
    CBox := TDBComboBox(Sender);

    {Поиск идентификатора списка}
    SID := '';
    If CBox.Name='BtnInv' then SID:=LIST_INVESTIGATE;
    If SID='' then Exit;

    RefreshListItem(@FFMAIN.BSET_LOCAL.TLIST, SID);
    CBoxSetItem;
end;


{==============================================================================}
{=======================   УСТАНОВКА СПИСКОВ CBOX    ==========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.CBoxSetItem;
begin
    GetListItemCBox(@EInv, @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(LIST_INVESTIGATE));
end;
