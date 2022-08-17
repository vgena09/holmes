object FVAR_OLE_EDIT: TFVAR_OLE_EDIT
  Left = 270
  Top = 136
  BorderWidth = 6
  Caption = #1041#1083#1086#1082#1080' Word'
  ClientHeight = 499
  ClientWidth = 801
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
  object PBottom: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 474
    Width = 801
    Height = 25
    Margins.Left = 0
    Margins.Top = 9
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object BtnOk: TBitBtn
      Left = 0
      Top = 0
      Width = 801
      Height = 25
      Margins.Left = 0
      Margins.Right = 0
      Align = alClient
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 0
    end
  end
  object PCat: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 801
    Height = 21
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LCat: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
    end
    object ECat: TDBComboBox
      Left = 106
      Top = 0
      Width = 675
      Height = 21
      Align = alClient
      TabOrder = 0
    end
    object BtnCat: TBitBtn
      Left = 781
      Top = 0
      Width = 20
      Height = 21
      Align = alRight
      Caption = '...'
      TabOrder = 1
    end
  end
  object PDP: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 341
    Width = 801
    Height = 21
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object LDP: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1044#1072#1090#1077#1083#1100#1085#1099#1081
    end
    object EDP: TDBEdit
      Left = 106
      Top = 0
      Width = 695
      Height = 21
      Align = alClient
      TabOrder = 0
    end
  end
  object PIP: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 293
    Width = 801
    Height = 21
    Margins.Left = 0
    Margins.Top = 6
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object LIP: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1048#1084#1077#1085#1080#1090#1077#1083#1100#1085#1099#1081
      ExplicitLeft = 0
    end
    object EIP: TDBEdit
      Left = 106
      Top = 0
      Width = 646
      Height = 21
      Align = alClient
      TabOrder = 0
    end
    object BtnAuto: TBitBtn
      Left = 752
      Top = 0
      Width = 49
      Height = 21
      Action = AAuto
      Align = alRight
      Caption = #1040#1074#1090#1086
      TabOrder = 1
    end
  end
  object PPP: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 413
    Width = 801
    Height = 21
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 7
    object LPP: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1055#1088#1077#1076#1083#1086#1078#1085#1099#1081
    end
    object EPP: TDBEdit
      Left = 106
      Top = 0
      Width = 695
      Height = 21
      Align = alClient
      TabOrder = 0
    end
  end
  object PRP: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 317
    Width = 801
    Height = 21
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object LRP: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1056#1086#1076#1080#1090#1077#1083#1100#1085#1099#1081
    end
    object ERP: TDBEdit
      Left = 106
      Top = 0
      Width = 695
      Height = 21
      Align = alClient
      TabOrder = 0
    end
  end
  object PTP: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 389
    Width = 801
    Height = 21
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    object LTP: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1058#1074#1086#1088#1080#1090#1077#1083#1100#1085#1099#1081
      ExplicitLeft = 0
    end
    object ETP: TDBEdit
      Left = 106
      Top = 0
      Width = 695
      Height = 21
      Align = alClient
      TabOrder = 0
    end
  end
  object PVP: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 365
    Width = 801
    Height = 21
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 5
    object LVP: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1042#1080#1085#1080#1090#1077#1083#1100#1085#1099#1081
    end
    object EVP: TDBEdit
      Left = 106
      Top = 0
      Width = 695
      Height = 21
      Align = alClient
      TabOrder = 0
    end
  end
  object Nav: TDBNavigator
    AlignWithMargins = True
    Left = 0
    Top = 440
    Width = 801
    Height = 25
    Margins.Left = 0
    Margins.Top = 6
    Margins.Right = 0
    Margins.Bottom = 0
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete]
    Align = alBottom
    Hints.Strings = (
      #1055#1077#1088#1074#1072#1103' '#1079#1072#1087#1080#1089#1100
      #1055#1088#1077#1076#1099#1076#1091#1097#1072#1103' '#1079#1072#1087#1080#1089#1100
      #1057#1083#1077#1076#1091#1102#1097#1072#1103' '#1079#1072#1087#1080#1089#1100
      #1055#1086#1089#1083#1077#1076#1085#1103#1103' '#1079#1072#1087#1080#1089#1100
      #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1087#1080#1089#1100
      #1047#1072#1074#1077#1088#1096#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
      #1054#1090#1084#1077#1085#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
      #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      #1054#1090#1084#1077#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103)
    Kind = dbnHorizontal
    TabOrder = 8
  end
  object EOle: TOleContainer
    Left = 0
    Top = 27
    Width = 801
    Height = 260
    Cursor = crHandPoint
    AllowInPlace = False
    AllowActiveDoc = False
    AutoActivate = aaManual
    AutoVerbMenu = False
    Align = alClient
    Caption = 'EOle'
    Ctl3D = False
    ParentCtl3D = False
    SizeMode = smScale
    TabOrder = 9
  end
  object AList: TActionList
    Left = 200
    Top = 48
    object AAuto: TAction
      Caption = #1040#1074#1090#1086
      Hint = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1089#1090' '#1080#1079' '#1073#1083#1086#1082#1072' Word'
      OnExecute = AAutoExecute
    end
  end
end
