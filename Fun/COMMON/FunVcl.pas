unit FunVcl;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes,
   Vcl.Forms, Vcl.Controls, Vcl.Dialogs, Vcl.ExtCtrls;

   function  LoadSubForm(ControlForm: TPanel; SubForm: TFormClass; const Update: Boolean): TForm;
   procedure ErrMsg(const Str: String);
   function  ForegroundWindow: Boolean;
   procedure BeginScreenUpdate(Hwnd: THandle);
   procedure EndScreenUpdate(Hwnd: THandle);


implementation

uses FunInfo;


{==============================================================================}
{============================= �������� �������� ==============================}
{==============================================================================}
function LoadSubForm(ControlForm: TPanel; SubForm: TFormClass; const Update: Boolean): TForm;
begin
    {�������������}
    Result:=nil;
    If Update then LockWindowUpdate(ControlForm.Handle);
    try
       if (ControlForm.ControlCount = 0) or not (ControlForm.Controls[0] is SubForm) then begin
          if ControlForm.ControlCount > 0 then begin
             TForm(ControlForm.Controls[0]).Hide;
             TForm(ControlForm.Controls[0]).Close;
             ControlForm.Controls[0].Free;
          end;
          if Assigned(SubForm) then begin
             Result := SubForm.Create(nil);
             Result.Hide;
             Result.BorderStyle := bsNone;
             Result.Parent := ControlForm;
             Result.Align := alClient;
             Result.Show;
          end;
       end;
    finally If Update then LockWindowUpdate(0);
    end;
end;


{==============================================================================}
{=========================   ��������� �� ������   ============================}
{==============================================================================}
procedure ErrMsg(const Str: String);
begin
    ForegroundWindow;
    MessageDlg(Str+Chr(13)+Chr(10)+Chr(13)+Chr(10)+
               '���������� ����������:'+Chr(13)+Chr(10)+
               GetProgLegalCopyright+Chr(13)+Chr(10)+
               GetProgComments, mtError, [mbOk], 0);
end;


{==============================================================================}
{===================   ���� ��������� �� �������� ����    =====================}
{==============================================================================}
function ForegroundWindow: Boolean;
begin
    Keybd_event(0,0,0,0);
    Result:=SetForegroundWindow(GetLastActivePopup(Application.Handle));
end;


{==============================================================================}
{==============  � � � � � � � � �   � � � � � � � �   � � � �  ===============}
{==============================================================================}
procedure BeginScreenUpdate(Hwnd: THandle);
begin
    LockWindowUpdate(Hwnd);
end;

procedure EndScreenUpdate(Hwnd: THandle);
begin
    LockWindowUpdate(0);
end;

end.

