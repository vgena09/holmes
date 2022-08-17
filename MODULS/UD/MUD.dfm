object FUD: TFUD
  Left = 0
  Top = 0
  Caption = 'FUD'
  ClientHeight = 304
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 265
    Top = 0
    Height = 304
    ExplicitLeft = 272
    ExplicitTop = -8
    ExplicitHeight = 307
  end
  object PMain: TPanel
    Left = 268
    Top = 0
    Width = 286
    Height = 304
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object PUD: TPanel
    Left = 0
    Top = 0
    Width = 265
    Height = 304
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object TreeUD: TTreeView
      Left = 0
      Top = 0
      Width = 265
      Height = 277
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      BorderWidth = 1
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HideSelection = False
      Indent = 19
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      ToolTips = False
      Items.NodeData = {
        03020000002E0000000000000001000000FFFFFFFFFFFFFFFFFFFFFFFF000000
        00020000000108640066006700640067006400660067002C0000000000000000
        000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000010776006800620067
        00660074006800320000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF00
        00000000000000010A6A006B0067006A0075006B00670068006A006B00280000
        000000000001000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000010533
        003400330034003300}
    end
    object PFinder: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 280
      Width = 259
      Height = 21
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object BtnClose: TBitBtn
        AlignWithMargins = True
        Left = 240
        Top = 0
        Width = 19
        Height = 21
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Action = AFinderHide
        Align = alRight
        Caption = 'X'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object BtnFind: TButton
        AlignWithMargins = True
        Left = 175
        Top = 0
        Width = 62
        Height = 21
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Action = AFind
        Align = alRight
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object EFind: TComboBox
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 172
        Height = 21
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alClient
        DropDownCount = 25
        TabOrder = 2
      end
    end
  end
  object AList: TActionList
    Left = 328
    Top = 64
    object AUDAdd: TAction
      Category = 'Operation'
      Caption = #1057#1086#1079#1076#1072#1090#1100'...'
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1086#1077' '#1076#1077#1083#1086
      ShortCut = 16497
      OnExecute = AUDAddExecute
    end
    object AUDCopy: TAction
      Category = 'Operation'
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100'...'
      ShortCut = 16500
      OnExecute = AUDCopyExecute
    end
    object AUDMove: TAction
      Category = 'Operation'
      Caption = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100'...'
      ShortCut = 16501
      OnExecute = AUDMoveExecute
    end
    object ARefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
      ShortCut = 16466
      OnExecute = ARefreshExecute
    end
    object AOpenDir: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1087#1082#1091
      OnExecute = AOpenDirExecute
    end
    object AFind: TAction
      Category = 'View'
      Caption = #1048#1089#1082#1072#1090#1100
      OnExecute = AFindExecute
    end
    object ABreak: TAction
      Category = 'View'
      Caption = #1057#1090#1086#1087
      OnExecute = ABreakExecute
    end
    object AFinder: TAction
      AutoCheck = True
      Caption = #1055#1086#1080#1089#1082
      Checked = True
      ShortCut = 16502
      OnExecute = AFinderExecute
    end
    object AFinderHide: TAction
      Caption = 'X'
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1087#1072#1085#1077#1083#1100' '#1087#1086#1080#1089#1082#1072
      OnExecute = AFinderHideExecute
    end
    object AUDPass: TAction
      Category = 'Operation'
      Caption = #1055#1072#1088#1086#1083#1100'...'
      OnExecute = AUDPassExecute
    end
    object AUDDat: TAction
      Category = 'Operation'
      Caption = #1055#1077#1088#1077#1084#1077#1085#1085#1099#1077'...'
      OnExecute = AUDDatExecute
    end
    object AOutlook: TAction
      Caption = #1050#1086#1085#1090#1088#1086#1083#1100' '#1074' Outlook'
      Hint = #1057#1080#1085#1093#1088#1086#1085#1080#1079#1080#1088#1086#1074#1072#1090#1100' '#1082#1086#1085#1090#1088#1086#1083#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1089' Outlook'
      ShortCut = 16463
      OnExecute = AOutlookExecute
    end
  end
  object PMenu: TPopupMenu
    Left = 360
    Top = 64
    object N1: TMenuItem
      Action = AUDAdd
    end
    object N5: TMenuItem
      Action = AUDCopy
    end
    object N10: TMenuItem
      Action = AUDMove
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N9: TMenuItem
      Action = AUDPass
    end
    object N11: TMenuItem
      Action = AUDDat
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object NOutlook: TMenuItem
      Action = AOutlook
    end
    object N8: TMenuItem
      Action = ARefresh
    end
    object N3: TMenuItem
      Action = AOpenDir
    end
    object N6: TMenuItem
      Action = AFinder
      AutoCheck = True
    end
  end
  object SaveDlg: TSaveDialog
    Left = 392
    Top = 64
  end
  object TimerOpenUD: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerOpenUDTimer
    Left = 424
    Top = 64
  end
end
