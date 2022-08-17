{==============================================================================}
{======================   ОПЕРАЦИИ С SQL-ЗАПРОСАМИ   ==========================}
{==============================================================================}


{==============================================================================}
{===================    УСТАНОВКА SQL-СПИСКА ЭКСПЕРТИЗ    =====================}
{==============================================================================}
function TFVAR_EXPERT_HELPER.SetSQLExp: Boolean;
var S, STxt: String;
begin
    {Инициализация}
    STxt:=Trim(EInv.Text);

    try
       {Текст запроса}
       S:='SELECT DISTINCT '+
                   '['+T_EXP_EXP+'].['+F_COUNTER    +'] AS ['+F_COUNTER    +'], '+CH_NEW+
                   '['+T_EXP_EXP+'].['+F_EXP_CAPTION+'] AS ['+F_EXP_CAPTION+'], '+CH_NEW+
                   '['+T_EXP_EXP+'].['+F_EXP_INV    +'] AS ['+F_EXP_INV    +']'+CH_NEW+
          'FROM     ['+T_EXP_EXP+']'+CH_NEW;

       {В случае необходимости добавляем поиск связанных вопросов}
       If STxt<>'' then S:=S+
                 ', ['+T_EXP_QST+']'+CH_NEW+
          'WHERE   (['+T_EXP_EXP+'].['+F_COUNTER+    ']='+'['+T_EXP_QST+'].['+F_QST_EXP+'])'+CH_NEW+
             ' AND (['+T_EXP_QST+'].['+F_QST_CAPTION+'] LIKE '+QuotedStr('%'+STxt+'%')+')'+CH_NEW;

       {Добавляем сортировку}
       S:=S+'ORDER BY ['+T_EXP_EXP+'].['+F_EXP_CAPTION+ '] ASC, ['+T_EXP_EXP+'].['+F_EXP_INV+'] ASC;';

       {Обновляем запрос}
       If QExp.Active then QExp.Close;
       QExp.SQL.Clear;
       QExp.SQL.Add(S);
       QExp.Open;

       {Возвращаемый результат}
       Result:=true;
    except
       Result:=false;
    end;
end;


{==============================================================================}
{====================    УСТАНОВКА SQL-СПИСКА ВОПРОСОВ    =====================}
{==============================================================================}
function TFVAR_EXPERT_HELPER.SetSQLQst: Boolean;
var S, S1, S2: String;
begin
    S2 := Trim(EExp.Text);
    S1 := TokStr(S2, S_SEPARAT);
    try
       {Текст запроса}
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

       {Учитываем материалы}
       S:=S+' AND ((['+T_EXP_QST+'].['+F_QST_PPERSON+ ']<='+IntToStr(LNewMat.Count)+') OR '+CH_NEW+
                  '(['+T_EXP_QST+'].['+F_QST_PPERSON+ '] Is Null))'+CH_NEW;

       {Порядок сортировки}
       S:=S+'ORDER BY     ['+T_EXP_QST+'].['+F_QST_CATEGORY+'] ASC,'+CH_NEW+
                         '['+T_EXP_QST+'].['+F_COUNTER     +'] ASC;';

       {Обновляем запрос}
       If QQst.Active then QQst.Close;
       QQst.SQL.Clear;
       QQst.SQL.Add(S);
       QQst.Open;

       {Возвращаемый результат}
       Result:=true;
    except
       Result:=false;
    end;
end;
