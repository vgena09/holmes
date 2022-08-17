unit MVAR;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, Vcl.Menus,
  Vcl.ImgList, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Data.Win.ADODB,
  FunConst, FunType, MAIN;

type
  TGridAccess = class(TCustomGrid);
  TFVAR = class(TForm)
    ActionList1: TActionList;
    Splitter: TSplitter;
    PMain: TPanel;
    DBGrid: TDBGrid;
    PBottom: TPanel;
    BtnClose: TBitBtn;
    AClose: TAction;
    AOk: TAction;
    BtnOk: TBitBtn;
    CBShowAll: TCheckBox;
    AShowAll: TAction;
    CBShowRun: TCheckBox;
    AShowRun: TAction;

    {������: MVAR_GRID}
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
                    DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridResize(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure QGetText(Sender: TField; var Text: String; DispalayText: Boolean);

    {������: MVAR}
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ADOQVARBeforeScroll(DataSet: TDataSet);
    procedure ADOQVARAfterScroll(DataSet: TDataSet);
    procedure ACloseExecute(Sender: TObject);
    procedure AOkExecute(Sender: TObject);
    procedure AShowAllExecute(Sender: TObject);
    procedure ADOQueryFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    function  ValidateValue(const P: PADODataSet): Boolean;
    procedure AShowRunExecute(Sender: TObject);

  private
    FFMAIN       : TFMAIN;
    DS           : TDataSource;
    PQVAR        : PADOQuery;
    PTSAV        : PADOTable;
    SDOC_COUNTER : String;
    LIST_OK      : array of Boolean;         // �������� ���������� ����������

    {������: MVAR_GRID}
    procedure IniGrid;
    procedure SaveSel;
    procedure LoadSel;

    {������: MVAR}

  public
    function Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable; const IDOC_COUNTER: Integer): Integer;
  end;

const GRID_COL : array [0..1] of String = (F_VAR_CAPTION, F_VAR_VAL_STR);
      GRID_COL_CAPTION  = 0;
      GRID_COL_STR      = 1;

var
  FVAR: TFVAR;

implementation

uses FunSys, FunVcl, FunText, FunIni, FunBD, FunIDE, FunList,
     MVAR_EDIT, MVAR_MEMO, MVAR_DATE, MVAR_SELECT, MVAR_UD, MVAR_EXPERT,
     MVAR_OLE, MVAR_REST;
//     MVAR_FILE,

{$R *.dfm}
{$INCLUDE MVAR_GRID}

{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
{!!!!!!!!!!!  � ��������� ���������� ��������� ������ ����������  !!!!!!!!!!!!!}
{!!!!!!!!!!!  ��������� - � ���� ������ ����                      !!!!!!!!!!!!!}
{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}

{******************************************************************************}
{***********                 ������� �������                       ************}
{******************************************************************************}
{***********  IDOC_COUNTER - F_COUNTER BUD.T_UD_DOC, �/� = 0       ************}
{******************************************************************************}
function TFVAR.Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable;
                       const IDOC_COUNTER: Integer): Integer;
var I, ICount: Integer;
begin
    {�������������}
    Result := mrCancel;
    If PPQVar = nil            then Exit;
    If PPQVar^.RecordCount = 0 then Exit;
    PQVAR              := PPQVAR;
    PTSAV              := PPTSAV;
    SDOC_COUNTER       := IntToStr(IDOC_COUNTER);

    DS.DataSet            := PQVAR^;
    PQVAR^.Filter         := '';
    PQVAR^.Filtered       := false;
    PQVAR^.OnFilterRecord := ADOQueryFilterRecord;
    PQVAR^.FieldByName(F_VAR_VAL_STR).OnGetText := QGetText;
    try
       {�������� ���������� ����������}
       ICount := PQVAR^.RecordCount;
       SetLength(LIST_OK,  ICount);
       PQVAR^.First;
       For I := 0 to ICount-1 do begin
          LIST_OK [I] := ValidateValue(PADODataSet(PQVAR));
          PQVAR^.Next;
       end;

       {��������������� ��������� �� Ini}
       LoadFormIni(Self, [fspPosition], Screen.Width Div 4 * 3, Screen.Height Div 6 * 5);
       AShowAll.Checked := false; //ReadLocalBool(INI_VAR, INI_VAR_SHOWALL, false);
       AShowAllExecute(nil);
       AShowRun.Checked := ReadLocalBool(INI_VAR, INI_VAR_SHOWRUN, true);

       IniGrid;

       If PQVAR^.RecordCount > 0 then Result := ShowModal
                                 else Result := mrOk;
    finally
       With PQVAR^ do begin
          FieldByName(F_VAR_VAL_STR).OnGetText := nil;
          Filtered       := false;
          Filter         := '';
          OnFilterRecord := nil;
       end;
    end;
end;


{==============================================================================}
{=============================  �������� �����  ===============================}
{==============================================================================}
procedure TFVAR.FormCreate(Sender: TObject);
begin
    {�������������}
    FFMAIN  := TFMAIN(GlFindComponent('FMAIN'));
    DS      := TDataSource.Create(Self);
    Caption := '����������';

    BtnOk.Action      := AOk;
    BtnClose.Action   := AClose;

    CBShowAll.Visible := true;
    CBShowRun.Visible := false;

    SetLength(LIST_OK, 0);
end;


{==============================================================================}
{==============================  ����� �����  =================================}
{==============================================================================}
procedure TFVAR.FormShow(Sender: TObject);
begin
    {������������� ����� �����}
    DBGrid.SetFocus;
end;


{==============================================================================}
{============================   �������� �����    =============================}
{==============================================================================}
procedure TFVAR.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    {��������� ��������� � Ini}
    SaveFormIni(Self, [fspPosition]);

    {��������� �������� ����������}
    LoadSubForm(PMain, nil, true);

    PQVAR^.FieldByName(F_VAR_VAL_STR).OnGetText := nil;
    PQVAR^.BeforeScroll := nil;
    PQVAR^.AfterScroll  := nil;
    DS.Free;

    SetLength(LIST_OK, 0);

    FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := '';
end;


{==============================================================================}
{=======================  ACTION: ������������ ��������  ======================}
{==============================================================================}
procedure TFVAR.AOkExecute(Sender: TObject);
begin
    ModalResult := mrOk;
end;

{==============================================================================}
{===========================  ACTION: ������� ����  ===========================}
{==============================================================================}
procedure TFVAR.ACloseExecute(Sender: TObject);
begin
    ModalResult := mrCancel;
end;


{==============================================================================}
{=========================   SQL: ��������� �������   =========================}
{==============================================================================}
procedure TFVAR.ADOQVARBeforeScroll(DataSet: TDataSet);
begin
    {��������� �������� ����������}
    LoadSubForm(PMain, nil, true);
end;

procedure TFVAR.ADOQVARAfterScroll(DataSet: TDataSet);
var VFormClass : TFormClass;
    VForm      : TForm;
    VTip       : String;
begin
    {��������� ���������}
    SaveSel;

    {�������� �������� �� ���� ����������}
    FFMAIN.StatusBar.Panels[STATUS_MAIN].Text := PQVAR^.FieldByName(F_VAR_HINT).AsString;
    VTip       := PQVAR^.FieldByName(F_VAR_TYPE).AsString;
    VFormClass := nil;
    VForm      := nil;
    If CmpStr(VTip, F_VAR_TYPE_EDIT)     then VFormClass:=TFVAR_EDIT;
    If CmpStr(VTip, F_VAR_TYPE_MEMO)     then VFormClass:=TFVAR_MEMO;
    If CmpStr(VTip, F_VAR_TYPE_DATE)     then VFormClass:=TFVAR_DATE;
    If CmpStr(VTip, F_VAR_TYPE_SELECT)   then VFormClass:=TFVAR_SELECT;
    If CmpStr(VTip, F_VAR_TYPE_REST)     then VFormClass:=TFVAR_REST;
    If CmpStr(VTip, F_VAR_TYPE_UD)       then VFormClass:=TFVAR_UD;
    If CmpStr(VTip, F_VAR_TYPE_OLE)      then VFormClass:=TFVAR_OLE;
    If CmpStr(VTip, F_VAR_TYPE_EXPERT)   then VFormClass:=TFVAR_EXPERT;
//    If CmpStr(VTip, AVAR_TYPE_FILE)     then VFormClass:=TFVAR_FILE;
    If VFormClass = nil then Exit;
    VForm := LoadSubForm(PMain, VFormClass, true);   //FormDisplayVar.AddFormClass(VFormClass, true) LoadSubForm(PMain, TFDOC, true) LoadSubForm(PMain, nil, true);
    If VForm = nil then Exit;
    If CmpStr(VTip, F_VAR_TYPE_EDIT)     then TFVAR_EDIT     (VForm).Execute(PQVAR, PTSAV);
    If CmpStr(VTip, F_VAR_TYPE_MEMO)     then TFVAR_MEMO     (VForm).Execute(PQVAR, PTSAV);
    If CmpStr(VTip, F_VAR_TYPE_DATE)     then TFVAR_DATE     (VForm).Execute(PQVAR, PTSAV);
    If CmpStr(VTip, F_VAR_TYPE_SELECT)   then TFVAR_SELECT   (VForm).Execute(PQVAR, PTSAV);
    If CmpStr(VTip, F_VAR_TYPE_REST)     then TFVAR_REST     (VForm).Execute(PQVAR, PTSAV);
    If CmpStr(VTip, F_VAR_TYPE_UD)       then TFVAR_UD       (VForm).Execute(PQVAR, PTSAV);
    If CmpStr(VTip, F_VAR_TYPE_OLE)      then TFVAR_OLE      (VForm).Execute(PQVAR, PTSAV);
    If CmpStr(VTip, F_VAR_TYPE_EXPERT)   then TFVAR_EXPERT   (VForm).Execute(PQVAR, PTSAV);
//    If CmpStr(VTip, AVAR_TYPE_FILE)     then TFVAR_FILE     (VForm).Execute(PQVAR, PTSAV);
end;


{==============================================================================}
{====================  ACTION: �������� ��� ����������  =======================}
{==============================================================================}
procedure TFVAR.AShowAllExecute(Sender: TObject);
begin
    //If Sender <> nil then WriteLocalBool(INI_VAR, INI_VAR_SHOWALL, AShowAll.Checked);
    PQVAR^.Filtered := not AShowAll.Checked;
end;


{==============================================================================}
{=================  ACTION: �������� ��� ������� ���������  ===================}
{==============================================================================}
procedure TFVAR.AShowRunExecute(Sender: TObject);
begin
   WriteLocalBool(INI_VAR, INI_VAR_SHOWRUN, AShowRun.Checked);
end;

{==============================================================================}
{=======================  QUERY: ����������-������  ===========================}
{==============================================================================}
procedure TFVAR.ADOQueryFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
    Accept := true;
    If not Assigned(DataSet.FieldByName(F_VAR_PARAM)) then Exit;
    Accept := FindStr(F_VAR_PARAM_SHOW+'=���', DataSet.FieldByName(F_VAR_PARAM).AsString) <= 0;
end;


{==============================================================================}
{==============  ������������ �� �������� ������� ����������  =================}
{==============================================================================}
function TFVAR.ValidateValue(const P: PADODataSet): Boolean;
var LParam : TStringList;
begin
    Result := true;
    LParam := TStringList.Create;
    try     LParam.Text := P^.FieldByName(F_VAR_PARAM).AsString;
            If not CmpStr(LRead(@LParam, F_VAR_PARAM_VALUE, '���'), '��') then Exit;
    finally LParam.Free; end;
    Result := P^.FieldByName(F_VAR_VAL_STR).AsString <> '';
end;


end.
