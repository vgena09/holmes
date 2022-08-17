unit FunRichEdit;

interface

uses Winapi.Windows, Winapi.CommCtrl, Winapi.Messages,
     System.SysUtils, System.Classes, System.IniFiles,
     Vcl.Dialogs, Vcl.ComCtrls, Vcl.Graphics,
     RichEdit,
     FunType;

{ÖÂÅÒ È ÔÎÍ ÂÛÄÅËÅÍÍÎÃÎ ÔÐÀÃÌÅÍÒÀ}
procedure RichEditSetColor(const P: PRichEdit; const cFont, cBack: TColor; const IsBold: Boolean = false);
{ÑÊÐÎËËÈÍÃ ÄÎ ÊÓÐÑÎÐÀ}
procedure RichEditScrollToCursor(const P: PRichEdit; const IsVisible: Boolean);
{ÏÎÈÑÊ È ÂÛÄÅËÅÍÈÅ}
function RichEditFindSel(const P: PRichEdit; const SFind: String; const IsNext: Boolean): Boolean;

implementation

//uses FunConst;

{==============================================================================}
{=================     ÖÂÅÒ È ÔÎÍ ÂÛÄÅËÅÍÍÎÃÎ ÔÐÀÃÌÅÍÒÀ    ====================}
{==============================================================================}
procedure RichEditSetColor(const P: PRichEdit; const cFont, cBack: TColor; const IsBold: Boolean = false);
var Fmt: TCharFormat2;
begin
    FillChar(Fmt, SizeOf(Fmt), 0);
    With Fmt do begin
       cbSize := SizeOf(Fmt);
       dwMask := CFM_BACKCOLOR;
       crBackColor := cBack;
    end;
    With P^ do begin
       Perform(EM_SETCHARFORMAT, SCF_SELECTION, LPARAM(@Fmt));
       SelAttributes.Color := cFont;
       If IsBold then SelAttributes.Style := SelAttributes.Style + [fsBold]
                 else SelAttributes.Style := SelAttributes.Style - [fsBold];
    end;
end;


{==============================================================================}
{========================     ÑÊÐÎËËÈÍÃ ÄÎ ÊÓÐÑÎÐÀ    =========================}
{==============================================================================}
procedure RichEditScrollToCursor(const P: PRichEdit; const IsVisible: Boolean);
begin
    With P^ do begin
       Perform(EM_SCROLLCARET, 0, 0);
       If IsVisible then SetFocus;
       SendMessage(Handle, WM_KEYDOWN, VK_RIGHT, 0);
       SendMessage(Handle, WM_KEYDOWN, VK_LEFT,  0);
    end;
end;


{==============================================================================}
{==========================     ÏÎÈÑÊ È ÂÛÄÅËÅÍÈÅ    ==========================}
{==============================================================================}
function RichEditFindSel(const P: PRichEdit; const SFind: String; const IsNext: Boolean): Boolean;
var IOld, IPos, I, ILen: Integer;
begin
    Result := false;
    ILen   := Length(P^.Lines.CommaText);
    IOld   := P^.SelStart;
    I      := -1;

    {Ïîèñê âïåðåä}
    If IsNext then begin
       IPos := P^.FindText(SFind, IOld + 1, ILen, []);

    {Ïîèñê íàçàä}
    end else begin
       repeat IPos := I;
              I := P^.FindText(SFind, IPos + 1, ILen, []);
       until  (I >= IOld) or (I = -1);
    end;

    {Âûäåëÿåì}
    If IPos > -1 then begin
       P^.SelStart  := IPos;
       P^.SelLength := Length(SFind);
       RichEditScrollToCursor(P, true);
       P^.SelStart  := IPos;
       P^.SelLength := Length(SFind);
       Result       := true;
    end;
end;

end.

