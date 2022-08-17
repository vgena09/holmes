unit FunConst;

interface

var
    PATH_PROG        : String;   // ������: ���� � ����� ���������
    PATH_PROG_INI    : String;   // ������: ���� � ����� ���������� ��������
    PATH_DATA        : String;   // ������: ���� � ������
    PATH_DATA_BD     : String;   // ������: ���� � ����� ������
    PATH_DATA_DOC    : String;   // ������: ���� � ����������:  ��+������

    PATH_WORK        : String;   // ������������: ���� � �������� ��������
    PATH_WORK_TEMP   : String;   // ������������: ���� � �������� ��������� ������
    PATH_WORK_INI    : String;   // ������������: ���� � ����� ��������� ��������

    PATH_UD          : String;   // ���� � ����� ��������� ���
    IS_ADMIN         : Boolean;  // ����� ��������������

const

{***  �����  ******************************************************************}

    FOLDER_MYDOC          = '�����\';                 // ����� ������� � ���� ����������
    FOLDER_TEMP           = 'Temp\';                  // ����� ��� ��������� ������
    FOLDER_UD             = '��\';                    // ����� ��� ��������� ���
    FOLDER_DATA           = '������\';                // ����� ������
    FOLDER_DATA_DOC       = '������\���������\';      // ����� ����������


{***  �����  ******************************************************************}

    FILE_CLIPBOARD        = 'Clipboard.bin';          // ��������� ���� Clipboard
    FILE_BLANK_WORD       = '����� Word.doc';         // ���� ������ Word
    FILE_HELP             = '����������.chm';         // ���� ������


{***  STATUS BAR  *************************************************************}

    STATUS_MAIN           = 0;
    STATUS_ADMIN          = 1;
    STATUS_UD             = 2;
    STATUS_DOC            = 3;
    STATUS_STRUCT         = 4;


{***  ������� ���� ��� ������  ************************************************}

    F_COUNTER             = '�������';
    F_CAPTION             = '���������';


{***  �������  ****************************************************************}

    CH1                   = '{';
    CH2                   = '}';
    CH_KAV                = Chr(39);
    CH_NEW                = Chr(13)+Chr(10);
    CH_UP                 = #8593;
    CH_DOWN               = #8595;


{***  ������  *****************************************************************}

    ID_DIR                = -1;           // Tree.Data ��� �����
    CBVAL_NULL            = '�� ������';


{$INCLUDE FunConst_ICO.pas}
{$INCLUDE FunConst_INI.pas}
{$INCLUDE FunConst_BD_UD.pas}
{$INCLUDE FunConst_BD_SET.pas}
{$INCLUDE FunConst_BD_EXP.pas}

implementation

end.
