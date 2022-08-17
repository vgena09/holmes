unit MVerify;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Variants,
  System.Win.ComObj,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.OleServer, Vcl.StdCtrls,
  Word2000;

type
  TFVerify = class(TForm)
    REdit: TRichEdit;
    Label1: TLabel;
    PMain: TPanel;
    PRight: TPanel;
    GBox: TGroupBox;
    BtnChange: TButton;
    BtnIgnore: TButton;
    BtnAbort: TButton;
    EdReplaceWith: TEdit;
    Label2: TLabel;
    ListVariants: TListBox;
    procedure ListVariantsClick(Sender: TObject);
    procedure BtnChangeClick(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);
    procedure EdReplaceWithChange(Sender: TObject);
    procedure ListVariantsDblClick(Sender: TObject);
  private
    SReplacedWord: String;
  public
     function GetSinonim(const VStr: String): String;
     function Verify(const VStr: AnsiString;
                     const IsOrfo, IsGramm, IsMyInterface: Boolean): AnsiString;
  end;

var
  FVerify: TFVerify;

implementation

uses FunText;

{$R *.dfm}



{==============================================================================}
{================================  ��������  ==================================}
{==============================================================================}
function TFVerify.GetSinonim(const VStr: String): String;
var WordApp, WordDoc : Variant;
begin
    {������������� ����������}
    Result:=VStr;
    WordApp := CreateOleObject('Word.Application');
    WordDoc := WordApp.Documents.Add;

    {�������� ����� � WORD}
    WordApp.Selection.TypeText(VStr);

    {�������� ���� �������}
    WordApp.Selection.Range.CheckSynonyms;

    {������ ����� WORD}
    WordApp.Selection.Start:=0;
    WordApp.Selection.End:=999999999;
    Result:=WordApp.Selection.Text;
    ShowMessage(Result);

    {������� WORD}
    WordApp.Quit(false);
end;

{==============================================================================}
{==================  ��������  ����������  �  ����������  =====================}
{==============================================================================}


{******************************************************************************}
{*************************  ��� �������� ������  ******************************}
{******************************************************************************}
function TFVerify.Verify(const VStr: AnsiString;
                         const IsOrfo, IsGramm, IsMyInterface: Boolean): AnsiString;
label Nx;
const LENFIELDS = 250;
var WordApp, WordDoc   : Variant;
    WordErrors         : Variant; //ProofreadingErrors;
    WordVariants       : Variant; //SpellingSuggestions;
    I, IErr, IPos      : Integer;
    StrErr             : String;
    IsNxt              : Boolean;

    {��������� ���������� ����� � ������}
    procedure PosWordInText;
    var I0, ILeft: Integer;
    begin
       {�������� ��������� �����}
       WordErrors.Item(IErr).Select;

       {���������� ����� ������� ��������� � ��������� ������ ���������}
       I0:=WordApp.Selection.Start;
       I0:=I0-LENFIELDS;
       If I0<0 then begin
          ILeft:=LENFIELDS+I0;
          I0:=0;
       end else begin
          ILeft:=LENFIELDS;
       end;
       WordApp.Selection.Start:=I0;

       {���������� ������ ������� ��������� � ��������� ������ ���������}
       WordApp.Selection.End:=WordApp.Selection.End+LENFIELDS;

       {��������� ��������}
       REdit.Lines.Clear;
       REdit.Lines.Add(WordApp.Selection.Text);
       REdit.SelStart:=ILeft;
       REdit.SelLength:=Length(StrErr);
       REdit.SelAttributes.Color:=clRed;
       REdit.SelAttributes.Style:=[fsBold]; //,fsUnderline
       //REdit.SelLength:=0; - �� �����������, ���� enabled = false
    end;

begin
    {������������� ����������}
    Result:='';
    IPos:=0;
    WordApp := CreateOleObject('Word.Application');
    WordDoc := WordApp.Documents.Add;

    {�������� ����� � WORD}
    WordApp.Selection.TypeText(VStr);

    {**************************************************************************}
    {*******************  ���������� ��������� ��������  **********************}
    {**************************************************************************}
    If IsMyInterface=true then begin
       {�������� ����������}
       if IsOrfo then begin
Nx:       {�������������}
          IsNxt:=false;
          WordApp.Selection.Start:=IPos;
          WordApp.Selection.End:=999999999;

          {������ ����������}
          WordErrors := WordApp.Selection.Range.SpellingErrors;
          For IErr:= 1 to WordErrors.Count do begin
             {��������� �����}
             StrErr := WordErrors.Item(IErr).Text;
             If StrErr = '' then Continue;

             {��������� ���������� ����� � ������}
             PosWordInText;

             {�������� ��������� �����}
             WordErrors.Item(IErr).Select;

             {C���� ��� ������}
             WordVariants := WordApp.GetSpellingSuggestions(StrErr);

             {������ ��������� ������}
             ListVariants.Items.Clear;
             for I:=1 to WordVariants.Count do begin
                      ListVariants.Items.Add(VarToStr(WordVariants.Item(I).Name));
             end;
             ListVariants.ItemIndex := 0;
             ListVariantsClick(Self);

             {���������� ����}
             case ShowModal of
             mrAbort:  Break;
             mrIgnore: Continue;
             mrOK:     if SReplacedWord <> '' then begin
                          WordApp.Selection.TypeText(SReplacedWord);
                          IsNxt:=true;
                          IPos:=WordApp.Selection.End+1;
                          Break;
                       end;
             else Break;
             end;
          end;

          {��������� ���������}
          If IsNxt=true then Goto Nx;
       end;

       {�������� ���������}
       if IsGramm then begin
          //���� �������� ���������� ������ �� ����������
       end;

    end else begin
       {***********************************************************************}
       {********************  ������� ��������� ��������  *********************}
       {***********************************************************************}
       if IsOrfo  then begin
          WordApp.Selection.Start:=0;
          WordApp.Selection.End:=999999999;
          WordApp.Options.CheckSpellingAsYouType := True;
          WordApp.Selection.Range.CheckSpelling;
          WordApp.Visible:=false;
       end;
       if IsGramm then begin
          WordApp.Selection.Start:=0;
          WordApp.Selection.End:=999999999;
          WordApp.Options.CheckGrammarAsYouType  := True;
          WordApp.Selection.Range.CheckGrammar;
          WordApp.Visible:=false;
       end;
    end;

    {������ ����� WORD}
    WordApp.Selection.Start:=0;
    WordApp.Selection.End:=999999999;
    Result:=CutEndStr(WordApp.Selection.Text);

    {������� WORD}
    WordApp.Quit(false);
end;

procedure TFVerify.ListVariantsClick(Sender: TObject);
begin
  if ListVariants.ItemIndex <> -1
  then EdReplaceWith.Text := ListVariants.Items[ListVariants.ItemIndex]
  else EdReplaceWith.Text := '';
  EdReplaceWithChange(Sender);
end;

procedure TFVerify.ListVariantsDblClick(Sender: TObject);
begin
    ListVariantsClick(Sender);
    If EdReplaceWith.Text <> '' then BtnChange.Click;
end;

procedure TFVerify.BtnChangeClick(Sender: TObject);
begin
    SReplacedWord := EdReplaceWith.Text;
end;

procedure TFVerify.BtnAbortClick(Sender: TObject);
begin
    SReplacedWord := '';
end;

procedure TFVerify.EdReplaceWithChange(Sender: TObject);
begin
    If EdReplaceWith.Text<>'' then BtnChange.Enabled:=true
                              else BtnChange.Enabled:=false;
end;

end.
