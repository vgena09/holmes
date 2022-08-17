{==============================================================================}
{=============        � � � � � � �     � � � � � �     I F      ==============}
{==============================================================================}
{=============          DecStr = IF ... THEN ... ELSE ...        ==============}
{==============================================================================}
function TDECOD.DecoderPackIF(const DecStr: String): String;
var S,S1,S2,S3 : String;
    I          : Integer;
begin
    {�������������}
    Result:='';
    S:=DecStr;    //S:=Trim(DecStr);

    {���������, ��� ������� IF}
    If not CmpStr(Copy(S, 1, Length('IF ')), 'IF ') then Exit;

    {�������� ������� S3}
    Delete(S, 1, Length('IF '));
    I  := InStrIf(1, S, ' THEN ');
    If I<1 then Exit;
    S3 := Copy(S, 1, I-1);  // S3 := CutSpace(Copy(S, 1, I-1));
    Delete(S, 1, I+Length(' THEN ')-1);

    {�������� �������� �������� S1 � S2}
    I:=InStrIf(1, S, ' ELSE ');
    If I>0 then begin
       S2:=Copy(S, I+Length(' ELSE '), Length(S));
       Delete(S, I, Length(S));
    end else S2:='';
    S1:=S;

    {������ ��������� �����������}
    If S1=CH_KAV+CH_KAV then S1:='';
    If S2=CH_KAV+CH_KAV then S2:='';

    {�������� �� ������� S3 ������� S1 ��� S2}
    If DecoderCondOrg(S3) then Result:=S1 else Result:=S2;

    //{�������� �������}
    //Result:=Trim(Result);
end;


{==============================================================================}
{====              ����������� ������������� � ������� �������             ====}
{==============================================================================}
(*===      DecStr =  {STR AND STR} AND {STR AND {STR AND STR}}    ���      ===*)
(*===      DecStr = {{STR AND STR} AND {STR AND {STR AND STR}}}            ===*)
{==============================================================================}
function TDECOD.DecoderCondOrg(const DecStr: String): Boolean;
var S: String;
begin
    Result:=false;
    S:=Trim(DecStr);
    If Length(S)<2 then Exit;   //<4 �� �������� '1=1'

    {���������� �������: � ������ ����� �� �����}
    S:=Decoder('{'+S+'}');

    {��������� String � Boolean}
    If CmpStr(S, 'TRUE')  then begin Result:=true;  Exit; end;
    If CmpStr(S, 'FALSE') then begin Result:=false; Exit; end;
end;


{==============================================================================}
{====                            ������ �������                            ====}
{==============================================================================}
(*===   DecStr = STR � STR                                                 ===*)
{====   Result = false - ������ ������������� (�� ������ �������)          ====}
{==============================================================================}
function TDECOD.DecoderCond(var DecStr: String): Boolean;
const Condit : array[1..10] of String=('<=', '>=', '<>', '<', '>', '=',
                                       ' AND ', ' OR ', ' XOR ', 'NOT ');
var S0, S1, S2 : String;
    B1, B2     : Boolean;
    I,  J      : Integer;

    {*** ��������� ������ �� �������� *****************************************}
    function SeparatCond(const Str: String;
                         var Str1, Str2: String; var ICond: Integer): Boolean;
    var PsStr  : TStringList;
        S      : String;
        I0, J0 : Integer;
    begin
        {�������������}
        Result := false;
        S      := Str;
        Str1   := Str;
        Str2   := '';
        ICond  := -1;
        PsStr  := TStringList.Create;
        try
           {�������� � ������ S ����� ������-�����������: |%N|%}
           S := ReplPsevdoModul(S, PsStr, CH_KAV, CH_KAV);
           S := ReplPsevdoModul(S, PsStr, '{', '}');
           S := ReplPsevdoModul(S, PsStr, '(', ')');

           {������������� ��� �������}
           For I0:=Low(Condit) to High(Condit) do begin
              J0:=FindStr(Condit[I0], S);  
              If J0>0 then begin
                 ICond:=I0;
                 Break;
              end;
           end;

           {������� �� �������}
           If ICond=-1 then Exit;

           {�������� ��������}
           Str1:=Trim(Copy(S, 1, J0-1));
           Str2:=Trim(Copy(S, J0+Length(Condit[I0]), Length(S)));

           {���������� � ����� �������� ������}
           For I0:=PsStr.Count-1 downto 0 do begin
              Str1:=ReplStr(Str1, PsStr.Names[I0], PsStr.Values[PsStr.Names[I0]]);
              Str2:=ReplStr(Str2, PsStr.Names[I0], PsStr.Values[PsStr.Names[I0]]);
           end;
        finally
           PsStr.Free;
        end;

        {������������ ��������}
        If Str1=CH_KAV+CH_KAV then Str1:='';
        If Str2=CH_KAV+CH_KAV then Str2:='';

        {�������� ��������� ������� ������}
        If Length(S1)>1 then begin
           If (S1[1]='(') and (S1[Length(S1)]=')') then begin
              Delete(S1, 1, 1);
              Delete(S1, Length(S1), 1);
           end;
        end;
        If Length(S2)>1 then begin
           If (S2[1]='(') and (S2[Length(S2)]=')') then begin
              Delete(S2, 1, 1);
              Delete(S2, Length(S2), 1);
           end;
        end;

        Result:=true;
    end;
    
    {*** �������� ������� *****************************************************}
begin
    {�������������}
    Result:=false;  B1:=false; B2:=false;

    {���� DecStr=true ��� DecStr=false}
    If CmpStrList(DecStr, ['TRUE', 'FALSE'])>=0 then begin
       Result:=true;
       Exit;
    end;

    {�������� ��������}
    If not SeparatCond(DecStr, S1, S2, I) then Exit;

    {���������� ������������� ������� ���������� �������� ����� ��������}
    For J:=Low(Condit) to High(Condit) do begin
       If FindStr(Condit[J], S2)>0 then begin
          DecoderCond(S2);
          Break;
       end;
    end;

    {���������� ��������}
    If CmpStrList(S1, ['TRUE', 'FALSE'])<0 then begin
       S0:=Decoder(S1);
       If S0<>'' then S1:=S0;
    end else B1:=StrToBoolMy(S1);
    If CmpStrList(S2, ['TRUE', 'FALSE'])<0 then begin
       S0:=Decoder(S2);
       If S0<>'' then S2:=S0;
    end else B2:=StrToBoolMy(S2);

    {��������� ��������� �������}
    S1 := AnsiUpperCase(S1);
    S2 := AnsiUpperCase(S2);
    DecStr:='FALSE';
    Case I of
    1:  If S1<=S2    then DecStr:='TRUE';
    2:  If S1>=S2    then DecStr:='TRUE';
    3:  If S1<>S2    then DecStr:='TRUE';
    4:  If S1<S2     then DecStr:='TRUE';
    5:  If S1>S2     then DecStr:='TRUE';
    6:  If S1=S2     then DecStr:='TRUE';
    7:  If B1 and B2 then DecStr:='TRUE';
    8:  If B1 or  B2 then DecStr:='TRUE';
    9:  If B1 xor B2 then DecStr:='TRUE';
    10: If    not B2 then DecStr:='TRUE';
    end;

    {������������ ���������}
    Result:=true;
end;

