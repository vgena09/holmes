{******************************************************************************}
{*******************************   FINDER   ***********************************}
{******************************************************************************}

{==============================================================================}
{=========================   FINDER: ИНИЦИАЛИЗАЦИЯ   ==========================}
{==============================================================================}
procedure TFUD.IniFinder();
begin
    BtnFind.Action          := AFind;
    BtnFind.ShowHint        := true;

    BtnClose.Action         := AFinderHide;
    BtnClose.ShowHint       := true;

    EFind.OnKeyDown         := EFindKeyDown;
    EFind.OnChange          := EFindChange;
    EFind.DropDownCount     := 20;
    ReadCBListIni(@EFind, INI_UD_FIND);

    AFinder.AutoCheck := true;
    AFinder.Checked   := ReadLocalBool(INI_UD, INI_UD_FINDER_VISIBLE, false);
    AFinderExecute(nil);
end;

{==============================================================================}
{====================    ACTION: ПОКАЗАТЬ/СКРЫТЬ ПОИСК   ======================}
{==============================================================================}
procedure TFUD.AFinderExecute(Sender: TObject);
begin
    PFinder.Visible := AFinder.Checked;
    If Sender <> nil then WriteLocalBool(INI_UD, INI_UD_FINDER_VISIBLE, PFinder.Visible);
    EnablAction;
end;

{==============================================================================}
{=========================    ACTION: СКРЫТЬ ПОИСК   ==========================}
{==============================================================================}
procedure TFUD.AFinderHideExecute(Sender: TObject);
begin
    AFinder.Checked := false;
    AFinderExecute(Sender);
    If TreeUD.Enabled then TreeUD.SetFocus;
end;


{==============================================================================}
{============================    ACTION: ПОИСК   ==============================}
{==============================================================================}
procedure TFUD.AFindExecute(Sender: TObject);
var N        : TTreeNode;
    LFind    : TStringList;
    IFind    : Integer;
    SFind, S : String;
begin
    {Инициализация}
    SFind := AnsiUpperCase(Trim(EFind.Text));
    If SFind   = '' then begin FFMAIN.IconMsg('Поиск', 'Не указано, что ищем.',   bfWarning); Exit; end;
    If PATH_UD = '' then begin FFMAIN.IconMsg('Поиск', 'Не указан путь к делам.', bfWarning); Exit; end;

    {Корректируем и сохраняем список поиска}
    S     := Trim(EFind.Text);
    IFind := EFind.Items.IndexOf(S);
    If IFind >= 0 then EFind.Items.Delete(IFind);
    EFind.Items.Insert(0, S);
    EFind.Text := S;
    For IFind:=EFind.Items.Count-1 downto 20 do EFind.Items.Delete(IFind);
    WriteCBListIni(@EFind, INI_UD_FIND);

    LFind := TStringList.Create;
    try
       {Разбиваем строку поиска}
       While SFind<>'' do LFind.Add(Trim(TokChar(SFind, ' ')));
       If LFind.Count = 0 then begin FFMAIN.IconMsg('Поиск УД', 'Не указано, что ищем.', bfWarning); Exit; end;

       {Ищем}
       N := FindNextNodeLText(@TreeUD, TreeUD.Selected, @LFind);
       If N = nil then begin FFMAIN.IconMsg('Поиск УД', 'Ничего не найдено!'+CH_NEW+'Упростите поисковый запрос.', bfInfo); Exit; end;
       N.Selected := true;

    finally
       If LFind<>nil then begin LFind.Clear; LFind.Free; end;
    end;
end;

procedure TFUD.ABreakExecute(Sender: TObject);
begin
    IsBreak := true;
end;


{==============================================================================}
{===========================    EFIND: KEY_DOWN   =============================}
{==============================================================================}
procedure TFUD.EFindKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    13: {Enter} AFind.Execute;
    end;
end;


{==============================================================================}
{============================    EFIND: CHANGE   ==============================}
{==============================================================================}
procedure TFUD.EFindChange(Sender: TObject);
begin
    EnablAction;
end;

