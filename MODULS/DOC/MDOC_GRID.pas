{******************************************************************************}
{********************************   GRID   ************************************}
{******************************************************************************}

{==============================================================================}
{==========================   GRID: ИНИЦИАЛИЗАЦИЯ   ===========================}
{==============================================================================}
procedure TFDOC.IniGrid;
var ICol: Integer;
begin
    With DBGrid do begin
        ReadOnly   := true;
        PopupMenu  := PMenu;
        DataSource := DS;
        Options    := Options + [dgRowSelect, dgAlwaysShowSelection]
                              - [dgEditing, dgIndicator, dgMultiSelect];

        Columns.Clear;
        For ICol := Low(GRID_COL) to High(GRID_COL) do begin
           With Columns.Add do begin
              FieldName := GRID_COL[ICol];
              Width     := 100;
           end;
        end;
        OnTitleClick     := DBGridTitleClick;
        OnDblClick       := DBGridDblClick;
        OnKeyDown        := DBGridKeyDown;
        OnDrawColumnCell := DBGridDrawColumnCell;
        OnMouseEnter     := DBGridMouseEnter;
    end;
    With TGridAccess(DBGrid) do begin
       Options    := Options - [goColMoving];
       ScrollBars := ssNone;
       OnResize   := DBGridResize;
    end;
end;


{==============================================================================}
{===========================   GRID: ОБНОВЛЕНИЕ   =============================}
{==============================================================================}
procedure TFDOC.RefreshGrid;
var ICol, I: Integer;
    IsASC  : Boolean;
    SFind, SWhere, SOrder, S : String;
begin
    {Инициализация}
    ICol  := ReadLocalInteger(INI_DOC, INI_DOC_COL_SORT,     GRID_COL_DATE);
    IsASC := ReadLocalBool   (INI_DOC, INI_DOC_COL_SORT_ASC, true);

    {Подключаем столбцы}
    SOrder  := '';
    For I := Low(GRID_COL) to High(GRID_COL) do begin
        If I = ICol then begin
           If IsASC then begin
             DBGrid.Columns[I].Title.Caption := CH_DOWN+GRID_COL[I];
             SOrder := ' ORDER BY ['+GRID_COL[I]+'] ASC';
           end else begin
             DBGrid.Columns[I].Title.Caption := CH_UP+GRID_COL[I];
             SOrder := ' ORDER BY ['+GRID_COL[I]+'] DESC';
           end;
        end else begin
           DBGrid.Columns[I].Title.Caption := GRID_COL[I];
        end;
    end;

    {Дополнительная сортировка по дате}
    If ICol <> GRID_COL_DATE then begin
       S := '['+GRID_COL[GRID_COL_DATE]+'] ASC';
       If SOrder = '' then SOrder := ' ORDER BY '+S
                      else SOrder := SOrder + ', '+S;
    end;

    {Подключаем фильтр}
    SWhere := '';
    SFind  := Trim(EFind.Text);
    If PFinder.Visible and (SFind <> '') then begin
       S := Trim(TokChar(SFind, ' '));
       While S <> '' do begin
           SWhere := SWhere + 'AND (['+GRID_COL[GRID_COL_CAPTION]+'] LIKE '+QuotedStr('%'+S+'%')+')';
           S := Trim(TokChar(SFind, ' '));
       end;
       Delete(SWhere, 1, 4);
       SWhere := ' WHERE ' + SWhere;
    end;

    {Собираем запрос}
    S := 'SELECT * FROM ['+T_UD_DOC+']'+SWhere+SOrder+';';
    Q.DisableControls;
    try
       Q.AfterScroll := nil;
       If Q.Active then Q.Close;
       Q.SQL.Text := S;
       Q.Open;
       Q.Fields[IND_UD_DOC_CONTROL].OnGetText := QGetText;
       FFMAIN.StatusBar.Panels[STATUS_DOC].Text := 'Документов: '+IntToStr(Q.RecordCount);
    finally
       Q.EnableControls;
    end;

    {Восстанавливаем текущую запись}
    LoadSel;
    Q.AfterScroll := QAfterScroll;

    {Доступность Action}
    EnablAction;
end;


{==============================================================================}
{=========================   SQL: ИЗМЕНЕНИЕ ПОЗИЦИИ   =========================}
{==============================================================================}
procedure TFDOC.QAfterScroll(DataSet: TDataSet);
begin
    SaveSel(-1);
    EnablAction;
end;


{==============================================================================}
{===========================   GRID: DBL_CLICK   ==============================}
{==============================================================================}
procedure TFDOC.DBGridDblClick(Sender: TObject);
var P   : TPoint;
    Pos : TGridCoord;
begin
    {Реакция только при нахождении курсора в области выбора}
    If not GetCursorPos(P) then Exit;
    P   := DBGrid.ScreenToClient(P);
    Pos := DBGrid.MouseCoord(P.X, P.Y);
    If Pos.Y >= 0 then AOpen.Execute;
end;


{==============================================================================}
{============================   GRID: KEY_DOWN   ==============================}
{==============================================================================}
procedure TFDOC.DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    13: {Enter} DBGridDblClick(Sender);
    32: {Space} AOk.Execute;
    46: {Del}   ADel.Execute;
    end;
end;


{==============================================================================}
{======================   GRID: НАЖАТИЕ НА ЗАГОЛОВОК   ========================}
{==============================================================================}
procedure TFDOC.DBGridTitleClick(Column: TColumn);
var ICol  : Integer;
    IsASC : Boolean;
begin
    {Инициализация}
    ICol  := ReadLocalInteger(INI_DOC, INI_DOC_COL_SORT,       -1);
    IsASC := ReadLocalBool   (INI_DOC, INI_DOC_COL_SORT_ASC, true);
    {Направление сортировки}
    If ICol = Column.Index then IsASC := not IsASC    //меняем направление сортировки
                           else IsASC := true;
    WriteLocalInteger(INI_DOC, INI_DOC_COL_SORT,     Column.Index);
    WriteLocalBool   (INI_DOC, INI_DOC_COL_SORT_ASC, IsASC);
    RefreshGrid;
end;


{==============================================================================}
{========================   GRID: РАСКРАСКА ЯЧЕЕК   ===========================}
{==============================================================================}
procedure TFDOC.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
                DataCol: Integer; Column: TColumn; State: TGridDrawState);
var IsOk, IsBlank : Boolean;

    function SelIco: Integer;
    begin
       If IsOk then begin
          If IsBlank then Result := ICO_DOC_YES1 else Result := ICO_DOC_YES;
       end else begin
          If IsBlank then Result := ICO_DOC_NO1  else Result := ICO_DOC_NO;
       end;
    end;

begin
    With TDBGrid(Sender) do begin
       If DataSource.DataSet.RecordCount = 0 then Exit;
       IsOk    :=     DataSource.DataSet.Fields[IND_UD_DOC_OK]  .AsBoolean;
       IsBlank := not DataSource.DataSet.Fields[IND_UD_DOC_AUTO].AsBoolean;
       If (DataSource.DataSet.RecNo mod 2 = 1) then Canvas.Brush.Color := FFMAIN.COLOR_ODD;
       If gdSelected IN State                  then Canvas.Brush.Color := FFMAIN.COLOR_SEL;
       If not IsOK then Canvas.Font.Color := clRed;
       If not IsDocFirstCopy(DataSource.DataSet.Fields[IND_UD_DOC_COUNTER].AsInteger) then Canvas.Font.Color := clBlue;
       If DataCol=0 then begin
          Canvas.FillRect(Rect);
          Canvas.TextOut(Rect.Left+24, Rect.Top+2, Column.Field.Text);
          FFMAIN.ImgSys16.Draw(Canvas, Rect.Left+2, Rect.Top, SelIco);
       end else begin
          Canvas.FillRect(Rect);
          Canvas.TextOut(Rect.Left+3, Rect.Top+2, Column.Field.Text);
       end;
    end;
end;


{==============================================================================}
{===========================   GRID: ON_RESIZE    =============================}
{==============================================================================}
procedure TFDOC.DBGridResize(Sender: TObject);
begin
    With DBGrid do begin
       Columns[0].Width := ClientWidth - Columns[1].Width - Columns[2].Width -
                           (Length(GRID_COL) - 1) * 1;
    end;
end;


{==============================================================================}
{===========================   GRID: SET_FOCUS   ==============================}
{==============================================================================}
procedure TFDOC.DBGridMouseEnter(Sender: TObject);
begin
    If not DBGrid.Focused then DBGrid.SetFocus;
end;


{==============================================================================}
{========================   GRID: ПОДМЕНА ЗНАЧЕНИЯ   ==========================}
{==============================================================================}
procedure TFDOC.QGetText(Sender: TField; var Text: String; DispalayText: Boolean);
var Hours, Days, Months, Years: Integer;
begin
    If Sender = nil  then Exit;
    If Sender.IsNull then Exit;
    DateTimeDiff0(Now, Sender.AsDateTime, Hours, Days, Months, Years);
    If (Years < 0) or (Months < 0) or (Days < 0) or (Hours < 0) then begin
        Text := 'Срок истек';
    end else begin
       Text := '';
       If Years  > 0 then Text := Text + IntToStr(Years)  + ' г. ';
       If Months > 0 then Text := Text + IntToStr(Months) + ' м. ';
       If Days   > 0 then Text := Text + IntToStr(Days)   + ' д. ';
       If Hours  > 0 then Text := Text + IntToStr(Hours)  + ' ч. ';
       If Text  = '' then Text := 'Сейчас ';
       Delete(Text, Length(Text), 1);
    end;
end;


{==============================================================================}
{=========================   GRID: SAVE/LOAD SELECT   =========================}
{==============================================================================}
procedure TFDOC.SaveSel(const ICounter: Integer);
var ID: Integer;
begin
    If ICounter < 0 then ID := Q.FieldByName(F_COUNTER).AsInteger
                    else ID := ICounter;
    TableWriteVar(@FFMAIN.BUD.TSYS, F_UD_SYS_DOC_SEL, ID);
end;

procedure TFDOC.LoadSel;
var ID: Integer;
begin
    ID := TableReadVar(@FFMAIN.BUD.TSYS, F_UD_SYS_DOC_SEL, Q.FieldByName(F_COUNTER).AsInteger);
    Q.Locate(F_COUNTER, ID, []);
end;

