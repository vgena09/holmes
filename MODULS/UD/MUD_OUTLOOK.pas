{******************************************************************************}
{******************************   OUTLOOK   ***********************************}
{******************************************************************************}


{==============================================================================}
{==============  ACTION: СИНХРОНИЗИРОВАТЬ КОНТРОЛЬ С OUTLOOK  =================}
{==============================================================================}
procedure TFUD.AOutlookExecute(Sender: TObject);
const PREF_DELO    = 'Дело № ';
      PREF_DOC     = 'Документ № ';
      PREF_SEPARAT = ', ';
      MSG_SYNC     = 'Синхронизация: ';
      MSG_ERROR    = 'Ошибка синхронизации';
      MY_CATEGORY  = 'Следствие';
      SHOW_WAIT    = 100;    // Число документов + записей Outlook, при которых появляется окно ожидания

var MAPI, Folder, Item : OLEVariant;
    IsItem, IsControl  : Boolean;
    T         : TADOTable;
    S, ID_UD  : String;
    I, ICount : Integer;
    IsWait    : Boolean;

    function GetNomerUD: String;
    var Q: TADOQuery;
    begin
        Result := '';
        Q := TADOQuery.Create(Self);
        With Q do begin
           try
              Connection := FFMAIN.BUD.BD;
              SQL.Text := 'SELECT ['+F_VAR_VAL_STR+'] FROM ['+T_UD_VAR+'] WHERE ['+F_VAR_NAME+']='+QuotedStr(F_VAR_NAME_NUD)+';';
              Open;
              If RecordCount = 1 then Result := FieldByName(F_VAR_VAL_STR).AsString;
              If Active then Close;
           finally
              Free;
           end;
        end;
    end;

    procedure FindItem(const IDDoc: String);
    var Item_ : OLEVariant;
        I_    : Integer;
    begin
        Item := Null;
        For I_:=1 to Folder.Items.Count do begin
           Item_ := Folder.Items.Item(I_);
           If not CmpStr(Item_.Location,   PREF_DELO+ID_UD+PREF_SEPARAT+PREF_DOC+IDDoc) then Continue;
           Item := Item_;
           Break;
        end;
    end;

    {Синхронизация + удаление Item при необходимости}
    function Sync: Boolean;
    var DatRec, DatItem, DatControl: TDateTime;
    begin
        {Инициализация}
        Result := true;
        try
           DatRec := T.FieldByName(F_UD_DOC_MODIFY ).AsDateTime;
           If Item.Location = '' then DatItem := 0
                                 else DatItem := Item.LastModificationTime;

           {Если последним менялся документ, то обновляем Outlook}
           If DatRec > DatItem then begin
              DatControl       := T.FieldByName(F_UD_DOC_CONTROL).AsDateTime;
              If DatControl <> 0 then begin
                 S := T.FieldByName(F_UD_DOC_CAPTION).AsString;
                 FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := MSG_SYNC+S;
                 Item.Location    := PREF_DELO+ID_UD+PREF_SEPARAT+PREF_DOC+T.FieldByName(F_COUNTER).AsString; // Место
                 If FFMAIN.OUT_VER >= 7 then Item.Categories  := MY_CATEGORY;                                 // Категория
                 Item.Subject     := S;                                         // Тема
                 //Item.Body        := T.FieldByName(F_UD_DOC_HINT).AsString;   // Содержание-примечание
                 Item.Start       := DatControl;                                // Начало встречи
                 Item.End         := IncHour(DatControl);                       // Конец встречи
                 Item.AllDayEvent := (TimeOf(DatControl) = 0);                  // Целый день если не указано время
                 Item.BusyStatus  := olTentative;                               // Занятость     olBusy
                 Item.Importance  := olImportanceHigh;                          // Важность
                 Item.Sensitivity := olPrivate;                                 // Частное
                 Item.ReminderSet := true;                                      // Напомнить
                 Item.ReminderOverrideDefault    := true;                       // Звук напоминания по умолчанию
                 Item.ReminderMinutesBeforeStart := 60 * 24 * 3;                // Напомнить за
                 Item.Save;
                 With T do begin
                    Edit;
                    FieldByName(F_UD_DOC_MODIFY ).AsDateTime := Item.LastModificationTime;
                    UpdateRecord;
                    Post;
                 end;
                 RefreshTable(@FFMAIN.BUD.TDOC);
              end else begin
                 Item.Delete;
              end;
              Exit;
           end;

           {Если последним менялся Outlook, то обновляем документ}
           If DatRec < DatItem then begin
              DatControl := Item.Start;
              If Item.AllDayEvent     then DatControl := Trunc(DatControl);
              If not Item.ReminderSet then DatControl := 0;
              S := Item.Subject;
              FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := MSG_SYNC+S;
              With T do begin
                 Edit;
                 FieldByName(F_UD_DOC_CAPTION).AsString := S;                   // Тема
                 //FieldByName(F_UD_DOC_HINT   ).AsString := Item.Body;         // Содержание-примечание
                 If DatControl <> 0 then FieldByName(F_UD_DOC_CONTROL).AsDateTime := DatControl // Начало встречи
                                    else FieldByName(F_UD_DOC_CONTROL).Clear;
                 FieldByName(F_UD_DOC_MODIFY ).AsDateTime := Item.LastModificationTime;
                 UpdateRecord;
                 Post;
              end;
              RefreshTable(@FFMAIN.BUD.TDOC);
              If not Item.ReminderSet then Item.Delete;
           end;

        except
           Result := false;
        end;
    end;

begin
    {Инициализация}
    IsWait := false;
    ID_UD  := GetNomerUD;
    T      := LikeTable(@FFMAIN.BUD.TDOC);
    try
       FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := 'Подключение к Outlook ...';
       If Not ConnectOutlook then begin ErrMsg('Ошибка подключения к Outlook!'); Exit; end;
       MAPI   := App.GetNameSpace('MAPI');
       Folder := MAPI.GetDefaultFolder(olFolderCalendar);
       ICount := Folder.Items.Count;

       {Информатор}
       SetDBFilter(@T, '');
       IsWait := (T.RecordCount + ICount) > SHOW_WAIT;
       If IsWait then BeginWaitWnd('Синхронизация', 'Синхронизация Outlook ...', true);
       FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := 'Синхронизация Outlook ...';

       {Создаем категорию}
       If FFMAIN.OUT_VER >= 7 then CreateCategory(MY_CATEGORY, olCategoryColorDarkBlue);

       {Просматриваем Outlook с конца}
       For I:=ICount downto 1 do begin
          If IsWait and (ICount > 50) then ChangeWaitWnd('Просмотр записей Outlook ...', 10 + (I * 60 div ICount));
          Item := Folder.Items.Item(I);
          S    := Item.Location;
          If not CmpStr(Copy(S, 1, Length(PREF_DELO+ID_UD)), PREF_DELO+ID_UD) then Continue;
          Delete(S, 1, Length(PREF_DELO+ID_UD+PREF_SEPARAT));
          If not CmpStr(Copy(S, 1, Length(PREF_DOC)), PREF_DOC) then Continue;
          Delete(S, 1, Length(PREF_DOC));
          If not IsIntegerStr(S) then Continue;

          SetDBFilter(@T, '['+F_COUNTER+']='+S);
          If T.RecordCount = 1 then begin
             If not Sync then begin
                FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := MSG_ERROR;
                FFMAIN.IconMsg('ОШИБКА!', MSG_ERROR, bfError);
                Exit;
             end;
          end else Item.Delete;
       end;

       {Просматриваем документы}
       SetDBFilter(@T, '');
       ICount := T.RecordCount;
       T.First;
       While not T.Eof do begin
          If IsWait then ChangeWaitWnd('Просмотр документов ...', 70+(T.RecNo * 30 div ICount));
          FindItem(T.FieldByName(F_COUNTER).AsString);
          IsItem    := not VarIsNull(Item);
          IsControl := T.FieldByName(F_UD_DOC_CONTROL).AsString <> '';

          If IsControl and (not IsItem) then begin Item := MAPI.GetDefaultFolder(olFolderCalendar).Items.Add; IsItem :=true; end;
          If IsItem  then If not Sync then begin
             FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := MSG_ERROR;
             FFMAIN.IconMsg('ОШИБКА!', MSG_ERROR, bfError);
             Exit;
          end;

          T.Next;
       end;

       FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := 'Синхронизация контрольных сроков с Outlook завершена';
       finally
          If T.Active then T.Close; T.Free;
          DisconnectOutlook;
          If IsWait then EndWaitWnd;
       end;

       {Обновляем дерево если принудительная синхронизация}
       If Sender <> nil then RefreshTreeUD;
end;


{==============================================================================}
{===========================  ВЫЗОВ СИНХРОНИЗАЦИИ  ============================}
{==============================================================================}
procedure TFUD.SyncControl;
begin
    If ReadLocalBool(INI_SET, INI_SET_OUTLOOK, false) and FFMAIN.BUD.BD.Connected then AOutlookExecute(nil);
end;

