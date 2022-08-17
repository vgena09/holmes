{******************************************************************************}
{********************************   TREE   ************************************}
{******************************************************************************}

{==============================================================================}
{==========================   TREE: ИНИЦИАЛИЗАЦИЯ   ===========================}
{==============================================================================}
procedure TFDOC_NEW.IniTree;
begin
    With TreeDoc do begin
       HideSelection := false;
       ShowRoot      := true;
       Images        := FFMAIN.ImgSys16;
       PopupMenu     := PMenu;
       OnCompare     := TreeDocCompare;
       OnChange      := TreeDocChange;
       OnDblClick    := TreeDocDblClick;
    end;
end;


{==============================================================================}
{===========================   TREE: ОБНОВЛЕНИЕ   =============================}
{==============================================================================}
procedure TFDOC_NEW.RefreshTree;
var N        : TTreeNode;
    S, SFind : String;
    DocCount : Integer;

    {Первый узел-файл}
    function FirstNodeFile: TTreeNode;
    var N: TTreeNode;
    begin
        Result := nil;
        N := TreeDoc.Items.GetFirstNode;
        While N <> nil do begin
            If N.Data <> Pointer(ID_DIR) then begin
               Result:=N;
               Break;
            end;
            N:=N.GetNext;
        end;
    end;

    {Добавить каталоги в узел NParent}
    procedure AddDir(const NParent: TTreeNode);
    var Sr   : TSearchRec;
        N    : TTreeNode;
        IExt : Integer;
        SPath, SName, SNameOnly, SExt: String;
    begin
        {Просматриваем каталог, соответствующий узлу}
        If NParent=nil then SPath := ''
                       else SPath := GetNodePath(@NParent);
        try
           If FindFirst(EPath.Text+SPath+'*', faDirectory, Sr) = 0 then begin
              repeat
                 SName := Sr.Name;
                 If (SName = '.') or (SName = '..') then Continue;
                 SNameOnly := ExtractFileNameWithoutExt(SName);
                 SExt      := ExtractFileExt(SName);

                 {Обнаружен каталог}
                 If (Sr.Attr and faDirectory) > 0 then begin
                    N := TreeDoc.Items.AddChildObject(NParent, SNameOnly, Pointer(ID_DIR));
                    N.ImageIndex    := ICO_FOLDER;
                    N.SelectedIndex := ICO_FOLDER_LIGHT;
                    AddDir(N);
                    Continue;
                 end;

                 {Поиск}
                 If (SFind <> '') and (FindStr(SFind, SPath+SNameOnly) <=0) then Continue;

                 {Обнаружен документ}
                 IExt := FindStrInArray(SExt, L_EXT);
                 If Pos('~', SName) > 0 then Continue;

                 If IExt >= Low(L_EXT) then begin
                    N := TreeDoc.Items.AddChildObject(NParent, SNameOnly, Pointer(L_IND[IExt]));
                    N.ImageIndex    := L_ICO[IExt];
                    N.SelectedIndex := L_ICO[IExt] + 1;
                    If Not FileExists(EPath.Text+SPath+SNameOnly+'.ini') then SetNodeState(@N, TVIS_CUT);
                    Inc(DocCount);
                 end;
              until FindNext(Sr) <> 0;
           end;
        finally
           FindClose(Sr);
        end;
    end;

begin
    TreeDoc.Items.BeginUpdate;
    TreeDoc.OnChange:=nil;
    TreeDoc.Items.Clear;
    try
       DocCount := 0;
       SFind    := AnsiUpperCase(Trim(EFind.Text));
       AddDir(nil);
       LInfo.Caption := ' Найдено документов: '+IntToStr(DocCount);

       {Удаляем пустые каталоги}
       DelEmptyNode(@TreeDoc);

       {Если не ищем, то восстанавливаем выделение}
       If SFind = '' then begin
          S := TableReadVar(@FFMAIN.BUD.TSYS, F_UD_SYS_DOCNEW_SEL, '');
          N := FindNodePath(@TreeDoc, S, false);
          If N <> nil then begin
             N.Expand(true);
             N.Selected := true;
          end;
       {Если ищем, то первый документ}
       end else begin
          N := FirstNodeFile;
          If N <> nil then begin
             N.Expand(true);
             N.Selected := true;
          end;
       end;
    finally
       TreeDocChange(nil, nil);
       TreeDoc.AlphaSort(true); // Сортировка узлов
       TreeDoc.Enabled  := (TreeDoc.Items.Count > 0);
       TreeDoc.OnChange := TreeDocChange;
       TreeDoc.Items.EndUpdate;
    end;
end;


{==============================================================================}
{============================   TREE: ON_CHANGE   =============================}
{==============================================================================}
procedure TFDOC_NEW.TreeDocChange(Sender: TObject; Node: TTreeNode);
begin
    If Sender <> nil then begin
       TableWriteVar(@FFMAIN.BUD.TSYS, F_UD_SYS_DOCNEW_SEL, GetNodePath(@Node));
       Node.Expanded := true;
    end;
    EnablAction;
end;


{==============================================================================}
{============================   TREE: DBL_CLICK   =============================}
{==============================================================================}
procedure TFDOC_NEW.TreeDocDblClick(Sender: TObject);
var P : TPoint;
    N : TTreeNode;
begin
    {Реакция только при нахождении курсора в области выбора}
    If Sender <> nil then begin
       If not GetCursorPos(P) then Exit;
       P := TreeDoc.ScreenToClient(P);
       N := TreeDoc.GetNodeAt(P.X, P.Y);
    end else begin
       If TreeDoc.SelectionCount=0 then Exit;
       N:=TreeDoc.Selected;
    end;
    If N = nil then Exit;
    If Integer(N.Data) > ID_DIR then AOk.Execute;
end;


{==============================================================================}
{============================   TREE: KEY_DOWN   ==============================}
{==============================================================================}
procedure TFDOC_NEW.TreeDocKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    13: {Enter} TreeDocDblClick(nil);
    27: {ESC}   ACancel.Execute;
    end;
end;


{==============================================================================}
{=======================    АЛГОРИТМ СОРТИРОВКИ    ============================}
{==============================================================================}
procedure TFDOC_NEW.TreeDocCompare(Sender: TObject; Node1, Node2: TTreeNode;
                                   Data: Integer; var Compare: Integer);
begin
    If (Node1=nil) or (Node2=nil) then Exit;
    If (Node1.ImageIndex = Node2.ImageIndex) then begin
       If Node1.Text < Node2.Text then Compare:=-1 else Compare:=1;
       Exit;
    end;

    If (Integer(Node1.Data) = ID_DIR) and (Integer(Node2.Data) > ID_DIR) then Compare:=-1
                                                                         else Compare:=1;
end;


{==============================================================================}
{=============================   ACTION: EXPAND    ============================}
{==============================================================================}
procedure TFDOC_NEW.AExpandExecute(Sender: TObject);
begin
    TreeDoc.FullExpand;
end;


{==============================================================================}
{============================   ACTION: COLLAPSE    ===========================}
{==============================================================================}
procedure TFDOC_NEW.ACollapseExecute(Sender: TObject);
begin
    TreeDoc.FullCollapse;
end;


