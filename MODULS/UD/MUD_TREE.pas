{******************************************************************************}
{********************************   TREE   ************************************}
{******************************************************************************}

{==============================================================================}
{==========================   TREE: ИНИЦИАЛИЗАЦИЯ   ===========================}
{==============================================================================}
procedure TFUD.IniTree;
begin
    With TreeUD do begin
       HideSelection    := false;
       Images           := FFMAIN.ImgSys16;
       PopupMenu        := PMenu;
       ShowRoot         := true;
       OnChange         := TreeUDChange;
       OnCompare        := TreeUDCompare;
       OnCustomDrawItem := TreeUDCustomDrawItem;
       OnMouseEnter     := TreeUDMouseEnter;
    end;
    RefreshTreeUD;
end;


{==============================================================================}
{===========================   TREE: ОБНОВЛЕНИЕ   =============================}
{==============================================================================}
procedure TFUD.RefreshTreeUD;
var SPath, SFind : String;
    UDCount      : Integer;

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
           If FindFirst(PATH_UD+SPath+'*', faDirectory, Sr) = 0 then begin
              repeat
                 SName := Sr.Name;
                 If (SName = '.') or (SName = '..') then Continue;
                 SNameOnly := ExtractFileNameWithoutExt(SName);
                 SExt      := ExtractFileExt(SName);

                 {Обнаружен каталог}
                 If (Sr.Attr and faDirectory) > 0 then begin
                    N := TreeUD.Items.AddChildObject(NParent, SNameOnly, Pointer(ID_DIR));
                    N.ImageIndex    := ICO_FOLDER;
                    N.SelectedIndex := ICO_FOLDER_LIGHT;
                    AddDir(N);
                    Continue;
                 end;

                 {Обнаружен документ}
                 IExt := FindStrInArray(SExt, L_EXT);
                 If Pos('~', SName) > 0 then Continue;

                 If IExt >= Low(L_EXT) then begin
                    N := TreeUD.Items.AddChildObject(NParent, SNameOnly, Pointer(L_IND[IExt]));
                    N.ImageIndex    := L_ICO[IExt];
                    N.SelectedIndex := L_ICO[IExt] + 1;
                    Inc(UDCount);
                 end;
              until FindNext(Sr) <> 0;
           end;
        finally
           FindClose(Sr);
        end;
    end;

begin
    TreeUD.Items.BeginUpdate;
    TreeUD.OnChange:=nil;
    TreeUD.Items.Clear;
    try
       UDCount := 0;
       SPath   := ReadLocalString(INI_UD, INI_UD_SELECT_TREE, '');
       SFind   := AnsiUpperCase(Trim(EFind.Text));
       AddDir(nil);
       FFMAIN.StatusBar.Panels[STATUS_UD].Text := 'Дел: '+IntToStr(UDCount);

       {Удаляем пустые каталоги}
       DelEmptyNode(@TreeUD);

       {Восстанавливаем выдление}
       LoadTreeSelect(@TreeUD, INI_UD, INI_UD_SELECT_TREE);

    finally
       TreeUDChange(nil, nil);
       TreeUD.AlphaSort(true); // Сортировка узлов
       TreeUD.Enabled  := (TreeUD.Items.Count > 0);
       TreeUD.OnChange := TreeUDChange;
       TreeUD.Items.EndUpdate;
    end;
end;


{==============================================================================}
{==========================  СОБЫТИЕ: ON_CHANGE  ==============================}
{==============================================================================}
procedure TFUD.TreeUDChange(Sender: TObject; Node: TTreeNode);
var N: TTreeNode;
begin
    PMain.Caption := 'Дело не выбрано';
    TreeUD.Items.BeginUpdate;
    TreeUD.OnChange:=nil;
    try
       {Сохраняем выдление}
       If Sender <> nil then SaveTreeSelect(@TreeUD, INI_UD, INI_UD_SELECT_TREE);
       N := TreeUD.Selected;
       If N <> nil then begin
          Case Integer(N.Data) of
          ID_DIR: begin {Если каталог - разворачиваем}
             N.Expanded := true;
             CloseUD;
          end;
          ID_MDB: begin {Если файл    - открываем дело}
             OpenUD(GetSelectedPath);
          end;
          End;
       end;

       {Автопрокрутка окна}
       AutoScrollTree(@TreeUD);
    finally
       EnablAction;
       TreeUD.Enabled  := (TreeUD.Items.Count > 0);
       TreeUD.OnChange := TreeUDChange;
       TreeUD.Items.EndUpdate;
    end;
end;


{==============================================================================}
{=======================    АЛГОРИТМ СОРТИРОВКИ    ============================}
{==============================================================================}
procedure TFUD.TreeUDCompare(Sender: TObject; Node1, Node2: TTreeNode;
                             Data: Integer; var Compare: Integer);
begin
    If (Node1=nil) or (Node2=nil) then Exit;
    If (Node1.ImageIndex = Node2.ImageIndex) then begin
       If Node1.Text < Node2.Text then Compare:=-1 else Compare:=1;
       Exit;
    end;

    If (Node1.ImageIndex = ICO_FOLDER) and (Node2.ImageIndex = ICO_UD) then Compare:=-1
                                                                       else Compare:=1;
end;



{==============================================================================}
{===================    СОБЫТИЕ: OnCustomDrawItem    ==========================}
{==============================================================================}
procedure TFUD.TreeUDCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
          State: TCustomDrawState; var DefaultDraw: Boolean);
begin
    If Not Node.Selected then Exit;
    If FFMAIN.WIN_VER < wvVista then begin
       {Для WinXP}
       if Node.ImageIndex = ICO_UD then Sender.Canvas.Brush.Color := clGreen
                                   else Sender.Canvas.Brush.Color := clRed;
       Sender.Canvas.Font.Color  := clWhite;
    end else begin
       {Для WinVista и Win7}
       if Node.ImageIndex = ICO_UD then Sender.Canvas.Font.Color := clGreen
                                   else Sender.Canvas.Font.Color := clRed;
    end;
end;


{==============================================================================}
{===================    ПУТЬ К ВЫДЕЛЕННОМУ MDB-ФАЙЛУ    =======================}
{==============================================================================}
function TFUD.GetSelectedPath: String;
var N: TTreeNode;
begin
    Result := '';
    N := TreeUD.Selected;
    If N = nil then Exit;
    If N.ImageIndex <> ICO_UD then Exit;
    Result := GetNodePath(@N);
    Delete(Result, Length(Result), 1);
    Result := PATH_UD + Result + '.mdb';
    If not FileExists(Result) then Result:='';
end;


{==============================================================================}
{===================    ПУТЬ К ВЫДЕЛЕННОМУ MDB-ФАЙЛУ    =======================}
{==============================================================================}
function TFUD.FullPathToTreePath(const SPath: String): String;
var SDir: String;
begin
    Result := SPath;
    SDir   := PATH_UD;
    Delete(Result, 1, Length(SDir));
    If CmpStr(ExtractFileExt(Result), '.MDB') then begin
       Delete(Result, Length(Result)-3, 4);
       Result := Result + '\';
    end;
end;


{==============================================================================}
{==========================   СОБЫТИЕ: SET_FOCUS   ============================}
{==============================================================================}
procedure TFUD.TreeUDMouseEnter(Sender: TObject);
begin
    If not TreeUD.Focused then TreeUD.SetFocus;
end;


