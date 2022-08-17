unit MVAR_DATE;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Variants, System.DateUtils,
  Vcl.ActnList, Vcl.Forms, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Controls,
  Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Data.Win.ADODB,
  FunType, MAIN;

type
  TFVAR_DATE = class(TForm)
    Timer1: TTimer;
    BtnNow: TBitBtn;
    ActionList1: TActionList;
    ANow: TAction;
    PDate: TPanel;
    EDate: TDateTimePicker;
    PTime: TPanel;
    Panel1: TPanel;
    ETime: TDateTimePicker;
    Panel2: TPanel;
    PHour: TPanel;
    LHour: TLabel;
    BarHour: TTrackBar;
    PMin: TPanel;
    LMin: TLabel;
    BarMin: TTrackBar;
    LDay: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ANowExecute(Sender: TObject);
    procedure BarChange(Sender: TObject);
    procedure ETimeChange(Sender: TObject);
    procedure EDateChange(Sender: TObject);
  private
    FFMAIN : TFMAIN;
    PQVAR  : PADOQuery;
    PTSAV  : PADOTable;
    SType  : String;   // Тип переменной
    LParam : TStringList;
    procedure SaveVal;
  public
    procedure Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
  end;

const
    BTN_DATETIME = 'Установить текущие дату и время';
    BTN_DATE     = 'Установить текущую дату';
    BTN_TIME     = 'Установить текущее время';

var
  FVAR_DATE: TFVAR_DATE;

implementation

uses FunConst, FunSys, FunText, FunList, FunDay;

{$R *.dfm}

procedure TFVAR_DATE.Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
var SVal: String;
begin
    {Инициализация}
    PQVAR            := PPQVAR;
    PTSAV            := PPTSAV;
    LParam.Text      := PQVAR^.FieldByName(F_VAR_PARAM).AsString;
    SType            := LRead(@LParam, F_VAR_PARAM_DATE_TYPE, F_VAR_PARAM_KEY_DATETIME);
    SVal             := PQVAR^.FieldByName(F_VAR_VAL_STR).AsString;

    EDate.OnChange   := EDateChange;
    ETime.OnChange   := ETimeChange;
    BarHour.OnChange := BarChange;
    BarMin.OnChange  := BarChange;

    {Конфигурируем в зависимости от типа переменной}
    If CmpStr(SType, F_VAR_PARAM_KEY_DATETIME) then begin
       If ValidDateTime(SVal) then begin
          EDate.Date:=VarToDateTime(SVal);
          ETime.Time:=VarToDateTime(SVal);
       end else begin
          EDate.Date:=Now;
          ETime.Time:=Now;
       end;
    end;

    If CmpStr(SType, F_VAR_PARAM_KEY_DATE) then begin
       If ValidDate(SVal) then EDate.Date:=StrToDate(SVal) else EDate.Date:=Now;
       PTime.Visible := false;
    end;

    If CmpStr(SType, F_VAR_PARAM_KEY_TIME) then begin
       If ValidTime(SVal) then ETime.Time:=StrToTime(SVal) else ETime.Time:=Now;
       PDate.Visible := false;
    end;

    {Реакция на установку даты и времени}
    EDateChange(nil);
    ETimeChange(nil);

    {Разрешаем таймер}
    Timer1Timer(nil);
end;


{==============================================================================}
{==========================    СОЗДАНИЕ ФОРМЫ    ==============================}
{==============================================================================}
procedure TFVAR_DATE.FormCreate(Sender: TObject);
begin
    FFMAIN       := TFMAIN(GlFindComponent('FMAIN'));
    LParam       := TStringList.Create;
    EDate.Format := 'dd MMMM yyyy г.';
    EDate.Color  := FFMAIN.COLOR_SEL;    // не работает, сделаю потом
    ETime.Format := 'HH:mm';
    ETime.Color  := FFMAIN.COLOR_SEL;
    BarHour.Min  := 0; BarHour.Max := 23;
    BarMin.Min   := 0; BarMin.Max  := 59;
end;


{==============================================================================}
{=========================    РАЗРУШЕНИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFVAR_DATE.FormDestroy(Sender: TObject);
begin
    {Запрещаем таймер}
    Timer1.Enabled := false;

    {Записываем значение переменной}
    SaveVal;

    {Освобождаем память}
    LParam.Free;
end;


{==============================================================================}
{==================    СОБЫТИЕ: ИЗМЕНЕНИЕ EDate, ETime   ======================}
{==============================================================================}
procedure TFVAR_DATE.EDateChange(Sender: TObject);
begin
    LDay.Caption := FormatDateTime('dddd', EDate.Date);

    {Записываем значение переменной}
    SaveVal;
end;

procedure TFVAR_DATE.ETimeChange(Sender: TObject);
var NEvent : TNotifyEvent;
    S      : String;
begin
    If not IsStrInArray(SType, [F_VAR_PARAM_KEY_DATETIME, F_VAR_PARAM_KEY_TIME]) then Exit;

    {Корректирем ползунок часов}
    S:=CutHour(ETime.Time);
    If IsIntegerStr(S) then begin
       NEvent:=BarHour.OnChange;
       BarHour.OnChange := nil;
       BarHour.Position :=StrToInt(S);
       BarHour.OnChange := NEvent;
    end;

    {Корректирем ползунок минут}
    S:=CutMinut(ETime.Time);
    If IsIntegerStr(S) then begin
       NEvent:=BarMin.OnChange;
       BarMin.OnChange := nil;
       BarMin.Position := StrToInt(S);
       BarMin.OnChange := NEvent;
    end;

    {Записываем значение переменной}
    SaveVal;
end;


{==============================================================================}
{==================   СОБЫТИЕ: ИЗМЕНЕНИЕ BarHour, BarMin   ====================}
{==============================================================================}
procedure TFVAR_DATE.BarChange(Sender: TObject);
var NEvent : TNotifyEvent;
    Val    : TDateTime;
begin
     If not IsStrInArray(SType, [F_VAR_PARAM_KEY_DATETIME, F_VAR_PARAM_KEY_TIME]) then Exit;

    {Определяем новое значение}
    Val:=StrToTime(IntToStr(BarHour.Position)+':'+IntToStr(BarMin.Position));

    {Производим замену времени}
    If ETime.Time <> Val then begin
       NEvent:=ETime.OnChange;
       ETime.OnChange:=nil;
       ETime.Time:=Val;
       ETime.OnChange:=NEvent;
       {Записываем значение переменной}
       SaveVal;
    end;
end;


{==============================================================================}
{=========================    СОБЫТИЕ: ON_TIMER    ============================}
{==============================================================================}
procedure TFVAR_DATE.Timer1Timer(Sender: TObject);
begin
    Timer1.Enabled := false;
    If CmpStr(SType, F_VAR_PARAM_KEY_DATETIME) then ANow.Caption:=BTN_DATETIME+': '+CorrectDateTimeStr(DateTimeToStr(Now)); //DateTimeToStr(int(EDate.Date) + frac(ETime.Time)));
    If CmpStr(SType, F_VAR_PARAM_KEY_DATE)     then ANow.Caption:=BTN_DATE    +': '+CorrectDateTimeStr(DateToStr(Date));
    If CmpStr(SType, F_VAR_PARAM_KEY_TIME)     then ANow.Caption:=BTN_TIME    +': '+CorrectDateTimeStr(TimeToStr(Time));
    Timer1.Enabled := true;
end;

{==============================================================================}
{=====================    СОБЫТИЕ: НАЖАТИЕ НА КНОПКУ    =======================}
{==============================================================================}
procedure TFVAR_DATE.ANowExecute(Sender: TObject);
begin
    If CmpStr(SType, F_VAR_PARAM_KEY_DATE) or CmpStr(SType, F_VAR_PARAM_KEY_DATETIME) then EDate.Date := Date;
    If CmpStr(SType, F_VAR_PARAM_KEY_TIME) or CmpStr(SType, F_VAR_PARAM_KEY_DATETIME) then ETime.Time := Time;

    {Корректируем ползунки времени}
    ETimeChange(nil);
end;


{==============================================================================}
{=========================    СОХРАНИТЬ ЗНАЧЕНИЕ    ===========================}
{==============================================================================}
procedure TFVAR_DATE.SaveVal;
begin
    With PQVAR^ do begin
       Edit;
       If CmpStr(SType, F_VAR_PARAM_KEY_DATETIME) then FieldByName(F_VAR_VAL_STR).AsString:=CorrectDateTimeStr(DateTimeToStr(int(EDate.Date) + frac(ETime.Time)));
       If CmpStr(SType, F_VAR_PARAM_KEY_DATE)     then FieldByName(F_VAR_VAL_STR).AsString:=CorrectDateTimeStr(DateToStr(EDate.Date));
       If CmpStr(SType, F_VAR_PARAM_KEY_TIME)     then FieldByName(F_VAR_VAL_STR).AsString:=CorrectDateTimeStr(TimeToStr(ETime.Time));
       UpdateRecord;
       Post;
    end;
end;


end.
