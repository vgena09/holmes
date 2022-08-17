unit MBDLIST;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.DBCtrls,
  Data.DB, Data.Win.ADODB,
  FunType;

type
  TGridAccess = class(TCustomGrid);
  TFBDList = class(TForm)
    DBGrid: TDBGrid;
    BtnClose: TButton;
    Nav: TDBNavigator;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure T_ListAfterInsert(DataSet: TDataSet);
    procedure DBGridResize(Sender: TObject);
  private
    DS       : TDataSource;
    T        : TADOTable;
    Category : String;
  public
    procedure Execute(const PTable: PADOTable; const sCategory: String);
 end;

var
  FBDList: TFBDList;

implementation

uses FunConst, FunSys, FunBD;

{$R *.dfm}


{******************************************************************************}
{****************************  ВНЕШНЯЯ ФУНКЦИЯ  *******************************}
{******************************************************************************}
procedure TFBDList.Execute(const PTable: PADOTable; const sCategory: String);
begin
    If sCategory = ''  then Exit;
    If PTable    = nil then Exit;
    T := LikeTable(PTable); If T = nil then Exit;

    Category := sCategory;
    Caption  := 'Редактирование списка: '+Category;

    SetDBFilter(@T, '['+LIST_CATEGORY+']='+QuotedStr(Category));
    T.Sort        := '['+LIST_VALUE+'] ASC';
    T.AfterInsert := T_ListAfterInsert;
    DS.DataSet := T;
        //Columns[0].Title.Caption := LIST_VALUE;
    DBGrid.Columns[0].Field := T.FieldByName(LIST_VALUE);

    ShowModal;
end;


{==============================================================================}
{=============================  СОЗДАНИЕ ФОРМЫ  ===============================}
{==============================================================================}
procedure TFBDList.FormCreate(Sender: TObject);
begin
    {Инициализация}
    DS       := TDataSource.Create(Self);
    Category := '';
    With DBGrid do begin
        ReadOnly   := false;
        DataSource := DS;
        Options    := Options + [dgAlwaysShowSelection, dgEditing]
                              - [dgIndicator, dgMultiSelect,
                                 dgTitles, dgTitleClick, dgTitleHotTrack,
                                 dgColLines, dgRowLines];
        Columns.Clear;
        Columns.Add;
    end;
    With TGridAccess(DBGrid) do begin
       Options    := Options - [goColMoving];
       ScrollBars := ssNone;
       OnResize   := DBGridResize;
    end;
    Nav.DataSource := DS;
    BtnClose.ModalResult := mrOk;
end;


{==============================================================================}
{============================   ЗАКРЫТИЕ ФОРМЫ    =============================}
{==============================================================================}
procedure TFBDList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    DS.DataSet.Refresh;  //Для обновления редактируемых перед закрытием полей
    DS.Free;
    If T.Active then T.Close; T.Free;
end;



{==============================================================================}
{=======================   TABLE: ON_AFTER_INSERT    ==========================}
{==============================================================================}
procedure TFBDList.T_ListAfterInsert(DataSet: TDataSet);
begin
    With DataSet do begin
       If FieldByName(LIST_CATEGORY).AsString <> Category then begin
          DisableControls;
          Edit;
          FieldByName(LIST_CATEGORY).AsString:=Category;
          UpdateRecord;
          Post;
          EnableControls;
       end;
    end;
end;



{==============================================================================}
{===========================   GRID: ON_RESIZE    =============================}
{==============================================================================}
procedure TFBDList.DBGridResize(Sender: TObject);
begin
    DBGrid.Columns[0].Width := DBGrid.ClientWidth;
end;



end.
