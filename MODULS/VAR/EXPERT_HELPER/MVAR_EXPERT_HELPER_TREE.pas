{******************************************************************************}
{********************************   TREE   ************************************}
{******************************************************************************}

{==============================================================================}
{==========================   TREE: ИНИЦИАЛИЗАЦИЯ   ===========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.IniTREE;
begin
    With Tree do begin
       Items.Clear;
       SetTreeChecked(@Tree);
       SetTreeNodeHeightAll(Tree, 18);
       SetTreeHint(Tree, false);
       HideSelection    := false;
       ReadOnly         := true;
       PopupMenu        := PMenu;
       ShowRoot         := false;
       ShowLines        := false;
       SortType         := stNone;
       DragMode         := dmAutomatic;
       RowSelect        := true;

       OnClick          := TreeClick;
       OnDblClick       := TreeDblClick;
       OnKeyDown        := TreeKeyDown;
       OnKeyUp          := TreeKeyUp;

       OnDragOver       := TreeDragOver;
       OnDragDrop       := TreeDragDrop;

       OnCustomDrawItem := TreeCustomDrawItem;
    end;
    RefreshTree;

    With LInfo do begin
       WordWrap         := false;
       Caption          := '';
       OnClick          := LInfoClick;
    end;
end;


{==============================================================================}
{=========================   TREE: ДЕИНИЦИАЛИЗАЦИЯ   ==========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.FreeTREE;
begin
    Linfo.Caption       := '';
end;


{==============================================================================}
{===========================   TREE: ОБНОВЛЕНИЕ   =============================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.RefreshTREE;
var FDECOD : TDECOD;
    Q      : TADOQuery;
    T      : TADOTable;
    N      : TTreeNode;
    S      : String;
begin
    {Инициализация}
    If Not QQst.Active then Exit;
    Tree.Items.BeginUpdate;
    Tree.Items.Clear;
    try
       {Создаем запись в клонированной таблице}
       Q := LikeQuery(PQVAR);
       SetDBFilter(@Q,'['+F_VAR_NAME+']='+QuotedStr(TEMP_VAR_NAME));
       With Q do begin
          First; While not EOF do Delete;
          Insert;
          FieldByName(F_VAR_DOC    ).AsString := PQVAR^.FieldByName(F_VAR_DOC).AsString;  // Обязательно
          FieldByName(F_VAR_NAME   ).AsString := TEMP_VAR_NAME;
          FieldByName(F_VAR_TYPE   ).AsString := F_VAR_TYPE_UD;
          FieldByName(F_VAR_VAL_STR).AsString := LNewMat.Text;
          UpdateRecord;
          Post;
          SetDBFilter(@Q,'');
       end;

       {Формируем список вопросов за исключением ранее выбранных}
       FDECOD := TDECOD.Create(PQVAR^.FieldByName(F_VAR_DOC).AsString);
       T      := TADOTable.Create(Self);
       T.Connection := FFMAIN.BEXP.BD;
       T.TableName  := T_EXP_QST;
       T.Open;
       try
          QQst.First;
          While not QQst.Eof do begin
             SetDBFilter(@T, '['+F_COUNTER+']='+QQst.FieldByName(F_COUNTER).AsString);
             S := FDECOD.Decoder(T.FieldByName(F_QST_CAPTION).AsString);
             If LOldQst.IndexOf(S) < 0 then begin
                N := Tree.Items.AddChildObject(nil, S, Pointer(QQst.FieldByName(F_COUNTER).AsInteger));
                N.ImageIndex := QQst.FieldByName(F_QST_CATEGORY).AsInteger;
             end;
             QQst.Next;
          end;
       finally
          T.Close; T.Free;
          FDECOD.Free;
       end;

    finally
       {Удаляем переменную и клон таблицы}
       SetDBFilter(@Q,'['+F_VAR_NAME+']='+QuotedStr(TEMP_VAR_NAME));
       With Q do begin Delete; Close; Free; end;

       Tree.Enabled  := (Tree.Items.Count > 0);
       Tree.Items.EndUpdate;
       EnablAction;
    end;
end;


{==============================================================================}
{============================   СОБЫТИЕ: CLICK   ==============================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.TreeClick(Sender: TObject);
var N : TTreeNode;
    T : TADOTable;
    S : String;
begin
    {Доступность Action}
    EnablAction;

    {Подсказка}
    S := '';
    N := Tree.Selected;
    try
       If (N <> nil) and QQst.Active then begin
          SetDBFilter(@QQst, '['+F_COUNTER+']='+IntToStr(Integer(N.Data)));
          If QQst.RecordCount = 1 then begin
             {Читаем через отдельную таблицу, т.к. обрезает длинные строки}
             T := TADOtable.Create(Self);
             T.Connection := FFMAIN.BUD.BD;
             try     If OpenBD(@FFMAIN.BEXP.BD, '', '', [@T], [T_EXP_QST], true) then begin
                        SetDBFilter(@T, '['+F_COUNTER+']='+IntToStr(Integer(N.Data)));
                        S := T.FieldByName(F_QST_HINT).AsString;
                     end;
             finally If T.Active then T.Close; T.Free;
             end;
          end;
          SetDBFilter(@QQst, '');
        end;
    finally
        LInfo.Caption := S;
        If Trim(S)<>'' then LInfo.Cursor := crHandPoint
                       else LInfo.Cursor := crDefault;
    end;
end;


{==============================================================================}
{=========================   СОБЫТИЕ: DBL_CLICK   =============================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.TreeDblClick(Sender: TObject);
var P : TPoint;
    N : TTreeNode;
begin
    {Реакция только при нахождении курсора в области выбора}
    If Sender <> nil then begin
       If not GetCursorPos(P) then Exit;
       P := Tree.ScreenToClient(P);
       N := Tree.GetNodeAt(P.X, P.Y);
    end else begin
       If Tree.SelectionCount=0 then Exit;
       N:=Tree.Selected;
    end;
    If N = nil then Exit;

    {Редактируем элемент}
    EditElement(N);
end;


{==============================================================================}
{==========================   СОБЫТИЕ: KEY_DOWN   =============================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.TreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    13 {Enter} : TreeDblClick(nil);
    27 {ESC}   : ModalResult := mrCancel;
    end;
end;


{==============================================================================}
{===========================   СОБЫТИЕ: KEY_UP   ==============================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.TreeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    TreeClick(Sender);
end;


{==============================================================================}
{===========================   DRAG: ДОПУСТИМОСТЬ   ===========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.TreeDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var NSrc, NDect: TTreeNode;
begin
    Accept := false;
    NDect  := Tree.GetNodeAt(X, Y); If Not Assigned(NDect) then Exit;
    NSrc   := Tree.Selected;        If Not Assigned(NSrc)  then Exit;
    If NSrc.AbsoluteIndex = NDect.AbsoluteIndex            then Exit;
    Accept := true;
end;


{==============================================================================}
{===========================    DRAG: ПЕРЕМЕЩЕНИЕ    ==========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.TreeDragDrop(Sender, Source: TObject; X, Y: Integer);
var NSrc, NDect : TTreeNode;
    Val         : Boolean;
begin
    {Инициализация}
    NDect := Tree.GetNodeAt(X, Y); If Not Assigned(NDect) then Exit;
    NSrc  := Tree.Selected;        If Not Assigned(NSrc)  then Exit;

    Val := GetTreeNodeCheck(NSrc);
    If NDect.Index > NSrc.Index then begin
       If NDect.getNextSibling <> nil then NSrc.MoveTo(NDect.getNextSibling, naInsert)
                                      else NSrc.MoveTo(NDect,                naAdd);
    end else NSrc.MoveTo(NDect, naInsert);
    SetTreeNodeCheck(NSrc, Val);
end;


{==============================================================================}
{==================    СОБЫТИЕ: ПРОРИСОВКА ЭЛЕМЕНТА    ========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.TreeCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
const Color: array [0..2] of TColor = (clBlack, clBlue, clRed);
//const Color: array [0..9] of TColor = (clBlack, clBlue, clGreen, clRed, clMaroon, clFuchsia, clWebPeru, clWebOrchid, clPurple, clTeal);
begin
    //If Node.ImageIndex = 0 then Sender.Canvas.Font.Style := [fsBold];
    Sender.Canvas.Font.Color := Color[(Node.ImageIndex mod High(Color))];
end;


{==============================================================================}
{===================   ФУНКЦИЯ: РЕДАКТИРОВАТЬ ЭЛЕМЕНТ   =======================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.EditElement(const N: TTreeNode);
var S: String;
begin
    If N = nil      then Exit;
    If N.Level <> 0 then Exit;

    S := EditMemo('Редактор вопроса', N.Text, false);
    N.Text := ReplStr(S, CH_NEW, '');
end;




{==============================================================================}
{=========================   ОПЕРАЦИИ С ACTION   ==============================}
{==============================================================================}


{==============================================================================}
{=========================   ACTION: ОТМЕТИТЬ ВСЁ   ===========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.A_SelAllExecute(Sender: TObject);
begin
    SetAllChk(true);
end;


{==============================================================================}
{=========================   ACTION: ОЧИСТИТЬ ВСЁ   ===========================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.A_DeselAllExecute(Sender: TObject);
begin
    SetAllChk(false);
end;


{==============================================================================}
{=============  УСТАНАВЛИВАЕТ ВСЕ CHECKED В ЗАДАННОЕ ЗНАЧЕНИЕ =================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.SetAllChk(const Val: Boolean);
var I: Integer;
begin
    For I:=0 to Tree.Items.Count-1 do SetTreeNodeCheck(Tree.Items[I], Val);
    EnablAction;
end;


{==============================================================================}
{===========================   LINFO: ON_CLICK   ==============================}
{==============================================================================}
procedure TFVAR_EXPERT_HELPER.LInfoClick(Sender: TObject);
begin
    If LInfo.Cursor = crHandPoint then EditMemo('Примечание', LInfo.Caption, true);
end;


