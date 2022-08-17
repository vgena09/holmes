unit FunWait;

interface

uses
   Forms, Controls, 
   Windows, Messages, SysUtils, Variants, Classes,
   MWAIT;

   procedure BeginWaitWnd(const SCaption, SText: String; const IsBar: Boolean);
   procedure ChangeWaitWnd(const SText: String; const I: Integer);
   procedure EndWaitWnd;

var FWait: TFWait;

implementation

//uses FunConst;

{==============================================================================}
{=======================   œŒ ¿«¿“‹ Œ ÕŒ Œ∆»ƒ¿Õ»ﬂ   ===========================}
{==============================================================================}
procedure BeginWaitWnd(const SCaption, SText: String; const IsBar: Boolean);
begin
    FWait:=TFWait.Create(nil);
    FWait.L1.Caption   := SCaption;
    FWait.L2.Caption   := SText;
    FWait.PBar.Visible := IsBar;
    ChangeWaitWnd(SText, 0);
    FWait.Show;
    Application.ProcessMessages;
end;


{==============================================================================}
{=======================   »«Ã≈Õ»“‹ Œ ÕŒ Œ∆»ƒ¿Õ»ﬂ   ===========================}
{==============================================================================}
procedure ChangeWaitWnd(const SText: String; const I: Integer);
begin
    If FWait=nil then Exit;
    If Not FWait.PBar.Visible then Exit;
    FWait.L2.Caption    := SText;
    //FWait.PBar.Caption  := IntToStr(I)+'%';
    FWait.PBar.Position := I;
    FWait.Refresh;
end;



{==============================================================================}
{========================   — –€“‹ Œ ÕŒ Œ∆»ƒ¿Õ»ﬂ   ===========================}
{==============================================================================}
procedure EndWaitWnd;
begin
    If FWait=nil then Exit;
    FWait.Close;
    FWait.Free;
    FWait:=nil;
    Application.ProcessMessages;
end;

end.
