unit MVAR_UD_EDIT_DPERSON;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.Graphics,
  Data.DB, Data.Win.ADODB,
  FunType, MAIN;

type
  TFVAR_UD_EDIT_DPERSON = class(TForm)
    PTop: TPanel;
    PTopRight: TPanel;
    GBSex: TDBRadioGroup;
    GBDocument: TGroupBox;
    PDocType: TPanel;
    LDocType: TLabel;
    EDocType: TDBComboBox;
    BtnDocType: TBitBtn;
    PDocNomer: TPanel;
    LDocNomer: TLabel;
    EDocNomer: TDBEdit;
    PDocPlace: TPanel;
    LDocPlace: TLabel;
    EDocPlace: TDBComboBox;
    BtnDocPlace: TBitBtn;
    PDocDate: TPanel;
    LDocDate: TLabel;
    LDocOld: TLabel;
    EDocDate: TDateTimePicker;
    PTopLeft: TPanel;
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
    PWorkPlace: TPanel;
    LWorkPlace: TLabel;
    EWorkPlace: TDBComboBox;
    BtnWorkPlace: TBitBtn;
    PBottom: TPanel;
    BtnClose: TBitBtn;
    PContacts: TPanel;
    LContacts: TLabel;
    EContacts: TDBEdit;
    PWorkPost: TPanel;
    LWorkPost: TLabel;
    BtnWorkPost: TBitBtn;
    EWorkPost: TDBComboBox;
    EHint: TDBMemo;
    PStatus: TPanel;
    LStatus: TLabel;
    EStatus: TDBComboBox;
    PAddress: TPanel;
    LAddress: TLabel;
    BtnAddress: TBitBtn;
    EAddress: TDBComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnListClick(Sender: TObject);
    procedure EDateChange(Sender: TObject);
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
  FVAR_UD_EDIT_DPERSON: TFVAR_UD_EDIT_DPERSON;

implementation

uses FunConst, FunSys, FunBDList, FunDay, FunText, FunPadeg, FunBD;

{$R *.dfm}


{******************************************************************************}
{*****************  ÂÍÅØÍßß ÔÓÍÊÖÈß: ÐÅÄÀÊÒÈÐÎÂÀÒÜ ÝËÅÌÅÍÒ  *******************}
{******************************************************************************}
procedure TFVAR_UD_EDIT_DPERSON.Execute(const PVAR: PADODataSet);

   procedure SetDate(Sender: TObject; const SField: String);
   var Dat: TDateTimePicker;
   begin
       Dat := TDateTimePicker(Sender);
       If DS.DataSet.FieldByName(SField).IsNull then begin
          Dat.Date := Date;
          EDateChange(Dat);
       end else Dat.Date := DS.DataSet.FieldByName(SField).AsDateTime;
       Dat.OnChange := EDateChange;
   end;

begin
    {Èíèöèàëèçàöèÿ}
    DS.DataSet := PVAR^;

    SetDate(EDocDate,  DPERSON_DOC_DATE);
    EDateChange(nil);

    {Óñòàíàâëèâàåì ñïèñêè CBox.Item}
    CBoxSetItem;

    {Ïî óìîë÷àíèþ ñêëîíÿåì ÔÈÎ}
    If (ERP.Text='') and (EDP.Text='') and (EVP.Text='') and (ETP.Text='') and
       (EPP.Text='') and (PVAR^.FieldByName(DPERSON_SEX).AsBoolean = false)
    then BtnAutoClick(nil);

    ShowModal;
end;


{==============================================================================}
{=============================  ÑÎÇÄÀÍÈÅ ÔÎÐÌÛ   ==============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_DPERSON.FormCreate(Sender: TObject);
begin
    {Èíèöèàëèçàöèÿ}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    DS     := TDataSource.Create(Self);

    EIP.OnChange            := EIPChange;
    EIP.DataSource          := DS;  EIP.DataField          := DPERSON_FIO;
    ERP.DataSource          := DS;  ERP.DataField          := DPERSON_FIO_RP;
    EDP.DataSource          := DS;  EDP.DataField          := DPERSON_FIO_DP;
    EVP.DataSource          := DS;  EVP.DataField          := DPERSON_FIO_VP;
    ETP.DataSource          := DS;  ETP.DataField          := DPERSON_FIO_TP;
    EPP.DataSource          := DS;  EPP.DataField          := DPERSON_FIO_PP;
    GBSex.DataSource        := DS;  GBSex.DataField        := DPERSON_SEX;
    EDocType.DataSource     := DS;  EDocType.DataField     := DPERSON_DOC_TYPE;   EDocType.Style       := csDropDownList; BtnDocType.OnClick   := BtnListClick;
    EDocNomer.DataSource    := DS;  EDocNomer.DataField    := DPERSON_DOC_NOMER;
    EDocPlace.DataSource    := DS;  EDocPlace.DataField    := DPERSON_DOC_PLACE;  BtnDocPlace.OnClick  := BtnListClick;

    EStatus.DataSource      := DS;  EStatus.DataField      := DPERSON_STATE;      EStatus.Style        := csDropDownList;
    EContacts.DataSource    := DS;  EContacts.DataField    := DPERSON_CONTACTS;

    EWorkPlace.DataSource   := DS;  EWorkPlace.DataField   := DPERSON_WORK_PLACE; BtnWorkPlace.OnClick := BtnListClick;
    EWorkPost.DataSource    := DS;  EWorkPost.DataField    := DPERSON_WORK_POST;  BtnWorkPost.OnClick  := BtnListClick;
    EAddress.DataSource     := DS;  EAddress.DataField     := DPERSON_ADDRESS;    BtnAddress.OnClick   := BtnListClick;

    EHint.DataSource        := DS;  EHint.DataField        := DPERSON_HINT;

    BtnAuto.OnClick         := BtnAutoClick;
    BtnClose.OnKeyDown      := BtnCloseKeyDown;
    BtnClose.ModalResult    := mrOk;
end;


{==============================================================================}
{============================   ÇÀÊÐÛÒÈÅ ÔÎÐÌÛ    =============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_DPERSON.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    {Çàïèñûâàåì çíà÷åíèå ïåðåìåííîé}
    DS.DataSet.Refresh;
    DS.Free;

    {Îáíîâëÿåì òàáëèöó ÓÄ}
    ReOpenDataSet(PADODataSet(@FFMAIN.BUD.TDPERSON));
end;


{==============================================================================}
{=====================   ÊÎÐÐÅÊÒÈÐÎÂÊÀ ÑÏÈÑÊÎÂ CBOX    ========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_DPERSON.BtnListClick(Sender: TObject);
var CBox : TDBComboBox;
    SID  : String;
begin
    {Èíèöèàëèçàöèÿ}
    CBox := TDBComboBox(Sender);

    {Ïîèñê èäåíòèôèêàòîðà ñïèñêà}
    SID := '';
    If CBox.Name='BtnDocType'    then SID:=LIST_DOC_TYPE;
    If CBox.Name='BtnDocPlace'   then SID:=LIST_DOC_PLACE;
    If CBox.Name='BtnWorkPlace'  then SID:=LIST_WORK_PLACE;
    If CBox.Name='BtnWorkPost'   then SID:=LIST_WORK_POST;
    If CBox.Name='BtnAddress'    then SID:=LIST_ADDRESS;
    If SID='' then Exit;

    RefreshListItem(@FFMAIN.BSET_LOCAL.TLIST, SID);
    CBoxSetItem;
end;


{==============================================================================}
{=======================   ÓÑÒÀÍÎÂÊÀ ÑÏÈÑÊÎÂ CBOX    ==========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_DPERSON.CBoxSetItem;
begin
    GetListItemCBox(@EStatus,    @FFMAIN.BSET_GLOBAL.TLSTATUS, LSTATUS_MIP, '['+LSTATUS_DPERSON+']=TRUE');
    GetListItemCBox(@EDocType,   @FFMAIN.BSET_LOCAL.TLIST,     LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_DOC_TYPE));
    GetListItemCBox(@EDocPlace,  @FFMAIN.BSET_LOCAL.TLIST,     LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_DOC_PLACE));
    GetListItemCBox(@EWorkPlace, @FFMAIN.BSET_LOCAL.TLIST,     LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_WORK_PLACE));
    GetListItemCBox(@EWorkPost,  @FFMAIN.BSET_LOCAL.TLIST,     LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_WORK_POST));
    GetListItemCBox(@EAddress,   @FFMAIN.BSET_LOCAL.TLIST,     LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_ADDRESS));

    {Äëÿ êîððåêòíîãî îòîáðàæåíèÿ ïîëåé}
    DS.DataSet.Refresh;
end;


{==============================================================================}
{=========================   EDATE: ÈÇÌÅÍÅÍÈÅ ÄÀÒÛ   ==========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_DPERSON.EDateChange(Sender: TObject);
var EDate : TDateTimePicker;
    SID   : String;

   procedure SetLDocOld;
   var Year, Mounth, Day, Hour: Integer;
       S: String;
   begin
       DateTimeDiff0(EDocDate.Date, Now, Hour, Day, Mounth, Year);
       S:='';
       If Year>100 then S:=S+' ?';
       If Year<0   then S:=' (ÎØÈÁÊÀ)';

       If S='' then LDocOld.Font.Color := clBlack
               else LDocOld.Font.Color := clRed;

       LDocOld.Caption:=IntToStr(Year)+' ã. '+IntToStr(Mounth)+' ì. '+IntToStr(Day)+' ä. '+S;
   end;

begin
    If Sender <> nil then begin
       EDate := TDateTimePicker(Sender);
       SID   := '';
       If EDate.Name='EDocDate'  then SID:=DPERSON_DOC_DATE;
       If SID='' then Exit;

       With DS.DataSet do begin
          DisableControls;
          Edit;
          FieldByName(SID).AsDateTime := EDate.Date;
          UpdateRecord;
          Post;
          EnableControls;
       end;
    end;
    SetLDocOld;
end;


{==============================================================================}
{=============================   EIP: ON_CHANGE   =============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_DPERSON.EIPChange(Sender: TObject);
begin
    Caption         := T_UD_DPERSON+': '+EIP.Text;
    BtnAuto.Enabled := GetColSlov(EIP.Text, ' ') > 1;
end;


{==============================================================================}
{==========================   BTN_AUTO: ON_CLICK   ============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_DPERSON.BtnAutoClick(Sender: TObject);
var FIO: String;
    Sex: Boolean;
begin
    With EIP.DataSource.DataSet do begin
       FIO:=FieldByName(DPERSON_FIO).AsString;
       Sex:=GetSexFIO(FIO);
       Edit;
       FieldByName(DPERSON_SEX).AsBoolean := Sex;
       FieldByName(DPERSON_FIO_RP).AsString := PadegFIO('Ð', FIO);
       FieldByName(DPERSON_FIO_DP).AsString := PadegFIO('Ä', FIO);
       FieldByName(DPERSON_FIO_VP).AsString := PadegFIO('Â', FIO);
       FieldByName(DPERSON_FIO_TP).AsString := PadegFIO('Ò', FIO);
       FieldByName(DPERSON_FIO_PP).AsString := PadegFIO('Ï', FIO);
       UpdateRecord;
       Post;
    end;
end;


{==============================================================================}
{========================   BTN_CLOSE: ON_KEY_DOWN   ==========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_DPERSON.BtnCloseKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    27: {ESC} ModalResult := mrOk;
    end;
end;



end.
