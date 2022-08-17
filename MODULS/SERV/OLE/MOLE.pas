unit MOLE;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtnrs,
  Data.DB, Data.Win.ADODB,
  FunType, MAIN, WordXP, Vcl.OleServer, Vcl.ExtCtrls;

type
  {���������� ��� �������� ���� ������� ������}
  TEventCloseDoc = procedure(const F: TForm) of object;

  TFOLE = class(TForm)
    Ole   : TOleContainer;
    Timer : TTimer;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);

  private
    FFMAIN        : TFMAIN;
    QDOC_UD       : TADOQuery;
    EventCloseDoc : TEventCloseDoc;

    procedure SaveOle;
    function  DecoderOLE(const ID_DOC: String): Boolean;

  public
    IDDoc : Integer;
    function  ImportDoc(const ID: Integer; const SPath: String): Boolean;
    function  OpenDoc(const ID: Integer; const IsForceDecod: Boolean; const Event: TEventCloseDoc): Boolean;
  end;

var
  FOLE: TFOLE;

implementation

uses FunConst, FunSys, FunOle, FunVcl, FunIni, FunBD, FunText,
     MDECOD_OLE;

{$R *.dfm}


{==============================================================================}
{============================   �������� �����    =============================}
{==============================================================================}
procedure TFOLE.FormCreate(Sender: TObject);
begin
    {�������������}
    FFMAIN  := TFMAIN(GlFindComponent('FMAIN'));
    QDOC_UD := nil;

    {�����}
    FormStyle   := fsStayOnTop;
    BorderStyle := bsSizeable;

    {OLE}
    With Ole do begin
       AllowInPlace   := false;          // ��������� � ��������� ����
       Iconic         := false;
       AllowActiveDoc := false;          // ��� ��������� ���������� IOleDocumentSite
       AutoActivate   := aaManual;       // ��� �������������
       AutoVerbMenu   := false;          // ��� ���� OLE-�������
       CopyOnSave     := true;           // ������� ����� �����������
       SizeMode       := smScale;
    end;

    {������}
    With Timer do begin
       Interval       := 300;
       Enabled        := false;
       OnTimer        := TimerTimer;
    end;
end;

{==============================================================================}
{===========================   ���������� �����    ============================}
{==============================================================================}
procedure TFOLE.FormDestroy(Sender: TObject);
begin
    Timer.Enabled := false;
    If OLE.State <> osEmpty then begin
       OLE.Close;
       OLE.DestroyObject;
    end;
    If QDOC_UD <> nil then begin
       if QDOC_UD.Active then QDOC_UD.Close;
       QDOC_UD.Free;
    end;
end;


{==============================================================================}
{============================  ������� �������  ===============================}
{==============================================================================}
{==========================   ������ ���������   ==============================}
{==============================================================================}
function TFOLE.ImportDoc(const ID: Integer; const SPath: String): Boolean;
var Q: TADOQuery;
begin
    Result := false;
    Q := TADOQuery.Create(Self);
    try
       {������������� ������� ����������}
       With Q do begin
          Connection := FFMAIN.BUD.BD;
          SQL.Text   := 'SELECT * FROM ['+T_UD_DOC+'] WHERE ['+F_COUNTER+']='+IntToStr(ID)+';';
          Open;
          If RecordCount <> 1 then begin ErrMsg('�������� �� ��������������� � ���� ����.'); Exit; end;
       end;

       {������ �������� � OLE - ��� WORD}
       If FindStrInArray(ExtractFileExt(SPath), ['.doc', '.docx']) > -1 then begin
          WordToOle(@OLE, SPath);
          OleToField(@OLE, PADODataSet(@Q));
          Q.Refresh;
          DecoderOLE(IntToStr(ID));
       end;

       {��������� ������� ����������}
       RefreshTable(@FFMAIN.BUD.TDOC);
       Result := true;
    finally
       If Q.Active then Q.Close; Q.Free;
    end;
end;

{==============================================================================}
{============================  ������� �������  ===============================}
{==============================================================================}
{=========   ��������� ������ � �������� ������������� �� ����   ==============}
{==============================================================================}
function TFOLE.OpenDoc(const ID: Integer; const IsForceDecod: Boolean; const Event: TEventCloseDoc): Boolean;
var SPath: String;
begin
    Result        := false;
    IDDoc         := ID;
    EventCloseDoc := Event;

    try
       {��.mdb : ���������}
       QDOC_UD := TADOQuery.Create(Self);
       With QDOC_UD do begin
          Connection := FFMAIN.BUD.BD;
          SQL.Text   := 'SELECT * FROM ['+T_UD_DOC+'] WHERE ['+F_COUNTER+']='+IntToStr(IDDoc)+';';
          Open;
          If RecordCount <> 1 then begin ErrMsg('�������� �� ��������������� � ���� ����.'); Exit; end;
       end;

       {*** ������ ��� ������������� ******************************************}
       If QDOC_UD.FieldByName(F_UD_DOC_AUTO).AsBoolean then begin
          {���� � ������}
          SPath := QDOC_UD.FieldByName(F_UD_DOC_PATH_FULL).AsString;
          If Not FileExists(SPath) then SPath := PATH_DATA_DOC + QDOC_UD.FieldByName(F_UD_DOC_PATH_SHORT).AsString;
          If Not FileExists(SPath) then  begin ErrMsg('����� ��������� �� ������:'+CH_NEW+SPath+CH_NEW+QDOC_UD.FieldByName(F_UD_DOC_PATH_FULL).AsString); Exit; end;

          {���� � ������ ��� ��������� ��� ��������� - ��������� ����� � ���������� ���}
          If IsForceDecod or QDOC_UD.FieldByName(F_UD_DOC_OLE).IsNull then begin
             WordToOle(@OLE, SPath);
             OleToField(@OLE, PADODataSet(@QDOC_UD));
             DecoderOLE(IntToStr(ID));
          end;

       end;
       {***********************************************************************}

       {��������� OLE}
       QDOC_UD.Refresh;
       FieldToOle(PADODataSet(@QDOC_UD), @OLE);

       {������� OLE}
       If OLE.State = osEmpty then begin ErrMsg('�������� ����������� � ���� ������.'); Exit; end;
       OLE.DoVerb(ovOpen);

       {������� ���������}
       If FindStr(OLE.OleClassName, 'Word.Document') > -1 then begin
          OLE.OleObject.Application.ActiveWindow.ActivePane.View.Zoom.Percentage := ReadLocalInteger(INI_SET, INI_SET_ZOOM_WORD, 100);
       end;

       Result        := true;
       Timer.Enabled := true;
    finally
    end;
end;


{==============================================================================}
{================================  ������  ====================================}
{==============================================================================}
procedure TFOLE.TimerTimer(Sender: TObject);
begin
    Timer.Enabled := false;
    If OLE.State <> osOpen then begin
       SaveOle;
       Close;
       EventCloseDoc(Self);
    end else Timer.Enabled := true;
end;


{==============================================================================}
{============================  ���������� OLE  ================================}
{==============================================================================}
procedure TFOLE.SaveOle;
begin
    If OLE.State = osEmpty then Exit;
    OleToField(@OLE, PADODataSet(@QDOC_UD));
    RefreshTable(@FFMAIN.BUD.TDOC);
end;


{==============================================================================}
{==============================  ������� OLE  =================================}
{==============================================================================}
function TFOLE.DecoderOLE(const ID_DOC: String): Boolean;
var F: TFDECOD_OLE;
begin
    Result := false;
    F := TFDECOD_OLE.Create(Self);
    try     Result := F.Execute(ID_DOC);
    finally F.Free; end;
end;

end.
