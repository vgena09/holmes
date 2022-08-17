{******************************************************************************}
{****************************   БАЗА ДАННЫХ ДЕЛА   ****************************}
{******************************************************************************}

     FILE_BD_UD  = 'Дело.mdb';


     {*************************************************************************}
     {*******  ТАБЛИЦА СИСТЕМНЫХ ПЕРЕМЕННЫХ  **********************************}
     {*************************************************************************}
     T_UD_SYS = 'SYS';

     F_UD_SYS_VAR          = 'Переменная';
     F_UD_SYS_VAL          = 'Значение';

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
     {*******  ТАБЛИЦА ДОКУМЕНТОВ  ********************************************}
     {*************************************************************************}
     T_UD_DOC = 'Документы';               IND_UD_DOC_COUNTER = 0;   // Индекс документа

     F_UD_DOC_CAPTION    = 'Заголовок';
     F_UD_DOC_AUTO       = 'Автодокумент'; IND_UD_DOC_AUTO    = 2;   // Признак автодокумента
     F_UD_DOC_OK         = 'Готово';       IND_UD_DOC_OK      = 3;   // Признак готовности документа
     F_UD_DOC_DATE       = 'Дата';         IND_UD_DOC_DATE    = 4;   // Дата документа
     F_UD_DOC_CONTROL    = 'Контроль';     IND_UD_DOC_CONTROL = 5;   // Срок контроля документа
     F_UD_DOC_OLE        = 'Значение OLE';
     F_UD_DOC_PATH_FULL  = 'Путь полный';
     F_UD_DOC_PATH_SHORT = 'Путь относительный';
     F_UD_DOC_HINT       = 'Примечание';
     F_UD_DOC_MODIFY     = 'Дата модификации';                       // Дата-время модификации записи - для синхронизации


     {*************************************************************************}
     {*******  ТАБЛИЦА ПЕРЕМЕННЫХ  ********************************************}
     {*************************************************************************}
     T_UD_VAR = 'Переменные';

     F_VAR_DOC       = 'Документы';
     F_VAR_NAME      = 'Имя';
        F_VAR_NAME_NUD        = '$Номер дела';           // Переменная УД
        F_VAR_NAME_LOOP       = '$VAR';
        F_VAR_NAME_REST0      = '$Присутствующие';       // Переменная глобальная
        F_VAR_NAME_REST0_PREF = '$Права - ';             // Переменная глобальная
        F_VAR_NAME_NOTICE     = '$Уведомление о записи'; // Переменная глобальная
        F_VAR_NAME_PART       = 'Участники';
        F_VAR_NAME_REST       = 'Присутствующие';
        F_VAR_NAME_FIXATION   = 'Фиксация';
        F_VAR_NAME_DATE       = 'Дата документа';
     F_VAR_CAPTION   = 'Заголовок';
     F_VAR_TYPE      = 'Тип';
        F_VAR_TYPE_EDIT   = 'EDIT';
        F_VAR_TYPE_MEMO   = 'MEMO';
        F_VAR_TYPE_DATE   = 'DATE';
        F_VAR_TYPE_SELECT = 'SELECT';
        F_VAR_TYPE_UD     = 'UD';
        F_VAR_TYPE_EXPERT = 'EXPERT';
        F_VAR_TYPE_OLE    = 'OLE';
        F_VAR_TYPE_REST   = 'REST';
     F_VAR_PARAM     = 'Параметры';
        F_VAR_PARAM_SHOW          = 'Показать';
        F_VAR_PARAM_VALUE         = 'Значение';
        F_VAR_PARAM_EDIT_VARIANTS = 'Варианты';
        F_VAR_PARAM_EDIT_CHANGE   = 'Изменение';
        F_VAR_PARAM_DATE_TYPE     = 'Тип';
           F_VAR_PARAM_KEY_DATETIME = 'ДатаВремя';
           F_VAR_PARAM_KEY_DATE     = 'Дата';
           F_VAR_PARAM_KEY_TIME     = 'Время';
           F_VAR_PARAM_KEY_TABLE    = 'Таблица';
           F_VAR_PARAM_KEY_FILTER   = 'Фильтр';
           F_VAR_PARAM_KEY_MSELECT  = 'Мультивыбор';
           F_VAR_PARAM_KEY_CATEGORY = 'Категория';
           F_VAR_PARAM_KEY_SELECT   = 'Выбор';
     F_VAR_VAL_STR   = 'Значение STR';
        F_VAR_STR_EXPERT_MAT = 'Материалы';           // В сохранениях VAR EXPORT - имя секции
        F_VAR_STR_EXPERT_EXP = 'Экспертизы';          // В сохранениях VAR EXPORT - имя секции
        F_VAR_STR_EXPERT_QST = 'Вопросы';             // В сохранениях VAR EXPORT - имя секции
        F_VAR_VAL_STR_FIXATION_PHOTO = 'Фотосъемка';
        F_VAR_VAL_STR_FIXATION_VIDEO = 'Видеосъемка';
        F_VAR_VAL_STR_FIXATION_AUDIO = 'Звукозапись';
     F_VAR_VAL_OLE   = 'Значение OLE';
     F_VAR_HINT      = 'Примечание';


     {*************************************************************************}
     {******  ФИЗИЧЕСКИЕ ЛИЦА  ************************************************}
     {*************************************************************************}
     T_UD_PPERSON = 'Физические лица';

     PPERSON_FIO        = 'ФИО';
     PPERSON_FIO_RP     = 'ФИО родительный падеж';
     PPERSON_FIO_DP     = 'ФИО дательный падеж';
     PPERSON_FIO_VP     = 'ФИО винительный падеж';
     PPERSON_FIO_TP     = 'ФИО творительный падеж';
     PPERSON_FIO_PP     = 'ФИО предложный падеж';
     PPERSON_FIO_OLD    = 'ФИО преждние';
     PPERSON_SEX        = 'Пол';
     PPERSON_STATE      = 'Статус';
        PPERSON_STATE_WITNESS = 'свидетель';
        PPERSON_STATE_VICTIM  = 'потерпевший';
        PPERSON_STATE_SUSPECT = 'подозреваемый';
        PPERSON_STATE_ACCUSED = 'обвиняемый';
        PPERSON_STATE_STUPID  = 'совершивший общественно опасное деяние';
     PPERSON_ARTICLES    = 'Статьи';
     PPERSON_GRAGD       = 'Гражданство';
     PPERSON_EDUCATION   = 'Образование';
     PPERSON_FAMILY      = 'Семейное положение';
     PPERSON_BORN_PLACE  = 'Место рождения';
     PPERSON_BORN_DATE   = 'Дата рождения';
     PPERSON_REG_PLACE   = 'Место регистрации';
     PPERSON_LIV_PLACE   = 'Место жительства';
     PPERSON_WORK_PLACE  = 'Место работы';
     PPERSON_WORK_POST   = 'Должность';
     PPERSON_CONTACTS    = 'Контакты';
     PPERSON_SUDIMOST    = 'Судимость';
     PPERSON_SODERG      = 'Место содержания';
     PPERSON_DOC_TYPE    = 'Тип документа';
     PPERSON_DOC_NOMER   = 'Номер документа';
     PPERSON_DOC_PLACE   = 'Орган выдачи документа';
     PPERSON_DOC_DATE    = 'Дата выдачи документа';
     PPERSON_PERSNOMER   = 'Личный номер';
     PPERSON_SET         = 'Установлено';
     PPERSON_HINT        = 'Примечание';


     {*************************************************************************}
     {******  ЮРИДИЧЕСКИЕ ЛИЦА  ***********************************************}
     {*************************************************************************}
     T_UD_LPERSON = 'Юридические лица';

     LPERSON_NAME        = 'Наименование';
     LPERSON_NAME_RP     = 'Наименование родительный падеж';
     LPERSON_NAME_DP     = 'Наименование дательный падеж';
     LPERSON_NAME_VP     = 'Наименование винительный падеж';
     LPERSON_NAME_TP     = 'Наименование творительный падеж';
     LPERSON_NAME_PP     = 'Наименование предложный падеж';
     LPERSON_NAME_SHORT  = 'Наименование сокращённое';
     LPERSON_STATE       = 'Статус';
        LPERSON_STATE_CLAIM     = 'гражданский истец';
        LPERSON_STATE_DEFENDANT = 'гражданский ответчик';
     LPERSON_BOSS        = 'Руководитель';
     LPERSON_ADDRESS     = 'Адрес';
     LPERSON_CONTACTS    = 'Контакты';
     LPERSON_SET         = 'Установлено';
     LPERSON_HINT        = 'Примечание';


     {*************************************************************************}
     {******  ДОПОЛНИТЕЛЬНЫЕ ЛИЦА  ********************************************}
     {*************************************************************************}
     T_UD_DPERSON = 'Дополнительные лица';

     DPERSON_FIO         = 'ФИО';
     DPERSON_FIO_RP      = 'ФИО родительный падеж';
     DPERSON_FIO_DP      = 'ФИО дательный падеж';
     DPERSON_FIO_VP      = 'ФИО винительный падеж';
     DPERSON_FIO_TP      = 'ФИО творительный падеж';
     DPERSON_FIO_PP      = 'ФИО предложный падеж';
     DPERSON_SEX         = 'Пол';
     DPERSON_STATE       = 'Статус';
        DPERSON_STATE_ADVOCATE  = 'защитник';
        DPERSON_STATE_REPRESENT = 'законный представитель';
     DPERSON_DOC_TYPE    = 'Тип документа';
     DPERSON_DOC_NOMER   = 'Номер документа';
     DPERSON_DOC_PLACE   = 'Орган выдачи документа';
     DPERSON_DOC_DATE    = 'Дата выдачи документа';
     DPERSON_WORK_PLACE  = 'Место работы';
     DPERSON_WORK_POST   = 'Должность';
     DPERSON_ADDRESS     = 'Адрес';
     DPERSON_CONTACTS    = 'Контакты';
     DPERSON_HINT        = 'Примечание';


     {*************************************************************************}
     {******  ОБЪЕКТЫ  ********************************************************}
     {*************************************************************************}
     T_UD_OBJECT = 'Объекты';

     OBJECT_CAPTION     = 'Наименование';
     OBJECT_VD          = 'Вещественное доказательство';
     OBJECT_CONF_PLACE  = 'Место изъятия';
     OBJECT_CONF_AGENCY = 'Орган изъятия';
     OBJECT_CONF_PERSON = 'Лицо изъятия';
     OBJECT_CONF_DATE   = 'Дата изъятия';
     OBJECT_LOC_PLACE   = 'Место нахождения';
     OBJECT_LOC_PERSON  = 'Лицо нахождения';
     OBJECT_LOC_DATE    = 'Дата нахождения';
     OBJECT_PACK        = 'Упаковано';
     OBJECT_SEAL        = 'Опечатано';
     OBJECT_HINT        = 'Примечание';


     {*************************************************************************}
     {******  СПИСОК ТАБЛИЦ УГОЛОВНОГО ДЕЛА  **********************************}
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
     {******  СПИСОК ТИПОВ МАТЕРИАЛОВ ПО ЭКСПЕРТИЗАМ  *************************}
     {*************************************************************************}
     LTAB_MAT: array[0..1] of String =
         (T_UD_PPERSON,
          T_UD_OBJECT);
