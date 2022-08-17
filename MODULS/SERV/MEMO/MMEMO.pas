unit MMEMO;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ActnList, Vcl.DBCtrls,
  Data.DB, Data.Win.ADODB,
  FunType, MAIN;

type
  TFMEMO = class(TForm)
    Edit: TRichEdit;
    PBottom: TPanel;
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    BtnVerify: TBitBtn;
    AList: TActionList;
    AVerify: TAction;
    EditDB: TDBRichEdit;
    AWord: TAction;
    BtnWord: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AVerifyExecute(Sender: TObject);
    procedure AVerifyExecuteDB(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AWordExecute(Sender: TObject);
  private
    FFMAIN : TFMAIN;
    DS     : TDataSource;
    PData  : PADODataSet;
  public
    function  Execute(const SCaption: String; const SText: String; const IsReadOnly: Boolean): String;
    procedure ExecuteDB(const SCaption: String; const P: PADODataSet; const SField: String; const IsReadOnly: Boolean);
  end;

var
  FMEMO: TFMEMO;

implementation

uses FunConst, FunVcl, FunIni, FunSys, FunVerify, FunWord, FunClip;

{$R *.dfm}

{******************************************************************************}
{****************************  ¬Õ≈ÿÕﬂﬂ ‘”Õ ÷»ﬂ  *******************************}
{******************************************************************************}
function TFMEMO.Execute(const SCaption: String; const SText: String; const IsReadOnly: Boolean): String;
begin
    BtnCancel.Visible   := true;
    Caption             := SCaption;
    AVerify.Visible     := not IsReadOnly;
    AVerify.Enabled     := not IsReadOnly;
    AVerify.OnExecute   := AVerifyExecute;
    BtnOk.OnKeyDown     := EditKeyDown;
    BtnCancel.OnKeyDown := EditKeyDown;
    BtnCancel.Visible   := not IsReadOnly;
    EditDB.Visible      := false;
    Edit.Visible        := true;
    Edit.Align          := alClient;
    Edit.ReadOnly       := IsReadOnly;
    Edit.Lines.Text     := SText;
    Edit.SelStart       := 0;
    Edit.SelLength      := 0;
    DS                  := nil;
    If ShowModal() = mrOk then Result := Edit.Lines.Text
                          else Result := SText;
end;


procedure TFMEMO.ExecuteDB(const SCaption: String; const P: PADODataSet;
                           const SField: String;   const IsReadOnly: Boolean);
begin
    BtnCancel.Visible   := false;
    Caption             := SCaption;
    AVerify.Visible     := not IsReadOnly;
    AVerify.Enabled     := not IsReadOnly;
    AVerify.OnExecute   := AVerifyExecuteDB;
    BtnOk.OnKeyDown     := EditKeyDown;
    BtnCancel.OnKeyDown := EditKeyDown;
    BtnCancel.Visible   := not IsReadOnly;
    Edit.Visible        := false;
    EditDB.ScrollBars   := ssVertical;
    EditDB.Visible      := true;
    EditDB.Align        := alClient;
    EditDB.ReadOnly     := IsReadOnly;
    EditDB.DataSource   := DS;
    EditDB.SelStart     := 0;
    EditDB.SelLength    := 0;
    PData               := P;
    DS := TDataSource.Create(Self);
    try     DS.DataSet        := P^;
            EditDB.DataSource := DS;
            EditDB.DataField  := SField;
            ShowModal;
    finally DS.Free;
    end;
end;


{==============================================================================}
{=============================  —Œ«ƒ¿Õ»≈ ‘Œ–Ã€  ===============================}
{==============================================================================}
procedure TFMEMO.FormCreate(Sender: TObject);
begin
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    Position := poScreenCenter;
    LoadFormIni(Self, [fspPosition]);

    AList.Images := FFMAIN.ImgSys16;
    AVerify.ImageIndex    := ICO_VERIFY;
    BtnOk    .ModalResult := mrOk;
    BtnCancel.ModalResult := mrCancel;
    BtnVerify.Action      := AVerify;
    With Edit do begin
       Font.Name := 'Times New Roman';
       Font.Size := 15;
       WordWrap  := true;
       OnKeyDown := EditKeyDown;
    end;
    With EditDB do begin
       Font.Name := 'Times New Roman';
       Font.Size := 15;
       WordWrap  := true;
       OnKeyDown := EditKeyDown;
    end;
end;


{==============================================================================}
{===========================   –¿«–”ÿ≈Õ»≈ ‘Œ–Ã€    ============================}
{==============================================================================}
procedure TFMEMO.FormDestroy(Sender: TObject);
begin
    SaveFormIni(Self, [fspPosition]);
end;


{==============================================================================}
{===========================   ACTION: œ–Œ¬≈–»“‹   ============================}
{==============================================================================}
procedure TFMEMO.AVerifyExecute(Sender: TObject);
var S1, S2: String;
begin
    S1 := Edit.Lines.Text;
    S2 := VerifyText(S1, true, true, not ReadLocalBool(INI_SET, INI_SET_CHECK_WORD, false));
    If S1 = S2 then Exit;
    Edit.Lines.Text := S2;
    Edit.SelStart   := 0;
    Edit.SelLength  := 0;
end;

procedure TFMEMO.AVerifyExecuteDB(Sender: TObject);
var S1, S2: String;
begin
    S1 := EditDB.Lines.Text;
    S2 := VerifyText(S1, true, true, not ReadLocalBool(INI_SET, INI_SET_CHECK_WORD, false));
    If S1 = S2 then Exit;
    With PData^ do begin
       Edit;
       FieldByName(EditDB.DataField).AsString := S2;
       UpdateRecord;
       Post;
    end;
    EditDB.SelStart   := 0;
    EditDB.SelLength  := 0;
end;


{==============================================================================}
{========================   ACTION: œ≈–≈ƒ¿“‹ ¬ WORD   =========================}
{==============================================================================}
procedure TFMEMO.AWordExecute(Sender: TObject);
var S      : String;
    IsClip : Boolean;
begin
    {»ÌËˆË‡ÎËÁ‡ˆËˇ}
    AWord.Enabled := false;
    try
       {—Óı‡ÌËÏ Clipboard}
       IsClip:=SaveClipboard;

       {—ÓÁ‰‡ÂÏ Word}
       FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := 'ŒÚÍ˚ÚËÂ Word ...';
       CreateWord;
       AddDoc;

       {¬ÒÚ‡‚ÎˇÂÏ ‚ Word ÚÂÍÒÚ}
       If Edit.Visible then S := Edit.Text
                       else S := EditDB.Text;
       PasteTextDoc(S);
       AlignmentWText(3);
       FirstStrDoc(0);

       {œÓÍ‡Á˚‚‡ÂÏ Word}
       ScrollStartDoc;
       StartOfDoc;
       VisibleWord(true);

    finally
       FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := '';
       If IsClip then LoadClipboard else ClearClipboard;
       AWord.Enabled := true;
    end;
end;


{==============================================================================}
{============================   EDIT: KEY_DOWN   ==============================}
{==============================================================================}
procedure TFMEMO.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    27: {ESC} ModalResult := mrCancel;
    end;
end;


end.
