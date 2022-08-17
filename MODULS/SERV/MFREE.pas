unit MFREE;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TFFREE = class(TForm)
    BtnOk : TBitBtn;
    PMain : TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private

  public
    procedure Execute(VFormClass: TFormClass; const SCaption: String);
  end;

var
  FFREE: TFFREE;

implementation

uses FunVcl, FunIni;

{$R *.dfm}

{******************************************************************************}
{****************************  ¬Õ≈ÿÕﬂﬂ ‘”Õ ÷»ﬂ  *******************************}
{******************************************************************************}
procedure TFFREE.Execute(VFormClass: TFormClass; const SCaption: String);
begin
    If VFormClass = nil then Exit;
    LoadSubForm(PMain, VFormClass, true);
    Caption := SCaption;
    ShowModal();
    LoadSubForm(PMain, nil, true);
end;


procedure TFFREE.FormCreate(Sender: TObject);
begin
    Position := poScreenCenter;
    LoadFormIni(Self, [fspPosition]);
    BtnOk.ModalResult := mrOk;
end;

procedure TFFREE.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    SaveFormIni(Self, [fspPosition]);
end;


end.
