unit MVAR_UD_EDIT_PPERSON;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.Graphics,
  Data.DB, Data.Win.ADODB,
  FunType, MAIN, Vcl.ActnList;

type
  TFVAR_UD_EDIT_PPERSON = class(TForm)
    PControl: TPageControl;
    TSMain: TTabSheet;
    TSSet: TTabSheet;
    EHint: TDBMemo;
    PTop: TPanel;
    PTopRight: TPanel;
    PGragd: TPanel;
    LGragd: TLabel;
    BtnGragd: TBitBtn;
    EGragd: TDBComboBox;
    PEducation: TPanel;
    LEducation: TLabel;
    BtnEducation: TBitBtn;
    EEducation: TDBComboBox;
    PFamily: TPanel;
    LFamily: TLabel;
    EFamily: TDBComboBox;
    BtnFamily: TBitBtn;
    PBornPlace: TPanel;
    LBornPlace: TLabel;
    EBornPlace: TDBComboBox;
    BtnBornPlace: TBitBtn;
    PBornDate: TPanel;
    LBornDate: TLabel;
    LBornOld: TLabel;
    EBornDate: TDateTimePicker;
    PStatus: TPanel;
    LStatus: TLabel;
    EStatus: TDBComboBox;
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
    PPersNomer: TPanel;
    LPersNomer: TLabel;
    EPersNomer: TDBEdit;
    PArt: TPanel;
    LArt: TLabel;
    BtnArt: TBitBtn;
    EArt: TDBEdit;
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
    POld: TPanel;
    LOld: TLabel;
    EOld: TDBEdit;
    PRegPlace: TPanel;
    LRegPlace: TLabel;
    ERegPlace: TDBEdit;
    PLivPlace: TPanel;
    LLivPlace: TLabel;
    ELivPlace: TDBEdit;
    PWorkPlace: TPanel;
    LWorkPlace: TLabel;
    EWorkPlace: TDBEdit;
    PContacts: TPanel;
    LContacts: TLabel;
    EContacts: TDBEdit;
    PSudimost: TPanel;
    LSudimost: TLabel;
    ESudimost: TDBEdit;
    PSoderg: TPanel;
    LSoderg: TLabel;
    ESoderg: TDBComboBox;
    BtnSoderg: TBitBtn;
    PWorkPost: TPanel;
    LWorkPost: TLabel;
    EWorkPost: TDBEdit;
    ESet: TDBMemo;
    PBottom: TPanel;
    BtnClose: TBitBtn;
    BtnVer: TBitBtn;
    AList: TActionList;
    AVer: TAction;
    AArt: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnListClick(Sender: TObject);
    procedure EDateChange(Sender: TObject);
    procedure EIPChange(Sender: TObject);
    procedure BtnAutoClick(Sender: TObject);
    procedure BtnCloseKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EStatusChange(Sender: TObject);
    procedure EArtChange(Sender: TObject);
    procedure AVerExecute(Sender: TObject);
    procedure AArtExecute(Sender: TObject);
  private
    FFMAIN : TFMAIN;
    DS     : TDataSource;
    procedure CBoxSetItem;

  public
    procedure Execute(const PVAR: PADODataSet);
  end;

var
  FVAR_UD_EDIT_PPERSON: TFVAR_UD_EDIT_PPERSON;

implementation

uses FunConst, FunSys, FunBDList, FunDay, FunText, FunPadeg, FunBD, FunVerify,
     FunArt;

{$R *.dfm}


{******************************************************************************}
{*****************  ВНЕШНЯЯ ФУНКЦИЯ: РЕДАКТИРОВАТЬ ЭЛЕМЕНТ  *******************}
{******************************************************************************}
procedure TFVAR_UD_EDIT_PPERSON.Execute(const PVAR: PADODataSet);

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
    {Инициализация}
    DS.DataSet := PVAR^;

    SetDate(EBornDate, PPERSON_BORN_DATE);
    SetDate(EDocDate,  PPERSON_DOC_DATE);
    EDateChange(nil);

    {Устанавливаем списки CBox.Item}
    CBoxSetItem;

    {По умолчанию склоняем ФИО}
    If (ERP.Text='') and (EDP.Text='') and (EVP.Text='') and (ETP.Text='') and
       (EPP.Text='') and (PVAR^.FieldByName(PPERSON_SEX).AsBoolean = false)
    then BtnAutoClick(nil);

    EStatusChange(nil);

    ShowModal;
end;


{==============================================================================}
{=============================  СОЗДАНИЕ ФОРМЫ   ==============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_PPERSON.FormCreate(Sender: TObject);
begin
    {Инициализация}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    DS     := TDataSource.Create(Self);

    EIP.OnChange            := EIPChange;
    EIP.DataSource          := DS;  EIP.DataField          := PPERSON_FIO;
    ERP.DataSource          := DS;  ERP.DataField          := PPERSON_FIO_RP;
    EDP.DataSource          := DS;  EDP.DataField          := PPERSON_FIO_DP;
    EVP.DataSource          := DS;  EVP.DataField          := PPERSON_FIO_VP;
    ETP.DataSource          := DS;  ETP.DataField          := PPERSON_FIO_TP;
    EPP.DataSource          := DS;  EPP.DataField          := PPERSON_FIO_PP;
    EOld.DataSource         := DS;  EOld.DataField         := PPERSON_FIO_OLD;
    GBSex.DataSource        := DS;  GBSex.DataField        := PPERSON_SEX;

    EStatus.DataSource      := DS;  EStatus.DataField      := PPERSON_STATE;      EStatus.OnChange := EStatusChange;  EStatus.Style        := csDropDownList;
    EBornPlace.DataSource   := DS;  EBornPlace.DataField   := PPERSON_BORN_PLACE;                                     BtnBornPlace.OnClick := BtnListClick;
    EGragd.DataSource       := DS;  EGragd.DataField       := PPERSON_GRAGD;      EGragd.Style     := csDropDownList; BtnGragd.OnClick     := BtnListClick;
    EEducation.DataSource   := DS;  EEducation.DataField   := PPERSON_EDUCATION;  EEducation.Style := csDropDownList; BtnEducation.OnClick := BtnListClick;
    EFamily.DataSource      := DS;  EFamily.DataField      := PPERSON_FAMILY;     EFamily.Style    := csDropDownList; BtnFamily.OnClick    := BtnListClick;
    ESudimost.DataSource    := DS;  ESudimost.DataField    := PPERSON_SUDIMOST;
    ESoderg.DataSource      := DS;  ESoderg.DataField      := PPERSON_SODERG;     ESoderg.Style    := csDropDownList; BtnSoderg.OnClick    := BtnListClick;

    ERegPlace.DataSource    := DS;  ERegPlace.DataField    := PPERSON_REG_PLACE;
    ELivPlace.DataSource    := DS;  ELivPlace.DataField    := PPERSON_LIV_PLACE;
    EWorkPlace.DataSource   := DS;  EWorkPlace.DataField   := PPERSON_WORK_PLACE;
    EWorkPost.DataSource    := DS;  EWorkPost.DataField    := PPERSON_WORK_POST;
    EContacts.DataSource    := DS;  EContacts.DataField    := PPERSON_CONTACTS;

    EDocType.DataSource     := DS;  EDocType.DataField     := PPERSON_DOC_TYPE;   EDocType.Style   := csDropDownList; BtnDocType.OnClick   := BtnListClick;
    EDocNomer.DataSource    := DS;  EDocNomer.DataField    := PPERSON_DOC_NOMER;
    EDocPlace.DataSource    := DS;  EDocPlace.DataField    := PPERSON_DOC_PLACE;                                      BtnDocPlace.OnClick  := BtnListClick;
    EPersNomer.DataSource   := DS;  EPersNomer.DataField   := PPERSON_PERSNOMER;

    EArt.DataSource         := DS;  EArt.DataField         := PPERSON_ARTICLES;   EArt.OnChange    := EArtChange;
    BtnArt.Action           := AArt; BtnArt.ShowHint       := true;

    ESet.DataSource         := DS;  ESet.DataField         := PPERSON_SET;
    EHint.DataSource        := DS;  EHint.DataField        := PPERSON_HINT;

    BtnAuto.OnClick         := BtnAutoClick;
    BtnClose.OnKeyDown      := BtnCloseKeyDown;
    BtnClose.ModalResult    := mrOk;

    PControl.TabIndex       := TableReadVar(@FFMAIN.BUD.TSYS, F_UD_SYS_PERSON_PAGE, PControl.TabIndex);

    AList.Images            := FMAIN.ImgSys16;
    AVer.ImageIndex         := ICO_VERIFY;
    BtnVer.Action           := AVer;
end;


{==============================================================================}
{============================   ЗАКРЫТИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_PPERSON.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    TableWriteVar(@FFMAIN.BUD.TSYS, F_UD_SYS_PERSON_PAGE, PControl.TabIndex);
    {Записываем значение переменной}
    DS.DataSet.Refresh;
    DS.Free;

    {Обновляем таблицу УД}
    ReOpenDataSet(PADODataSet(@FFMAIN.BUD.TPPERSON));
end;


{==============================================================================}
{=====================   КОРРЕКТИРОВКА СПИСКОВ CBOX    ========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_PPERSON.BtnListClick(Sender: TObject);
var CBox : TDBComboBox;
    SID  : String;
begin
    {Инициализация}
    CBox := TDBComboBox(Sender);

    {Поиск идентификатора списка}
    SID := '';
    If CBox.Name='BtnGragd'      then SID:=LIST_GRAGD;
    If CBox.Name='BtnEducation'  then SID:=LIST_EDUCATION;
    If CBox.Name='BtnFamily'     then SID:=LIST_FAMILY;
    If CBox.Name='BtnBornPlace'  then SID:=LIST_BORN_PLACE;
    If CBox.Name='BtnSoderg'     then SID:=LIST_SODERG;
    If CBox.Name='BtnDocType'    then SID:=LIST_DOC_TYPE;
    If CBox.Name='BtnDocPlace'   then SID:=LIST_DOC_PLACE;
    If SID='' then Exit;

    RefreshListItem(@FFMAIN.BSET_LOCAL.TLIST, SID);
    CBoxSetItem;
end;


{==============================================================================}
{=======================   УСТАНОВКА СПИСКОВ CBOX    ==========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_PPERSON.CBoxSetItem;
begin
    GetListItemCBox(@EStatus,    @FFMAIN.BSET_GLOBAL.TLSTATUS, LSTATUS_MIP, '['+LSTATUS_PPERSON+']=TRUE'); // '(['+LSTATUS_PPERSON+']=TRUE) AND (['+LSTATUS_UG+']=TRUE)');
    GetListItemCBox(@EGragd,     @FFMAIN.BSET_LOCAL.TLIST,     LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_GRAGD));
    GetListItemCBox(@EEducation, @FFMAIN.BSET_LOCAL.TLIST,     LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_EDUCATION));
    GetListItemCBox(@EFamily,    @FFMAIN.BSET_LOCAL.TLIST,     LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_FAMILY));
    GetListItemCBox(@EBornPlace, @FFMAIN.BSET_LOCAL.TLIST,     LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_BORN_PLACE));
    GetListItemCBox(@ESoderg,    @FFMAIN.BSET_LOCAL.TLIST,     LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_SODERG));
    GetListItemCBox(@EDocType,   @FFMAIN.BSET_LOCAL.TLIST,     LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_DOC_TYPE));
    GetListItemCBox(@EDocPlace,  @FFMAIN.BSET_LOCAL.TLIST,     LIST_VALUE,  '['+LIST_CATEGORY+']='+QuotedStr(LIST_DOC_PLACE));

    {Для корректного отображения полей}
    DS.DataSet.Refresh;
end;


{==============================================================================}
{=========================   EDATE: ИЗМЕНЕНИЕ ДАТЫ   ==========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_PPERSON.EDateChange(Sender: TObject);
var EDate : TDateTimePicker;
    SID   : String;

   procedure SetLBornOld;
   var Year, Mounth, Day, Hour: Integer;
       S: String;
   begin
       DateTimeDiff0(EBornDate.Date, Now, Hour, Day, Mounth, Year);
       S:='';
       If Year<18  then S:=' (несовершеннолетний)';
       If Year<14  then S:=' (малолетний)';
       If Year>=70 then S:=' (престарелый)';
       If Year<8   then S:=S+' ?';
       If Year>100 then S:=S+' ?';
       If Year<0   then S:=' (ОШИБКА)';

       If S='' then LBornOld.Font.Color := clBlack
               else LBornOld.Font.Color := clRed;

       LBornOld.Caption:=IntToStr(Year)+S;
   end;

   procedure SetLDocOld;
   var Year, Mounth, Day, Hour: Integer;
       S: String;
   begin
       DateTimeDiff0(EDocDate.Date, Now, Hour, Day, Mounth, Year);
       S:='';
       If Year>100 then S:=S+' ?';
       If Year<0   then S:=' (ОШИБКА)';

       If S='' then LDocOld.Font.Color := clBlack
               else LDocOld.Font.Color := clRed;

       LDocOld.Caption:=IntToStr(Year)+' г. '+IntToStr(Mounth)+' м. '+IntToStr(Day)+' д. '+S;
   end;

begin
    If Sender <> nil then begin
       EDate := TDateTimePicker(Sender);
       SID   := '';
       If EDate.Name='EBornDate' then SID:=PPERSON_BORN_DATE;
       If EDate.Name='EDocDate'  then SID:=PPERSON_DOC_DATE;
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
    SetLBornOld;
    SetLDocOld;
end;


{==============================================================================}
{=============================   EIP: ON_CHANGE   =============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_PPERSON.EIPChange(Sender: TObject);
begin
    Caption         := T_UD_PPERSON+': '+EIP.Text;
    BtnAuto.Enabled := GetColSlov(EIP.Text, ' ') > 1;
end;


{==============================================================================}
{===========================   EStatus: ON_CHANGE   ===========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_PPERSON.EStatusChange(Sender: TObject);
var B: Boolean;
begin
    B := CmpStrList(EStatus.Text,[PPERSON_STATE_SUSPECT, PPERSON_STATE_ACCUSED, PPERSON_STATE_STUPID]) >= 0;

    If B then EArt.Color := clWindow else EArt.Color := clBtnFace;
    EArt.Enabled := B;
    LArt.Enabled := B;
    AArt.Enabled := B;
end;


{==============================================================================}
{=============================   EArt: ON_CHANGE   ============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_PPERSON.EArtChange(Sender: TObject);
begin
    If VerifyArticles(EArt.Text) then EArt.Font.Color := clWindowText
                                 else EArt.Font.Color := clRed;
end;


{==============================================================================}
{==========================   BTN_AUTO: ON_CLICK   ============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_PPERSON.BtnAutoClick(Sender: TObject);
var FIO: String;
    Sex: Boolean;
begin
    With EIP.DataSource.DataSet do begin
       FIO:=FieldByName(PPERSON_FIO).AsString;
       Sex:=GetSexFIO(FIO);
       Edit;
       FieldByName(PPERSON_SEX).AsBoolean := Sex;
       FieldByName(PPERSON_FIO_RP).AsString := PadegFIO('Р', FIO);
       FieldByName(PPERSON_FIO_DP).AsString := PadegFIO('Д', FIO);
       FieldByName(PPERSON_FIO_VP).AsString := PadegFIO('В', FIO);
       FieldByName(PPERSON_FIO_TP).AsString := PadegFIO('Т', FIO);
       FieldByName(PPERSON_FIO_PP).AsString := PadegFIO('П', FIO);
       UpdateRecord;
       Post;
    end;
end;


{==============================================================================}
{========================   BTN_CLOSE: ON_KEY_DOWN   ==========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_PPERSON.BtnCloseKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    Case Key of
    27: {ESC} ModalResult := mrOk;
    end;
end;


{==============================================================================}
{============================   ACTION: VERUFY   ==============================}
{==============================================================================}
procedure TFVAR_UD_EDIT_PPERSON.AVerExecute(Sender: TObject);
begin
    With ESet.DataSource.DataSet do begin
       Edit;
       FieldByName(ESet.DataField).AsString:=VerifyText(ESet.Lines.Text, true, true, true);
       UpdateRecord;
       Post;
    end;
end;


{==============================================================================}
{==========================   ACTION: КОММЕНТАРИЙ   ===========================}
{==============================================================================}
procedure TFVAR_UD_EDIT_PPERSON.AArtExecute(Sender: TObject);
begin
    InfoUK(EArt.text);
end;


end.
