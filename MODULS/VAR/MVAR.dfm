object FVAR: TFVAR
  Left = 671
  Top = 110
  Caption = 'FVAR'
  ClientHeight = 412
  ClientWidth = 764
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 377
    Top = 0
    Height = 372
    ExplicitLeft = 272
    ExplicitTop = 3
    ExplicitHeight = 412
  end
  object PMain: TPanel
    Left = 380
    Top = 0
    Width = 384
    Height = 372
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 377
    Height = 372
    Align = alLeft
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object PBottom: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 381
    Width = 764
    Height = 25
    Margins.Left = 0
    Margins.Top = 9
    Margins.Right = 0
    Margins.Bottom = 6
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object BtnClose: TBitBtn
      Left = 614
      Top = 0
      Width = 150
      Height = 25
      Margins.Left = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Action = AClose
      Align = alRight
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object BtnOk: TBitBtn
      AlignWithMargins = True
      Left = 444
      Top = 0
      Width = 150
      Height = 25
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 20
      Margins.Bottom = 0
      Action = AOk
      Align = alRight
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object CBShowAll: TCheckBox
      AlignWithMargins = True
      Left = 6
      Top = 3
      Width = 187
      Height = 19
      Margins.Left = 6
      Action = AShowAll
      Align = alLeft
      TabOrder = 2
    end
    object CBShowRun: TCheckBox
      AlignWithMargins = True
      Left = 202
      Top = 3
      Width = 187
      Height = 19
      Margins.Left = 6
      Action = AShowRun
      Align = alLeft
      TabOrder = 3
      ExplicitLeft = 262
      ExplicitTop = 11
    end
  end
  object ActionList1: TActionList
    Left = 416
    Top = 24
    object AOk: TAction
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
      OnExecute = AOkExecute
    end
    object AClose: TAction
      Caption = #1047#1072#1082#1088#1099#1090#1100
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1086#1082#1085#1086
      ShortCut = 16499
      OnExecute = ACloseExecute
    end
    object AShowAll: TAction
      AutoCheck = True
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1087#1077#1088#1077#1084#1077#1085#1085#1099#1077
      OnExecute = AShowAllExecute
    end
    object AShowRun: TAction
      AutoCheck = True
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077
      OnExecute = AShowRunExecute
    end
  end
end
