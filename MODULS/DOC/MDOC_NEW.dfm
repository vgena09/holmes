object FDOC_NEW: TFDOC_NEW
  Left = 0
  Top = 0
  Caption = #1053#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
  ClientHeight = 475
  ClientWidth = 397
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PBottom: TPanel
    Left = 0
    Top = 444
    Width = 397
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object LInfo: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 8
      Width = 25
      Height = 20
      Margins.Left = 6
      Margins.Top = 8
      Align = alLeft
      Caption = 'LInfo'
      ExplicitHeight = 13
    end
    object BtnOk: TBitBtn
      AlignWithMargins = True
      Left = 188
      Top = 3
      Width = 100
      Height = 25
      Action = AOk
      Align = alRight
      Caption = #1054#1082
      TabOrder = 0
    end
    object BtnCancel: TBitBtn
      AlignWithMargins = True
      Left = 294
      Top = 3
      Width = 100
      Height = 25
      Action = ACancel
      Align = alRight
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
    end
  end
  object TreeDoc: TTreeView
    AlignWithMargins = True
    Left = 3
    Top = 57
    Width = 391
    Height = 384
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
    OnDblClick = TreeDocDblClick
    OnKeyDown = TreeDocKeyDown
    Items.NodeData = {
      03020000002E0000000000000001000000FFFFFFFFFFFFFFFFFFFFFFFF000000
      00020000000108640066006700640067006400660067002C0000000000000000
      000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000010776006800620067
      00660074006800320000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF00
      00000000000000010A6A006B0067006A0075006B00670068006A006B00280000
      000000000001000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000010533
      003400330034003300}
  end
  object PFind: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 30
    Width = 391
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object LFind: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 45
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1055#1086#1080#1089#1082
    end
    object BtnClose: TBitBtn
      Left = 372
      Top = 0
      Width = 19
      Height = 21
      Action = AFindClear
      Align = alRight
      Caption = #1061
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object EFind: TEdit
      AlignWithMargins = True
      Left = 54
      Top = 0
      Width = 315
      Height = 21
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alClient
      TabOrder = 0
      Text = 'EFind'
    end
  end
  object PPath: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 391
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object LPath: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 45
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1055#1072#1087#1082#1072
    end
    object EPath: TComboBox
      AlignWithMargins = True
      Left = 54
      Top = 0
      Width = 315
      Height = 21
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alClient
      TabOrder = 0
      Text = 'EPath'
    end
    object BtnPath: TBitBtn
      Left = 372
      Top = 0
      Width = 19
      Height = 21
      Action = APath
      Align = alRight
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
  object AList: TActionList
    Left = 144
    Top = 88
    object AOk: TAction
      Caption = #1054#1082
      OnExecute = AOkExecute
    end
    object ACancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = ACancelExecute
    end
    object ACollapse: TAction
      Caption = #1057#1074#1077#1088#1085#1091#1090#1100' '#1074#1089#1077
      OnExecute = ACollapseExecute
    end
    object AExpand: TAction
      Caption = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1074#1089#1077
      OnExecute = AExpandExecute
    end
    object AFindClear: TAction
      Caption = #1061
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1090#1088#1086#1082#1091' '#1087#1086#1080#1089#1082#1072
      OnExecute = AFindClearExecute
    end
    object APath: TAction
      Caption = '...'
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1087#1082#1091
      OnExecute = APathExecute
    end
    object AOpenDoc: TAction
      Caption = #1064#1072#1073#1083#1086#1085
      OnExecute = AOpenDocExecute
    end
    object AOpenIni: TAction
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      OnExecute = AOpenIniExecute
    end
    object AOpenFolder: TAction
      Caption = #1055#1072#1087#1082#1091
      OnExecute = AOpenFolderExecute
    end
  end
  object PMenu: TPopupMenu
    Left = 176
    Top = 88
    object NShablon: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100
      object N5: TMenuItem
        Action = AOpenDoc
      end
      object N6: TMenuItem
        Action = AOpenIni
      end
      object N7: TMenuItem
        Action = AOpenFolder
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N2: TMenuItem
      Action = AExpand
    end
    object N1: TMenuItem
      Action = ACollapse
    end
  end
end
