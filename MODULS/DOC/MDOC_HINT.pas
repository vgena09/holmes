{******************************************************************************}
{********************************   HINT   ************************************}
{******************************************************************************}


{==============================================================================}
{==========================   HINT: »Õ»÷»¿À»«¿÷»ﬂ   ===========================}
{==============================================================================}
procedure TFDOC.IniHint;
begin
    AHint.AutoCheck := true;
    AHint.Checked   := ReadLocalBool(INI_DOC, INI_DOC_HINT_VISIBLE, false);
    AHintExecute(nil);
end;


{==============================================================================}
{=======================   ACTION: — –€“‹/œŒ ¿«¿“‹   ==========================}
{==============================================================================}
procedure TFDOC.AHintExecute(Sender: TObject);
begin
    If Sender <> nil then WriteLocalBool(INI_DOC, INI_DOC_HINT_VISIBLE, AHint.Checked);
    If AHint.Checked then begin
       If FHINT <> nil then Exit;
       {—ÓÁ‰‡ÂÏ ÙÓÏÛ}
       FHINT := TFORM.Create(FFMAIN);
       With FHINT do begin
          Parent      := FFMAIN;
          Caption     := 'œËÏÂ˜‡ÌËÂ Í ÚÂÍÛ˘ÂÏÛ ‰ÓÍÛÏÂÌÚÛ';
          BorderStyle := bsSizeToolWin;
          Position    := poDesigned;
          Height      := FFMAIN.ClientHeight Div 6; Top  := FFMAIN.StatusBar.Top - Height;
          Width       := FFMAIN.ClientWidth  Div 4; Left := FFMAIN.ClientWidth   - Width;
          LoadFormIni(FHINT, [fspPosition]);
          OnClose     := HintClose;

          {—ÓÁ‰‡ÂÏ ÔÓÎÂ ‚‚Ó‰‡}
          EHINT := TDBRichEdit.Create(FHINT);
          With EHINT do begin
             Parent     := FHINT;
             Align      := alClient;
             ScrollBars := ssVertical;
             WordWrap   := true;
             Font.Size  := 10;
             Font.Color := clGray;
             DataSource := DS;
             DataField  := F_UD_DOC_HINT;
             Enabled    := DS.DataSet.RecordCount > 0;
          end;
          Show;
       end;
    end else begin
       If FHINT = nil then Exit;
       With FHINT do begin
          SaveFormIni(FHINT, [fspPosition]);
          OnClose := nil;
          Close;
          Free;
       end;
       EHINT := nil;
       FHINT := nil;
    end;
end;


{==============================================================================}
{=======================    FHINT: — –€“‹ œ–»Ã≈◊¿Õ»≈   ========================}
{==============================================================================}
procedure TFDOC.HintClose(Sender: TObject; var Action: TCloseAction);
begin
    AHint.Checked:=false;
    AHintExecute(Sender);
end;




