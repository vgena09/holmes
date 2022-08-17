unit FunMemo;

interface
uses
   System.Classes, System.SysUtils,
   Vcl.Dialogs, Vcl.Controls,
   FunType;

{–≈ƒ¿ “»–Œ¬¿“‹ “≈ —“ MEMO}
function  EditMemo(const SCaption: String; const SText: String; const IsReadOnly: Boolean): String;
procedure EditMemoDB(const SCaption: String; const P: PADODataSet; const SField: String; const IsReadOnly: Boolean);

implementation

uses FunConst, MMEMO;

{==============================================================================}
{=========================   –≈ƒ¿ “»–Œ¬¿“‹ “≈ —“ MEMO   =======================}
{==============================================================================}
function EditMemo(const SCaption: String; const SText: String; const IsReadOnly: Boolean): String;
var F: TFMEMO;
begin
    Result := SText;
    F:=TFMEMO.Create(nil);
    try     Result := F.Execute(SCaption, SText, IsReadOnly);
    finally F.Free;
    end;
end;


{==============================================================================}
{========================   –≈ƒ¿ “»–Œ¬¿“‹ “≈ —“ DBMEMO   ======================}
{==============================================================================}
procedure EditMemoDB(const SCaption: String; const P: PADODataSet;
                     const SField: String;   const IsReadOnly: Boolean);
var F: TFMEMO;
begin
    F := TFMEMO.Create(nil);
    try     F.ExecuteDB(SCaption, P, SField, IsReadOnly);
    finally F.Free;
    end;
end;

end.

