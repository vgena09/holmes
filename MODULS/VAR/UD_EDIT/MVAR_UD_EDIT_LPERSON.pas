unit MVAR_UD_EDIT_LPERSON;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.Graphics,
  Data.DB, Data.Win.ADODB,
  FunType, MAIN;

type
  TFVAR_UD_EDIT_LPERSON = class(TForm)
    PBottom: TPanel;
    BtnClose: TBitBtn;
    PControl: TPageControl;
    TSMain: TTabSheet;
    TSSet: TTabSheet;
    ESet: TDBMemo;
    BtnVer: TBitBtn;
    GBFIO: TGroupBox;
    PIP: TPanel;
    LIP: TLabel;
    EIP: TDBEdit;
    BtnAuto: TBitBtn;
    PRP: TPanel;
    LRP: TLabel;
    ERP: TDBEdit;
    PDP: TPanel;
    LDP: TLabel;
    EDP: TDBEdit;
    PVP: TPanel;
    LVP: TLabel;
    EVP: TDBEdit;
    PTP: TPanel;
    LTP: TLabel;
    ETP: TDBEdit;
    PPP: TPanel;
    LPP: TLabel;
    EPP: TDBEdit;
    PShort: TPanel;
    LShort: TLabel;
    EShort: TDBEdit;
    PStatus: TPanel;
    LStatus: TLabel;
    EStatus: TDBComboBox;
    PBoss: TPanel;
    LBoss: TLabel;
    EBoss: TDBEdit;
    PAddress: TPanel;
    LAddress: TLabel;
    EAddress: TDBEdit;
    PContacts: TPanel;
    LContacts: TLabel;
    EContacts: TDBEdit;
    EHint: TDBMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EIPChange(Sender: TObject);
    procedure BtnAutoClick(Sender: TObject);
    procedure BtnCloseKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FFMAIN : TFMAIN;
    DS     : TDataSource;
    procedure CBoxSetItem;

  public
    procedure Execute(const PVAR: PADODataSet);
  end;

var
  FVAR_UD_EDIT_LPERSON: TFVAR_UD_EDIT_LPERSON;

implementation

uses FunConst, FunSys, FunBDList, FunText, FunPadeg, FunBD, FunVerify;

{$R *.dfm}


{******************************************************************************}
{*****************  ÂÍÅØÍßß ÔÓÍÊÖÈß: ÐÅÄÀÊÒÈÐÎÂÀÒÜ ÝËÅÌÅÍÒ  *******************}
{******************************************************************************}
procedure TFVAR_UD_EDIT_LPERSON.Execute(const PVAR: PADODataSet);
begin
    {Èíèöèàëèçàöèÿ}
    DS.DataSet := PVAR^;

    {Óñòàíàâëèâàåì ñïèñêè CBox.Item}
    CBoxSetItem;

    {Ïî óìîë÷àíèþ ñêëîíÿåì}
    If (ERP.Text='') and (EDP.Text='') and (EVP.Text='') and (ETP.Text='') and (EPP.Text='')
    then BtnAutoClick(nil);

    ShowModal;
end;


{==============================================================================}
{=============================  ÑÎÇÄÀÍÈÅ ÔÎÐÌÛ   ==============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_LPERSON.FormCreate(Sender: TObject);
begin
    {Èíèöèàëèçàöèÿ}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    DS     := TDataSource.Create(Self);

    EIP.OnChange            := EIPChange;
    EIP.DataSource          := DS;  EIP.DataField          := LPERSON_NAME;
    ERP.DataSource          := DS;  ERP.DataField          := LPERSON_NAME_RP;
    EDP.DataSource          := DS;  EDP.DataField          := LPERSON_NAME_DP;
    EVP.DataSource          := DS;  EVP.DataField          := LPERSON_NAME_VP;
    ETP.DataSource          := DS;  ETP.DataField          := LPERSON_NAME_TP;
    EPP.DataSource          := DS;  EPP.DataField          := LPERSON_NAME_PP;
    EShort.DataSource       := DS;  EShort.DataField       := LPERSON_NAME_SHORT;

    EStatus.DataSource      := DS;  EStatus.DataField      := LPERSON_STATE;      EStatus.Style := csDropDownList;
    EBoss.DataSource        := DS;  EBoss.DataField        := LPERSON_BOSS;
    EAddress.DataSource     := DS;  EAddress.DataField     := LPERSON_ADDRESS;
    EContacts.DataSource    := DS;  EContacts.DataField    := LPERSON_CONTACTS;
    ESet.DataSource         := DS;  ESet.DataField         := LPERSON_SET;
    EHint.DataSource        := DS;  EHint.DataField        := LPERSON_HINT;

    BtnAuto.OnClick         := BtnAutoClick;
    BtnClose.OnKeyDown      := BtnCloseKeyDown;
    BtnClose.ModalResult    := mrOk;

    PControl.TabIndex       := TableReadVar(@FFMAIN.BUD.TSYS, F_UD_SYS_PERSON_PAGE, PControl.TabIndex);
end;


{==============================================================================}
{==========================    ÇÀÊÐÛÒÈÅ ÔÎÐÌÛ    ==============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_LPERSON.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    TableWriteVar(@FFMAIN.BUD.TSYS, F_UD_SYS_PERSON_PAGE, PControl.TabIndex);
    {Çàïèñûâàåì çíà÷åíèå ïåðåìåííîé}
    DS.DataSet.Refresh;
    DS.Free;

    {Îáíîâëÿåì òàáëèöó ÓÄ}
    ReOpenDataSet(PADODataSet(@FFMAIN.BUD.TLPERSON));
end;



{==============================================================================}
{=======================   ÓÑÒÀÍÎÂÊÀ ÑÏÈÑÊÎÂ CBOX    ==========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_LPERSON.CBoxSetItem;
begin
    GetListItemCBox(@EStatus, @FFMAIN.BSET_GLOBAL.TLSTATUS, LSTATUS_MIP, '['+LSTATUS_LPERSON+']=TRUE');

    {Äëÿ êîððåêòíîãî îòîáðàæåíèÿ ïîëåé}
    DS.DataSet.Refresh;
end;


{==============================================================================}
{=============================   EIP: ON_CHANGE   =============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_LPERSON.EIPChange(Sender: TObject);
begin
    Caption := T_UD_LPERSON+': '+EIP.Text;
    BtnAuto.Enabled := Length(Trim(EIP.Text)) > 2;
end;


{==============================================================================}
{==========================   BTN_AUTO: ON_CLICK   ============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_LPERSON.BtnAutoClick(Sender: TObject);
var LName: String;
begin
    With EIP.DataSource.DataSet do begin
       LName:=FieldByName(LPERSON_NAME).AsString;
       Edit;
       FieldByName(LPERSON_NAME_RP).AsString    := PadegAuto('Ð', LName);
       FieldByName(LPERSON_NAME_DP).AsString    := PadegAuto('Ä', LName);
       FieldByName(LPERSON_NAME_VP).AsString    := PadegAuto('Â', LName);
       FieldByName(LPERSON_NAME_TP).AsString    := PadegAuto('Ò', LName);
       FieldByName(LPERSON_NAME_PP).AsString    := PadegAuto('Ï', LName);
       FieldByName(LPERSON_NAME_SHORT).AsString := LName;
       UpdateRecord;
       Post;
    end;
end;


{==============================================================================}
{========================   BTN_CLOSE: ON_KEY_DOWN   ==========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_LPERSON.BtnCloseKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    27: {ESC} ModalResult := mrOk;
    end;
end;


end.
