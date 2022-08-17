unit FunDay;

interface
uses
   System.SysUtils, System.DateUtils, System.StrUtils,
   Vcl.Dialogs, Vcl.Controls {TDate},
   Data.DB, Data.Win.ADODB;

   {�������� ���� � �������}
   function  ValidDateTime(const S: String): Boolean;

   {�������� ����}
   function  ValidDate(const S: String): Boolean;

   {�������� �������}
   function  ValidTime(const S: String): Boolean;

   {������� �� ����/������� �������}
   function  DelSecond(const FDateTime: TDateTime): TDateTime;

   {����������� ����/������� (STRING)}
   function  CorrectDateTimeStr(const SDateTime: String): String;

   {�������� �� ���� ��� � ������� 2000}
   function  CutYear(const FDate: TDateTime): String;

   {�������� �� ������� ���� � ������� 00}
   function  CutHour(const FTime: TDateTime): String;

   {�������� �� ������� ������ � ������� 00}
   function  CutMinut(const FTime: TDateTime): String;

   {�������� �� STR-���� ��� � ������� 0000}
   function  CutYearStr(const Str: String): String;

   {�������� �� STR-������� ���� � ������� 00}
   function  CutHourStr(const Str: String): String;

   {�������� �� STR-������� ������ � ������� 00}
   function  CutMinutStr(const Str: String): String;

   {�������� �� STR-����/������� ����}
   function  CutDateStr(const Str: String): String;

   {�������� �� STR-����/������� �����}
   function  CutTimeStr(const Str: String): String;

   {��������� ����/������� �� +1, -2, ...}
   function  DateTimeCorrect(const T0: TDateTime; const DYears, DMonths,
                             DDays, DHours, DMinuts: Integer): TDateTime;
                             
   {����� ���, �������, ����, ����� ����� ����� ������}
   procedure DateTimeDiff0(const Date1, Date2: TDateTime;
                           var Hours, Days, Months, Years: Integer);

   {������� � ������ �������}
   function  SecondToTime(const Seconds: Cardinal): Double;

   {������: '01.01.2000+StrEnd 01:02' �� '01 ������ 2000+StrEnd+01 ���. 02 ���.'}
   function  SDateTimeToStr(const S: String; const Prm: array of String): String;

   {������: '01.01.2000+StrEnd' �� '01 ������ 2000+StrEnd'}
   function  SDateToStr(const S, StrEnd: String): String;

   {�� ������� 00:00 ---> 00 ���. 00 ���.}
   function  STimeToStr(const S: String): String;

   {������: 00 �� 2000}
   function  Year2To4(const S: String): String;

   {������� ������� ������ � ������}
   function  MonthIndToStr(const IMonth: Integer): String;

   {������� �������� ������ � ������}
   function  MonthStrToInd(const SMonth: String): Integer;
   function  MonthOldStrToInd(const SMonth: String): Integer;

   {���������� ������� �������� ������}
   function  NullPeriod(var SYear, SMonth: String): Boolean;

   {���� �������}
   function  SDatePeriod(const SYear, SMonth: String): TDate;
   function  IDatePeriod(const IYear, IMonth: Integer): TDate;

   {������������ ������}
   function  CorrectPeriod(const SYear, SMonth: String; const DMonth: Integer): TDate;

   {������������ ��� � ����� �������}
   function  CorrectPeriodStr(var SYear, SMonth: String; const DMonth: Integer): Boolean;


const MonthList: array[1..12] of String = ('������', '�������', '����',     '������',  '���',    '����',
                                           '����',   '������',  '��������', '�������', '������', '�������');

const MonthListOld: array[1..12] of String = ('1 �����',   '2 ������',  '�������',   '4 ������',   '5 �������',  '���������',
                                              '7 �������', '8 �������', '9 �������', '10 �������', '11 �������', '���');

const MonthListOld2: array[1..12] of String = ('1 �����',   '2 ������',  '3 ������',   '4 ������',   '5 �������',  '6 �������',
                                               '7 �������', '8 �������', '9 �������',  '10 �������', '11 �������', '12 �������');

implementation

uses FunConst, FunText, FunRx, Types;


{==============================================================================}
{========================   �������� ���� � �������   =========================}
{==============================================================================}
function ValidDateTime(const S: String): Boolean;
begin
    Result := false;
    If S='' then Exit;
    try    StrToDateTime(S);
           Result := true;
    except Result := false;
    end;
end;



{==============================================================================}
{===========================    �������� ����    ==============================}
{==============================================================================}
function ValidDate(const S: String): Boolean;
begin
    Result := false;
    If S='' then Exit;
    try    StrToDate(S);
           Result := true;
    except Result := false;
    end;
end;


{==============================================================================}
{==========================    �������� �������    ============================}
{==============================================================================}
function ValidTime(const S: String): Boolean;
begin
    Result := false;
    If S='' then Exit;
    try    StrToTime(S);
           Result := true;
    except Result := false;
    end;
end;


{==============================================================================}
{=================    ������� �� ����/������� �������    ======================}
{==============================================================================}
function DelSecond(const FDateTime: TDateTime): TDateTime;
var Years0,  Months0,  Days0,  Hours0,  Minuts0,  Sec0,  MSec0:  Word;
begin
    {�������������}
    DecodeDateTime(FDateTime, Years0, Months0, Days0, Hours0, Minuts0, Sec0, MSec0);
    Result:=EncodeDateTime(Years0, Months0, Days0, Hours0, Minuts0, 0, 0);
end;


{******************************************************************************}
{*********************  �������� �� ���� ��� � ������� 2000  ******************}
{******************************************************************************}
function CutYear(const FDate: TDateTime): String;
var Year, Month, Day: Word;
begin
    DecodeDate(FDate, Year, Month, Day);
    Result:=IntToStr(Year);
end;


{******************************************************************************}
{*****************   �������� �� ������� ���� � ������� 00   ******************}
{******************************************************************************}
function CutHour(const FTime: TDateTime): String;
var Hour, Min, Sec, MSec: Word;
begin
    DecodeTime(FTime, Hour, Min, Sec, MSec);
    Result:=IntToStr(Hour);
    If Length(Result)=1 then Result:='0'+Result;
end;


{******************************************************************************}
{***************   �������� �� ������� ������ � ������� 00   ******************}
{******************************************************************************}
function CutMinut(const FTime: TDateTime): String;
var Hour, Min, Sec, MSec: Word;
begin
    DecodeTime(FTime, Hour, Min, Sec, MSec);
    Result:=IntToStr(Min);
    If Length(Result)=1 then Result:='0'+Result;
end;


{==============================================================================}
{===============  �������� �� STR-���� ��� � ������� 0000  ====================}
{==============================================================================}
function CutYearStr(const Str: String): String;
var Year, Month, Day: Word;
begin
    Result:='';
    If Str='' then Exit;
    DecodeDate(StrToDate(CutDateStr(Str)), Year, Month, Day);
    Result:=IntToStr(Year);
end;


{==============================================================================}
{==============  �������� �� STR-������� ���� � ������� 00  ===================}
{==============================================================================}
function CutHourStr(const Str: String): String;
var H,M,Sec,MSec: Word;
begin
    Result:='';
    If Str='' then Exit;
    DecodeTime(StrToTime(CutTimeStr(Str)), H, M, Sec, MSec);
    If H > 9 then Result:=IntToStr(H) else Result:='0'+IntToStr(H);
end;


{==============================================================================}
{==============  �������� �� STR-������� ������ � ������� 00  =================}
{==============================================================================}
function CutMinutStr(const Str: String): String;
var H,M,Sec,MSec: Word;
begin
    Result:='';
    If Str='' then Exit;
    DecodeTime(StrToTime(CutTimeStr(Str)), H, M, Sec, MSec);
    If M > 9 then Result:=IntToStr(M) else Result:='0'+IntToStr(M);
end;


{==============================================================================}
{==================  �������� �� STR-����/������� ����  =======================}
{==============================================================================}
{==================  ���� � ����� �/� � ����� ��������  =======================}
{==============================================================================}
function CutDateStr(const Str: String): String;
var I: Integer;
begin
    {�������������}
    Result:=Str;

    {����������� ������� :}
    I:=Pos(':', Str);
    If I>0 then begin Result:=Trim(Copy(Str, 1, I-3)); Exit; end;

    {����������� ������� �}
    I:=Pos('�', Str); If I=0 then I:=Pos('�', Str);
    If I>0 then Result:=Trim(Copy(Str, 1, I-4));
end;


{==============================================================================}
{==================  �������� �� STR-����/������� �����  ======================}
{==============================================================================}
{==================  ���� � ����� �/� � ����� ��������   ======================}
{==============================================================================}
function CutTimeStr(const Str: String): String;
var I: Integer;
begin
    {�������������}
    Result:=Str;

    {����������� ������� :}
    I:=Pos(':', Str);
    If I>0 then begin Result:=Trim(Copy(Str, I-2, 20)); Exit; end;

    {����������� ������� �}
    I:=Pos('�', Str); If I=0 then I:=Pos('�', Str);
    If I>0 then Result:=Trim(Copy(Str, I-3, 20));
end;


{==============================================================================}
{================    ����������� ����/������� (STRING)   ======================}
{==============================================================================}
{================    ����:  [1.5.2008  ] 9:5:8           ======================}
{================    �����: [01.05.2008] 09:05           ======================}
{==============================================================================}
function CorrectDateTimeStr(const SDateTime: String): String;
var SDate, STime, S1, S2: String;
begin
    {�������������}
    If GetColSlov(SDateTime, ' ')=2 then begin
       SDate := CutSlovo(SDateTime, 1, ' ');
       STime := CutSlovo(SDateTime, 2, ' ');
    end else begin
       If Pos(':', SDateTime)=0 then begin SDate:=SDateTime; STime:=''; end
                                else begin SDate:=''; STime:=SDateTime; end;
    end;

    {������������ ����}
    If Length(SDate)>=8 then begin
       S1 := CutSlovo(SDate, 1, '.');   // ����
       S2 := CutSlovo(SDate, 2, '.');   // �����
       If Length(S2)=1 then Insert('0', SDate, Length(S1+'.')+1);
       If Length(S1)=1 then Insert('0', SDate, 1);
    end else SDate:='';

    If Length(STime)>=3 then begin
       S1 := CutSlovo(STime, 1, ':');   // ����
       S2 := CutSlovo(STime, 2, ':');   // ������
       If Length(S2)=1 then Insert('0', STime, Length(S1+':')+1);
       If Length(S1)=1 then Insert('0', STime, 1);
       Delete(STime, 6, 20);
    end else STime:='';

    {���������� ���� � �����}
    If (SDate<>'') and (STime<>'') then Result:=SDate+' '+STime
                                   else Result:=SDate+STime;
end;


{******************************************************************************}
{********************  ��������� ����/������� �� +1, -2  **********************}
{******************************************************************************}
function DateTimeCorrect(const T0: TDateTime; const DYears, DMonths, DDays, DHours, DMinuts: Integer): TDateTime;
begin
    Result:=IncDate(T0, DDays, DMonths, DYears);
    Result:=IncTime(Result, DHours, DMinuts, 0, 0);
end;


{******************************************************************************}
{***********  ����� ���, �������, ����, ����� ����� ����� ������  *************}
{******************************************************************************}
procedure DateTimeDiff0(const Date1, Date2: TDateTime; var Hours, Days, Months, Years: Integer);
var Years1,  Months1,  Days1,  Hours1,  Minuts1,  Sec1,  MSec1:  Word;
    Years2,  Months2,  Days2,  Hours2,  Minuts2,  Sec2,  MSec2:  Word;
    WYears,  WMonths,  WDays   : Word;
    IHours                     : Integer;
    Date_,  Date1_,    Date2_  : TDateTime;
    Invert_                    : Integer;
begin
    {������� ������ ���� ���� Date1, � ����� Date2}
    If CompareDateTime(Date1, Date2)=GreaterThanValue then begin
       Date_   := Date2;
       Date2_  := Date1;
       Date1_  := Date_;
       Invert_ := -1;
    end else begin
       Date1_  := Date1;
       Date2_  := Date2;
       Invert_ := 1;
    end;

    {�������������}
    DecodeDate(Date1_, Years1, Months1, Days1);
    DecodeTime(Date1_, Hours1, Minuts1, Sec1, MSec1);
    DecodeDate(Date2_, Years2, Months2, Days2);
    DecodeTime(Date2_, Hours2, Minuts2, Sec2, MSec2);

    {=========  ���������� ������� ����� ������: ���, �����, ����  ============}
    DateDiff(Date1_, Date2_, WDays, WMonths, WYears);

    {==============  ���������� ������� ����� ������: ����   ==================}
    {���� ������� ����� �����, �� ��������� ����� ����}
    If Hours1>Hours2 then begin
       Date2_ := IncDay(Date2_, -1);
       {�������� ���}
       DecodeDate(Date2_, Years2, Months2, Days2);
       DateDiff(Date1_, Date2_, WDays, WMonths, WYears);

       IHours := Integer(Hours1) - 24;
    end else begin
       IHours := Hours1;
    end;
    Hours := Hours2-IHours;

    {��������� ��������}
    Days   := Integer(WDays)   * Invert_;
    Months := Integer(WMonths) * Invert_;
    Years  := Integer(WYears)  * Invert_;
    Hours  := Hours            * Invert_;
end;


{******************************************************************************}
{************************  ������� � ������ �������  **************************}
{******************************************************************************}
function SecondToTime(const Seconds: Cardinal): Double;
const SecPerDay    = 86400;
      SecPerHour   = 3600;
      SecPerMinute = 60;
var ms, ss, mm, hh, dd: Cardinal;
begin
    dd := Seconds div SecPerDay;
    hh := (Seconds mod SecPerDay) div SecPerHour;
    mm := ((Seconds mod SecPerDay) mod SecPerHour) div SecPerMinute;
    ss := ((Seconds mod SecPerDay) mod SecPerHour) mod SecPerMinute;
    ms := 0;
    Result := dd + EncodeTime(hh, mm, ss, ms);
end;



{==============================================================================}
{ ������: '01.01.2000+StrEnd 01:02' �� '01 ������ 2000+StrEnd+01 ���. 02 ���.' }
{==============================================================================}
function SDateTimeToStr(const S: String; const Prm: array of String): String;
var StrEnd: String;
begin
    {�������������}
    If Length(Prm)>0 then StrEnd:=Prm[0]
                     else StrEnd:='�.';

    Result:=SDateToStr(S, StrEnd)+' '+STimeToStr(S);
end;


{==============================================================================}
{====== ������: '01.01.2000+StrEnd' �� '01 ������ 2000+StrEnd' ================}
{==============================================================================}
function SDateToStr(const S, StrEnd: String): String;
var S0: String;
begin
     S0:=CutDateStr(S);
     Result:=S0;
     if Length(S0)<8 then Exit;
     if IsIntegerStr(S0[4]+S0[5]) = false then Exit;

     if (S0='  .  .') or (S0='  .  .'+'    ') or
        (S0='__.__.') or (S0='__.__.____')    then begin
        Result:= '"___" ____________ 20___' + StrEnd;
        Exit;
     end;

     Result:= S0[1]+S0[2]+' ';
     case StrToInt(S0[4]+S0[5]) of
        1:  Result:=Result+'������';
        2:  Result:=Result+'�������';
        3:  Result:=Result+'�����';
        4:  Result:=Result+'������';
        5:  Result:=Result+'���';
        6:  Result:=Result+'����';
        7:  Result:=Result+'����';
        8:  Result:=Result+'�������';
        9:  Result:=Result+'��������';
        10: Result:=Result+'�������';
        11: Result:=Result+'������';
        12: Result:=Result+'�������';
        else begin
            Result:=S0; Exit;
        end;
     end;

     if Length(S0)>8 then Result:=Result+' '+S0[7]+S0[8]+S0[9]+S0[10]+StrEnd
                     else Result:=Result+' '+Year2To4(S0[7]+S0[8]) +StrEnd;
end;



{==============================================================================}
{================   �� ������� 00:00 ---> 00 ���. 00 ���.   ===================}
{==============================================================================}
function STimeToStr(const S: String): String;
var S0: String;
begin
    {�������������}
    S0:=CutTimeStr(S);

    {�������������� ��� ���������� ���������}
    If S0='' then begin
       Result:='__ ���. __ ���.';
       Exit;
    end;

    {��������� ������}
    Result:=CutHourStr(S0)+' ���. '+CutMinutStr(S0)+' ���.';
end;



{==============================================================================}
{========================== ������: 00 �� 2000 ================================}
{==============================================================================}
function Year2To4(const S: String): String;
begin Result:=S;
    if S='' then Exit;
    if (S[1]='0')or(S[1]='1') then Result:='20'+S[1]+S[2]
                              else Result:='19'+S[1]+S[2];
end;


{==============================================================================}
{=====================  ������� ������� ������ � ������  ======================}
{==============================================================================}
function MonthIndToStr(const IMonth: Integer): String;
begin
    Result:='';
    If (IMonth<Low(MonthList)) or (IMonth>High(MonthList)) then Exit;
    Result:=MonthList[IMonth];
end;


{==============================================================================}
{====================  ������� �������� ������ � ������  ======================}
{==============================================================================}
function MonthStrToInd(const SMonth: String): Integer;
var I: Integer;
begin
    Result:=0;
    For I:=Low(MonthList) to High(MonthList) do begin
       If CmpStr(MonthList[I], SMonth) then begin
          Result:=I;
          Break;
       end;
    end;
end;


{==============================================================================}
{====================  ������� �������� ������ � ������  ======================}
{==============================================================================}
{====================  2 ������  --> 2                   ======================}
{====================  ��������� --> 6                   ======================}
{====================  6 ������� --> 6                   ======================}
{==============================================================================}
function MonthOldStrToInd(const SMonth: String): Integer;
var I: Integer;
begin
    Result:=0;
    For I:=Low(MonthListOld) to High(MonthListOld) do begin
       If CmpStr(MonthListOld[I], SMonth) then begin
          Result:=I;
          Break;
       end;
    end;
    If Result>0 then Exit;

    For I:=Low(MonthListOld2) to High(MonthListOld2) do begin
       If CmpStr(MonthListOld2[I], SMonth) then begin
          Result:=I;
          Break;
       end;
    end;
    If Result>0 then Exit;

    Result:=MonthStrToInd(SMonth);
end;


{==============================================================================}
{==================  ���������� ������� �������� ������   =====================}
{==============================================================================}
function NullPeriod(var SYear, SMonth: String): Boolean;
var Date0: TDate;
    IYear, IMonth, IDay: Word;
begin
    try
       DecodeDate(Date, IYear, IMonth, IDay);
       {���� ����� �� ���������� �����}
       If IDay<20 then begin
          Date0:=IncDate(Date, 0, -1, 0);
          DecodeDate(Date0, IYear, IMonth, IDay);
       end;

       {������������ ���������}
       Result := true;
       SYear  := IntToStr(IYear);
       SMonth := MonthIndToStr(IMonth);
    except
       Result := false;
       SYear  := '';
       SMonth := '';
    end;
end;


{==============================================================================}
{=============================  ���� �������  =================================}
{==============================================================================}
function SDatePeriod(const SYear, SMonth: String): TDate;
begin
    {�������������}
    Result:=0;
    If (SYear='') or (SMonth='') then Exit;
    try Result:=IDatePeriod(StrToInt(SYear), MonthStrToInd(SMonth));
    finally
    end;
end;

function IDatePeriod(const IYear, IMonth: Integer): TDate;
begin
    Result:=EncodeDate(IYear, IMonth, 20);
end;


{==============================================================================}
{==========================  ������������ ������  =============================}
{==============================================================================}
function CorrectPeriod(const SYear, SMonth: String; const DMonth: Integer): TDate;
var IYear, IMonth : Word;
begin
    {�������������}
    Result := 0;
    try
       IYear  := StrToInt(SYear);
       IMonth := MonthStrToInd(SMonth);
       Result := IncDate(EncodeDate(IYear, IMonth, 1), 0, DMonth, 0);
    finally
    end;
end;


{==============================================================================}
{====================  ������������ ��� � ����� �������  ======================}
{==============================================================================}
function CorrectPeriodStr(var SYear, SMonth: String; const DMonth: Integer): Boolean;
var IYear, IMonth, IDay : Word;
    Date_               : TDate;
begin
    {�������������}
    Result := false;
    try
       Date_ := CorrectPeriod(SYear, SMonth, DMonth);
       If Date_ = 0 then Exit;
       DecodeDate(Date_, IYear, IMonth, IDay);
       SYear  := IntToStr(IYear);
       SMonth := MonthIndToStr(IMonth);
       Result := true;
    finally
    end;
end;


end.

