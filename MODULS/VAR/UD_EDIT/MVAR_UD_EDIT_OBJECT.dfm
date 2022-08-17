object FVAR_UD_EDIT_OBJECT: TFVAR_UD_EDIT_OBJECT
  Left = 299
  Top = 60
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'FVAR_UD_EDIT_OBJECT'
  ClientHeight = 453
  ClientWidth = 743
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
  object PCaption: TPanel
    AlignWithMargins = True
    Left = 6
    Top = 3
    Width = 732
    Height = 21
    Margins.Left = 6
    Margins.Right = 5
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LCaption: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 110
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BtnCaption: TBitBtn
      Left = 712
      Top = 0
      Width = 20
      Height = 21
      Align = alRight
      Caption = '...'
      TabOrder = 1
    end
    object ECaption: TDBComboBox
      Left = 116
      Top = 0
      Width = 596
      Height = 21
      Align = alClient
      TabOrder = 0
    end
  end
  object PBottom: TPanel
    Left = 0
    Top = 422
    Width = 743
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object BtnClose: TBitBtn
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 737
      Height = 25
      Align = alClient
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 0
    end
  end
  object GBConf: TGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 53
    Width = 743
    Height = 118
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 8
    Align = alTop
    Caption = ' '#1048#1079#1098#1103#1090#1080#1077' '
    TabOrder = 3
    object PConfPlace: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 733
      Height = 21
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object LConfPlace: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 110
        Height = 15
        Align = alLeft
        AutoSize = False
        Caption = #1052#1077#1089#1090#1086
      end
      object EConfPlace: TDBComboBox
        Left = 116
        Top = 0
        Width = 597
        Height = 21
        Align = alClient
        TabOrder = 0
      end
      object BtnConfPlace: TBitBtn
        Left = 713
        Top = 0
        Width = 20
        Height = 21
        Align = alRight
        Caption = '...'
        TabOrder = 1
      end
    end
    object PConfPerson: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 66
      Width = 733
      Height = 21
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object LConfPerson: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 110
        Height = 15
        Align = alLeft
        AutoSize = False
        Caption = #1051#1080#1094#1086
      end
      object EConfPerson: TDBComboBox
        Left = 116
        Top = 0
        Width = 597
        Height = 21
        Align = alClient
        TabOrder = 0
      end
      object BtnConfPerson: TBitBtn
        Left = 713
        Top = 0
        Width = 20
        Height = 21
        Align = alRight
        Caption = '...'
        TabOrder = 1
      end
    end
    object PConfDate: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 90
      Width = 733
      Height = 21
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      object LConfDate: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 110
        Height = 15
        Align = alLeft
        AutoSize = False
        Caption = #1044#1072#1090#1072
      end
      object LConfOld: TLabel
        AlignWithMargins = True
        Left = 268
        Top = 3
        Width = 462
        Height = 15
        Align = alClient
        Alignment = taRightJustify
        Caption = 'LConfOld'
        ExplicitLeft = 686
        ExplicitWidth = 44
        ExplicitHeight = 13
      end
      object EConfDate: TDateTimePicker
        Left = 116
        Top = 0
        Width = 149
        Height = 21
        Align = alLeft
        Date = 0.620052673606551300
        Time = 0.620052673606551300
        DateFormat = dfLong
        TabOrder = 0
      end
    end
    object PConfAgency: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 42
      Width = 733
      Height = 21
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object LConfAgency: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 110
        Height = 15
        Align = alLeft
        AutoSize = False
        Caption = #1054#1088#1075#1072#1085
        ExplicitLeft = 0
      end
      object BtnConfAgency: TBitBtn
        Left = 713
        Top = 0
        Width = 20
        Height = 21
        Align = alRight
        Caption = '...'
        TabOrder = 1
      end
      object EConfAgency: TDBComboBox
        Left = 116
        Top = 0
        Width = 597
        Height = 21
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object GBLoc: TGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 179
    Width = 743
    Height = 94
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 8
    Align = alTop
    Caption = ' '#1053#1072#1093#1086#1078#1076#1077#1085#1080#1077' '
    TabOrder = 4
    object PLocPlace: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 733
      Height = 21
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object LLocPlace: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 110
        Height = 15
        Align = alLeft
        AutoSize = False
        Caption = #1052#1077#1089#1090#1086
      end
      object ELocPlace: TDBComboBox
        Left = 116
        Top = 0
        Width = 597
        Height = 21
        Align = alClient
        TabOrder = 0
      end
      object BtnLocPlace: TBitBtn
        Left = 713
        Top = 0
        Width = 20
        Height = 21
        Align = alRight
        Caption = '...'
        TabOrder = 1
      end
    end
    object PLocPerson: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 42
      Width = 733
      Height = 21
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object LLocPerson: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 110
        Height = 15
        Align = alLeft
        AutoSize = False
        Caption = #1051#1080#1094#1086
        ExplicitLeft = 0
      end
      object BtnLocPerson: TBitBtn
        Left = 713
        Top = 0
        Width = 20
        Height = 21
        Align = alRight
        Caption = '...'
        TabOrder = 1
      end
      object ELocPerson: TDBComboBox
        Left = 116
        Top = 0
        Width = 597
        Height = 21
        Align = alClient
        TabOrder = 0
      end
    end
    object PLocDate: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 66
      Width = 733
      Height = 21
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object LLocDate: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 110
        Height = 15
        Align = alLeft
        AutoSize = False
        Caption = #1044#1072#1090#1072
      end
      object LLocOld: TLabel
        AlignWithMargins = True
        Left = 268
        Top = 3
        Width = 462
        Height = 15
        Align = alClient
        Alignment = taRightJustify
        Caption = 'LLocOld'
        ExplicitLeft = 690
        ExplicitWidth = 40
        ExplicitHeight = 13
      end
      object ELocDate: TDateTimePicker
        Left = 116
        Top = 0
        Width = 149
        Height = 21
        Align = alLeft
        Date = 0.620052673606551300
        Time = 0.620052673606551300
        DateFormat = dfLong
        TabOrder = 0
      end
    end
  end
  object PPack: TPanel
    AlignWithMargins = True
    Left = 6
    Top = 284
    Width = 732
    Height = 21
    Margins.Left = 6
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object LPack: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 110
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1059#1087#1072#1082#1086#1074#1072#1085#1086
    end
    object BtnPack: TBitBtn
      Left = 712
      Top = 0
      Width = 20
      Height = 21
      Align = alRight
      Caption = '...'
      TabOrder = 1
    end
    object EPack: TDBComboBox
      Left = 116
      Top = 0
      Width = 596
      Height = 21
      Align = alClient
      TabOrder = 0
    end
  end
  object PSeal: TPanel
    AlignWithMargins = True
    Left = 6
    Top = 308
    Width = 732
    Height = 21
    Margins.Left = 6
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 6
    object LSeal: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 110
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1054#1087#1077#1095#1072#1090#1072#1085#1086
    end
    object BtnSeal: TBitBtn
      Left = 712
      Top = 0
      Width = 20
      Height = 21
      Align = alRight
      Caption = '...'
      TabOrder = 1
    end
    object ESeal: TDBComboBox
      Left = 116
      Top = 0
      Width = 596
      Height = 21
      Align = alClient
      TabOrder = 0
    end
  end
  object EVD: TDBCheckBox
    AlignWithMargins = True
    Left = 9
    Top = 30
    Width = 731
    Height = 17
    Margins.Left = 9
    Margins.Bottom = 6
    Align = alTop
    Caption = ' '#1042#1077#1097#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1076#1086#1082#1072#1079#1072#1090#1077#1083#1100#1089#1090#1074#1086
    TabOrder = 2
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object EHint: TDBMemo
    AlignWithMargins = True
    Left = 3
    Top = 332
    Width = 737
    Height = 87
    Align = alClient
    TabOrder = 7
  end
end
