unit MVAR_SELECT;

interface

uses     
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Variants,
  Vcl.ActnList, Vcl.Controls, Vcl.Forms, Vcl.Graphics, Vcl.ExtCtrls,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Vcl.Buttons,
  Data.DB, Data.Win.ADODB,
  FunType, MAIN;

type
  TFVAR_SELECT = class(TForm)
    AList: TActionList;
    AEditList: TAction;
    BtnEditList: TBitBtn;
    LBox: TCheckListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AEditListExecute(Sender: TObject);
    procedure LBoxClickCheck(Sender: TObject);
    procedure LBoxDblClick(Sender: TObject);
    procedure LBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure LBoxClick(Sender: TObject);
    procedure LBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FFMAIN       : TFMAIN;
    PQVAR        : PADOQuery;
    PTSAV        : PADOTable;
    LParam       : TStringList;
    SCatList     : String;          // ��������� ������ �����������
    IDVar        : String;
    ParamMSelect : Boolean;         // ������� ������������

    procedure LBoxIni;
    function  LBoxLoad: Boolean;
    procedure LBoxSave;
  public
    procedure Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
  end;

var
  FVAR_SELECT: TFVAR_SELECT;

implementation

uses FunConst, FunText, FunList, FunBD, FunBDList, FunIni, FunSys;

{$R *.dfm}

{$INCLUDE MVAR_SELECT_BOX}

{******************************************************************************}
{****************************  ������� �������  *******************************}
{******************************************************************************}
procedure TFVAR_SELECT.Execute(const PPQVAR: PADOQuery; const PPTSAV: PADOTable);
var S       : String;
    IsParam : Boolean;
begin
    {�������������}
    PQVAR       := PPQVAR;
    PTSAV       := PPTSAV;
    IDVar       := PQVAR^.FieldByName(F_COUNTER).AsString;
    LParam.Text := PQVAR^.FieldByName(F_VAR_PARAM).AsString;

    {��������: �����������}
    ParamMSelect := CmpStr(LRead(@LParam, F_VAR_PARAM_KEY_MSELECT, '��'), '��');

    {��������: ��������}
    IsParam := LBoxLoad;

    {��������: ���������}
    S := AnsiUpperCase(LRead(@LParam, F_VAR_PARAM_EDIT_CHANGE, '��'));
    If S <> '���' then begin AEditList.Enabled := IsParam; BtnEditList.Visible := IsParam; end
                  else begin AEditList.Enabled := false;   BtnEditList.Visible := false;   end;
end;


{==============================================================================}
{==========================    �������� �����    ==============================}
{==============================================================================}
procedure TFVAR_SELECT.FormCreate(Sender: TObject);
begin
    {�������������}
    FFMAIN := TFMAIN(GlFindComponent('FMAIN'));
    LParam := TStringList.Create;
    LParam.CaseSensitive := false;
    AList.Images         := FFMAIN.ImgSys16;
    SCatList             := '';
    LBoxIni;
end;


{==============================================================================}
{=========================    ���������� �����    =============================}
{==============================================================================}
procedure TFVAR_SELECT.FormDestroy(Sender: TObject);
begin
    LBoxSave;
    LParam.Free;
end;


{==============================================================================}
{===========================    ACTION: EDIT    ===============================}
{==============================================================================}
procedure TFVAR_SELECT.AEditListExecute(Sender: TObject);
begin
    {��������� ������}
    LBoxSave;
    {��������� ���������}
    RefreshListItem(@FFMAIN.BSET_LOCAL.TLIST, SCatList);
    {��������� ������}
    LBoxLoad;
    LBoxSave;
end;


{==============================================================================}
{======================          LBOX: ��������          ======================}
{==============================================================================}
{======================  Result - ���� � ���� ���������  ======================}
{==============================================================================}
function TFVAR_SELECT.LBoxLoad: Boolean;
var LVal      : TStringList;
    Ind, IVal : Integer;
begin
    Result := false;
    LVal   := TStringList.Create;
    LBox.Items.BeginUpdate;
    try

       {��������� ������}
       LSectionCopy(@LParam, @LBox.Items, F_VAR_PARAM_EDIT_VARIANTS); // ���� � ���� ������
       If LBox.Count = 0 then begin                                   // ���� � ���� ���������
          SCatList := LRead(@LParam, F_VAR_PARAM_EDIT_VARIANTS, '');
          If SCatList <> '' then begin
             LBox.Items.Text := GetListItem(@FFMAIN.BSET_LOCAL.TLIST, LIST_VALUE, '['+LIST_CATEGORY+']='+QuotedStr(SCatList));
             Result := true;
          end;
       end;

       {***** ����������� *****************************************************}
       If ParamMSelect then begin
          {�������� ������}
          LVal.Text := PQVAR^.FieldByName(F_VAR_VAL_STR).AsString;
          For Ind:=0 to LVal.Count-1 do begin
             IVal := LBox.Items.IndexOf(LVal[Ind]);
             If IVal >= 0 then LBox.Checked[IVal] := true;
          end;

         {���������}
          If PTSAV <> nil then begin
             Ind := TableReadVar(PTSAV, IDVar+': '+F_UD_SYS_SELECT_SEL, LBox.ItemIndex);
             If Ind > (LBox.Items.Count - 1) then Ind := LBox.Items.Count - 1;
             LBox.ItemIndex := Ind;
          end;

       {***** ���������� ������������ *****************************************}
       end else begin
          LVal.Text := PQVAR^.FieldByName(F_VAR_VAL_STR).AsString;
          If LVal.Count > 0 then LBox.ItemIndex := LBox.Items.IndexOf(LVal[0])
                            else LBox.ItemIndex := -1;
       end;
    finally
       LBox.Items.EndUpdate;
       LVal.Free;
    end;
end;


{==============================================================================}
{======================          LBOX: ����������        ======================}
{==============================================================================}
procedure TFVAR_SELECT.LBoxSave;
var LVal : TStringlist;
    Ind  : Integer;
begin
    LVal := Tstringlist.Create;
    try
       {��������� ��������}
       If ParamMSelect then begin
          For Ind:=0 to LBox.Count-1 do If LBox.Checked[Ind] then LVal.Add(LBox.Items[Ind]);
       end else begin
          Ind := LBox.ItemIndex;
          If Ind >= 0 then LVal.Text := LBox.Items[Ind] else LVal.Text := '';
       end;

       {���������� ��������}
       With PQVAR^ do begin
          Edit;
          FieldByName(F_VAR_VAL_STR).AsString := LVal.Text;
          UpdateRecord;
          Post;
       end;

       {���������}
       If ParamMSelect and (PTSAV <> nil) then  TableWriteVar(PTSAV, IDVar+': '+F_UD_SYS_SELECT_SEL, LBox.ItemIndex);
    finally
       LVal.Free;
    end;
end;

end.
