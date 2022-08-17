{==============================================================================}
{==============================   ACTION   ====================================}
{==============================================================================}


{==============================================================================}
{=========================   ACTION: ДОСТУПНОСТЬ   ============================}
{==============================================================================}
procedure TFVAR_EXPERT.EnablAction;
var IsEdit: Boolean;
begin
    IsEdit := false;
    If Tree.Selected <> nil then  IsEdit := Tree.Selected.Level > 0;
    A_Edit.Enabled   := IsEdit;
    A_Del.Enabled    := Tree.Selected <> nil;
    A_DelAll.Enabled := Tree.Items.Count > 0;
end;


{==============================================================================}
{============================   ACTION: HELPER   ==============================}
{==============================================================================}
procedure TFVAR_EXPERT.A_HelperExecute(Sender: TObject);
var F: TFVAR_EXPERT_HELPER;
begin
    WriteVar;
    F :=    TFVAR_EXPERT_HELPER.Create(Self);
    try     F.Execute(PQVAR, PTSAV);
    finally F.Free;
    end;
    ReadVar;
end;


{==============================================================================}
{=====================   ACTION: ДОБАВИТЬ ЭКСПЕРТИЗУ   ========================}
{==============================================================================}
procedure TFVAR_EXPERT.A_IncExpExecute(Sender: TObject);
begin
    IncElement(F_VAR_STR_EXPERT_EXP, 'Новая экспертиза');
end;


{==============================================================================}
{======================    ACTION: ДОБАВИТЬ ВОПРОС    =========================}
{==============================================================================}
procedure TFVAR_EXPERT.A_IncQstExecute(Sender: TObject);
begin
    IncElement(F_VAR_STR_EXPERT_QST, 'Новый вопрос');
end;



{==============================================================================}
{======================   ФУНКЦИЯ: ДОБАВИТЬ ЭЛЕМЕНТ   =========================}
{==============================================================================}
procedure TFVAR_EXPERT.IncElement(const Section, Element: String);
var N, NParent : TTreeNode;
    S : String;
begin
    S := EditMemo('Редактор элемента ['+Section+']', Element, false);
    S := ReplStr(S, CH_NEW, '');

    NParent := FindNodeLevel(@Tree, Section, 0);
    If NParent = nil then NParent := Tree.Items.AddChildObject(nil, Section, Pointer(0));
    N := Tree.Items.AddChildObject(NParent, S, Pointer(0));
    Tree.Selected := N;

    WriteVar;
    ReadVar;
end;


{==============================================================================}
{==============    ACTION: РЕДАКТИРОВАТЬ МАТЕРИАЛ - ФЛ    =====================}
{==============================================================================}
procedure TFVAR_EXPERT.A_IncMat_PPersonExecute(Sender: TObject);
begin
    EditMat(T_UD_PPERSON, LTAB_UD_PPERSON);
end;


{==============================================================================}
{============    ACTION: РЕДАКТИРОВАТЬ МАТЕРИАЛ - ОБЪЕКТ    ===================}
{==============================================================================}
procedure TFVAR_EXPERT.A_IncMat_ObjectExecute(Sender: TObject);
begin
    EditMat(T_UD_OBJECT, LTAB_UD_OBJECT);
end;


{==============================================================================}
{==================    ФУНКЦИЯ: РЕДАКТИРОВАТЬ МАТЕРИАЛ    =====================}
{==============================================================================}
procedure TFVAR_EXPERT.EditMat(const Element: String; const Ind: Integer);
var F      : TFVAR_UD;
    L1, L2 : TStringList;
begin
    WriteVar;
    F  := TFVAR_UD.Create(Self);
    L1 := TStringList.Create;
    L2 := TStringList.Create;
    try
       L1.Text := PQVAR^.FieldByName(F_VAR_VAL_STR).AsString;
       LSectionCopy(@L1, @L2, F_VAR_STR_EXPERT_MAT);

       LKeySel(@L2, Element);
       F.ExecuteCheck(@L2, Ind, PQVAR^.FieldByName(F_COUNTER).AsInteger);
       LKeyReplace(@L1, @L2, F_VAR_STR_EXPERT_MAT, Element);

       With PQVAR^ do begin
          Edit;
          PQVAR^.FieldByName(F_VAR_VAL_STR).AsString := L1.Text;
          UpdateRecord;
          Post;
       end;
       RefreshTable(@FFMAIN.BUD.TVAR);
    finally L1.Free; L2.Free; F.Free;
    end;
    ReadVar;
end;


{==============================================================================}
{=======================   ACTION: РЕДАКТИРОВАТЬ   ============================}
{==============================================================================}
procedure TFVAR_EXPERT.A_EditExecute(Sender: TObject);
begin
    If Tree.Selected <> nil then EditElement(Tree.Selected);
end;


{==============================================================================}
{===================   ФУНКЦИЯ: РЕДАКТИРОВАТЬ ЭЛЕМЕНТ   =======================}
{==============================================================================}
procedure TFVAR_EXPERT.EditElement(const N: TTreeNode);
var F : TForm;
    S : String;
    I : Integer;
    T : TADOTable;
    P : PADOTable;
begin
    If N = nil      then Exit;
    If N.Level <> 1 then Exit;

    I := Integer(N.Data);
    If I = 0 then begin
       S := EditMemo('Редактор элемента ['+N.Parent.Text+']', N.Text, false);
       N.Text := ReplStr(S, CH_NEW, '');
       WriteVar;

    {Section = F_VAR_STR_EXPERT_MAT}
    end else begin
       WriteVar;
       If I > 0 then S := T_UD_PPERSON else S := T_UD_OBJECT;
       P := NameToTabUD(@FFMAIN.BUD, S); If P = nil then Exit;
       T := LikeTable(P);                If T = nil then Exit;
       try
          If Not PosTabUD(@T, IntToStr(Abs(I))) then Exit;
          If S = T_UD_PPERSON then begin
             F := TFVAR_UD_EDIT_PPERSON.Create(Self);
             try     TFVAR_UD_EDIT_PPERSON(F).Execute(@T);
             finally F.Free; end;
          end;
          If S = T_UD_OBJECT then begin
             F := TFVAR_UD_EDIT_OBJECT.Create(Self);
             try     TFVAR_UD_EDIT_OBJECT(F).Execute(@T);
             finally F.Free; end;
          end;
       finally
          P^.Active := false;
          P^.Active := true;
          If T.Active then T.Close; T.Free;
       end;
       ReadVar;
    end;
end;


{==============================================================================}
{==========================   ACTION: УДАЛИТЬ   ===============================}
{==============================================================================}
procedure TFVAR_EXPERT.A_DelExecute(Sender: TObject);
begin
    If Tree.Selected = nil then Exit;
    If Tree.Selected.Level = 0 then
       If MessageDlg('Подтвердите удаление группы ['+Tree.Selected.Text+']', mtWarning, [mbOK, mbCancel], 0) <> mrOk then Exit;
    If Tree.Selected.Level = 1 then
       If MessageDlg('Подтвердите удаление элемента ['+Tree.Selected.Parent.Text+'].['+Tree.Selected.Text+']', mtWarning, [mbOK, mbCancel], 0) <> mrOk then Exit;

    Tree.Selected.Delete;
    WriteVar;
    ReadVar;
end;


{==============================================================================}
{=========================   ACTION: УДАЛИТЬ ВСЕ  =============================}
{==============================================================================}
procedure TFVAR_EXPERT.A_DelAllExecute(Sender: TObject);
begin
    If Tree.Items.Count=0 then Exit;
    If MessageDlg('Подтвердите удаление ВСЕХ элементов!', mtWarning, [mbOK, mbCancel], 0) <> mrOk then Exit;
    Tree.Items.Clear;
    WriteVar;
    ReadVar;
end;



