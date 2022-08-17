{==============================================================================}
{==========         ��������� � ����������� �������� WORD           ===========}
{==========      (������������ � ��� ����� ����������-������)       ===========}
{==============================================================================}
function TFDECOD_OLE.ScanDoc: Boolean;
var ID_OLE     : Variant;
    SOld, SNew : String;
    ICount     : Integer;
    FErr       : TFont;
begin
    {�������������}
    Result     := false;
    Btn.Action := AStop;
    IS_STOP    := false;
    FErr       := nil;
    Btn.SetFocus;
    try
       {����� ������}
       FErr:=TFont.Create;
       FErr.Name  := 'Times New Roman';
       FErr.Size  := 8;
       FErr.Color := $00FFFF00;

       {������������� OLE}
       SetInfo(0, '�������� ���������');
       AddInfo('��������: '+QDOC_UD.FieldByName(F_UD_DOC_CAPTION).AsString, ICO_INFO);
       BeginScreenUpdate(Self.Handle);
       If not OpenOle(@OLE, ovUIActivate) then begin AddInfo('������ �������� ���������', ICO_ERR); Exit; end;
       OLE.Visible := false;
       EndScreenUpdate(Self.Handle);

       {���������}
       SetInfo(0, '����������');
       ID_OLE         := GetWordApplicationID;
       ID_OLE.Options.PasteAdjustWordSpacing := false;   // ��������� ������: ������� ����� ������ - ��������� - ������ - ��������� - ���������� ��������� ����� ������������� � �������, �.�. ��������� ������� ��� ������������ �����
       If not ZoomWord(ReadLocalInteger(INI_SET, INI_SET_ZOOM_WORD, 100)) then begin AddInfo('������ ��������� ��������', ICO_ERR); Exit; end;
       PBar.Max       := GetCountWordChar(CH1);
       ClearClipboard;

       {������ �� ������ ���������}
       SelectMainDoc;
       If not StartOfDoc then begin AddInfo('������ ��������� �������', ICO_ERR); Exit; end;

       {�������}
       ICount := 1;
       SOld   := FindKeyTextDoc;
       While SOld <> '' do begin
          {��������}
          SetInfo(ICount, '�������: '+SOld); Inc(ICount);

          {���� ������� ���� - �� ��������� ��������}
          Application.ProcessMessages;
          If IS_STOP then begin AddInfo('�������� �������������', ICO_ERR); Exit; end;
          If CmpStr(SOld, '{����}') then begin PasteTextDoc(''); Break; end;

          {��������� �����, � ��� ����� � ��������}
          SNew := FDECOD.DecoderOle(SOld);

          {��������� ������ � ��������� OLE ��� ������ � ������ OLE}
          //If OLE.OleObject.Application.Selection = $00000000 then begin       //VarIsNull VarIsEmpty   VarType varUnknown
          BeginScreenUpdate(Self.Handle);
          OLE.Visible := true;
          If not OpenOle(@OLE, ovUIActivate) then begin AddInfo('������ ���������� �������� ���������', ICO_ERR); Exit; end; //ID_OLE.ActiveWindow
          OLE.Visible := false;
          EndScreenUpdate(Self.Handle);
          //end;

          {���� ������}
          If FDECOD.Err then begin
             AddInfo('������ ��������: '+ SOld+CH_NEW+SNew, ICO_WARN);
             ID_OLE.Selection.Text:='������: [ ]';
             SetFontSelection(FErr, 6);
             ID_OLE.Selection.Start := ID_OLE.Selection.Start+9;
             ID_OLE.Selection.End   := ID_OLE.Selection.End  -1;
             PutStringInClipboard(SNew);
          end;

          {������ �����}
          If not PasteClipbordDoc then begin AddInfo('������ ������ ������', ICO_ERR); Exit; end;
          ClearClipboard;

          {������ �� ������ ���������}
          If not StartOfDoc then begin AddInfo('������ ��������� �������', ICO_ERR); Exit; end;

          {����������� ����������}
          //Btn.SetFocus;
          Application.ProcessMessages;

          {��������� ����}
          SOld := FindKeyTextDoc;
       end;

       {������ � ��������� �� ������ ���������}
       SetInfo(100, '����������� ��������');
       If not StartOfDoc     then begin AddInfo('������ ��������� �������',   ICO_ERR); Exit; end;
       If not ScrollStartDoc then begin AddInfo('������ ��������� ���������', ICO_ERR); Exit; end;

       Result := true;

    finally
       Btn.Action := AClose;
       ClearClipboard;

       ID_OLE := Unassigned;
       If OLE.State <> osEmpty then OLE.Close;

       If FErr <> nil then FErr.Free;

       If Result then begin AddInfo('�������� ���������',   ICO_INFO); SetInfo(100, '�������� ���������');   end
                 else begin AddInfo('��������� ����������', ICO_ERR);  SetInfo(100, '��������� ����������'); end;

       Btn.SetFocus;
    end;
end;


{==============================================================================}
{=============      ��������� � ����������� ����� EXCEL          ==============}
{=============      (����������-������ �� ������������)          ==============}
{==============================================================================}
function TFDECOD_OLE.ScanXls: Boolean;
//var S, S0, S1     : String;
//    PBar, PBarMax : Integer;
//    Len           : Integer;
begin
    {�������������}
    Result := false;
(*
    E0     := Null;

    try
    SetPBar(1);
    If not CreateExcel then begin
       AddInfo('������ �������� MS Excel', ICO_ERR);
       Exit;
    end;

    SetPBar(2);
    If not OpenXls(FName) then begin
       AddInfo('������ �������� ���������: '+FName, ICO_ERR);
       Exit;
    end;

    SetPBar(3);
    PBarMax:=GetCountExcelChar(CH1);
    E0:=GetExcelApplicationID;

    {������������� �����������}
    If not SetHeaderXls(1,'����������� ���������� ��������') then begin
       AddInfo('������ ������� ������: ��������� �������� �����������', ICO_ERR);
       Exit;
    end;
    If not SetFooterXls(2,'��������� ������������� ������������ ������������') then begin
       AddInfo('������ ������� ������: ��������� ������� �����������', ICO_ERR);
       Exit;
    end;

    {������������� ������� �������}
    If FileExists(PATH_0+PATH_IMG_XLS) then begin
       If SetBackGroundPicXls(PATH_0+PATH_IMG_XLS) = false then begin
          AddInfo('������ ��������� ����: ������������� ���������', ICO_ERR);
          Exit;
       end;
    end;

    SetPBar(5);
    PBar:=0;

    S:=FindKeyTextXls;
    While S<>'' do begin
       {��������}
       LInfo2.Caption:=S;
       LInfo2.Refresh;

       {���� ������� ���� - �� ��������� ��������}
       If AnsiUpperCase(S)='{����}' then begin
          WriteActiveCells('');
          Break;
       end;

       S1:=S;
       {������� ����� ������ ������ ������}
       S0:=CutSlovoChar(S1, 1, ' ');
       Delete(S0, 1, 1);
       If IsNumericStr(CutSpace(S0))=true then begin
          Len:=StrToInt(CutSpace(S0));
          Delete(S1, 2, Length(S0)+1);
       end else Len:=1;

       {���������� ������}
       S1:=FFUD.DecoderFull(S1, false, [FFUD.DopDecoderVar, FFUD.DopDecoderTables],
                                       [@T_WORK_VAR,        @T_UD_DECOD]);

       {���� ������}
       If FFUD.IsErrorDecod=true then begin
          {��������}
          AddInfo('������ ��������: '+S1, LInfo2.Caption, ICO_WARN);

          //{������ ���� ������}
          //W0.Selection.Text:='������: [ ]';
          //SetFontSelection(FErr, 6);
          //W0.Selection.Start := W0.Selection.Start+9;
          //W0.Selection.End   := W0.Selection.End  -1;
       end;

       {�������� ������}
       If FindAndPasteTextXls(S, S1, Len) = false then begin
          AddInfo('������ ��������� ���������: ���� ������ ������', ICO_ERR);
          Exit;
       end;
       S:=FindKeyTextXls;

       Inc(PBar);
       SetPBar(5);
    end;
    If not StartOfXls then begin
       AddInfo('������ ���������������� �������: ���� ������������� ��������� �������', ICO_ERR);
       Exit;
    end;

    {��������� ��������}
    If not SaveXls then begin
       AddInfo('������ ���������� ���������', ICO_ERR);
       Exit;
    end;

    SetPBar(100);
    Result:=true;
    
    finally
       If not Result then AddInfo('��������� ����������', ICO_WARN);
    end;
*)
end;


