object FCOM: TFCOM
  Left = 301
  Top = 168
  Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
  ClientHeight = 606
  ClientWidth = 821
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
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 219
    Width = 821
    Height = 2
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 280
    ExplicitWidth = 702
  end
  object PBottom: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 575
    Width = 815
    Height = 25
    Margins.Top = 6
    Margins.Bottom = 6
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object LInfo: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 24
      Height = 17
      Margins.Top = 5
      Align = alLeft
      Caption = 'LInfo'
      ExplicitHeight = 13
    end
    object BtnClose: TBitBtn
      Left = 615
      Top = 0
      Width = 200
      Height = 25
      Align = alRight
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
    end
    object BtnWord: TBitBtn
      AlignWithMargins = True
      Left = 406
      Top = 0
      Width = 200
      Height = 25
      Margins.Top = 0
      Margins.Right = 9
      Margins.Bottom = 0
      Action = AWord
      Align = alRight
      Caption = #1055#1077#1088#1077#1076#1072#1090#1100' '#1074' Word'
      TabOrder = 0
    end
  end
  object PFilter: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 6
    Width = 818
    Height = 21
    Margins.Top = 6
    Margins.Right = 0
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object LFilter: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 86
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1055#1086#1080#1089#1082
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object EFilter: TEdit
      Left = 92
      Top = 0
      Width = 576
      Height = 21
      Align = alClient
      TabOrder = 0
      Text = 'EFilter'
    end
    object BtnNext: TBitBtn
      Left = 743
      Top = 0
      Width = 75
      Height = 21
      Action = ANext
      Align = alRight
      Caption = #1042#1087#1077#1088#1077#1076
      TabOrder = 2
      ExplicitLeft = 668
    end
    object BtnPrev: TBitBtn
      Left = 668
      Top = 0
      Width = 75
      Height = 21
      Action = APrev
      Align = alRight
      Caption = #1053#1072#1079#1072#1076
      TabOrder = 1
      ExplicitLeft = 615
      ExplicitTop = 3
    end
  end
  object EGrid: TDBGrid
    AlignWithMargins = True
    Left = 0
    Top = 36
    Width = 821
    Height = 183
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object EContent: TRichEdit
    Left = 0
    Top = 221
    Width = 821
    Height = 348
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'EContent')
    ParentFont = False
    TabOrder = 2
  end
  object AList: TActionList
    Left = 128
    Top = 64
    object AWord: TAction
      Caption = #1055#1077#1088#1077#1076#1072#1090#1100' '#1074' Word'
      OnExecute = AWordExecute
    end
    object ANext: TAction
      Caption = #1042#1087#1077#1088#1077#1076
      OnExecute = ANextExecute
    end
    object APrev: TAction
      Caption = #1053#1072#1079#1072#1076
      OnExecute = APrevExecute
    end
  end
end
