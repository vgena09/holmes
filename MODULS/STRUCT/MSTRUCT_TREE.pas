{******************************************************************************}
{********************************   TREE   ************************************}
{******************************************************************************}

{==============================================================================}
{==========================   TREE: ИНИЦИАЛИЗАЦИЯ   ===========================}
{==============================================================================}
procedure TFSTRUCT.IniTree;
begin
    With Tree do begin
       HideSelection    := false;
       Images           := FFMAIN.ImgSys16;
       ReadOnly         := true;
       PopupMenu        := PMenu;
       ShowRoot         := true;
       OnChange         := TreeChange;
       OnDblClick       := TreeDblClick;
       OnKeyDown        := TreeKeyDown;
       OnCustomDrawItem := TreeCustomDrawItem;
       OnMouseEnter     := TreeMouseEnter;
    end;
    RefreshTree;
end;


{==============================================================================}
{===========================   TREE: ОБНОВЛЕНИЕ   =============================}
{==============================================================================}
procedure TFSTRUCT.RefreshTree;
const SFIELD     : array [0..3, 0..1] of String = ((PPERSON_STATE, PPERSON_FIO),
                                                   (LPERSON_STATE, LPERSON_NAME_SHORT),
                                                   (DPERSON_STATE, DPERSON_FIO),
                                                   (OBJECT_VD,     OBJECT_CAPTION));
var Event        : TTVChangedEvent;
    NParent, N   : TTreeNode;
    Q            : TADOQuery;
    ITab, ICount : Integer;
    S            : String;
begin
    {Инициализация}
    ICount := 0;
    Q := TADOQuery.Create(Self);
    With Tree do begin
       Event    := OnChange;
       OnChange := nil;
       Items.BeginUpdate;
       Items.Clear;
       try
          OnChange     := nil;
          Q.Connection := FFMAIN.BUD.BD;
          For ITab := Low(LTAB_UD) to High(LTAB_UD) do begin
             {Создаем запрос}
             S := 'SELECT * FROM ['+LTAB_UD[ITab]+'] ORDER BY ['+SFIELD[ITab][0]+'] ASC, ['+SFIELD[ITab][1]+'] ASC;';
             Q.SQL.Text := S;
             Q.Open;
             If Q.RecordCount = 0 then Continue;

             {Создаем папку}
             NParent := Items.AddChildObject(nil, LTAB_UD[ITab], Pointer(ITab));
             NParent.ImageIndex    := ICO_FOLDER;
             NParent.SelectedIndex := ICO_FOLDER_LIGHT;

             {Создаем элементы}
             Q.First;
             While not Q.Eof do begin
                If ITab <> LTAB_UD_OBJECT then S := Q.FieldByName(SFIELD[ITab][0]).AsString+' '+Q.FieldByName(SFIELD[ITab][1]).AsString
                                          else S := Q.FieldByName(SFIELD[ITab][1]).AsString;
                N := Items.AddChildObject(NParent, S, Pointer(Q.FieldByName(F_COUNTER).AsInteger));
                N.ImageIndex    := GetIcoElementUD(PADOTable(@Q), ITab);
                N.SelectedIndex := N.ImageIndex;
                Q.Next;
                Inc(ICount);
             end;
             Q.Close;
          end;

          {Восстанавливаем выдление}
          LoadSel;
          {Разворачиваем все}
          FullExpand;
       finally
          FFMAIN.StatusBar.Panels[STATUS_STRUCT].Text := 'Элементов: '+IntToStr(ICount);
          If Q.Active then Q.Close; Q.Free;
          Items.EndUpdate;
          OnChange := Event;
          EnablAction;
       end;
    end;
end;


{==============================================================================}
{==========================  СОБЫТИЕ: ON_CHANGE  ==============================}
{==============================================================================}
procedure TFSTRUCT.TreeChange(Sender: TObject; Node: TTreeNode);
var N: TTreeNode;
begin
    Tree.OnChange := nil;
    Tree.Items.BeginUpdate;
    try
       {Сохраняем выдление}
       If Sender <> nil then SaveSel;

       {Если каталог - разворачиваем}
       N := Tree.Selected;
       If N <> nil then begin
          If N.Level=0 then N.Expanded := true;
       end;

       {Автопрокрутка окна}
       AutoScrollTree(@Tree);
    finally
       Tree.Items.EndUpdate;
       Tree.OnChange := TreeChange;
       EnablAction;
    end;
end;


{==============================================================================}
{===========================   GRID: DBL_CLICK   ==============================}
{==============================================================================}
procedure TFSTRUCT.TreeDblClick(Sender: TObject);
var P : TPoint;
    F : TForm;
    Q : TADOQuery;
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
    If N.Level <> 1 then Exit;

    {Находим запись}
    Q := TADOQuery.Create(Self);
    try
       Q.Connection := FFMAIN.BUD.BD;
       Q.SQL.Text   := 'SELECT * FROM ['+LTAB_UD[Integer(N.Parent.Data)]+'] WHERE ['+F_COUNTER+']='+IntToStr(Integer(N.Data))+';';
       Q.Open;
       If Q.RecordCount <> 1 then Exit;

       {Диалог}
       case Integer(N.Parent.Data) of
          LTAB_UD_PPERSON: begin
             F := TFVAR_UD_EDIT_PPERSON.Create(Self);
             try     TFVAR_UD_EDIT_PPERSON(F).Execute(@Q);
             finally F.Free; end;
             If Q.Active then Q.Close;
             RefreshTable(@FFMAIN.BUD.TPPERSON);
          end;
          LTAB_UD_LPERSON: begin
             F := TFVAR_UD_EDIT_LPERSON.Create(Self);
             try     TFVAR_UD_EDIT_LPERSON(F).Execute(@Q);
             finally F.Free; end;
             If Q.Active then Q.Close;
             RefreshTable(@FFMAIN.BUD.TLPERSON);
          end;
          LTAB_UD_DPERSON: begin
             F := TFVAR_UD_EDIT_DPERSON.Create(Self);
             try     TFVAR_UD_EDIT_DPERSON(F).Execute(@Q);
             finally F.Free; end;
             If Q.Active then Q.Close;
             RefreshTable(@FFMAIN.BUD.TDPERSON);
          end;
          LTAB_UD_OBJECT: begin
             F := TFVAR_UD_EDIT_OBJECT.Create(Self);
             try     TFVAR_UD_EDIT_OBJECT(F).Execute(@Q);
             finally F.Free; end;
             If Q.Active then Q.Close;
             RefreshTable(@FFMAIN.BUD.TOBJECT);
          end;
       end;
    finally
        Q.Free;
    end;

    RefreshTree;
end;

{==============================================================================}
{============================   GRID: KEY_DOWN   ==============================}
{==============================================================================}
procedure TFSTRUCT.TreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    13: {Enter} TreeDblClick(nil);
    end;
end;


{==============================================================================}
{===================    СОБЫТИЕ: OnCustomDrawItem    ==========================}
{==============================================================================}
procedure TFSTRUCT.TreeCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
                             State: TCustomDrawState; var DefaultDraw: Boolean);
begin
    If Node.ImageIndex = ICO_FOLDER then Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsBold];
    If Not Node.Selected then Exit;
    If FFMAIN.WIN_VER < wvVista then begin
       {Для WinXP}
       if Node.ImageIndex = ICO_FOLDER then Sender.Canvas.Brush.Color := clRed
                                       else Sender.Canvas.Brush.Color := clGreen;
       Sender.Canvas.Font.Color  := clWhite;
    end else begin
       {Для WinVista и Win7}
       if Node.ImageIndex = ICO_FOLDER then Sender.Canvas.Font.Color := clRed
                                       else Sender.Canvas.Font.Color := clGreen;
    end;
end;


{==============================================================================}
{==========================   СОБЫТИЕ: SET_FOCUS   ============================}
{==============================================================================}
procedure TFSTRUCT.TreeMouseEnter(Sender: TObject);
begin
    If not Tree.Focused then Tree.SetFocus;
end;


{==============================================================================}
{===================   СОХРАНИТЬ - ВОССТАНОВИТЬ ВЫДЕЛЕНИЕ  ====================}
{==============================================================================}
procedure TFSTRUCT.SaveSel;
var N : TTreeNode;
    S : String;
begin
    {Инициализация}
    S := '';
    N := Tree.Selected;
    If N <> nil then begin
       case N.Level of
       0: S := IntToStr(Integer(N.Data));
       1: S := IntToStr(Integer(N.Parent.Data)) + ' ' + IntToStr(Integer(N.Data));
       end;
    end;

    {Запись}
    TableWriteVar(@FFMAIN.BUD.TSYS, F_UD_SYS_STRUCT_SEL, S);
end;

procedure TFSTRUCT.LoadSel;
var Event   : TTVChangedEvent;
    N, NRes : TTreeNode;
    S1, S2  : String;
    I1, I2  : Pointer;
begin
    {Чтение}
    S1 := TableReadVar(@FFMAIN.BUD.TSYS, F_UD_SYS_STRUCT_SEL, '');
    S2 := TokCharEnd(S1, ' ');
    If IsIntegerStr(S1) then I1 := Pointer(StrToInt(S1)) else I1 := Pointer(0);
    If IsIntegerStr(S2) then I2 := Pointer(StrToInt(S2)) else I2 := Pointer(0);

    {Ищем узел}
    NRes := nil;
    N := Tree.Items.GetFirstNode;
    While N <> nil do begin
        If (N.Level=0) and (N.Data=I1) then NRes := N;
        If (N.Level=1) and (N.Data=I2) then begin
           If N.Parent.Data = I1 then begin
              NRes := N;
              Break;
           end;
        end;
        N:=N.GetNext;
    end;

    {Устанавливаем выделение}
    Event         := Tree.OnChange;
    Tree.OnChange := nil;
    Tree.Selected := NRes;
    Tree.OnChange := Event;
end;
