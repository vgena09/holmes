{******************************************************************************}
{*****************  � � � � � � � �    �    � � � � � � �  ********************}
{******************************************************************************}

{==============================================================================}
{=============           �������   ������  ��������              ==============}
{==============================================================================}
{=============   Kod = �������                                   ==============}
{=============   LDecod, PLTab - ���-�� ������ ��� '�����'       ==============}
{==============================================================================}
function TDECOD.DopDecoderBase(var DecStr: String; const Kod: String): Boolean;
label Ex, Ex0;
var Cmd : String;
    Prm : TArrayStr;
begin
    {�������������}
    Result:=false;
    If Kod='' then Exit;

    {��������� ��� [Kod] �� ������� [Cmd] � ��������� [Prm]}
    SeparatKod(Kod, Cmd, Prm);

    {�������-����������}
    If not IsStrInArray(Cmd, ['#',
                             '**',
                             '����',
                             '����',
                             '���� �������',
                             '��������� � �����',
                             '����� ����������',
                             '����������� � ������',
                             '����������� � ��������������� ������']) then Prm:=UpperArrayStr(Prm);

    {**************************************************************************}
    {****************  FunDecoder_Text_Macro:  � � � � � � �   ****************}
    {**************************************************************************}
    If Cmd = '������ ����������'                    then begin DecStr:=FMacroParticipantsList;        Goto Ex; end;
    If Cmd = '����� ����������'                     then begin DecStr:=FMacroParticipantsRights(Prm); Goto Ex; end;
    If Cmd = '������� ����������'                   then begin DecStr:=FMacroParticipantsSign;        Goto Ex; end;
    If Cmd = '����������� � ������'                 then begin DecStr:=FMacroMediaInform(Prm);        Goto Ex; end;
    If Cmd = '����������� � ��������������� ������' then begin DecStr:=FMacroMediaShow(Prm);          Goto Ex; end;


    {**************************************************************************}
    {*****************  FUN_COMMON:  � � � � �   � � � � � � �  ***************}
    {**************************************************************************}
    If Cmd = '������'      then begin DecStr:=FKodChr(Prm);                     Goto Ex; end;
    If Cmd = '/N'          then begin DecStr:=CH_NEW        ;                  Goto Ex; end;
    If Cmd = '/A'          then begin DecStr:=Chr(10);                          Goto Ex; end;


    {**************************************************************************}
    {************  FunDecoder_Text:  � � � � � �   �   � � � � � � �   ********}
    {**************************************************************************}
    If Cmd = '����'        then begin DecStr:=MyCharUpper(DecStr, Prm);         Goto Ex; end;


    {**************************************************************************}
    {*** ����������� 3 ��������� **********************************************}
    {**************************************************************************}
    If Length(Prm)>2  then begin
       If Cmd = '�������'   then begin DecStr:=FindFromSanctionArticles(DecStr, Prm);                         Goto Ex; end;
    end;

    
    {**************************************************************************}
    {*** ����������� 2 ��������� **********************************************}
    {**************************************************************************}
    If Length(Prm)>1  then begin
       {�������: ����������� ������ � ����������� �� ����� ������������}
       If Cmd = '#'         then begin DecStr:=SelTxtFromArticl(DecStr, Prm[0], Prm[1]);                      Goto Ex; end;
       {�������: ����� � ����������� �� ����}
       If Cmd = '**'        then begin DecStr:=FSexPrm(DecStr, Prm);                                          Goto Ex; end;
       {�������: ����� �����}
       If Cmd = '�����'     then begin DecStr:=FFindPrm(Prm);                                                 Goto Ex; end;

       {***********************************************************************}
       {*** �������: 1-� �������� - ����� *************************************}
       {***********************************************************************}
       {�������: �������� �� ����� �����}
       If IsIntegerStr(Prm[0]) then begin
          If Cmd = '�����'  then begin DecStr:=CutSlovo(DecStr, StrToInt(Prm[0]), AnsiLowerCase(Prm[1]));  Goto Ex; end;
       end;
    end;

    {**************************************************************************}
    {*** ���������� 1 �������� ************************************************}
    {**************************************************************************}
    If Length(Prm)>0  then begin
       If Length(Prm[0])>0 then begin
          {�������: ������������� ������ ��� ���������� ���������}
          If Cmd = '!'  then begin DecStr:=FSetStr(Kod);                                                      Goto Ex; end;
          {�������: �������� �� ��� �������� � �������� �������}
          If Cmd = '��������' then begin
             If String(Prm[0][1])='-' then begin DecStr:=FIO_Initialy(DecStr, false);                         Goto Ex; end;
          end;
          {�������: �������� ���}
          If Cmd = '����� ���'    then begin DecStr:=PadegFIO(Prm[0][1], DecStr);                             Goto Ex; end;
          {�������: �������� ����� ����� ������ � �� � �������}
//          If Cmd = '����� ������' then begin DecStr:=PadegDLG(Prm[0][1], DecStr);                           Goto Ex; end;
          {�������: �������� ����� �������������}
          If Cmd = '����� ����'   then begin DecStr:=PadegAUTO(Prm[0][1], DecStr);                            Goto Ex; end;
          //{�������: �������� ����� ������� �� ���������}  ��������� �� �������������
          //If Cmd = '����� �������'then begin DecStr:=PadegSTATUS(@FFMAIN.BSET_GLOBAL.TLSTATUS, Prm[0][1], DecStr); Goto Ex; end;
       end;
       {***********************************************************************}
       {*** �������: 1-� �������� - ����� *************************************}
       {***********************************************************************}
       If IsIntegerStr(Prm[0]) then begin
          {�������: �������� �� ����� �����}
          If Cmd = '�����'  then begin DecStr:=CutSlovo (DecStr, StrToInt(Prm[0]), ' ');                    Goto Ex; end;
          If Cmd = '������' then begin DecStr:=FCutLines(DecStr, StrToInt(Prm[0]));                           Goto Ex; end;
       end;
    end;

    {**************************************************************************}
    {*** ��� ���������� *******************************************************}
    {**************************************************************************}
    If Length(Prm)=0 then begin
//       If Cmd = '�������� �������' then begin DecStr:=SetPredlog(DecStr);        Goto Ex; end;
    end;
                                     

    {��������� �������: �������������� ����}
    If Cmd = '����'              then begin DecStr:=FMsgDlg(DecStr, Prm);         Goto Ex; end;
    {��������� �������: ���� ������}
    If Cmd = '����'              then begin DecStr:=FInpDlg(DecStr, Prm);         Goto Ex; end;


    {�������: �������� �� ��� ��������}
    If Cmd = '��������'          then begin DecStr:=FIO_Initialy(DecStr, true);   Goto Ex; end;
    {�������: �������� ���}
    If Cmd = '����� ���'         then begin DecStr:=PadegFIO('', DecStr);         Goto Ex; end;
    {�������: �������� ����� ����� ������ � �� � �������}
//    If Cmd = '����� ������'      then begin DecStr:=PadegDLG('', DecStr);         Goto Ex; end;
    {�������: �������� ����� �������������}
    If Cmd = '����� ����'        then begin DecStr:=PadegAUTO('', DecStr);        Goto Ex; end;
    //{�������: �������� ����� ������� �� ���������}  ��������� �� �������������
    //If Cmd = '����� �������'     then begin DecStr:=PadegSTATUS(@FFMAIN.BSET_GLOBAL.TLSTATUS, '', DecStr);      Goto Ex; end;


    {**************************************************************************}
    {************  FunDecoder_DateTime:   � � � �   �   � � � � �  ************}
    {**************************************************************************}
    If Cmd = '���������'         then begin DecStr:=FDateTimeNow(Prm);            Goto Ex; end;
    If Cmd = '����'              then begin DecStr:=FDateNow(Prm);                Goto Ex; end;
    If Cmd = '�����'             then begin DecStr:=FTimeNow(Prm);                Goto Ex; end;

    If Cmd = '��������� � �����' then begin DecStr:=SDateTimeToStr(DecStr, Prm);  Goto Ex; end;  //2-� �������� - ����� � ����� ����
    If Cmd = '���� � �����'      then begin DecStr:=SDateToStr(DecStr, '');       Goto Ex; end;  //2-� �������� - ����� � �����
    If Cmd = '����� � �����'     then begin DecStr:=STimeToStr(DecStr);           Goto Ex; end;
    If Cmd = '���'               then begin DecStr:=CutYearStr(DecStr);           Goto Ex; end;
    If Cmd = '����'              then begin DecStr:=CutHourStr(DecStr);           Goto Ex; end;
    If Cmd = '������'            then begin DecStr:=CutMinutStr(DecStr);          Goto Ex; end;


    Goto Ex0;

Ex: {������������ ���������}
    Result:=true;

Ex0:{����������� ������}
    SetLength(Prm,  0);                          
end;


{==============================================================================}
{================     �������: �������� �� ������ ������     ==================}
{==============================================================================}
function TDECOD.FCutLines(const DecStr: String; const Num: Integer): String;
var SList: TStringList;
begin
    {�������������}
    Result:='';
    If Num<1 then Exit;
    SList:=TStringList.Create;
    try
       SList.Text:=DecStr;
       If SList.Count>=Num then Result:=SList[Num-1];
    finally
       SList.Free;
    end;
end;



{==============================================================================}
{==============            �������: ��������� ������           ================}
{==============================================================================}
function TDECOD.FSetStr(const Kod: String): String;
begin
    {�������������}
    Result := Kod;

    {������� !( � ) }
    Delete(Result, 1, 2);
    Delete(Result, Length(Result), 1);

    {�������� ��������� �������}
    If Length(Result)>1 then begin
       If (Result[1]=CH_KAV) and (Result[Length(Result)]=CH_KAV) then begin
          Delete(Result, 1,              1);
          Delete(Result, Length(Result), 1);
       end;
    end;
end;



{==============================================================================}
{==============             �������: ����� ������              ================}
{==============================================================================}
{==============  Prm[0]   - ��������������� ������             ================}
{==============  Prm[1..] - ������� ������ ��� ����� ��������  ================}
{==============  �����    - TRUE, FALSE                        ================}
{==============================================================================}
function TDECOD.FFindPrm(const Prm: array of String): String;
var S : String;
    I : Integer;
begin
    {�������������}
    Result := 'FALSE';
    S:=Trim(Prm[0]);

    {����������� ���������}
    For I:=1 to Length(Prm)-1 do begin
       If (FindStr(Trim(Prm[I]), S)>0) or ((Prm[I]='') and (S='')) then begin
          Result:='TRUE';
          Break;
       end;
    end;
end;


{==============================================================================}
{==============     �������: ����� � ����������� �� ����     ==================}
{==============================================================================}
function TDECOD.FSexPrm(const DecStr: String; const Prm: array of String): String;
var SexMen, SexFam: String;
begin
    {�������������}
    Result:='';
    If Length(Prm)>0 then SexMen  := Prm[Low(Prm)]   else SexMen  := '';
    If Length(Prm)>1 then SexFam  := Prm[Low(Prm)+1] else SexFam  := '';

    {�������� ����� � ����������� �� ����}
    If GetSexFIO(DecStr) then Result:=SexMen else Result:=SexFam;
end;


{==============================================================================}
{==============             �������: ���� ���������          ==================}
{==============================================================================}
{==============  [1-� ��������]: ��� �������                 ==================}
{==============  [2-� ��������]: ����� ���������             ==================}
{==============  [3-� ��������]: ����������� �������� ��     ==================}
{==============  [4-� ��������]: ����������� �������� ���    ==================}
{==============================================================================}
function TDECOD.FMsgDlg(const DecStr: String; const Prm: array of String): String;
var DlgType : TMsgDlgType;
    Buttons : TMsgDlgButtons;
    Msg     : String;
    Res     : Word;
begin
    {�������������}                  
    Result  := '';

    {���������� ��� �������}
    DlgType := mtInformation;
    If Length(Prm)>0 then begin
       If Prm[0]='' then DlgType := mtInformation else
       Case Prm[0][1] of
       '1': DlgType := mtWarning;
       '2': DlgType := mtError;
       '3': DlgType := mtInformation;
       '4': DlgType := mtConfirmation;
       '5': DlgType := mtCustom;
       end;
    end;

    {���������� ���������}
    Msg:=DecStr;
    If Length(Prm)>1 then Msg:=Prm[1];

    {���������� ������}
    Buttons := [mbOk];
    If Length(Prm)>3 then Buttons := [mbYes, mbNo];

    {���� �������}
    Res:=MessageDlg(Msg, DlgType, Buttons, 0);

    If Length(Prm)>3 then begin
       If Res=mrYes then Result:=Prm[2]
                    else Result:=Prm[3];
    end;
end;


{==============================================================================}
{==============           �������: ���� ����� ������         ==================}
{==============================================================================}
{==============  [1-� ��������]: ��������� ����              ==================}
{==============  [2-� ��������]: ����� ���������             ==================}
{==============  [3-� ��������]: ����� �� ���������          ==================}
{==============================================================================}
function TDECOD.FInpDlg(const DecStr: String; const Prm: array of String): String;
//var Dlg: TLMDInputDlg;
begin
//    {�������������}
//    Result := '';
//    Dlg    := TLMDInputDlg.Create(nil);
//    try
//
//       {���������� ��������� ����}
//       If Length(Prm)>0 then Dlg.CaptionTitle:=Prm[0] else Dlg.CaptionTitle:='';
//
//       {���������� ����� ���������}
//       If Length(Prm)>1 then Dlg.Prompt:=Prm[1] else Dlg.Prompt:='';
//
//       {���������� ����� �� ���������}
//       If Length(Prm)>2 then Dlg.DefaultValue:=Prm[2] else Dlg.DefaultValue:='';
//
//       {������ ���������}
//       Dlg.DefaultSelected:=true;
//
//       {������}
//       If Not Dlg.Execute then Exit;
//
//       Result:=Dlg.Value;
//
//    finally
//       Dlg.Free;
//    end;
end;



{==============================================================================}
{========================  �������: ��� ������  ===============================}
{==============================================================================}
function TDECOD.FKodChr(const Prm: array of String): String;
var I: Integer;
    Kod: String;
begin
    {�������� ������� �� ������������}
    Result:='';
    Kod:=GetPrm(Prm, 0);
    If Kod = '' then Exit;
    For I:=1 to Length(Kod) do begin
       If IsNumeric(Kod[I])=false then Exit;
    end;

    {�������� ���}
    I:=StrToInt(Kod);
    If I<0 then Exit;

    {���������� ���������}
    Result:=Chr(I);
end;



{==============================================================================}
{===============      ������������� ��������� �����      ======================}
{==============================================================================}
{===============  Prm[0]='1' - ��������� ������ 1 �����  ======================}
{==============================================================================}
function TDECOD.MyCharUpper(const StrKod: String; const Prm: array of String): String;
var StrKodUp: String;
begin
    {���� ���� ���, �� �����}
    Result:=StrKod;
    If Result='' then Exit;

    {�������������}
    StrKodUp:=AnsiUpperCase(StrKod);

    {������������� ��������� ����� �������� ���������}
    If GetPrm(Prm,0)='1' then Result[1]:=StrKodUp[1] {��������� ������ ������ �����}
                         else Result:=StrKodUp;      {��� ����� ���������}
end;


{==============================================================================}
{=========  ��������� ��� [Kod] �� ������� [Cmd] � ��������� [Prm]  ===========}
(*========  � ���������� � '...' � {...} ����� ���-�� ����� ������� ==========*)
{=========  Cmd - � ��������� �������; Prm - ������� �� ������      ===========}
{=========  ������������ � ������� ��������                         ===========}
{==============================================================================}
procedure TDECOD.SeparatKod(const Kod: String; var Cmd: String; var Prm: TArrayStr);
var PsStr : TStringList;
    I, I0 : Integer;
    S, S0 : String;
begin
    {������� -> Cmd}
    S   := Trim(Kod);
    Cmd := AnsiUpperCase(Trim(CutSlovo(S, 1, '(')));

    {�������� � ����� ������ ��������� #$0Dh � #$0Ah}
    S:=CutEndStr(S);

    {*** �������� �� ������ S: Cmd � ������� ������ ***************************}
    Delete (S, 1, Length(Cmd));
    S := Trim(S);
    Delete(S, 1, 1);
    Delete(S, Length(S), 1);
    S := Trim(S);

    {�������� � ������ S ����� ������-�����������: |%N|%}
    PsStr  := TStringList.Create;
    try
       S := ReplPsevdoModul(S, PsStr, CH_KAV, CH_KAV);
       S := ReplPsevdoModul(S, PsStr, '{', '}');
       S := ReplStr(S, ',', ' , ');                 // �.�. ',,a' �������������� ��� �

       {*** ��������� ������ ��������� SOper0 ************************************}
       SetLength(Prm, 0);
       For I:=1 to GetColPSlovStr(S, ',') do begin
          S0:=Trim(CutPSlovoStr(S, I, ','));

          {���������� � ����� S0 �������� ������}
          For I0:=PsStr.Count-1 downto 0 do S0:=ReplStr(S0, PsStr.Names[I0], PsStr.Values[PsStr.Names[I0]]);

          {�������� ������� � ������ � ������������ �����}
          If Length(S0)>1 then begin
///             If (S0[1]='{')    and (S0[Length(S0)]='}') then ShowMessage('�������� ������: '+S0);
             If (S0[1]=CH_KAV) and (S0[Length(S0)]=CH_KAV) then begin
///             If ((S0[1]=CH_KAV) and (S0[Length(S0)]=CH_KAV)) or
///                ((S0[1]='{')    and (S0[Length(S0)]='}'))    then begin
                Delete(S0, 1,          1);
                Delete(S0, Length(S0), 1);
                S0:=ReplStr(S0, ' ,', ',');      // ���������� ���������
             end;
          end;

          {���������� ��������}
          SetLength(Prm, Length(Prm)+1);
          Prm[High(Prm)]:=S0;
       end;
    finally
       PsStr.Free;
    end;
end;


{==============================================================================}
{========================  ��������� ������ ��������  =========================}
{==============================================================================}
{========================            Ind � 0          =========================}
{==============================================================================}
function TDECOD.GetPrm(const Prm: array of String; const Ind: Integer): String;
begin
    Result:='';
    If (Length(Prm)-1)<Ind then Exit;
    Result:=Prm[Ind];
end;


