unit MVAR_OLE_EDIT;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ActnList, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.OleCtnrs,
  Data.DB, Data.Win.ADODB,
  FunType, FunConst, MAIN;

type
  TFVAR_OLE_EDIT = class(TForm)
    PBottom: TPanel;
    BtnOk: TBitBtn;
    PCat: TPanel;
    LCat: TLabel;
    ECat: TDBComboBox;
    BtnCat: TBitBtn;
    PDP: TPanel;
    LDP: TLabel;
    EDP: TDBEdit;
    PIP: TPanel;
    LIP: TLabel;
    EIP: TDBEdit;
    PPP: TPanel;
    LPP: TLabel;
    EPP: TDBEdit;
    PRP: TPanel;
    LRP: TLabel;
    ERP: TDBEdit;
    PTP: TPanel;
    LTP: TLabel;
    ETP: TDBEdit;
    PVP: TPanel;
    LVP: TLabel;
    EVP: TDBEdit;
    AList: TActionList;
    AAuto: TAction;
    Nav: TDBNavigator;
    EOle: TOleContainer;
    BtnAuto: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AAutoExecute(Sender: TObject);
    procedure TBeforeScroll(DataSet: TDataSet);
    procedure TAfterScroll(DataSet: TDataSet);
    procedure EOleMouseDown(Sender: TObject; Button: TMouseButton; Shift:  TShiftState; X, Y: Integer);
    procedure TBeforeClose(DataSet: TDataSet);
    procedure KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FFMAIN : TFMAIN;
    DS     : TDataSource;

    procedure BtnListClick(Sender: TObject);
    procedure CBoxSetItem;

  public
    T: TADOTable;
  end;

var
  FVAR_OLE_EDIT: TFVAR_OLE_EDIT;

implementation

uses FunBD, FunText, FunSys, FunOle, FunBDList, FunIni, FunPadeg;

{$R *.dfm}


{==============================================================================}
{============================   —Œ«ƒ¿Õ»≈ ‘Œ–Ã€    =============================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.FormCreate(Sender: TObject);
begin
    {»ÌËˆË‡ÎËÁ‡ˆËˇ}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    DS     := TDataSource.Create(Self);

    With EOle do begin
       AutoActivate   := aaManual;      // ·ÂÁ ‡‚ÚÓ‡ÍÚË‚‡ˆËË
       AutoVerbMenu   := false;         // ·ÂÁ ÏÂÌ˛ OLE-ÒÂ‚Â‡
       AllowActiveDoc := false;         // ·ÂÁ ÔÓ‰‰ÂÊÍË ËÌÚÂÙÂÈÒ‡ IOleDocumentSite
       AllowInPlace   := false;         // ÓÚÍ˚‚‡Ú¸ ‚ ÓÚ‰ÂÎ¸ÌÓÏ ÓÍÌÂ
       CopyOnSave     := true;          // ÒÊËÏ‡Ú¸ ÔÂÂ‰ ÒÓı‡ÌÂÌËÂÏ
       Ctl3D          := false;         // ·ÂÎ˚È ÙÓÌ
       ParentCtl3D    := false;
       Cursor         := crHandPoint;
       OnMouseDown    := EOleMouseDown;
       SizeMode       := smScale;
    end;

    ECat.DataSource     := DS;  ECat.DataField := F_VAR_OLE_CAT; ECat.Style := csDropDownList; BtnCat.OnClick := BtnListClick;
    EIP.DataSource      := DS;  EIP.DataField  := F_VAR_OLE_IP;
    ERP.DataSource      := DS;  ERP.DataField  := F_VAR_OLE_RP;
    EDP.DataSource      := DS;  EDP.DataField  := F_VAR_OLE_DP;
    EVP.DataSource      := DS;  EVP.DataField  := F_VAR_OLE_VP;
    ETP.DataSource      := DS;  ETP.DataField  := F_VAR_OLE_TP;
    EPP.DataSource      := DS;  EPP.DataField  := F_VAR_OLE_PP;
    Nav.DataSource      := DS;
    Nav.VisibleButtons  := [nbFirst,nbPrior,nbNext,nbLast,nbInsert,nbDelete];
    Nav.ShowHint        := true;
    BtnOk.ModalResult   := mrOk;
    BtnOk.OnKeyDown     := KeyDown;

    T := TADOTable.Create(Self);
    T.AfterScroll  := TAfterScroll;
    T.BeforeScroll := TBeforeScroll;
    T.BeforeClose  := TBeforeClose;
    T.Connection   := FFMAIN.BSET_LOCAL.BD;
    T.TableName    := T_UD_VAR_OLE;
    DS.DataSet     := T;
    T.Open;

    CBoxSetItem;
    LoadFormIni(Self, [fspPosition]);
end;


{==============================================================================}
{============================   «¿ –€“»≈ ‘Œ–Ã€    =============================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    T.Close;
    DS.Free;
    EOle.DestroyObject;
    SaveFormIni(Self, [fspPosition]);
end;

{==============================================================================}
{===============================   KEY_DOWN   =================================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    27: {ESC} ModalResult := mrClose;
    end;
end;


{******************************************************************************}
{********************************   TABLE   ***********************************}
{******************************************************************************}

{==============================================================================}
{=======================   TABLE: œ–»’Œƒ»Ã Õ¿ «¿œ»—‹   ========================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.TAfterScroll(DataSet: TDataSet);
begin
    Caption:='¡ÎÓÍË Word: '+IntToStr(T.RecNo)+' ËÁ '+IntToStr(T.RecordCount);
    If T.FieldByName(F_VAR_OLE_OLE).IsNull then BlankWordToOle(@EOle)
                                           else FieldToOle(@T, @EOle);
end;


{==============================================================================}
{=========================   TABLE: ”’Œƒ»Ã — «¿œ»—»   =========================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.TBeforeScroll(DataSet: TDataSet);
begin
    If T.RecordCount = 0 then Exit;
    OleToField(@EOle, @T);
end;

{==============================================================================}
{=========================   TABLE: œ≈–≈ƒ «¿ –€“»≈Ã   =========================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.TBeforeClose(DataSet: TDataSet);
begin
    TBeforeScroll(DataSet);
end;


{==============================================================================}
{===========================   OLE: ON_MOUSE_DOWN   ===========================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.EOleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   If (Button = mbLeft) and (T.RecordCount > 0) then EOle.DoVerb(ovShow);
end;


{==============================================================================}
{=========================   ACTION: “≈ —“ »« OLE   ===========================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.AAutoExecute(Sender: TObject);
var S: String;
begin
    If T.RecordCount = 0 then Exit;
    S:=GetOLEText(@EOle);
    With T do begin
       Edit;
       FieldByName(F_VAR_OLE_IP).AsString:=LowerStrPart(S, 1, 1);
       FieldByName(F_VAR_OLE_RP).AsString:=LowerStrPart(PadegAUTO('–', S), 1, 1);
       FieldByName(F_VAR_OLE_DP).AsString:=LowerStrPart(PadegAUTO('ƒ', S), 1, 1);
       FieldByName(F_VAR_OLE_VP).AsString:=LowerStrPart(PadegAUTO('¬', S), 1, 1);
       FieldByName(F_VAR_OLE_TP).AsString:=LowerStrPart(PadegAUTO('“', S), 1, 1);
       FieldByName(F_VAR_OLE_PP).AsString:=LowerStrPart(PadegAUTO('œ', S), 1, 1);
       UpdateRecord;
       Post;
    end;
end;



{******************************************************************************}
{********************************   CBOX   ************************************}
{******************************************************************************}

{==============================================================================}
{=====================    Œ––≈ “»–Œ¬ ¿ —œ»— Œ¬ CBOX    ========================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.BtnListClick(Sender: TObject);
var CBox : TDBComboBox;
    SID  : String;
begin
    CBox := TDBComboBox(Sender);
    SID  := '';
    If CBox.Name='BtnCat' then SID:=LIST_CAT_OLE;
    If SID='' then Exit;

    RefreshListItem(@FFMAIN.BSET_LOCAL.TLIST, SID);
    CBoxSetItem;
end;

{==============================================================================}
{=======================   ”—“¿ÕŒ¬ ¿ —œ»— Œ¬ CBOX    ==========================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.CBoxSetItem;
begin
    GetListItemCBox(@ECat, @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(LIST_CAT_OLE));
    DS.DataSet.Refresh;
end;


end.


