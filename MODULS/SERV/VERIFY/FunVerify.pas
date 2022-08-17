unit FunVerify;

interface

uses
   Forms, Controls, 
   Windows, Messages, SysUtils, Variants, Classes;

   function VerifyText(const VStr: String; const IsOrfo, IsGramm, IsMyInterface: Boolean): String;

implementation

uses FunConst, MVerify;

{==============================================================================}
{=================    œ–Œ¬≈– ¿ Œ–‘Œ√–¿‘»» » √–¿ÃÃ¿“» »    =====================}
{==============================================================================}
function VerifyText(const VStr: String; const IsOrfo, IsGramm, IsMyInterface: Boolean): String;
var F: TFVerify;
begin
    F:=TFVerify.Create(Application);
    try     Result:=F.Verify(VStr, IsOrfo, IsGramm, IsMyInterface);
    finally F.Free;
    end;
end;

end.
