{==============================================================================}
{==========         Сканируем и преобразуем документ WORD           ===========}
{==========      (ОБРАБАТЫВАЕТ В ТОМ ЧИСЛЕ ПЕРЕМЕННЫЕ-ПОТОКИ)       ===========}
{==============================================================================}
function TFDECOD_OLE.ScanDoc: Boolean;
var ID_OLE     : Variant;
    SOld, SNew : String;
    ICount     : Integer;
    FErr       : TFont;
begin
    {Инициализация}
    Result     := false;
    Btn.Action := AStop;
    IS_STOP    := false;
    FErr       := nil;
    Btn.SetFocus;
    try
       {Шрифт ошибки}
       FErr:=TFont.Create;
       FErr.Name  := 'Times New Roman';
       FErr.Size  := 8;
       FErr.Color := $00FFFF00;

       {Инициализация OLE}
       SetInfo(0, 'Открытие документа');
       AddInfo('Документ: '+QDOC_UD.FieldByName(F_UD_DOC_CAPTION).AsString, ICO_INFO);
       BeginScreenUpdate(Self.Handle);
       If not OpenOle(@OLE, ovUIActivate) then begin AddInfo('Ошибка открытия документа', ICO_ERR); Exit; end;
       OLE.Visible := false;
       EndScreenUpdate(Self.Handle);

       {Настройка}
       SetInfo(0, 'Подготовка');
       ID_OLE         := GetWordApplicationID;
       ID_OLE.Options.PasteAdjustWordSpacing := false;   // Устраняем ошибку: убираем опцию Сервис - Параметры - Правка - Настройки - Исправлять интервалы между предложениями и словами, т.к. вставляет пробелы при формировании слова
       If not ZoomWord(ReadLocalInteger(INI_SET, INI_SET_ZOOM_WORD, 100)) then begin AddInfo('Ошибка установки масштаба', ICO_ERR); Exit; end;
       PBar.Max       := GetCountWordChar(CH1);
       ClearClipboard;

       {Курсор на начало документа}
       SelectMainDoc;
       If not StartOfDoc then begin AddInfo('Ошибка установки курсора', ICO_ERR); Exit; end;

       {Декодер}
       ICount := 1;
       SOld   := FindKeyTextDoc;
       While SOld <> '' do begin
          {Информер}
          SetInfo(ICount, 'Команда: '+SOld); Inc(ICount);

          {Если команда стоп - то остановка процесса}
          Application.ProcessMessages;
          If IS_STOP then begin AddInfo('Прервано пользователем', ICO_ERR); Exit; end;
          If CmpStr(SOld, '{СТОП}') then begin PasteTextDoc(''); Break; end;

          {Обработка блока, в том числе с потоками}
          SNew := FDECOD.DecoderOle(SOld);

          {Устраняем ошибку с закрытием OLE при работе с другим OLE}
          //If OLE.OleObject.Application.Selection = $00000000 then begin       //VarIsNull VarIsEmpty   VarType varUnknown
          BeginScreenUpdate(Self.Handle);
          OLE.Visible := true;
          If not OpenOle(@OLE, ovUIActivate) then begin AddInfo('Ошибка повторного открытия документа', ICO_ERR); Exit; end; //ID_OLE.ActiveWindow
          OLE.Visible := false;
          EndScreenUpdate(Self.Handle);
          //end;

          {Если ошибка}
          If FDECOD.Err then begin
             AddInfo('Ошибка декодера: '+ SOld+CH_NEW+SNew, ICO_WARN);
             ID_OLE.Selection.Text:='Ошибка: [ ]';
             SetFontSelection(FErr, 6);
             ID_OLE.Selection.Start := ID_OLE.Selection.Start+9;
             ID_OLE.Selection.End   := ID_OLE.Selection.End  -1;
             PutStringInClipboard(SNew);
          end;

          {Замена блока}
          If not PasteClipbordDoc then begin AddInfo('Ошибка замены текста', ICO_ERR); Exit; end;
          ClearClipboard;

          {Курсор на начало документа}
          If not StartOfDoc then begin AddInfo('Ошибка установки курсора', ICO_ERR); Exit; end;

          {Возможность прерывания}
          //Btn.SetFocus;
          Application.ProcessMessages;

          {Следующий блок}
          SOld := FindKeyTextDoc;
       end;

       {Курсор и перемотка на начало документа}
       SetInfo(100, 'Завершающие операции');
       If not StartOfDoc     then begin AddInfo('Ошибка установки курсора',   ICO_ERR); Exit; end;
       If not ScrollStartDoc then begin AddInfo('Ошибка перемотки документа', ICO_ERR); Exit; end;

       Result := true;

    finally
       Btn.Action := AClose;
       ClearClipboard;

       ID_OLE := Unassigned;
       If OLE.State <> osEmpty then OLE.Close;

       If FErr <> nil then FErr.Free;

       If Result then begin AddInfo('Документ обработан',   ICO_INFO); SetInfo(100, 'Документ обработан');   end
                 else begin AddInfo('Аварийное завершение', ICO_ERR);  SetInfo(100, 'Аварийное завершение'); end;

       Btn.SetFocus;
    end;
end;


{==============================================================================}
{=============      Сканируем и преобразуем книгу EXCEL          ==============}
{=============      (ПЕРЕМЕННЫЕ-ПОТОКИ НЕ ОБРАБАТЫВАЕТ)          ==============}
{==============================================================================}
function TFDECOD_OLE.ScanXls: Boolean;
//var S, S0, S1     : String;
//    PBar, PBarMax : Integer;
//    Len           : Integer;
begin
    {Инициализация}
    Result := false;
(*
    E0     := Null;

    try
    SetPBar(1);
    If not CreateExcel then begin
       AddInfo('Ошибка открытия MS Excel', ICO_ERR);
       Exit;
    end;

    SetPBar(2);
    If not OpenXls(FName) then begin
       AddInfo('Ошибка открытия документа: '+FName, ICO_ERR);
       Exit;
    end;

    SetPBar(3);
    PBarMax:=GetCountExcelChar(CH1);
    E0:=GetExcelApplicationID;

    {Устанавливаем колонтитулы}
    If not SetHeaderXls(1,'Прокуратура Республики Беларусь') then begin
       AddInfo('Ошибка вставки текста: установка верхнего колонтитула', ICO_ERR);
       Exit;
    end;
    If not SetFooterXls(2,'Программа автоматизации следственной деятельности') then begin
       AddInfo('Ошибка вставки текста: установка нижнего колонтитула', ICO_ERR);
       Exit;
    end;

    {Устанавливаем фоновый рисунок}
    If FileExists(PATH_0+PATH_IMG_XLS) then begin
       If SetBackGroundPicXls(PATH_0+PATH_IMG_XLS) = false then begin
          AddInfo('Ошибка установки фона: инициализация документа', ICO_ERR);
          Exit;
       end;
    end;

    SetPBar(5);
    PBar:=0;

    S:=FindKeyTextXls;
    While S<>'' do begin
       {Информер}
       LInfo2.Caption:=S;
       LInfo2.Refresh;

       {Если команда стоп - то остановка процесса}
       If AnsiUpperCase(S)='{СТОП}' then begin
          WriteActiveCells('');
          Break;
       end;

       S1:=S;
       {Сколько ячеек должна занять запись}
       S0:=CutSlovoChar(S1, 1, ' ');
       Delete(S0, 1, 1);
       If IsNumericStr(CutSpace(S0))=true then begin
          Len:=StrToInt(CutSpace(S0));
          Delete(S1, 2, Length(S0)+1);
       end else Len:=1;

       {Декодируем строку}
       S1:=FFUD.DecoderFull(S1, false, [FFUD.DopDecoderVar, FFUD.DopDecoderTables],
                                       [@T_WORK_VAR,        @T_UD_DECOD]);

       {Если ошибка}
       If FFUD.IsErrorDecod=true then begin
          {Информер}
          AddInfo('Ошибка декодера: '+S1, LInfo2.Caption, ICO_WARN);

          //{Меняем цвет текста}
          //W0.Selection.Text:='Ошибка: [ ]';
          //SetFontSelection(FErr, 6);
          //W0.Selection.Start := W0.Selection.Start+9;
          //W0.Selection.End   := W0.Selection.End  -1;
       end;

       {Заменяем строку}
       If FindAndPasteTextXls(S, S1, Len) = false then begin
          AddInfo('Ошибка обработки документа: блок замены текста', ICO_ERR);
          Exit;
       end;
       S:=FindKeyTextXls;

       Inc(PBar);
       SetPBar(5);
    end;
    If not StartOfXls then begin
       AddInfo('Ошибка позиционирования курсора: блок окончательной установки курсора', ICO_ERR);
       Exit;
    end;

    {Сохраняем документ}
    If not SaveXls then begin
       AddInfo('Ошибка сохранения документа', ICO_ERR);
       Exit;
    end;

    SetPBar(100);
    Result:=true;
    
    finally
       If not Result then AddInfo('Аварийное завершение', ICO_WARN);
    end;
*)
end;


