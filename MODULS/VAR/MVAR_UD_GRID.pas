{******************************************************************************}
{********************************   GRID   ************************************}
{******************************************************************************}

{==============================================================================}
{==========================   GRID: ИНИЦИАЛИЗАЦИЯ   ===========================}
{==============================================================================}
procedure TFVAR_UD.IniGrid;
var ICol: Integer;
begin
    With DBGrid do begin
        ReadOnly   := true;
        PopupMenu  := PMenu;
        DataSource := DS;
        Options    := Options + [dgRowSelect, dgAlwaysShowSelection]
                              - [dgEditing, dgIndicator, dgMultiSelect];
        //If ParamMSelect then Options := Options - [dgColumnResize];  // Из-за первого check-столбца - некрасиво
        Columns.Clear;
        For ICol := Low(GRID_COL) to High(GRID_COL) do begin
           With Columns.Add do FieldName := GRID_COL[ICol];
        end;
        Columns[0].Visible := ParamMSelect;
        OnTitleClick       := DBGridTitleClick;
        OnDblClick         := DBGridDblClick;
        OnKeyDown          := DBGridKeyDown;
        OnDrawColumnCell   := DBGridDrawColumnCell;
        OnMouseEnter       := DBGridMouseEnter;
        If ParamMSelect then OnMouseUp := DBGridMouseUp
                        else OnMouseUp := nil;
    end;
    With TGridAccess(DBGrid) do begin
       Options    := Options - [goColMoving];
       ScrollBars := ssNone;
       OnResize   := DBGridResize;
    end;
    DBGridResize(nil);
end;


{==============================================================================}
{===========================   GRID: ОБНОВЛЕНИЕ   =============================}
{==============================================================================}
procedure TFVAR_UD.RefreshGrid;
var ICol, I: Integer;
    IsASC  : Boolean;
    SWhere, SOrder, S : String;
begin
    {Инициализация}
    ICol  := ReadLocalInteger(INI_VAR_UD+'.'+ParamTable, INI_VAR_UD_COL_SORT,     Low(GRID_COL)+1);
    IsASC := ReadLocalBool   (INI_VAR_UD+'.'+ParamTable, INI_VAR_UD_COL_SORT_ASC, true);
    If ICol = ICOL_CHECK then ICol := ICOL_1;

    {Подключаем столбцы}
    SOrder  := '';
    For I := Low(GRID_COL)+1 to High(GRID_COL) do begin
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
    DBGrid.Columns[ICOL_CHECK].Title.Caption := '';

    {Дополнительная сортировка по первому столбцу}
    If ICol <> ICOL_1 then begin
       S := '['+GRID_COL[ICOL_1]+'] ASC';
       If SOrder = '' then SOrder := ' ORDER BY '+S
                      else SOrder := SOrder + ', '+S;
    end;

    {Подключаем фильтр}
    If ParamFilter <> '' then SWhere := ' WHERE ' + ParamFilter
                         else SWhere := '';


    {Собираем запрос}
    S := 'SELECT * FROM ['+ParamTable+']'+SWhere+SOrder+';';
    Q.DisableControls;
    try
       Q.AfterScroll := nil;
       If Q.Active then Q.Close;
       Q.SQL.Text := S;
       Q.Open;
    finally
       Q.EnableControls;
    end;

    {Восстанавливаем выбор}
    LoadCheck;
    If Not ParamMSelect then Q.AfterScroll := QAfterScroll;

    {Доступность Action}
    EnablAction;
end;


{==============================================================================}
{===========================   GRID: DBL_CLICK   ==============================}
{==============================================================================}
procedure TFVAR_UD.DBGridDblClick(Sender: TObject);
var F: TForm;
begin
    case ITable of
       LTAB_UD_PPERSON: begin
          F := TFVAR_UD_EDIT_PPERSON.Create(Self);
          try     TFVAR_UD_EDIT_PPERSON(F).Execute(@Q);
          finally F.Free; end;
       end;
       LTAB_UD_LPERSON: begin
          F := TFVAR_UD_EDIT_LPERSON.Create(Self);
          try     TFVAR_UD_EDIT_LPERSON(F).Execute(@Q);
          finally F.Free; end;
       end;
       LTAB_UD_DPERSON: begin
          F := TFVAR_UD_EDIT_DPERSON.Create(Self);
          try     TFVAR_UD_EDIT_DPERSON(F).Execute(@Q);
          finally F.Free; end;
       end;
       LTAB_UD_OBJECT: begin
          F := TFVAR_UD_EDIT_OBJECT.Create(Self);
          try     TFVAR_UD_EDIT_OBJECT(F).Execute(@Q);
          finally F.Free; end;
       end;
    end;
    //RefreshGrid;
end;


{==============================================================================}
{============================   GRID: KEY_DOWN   ==============================}
{==============================================================================}
procedure TFVAR_UD.DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    13: {Enter} DBGridDblClick(Sender);
    end;
end;


{==============================================================================}
{===========================   GRID: SET_FOCUS   ==============================}
{==============================================================================}
procedure TFVAR_UD.DBGridMouseEnter(Sender: TObject);
begin
    If not DBGrid.Focused then DBGrid.SetFocus;
end;



{******************************************************************************}
{*************************   GRID: ИЗМЕНЕНИЕ ВЫБОРА   *************************}
{******************************************************************************}

{==============================================================================}
{=========================     НЕ ДЛЯ МУЛЬТИВЫБОРА    =========================}
{==============================================================================}
procedure TFVAR_UD.QAfterScroll(DataSet: TDataSet);
var S: String;
begin
    If DataSet.RecordCount > 0 then begin
       S := DataSet.FieldByName(F_COUNTER).AsString;
       If S <> '' then LCheck.Text := ParamTable+'.'+S
                  else LCheck.Text := '';
    end else LCheck.Text := '';
    SaveCheck;
end;

{==============================================================================}
{=======================     ДЛЯ МУЛЬТИВЫБОРА     =============================}
{==============================================================================}
procedure TFVAR_UD.DBGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Cell  : TGridCoord;
    Ind   : Integer;
    SFind : String;
begin
    Cell := DBGrid.MouseCoord(X, Y);
    If Cell.Y = 0 then Exit;
    If Cell.X = ICOL_CHECK then begin
       SFind  := ParamTable+'.'+TDBGrid(Sender).DataSource.DataSet.FieldByName(F_COUNTER).AsString;
       Ind    := LCheck.IndexOf(SFind);
       If Ind > -1 then LCheck.Delete(Ind)
                   else LCheck.Add(SFind); //.Insert(0, SFind);
       SaveCheck;
       DBGrid.Repaint;
    end;
end;


{==============================================================================}
{=========================   GRID: SAVE/LOAD CHECK   ==========================}
{==============================================================================}
procedure TFVAR_UD.SaveCheck;
begin
    If PQVAR = nil then Exit;
    With PQVAR^ do begin
       Edit;
       FieldByName(F_VAR_VAL_STR).AsString := LCheck.Text;
       UpdateRecord;
       Post;
    end;
end;

procedure TFVAR_UD.LoadCheck;
begin
    If PQVAR = nil then Exit;
    LCheck.Text := PQVAR^.FieldByName(F_VAR_VAL_STR).AsString;
    If PQVAR^.RecordCount = 0 then begin LCheck.Clear; Exit; end;

    {Выделение по умолчанию}
    If (Not ParamMSelect) and (LCheck.Count = 0) and (Q.RecordCount > 0) then begin
       LCheck.Text := ParamTable+'.'+Q.FieldByName(F_COUNTER).AsString;
       SaveCheck;
    end;

    {Устанавливаем выделение}
    If LCheck.Count > 0 then PosDataSet(@Q, LCheck[0]);
end;


{==============================================================================}
{========================   GRID: РАСКРАСКА ЯЧЕЕК   ===========================}
{==============================================================================}
procedure TFVAR_UD.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
                   DataCol: Integer; Column: TColumn; State: TGridDrawState);

    function IsChecked: Boolean;
    var SFind : String;
    begin
        SFind  := ParamTable+'.'+TDBGrid(Sender).DataSource.DataSet.FieldByName(F_COUNTER).AsString;
        Result := (LCheck.IndexOf(SFind) > -1);
    end;

    procedure SetCheckBox(const Checked: boolean);
    var DrawFlags: Integer;
    begin
        DrawFlags := DFCS_BUTTONCHECK;// or DFCS_ADJUSTRECT;
        If Checked then DrawFlags := DrawFlags or DFCS_CHECKED;
        DrawFrameControl(TDBGrid(Sender).Canvas.Handle, Rect, DFC_BUTTON, DrawFlags);
    end;

begin
    With TDBGrid(Sender) do begin
       If (DataSource.DataSet.RecNo mod 2 = 1) then Canvas.Brush.Color := FFMAIN.COLOR_ODD
                                               else Canvas.Brush.Color := clWindow;
       If gdSelected IN State                  then Canvas.Brush.Color := FFMAIN.COLOR_SEL;
       Canvas.FillRect(Rect);
       If DataSource.DataSet.RecordCount = 0 then Exit;
       Case DataCol of
          ICOL_CHECK:  begin SetCheckBox(IsChecked); end;
          ICOL_1:      begin
             Canvas.TextOut(Rect.Left+24, Rect.Top+2, Column.Field.Text);
             FFMAIN.ImgSys16.Draw(Canvas, Rect.Left+2, Rect.Top, GetIcoElementUD(@TDBGrid(Sender).DataSource.DataSet, ITable));
          end;
          else begin
             If Column.Field <> nil then Canvas.TextOut(Rect.Left+3, Rect.Top+2, Column.Field.Text);
          end;
       end;
    end;
end;


{==============================================================================}
{======================   GRID: НАЖАТИЕ НА ЗАГОЛОВОК   ========================}
{==============================================================================}
procedure TFVAR_UD.DBGridTitleClick(Column: TColumn);
var ICol  : Integer;
    IsASC : Boolean;
begin
    {Инициализация}
    If Column.Index = ICOL_CHECK then Exit;
    ICol  := ReadLocalInteger(INI_VAR_UD+'.'+ParamTable, INI_VAR_UD_COL_SORT,     -1);
    IsASC := ReadLocalBool   (INI_VAR_UD+'.'+ParamTable, INI_VAR_UD_COL_SORT_ASC, true);
    {Направление сортировки}
    If ICol = Column.Index then IsASC := not IsASC    //меняем направление сортировки
                           else IsASC := true;
    WriteLocalInteger(INI_VAR_UD+'.'+ParamTable, INI_VAR_UD_COL_SORT,     Column.Index);
    WriteLocalBool   (INI_VAR_UD+'.'+ParamTable, INI_VAR_UD_COL_SORT_ASC, IsASC);
    RefreshGrid;
end;


{==============================================================================}
{===========================   GRID: ON_RESIZE    =============================}
{==============================================================================}
procedure TFVAR_UD.DBGridResize(Sender: TObject);
begin
    With DBGrid do begin
       Columns[0].Width := COLCHECK_WIDTH;
       Columns[2].Width := ClientWidth div 2;
       Columns[1].Width := ClientWidth - Columns[0].Width - Columns[2].Width - (3 - 1) * 1;
    end;
end;




