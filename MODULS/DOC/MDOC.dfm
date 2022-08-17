object FDOC: TFDOC
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FDOC'
  ClientHeight = 308
  ClientWidth = 626
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
  object SplitStruct: TSplitter
    Left = 301
    Top = 0
    Height = 308
    Align = alRight
    ExplicitLeft = 429
    ExplicitTop = -3
    ExplicitHeight = 240
  end
  object Ole: TOleContainer
    Left = -90
    Top = -88
    Width = 107
    Height = 104
    AllowInPlace = False
    AllowActiveDoc = False
    AutoActivate = aaManual
    AutoVerbMenu = False
    Caption = 'Ole'
    Ctl3D = False
    ParentCtl3D = False
    SizeMode = smScale
    TabOrder = 1
  end
  object PLeft: TPanel
    Left = 0
    Top = 0
    Width = 301
    Height = 308
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object PFinder: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 284
      Width = 295
      Height = 21
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object LFind: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 57
        Height = 15
        Align = alLeft
        AutoSize = False
        Caption = #1055#1086#1080#1089#1082
        ExplicitTop = 6
        ExplicitHeight = 25
      end
      object BtnClose: TBitBtn
        AlignWithMargins = True
        Left = 276
        Top = 0
        Width = 19
        Height = 21
        Hint = #1047#1072#1082#1088#1099#1090#1100' '#1087#1072#1085#1077#1083#1100' '#1087#1086#1080#1089#1082#1072
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alRight
        Caption = 'X'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object EFind: TEdit
        Left = 63
        Top = 0
        Width = 210
        Height = 21
        Align = alClient
        TabOrder = 1
        Text = 'EFind'
      end
    end
    object PGrid: TPanel
      Left = 0
      Top = 0
      Width = 301
      Height = 281
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object DBGrid: TDBGrid
        Left = 0
        Top = 0
        Width = 301
        Height = 281
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
  end
  object PStruct: TPanel
    Left = 304
    Top = 0
    Width = 322
    Height = 308
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object AList: TActionList
    Left = 128
    Top = 85
    object AAddDir: TAction
      Caption = #1057#1086#1079#1076#1072#1090#1100'...'
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      ShortCut = 113
      OnExecute = AAddDirExecute
    end
    object AAddFile: TAction
      Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100'...'
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      ShortCut = 114
      OnExecute = AAddFileExecute
    end
    object AOpen: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ShortCut = 115
      OnExecute = AOpenExecute
    end
    object AProp: TAction
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072'...'
      ShortCut = 116
      OnExecute = APropExecute
    end
    object AFinder: TAction
      AutoCheck = True
      Caption = #1055#1086#1080#1089#1082
      Checked = True
      ShortCut = 118
      OnExecute = AFinderExecute
    end
    object AFinderHide: TAction
      Caption = 'X'
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1087#1072#1085#1077#1083#1100' '#1087#1086#1080#1089#1082#1072
      OnExecute = AFinderHideExecute
    end
    object ADel: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ShortCut = 119
      OnExecute = ADelExecute
    end
    object AHint: TAction
      AutoCheck = True
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      Checked = True
      OnExecute = AHintExecute
    end
    object AOk: TAction
      AutoCheck = True
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1075#1086#1090#1086#1074
      OnExecute = AOkExecute
    end
  end
  object PMenu: TPopupMenu
    Left = 160
    Top = 88
    object N1: TMenuItem
      Action = AAddDir
    end
    object N4: TMenuItem
      Action = AAddFile
    end
    object N7: TMenuItem
      Action = AOpen
    end
    object N2: TMenuItem
      Action = AProp
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object N5: TMenuItem
      Action = ADel
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Action = AFinder
      AutoCheck = True
    end
    object N6: TMenuItem
      Action = AHint
      AutoCheck = True
    end
  end
end
