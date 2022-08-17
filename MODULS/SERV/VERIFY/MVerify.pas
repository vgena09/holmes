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
{================================  СИНОНИМЫ  ==================================}
{==============================================================================}
function TFVerify.GetSinonim(const VStr: String): String;
var WordApp, WordDoc : Variant;
begin
    {Инициализация переменных}
    Result:=VStr;
    WordApp := CreateOleObject('Word.Application');
    WordDoc := WordApp.Documents.Add;

    {Помещаем текст в WORD}
    WordApp.Selection.TypeText(VStr);

    {Вызываем окно диалога}
    WordApp.Selection.Range.CheckSynonyms;

    {Читаем текст WORD}
    WordApp.Selection.Start:=0;
    WordApp.Selection.End:=999999999;
    Result:=WordApp.Selection.Text;
    ShowMessage(Result);

    {Закрыть WORD}
    WordApp.Quit(false);
end;

{==============================================================================}
{==================  ПРОВЕРКА  ОРФОГРАФИИ  И  ГРАММАТИКИ  =====================}
{==============================================================================}


{******************************************************************************}
{*************************  ДЛЯ ВНЕШНЕГО ВЫЗОВА  ******************************}
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

    {Положение ошибочного слова в тексте}
    procedure PosWordInText;
    var I0, ILeft: Integer;
    begin
       {Выделяем ошибочное слово}
       WordErrors.Item(IErr).Select;

       {Определяем левую границу фрагмента с ошибочным словом посредине}
       I0:=WordApp.Selection.Start;
       I0:=I0-LENFIELDS;
       If I0<0 then begin
          ILeft:=LENFIELDS+I0;
          I0:=0;
       end else begin
          ILeft:=LENFIELDS;
       end;
       WordApp.Selection.Start:=I0;

       {Определяем правую границу фрагмента с ошибочным словом посредине}
       WordApp.Selection.End:=WordApp.Selection.End+LENFIELDS;

       {Формируем фрагмент}
       REdit.Lines.Clear;
       REdit.Lines.Add(WordApp.Selection.Text);
       REdit.SelStart:=ILeft;
       REdit.SelLength:=Length(StrErr);
       REdit.SelAttributes.Color:=clRed;
       REdit.SelAttributes.Style:=[fsBold]; //,fsUnderline
       //REdit.SelLength:=0; - не обязательно, если enabled = false
    end;

begin
    {Инициализация переменных}
    Result:='';
    IPos:=0;
    WordApp := CreateOleObject('Word.Application');
    WordDoc := WordApp.Documents.Add;

    {Помещаем текст в WORD}
    WordApp.Selection.TypeText(VStr);

    {**************************************************************************}
    {*******************  Встроенный интерфейс проверки  **********************}
    {**************************************************************************}
    If IsMyInterface=true then begin
       {Проверка орфографии}
       if IsOrfo then begin
Nx:       {Инициализация}
          IsNxt:=false;
          WordApp.Selection.Start:=IPos;
          WordApp.Selection.End:=999999999;

          {Ошибки орфографии}
          WordErrors := WordApp.Selection.Range.SpellingErrors;
          For IErr:= 1 to WordErrors.Count do begin
             {Ошибочный текст}
             StrErr := WordErrors.Item(IErr).Text;
             If StrErr = '' then Continue;

             {Положение ошибочного слова в тексте}
             PosWordInText;

             {Выделяем ошибочное слово}
             WordErrors.Item(IErr).Select;

             {Cлова для замены}
             WordVariants := WordApp.GetSpellingSuggestions(StrErr);

             {Список вариантов замены}
             ListVariants.Items.Clear;
             for I:=1 to WordVariants.Count do begin
                      ListVariants.Items.Add(VarToStr(WordVariants.Item(I).Name));
             end;
             ListVariants.ItemIndex := 0;
             ListVariantsClick(Self);

             {Диалоговое окно}
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

          {Следующая интерация}
          If IsNxt=true then Goto Nx;
       end;

       {Проверка граматики}
       if IsGramm then begin
          //Блок проверки грамматики текста не разработан
       end;

    end else begin
       {***********************************************************************}
       {********************  Внешний интерфейс проверки  *********************}
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

    {Читаем текст WORD}
    WordApp.Selection.Start:=0;
    WordApp.Selection.End:=999999999;
    Result:=CutEndStr(WordApp.Selection.Text);

    {Закрыть WORD}
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
