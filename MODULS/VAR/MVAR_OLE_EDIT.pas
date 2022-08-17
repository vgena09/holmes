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
{============================   �������� �����    =============================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.FormCreate(Sender: TObject);
begin
    {�������������}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    DS     := TDataSource.Create(Self);

    With EOle do begin
       AutoActivate   := aaManual;      // ��� �������������
       AutoVerbMenu   := false;         // ��� ���� OLE-�������
       AllowActiveDoc := false;         // ��� ��������� ���������� IOleDocumentSite
       AllowInPlace   := false;         // ��������� � ��������� ����
       CopyOnSave     := true;          // ������� ����� �����������
       Ctl3D          := false;         // ����� ���
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
{============================   �������� �����    =============================}
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
{=======================   TABLE: �������� �� ������   ========================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.TAfterScroll(DataSet: TDataSet);
begin
    Caption:='����� Word: '+IntToStr(T.RecNo)+' �� '+IntToStr(T.RecordCount);
    If T.FieldByName(F_VAR_OLE_OLE).IsNull then BlankWordToOle(@EOle)
                                           else FieldToOle(@T, @EOle);
end;


{==============================================================================}
{=========================   TABLE: ������ � ������   =========================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.TBeforeScroll(DataSet: TDataSet);
begin
    If T.RecordCount = 0 then Exit;
    OleToField(@EOle, @T);
end;

{==============================================================================}
{=========================   TABLE: ����� ���������   =========================}
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
{=========================   ACTION: ����� �� OLE   ===========================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.AAutoExecute(Sender: TObject);
var S: String;
begin
    If T.RecordCount = 0 then Exit;
    S:=GetOLEText(@EOle);
    With T do begin
       Edit;
       FieldByName(F_VAR_OLE_IP).AsString:=LowerStrPart(S, 1, 1);
       FieldByName(F_VAR_OLE_RP).AsString:=LowerStrPart(PadegAUTO('�', S), 1, 1);
       FieldByName(F_VAR_OLE_DP).AsString:=LowerStrPart(PadegAUTO('�', S), 1, 1);
       FieldByName(F_VAR_OLE_VP).AsString:=LowerStrPart(PadegAUTO('�', S), 1, 1);
       FieldByName(F_VAR_OLE_TP).AsString:=LowerStrPart(PadegAUTO('�', S), 1, 1);
       FieldByName(F_VAR_OLE_PP).AsString:=LowerStrPart(PadegAUTO('�', S), 1, 1);
       UpdateRecord;
       Post;
    end;
end;



{******************************************************************************}
{********************************   CBOX   ************************************}
{******************************************************************************}

{==============================================================================}
{=====================   ������������� ������� CBOX    ========================}
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
{=======================   ��������� ������� CBOX    ==========================}
{==============================================================================}
procedure TFVAR_OLE_EDIT.CBoxSetItem;
begin
    GetListItemCBox(@ECat, @FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(LIST_CAT_OLE));
    DS.DataSet.Refresh;
end;


end.


