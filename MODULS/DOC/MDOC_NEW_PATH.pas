{******************************************************************************}
{********************************   PATH   ************************************}
{******************************************************************************}

{==============================================================================}
{==========================   PATH: ИНИЦИАЛИЗАЦИЯ   ===========================}
{==============================================================================}
procedure TFDOC_NEW.IniPath;
var I: Integer;
begin
    With EPath do begin
       {Отключаем обработчики событий}
       OnChange := EPathChange;

       {Читаем список путей из локальных настроек}
       ReadCBListIni(@EPath, INI_DOC_NEW_PATH);

       {Инициализация}
       Style         := csDropDownList;
       DropDownCount := MAX_PATH_COUNT;

       {Удаляем несуществующие папки}
       For I := Items.Count-1 downto 0 do If not System.SysUtils.DirectoryExists(Items[I]) then Items.Delete(I);

       {Если нет базовой папки, то добавляем ее}
       If Items.IndexOf(PATH_DATA_DOC) = -1 then Items.Insert(0, PATH_DATA_DOC);

       {Восстанавливаем выделение}
       If Items.Count > 0 then ItemIndex := 0;

       {Подключаем обработчики событий}
       OnChange := EPathChange;
    end;
end;


{==============================================================================}
{==========================  СОБЫТИЕ: ON_CHANGE  ==============================}
{==============================================================================}
procedure TFDOC_NEW.EPathChange(Sender: TObject);
begin
    {Корректируем список}
    SetPath(EPath.Text);
    RefreshTree;
end;


{==============================================================================}
{=============================   ACTION: PATH    ==============================}
{==============================================================================}
procedure TFDOC_NEW.APathExecute(Sender: TObject);
var SPath: String;
begin
    {Диалог выбора каталога}
    SPath := EPath.Text;
    If not SelectDirectory('Расположение бланков документов', '\', SPath, [sdNewFolder, sdNewUI, sdShowEdit, sdValidateDir]) then Exit;    //, sdShowShares
    SPath := IncludeTrailingBackslash(Trim(SPath));
    Refresh;

    {Корректируем список}
    SetPath(SPath);

    {Обновляем интерфейс}
    IniPath;
    RefreshTree;
end;


{==============================================================================}
{==================   PATH: УСТАНОВИТЬ И СОХРАНИТЬ PATH    ====================}
{==============================================================================}
procedure TFDOC_NEW.SetPath(const SPath: String);
var IFind: Integer;
begin
    With EPath do begin
       {Режим обновления}
       Items.BeginUpdate;
       try
          {Если нет базовой папки, то добавляем}
          IFind := Items.IndexOf(PATH_DATA_DOC);
          If IFind >= 0 then Items.Delete(IFind);
          Items.Insert(0, PATH_DATA_DOC);

          {Выбранный элемент первый в списке}
          IFind := Items.IndexOf(SPath);
          If IFind >= 0 then Items.Delete(IFind);
          Items.Insert(0, SPath);

          {Обрезаем список}
          For IFind := Items.Count-1 downto MAX_PATH_COUNT do Items.Delete(IFind);
          ItemIndex := 0;

          {Сохраняем список}
          WriteCBListIni(@EPath, INI_DOC_NEW_PATH);
       finally
          Items.EndUpdate;
       end;
    end;
end;
