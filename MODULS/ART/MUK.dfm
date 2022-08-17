object FUK: TFUK
  Left = 0
  Top = 0
  Caption = #1057#1090#1072#1090#1100#1080' '#1059#1050
  ClientHeight = 417
  ClientWidth = 872
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PBottom: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 386
    Width = 866
    Height = 25
    Margins.Top = 6
    Margins.Bottom = 6
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object BtnClose: TBitBtn
      Left = 666
      Top = 0
      Width = 200
      Height = 25
      Align = alRight
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 0
    end
    object Nav: TDBNavigator
      Left = 0
      Top = 0
      Width = 666
      Height = 25
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Align = alClient
      Kind = dbnHorizontal
      TabOrder = 1
    end
  end
  object ENorm: TDBMemo
    Left = 0
    Top = 30
    Width = 872
    Height = 329
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
  end
  object Tab: TTabSet
    Left = 0
    Top = 359
    Width = 872
    Height = 21
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    SoftTop = True
    Tabs.Strings = (
      #1087'.3 '#1095'.2 '#1089#1090'.139'
      #1095'.2 '#1089#1090'.317_1'
      #1095'.1 '#1089#1090'.339')
    TabIndex = 0
  end
  object PTop: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 866
    Height = 21
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object PDateStart: TPanel
      Left = 0
      Top = 0
      Width = 280
      Height = 21
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 2
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LDateStart: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 100
        Height = 15
        Align = alLeft
        AutoSize = False
        Caption = #1053#1072#1095#1072#1083#1086' '#1076#1077#1081#1089#1090#1074#1080#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object EDateStart: TDBText
        AlignWithMargins = True
        Left = 109
        Top = 2
        Width = 168
        Height = 16
        Margins.Top = 2
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 224
        ExplicitTop = 4
        ExplicitWidth = 97
        ExplicitHeight = 17
      end
    end
    object PDateEnd: TPanel
      Left = 280
      Top = 0
      Width = 280
      Height = 21
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 2
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object LDateEnd: TLabel
        AlignWithMargins = True
        Left = 6
        Top = 3
        Width = 100
        Height = 15
        Margins.Left = 6
        Align = alLeft
        AutoSize = False
        Caption = #1050#1086#1085#1077#1094' '#1076#1077#1081#1089#1090#1074#1080#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object EDateEnd: TDBText
        AlignWithMargins = True
        Left = 112
        Top = 2
        Width = 165
        Height = 16
        Margins.Top = 2
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 224
        ExplicitTop = 4
        ExplicitWidth = 97
        ExplicitHeight = 17
      end
    end
  end
end
