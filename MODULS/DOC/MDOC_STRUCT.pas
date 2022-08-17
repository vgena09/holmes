{******************************************************************************}
{*******************************   STRUCT   ***********************************}
{******************************************************************************}


{==============================================================================}
{=========================   STRUCT: �������������   ==========================}
{==============================================================================}
procedure TFDOC.IniStruct;
begin
    PSTRUCT.Width          := ReadLocalInteger(INI_UD, INI_DOC_STRUCT_WIDTH, PStruct.Width);
    PStruct.OnResize       := PStructResize;

    {��������� ��������}
    FFSTRUCT := TFSTRUCT(LoadSubForm(PStruct, TFSTRUCT, true));
end;


{==============================================================================}
{========================   STRUCT: ���������������   =========================}
{==============================================================================}
procedure TFDOC.FreeStruct;
begin
    {��������� ��������}
    LoadSubForm(PStruct, nil, true);
    FFSTRUCT := nil;
end;


{==============================================================================}
{=========================    PSTRUCT: ON_RESIZE   ============================}
{==============================================================================}
procedure TFDOC.PStructResize(Sender: TObject);
begin
    If PStruct.Width < 200 then PStruct.Width := 200;
    WriteLocalInteger(INI_UD, INI_DOC_STRUCT_WIDTH, PStruct.Width);
end;

