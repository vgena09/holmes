{******************************************************************************}
{*******************  �������� � ��������-�����������  ************************}
{******************************************************************************}


{==============================================================================}
{===========  ��������� ���������� � ������� ���������� ��������   ============}
{==============================================================================}
procedure TableWriteVar(const PTable: PADOTable; const VarName: String;
                        const Value: Variant);
begin
    {�������������}
    If (PTable=nil) or (VarName='') then Exit;
    If PTable^.Active=false then Exit;

    SetDBFilter(PTable, '['+F_UD_SYS_VAR+']='+QuotedStr(VarName));
    If PTable^.RecordCount=0 then begin
       PTable^.Insert;
       PTable^.FieldByName(F_UD_SYS_VAR).AsString:=VarName;
    end else begin
       PTable^.Edit;
    end;
    PTable^.FieldByName(F_UD_SYS_VAL).AsVariant:=Value;

    {���������� ������ ��������� � ��}
    PTable^.UpdateRecord;
    PTable^.Post;
    SetDBFilter(PTable, '');
end;


{==============================================================================}
{===========   ��������� ������ �������� ���������� �� �������   ==============}
{==============================================================================}
function TableReadVar(const PTable: PADOTable; const VarName: String;
                      const Value0: Variant): Variant;
begin
    {�������������}
    Result:=Value0;
    If (PTable=nil) or (VarName='') then Exit;
    If PTable^.Active=false then Exit;

    SetDBFilter(PTable, '['+F_UD_SYS_VAR+']='+QuotedStr(VarName));
    If PTable^.RecordCount>0 then Result:=PTable^.FieldByName(F_UD_SYS_VAL).AsVariant;
    SetDBFilter(PTable, '');
end;


{==============================================================================}
{====================   ������� �� ������� ����������   =======================}
{==============================================================================}
procedure TableDelVar(const PTable: PADOTable; const VarName: String);
var I: Integer;
begin
    If (PTable=nil) or (VarName='') then Exit;
    If PTable^.Active=false then Exit;

    SetDBFilter(PTable, '['+F_UD_SYS_VAR+']='+QuotedStr(VarName));

    For I:=PTable^.RecordCount downto 1 do PTable^.Delete;
    SetDBFilter(PTable, '');
end;


