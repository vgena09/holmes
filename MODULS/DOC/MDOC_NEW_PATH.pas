{******************************************************************************}
{********************************   PATH   ************************************}
{******************************************************************************}

{==============================================================================}
{==========================   PATH: �������������   ===========================}
{==============================================================================}
procedure TFDOC_NEW.IniPath;
var I: Integer;
begin
    With EPath do begin
       {��������� ����������� �������}
       OnChange := EPathChange;

       {������ ������ ����� �� ��������� ��������}
       ReadCBListIni(@EPath, INI_DOC_NEW_PATH);

       {�������������}
       Style         := csDropDownList;
       DropDownCount := MAX_PATH_COUNT;

       {������� �������������� �����}
       For I := Items.Count-1 downto 0 do If not System.SysUtils.DirectoryExists(Items[I]) then Items.Delete(I);

       {���� ��� ������� �����, �� ��������� ��}
       If Items.IndexOf(PATH_DATA_DOC) = -1 then Items.Insert(0, PATH_DATA_DOC);

       {��������������� ���������}
       If Items.Count > 0 then ItemIndex := 0;

       {���������� ����������� �������}
       OnChange := EPathChange;
    end;
end;


{==============================================================================}
{==========================  �������: ON_CHANGE  ==============================}
{==============================================================================}
procedure TFDOC_NEW.EPathChange(Sender: TObject);
begin
    {������������ ������}
    SetPath(EPath.Text);
    RefreshTree;
end;


{==============================================================================}
{=============================   ACTION: PATH    ==============================}
{==============================================================================}
procedure TFDOC_NEW.APathExecute(Sender: TObject);
var SPath: String;
begin
    {������ ������ ��������}
    SPath := EPath.Text;
    If not SelectDirectory('������������ ������� ����������', '\', SPath, [sdNewFolder, sdNewUI, sdShowEdit, sdValidateDir]) then Exit;    //, sdShowShares
    SPath := IncludeTrailingBackslash(Trim(SPath));
    Refresh;

    {������������ ������}
    SetPath(SPath);

    {��������� ���������}
    IniPath;
    RefreshTree;
end;


{==============================================================================}
{==================   PATH: ���������� � ��������� PATH    ====================}
{==============================================================================}
procedure TFDOC_NEW.SetPath(const SPath: String);
var IFind: Integer;
begin
    With EPath do begin
       {����� ����������}
       Items.BeginUpdate;
       try
          {���� ��� ������� �����, �� ���������}
          IFind := Items.IndexOf(PATH_DATA_DOC);
          If IFind >= 0 then Items.Delete(IFind);
          Items.Insert(0, PATH_DATA_DOC);

          {��������� ������� ������ � ������}
          IFind := Items.IndexOf(SPath);
          If IFind >= 0 then Items.Delete(IFind);
          Items.Insert(0, SPath);

          {�������� ������}
          For IFind := Items.Count-1 downto MAX_PATH_COUNT do Items.Delete(IFind);
          ItemIndex := 0;

          {��������� ������}
          WriteCBListIni(@EPath, INI_DOC_NEW_PATH);
       finally
          Items.EndUpdate;
       end;
    end;
end;
