unit FunConst;

interface

var
    PATH_PROG        : String;   // СЕРВЕР: путь к файлу программы
    PATH_PROG_INI    : String;   // СЕРВЕР: путь к файлу глобальных настроек
    PATH_DATA        : String;   // СЕРВЕР: путь к данным
    PATH_DATA_BD     : String;   // СЕРВЕР: путь к базам данных
    PATH_DATA_DOC    : String;   // СЕРВЕР: путь к документам:  БД+бланки

    PATH_WORK        : String;   // ПОЛЬЗОВАТЕЛЬ: путь к рабочему каталогу
    PATH_WORK_TEMP   : String;   // ПОЛЬЗОВАТЕЛЬ: путь к каталогу временных файлов
    PATH_WORK_INI    : String;   // ПОЛЬЗОВАТЕЛЬ: путь к файлу локальных настроек

    PATH_UD          : String;   // Путь к папке уголовных дел
    IS_ADMIN         : Boolean;  // Режим администратора

const

{***  ПАПКИ  ******************************************************************}

    FOLDER_MYDOC          = 'Холмс\';                 // Папка рабочая в моих документах
    FOLDER_TEMP           = 'Temp\';                  // Папка для временных файлов
    FOLDER_UD             = 'УД\';                    // Папка для уголовных дел
    FOLDER_DATA           = 'Данные\';                // Папка данных
    FOLDER_DATA_DOC       = 'Данные\Документы\';      // Папка документов


{***  ФАЙЛЫ  ******************************************************************}

    FILE_CLIPBOARD        = 'Clipboard.bin';          // Временный файл Clipboard
    FILE_BLANK_WORD       = 'Бланк Word.doc';         // Файл бланка Word
    FILE_HELP             = 'Инструкция.chm';         // Файл помощи


{***  STATUS BAR  *************************************************************}

    STATUS_MAIN           = 0;
    STATUS_ADMIN          = 1;
    STATUS_UD             = 2;
    STATUS_DOC            = 3;
    STATUS_STRUCT         = 4;


{***  ТИПОВЫЕ ПОЛЯ БАЗ ДАННЫХ  ************************************************}

    F_COUNTER             = 'Счётчик';
    F_CAPTION             = 'Заголовок';


{***  СИМВОЛЫ  ****************************************************************}

    CH1                   = '{';
    CH2                   = '}';
    CH_KAV                = Chr(39);
    CH_NEW                = Chr(13)+Chr(10);
    CH_UP                 = #8593;
    CH_DOWN               = #8595;


{***  РАЗНОЕ  *****************************************************************}

    ID_DIR                = -1;           // Tree.Data для папок
    CBVAL_NULL            = 'не задано';


{$INCLUDE FunConst_ICO.pas}
{$INCLUDE FunConst_INI.pas}
{$INCLUDE FunConst_BD_UD.pas}
{$INCLUDE FunConst_BD_SET.pas}
{$INCLUDE FunConst_BD_EXP.pas}

implementation

end.
