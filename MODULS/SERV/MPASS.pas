unit MPASS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.ActnList;

type
  TFPASS = class(TForm)
    PBottom: TPanel;
    BtnClose: TBitBtn;
    BtnOk: TBitBtn;
    POld: TPanel;
    LOld: TLabel;
    EOld: TEdit;
    PNew: TPanel;
    LNew: TLabel;
    ENew: TEdit;
    PNew2: TPanel;
    LNew2: TLabel;
    ENew2: TEdit;
    Bevel1: TBevel;
    AList: TActionList;
    AOk: TAction;
    ACancel: TAction;
    procedure FormCreate(Sender: TObject);
    procedure AOkExecute(Sender: TObject);
    procedure ACancelExecute(Sender: TObject);
    procedure EChange(Sender: TObject);
    procedure EKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private

  public
     function Execute(var SOld, SNew: String): Boolean;
  end;

var
  FPASS: TFPASS;

implementation

{$R *.dfm}

{==============================================================================}
{============================   —Œ«ƒ¿Õ»≈ ‘Œ–Ã€    =============================}
{==============================================================================}
procedure TFPASS.FormCreate(Sender: TObject);
begin
    EOld.Text  := ''; EOld .PasswordChar := '*';
    ENew.Text  := ''; ENew .PasswordChar := '*';
    ENew2.Text := ''; ENew2.PasswordChar := '*';

    EOld.OnChange  := EChange;  EOld.OnKeyDown  := EKeyDown;
    ENew.OnChange  := EChange;  ENew.OnKeyDown  := EKeyDown;
    ENew2.OnChange := EChange;  ENew2.OnKeyDown := EKeyDown;
end;


{******************************************************************************}
{*************************   ¬Õ≈ÿÕﬂﬂ ‘”Õ ÷»ﬂ    *******************************}
{******************************************************************************}
function TFPASS.Execute(var SOld, SNew: String): Boolean;
begin
    EChange(nil);
    If ShowModal = mrOk then begin
       SOld := EOld.Text;
       SNew := ENew.Text;
       Result := true;
    end else begin
       SOld := '';
       SNew := '';
       Result := false;
    end;
end;


{==============================================================================}
{===========================  TEXT: ON_CHANGE    ==============================}
{==============================================================================}
procedure TFPASS.EChange(Sender: TObject);
var Color: TColor;
begin
    AOk.Enabled := (ENew.Text = ENew2.Text) and (ENew.Text <> EOld.Text);
    If ENew.Text = ENew2.Text then Color := clWindowText
                              else Color := clRed;
    ENew .Font.Color := Color;
    ENew2.Font.Color := Color;
end;


{==============================================================================}
{==========================   TEXT: ON_KEY_DOWN   =============================}
{==============================================================================}
procedure TFPASS.EKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    27: {ESC} ModalResult := mrCancel;
    end;
end;


{==============================================================================}
{================================   ACTION    =================================}
{==============================================================================}
procedure TFPASS.AOkExecute(Sender: TObject);
begin
    ModalResult := mrOk;
end;

procedure TFPASS.ACancelExecute(Sender: TObject);
begin
    ModalResult := mrCancel;
end;




end.
