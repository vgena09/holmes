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
   olFolderDeletedItems = $00000003; // папка «Deleted Items»
   olFolderOutbox       = $00000004; // папка «Outbox»
   olFolderSentMail     = $00000005; // папка «Sent»
   olFolderInbox        = $00000006; // папка «Inbox»
   olFolderCalendar     = $00000009; // папка «Calendar»
   olFolderContacts     = $0000000A; // папка «Contacts»
   olFolderJournal      = $0000000B; // папка «Journal»
   olFolderNotes        = $0000000C; // папка «Notes»
   olFolderTasks        = $0000000D; // папка «Tasks»
   olFolderDrafts       = $00000010; // папка «Drafts»

   olMailItem           = $00000000; // почтовое сообщение
   olAppointmentItem    = $00000001; // встреча
   olContactItem        = $00000002; // контакт
   olTaskItem           = $00000003; // задача
   olJournalItem        = $00000004; // запись в журнале
   olNoteItem           = $00000005; // заметка
   olPostItem           = $00000006; // сообщение, помещаемое для общего доступа

   {Возможные значения цветов подложки заметок}
   olBlue               = $00000000; // синий
   olGreen              = $00000001; // зеленый
   olPink               = $00000002; // розовый
   olYellow             = $00000003; // желтый
   olWhite              = $00000004; // белый

   olCategoryColorRed        = $00000001;
   olCategoryColorGreen      = $00000005;
   olCategoryColorBlue       = $00000008;
   olCategoryColorDarkBlue   = $00000017;

   olCategoryShortcutKeyNone = $00000000;


{ПОДКЛЮЧИТЬСЯ К OUTLOOK}
function ConnectOutlook: Boolean;                                               StdCall
{ОТКЛЮЧИТЬСЯ ОТ OUTLOOK}
procedure DisconnectOutlook;                                                    StdCall

{СОЗДАТЬ КАТЕГОРИЮ}
function  CreateCategory(const Category: String; const Color: Integer): Boolean; StdCall
{СУЩЕСТВУЕТ ЛИ КАТЕГОРИЯ}
function ExistCategory(const Category: String): Boolean;                        StdCall


var App   : Variant;              // ID OLE
    IsRun : Boolean;              // запущен ли ранее Outlook
    MAPI  : OLEVariant;

implementation

uses FunConst, FunText;


{******************************************************************************}
{************************  ПОДКЛЮЧИТЬСЯ К OUTLOOK  ****************************}
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
{************************  ОТКЛЮЧИТЬСЯ ОТ OUTLOOK  ****************************}
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
{************************  СУЩЕСТВУЕТ ЛИ КАТЕГОРИЯ  ***************************}
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
{***************************  СОЗДАТЬ КАТЕГОРИЮ  ******************************}
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
