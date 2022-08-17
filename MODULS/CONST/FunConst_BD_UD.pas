{******************************************************************************}
{****************************   ���� ������ ����   ****************************}
{******************************************************************************}

     FILE_BD_UD  = '����.mdb';


     {*************************************************************************}
     {*******  ������� ��������� ����������  **********************************}
     {*************************************************************************}
     T_UD_SYS = 'SYS';

     F_UD_SYS_VAR          = '����������';
     F_UD_SYS_VAL          = '��������';

     F_UD_SYS_DOC_SEL      = 'TFDOC.SGrid.Selected';
     F_UD_SYS_DOCNEW_SEL   = 'TFDOC_NEW.TreeDoc.Selected';
     F_UD_SYS_VAR_SEL      = 'TFVAR.SGrid.Selected';
     F_UD_SYS_EXPERT_SEL   = 'TFVAR_EXPERT.Tree.Selected';
     F_UD_SYS_MEMO_SEL1    = 'TFMEMO.Memo.SelStart';
     F_UD_SYS_MEMO_SEL2    = 'TFMEMO.Memo.SelLength';
     F_UD_SYS_REST_SEL     = 'TFREST.Grid.Selected';
     F_UD_SYS_SELECT_SEL   = 'TFSELECT.LBox.ItemIndex';
     F_UD_SYS_PERSON_PAGE  = 'TFVAR_UD_EDIT_PERSON.PControl.TabIndex';
     F_UD_SYS_STRUCT_SEL   = 'TSTRUCT.Tree.Selected';


     {*************************************************************************}
     {*******  ������� ����������  ********************************************}
     {*************************************************************************}
     T_UD_DOC = '���������';               IND_UD_DOC_COUNTER = 0;   // ������ ���������

     F_UD_DOC_CAPTION    = '���������';
     F_UD_DOC_AUTO       = '������������'; IND_UD_DOC_AUTO    = 2;   // ������� �������������
     F_UD_DOC_OK         = '������';       IND_UD_DOC_OK      = 3;   // ������� ���������� ���������
     F_UD_DOC_DATE       = '����';         IND_UD_DOC_DATE    = 4;   // ���� ���������
     F_UD_DOC_CONTROL    = '��������';     IND_UD_DOC_CONTROL = 5;   // ���� �������� ���������
     F_UD_DOC_OLE        = '�������� OLE';
     F_UD_DOC_PATH_FULL  = '���� ������';
     F_UD_DOC_PATH_SHORT = '���� �������������';
     F_UD_DOC_HINT       = '����������';
     F_UD_DOC_MODIFY     = '���� �����������';                       // ����-����� ����������� ������ - ��� �������������


     {*************************************************************************}
     {*******  ������� ����������  ********************************************}
     {*************************************************************************}
     T_UD_VAR = '����������';

     F_VAR_DOC       = '���������';
     F_VAR_NAME      = '���';
        F_VAR_NAME_NUD        = '$����� ����';           // ���������� ��
        F_VAR_NAME_LOOP       = '$VAR';
        F_VAR_NAME_REST0      = '$��������������';       // ���������� ����������
        F_VAR_NAME_REST0_PREF = '$����� - ';             // ���������� ����������
        F_VAR_NAME_NOTICE     = '$����������� � ������'; // ���������� ����������
        F_VAR_NAME_PART       = '���������';
        F_VAR_NAME_REST       = '��������������';
        F_VAR_NAME_FIXATION   = '��������';
        F_VAR_NAME_DATE       = '���� ���������';
     F_VAR_CAPTION   = '���������';
     F_VAR_TYPE      = '���';
        F_VAR_TYPE_EDIT   = 'EDIT';
        F_VAR_TYPE_MEMO   = 'MEMO';
        F_VAR_TYPE_DATE   = 'DATE';
        F_VAR_TYPE_SELECT = 'SELECT';
        F_VAR_TYPE_UD     = 'UD';
        F_VAR_TYPE_EXPERT = 'EXPERT';
        F_VAR_TYPE_OLE    = 'OLE';
        F_VAR_TYPE_REST   = 'REST';
     F_VAR_PARAM     = '���������';
        F_VAR_PARAM_SHOW          = '��������';
        F_VAR_PARAM_VALUE         = '��������';
        F_VAR_PARAM_EDIT_VARIANTS = '��������';
        F_VAR_PARAM_EDIT_CHANGE   = '���������';
        F_VAR_PARAM_DATE_TYPE     = '���';
           F_VAR_PARAM_KEY_DATETIME = '���������';
           F_VAR_PARAM_KEY_DATE     = '����';
           F_VAR_PARAM_KEY_TIME     = '�����';
           F_VAR_PARAM_KEY_TABLE    = '�������';
           F_VAR_PARAM_KEY_FILTER   = '������';
           F_VAR_PARAM_KEY_MSELECT  = '�����������';
           F_VAR_PARAM_KEY_CATEGORY = '���������';
           F_VAR_PARAM_KEY_SELECT   = '�����';
     F_VAR_VAL_STR   = '�������� STR';
        F_VAR_STR_EXPERT_MAT = '���������';           // � ����������� VAR EXPORT - ��� ������
        F_VAR_STR_EXPERT_EXP = '����������';          // � ����������� VAR EXPORT - ��� ������
        F_VAR_STR_EXPERT_QST = '�������';             // � ����������� VAR EXPORT - ��� ������
        F_VAR_VAL_STR_FIXATION_PHOTO = '����������';
        F_VAR_VAL_STR_FIXATION_VIDEO = '�����������';
        F_VAR_VAL_STR_FIXATION_AUDIO = '�����������';
     F_VAR_VAL_OLE   = '�������� OLE';
     F_VAR_HINT      = '����������';


     {*************************************************************************}
     {******  ���������� ����  ************************************************}
     {*************************************************************************}
     T_UD_PPERSON = '���������� ����';

     PPERSON_FIO        = '���';
     PPERSON_FIO_RP     = '��� ����������� �����';
     PPERSON_FIO_DP     = '��� ��������� �����';
     PPERSON_FIO_VP     = '��� ����������� �����';
     PPERSON_FIO_TP     = '��� ������������ �����';
     PPERSON_FIO_PP     = '��� ���������� �����';
     PPERSON_FIO_OLD    = '��� ��������';
     PPERSON_SEX        = '���';
     PPERSON_STATE      = '������';
        PPERSON_STATE_WITNESS = '���������';
        PPERSON_STATE_VICTIM  = '�����������';
        PPERSON_STATE_SUSPECT = '�������������';
        PPERSON_STATE_ACCUSED = '����������';
        PPERSON_STATE_STUPID  = '����������� ����������� ������� ������';
     PPERSON_ARTICLES    = '������';
     PPERSON_GRAGD       = '�����������';
     PPERSON_EDUCATION   = '�����������';
     PPERSON_FAMILY      = '�������� ���������';
     PPERSON_BORN_PLACE  = '����� ��������';
     PPERSON_BORN_DATE   = '���� ��������';
     PPERSON_REG_PLACE   = '����� �����������';
     PPERSON_LIV_PLACE   = '����� ����������';
     PPERSON_WORK_PLACE  = '����� ������';
     PPERSON_WORK_POST   = '���������';
     PPERSON_CONTACTS    = '��������';
     PPERSON_SUDIMOST    = '���������';
     PPERSON_SODERG      = '����� ����������';
     PPERSON_DOC_TYPE    = '��� ���������';
     PPERSON_DOC_NOMER   = '����� ���������';
     PPERSON_DOC_PLACE   = '����� ������ ���������';
     PPERSON_DOC_DATE    = '���� ������ ���������';
     PPERSON_PERSNOMER   = '������ �����';
     PPERSON_SET         = '�����������';
     PPERSON_HINT        = '����������';


     {*************************************************************************}
     {******  ����������� ����  ***********************************************}
     {*************************************************************************}
     T_UD_LPERSON = '����������� ����';

     LPERSON_NAME        = '������������';
     LPERSON_NAME_RP     = '������������ ����������� �����';
     LPERSON_NAME_DP     = '������������ ��������� �����';
     LPERSON_NAME_VP     = '������������ ����������� �����';
     LPERSON_NAME_TP     = '������������ ������������ �����';
     LPERSON_NAME_PP     = '������������ ���������� �����';
     LPERSON_NAME_SHORT  = '������������ �����������';
     LPERSON_STATE       = '������';
        LPERSON_STATE_CLAIM     = '����������� �����';
        LPERSON_STATE_DEFENDANT = '����������� ��������';
     LPERSON_BOSS        = '������������';
     LPERSON_ADDRESS     = '�����';
     LPERSON_CONTACTS    = '��������';
     LPERSON_SET         = '�����������';
     LPERSON_HINT        = '����������';


     {*************************************************************************}
     {******  �������������� ����  ********************************************}
     {*************************************************************************}
     T_UD_DPERSON = '�������������� ����';

     DPERSON_FIO         = '���';
     DPERSON_FIO_RP      = '��� ����������� �����';
     DPERSON_FIO_DP      = '��� ��������� �����';
     DPERSON_FIO_VP      = '��� ����������� �����';
     DPERSON_FIO_TP      = '��� ������������ �����';
     DPERSON_FIO_PP      = '��� ���������� �����';
     DPERSON_SEX         = '���';
     DPERSON_STATE       = '������';
        DPERSON_STATE_ADVOCATE  = '��������';
        DPERSON_STATE_REPRESENT = '�������� �������������';
     DPERSON_DOC_TYPE    = '��� ���������';
     DPERSON_DOC_NOMER   = '����� ���������';
     DPERSON_DOC_PLACE   = '����� ������ ���������';
     DPERSON_DOC_DATE    = '���� ������ ���������';
     DPERSON_WORK_PLACE  = '����� ������';
     DPERSON_WORK_POST   = '���������';
     DPERSON_ADDRESS     = '�����';
     DPERSON_CONTACTS    = '��������';
     DPERSON_HINT        = '����������';


     {*************************************************************************}
     {******  �������  ********************************************************}
     {*************************************************************************}
     T_UD_OBJECT = '�������';

     OBJECT_CAPTION     = '������������';
     OBJECT_VD          = '������������ ��������������';
     OBJECT_CONF_PLACE  = '����� �������';
     OBJECT_CONF_AGENCY = '����� �������';
     OBJECT_CONF_PERSON = '���� �������';
     OBJECT_CONF_DATE   = '���� �������';
     OBJECT_LOC_PLACE   = '����� ����������';
     OBJECT_LOC_PERSON  = '���� ����������';
     OBJECT_LOC_DATE    = '���� ����������';
     OBJECT_PACK        = '���������';
     OBJECT_SEAL        = '���������';
     OBJECT_HINT        = '����������';


     {*************************************************************************}
     {******  ������ ������ ���������� ����  **********************************}
     {*************************************************************************}
     LTAB_UD_PPERSON = 0;
     LTAB_UD_LPERSON = 1;
     LTAB_UD_DPERSON = 2;
     LTAB_UD_OBJECT  = 3;
     LTAB_UD: array[0..3] of String =
         (T_UD_PPERSON,
          T_UD_LPERSON,
          T_UD_DPERSON,
          T_UD_OBJECT);
     LTAB_UD_KEY: array[0..3] of String =
         (PPERSON_FIO,
          LPERSON_NAME,
          DPERSON_FIO,
          OBJECT_CAPTION);

     {*************************************************************************}
     {******  ������ ����� ���������� �� �����������  *************************}
     {*************************************************************************}
     LTAB_MAT: array[0..1] of String =
         (T_UD_PPERSON,
          T_UD_OBJECT);
