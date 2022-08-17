unit MCLOSE;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Imaging.jpeg,
  MAIN;

type
  TFCLOSE = class(TForm)
    ActionList1: TActionList;
    AExit: TAction;
    ACancel: TAction;
    Image1: TImage;
    PBottom: TPanel;
    BtnCancel: TBitBtn;
    BtnOk: TBitBtn;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure AExitExecute(Sender: TObject);
    procedure ACancelExecute(Sender: TObject);
  private
    FFMAIN           : TFMAIN;
  public
    function  Execute: Boolean;
  end;

var
  FCLOSE: TFCLOSE;

implementation

uses FunConst, FunSys, FunInfo, FunVcl, FunFiles, FunDay, FunText, FunIni;

{$R *.dfm}


{==============================================================================}
{============================   ¬Õ≈ÿÕ»… ¬€«Œ¬   ===============================}
{==============================================================================}
function TFCLOSE.Execute: Boolean;
begin
    Result := (ShowModal=mrOk);
end;


{==============================================================================}
{============================   —Œ«ƒ¿Õ»≈ ‘Œ–Ã€   ==============================}
{==============================================================================}
procedure TFCLOSE.FormCreate(Sender: TObject);
begin
    {»ÌËˆË‡ÎËÁ‡ˆËˇ}
    FFMAIN  := TFMAIN(GlFindComponent('FMAIN'));
    Caption := FFMAIN.Caption;
end;


{==============================================================================}
{======================   ACTION: ¬€’Œƒ »« œ–Œ√–¿ÃÃ€   ========================}
{==============================================================================}
procedure TFCLOSE.AExitExecute(Sender: TObject);
begin
    ModalResult := mrOk;
end;


{==============================================================================}
{===========================   ACTION: Œ“Ã≈Õ¿   ===============================}
{==============================================================================}
procedure TFCLOSE.ACancelExecute(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

end.
