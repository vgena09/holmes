{******************************************************************************}
{*******************  янблеярмши ббнд дюрш х бпелемх   ************************}
{******************************************************************************}
unit FunDateTimePicker;

interface
uses
   Winapi.Messages, // TWMNotify
   Winapi.CommCtrl, // DTN_DATETIMECHANGE
   System.SysUtils, // SystemTimeToDateTime
   Vcl.Controls,    // CN_NOTIFY
   Vcl.ComCtrls;    // TDateTimePicker

type
   TMyDateTimePicker = class(TDateTimePicker)
private
   procedure CNNotify(var Msg: TWMNotify); message CN_NOTIFY;
end;

implementation

procedure TMyDateTimePicker.CNNotify(var Msg: TWMNotify);
begin
    With Msg, NMHdr^ do begin
       Result := 0;
       If code = DTN_DATETIMECHANGE then begin
          With PNMDateTimeChange(NMHdr)^ do begin
             If dwFlags = GDT_VALID then DateTime := SystemTimeToDateTime(st);
          end;
          Change;
       end;
    end;
end;

end.