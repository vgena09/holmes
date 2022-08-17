{==============================================================================}
{========================    LBOX: ИНИЦИАЛИЗАЦИЯ    ===========================}
{==============================================================================}
procedure TFVAR_SELECT.LBoxIni;
begin
    With LBox do begin
       Style        := lbOwnerDrawFixed;
       Sorted       := false;
       ItemHeight   := 19;
       OnClickCheck := LBoxClickCheck;
       OnDblClick   := LBoxDblClick;
       OnDrawItem   := LBoxDrawItem;
       OnClick      := LBoxClick;
       OnKeyDown    := LBoxKeyDown;
    end;
end;

{==============================================================================}
{=======================    LBOX: ON_CLICK_CHECK    ===========================}
{==============================================================================}
procedure TFVAR_SELECT.LBoxClickCheck(Sender: TObject);
begin
    If ParamMSelect then LBoxSave;
end;


{==============================================================================}
{=========================    LBOX: ON_KEY_DOWN    ============================}
{==============================================================================}
procedure TFVAR_SELECT.LBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    If not ParamMSelect then LBoxSave;
end;


{==============================================================================}
{=========================    LBOX: ON_CLICK    ===============================}
{==============================================================================}
procedure TFVAR_SELECT.LBoxClick(Sender: TObject);
begin
    If not ParamMSelect then LBoxSave;
end;


{==============================================================================}
{=========================    LBOX: ON_DBLCLICK    ============================}
{==============================================================================}
procedure TFVAR_SELECT.LBoxDblClick(Sender: TObject);
var P   : TPoint;
    Ind : Integer;
begin
    If not ParamMSelect then Exit;
    {Реакция только при нахождении курсора в области выбора}
    Ind := -1;
    If Sender <> nil then begin
       If GetCursorPos(P) = false then Exit;
       P   := LBox.ScreenToClient(P);
       Ind := LBox.ItemAtPos(P, true);
    end;
    If Ind=-1 then Exit;

    {Меняем Checked}
    LBox.Checked[Ind] := not LBox.Checked[Ind];
    LBoxSave;
end;


{==============================================================================}
{======================          LBOX: ПЕРЕРИСОВКА       ======================}
{==============================================================================}
procedure TFVAR_SELECT.LBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
const OffsetCheck = 16;
begin
    With TCheckListBox(Control) do begin
       If not ParamMSelect then Rect.Left := Rect.Left - OffsetCheck;
       If (Index mod 2 = 1)   then Canvas.Brush.Color := FFMAIN.COLOR_ODD
                              else Canvas.Brush.Color := clWindow;
    end;
    If odSelected IN State then TCheckListBox(Control).Canvas.Brush.Color := FFMAIN.COLOR_SEL;
    With TCheckListBox(Control) do begin
       Canvas.Font.Color := clBlack;
       Canvas.FillRect(Rect);
       Canvas.TextOut(Rect.Left+4, Rect.Top + 2, Items[Index]);
    end;
    If not ParamMSelect then Rect.Left := Rect.Left + OffsetCheck;
    If odFocused  IN State then DrawFocusRect(TCheckListBox(Control).Canvas.Handle, Rect);
end;

