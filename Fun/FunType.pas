unit FunType;

interface

{!!! �� ������ ���� El-�����������, ��� ��� �������� ��� ������ �� DLL !!!}
uses System.Classes, System.IniFiles,
     Vcl.Forms, Vcl.ComCtrls, Vcl.Graphics, Vcl.Controls, Vcl.Grids,
     Vcl.StdCtrls {TComboBox}, Vcl.DBCtrls {TDBComboBox}, Vcl.Menus {TMenuItem},
     Vcl.OleCtnrs {TOleContainer},
     Data.DB, Data.Win.ADODB;

type
   {*** ��� �������� � ��������� � �������� ***********************************}
   TArrayStr = array of String;
   PArrayStr = ^TArrayStr;

   {*** ��������� ������ ******************************************************}
   TPrmRec = record
     IsKey  : Boolean;
     FName  : String;
     FValue : String;
   end;
   TArrayPrmRec = array of TPrmRec;
   PArrayPrmRec = ^TArrayPrmRec;

   {���������}
   PBoolean       = ^Boolean;
   PString        = ^String;
   PStringList    = ^TStringList;
   PADOConnection = ^TADOConnection;
   PADOTable      = ^TADOTable;
   PADOQuery      = ^TADOQuery;
   PADODataSet    = ^TADODataSet;
   //PField         = ^TField;
   //PBLOBField     = ^TBLOBField;
   PDataSource    = ^TDataSource;
   PDBComboBox    = ^TDBComboBox;
   POleContainer  = ^TOleContainer;
   //PButton        = ^TButton;
   PMenuItem      = ^TMenuItem;
   PStrings       = ^TStrings;
   PTreeView      = ^TTreeView;
   PRichEdit      = ^TRichEdit;
   PStringGrid    = ^TStringGrid;
   PTreeNode      = ^TTreeNode;
   PIniFile       = ^TIniFile;
   PComboBox      = ^TComboBox;
   PMemIniFile    = ^TMemIniFile;
   PCustomIniFile = ^TCustomIniFile;
   PPBitmap       = ^TBitmap;          // !!! ����� PBitmap � ������� ��������� !!!

implementation

end.
