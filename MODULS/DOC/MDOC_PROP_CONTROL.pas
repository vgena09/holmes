{******************************************************************************}
{***************************   КОНТРОЛЬ СРОКА   *******************************}
{******************************************************************************}

procedure TFDOC_PROP.ControlIni;
begin
    With EControl do begin
       Format    := 'dd MMMM yyyy г., HH час. mm мин.';
       OnChange  := EControlChange;
       OnKeyDown := EKeyDown;
    end;
    With CBControl do begin
       OnClick   := CBControlClick;
       OnKeyDown := CBControlKeyDown;
    end;
end;


{==============================================================================}
{========================   CBCONTROL: ON_CHANGE   ============================}
{==============================================================================}
procedure TFDOC_PROP.CBControlClick(Sender: TObject);
begin
    EControl.Enabled := CBControl.Checked;
    EControlChange(Sender);
end;

procedure TFDOC_PROP.CBControlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    CBControlClick(Sender);
end;


{==============================================================================}
{=========================   ECONTROL: ON_CHANGE   ============================}
{==============================================================================}
procedure TFDOC_PROP.EControlChange(Sender: TObject);
var Years, Months, Days, Hours: Integer;
    SVal, SInfo: String;
begin
    {Инициализация}
    LControlOld.Caption    := '';
    LControlOld.Font.Color := clWindowText;
    SInfo                  := '';
    SVal                   := ControlVal;

    {Сохраняем изменения}
    If Sender <> nil then ControlWrite;

    {Сколько времени осталось}
    If SVal <> '' then begin
       DateTimeDiff0(Now, StrToDatetime(SVal), Hours, Days, Months, Years);
       If (Years < 0) or (Months < 0) or (Days < 0) or (Hours < 0) then begin
           SInfo                  := 'срок истек';
           LControlOld.Font.Color := clRed;
       end else begin
          If Years  > 0 then SInfo := SInfo + IntToStr(Years)  + ' г. ';
          If Months > 0 then SInfo := SInfo + IntToStr(Months) + ' м. ';
          If Days   > 0 then SInfo := SInfo + IntToStr(Days)   + ' д. ';
          If Hours  > 0 then SInfo := SInfo + IntToStr(Hours)  + ' ч. ';
          If SInfo = '' then SInfo := 'сейчас ';
          Delete(SInfo, Length(SInfo), 1);
       end;
    end;
    LControlOld.Caption := SInfo;
end;


{==============================================================================}
{============================   ЧТЕНИЕ / ЗАПИСЬ   =============================}
{==============================================================================}
procedure TFDOC_PROP.ControlWrite;
begin
    If Q.Active then begin
       With Q do begin
          Edit;
          FieldByName(F_UD_DOC_CONTROL).AsString := ControlVal;
          UpdateRecord;
          Post;
       end;
    end;
    RefreshTable(@FFMAIN.BUD.TDOC);
end;

procedure TFDOC_PROP.ControlRead;
var EventEdit, EventCB: TNotifyEvent;
begin
    EventEdit         := EControl .OnChange;  EControl .OnChange := nil;
    EventCB           := CBControl.OnClick;   CBControl.OnClick  := nil;

    If Q.FieldByName(F_UD_DOC_CONTROL).AsString = '' then begin
       CBControl.Checked := false;
       EControl.DateTime := Now;
    end else begin
       CBControl.Checked := true;
       EControl.DateTime := Q.FieldByName(F_UD_DOC_CONTROL).AsDateTime;
    end;

    CBControl.OnClick := EventCB;
    EControl.OnChange := EventEdit;
    CBControlClick(nil);
end;

function TFDOC_PROP.ControlVal: String;
begin
    If CBControl.Checked then Result := DateTimeToStr(EControl.DateTime)
                         else Result := '';
end;
