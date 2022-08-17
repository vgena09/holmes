unit FunOutlook;

interface
  uses Winapi.Windows,
       System.SysUtils, System.Variants, System.Win.ComObj,
       Vcl.Graphics, Vcl.OleCtnrs, Vcl.OleServer,
       ActiveX, Outlook2000,
       FunType;

  // ActiveX         - GetActiveObject
  // ComObj, ActiveX - Outlook

const
   olFolderDeletedItems = $00000003; // ����� �Deleted Items�
   olFolderOutbox       = $00000004; // ����� �Outbox�
   olFolderSentMail     = $00000005; // ����� �Sent�
   olFolderInbox        = $00000006; // ����� �Inbox�
   olFolderCalendar     = $00000009; // ����� �Calendar�
   olFolderContacts     = $0000000A; // ����� �Contacts�
   olFolderJournal      = $0000000B; // ����� �Journal�
   olFolderNotes        = $0000000C; // ����� �Notes�
   olFolderTasks        = $0000000D; // ����� �Tasks�
   olFolderDrafts       = $00000010; // ����� �Drafts�

   olMailItem           = $00000000; // �������� ���������
   olAppointmentItem    = $00000001; // �������
   olContactItem        = $00000002; // �������
   olTaskItem           = $00000003; // ������
   olJournalItem        = $00000004; // ������ � �������
   olNoteItem           = $00000005; // �������
   olPostItem           = $00000006; // ���������, ���������� ��� ������ �������

   {��������� �������� ������ �������� �������}
   olBlue               = $00000000; // �����
   olGreen              = $00000001; // �������
   olPink               = $00000002; // �������
   olYellow             = $00000003; // ������
   olWhite              = $00000004; // �����

   olCategoryColorRed        = $00000001;
   olCategoryColorGreen      = $00000005;
   olCategoryColorBlue       = $00000008;
   olCategoryColorDarkBlue   = $00000017;

   olCategoryShortcutKeyNone = $00000000;


{������������ � OUTLOOK}
function ConnectOutlook: Boolean;                                               StdCall
{����������� �� OUTLOOK}
procedure DisconnectOutlook;                                                    StdCall

{������� ���������}
function  CreateCategory(const Category: String; const Color: Integer): Boolean; StdCall
{���������� �� ���������}
function ExistCategory(const Category: String): Boolean;                        StdCall


var App   : Variant;              // ID OLE
    IsRun : Boolean;              // ������� �� ����� Outlook
    MAPI  : OLEVariant;

implementation

uses FunConst, FunText;


{******************************************************************************}
{************************  ������������ � OUTLOOK  ****************************}
{******************************************************************************}
function ConnectOutlook: Boolean;
const ID = 'Outlook.Application';
var Res     : HResult;
    Unknown : IUnknown;
begin
    Result := true;
    try
       Res := GetActiveObject(ProgIDToClassID(ID), nil, Unknown);
       If (Res = MK_E_UNAVAILABLE) then begin
          App   := CreateOleObject(ID);
          IsRun := false;
       end else begin
          App   := GetActiveOleObject(ID);
          IsRun := true;
       end;
       MAPI := App.GetNameSpace('MAPI');
    except Result := false;
    end;
end;


{******************************************************************************}
{************************  ����������� �� OUTLOOK  ****************************}
{******************************************************************************}
procedure DisconnectOutlook;
begin
    try If not IsRun then App.Quit;
        MAPI := Unassigned;
        App  := Unassigned;
    except
    end;
end;


{******************************************************************************}
{************************  ���������� �� ���������  ***************************}
{******************************************************************************}
function ExistCategory(const Category: String): Boolean;
var I: Integer;
begin
    Result := false;
    try    For I:= 1 to MAPI.Categories.Count do begin
              Result := CmpStr(MAPI.Categories.Item(I), Category);
              If Result then Break;
           end;
    except Result := false;
    end;
end;


{******************************************************************************}
{***************************  ������� ���������  ******************************}
{******************************************************************************}
function CreateCategory(const Category: String; const Color: Integer): Boolean;
begin
    Result := false;
    try
       If not ExistCategory(Category) then MAPI.Categories.Add(Category, Color, olCategoryShortcutKeyNone);
       Result := true;
    except
    end;
end;


end.
