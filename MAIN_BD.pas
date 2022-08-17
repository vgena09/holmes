{==============================================================================}
{=====================     �� �������� ���������       ========================}
{==============================================================================}
{=====================  ���� ��� ������� ������������  ========================}
{==============================================================================}
function TFMAIN.IniBSET_LOCAL: Boolean;
var SSrc, SDect : String;
begin
    Result := false;
    try
       SSrc := PATH_DATA+FILE_BD_SET_LOCAL;
       If Not FileExists(SSrc) then begin ErrMsg('�� ������ ����:'+CH_NEW+SSrc); Exit; end;
       If not IS_ADMIN then begin
          {��� ������ ������������ �������� ���� �� ���������}
          SDect := PATH_WORK+ExtractFileName(SSrc);
          If Not FileExists(SDect) then begin
             If Not CopyFileTo(SSrc, SDect) then begin ErrMsg('������ �����������:'+CH_NEW+'��: '+SSrc+CH_NEW+'�:  '+SDect); Exit; end;
             try FileSetAttr(SDect, 0); except end; {������� ��������� �������� !!!!! ��� ����� ��������� ��������� ������ �������������� � ������������ !!!!!}
          end;
       end else begin
          SDect := SSrc;
       end;

       {��������� ��}
       With BSET_LOCAL do begin
          BD       := TADOConnection.Create(Self);
          TLIST    := TADOTable.Create(Self);
          TVAR     := TADOTable.Create(Self);
          TVAR_OLE := TADOTable.Create(Self);
          If Not OpenBD(@BD, SDect, '', [@TLIST, @TVAR,    @TVAR_OLE],
                                        [T_LIST, T_UD_VAR, T_UD_VAR_OLE])
          then begin ErrMsg('������ ��������:'+CH_NEW+SDect); Exit; end;
          TVAR.Sort := '['+F_VAR_CAPTION+'] ASC';
       end;
       Result := true;
    finally
    end;
end;

procedure TFMAIN.FreeBSET_LOCAL;
begin
    With BSET_LOCAL do begin
       CloseBD(@BD, [@TLIST, @TVAR, @TVAR_OLE]);
       TLIST.Free;
       TVAR.Free;
       TVAR_OLE.Free;
       BD.Free;
    end;
end;


{==============================================================================}
{=========                   �� �������� ����������                 ===========}
{==============================================================================}
{=========  ����� ��� ���� (� ���� ���������� ������������ � TEMP)  ===========}
{==============================================================================}
function TFMAIN.IniBSET_GLOBAL: Boolean;
var SSrc, SDect : String;
begin
    Result := false;
    try
       SSrc := PATH_DATA+FILE_BD_SET_GLOBAL;
       If Not FileExists(SSrc) then begin ErrMsg('�� ������ ����:'+CH_NEW+SSrc); Exit; end;
       If not IS_ADMIN then begin
          {��� ������ ������������ �������� ���� �� ��������� ����� �� ���������}
          SDect := PATH_WORK_TEMP+ExtractFileName(SSrc);
          If Not FileExists(SDect) then begin
             If Not CopyFileTo(SSrc, SDect) then begin ErrMsg('������ �����������:'+CH_NEW+'��: '+SSrc+CH_NEW+'�:  '+SDect); Exit; end;
             try FileSetAttr(SDect, 0); except end; {������� ��������� �������� !!!!! ��� ����� ��������� ��������� ������ �������������� � ������������ !!!!!}
          end;
       end else begin
          SDect := SSrc;
       end;

       {��������� ��}
       With BSET_GLOBAL do begin
          BD       := TADOConnection.Create(Self);
          TLSTATUS := TADOTable.Create(Self);
          If Not OpenBD(@BD, SDect, '', [@TLSTATUS],
                                        [TABLE_LSTATUS], true)
          then begin ErrMsg('������ ��������:'+CH_NEW+SDect); Exit; end;
       end;
       Result := true;
    finally
    end;
end;

procedure TFMAIN.FreeBSET_GLOBAL;
begin
    With BSET_GLOBAL do begin
       CloseBD(@BD, [@TLSTATUS]);
       TLSTATUS.Free;
       BD.Free;
    end;
end;


{==============================================================================}
{=========                        �� ���������                      ===========}
{==============================================================================}
{=========  ����� ��� ���� (� ���� ���������� ������������ � TEMP)  ===========}
{==============================================================================}
function TFMAIN.IniBEXP: Boolean;
var SSrc, SDect : String;
begin
    Result := false;
    try
       SSrc := PATH_DATA+FILE_BD_EXP;
       If Not FileExists(SSrc) then begin ErrMsg('�� ������ ����:'+CH_NEW+SSrc); Exit; end;
       If not IS_ADMIN then begin
          {��� ������ ������������ �������� ���� �� ��������� ����� �� ���������}
          SDect := PATH_WORK_TEMP+ExtractFileName(SSrc);
          If Not FileExists(SDect) then begin
             If Not CopyFileTo(SSrc, SDect) then begin ErrMsg('������ �����������:'+CH_NEW+'��: '+SSrc+CH_NEW+'�:  '+SDect); Exit; end;
             try FileSetAttr(SDect, 0); except end; {������� ��������� �������� !!!!! ��� ����� ��������� ��������� ������ �������������� � ������������ !!!!!}
          end;
       end else begin
          SDect := SSrc;
       end;

       {��������� ��}
       With BEXP do begin
          BD   := TADOConnection.Create(Self);
          TEXP := TADOTable.Create(Self);
          TQST := TADOTable.Create(Self);
          TORG := TADOTable.Create(Self);
          TREL := TADOTable.Create(Self);
          If Not OpenBD(@BD, SDect, '', [@TEXP,     @TQST],
                                        [T_EXP_EXP, T_EXP_QST], true)
          then begin ErrMsg('������ ��������:'+CH_NEW+SDect); Exit; end;
       end;
       Result := true;
    finally
    end;
end;

procedure TFMAIN.FreeBEXP;
begin
    With BEXP do begin
       CloseBD(@BD, [@TEXP, @TQST]);
       TEXP.Free; TQST.Free; TORG.Free; TREL.Free;
       BD.Free;
    end;
end;


{==============================================================================}
{=========                           �� ����                        ===========}
{==============================================================================}
{=========  ����� ��� ���� (� ���� ���������� ������������ � TEMP)  ===========}
{==============================================================================}
function TFMAIN.IniBART: Boolean;
var SSrc, SDect : String;
begin
    Result := false;
    try
       SSrc := PATH_DATA+FILE_BD_ART;
       If Not FileExists(SSrc) then begin ErrMsg('�� ������ ����:'+CH_NEW+SSrc); Exit; end;
       If not IS_ADMIN then begin
          {��� ������ ������������ �������� ���� �� ��������� ����� �� ���������}
          SDect := PATH_WORK_TEMP+ExtractFileName(SSrc);
          If Not FileExists(SDect) then begin
             If Not CopyFileTo(SSrc, SDect) then begin ErrMsg('������ �����������:'+CH_NEW+'��: '+SSrc+CH_NEW+'�:  '+SDect); Exit; end;
             try FileSetAttr(SDect, 0); except end; {������� ��������� �������� !!!!! ��� ����� ��������� ��������� ������ �������������� � ������������ !!!!!}
          end;
       end else begin
          SDect := SSrc;
       end;

       {��������� ��}
       With BART do begin
          BD    := TADOConnection.Create(Self);
          TUK   := TADOTable.Create(Self);
          TCOM  := TADOTable.Create(Self);
          If Not OpenBD(@BD, SDect, '', [@TUK,     @TCOM],
                                        [TABLE_UK, TABLE_COM], true)
          then begin ErrMsg('������ ��������:'+CH_NEW+SDect); Exit; end;
       end;
       Result := true;
    finally
    end;
end;

procedure TFMAIN.FreeBART;
begin
    With BART do begin
       CloseBD(@BD, [@TUK, @TCOM]);
       TUK.Free;
       TCOM.Free;
       BD.Free;
    end;
end;


{==============================================================================}
{=========                           ������                         ===========}
{==============================================================================}
{=========  ����� ��� ���� (� ���� ���������� ������������ � TEMP)  ===========}
{==============================================================================}
function TFMAIN.IniHelp: Boolean;
var SSrc, SDect : String;
begin
    Result := false;
    try
       SSrc := PATH_DATA+FILE_HELP;
       If Not FileExists(SSrc) then begin ErrMsg('�� ������ ����:'+CH_NEW+SSrc); Exit; end;
       If not IS_ADMIN then begin
          {��� ������ ������������ �������� ���� �� ��������� ����� �� ���������}
          SDect := PATH_WORK_TEMP+ExtractFileName(SSrc);
          If Not FileExists(SDect) then begin
             If Not CopyFileTo(SSrc, SDect) then begin ErrMsg('������ �����������:'+CH_NEW+'��: '+SSrc+CH_NEW+'�:  '+SDect); Exit; end;
             try FileSetAttr(SDect, 0); except end; {������� ��������� �������� !!!!! ��� ����� ��������� ��������� ������ �������������� � ������������ !!!!!}
          end;
       end else begin
          SDect := SSrc;
       end;

       Result := true;
    finally
    end;
end;


