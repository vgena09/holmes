{******************************************************************************}
{********************************   GRID   ************************************}
{******************************************************************************}

{==============================================================================}
{==========================   GRID: ÈÍÈÖÈÀËÈÇÀÖÈß   ===========================}
{==============================================================================}
procedure TFVAR.IniGrid;
begin
    With DBGrid do begin
        Width      := ReadLocalInteger(INI_VAR, INI_VAR_WIDTH, Width);
        ReadOnly   := true;
        DataSource := DS;
        Options    := Options + [dgRowSelect, dgAlwaysShowSelection]
                              - [dgEditing, dgIndicator, dgMultiSelect, dgTitleClick];
        Columns.Clear;
        Columns.Add;
        Columns[0].Title.Caption := 'Ïåðåìåííàÿ';
        Columns[0].Field := PQVAR^.FieldByName(F_VAR_CAPTION);
        Columns.Add;
        Columns[1].Title.Caption := 'Çíà÷åíèå';
        Columns[1].Field := PQVAR^.FieldByName(F_VAR_VAL_STR);
        OnDrawColumnCell := DBGridDrawColumnCell;
        OnKeyDown        := DBGridKeyDown;
        OnKeyDown        := DBGridKeyDown;
    end;
    With TGridAccess(DBGrid) do begin
       Options    := Options - [goColMoving];
       ScrollBars := ssNone;
       OnResize   := DBGridResize;
    end;

    {Âîññòàíàâëèâàåì òåêóùóþ çàïèñü}
    LoadSel;
    PQVAR^.BeforeScroll := ADOQVARBeforeScroll;
    PQVAR^.AfterScroll  := ADOQVARAfterScroll;
    ADOQVARAfterScroll(TDataSet(PQVAR^));
end;


{==============================================================================}
{========================   GRID: ÐÀÑÊÐÀÑÊÀ ß×ÅÅÊ   ===========================}
{==============================================================================}
procedure TFVAR.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
                DataCol: Integer; Column: TColumn; State: TGridDrawState);
var IsOk : Boolean;

    {Èêîíêà}
    function SelIco: Integer;
    begin
       If IsOk then Result := ICO_YES else Result := ICO_NO;
    end;

    {Âîçìîæíîñòü ñîçäàíèÿ äîêóìåíòà}
    function IsReady: Boolean;
    var I: Integer;
    begin
        Result := true;
        For I:=Low(LIST_OK) to High(LIST_OK) do begin
           If not LIST_OK[I] then begin
              Result := false;
              Break;
           end;
        end;
    end;

begin
    With TDBGrid(Sender) do begin
       IsOk := ValidateValue(@TDBGrid(Sender).DataSource.DataSet);
       LIST_OK[DataSource.DataSet.RecNo-1] := IsOk;

       If (DataSource.DataSet.RecNo mod 2 = 1) then Canvas.Brush.Color := FFMAIN.COLOR_ODD;
       If gdSelected IN State                  then Canvas.Brush.Color := FFMAIN.COLOR_SEL;
       If not IsOK then Canvas.Font.Color := clRed;
       If DataCol=0 then begin
          Canvas.FillRect(Rect);
          Canvas.TextOut(Rect.Left+24, Rect.Top+2, Column.Field.Text);
          FFMAIN.ImgSys16.Draw(Canvas, Rect.Left+2, Rect.Top, SelIco);
       end else begin
          Canvas.FillRect(Rect);
          Canvas.TextOut(Rect.Left+3, Rect.Top+2, Column.Field.Text);
       end;
    end;
    AOk.Enabled := IsReady;
end;


{==============================================================================}
{===========================   GRID: ON_RESIZE    =============================}
{==============================================================================}
procedure TFVAR.DBGridResize(Sender: TObject);
begin
    WriteLocalInteger(INI_VAR, INI_VAR_WIDTH, DBGrid.Width);
    With DBGrid do begin
       Columns[1].Width := ClientWidth div 2;
       Columns[0].Width := ClientWidth - Columns[1].Width - (Length(GRID_COL) - 1) * 1;
    end;
end;


{==============================================================================}
{========================   GRID: ÏÎÄÌÅÍÀ ÇÍÀ×ÅÍÈß   ==========================}
{==============================================================================}
procedure TFVAR.QGetText(Sender: TField; var Text: String; DispalayText: Boolean);
var SList : TStringList;
begin
    If Sender = nil then Exit;
    Text  := '';
    SList := TStringList.Create;
    try
       SList.Text := Sender.AsString;
       If SList.Count > 0 then Text := SList[0];
       If VerifyID(Text)  then Text := IDToTxt(@FFMAIN.BUD, Text, []) + iff(SList.Count > 1, ' ...', '');
    finally
       SList.Free;
    end;
end;


{==============================================================================}
{============================   GRID: KEY_DOWN   ==============================}
{==============================================================================}
procedure TFVAR.DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    27: {ESC} AClose.Execute;
    end;
end;


{==============================================================================}
{===========================   GRID: SET_FOCUS   ==============================}
{==============================================================================}
//procedure TFVAR.DBGridMouseEnter(Sender: TObject);
//begin
//    If not DBGrid.Focused then DBGrid.SetFocus;
//end;


{==============================================================================}
{=========================   GRID: SAVE/LOAD SELECT   =========================}
{==============================================================================}
procedure TFVAR.SaveSel;
begin
    TableWriteVar(PTSAV, F_UD_SYS_VAR_SEL+'.'+SDOC_COUNTER, PQVAR^.FieldByName(F_COUNTER).AsString);
end;

procedure TFVAR.LoadSel;
var ID: Integer;
begin
    ID := TableReadVar(PTSAV, F_UD_SYS_VAR_SEL+'.'+SDOC_COUNTER, PQVAR^.FieldByName(F_COUNTER).AsInteger);
    try PQVAR^.Locate(F_COUNTER, ID, []); except end;
end;


