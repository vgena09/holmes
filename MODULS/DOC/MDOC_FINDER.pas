{******************************************************************************}
{*******************************   FINDER   ***********************************}
{******************************************************************************}

{==============================================================================}
{=========================   FINDER: »Õ»÷»¿À»«¿÷»ﬂ   ==========================}
{==============================================================================}
procedure TFDOC.IniFinder;
begin
    BtnClose.Action   := AFinderHide;
    BtnClose.ShowHint := true;
    EFind.Text        := '';
    EFind.OnChange    := EFindChange;

    AFinder.AutoCheck := true;
    AFinder.Checked   := ReadLocalBool(INI_DOC, INI_DOC_FINDER, false);
    AFinderExecute(nil);
end;

{==============================================================================}
{====================    ACTION: œŒ ¿«¿“‹/— –€“‹ œŒ»—    ======================}
{==============================================================================}
procedure TFDOC.AFinderExecute(Sender: TObject);
begin
    PFinder.Visible := AFinder.Checked;
    If Sender <> nil then WriteLocalBool(INI_DOC, INI_DOC_FINDER, PFinder.Visible);
    RefreshGrid();
end;

{==============================================================================}
{=========================    ACTION: — –€“‹ œŒ»—    ==========================}
{==============================================================================}
procedure TFDOC.AFinderHideExecute(Sender: TObject);
begin
    AFinder.Checked:=false;
    AFinderExecute(Sender);
    DBGrid.SetFocus;
end;


{==============================================================================}
{============================    EFIND: CHANGE   ==============================}
{==============================================================================}
procedure TFDOC.EFindChange(Sender: TObject);
begin
    RefreshGrid();
end;


