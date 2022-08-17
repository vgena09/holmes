{******************************************************************************}
{********  Î Ï Å Ð À Ö È È    Ñ    Ä À Ò À Ì È   È   Â Ð Å Ì Å Í Å Ì   ********}
{******************************************************************************}


{==============================================================================}
{========================    ÄÀÒÀ/ÂÐÅÌß ÑÅÃÎÄÍß    ============================}
{==============================================================================}
function TDECOD.FDateTimeNow(const Prm: array of String): String;
begin
    Result:=CorrectDateTimeStr(DateTimeToStr(StrDateTimeCorrect(Now, Prm)));
end;


{==============================================================================}
{===========================    ÄÀÒÀ ÑÅÃÎÄÍß    ===============================}
{==============================================================================}
function TDECOD.FDateNow(const Prm: array of String): String;
begin
    Result:=CorrectDateTimeStr(DateToStr(StrDateTimeCorrect(Date, Prm)));
end;


{==============================================================================}
{===========================  ÒÅÊÓÙÅÅ ÂÐÅÌß  ==================================}
{==============================================================================}
function TDECOD.FTimeNow(const Prm: array of String): String;
begin
    Result:=CorrectDateTimeStr(TimeToStr(StrTimeCorrect(Time, Prm)));
end;


{==============================================================================}
{===============            ÊÎÐÐÅÊÖÈß ÄÀÒÛ                    =================}
{==============================================================================}
{===============   Prm = [ìåñÿöû], [äíè], [÷àñû], [ìèíóòû]    =================}
{==============================================================================}
function TDECOD.StrDateTimeCorrect(const T0: TDateTime; const Prm: array of String): TDateTime;
var Len, Month0, Day0, Hour0, Min0: Integer;
begin
     {Èíèöèàëèçàöèÿ}
     Month0:=0; Day0:=0; Hour0:=0; Min0:=0;
     Len:=Length(Prm);

     {Îïðåäåëÿåì ïàðàìåòðû}
     If Len>0 then If IsIntegerStr(GetPrm(Prm, 0)) then Month0 := StrToInt(GetPrm(Prm, 0));
     If Len>1 then If IsIntegerStr(GetPrm(Prm, 1)) then Day0   := StrToInt(GetPrm(Prm, 1));
     If Len>2 then If IsIntegerStr(GetPrm(Prm, 2)) then Hour0  := StrToInt(GetPrm(Prm, 2));
     If Len>3 then If IsIntegerStr(GetPrm(Prm, 3)) then Min0   := StrToInt(GetPrm(Prm, 3));

     {Ïðîèçâîäèì êîððåêöèþ äàòû}
     Result:=DateTimeCorrect(T0, 0, Month0, Day0, Hour0, Min0);
end;


{==============================================================================}
{=====================       ÊÎÐÐÅÊÖÈß  ÂÐÅÌÅÍÈ         =======================}
{==============================================================================}
{=====================     Prm = [÷àñû], [ìèíóòû]       =======================}
{==============================================================================}
function TDECOD.StrTimeCorrect(const T0: TDateTime; const Prm: array of String): TDateTime;
label nx1,nx2;
var H, M, Sec, MSec : Word;
    H0, M0          : Integer;
begin
     {Èíèöèàëèçàöèÿ}
     H0:=0; M0:=0;

     {Îïðåäåëÿåì ïàðàìåòðû}
     Case Length(Prm) of
     1: begin
           H0:=StrToInt(GetPrm(Prm, 0));
        end;
     2: begin
           H0:=StrToInt(GetPrm(Prm, 0));
           M0:=StrToInt(GetPrm(Prm, 1));
        end;
     end;

     {Ïðîèçâîäèì êîððåêöèþ âðåìåíè}
     DecodeTime(T0, H, M, Sec, MSec);
     H:=H+H0;
     M:=M+M0;
nx1: if M>=60 then begin M:=M-60; Inc(H); goto nx1; end;
     if M<0   then begin M:=M+60; Dec(H); goto nx1; end;
nx2: if H>=24 then begin H:=H-24; goto nx2; end;
     if H<0   then begin H:=H+24; goto nx2; end;
     Result:=EncodeTime(H, M, 0, 0);
end;



