{******************************************************************************}
{********************************   TREE   ************************************}
{******************************************************************************}

{==============================================================================}
{==========================   TREE: ИНИЦИАЛИЗАЦИЯ   ===========================}
{==============================================================================}
procedure TFVAR_EXPERT.IniTree;
begin
    With Tree do begin
       Images := FFMAIN.ImgSys16;
       Items.Clear;
       HideSelection := false;
       MultiSelect   := false;
       ReadOnly      := true;
       ShowLines     := true;
       ShowRoot      := false;
       DragMode      := dmAutomatic;
       AutoExpand    := false;
       PopupMenu     := PMenu;

       OnDblClick    := TreeDblClick;
       OnKeyDown     := TreeKeyDown;
       OnMouseEnter  := TreeMouseEnter;

       OnDragOver    := TreeDragOver;
       OnDragDrop    := TreeDragDrop;
    end;
end;


{==============================================================================}
{=============================   TREE: LOAD   =================================}
{==============================================================================}
procedure TFVAR_EXPERT.ReadVar;
var L1, L2 : TStringList;
    I      : Integer;

    {Читаем секцию}
    procedure SetBlock(const Section: String);
    var N, NParent : TTreeNode;
        I, Ind     : Integer;
    begin
        {Копируем секцию со списком объектов исследований}
        LSectionCopy(@L1, @L2, Section);

        {Если нет записей - выход}
        If L2.Count=0 then Exit;

        {Создаем корневой директорий}
        NParent:=Tree.Items.AddChildObject(nil, Section, Pointer(0));
        NParent.ImageIndex    := ICO_FOLDER;
        NParent.SelectedIndex := ICO_FOLDER_LIGHT;

        {Создаем записи}
        For I:=0 to L2.Count-1 do begin
           N := Tree.Items.AddChildObject(NParent, L2[I], Pointer(0));
           If Section = F_VAR_STR_EXPERT_MAT then begin
              If IDToTable(L2[I]) = T_UD_PPERSON then N.Data := Pointer(StrToInt(IDToRecord(L2[I])))
                                                 else N.Data := Pointer(StrToInt(IDToRecord(L2[I])) * (-1));
              Ind := IDToIco(@FFMAIN.BUD, L2[I]);
              N.ImageIndex    := Ind;
              N.SelectedIndex := Ind;
              N.Text := IDToTxt(@FFMAIN.BUD, L2[I], []);
              Continue;
           end;
           //If Section = F_VAR_STR_EXPERT_QST then begin
           //   N.ImageIndex    := ICO_QUEST;
           //   N.SelectedIndex := ICO_QUEST;
           //   Continue;
           //end;
           N.ImageIndex    := ICO_QUEST;
           N.SelectedIndex := ICO_QUEST;
        end;
    end;

begin
    {Допустимость}
    Tree.Items.Clear;
    If PQVAR^.RecordCount=0 then Exit;

    {Инициализация}
    Tree.Items.BeginUpdate;
    L1 := TStringList.Create;
    L2 := TStringList.Create;
    try
       {Читаем значение переменной целиком}
       L1.Text := PQVAR^.FieldByName(F_VAR_VAL_STR).AsString;

       {Загружаем секции в Tree}
       For I:=Low(SECTIONS) to High(SECTIONS) do SetBlock(SECTIONS[I]);

       {Разворачиваем структуру}
       Tree.FullExpand;

       {Восстановление выделенной переменной}
       If PTSAV <> nil  then begin
          I:=TableReadVar(PTSAV, IDVar+': '+F_UD_SYS_EXPERT_SEL, 0);
          try     If (I > -1)  and (I < Tree.Items.Count) then Tree.Selected:=Tree.Items[I];
          except end;
       end;
       AutoScrollTree(@Tree);

    finally
       Tree.Items.EndUpdate;
       L1.Free;
       L2.Free;
       EnablAction;
       SetTreeHint(Tree, false);
    end;
end;


{==============================================================================}
{=============================   TREE: SAVE   =================================}
{==============================================================================}
procedure TFVAR_EXPERT.WriteVar;
var L1 : TStringList;
    I  : Integer;

    procedure RefreshSect(const Section: String);
    var NParent, N : TTreeNode;
        I : Integer;
        S : String;
    begin
        {Удаляем секцию Section}
        LSectionDel(@L1, Section);

        {Ищем в Tree каталог}
        NParent := FindNodeLevel(@Tree, Section, 0);
        If NParent       = nil then Exit;
        If NParent.Count = 0   then Exit;

        {Создаем новую секцию}
        L1.Add('['+Section+']');

        {Просматриваем ItemParent}
        N := NParent.getFirstChild;
        While N <> nil do begin
           If N.Level <> 1 then Break;

           S := N.Text;
           I := Integer(N.Data);
           If I > 0 then S := T_UD_PPERSON+'.'+IntToStr(I);       {Section = F_VAR_STR_EXPERT_MAT}
           If I < 0 then S := T_UD_OBJECT +'.'+IntToStr(I*(-1));  {Section = F_VAR_STR_EXPERT_MAT}

           L1.Add(S);
           N:=N.GetNext;
        end;
    end;

begin
    {Сохраняем индекс выделенной переменной}
    If Tree.Selected <> nil then TableWriteVar(PTSAV, IDVar+': '+F_UD_SYS_EXPERT_SEL, Tree.Selected.AbsoluteIndex)
                            else TableWriteVar(PTSAV, IDVar+': '+F_UD_SYS_EXPERT_SEL, -1);
    {Инициализация}
    L1:=TStringList.Create;
    try
       {Читаем значение переменной целиком}
       L1.Text:=PQVAR^.FieldByName(F_VAR_VAL_STR).AsString;

       {Обновляем в переменной указанные секции}
       For I:=Low(SECTIONS) to High(SECTIONS) do RefreshSect(SECTIONS[I]);

       {Записываем значение переменной в БД}
       With PQVAR^ do begin
          Edit;
          FieldByName(F_VAR_VAL_STR).AsString:=L1.Text;
          UpdateRecord;
          Post;
       end;
    finally
       L1.Free;
    end;
end;


{==============================================================================}
{===========================   TREE: DBL_CLICK   ==============================}
{==============================================================================}
procedure TFVAR_EXPERT.TreeDblClick(Sender: TObject);
var P : TPoint;
    N : TTreeNode;
begin
    {Реакция только при нахождении курсора в области выбора}
    If Sender <> nil then begin
       If GetCursorPos(P) = false then Exit;
       P := Tree.ScreenToClient(P);
       N := Tree.GetNodeAt(P.X, P.Y);
    end else begin
       If Tree.Selected = nil then Exit;
       N := Tree.Selected;
    end;

    {Редактируем элемент}
    EditElement(N);
end;


{==============================================================================}
{==========================   СОБЫТИЕ: KEY_DOWN   =============================}
{==============================================================================}
procedure TFVAR_EXPERT.TreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    13  {Enter}: If Tree.Selected <> nil then EditElement(Tree.Selected);
    end;
end;


{==============================================================================}
{===========================   DRAG: ДОПУСТИМОСТЬ   ===========================}
{==============================================================================}
procedure TFVAR_EXPERT.TreeDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var NSrc, NDect: TTreeNode;
begin
    Accept := false;
    NDect  := Tree.GetNodeAt(X, Y); If Not Assigned(NDect) then Exit; If NDect.Level <> 1 then Exit;
    NSrc   := Tree.Selected;        If Not Assigned(NSrc)  then Exit; If NSrc .Level <> 1 then Exit;
    If NSrc.Parent.AbsoluteIndex <> NDect.Parent.AbsoluteIndex then Exit;
    If NSrc.AbsoluteIndex         = NDect.AbsoluteIndex        then Exit;
    Accept := true;
end;


{==============================================================================}
{===========================    DRAG: ПЕРЕМЕЩЕНИЕ    ==========================}
{==============================================================================}
procedure TFVAR_EXPERT.TreeDragDrop(Sender, Source: TObject; X, Y: Integer);
var NSrc, NDect: TTreeNode;
begin
    {Инициализация}
    NDect := Tree.GetNodeAt(X, Y); If Not Assigned(NDect) then Exit; //If NDect.Level = 0 then Exit;
    NSrc  := Tree.Selected;        If Not Assigned(NSrc)  then Exit;

    If NDect.Index > NSrc.Index then begin
       If NDect.getNextSibling <> nil then NSrc.MoveTo(NDect.getNextSibling, naInsert)
                                      else NSrc.MoveTo(NDect,                naAdd);
    end else NSrc.MoveTo(NDect, naInsert);
end;


{==============================================================================}
{===========================   TREE: SET_FOCUS   ==============================}
{==============================================================================}
procedure TFVAR_EXPERT.TreeMouseEnter(Sender: TObject);
begin
    If not Tree.Focused then Tree.SetFocus;
end;

