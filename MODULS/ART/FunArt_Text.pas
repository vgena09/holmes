{******************************************************************************}
{*************************    ������ � �������   ******************************}
{******************************************************************************}


{==============================================================================}
{================  ��������������� (�����������) ������ ������  ===============}
{==============================================================================}
{===  ����:  ��.2,5,12 �.2 ��.139, ��.14 - �.1 ��.139, ��.2,7,9 �.2 ��.139  ===}
{===  �����: ��.14 - �.1 ��.139, ��.2,5,7,9,12 �.2 ��.139                   ===}
{==============================================================================}
{===  ����:  �.2 ��.206, �.1 ��.206, ��.1,3 ��.206, �.1 ��.14 - ��.401      ===}
{===  �����: ��.1,2,3 ��.206, �.1 ��.14 - ��.401                            ===}
{==============================================================================}
function ArticlesGroup_TT(const Str: String): String;
var SList : TStringList;

    {**************************************************************************}
    {*** ������� �� ������ ������������ ***************************************}
    {**************************************************************************}
    procedure RemoveDublicate;
    var I, I0         : Integer;
        S, S0, SVal   : String;
        S1, S2, S3    : String;
        S01, S02, S03 : String;

       {***********************************************************************}
       {*** �������� ����� ������ *********************************************}
       {***********************************************************************}
       {*** Str  = 14 1 - 139 2 1 *********************************************}
       {*** PS1^ = 14 1 - 139     *********************************************}
       {*** PS2^ = 2              *********************************************}
       {*** PS3^ = 1              *********************************************}
       {***********************************************************************}
       procedure SeparatParts(const Str: String; const PS1, PS2, PS3: PString);
       var S : String;
           I : Integer;
       begin
           {�������������}
           PS1^:=''; PS2^:=''; PS3^:='';
           S   :=Str;

           {���������� S1}
           I:=Pos(' - ', S);
           If I>0 then begin
              PS1^ := Copy(S, 1, I+2);
              Delete(S, 1, I+2);
           end;
           PS1^ := PS1^ + CutSlovo(S, 1, ' ');
           PS2^ := PS2^ + CutSlovo(S, 2, ' ');
           PS3^ := PS3^ + CutSlovo(S, 3, ' ');
       end;

    begin
        {���������� ������ ����������: 12<2 --> 12>02 - ������ ��� ����� ������������}
        For I:=0 to SList.Count-1 do begin
           SVal := '';
           S    := SList[I];
           S0   := TokChar(S, ' ');
           While S0<>'' do begin
              If S0<>'-' then For I0:=Length(S0) to 2 do Insert('0', S0, 1);
              SVal := SVal+' '+S0;
              S0   := TokChar(S, ' ');
           end;
           Delete(SVal, 1, 1);
           SList[I]:=SVal;
        end;

        {��������� ������}
        SList.Sort;

        {������� ������ ����}
        For I:=0 to SList.Count-1 do begin
           SVal := '';
           S    := SList[I];
           For I0:=1 to GetColSlov(S, ' ') do begin
              S0:=CutSlovo(S, I0, ' ');
              If (S0<>'-') and IsIntegerStr(S0) then S0:=IntToStr(StrToInt(S0));
              SVal := SVal+' '+S0;
           end;
           Delete(SVal, 1, 1);
           SList[I]:=SVal;
        end;

        {������� ���������� ������}
        For I:=SList.Count-1 downto 1 do begin
           If SList[I]=SList[I-1] then SList.Delete(I);
        end;

        {���������� ���������� ����� � ������}
        For I:=SList.Count-1 downto 1 do begin
           {��������� ���� � ���������� ���� �� ������������}
           SeparatParts(SList[I],   @S1,  @S2,  @S3);
           SeparatParts(SList[I-1], @S01, @S02, @S03);

           {���� ������ ����� �� �����, �� ������� ������ ����������}
           If S1<>S01 then Continue;

           {���� ���� ����������� ������ - S2}
           If (S2<>S02) and (S3='') and (S03='') then begin
              SList[I-1]:=S1+' '+S02+','+S2;
              SList.Delete(I);
              Continue;
           end;

           {���� ���� ����������� ������� - S3}
           If (S2=S02) and (S3<>S03) then begin
              SList[I-1]:=S1+' '+S2+' '+S03+','+S3;
              SList.Delete(I);
              Continue;
           end;

           {���� ������ �����������}
           If (S2=S02) and (S3=S03) then SList.Delete(I);
        end;
    end;

    {**************************************************************************}
    {*** ��������� �� ������ ������ ������ ************************************}
    {**************************************************************************}
    function GetArticlStr: String;
    var S : String;
        I : Integer;
    begin
        {�������������}
        Result:='';

        {������������� ������}
        For I:=0 to SList.Count-1 do begin
           S:=ArticlesConvertBlock_AT(SList[I]);
           If S<>'' then Result:=Result+', '+S;
        end;

        {������������ ���������}
        Delete(Result, 1, 2);
    end;

{******************************************************************************}
{*** �������� ������� *********************************************************}
{******************************************************************************}
begin
    {�������������}
    Result:='';

    try
       {��������� �������� ������ �� ����� � ������� Access (� ��������������� � �����������) � ������� ������ SList}
       SList:=ArticlesSeparat_TA(Str, true);

       {������� �� ������ ������������}
       RemoveDublicate;

       {��������� �� ������ ������ ������}
       Result:=GetArticlStr;
    finally
       If SList<>nil then SList.Free;
    end;
end;


{==============================================================================}
{==================    ��������� ������ �� ������������     ===================}
{==============================================================================}
{===  ����:  ��.2,5 �.2 ��.139, �.1 ��.14 - �.1 ��.139, ��.2,7 �.2 ��.139  ====}
{===  �����: �.1 ��.14 - �.1 ��.139, �.2 �.2 ��.139, �.5 �.2 ��.139, ...   ====}
{==============================================================================}
function ArticlesSeparat_TT(const Str: String): TStringList;
var SList : TStringList;
    I     : Integer;
begin
    {�������������}
    Result:=nil;

    {��������� ������ ������ �� ����� � ������� Access (� ��������������� � �����������)}
    SList:=ArticlesSeparat_TA(Str, true);
    If SList=nil then Exit;
    Result:=TStringList.Create;

    {����������� ���� �� Access � Txt}
    For I:=0 to SList.Count-1 do Result.Add(ArticlesConvertBlock_AT(SList[I]));
end;


{==============================================================================}
{==================    ��������� ������ �� ������������     ===================}
{==============================================================================}
{===  ����:  ��.2,5 �.2 ��.139, �.1 ��.14 - �.1 ��.139, ��.2,7 �.2 ��.139  ====}
{===  �����: 14 1 - 139 1, 139 2 2, 139 2 5, 139 2 7  - IsFull=true        ====}
{===  �����:        139 1, 139 2 2, 139 2 5, 139 2 7  - IsFull=false       ====}
{==============================================================================}
function ArticlesSeparat_TA(const Str: String; const IsFull: Boolean): TStringList;
var SList : TStringList;
    Str0  : String;
    I     : Integer;


    {**************************************************************************}
    {*** ��������� ���� �� ������������ ������ � ������� � ������ SList *******}
    {**************************************************************************}
    {Art = �.1 ��.14 - ��.2,7, 9 �.2 ��.139}
    {Art = ��.14 - ��.145}
    {Art = ��.2,7, 9 �.2 ��.139}
    {Art = ��.1,3, 8 ��.206}
    {Art = ��.326}
    procedure AddArticlToSList(const Art: String);
    var SList0 : TStringList;
        S, S0  : String;
        I      : Integer;

       {***********************************************************************}
       {***  ��������� ������ �� ������������ ������ � ����� �������  *********}
       {***********************************************************************}
       {Str = 2,7,9 2 139  -->  139 2 2  /  139 2 7  /  139 2 9 }
       {Str = 1,3,8 206    -->  206 1    /  206 3    /  206 8   }
       {Str = 326          -->  326                             }
       procedure GetNewForm(const Str: String; const PList: PStringList);
       var S, S1, S2, S3 : String;
           I             : Integer;
       begin
           {�������������}
           If PList=nil then Exit;
           PList^.Clear;
           S1:=''; S2:=''; S3:='';
           S := Trim(Str);

           {����� ����}
           I := GetColSlov(S, ' ');
           If I=0 then Exit;

           {������: S1='139'; �����: S2='2'; �����: S3='2,7,9'}
                       S1 := CutSlovo(S, I, ' ');
           If I>1 then S2 := CutSlovo(S, I-1, ' ');
           If I>2 then S3 := CutSlovo(S, I-2, ' ');

           {������������ ���������}
           If S3<>'' then begin
              If GetColSlov(S3, ',')>0 then begin
                 For I:=1 to GetColSlov(S3, ',') do begin
                    PList^.Add(S1+' '+S2+' '+CutSlovo(S3, I, ','));
                 end;
              end else begin
                 PList^.Add(S1+' '+S2+' '+S3);
              end;
              Exit;
           end;
           If S2<>'' then begin
              If GetColSlov(S2, ',')>1 then begin
                 For I:=1 to GetColSlov(S2, ',') do begin
                    PList^.Add(S1+' '+CutSlovo(S2, I, ','));
                 end;
              end else begin
                 PList^.Add(S1+' '+S2);
              end;
              Exit;
           end;
           PList^.Add(S1);
       end;

    begin
        {�������������}
        S:=''; S0:='';
        SList0:=TStringList.Create;
        try
           {������� �� ����� �� ������ ������� + �������������� ������: S='1 14 - 2,7,9 2 139'}
           For I:=1 to Length(Art) do begin
              Case Art[I] of
              '�','�','�','�','.': S:=S+' ';
              else S:=S+Art[I];
              end;
           end;

           {������� ������ �������}
           S := ReplStrLoop(S, '  ', ' ');                // '2,    7,9 2 139' --> '2, 7,9 2 139'
           S := ReplStrLoop(S, ', ', ',');                // '2, 7,9 2 139'    --> '2,7,9 2 139'

           {�������� ������������� � ��������� � S0 = '14 1 - '}
           I:=Pos('-', S);
           If I>0 then begin
              {���� ��������� ������������� � ���������}
              If IsFull then begin
                 S0 := Copy(S, 1, I-1);
                 Delete(S, 1, I);

                 {��������� � ����� ������}
                 GetNewForm(S0, @SList0);                 // '1 14'  -->  '14 1'
                 If SList0.Count>0 then S0 := SList0[0]+' - '
                                   else S0 := '';

              {���� �� ��������� ������������� � ���������}
              end else begin
                 Delete(S, 1, I);
              end;
           end;

           {��������� �� ������������ ������ � ����� �������}
           GetNewForm(S, @SList0);

           {��������� ���������}
           For I:=0 to SList0.Count-1 do SList.Add(S0+SList0[I]);
        finally
           SList0.Free;
        end;
    end;


{******************************************************************************}
{*** �������� ������� *********************************************************}
{******************************************************************************}
begin
    {��� �������������: ���� ������ ��������� #0D#0A}
    Str0:=Str;
    For I:=1 to Length(Str0)-1 do begin
       If (Str0[I]=Chr(13)) and (Str0[I+1]=Chr(10)) then begin
          Str0[I]:=',';
          Str0[I+1]:=' ';
       end;
    end;

    {�������������}
    Result:=nil;
    SList:=TStringList.Create;
    try
       {��������� �������� ������ �� ����� � ������� ������ SList}
       While Str0<>'' do AddArticlToSList(TokArticl(Str0));

       {������������ ��������}
       If SList.Count=1 then If SList[0]='' then Exit;
       Result:=SList;
       Result.Sort;
    except
       SList.Free;
    end;
end;


{==============================================================================}
{================  ������� ������ ������ ��� Access: Norms  ===================}
{==============================================================================}
{======  ����:  139 1, 139 2 2, 139 2 5, 139 2 7                         ======}
{======  �����: ��.2,5 �.2 ��.139, �.1 ��.139, ��.2,7 �.2 ��.139         ======}
{==============================================================================}
function ArticlesConvert_AT(const Str: String): String;
label Nx;
var SList : TStringList;
    S     : String;
    I     : Integer;
begin
    {�������������}
    Result := '';
    SList  := TStringList.Create;
    try
       If Not SeparatMStr(Str, @SList, ', ') then Exit;

       {������������ ������ ����}
       For I:=0 to SList.Count-1 do begin
          S:=ArticlesConvertBlock_AT(SList[I]);
          If S<>'' then Result:=Result+', '+S;
       end;
       Delete(Result, 1, 2);

       {������������ ������}
       Result:=ArticlesGroup_TT(Result);
    finally
       SList.Free;
    end;
end;


{==============================================================================}
{=====================  ��������� ������������ � ������  ======================}
{==============================================================================}
function SeparatMStr(const MStr: String; const PLStr: PStringList; const Separator: String): Boolean;
var S: String;
    I: Integer;
begin
    {�������������}
    Result:=false;
    If PLStr=nil then Exit;
    PLStr^.Clear;

    {������������� ��� ������� � ��������� ������}
    I:=1; S:=Trim(CutSlovo(MStr, I, Separator));
    While S<>'' do begin
       Result:=true;
       PLStr^.Add(S);
       Inc(I); S:=Trim(CutSlovo(MStr, I, Separator));
    end;
end;


{==============================================================================}
{==========            ����������� ���� �� Access � Txt            ============}
{==============================================================================}
{==========  14 1 - 139 2 5,8  -->  �.1 ��.14 - ��.5,8 �.2 ��.139  ============}
{==============================================================================}
function ArticlesConvertBlock_AT(const Str: String): String;
var S, S0 : String;
    I     : Integer;

    {**************************************************************************}
    {***************  ����������� ����� ����� �� Access � Txt  ****************}
    {**************************************************************************}
    {***************        14 1     -->  �.1 ��.14            ****************}
    {***************        139 2 5  -->  �.5 �.2 ��.139       ****************}
    {**************************************************************************}
    function ConvertPartBlock(const Str: String): String;
    var S: String;
    begin
        {�������������}
        Result := '��.'+CutSlovo(Str, 1, ' ');

        {���������� �����}
        S      := CutSlovo(Str, 2, ' ');
        If S<>'' then begin
           If Pos(',', S)>0 then Result:='��.'+S+' '+Result
                            else Result:='�.' +S+' '+Result;
        end;

        {���������� ������}
        S      := CutSlovo(Str, 3, ' ');
        If S<>'' then begin
           If Pos(',', S)>0 then Result:='��.'+S+' '+Result
                            else Result:='�.'+S+' '+Result;
        end;
    end;
begin
    {�������������}
    S  := Str;
    S0 := '';

    {���������� ������ ������������� � ���������}
    I:=Pos(' - ', S);
    If I>0 then begin
       S0 := Copy(S, 1, I-1);
       S0 := ConvertPartBlock(S0)+' - ';
       Delete(S, 1, I+Length(' - ')-1);
    end;

    {���������� ��������� �����}
    Result:=S0+ConvertPartBlock(S);
end;


{==============================================================================}
{==============    ��������� ������������ ��������� ������     ================}
{==============================================================================}
function VerifyArticles(const Str: String): Boolean;
var SListNum, SListTxt : TStringList;
    SNum, STxt, S, S0  : String;
    I, I0 : Integer;
begin
    {�������������}
    Result:=false;
    STxt:=Trim(Str);
    If STxt='' then Exit;

    {��������� ������ �� ������������}
    SListNum := ArticlesSeparat_TA(Str, true);
    SListTxt := ArticlesSeparat_TT(Str);
    try
       If (SListNum=nil) or (SListTxt=nil) then Exit;
       If SListNum.Count = 0               then Exit;
       If SListNum.Count <> SListTxt.Count then Exit;
       Result:=true;

       {������������� ������ ���� ������}
       For I:=0 to SListNum.Count-1 do begin
          SNum := SListNum[I];
          STxt := AnsiLowerCase(SListTxt[I]);
          If GetColSlov(SNum, ' ')<>GetColSlov(STxt, ' ') then begin Result:=false; Break; end;
          If FindStr('��.', STxt)<1                       then begin Result:=false; Break; end;

          {������������� ������ ������� ������}
          For I0:=1 to GetColSlov(SNum, ' ') do begin
             {���� ������� - �����, �� ��}
             S:=CutSlovo(SNum, I0, ' ');
             If IsIntegerStr(S) then Continue;

             {�����: �����_�����}
             If I0=1 then begin
                S0:=CutSlovo(S, 1, '_');
                If IsIntegerStr(S0) then begin
                   S0:=CutSlovo(S, 2, '_');
                   If IsIntegerStr(S0) then Continue;
                 end;
             end;

             {������������ ��������}
             Result:=false;
             Break;
          end;

          If Result=false then Break;
       end;
    finally
       If SListTxt <> nil then SListTxt.Free;
       If SListNum <> nil then SListNum.Free;
    end;
end;


{==============================================================================}
{================   �������� �� ������ ������ ������ ����    ==================}
{==============================================================================}
{=======  Art = ��.2,4, 7 �.2 ��.139, ��.14 - �.1 ��.139, �.1 ��.145,  ========}
{==============================================================================}
{================  Result = �.1 ��.14 - ��.2,7,9 �.2 ��.139  ==================}
{================  Result = ��.14 - ��.2,7,9 �.2 ��.139      ==================}
{================  Result = ��.2,7,9 �.2 ��.139              ==================}
{================  Result = ��.1,3 ��.206                    ==================}
{================  Result = ��.326                           ==================}
{==============================================================================}
function TokArticl(var Art: String): String;
label Nx;
var S1, S2 : String;
    I      : Integer;
begin
    {�������������}
    Result := '';
    Art:=Trim(Art);
    If Art='' then Exit;

    {����� ������� ����������}
    I:=1;
Nx: I:=InStrMy(I, Art, ', ');

    {�������������� ��������� ������}
    If I>0 then begin
       {���������� ����� �� � ����� ����������}
       S1:=Copy(Art, 1,   I-1);
       S2:=Trim(Copy(Art, I+1, Length(Art)-I));

       {���� ���� ����� ���������� ���������� � �����, �� �� ������ ��������� - ���� ������}
       If Length(S2)>0 then If IsNumeric(S2[1]) then begin
          I:=I+1;
          Goto Nx;
       end;

       {�������� ����}
       Result:=S1;
       Delete(Art, 1, Length(S1+', '));

    {��������� �� ������}
    end else begin
       If FindStr('��.', Art)>0 then Result:=Art else Result:='';
       Art:='';
    end;

    {������� ��������� ���������������}
    Result:=ReplStr(Result, ', ', ',');

    {������������ ���������}
    If Length(Result)>0 then If Result[Length(Result)]=',' then Delete(Result, Length(Result), 1);
end;


{==============================================================================}
{========  ����� S1 ��� S2 � ����������� �� ����� ������ � SArticl  ===========}
{==============================================================================}
function  SelTxtFromArticl(const SArticl, S1, S2: String): String;
var SList : TStringList;
    S     : String;
begin
    {�������������}
    Result:=S1;

    {SArticl �/� � ��������}
    S:=CutModulChar(SArticl, CH_KAV, CH_KAV);
    If S='' then S:=SArticl;

    {��������� ������ ������ �� ����� � ������� Access (��� ������������� � ���������)}
    SList:=ArticlesSeparat_TA(S, false);

    If SList=nil then Exit;
    If SList.Count>1 then Result:=S2;
    SList.Free;
end;
