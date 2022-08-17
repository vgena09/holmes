object FVAR_OLE: TFVAR_OLE
  Left = 512
  Top = 117
  Align = alClient
  Caption = 'FVAR_OLE'
  ClientHeight = 474
  ClientWidth = 716
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object EOle: TOleContainer
    Left = 0
    Top = 0
    Width = 716
    Height = 418
    AllowInPlace = False
    AllowActiveDoc = False
    AutoActivate = aaManual
    AutoVerbMenu = False
    Align = alClient
    Caption = 'EOle'
    Ctl3D = False
    ParentCtl3D = False
    SizeMode = smScale
    TabOrder = 0
    OnMouseDown = EOleMouseDown
  end
  object PBottom: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 421
    Width = 716
    Height = 25
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Nav: TDBNavigator
      Left = 0
      Top = 0
      Width = 716
      Height = 25
      Margins.Left = 0
      Margins.Right = 0
      Margins.Bottom = 0
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Align = alClient
      Hints.Strings = (
        #1055#1077#1088#1074#1072#1103' '#1079#1072#1087#1080#1089#1100
        #1055#1088#1077#1076#1099#1076#1091#1097#1072#1103' '#1079#1072#1087#1080#1089#1100
        #1057#1083#1077#1076#1091#1102#1097#1072#1103' '#1079#1072#1087#1080#1089#1100
        #1055#1086#1089#1083#1077#1076#1085#1103#1103' '#1079#1072#1087#1080#1089#1100
        #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
        #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
        'Edit record'
        'Post edit'
        'Cancel edit'
        #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
        #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
        #1054#1090#1084#1077#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103)
      Kind = dbnHorizontal
      TabOrder = 0
    end
  end
  object BtnClear: TBitBtn
    AlignWithMargins = True
    Left = 0
    Top = 449
    Width = 716
    Height = 25
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Action = AClear
    Align = alBottom
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 2
  end
  object AList: TActionList
    Left = 192
    Top = 64
    object AClear: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      OnExecute = AClearExecute
    end
    object AEdit: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      OnExecute = AEditExecute
    end
  end
  object PMenu: TPopupMenu
    Left = 232
    Top = 64
    object N1: TMenuItem
      Action = AEdit
    end
    object N2: TMenuItem
      Action = AClear
    end
  end
end
