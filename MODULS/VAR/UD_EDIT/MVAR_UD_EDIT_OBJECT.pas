unit MVAR_UD_EDIT_OBJECT;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.Graphics,
  Data.DB, Data.Win.ADODB,
  FunType, MAIN;

type
  TFVAR_UD_EDIT_OBJECT = class(TForm)
    PCaption: TPanel;
    LCaption: TLabel;
    PBottom: TPanel;
    BtnClose: TBitBtn;
    GBConf: TGroupBox;
    PConfPlace: TPanel;
    LConfPlace: TLabel;
    EConfPlace: TDBComboBox;
    BtnConfPlace: TBitBtn;
    PConfPerson: TPanel;
    LConfPerson: TLabel;
    EConfPerson: TDBComboBox;
    BtnConfPerson: TBitBtn;
    PConfDate: TPanel;
    LConfDate: TLabel;
    LConfOld: TLabel;
    EConfDate: TDateTimePicker;
    GBLoc: TGroupBox;
    PLocPlace: TPanel;
    LLocPlace: TLabel;
    ELocPlace: TDBComboBox;
    BtnLocPlace: TBitBtn;
    PLocPerson: TPanel;
    LLocPerson: TLabel;
    BtnLocPerson: TBitBtn;
    ELocPerson: TDBComboBox;
    PLocDate: TPanel;
    LLocDate: TLabel;
    LLocOld: TLabel;
    ELocDate: TDateTimePicker;
    PPack: TPanel;
    LPack: TLabel;
    BtnPack: TBitBtn;
    EPack: TDBComboBox;
    PSeal: TPanel;
    LSeal: TLabel;
    BtnSeal: TBitBtn;
    ESeal: TDBComboBox;
    BtnCaption: TBitBtn;
    ECaption: TDBComboBox;
    EVD: TDBCheckBox;
    EHint: TDBMemo;
    PConfAgency: TPanel;
    LConfAgency: TLabel;
    BtnConfAgency: TBitBtn;
    EConfAgency: TDBComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnListClick(Sender: TObject);
    procedure EDateChange(Sender: TObject);
    procedure ECaptionChange(Sender: TObject);
    procedure BtnCloseKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FFMAIN : TFMAIN;
    DS     : TDataSource;
    procedure CBoxSetItem;

  public
    procedure Execute(const PVAR: PADODataSet);
  end;

var
  FVAR_UD_EDIT_OBJECT: TFVAR_UD_EDIT_OBJECT;

implementation

uses FunConst, FunSys, FunBDList, FunDay, FunText, FunPadeg;

{$R *.dfm}


{******************************************************************************}
{*****************  ÂÍÅØÍßß ÔÓÍÊÖÈß: ÐÅÄÀÊÒÈÐÎÂÀÒÜ ÝËÅÌÅÍÒ  *******************}
{******************************************************************************}
procedure TFVAR_UD_EDIT_OBJECT.Execute(const PVAR: PADODataSet);

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

    SetDate(EConfDate, OBJECT_CONF_DATE);
    SetDate(ELocDate,  OBJECT_LOC_DATE);
    EDateChange(nil);

    {Óñòàíàâëèâàåì ñïèñêè CBox.Item}
    CBoxSetItem;
    ECaptionChange(nil);

    ShowModal;
end;


{==============================================================================}
{===========================  ÑÎÇÄÀÍÈÅ ÔÎÐÌÛ  =================================}
{==============================================================================}
procedure TFVAR_UD_EDIT_OBJECT.FormCreate(Sender: TObject);
begin
    {Èíèöèàëèçàöèÿ}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    DS     := TDataSource.Create(Self);

    ECaption.DataSource     := DS;  ECaption.DataField     := OBJECT_CAPTION;      BtnCaption.OnClick    := BtnListClick; ECaption.OnChange     := ECaptionChange;
    EVD.DataSource          := DS;  EVD.DataField          := OBJECT_VD;

    EConfPlace.DataSource   := DS;  EConfPlace.DataField   := OBJECT_CONF_PLACE;   BtnConfPlace.OnClick  := BtnListClick;
    EConfAgency.DataSource  := DS;  EConfAgency.DataField  := OBJECT_CONF_AGENCY;  BtnConfAgency.OnClick := BtnListClick;
    EConfPerson.DataSource  := DS;  EConfPerson.DataField  := OBJECT_CONF_PERSON;  BtnConfPerson.OnClick := BtnListClick;

    ELocPlace.DataSource    := DS;  ELocPlace.DataField    := OBJECT_LOC_PLACE;    BtnLocPlace.OnClick   := BtnListClick;
    ELocPerson.DataSource   := DS;  ELocPerson.DataField   := OBJECT_LOC_PERSON;   BtnLocPerson.OnClick  := BtnListClick;

    EPack.DataSource        := DS;  EPack.DataField        := OBJECT_PACK;         BtnPack.OnClick       := BtnListClick;
    ESeal.DataSource        := DS;  ESeal.DataField        := OBJECT_SEAL;         BtnSeal.OnClick       := BtnListClick;
    EHint.DataSource        := DS;  EHint.DataField        := OBJECT_HINT;

    BtnClose.OnKeyDown      := BtnCloseKeyDown;
    BtnClose.ModalResult    := mrOk;
end;


{==============================================================================}
{============================   ÇÀÊÐÛÒÈÅ ÔÎÐÌÛ    =============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_OBJECT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    DS.DataSet.Refresh;  //Äëÿ îáíîâëåíèÿ ðåäàêòèðóåìûõ ïåðåä çàêðûòèåì ïîëåé
    DS.Free;
end;


{==============================================================================}
{=====================   ÊÎÐÐÅÊÒÈÐÎÂÊÀ ÑÏÈÑÊÎÂ CBOX    ========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_OBJECT.BtnListClick(Sender: TObject);
var CBox : TDBComboBox;
    SID  : String;
begin
    {Èíèöèàëèçàöèÿ}
    CBox := TDBComboBox(Sender);

    {Ïîèñê èäåíòèôèêàòîðà ñïèñêà}
    SID := '';
    If CBox.Name='BtnCaption'    then SID:=LIST_OBJECT_CAPTION;
    If CBox.Name='BtnConfPlace'  then SID:=LIST_OBJECT_PLACE;
    If CBox.Name='BtnConfAgency' then SID:=LIST_OBJECT_AGENCY;
    If CBox.Name='BtnConfPerson' then SID:=LIST_OBJECT_PERSON;
    If CBox.Name='BtnLocPlace'   then SID:=LIST_OBJECT_PLACE;
    If CBox.Name='BtnLocPerson'  then SID:=LIST_OBJECT_PERSON;
    If CBox.Name='BtnPack'       then SID:=LIST_OBJECT_PACK;
    If CBox.Name='BtnSeal'       then SID:=LIST_OBJECT_SEAL;
    If SID='' then Exit;

    RefreshListItem(@FFMAIN.BSET_LOCAL.TLIST, SID);
    CBoxSetItem;
end;


{==============================================================================}
{=======================   ÓÑÒÀÍÎÂÊÀ ÑÏÈÑÊÎÂ CBOX    ==========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_OBJECT.CBoxSetItem;
begin
    GetListItemCBox(@ECaption,    @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(LIST_OBJECT_CAPTION));
    GetListItemCBox(@EConfPlace,  @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(LIST_OBJECT_PLACE  ));
    GetListItemCBox(@EConfAgency, @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(LIST_OBJECT_AGENCY ));
    GetListItemCBox(@EConfPerson, @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(LIST_OBJECT_PERSON ));
    GetListItemCBox(@ELocPlace,   @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(LIST_OBJECT_PLACE  ));
    GetListItemCBox(@ELocPerson,  @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(LIST_OBJECT_PERSON ));
    GetListItemCBox(@EPack,       @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(LIST_OBJECT_PACK   ));
    GetListItemCBox(@ESeal,       @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(LIST_OBJECT_SEAL   ));

    {Äëÿ êîððåêòíîãî îòîáðàæåíèÿ ïîëåé}
    DS.DataSet.Refresh;
end;


{==============================================================================}
{=========================   EDATE: ÈÇÌÅÍÅÍÈÅ ÄÀÒÛ   ==========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_OBJECT.EDateChange(Sender: TObject);
var EDate : TDateTimePicker;
    SID   : String;

   procedure SetLConfOld;
   var Year, Mounth, Day, Hour: Integer;
       S: String;
   begin
       DateTimeDiff0(EConfDate.Date, Now, Hour, Day, Mounth, Year);
       S:='';
       If Year>100 then S:=S+' ?';
       If Year<0   then S:=' (ÎØÈÁÊÀ)';

       If S='' then LConfOld.Font.Color := clBlack
               else LConfOld.Font.Color := clRed;

       LConfOld.Caption:=IntToStr(Year)+' ã. '+IntToStr(Mounth)+' ì. '+IntToStr(Day)+' ä. '+S;
   end;

   procedure SetLLocOld;
   var Year, Mounth, Day, Hour: Integer;
       S: String;
   begin
       DateTimeDiff0(ELocDate.Date, Now, Hour, Day, Mounth, Year);
       S:='';
       If Year>100 then S:=S+' ?';
       If Year<0   then S:=' (ÎØÈÁÊÀ)';

       If S='' then LLocOld.Font.Color := clBlack
               else LLocOld.Font.Color := clRed;

       LLocOld.Caption:=IntToStr(Year)+' ã. '+IntToStr(Mounth)+' ì. '+IntToStr(Day)+' ä. '+S;
   end;

begin
    If Sender <> nil then begin
       EDate := TDateTimePicker(Sender);
       SID   := '';
       If EDate.Name='EConfDate' then SID:=OBJECT_CONF_DATE;
       If EDate.Name='ELocDate'  then SID:=OBJECT_LOC_DATE;
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
    SetLConfOld;
    SetLLocOld;
end;


{==============================================================================}
{=============================   EIP: ON_CHANGE   =============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_OBJECT.ECaptionChange(Sender: TObject);
begin
    Caption := T_UD_OBJECT+': '+ECaption.Text;
end;


{==============================================================================}
{========================   BTN_CLOSE: ON_KEY_DOWN   ==========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_OBJECT.BtnCloseKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    27: {ESC} ModalResult := mrOk;
    end;
end;

end.
