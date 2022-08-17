{******************************************************************************}
{******************************   OUTLOOK   ***********************************}
{******************************************************************************}


{==============================================================================}
{==============  ACTION: ���������������� �������� � OUTLOOK  =================}
{==============================================================================}
procedure TFUD.AOutlookExecute(Sender: TObject);
const PREF_DELO    = '���� � ';
      PREF_DOC     = '�������� � ';
      PREF_SEPARAT = ', ';
      MSG_SYNC     = '�������������: ';
      MSG_ERROR    = '������ �������������';
      MY_CATEGORY  = '���������';
      SHOW_WAIT    = 100;    // ����� ���������� + ������� Outlook, ��� ������� ���������� ���� ��������

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

    {������������� + �������� Item ��� �������������}
    function Sync: Boolean;
    var DatRec, DatItem, DatControl: TDateTime;
    begin
        {�������������}
        Result := true;
        try
           DatRec := T.FieldByName(F_UD_DOC_MODIFY ).AsDateTime;
           If Item.Location = '' then DatItem := 0
                                 else DatItem := Item.LastModificationTime;

           {���� ��������� ������� ��������, �� ��������� Outlook}
           If DatRec > DatItem then begin
              DatControl       := T.FieldByName(F_UD_DOC_CONTROL).AsDateTime;
              If DatControl <> 0 then begin
                 S := T.FieldByName(F_UD_DOC_CAPTION).AsString;
                 FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := MSG_SYNC+S;
                 Item.Location    := PREF_DELO+ID_UD+PREF_SEPARAT+PREF_DOC+T.FieldByName(F_COUNTER).AsString; // �����
                 If FFMAIN.OUT_VER >= 7 then Item.Categories  := MY_CATEGORY;                                 // ���������
                 Item.Subject     := S;                                         // ����
                 //Item.Body        := T.FieldByName(F_UD_DOC_HINT).AsString;   // ����������-����������
                 Item.Start       := DatControl;                                // ������ �������
                 Item.End         := IncHour(DatControl);                       // ����� �������
                 Item.AllDayEvent := (TimeOf(DatControl) = 0);                  // ����� ���� ���� �� ������� �����
                 Item.BusyStatus  := olTentative;                               // ���������     olBusy
                 Item.Importance  := olImportanceHigh;                          // ��������
                 Item.Sensitivity := olPrivate;                                 // �������
                 Item.ReminderSet := true;                                      // ���������
                 Item.ReminderOverrideDefault    := true;                       // ���� ����������� �� ���������
                 Item.ReminderMinutesBeforeStart := 60 * 24 * 3;                // ��������� ��
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

           {���� ��������� ������� Outlook, �� ��������� ��������}
           If DatRec < DatItem then begin
              DatControl := Item.Start;
              If Item.AllDayEvent     then DatControl := Trunc(DatControl);
              If not Item.ReminderSet then DatControl := 0;
              S := Item.Subject;
              FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := MSG_SYNC+S;
              With T do begin
                 Edit;
                 FieldByName(F_UD_DOC_CAPTION).AsString := S;                   // ����
                 //FieldByName(F_UD_DOC_HINT   ).AsString := Item.Body;         // ����������-����������
                 If DatControl <> 0 then FieldByName(F_UD_DOC_CONTROL).AsDateTime := DatControl // ������ �������
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
    {�������������}
    IsWait := false;
    ID_UD  := GetNomerUD;
    T      := LikeTable(@FFMAIN.BUD.TDOC);
    try
       FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := '����������� � Outlook ...';
       If Not ConnectOutlook then begin ErrMsg('������ ����������� � Outlook!'); Exit; end;
       MAPI   := App.GetNameSpace('MAPI');
       Folder := MAPI.GetDefaultFolder(olFolderCalendar);
       ICount := Folder.Items.Count;

       {����������}
       SetDBFilter(@T, '');
       IsWait := (T.RecordCount + ICount) > SHOW_WAIT;
       If IsWait then BeginWaitWnd('�������������', '������������� Outlook ...', true);
       FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := '������������� Outlook ...';

       {������� ���������}
       If FFMAIN.OUT_VER >= 7 then CreateCategory(MY_CATEGORY, olCategoryColorDarkBlue);

       {������������� Outlook � �����}
       For I:=ICount downto 1 do begin
          If IsWait and (ICount > 50) then ChangeWaitWnd('�������� ������� Outlook ...', 10 + (I * 60 div ICount));
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
                FFMAIN.IconMsg('������!', MSG_ERROR, bfError);
                Exit;
             end;
          end else Item.Delete;
       end;

       {������������� ���������}
       SetDBFilter(@T, '');
       ICount := T.RecordCount;
       T.First;
       While not T.Eof do begin
          If IsWait then ChangeWaitWnd('�������� ���������� ...', 70+(T.RecNo * 30 div ICount));
          FindItem(T.FieldByName(F_COUNTER).AsString);
          IsItem    := not VarIsNull(Item);
          IsControl := T.FieldByName(F_UD_DOC_CONTROL).AsString <> '';

          If IsControl and (not IsItem) then begin Item := MAPI.GetDefaultFolder(olFolderCalendar).Items.Add; IsItem :=true; end;
          If IsItem  then If not Sync then begin
             FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := MSG_ERROR;
             FFMAIN.IconMsg('������!', MSG_ERROR, bfError);
             Exit;
          end;

          T.Next;
       end;

       FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := '������������� ����������� ������ � Outlook ���������';
       finally
          If T.Active then T.Close; T.Free;
          DisconnectOutlook;
          If IsWait then EndWaitWnd;
       end;

       {��������� ������ ���� �������������� �������������}
       If Sender <> nil then RefreshTreeUD;
end;


{==============================================================================}
{===========================  ����� �������������  ============================}
{==============================================================================}
procedure TFUD.SyncControl;
begin
    If ReadLocalBool(INI_SET, INI_SET_OUTLOOK, false) and FFMAIN.BUD.BD.Connected then AOutlookExecute(nil);
end;

