unit MVAR_REST;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Controls,
  Vcl.ImgList, Vcl.ExtCtrls, Vcl.Menus, Vcl.ActnList, Vcl.Graphics, Vcl.DBCtrls,
  Vcl.Dialogs,
  Data.DB, Data.Win.ADODB,
  FunConst, FunType, MAIN;

type
  TFVAR_REST = class(TForm)
    ActionList1: TActionList;
    AAdd: TAction;
    ADel: TAction;
    AEdit: TAction;
    AUp: TAction;
    ADown: TAction;
    PMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Grid: TStringGrid;
    BtnAdd: TBitBtn;

    {ÃÓ‰ÛÎ¸: MVAR_REST_GRID}
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure GridMouseEnter(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridDblClick(Sender: TObject);

    {ÃÓ‰ÛÎ¸: MVAR_REST}
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure AAddExecute(Sender: TObject);
    procedure ADelExecute(Sender: TObject);
    procedure AEditExecute(Sender: TObject);
    procedure AUpExecute(Sender: TObject);
    procedure ADownExecute(Sender: TObject);
    procedure PMenuPopup(Sender: TObject);

  private
    FFMAIN : TFMAIN;
    DS     : TDataSource;
    Q      : TADOQuery;
    PQVAR  : PADOQuery;
    PTSAV  : PADOTable;
    IDVar  : String;
    LVal   : TStringList;

    {ÃÓ‰ÛÎ¸: MVAR_REST_GRID}
    procedure IniGrid;
    procedure RefreshVal;
    procedure SaveVal;
    procedure LoadVal;

    {ÃÓ‰ÛÎ¸: MVAR_REST}
    procedure EnablAction;

  public
    procedure Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
  end;

const
  LField : array [0..1] of String = ('‘»Œ', '—Ú‡ÚÛÒ');

var
  FVAR_REST: TFVAR_REST;

implementation

uses FunSys, FunBD,
     MVAR_REST_ADD, MVAR_REST_EDIT;

{$R *.dfm}

{$INCLUDE MVAR_REST_GRID}

{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
{!!!!!!!!!!!  ¬ ÀŒ ¿À‹Õ€’ Õ¿—“–Œ… ¿’ —Œ’–¿Õﬂ≈Ã “ŒÀ‹ Œ Œ‘Œ–ÃÀ≈Õ»≈  !!!!!!!!!!!!!}
{!!!!!!!!!!!  Œ—“¿À‹ÕŒ≈ - ¬ ¡¿«≈ ƒ¿ÕÕ€’ ƒ≈À¿                      !!!!!!!!!!!!!}
{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}


{******************************************************************************}
{****************************  ¬Õ≈ÿÕﬂﬂ ‘”Õ ÷»ﬂ  *******************************}
{******************************************************************************}
procedure TFVAR_REST.Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
begin
    {»ÌËˆË‡ÎËÁ‡ˆËˇ}
    PQVAR := PPQVAR;
    PTSAV := PPTSAV;
    IDVar := PQVAR^.FieldByName(F_COUNTER).AsString;
    IniGrid;
    LoadVal;
end;



{==============================================================================}
{============================  —Œ«ƒ¿“‹ ‘Œ–Ã”  =================================}
{==============================================================================}
procedure TFVAR_REST.FormCreate(Sender: TObject);
begin
    {»ÌËˆË‡ÎËÁ‡ˆËˇ}
    FFMAIN        := TFMAIN(GlFindComponent('FMAIN'));
    Q             := TADOQuery.Create(Self);
    Q.Connection  := FFMAIN.BUD.BD;
    DS            := TDataSource.Create(Self);
    DS.DataSet    := Q;
    LVal          := TStringList.Create;
    LVal.Sorted   := false;

    BtnAdd.Action := AAdd;
    PMenu.OnPopup := PMenuPopup;

    OnDestroy     := FormDestroy;
    OnResize      := FormResize;
end;


{==============================================================================}
{==========================    –¿«–”ÿ»“‹ ‘Œ–Ã”    =============================}
{==============================================================================}
procedure TFVAR_REST.FormDestroy(Sender: TObject);
begin
    SaveVal;
    DS.Free;
    If Q.Active then Q.Close; Q.Free;
    LVal.Free;
end;


{==============================================================================}
{====================  ƒŒ—“”œÕŒ—“‹ ›À≈Ã≈Õ“Œ¬ ACTION  ==========================}
{==============================================================================}
procedure TFVAR_REST.EnablAction;
begin
    ADel .Enabled := Grid.Row > 0;
    AEdit.Enabled := Grid.Row > 0;
    AUp.Enabled   := Grid.Row > 1;
    ADown.Enabled := Grid.Row < (Grid.RowCount - 1);
end;


{==============================================================================}
{======================   ACTION: ƒŒ¡¿¬»“‹ ›À≈Ã≈Õ“   ==========================}
{==============================================================================}
procedure TFVAR_REST.AAddExecute(Sender: TObject);
var F : TForm;
    S : String;
begin
    {ÀÓÍ‡Î¸Ì˚Â ÔÂÂÏÂÌÌ˚Â}
    If PQVAR^.FieldByName(F_VAR_NAME).AsString <> F_VAR_NAME_REST0 then begin
       F := TFVAR_REST_ADD.Create(Self);
       try     If not TFVAR_REST_ADD(F).Execute(@LVal) then Exit;
       finally F.Free; end;

    {√ÎÓ·‡Î¸Ì˚Â ÔÂÂÏÂÌÌ˚Â}
    end else begin
       S := Trim(InputBox('ƒÓ·‡‚ËÚ¸', LField[Low(LField)], '')); If S = '' then Exit;
       LVal.Add(S);
       LVal.Add('ÔÓÌˇÚÓÈ');
       LVal.Add('...');
    end;

    {Œ·ÌÓ‚ÎÂÌËÂ}
    RefreshVal;
    Grid.Row := Grid.RowCount - 1;
    SaveVal;
    AEditExecute(Sender);
end;


{==============================================================================}
{======================   ACTION: ”ƒ¿À»“‹ ›À≈Ã≈Õ“   ===========================}
{==============================================================================}
procedure TFVAR_REST.ADelExecute(Sender: TObject);
var I: Integer;
begin
    If Grid.Row < 1 then Exit;
    If MessageDlg('œÓ‰Ú‚Â‰ËÚÂ Û‰‡ÎÂÌËÂ:'+CH_NEW+'['+Grid.Cells[0, Grid.Row]+']', mtWarning, [mbOK, mbCancel], 0) <> mrOk then Exit;

    I := (Grid.Row - 1) * 3;
    LVal.Delete(I); LVal.Delete(I); LVal.Delete(I);

    RefreshVal;
end;


{==============================================================================}
{=====================   ACTION: –≈ƒ¿ “»–Œ¬¿“‹ ›À≈Ã≈Õ“   ======================}
{==============================================================================}
procedure TFVAR_REST.AEditExecute(Sender: TObject);
var F: TForm;
begin
    F := TFVAR_REST_EDIT.Create(Self);
    try     TFVAR_REST_EDIT(F).Execute(@LVal, (Grid.Row - 1) * 3);
            SaveVal;
    finally F.Free; end;
    RefreshVal;
end;


{==============================================================================}
{======================   ACTION: œ≈–≈Ã≈—“»“‹ ›À≈Ã≈Õ“   =======================}
{==============================================================================}
procedure TFVAR_REST.AUpExecute(Sender: TObject);
var I: Integer;
begin
    I := (Grid.Row - 1) * 3;
    LVal.Move(I + 0, I - 3);
    LVal.Move(I + 1, I - 2);
    LVal.Move(I + 2, I - 1);
    Grid.Row := Grid.Row - 1;
    RefreshVal;
end;


procedure TFVAR_REST.ADownExecute(Sender: TObject);
var I: Integer;
begin
    I := (Grid.Row - 1) * 3;
    LVal.Move(I, I + 5);
    LVal.Move(I, I + 5);
    LVal.Move(I, I + 5);
    Grid.Row := Grid.Row + 1;
    RefreshVal;
end;


{==============================================================================}
{==============================   MENU: œŒ ¿«   ===============================}
{==============================================================================}
procedure TFVAR_REST.PMenuPopup(Sender: TObject);
begin
    EnablAction;
end;


end.
