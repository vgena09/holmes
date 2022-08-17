{******************************************************************************}
{********************************   GRID   ************************************}
{******************************************************************************}

{==============================================================================}
{==========================   GRID: »Õ»÷»¿À»«¿÷»ﬂ   ===========================}
{==============================================================================}
procedure TFVAR_REST.IniGrid;
begin
    With Grid do begin
       PopupMenu        := PMenu;
       Options          := Options + [goRowSelect, goDrawFocusSelected]
                                   - [goFixedRowClick, goRowMoving, goColMoving, goRangeSelect];
       FixedCols        := 0;
       FixedRows        := 1;
       ColCount         := 2;
       RowCount         := 11;
       DefaultRowHeight := 19;
       ScrollBars       := ssNone;

       OnDblClick       := GridDblClick;
       OnKeyDown        := GridKeyDown;
       OnDrawCell       := GridDrawCell;
       OnMouseEnter     := GridMouseEnter;
       Cells[0, 0]      := LField[Low(LField)];
       Cells[1, 0]      := LField[Low(LField)+1];
    end;
    FormResize(nil);
end;


{==============================================================================}
{=========================   GRID: SAVE/LOAD CHECK   ==========================}
{==============================================================================}
procedure TFVAR_REST.RefreshVal;
begin
    SaveVal;
    LoadVal;
end;

procedure TFVAR_REST.SaveVal;
begin
    With PQVAR^ do begin
       Edit;
       FieldByName(F_VAR_VAL_STR).AsString := LVal.Text;
       UpdateRecord;
       Post;
    end;

    {¬˚‰ÂÎÂÌËÂ}
    If PTSAV <> nil then  TableWriteVar(PTSAV, IDVar+': '+F_UD_SYS_REST_SEL, Grid.Row);
end;

procedure TFVAR_REST.LoadVal;
var I, Count : Integer;
begin
    try
       {»ÌËˆË‡ÎËÁ‡ˆËˇ}
       LVal.Text      := PQVAR^.FieldByName(F_VAR_VAL_STR).AsString;
       Count          := LVal.Count Div 3;
       Grid.RowCount  := Count + 1;
       If Grid.RowCount > 1 then Grid.FixedRows := 1
                            else Exit;

       {«Ì‡˜ÂÌËˇ}
       For I := 0 to Count - 1 do begin
          Grid.Cells[0, I + Grid.FixedRows] := LVal[I * 3 + 0];
          Grid.Cells[1, I + Grid.FixedRows] := LVal[I * 3 + 1];
       end;

       {¬˚‰ÂÎÂÌËÂ}
       If PTSAV <> nil then begin
          I := TableReadVar(PTSAV, IDVar+': '+F_UD_SYS_REST_SEL, Grid.Row);
          If I > (Grid.RowCount - 1) then I := (Grid.RowCount - 1);
          If I > Grid.FixedRows then Grid.Row := I;
       end;
    finally
       EnablAction;
    end;
end;


{==============================================================================}
{===========================   GRID: DBL_CLICK   ==============================}
{==============================================================================}
procedure TFVAR_REST.GridDblClick(Sender: TObject);
begin
    AEdit.Execute;
end;


{==============================================================================}
{============================   GRID: KEY_DOWN   ==============================}
{==============================================================================}
procedure TFVAR_REST.GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    13: {Enter} GridDblClick(Sender);
    38: {UP}    If GetKeyState(VK_LCONTROL) then begin EnablAction; AUp  .Execute; end;
    40: {Down}  If GetKeyState(VK_LCONTROL) then begin EnablAction; ADown.Execute; end;
    end;
end;


{==============================================================================}
{========================   GRID: –¿— –¿— ¿ ﬂ◊≈≈    ===========================}
{==============================================================================}
procedure TFVAR_REST.GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
    With TStringGrid(Sender) do begin
       If gdFixed IN State then Exit;
       If ARow > 0 then begin
          If (ARow mod 2 = 1)    then Canvas.Brush.Color := FFMAIN.COLOR_ODD
                                 else Canvas.Brush.Color := clWindow;
          If gdSelected IN State then Canvas.Brush.Color := FFMAIN.COLOR_SEL;

          Rect.Left := Rect.Left - 4;
          Canvas.FillRect(Rect);

          If ACol = 0 then begin
              FFMAIN.ImgSys16.Draw(Canvas, Rect.Left+2, Rect.Top+2, ICO_DPERSON_3);
              Canvas.TextOut(Rect.Left+24, Rect.Top +2, Cells[ACol, ARow]);
          end else begin
              Canvas.TextOut(Rect.Left+2,  Rect.Top +2, Cells[ACol, ARow]);
          end;
       end;
    end;
end;


{==============================================================================}
{===========================   GRID: SET_FOCUS   ==============================}
{==============================================================================}
procedure TFVAR_REST.GridMouseEnter(Sender: TObject);
begin
    If not Grid.Focused then Grid.SetFocus;
end;


{==============================================================================}
{===========================   GRID: ON_RESIZE    =============================}
{==============================================================================}
procedure TFVAR_REST.FormResize(Sender: TObject);
begin
    With Grid do begin
       ColWidths[1] := ClientWidth div 2;
       ColWidths[0] := ClientWidth - ColWidths[1] - (2 - 1) * 1;
    end;
end;
