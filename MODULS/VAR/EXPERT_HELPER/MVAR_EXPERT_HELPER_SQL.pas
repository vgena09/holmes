{==============================================================================}
{======================   �������� � SQL-���������   ==========================}
{==============================================================================}


{==============================================================================}
{===================    ��������� SQL-������ ���������    =====================}
{==============================================================================}
function TFVAR_EXPERT_HELPER.SetSQLExp: Boolean;
var S, STxt: String;
begin
    {�������������}
    STxt:=Trim(EInv.Text);

    try
       {����� �������}
       S:='SELECT DISTINCT '+
                   '['+T_EXP_EXP+'].['+F_COUNTER    +'] AS ['+F_COUNTER    +'], '+CH_NEW+
                   '['+T_EXP_EXP+'].['+F_EXP_CAPTION+'] AS ['+F_EXP_CAPTION+'], '+CH_NEW+
                   '['+T_EXP_EXP+'].['+F_EXP_INV    +'] AS ['+F_EXP_INV    +']'+CH_NEW+
          'FROM     ['+T_EXP_EXP+']'+CH_NEW;

       {� ������ ������������� ��������� ����� ��������� ��������}
       If STxt<>'' then S:=S+
                 ', ['+T_EXP_QST+']'+CH_NEW+
          'WHERE   (['+T_EXP_EXP+'].['+F_COUNTER+    ']='+'['+T_EXP_QST+'].['+F_QST_EXP+'])'+CH_NEW+
             ' AND (['+T_EXP_QST+'].['+F_QST_CAPTION+'] LIKE '+QuotedStr('%'+STxt+'%')+')'+CH_NEW;

       {��������� ����������}
       S:=S+'ORDER BY ['+T_EXP_EXP+'].['+F_EXP_CAPTION+ '] ASC, ['+T_EXP_EXP+'].['+F_EXP_INV+'] ASC;';

       {��������� ������}
       If QExp.Active then QExp.Close;
       QExp.SQL.Clear;
       QExp.SQL.Add(S);
       QExp.Open;

       {������������ ���������}
       Result:=true;
    except
       Result:=false;
    end;
end;


{==============================================================================}
{====================    ��������� SQL-������ ��������    =====================}
{==============================================================================}
function TFVAR_EXPERT_HELPER.SetSQLQst: Boolean;
var S, S1, S2: String;
begin
    S2 := Trim(EExp.Text);
    S1 := TokStr(S2, S_SEPARAT);
    try
       {����� �������}
       S:='SELECT DISTINCT '+
                      '['+T_EXP_QST+'].['+F_COUNTER     +'], '+CH_NEW+
                      '['+T_EXP_QST+'].['+F_QST_CATEGORY+'], '+CH_NEW+
                      '['+T_EXP_QST+'].['+F_QST_CAPTION +'], '+CH_NEW+
                      '['+T_EXP_QST+'].['+F_QST_HINT    +']'  +CH_NEW+
          'FROM        ['+T_EXP_EXP+'] '+
          'INNER JOIN  ['+T_EXP_QST+'] '+
          'ON         (['+T_EXP_EXP+'].['+F_COUNTER+'] = ['+T_EXP_QST+'].['+F_QST_EXP+']) '+
          'AND        (['+T_EXP_EXP+'].['+F_COUNTER+'] = ['+T_EXP_QST+'].['+F_QST_EXP+'])'+CH_NEW+
          'WHERE      (['+T_EXP_EXP+'].['+F_EXP_CAPTION+']='+QuotedStr(S1)+')'+CH_NEW;

       If S2<>'' then S:=S+'AND  (['+T_EXP_EXP+'].['+F_EXP_INV+']='+QuotedStr(S2)+')'+CH_NEW
                 else S:=S+'AND ((['+T_EXP_EXP+'].['+F_EXP_INV+']='+QuotedStr(S2)+') OR '+CH_NEW+
                                '(['+T_EXP_EXP+'].['+F_EXP_INV+'] is Null))'+CH_NEW;

       {��������� ���������}
       S:=S+' AND ((['+T_EXP_QST+'].['+F_QST_PPERSON+ ']<='+IntToStr(LNewMat.Count)+') OR '+CH_NEW+
                  '(['+T_EXP_QST+'].['+F_QST_PPERSON+ '] Is Null))'+CH_NEW;

       {������� ����������}
       S:=S+'ORDER BY     ['+T_EXP_QST+'].['+F_QST_CATEGORY+'] ASC,'+CH_NEW+
                         '['+T_EXP_QST+'].['+F_COUNTER     +'] ASC;';

       {��������� ������}
       If QQst.Active then QQst.Close;
       QQst.SQL.Clear;
       QQst.SQL.Add(S);
       QQst.Open;

       {������������ ���������}
       Result:=true;
    except
       Result:=false;
    end;
end;
