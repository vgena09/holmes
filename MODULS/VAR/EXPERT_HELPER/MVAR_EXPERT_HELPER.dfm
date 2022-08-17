object FVAR_EXPERT_HELPER: TFVAR_EXPERT_HELPER
  Left = 371
  Top = 136
  Caption = #1055#1086#1084#1086#1097#1085#1080#1082' '#1087#1086' '#1101#1082#1089#1087#1077#1088#1090#1080#1079#1072#1084
  ClientHeight = 544
  ClientWidth = 869
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PBtn: TPanel
    Left = 0
    Top = 513
    Width = 869
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object LInfo: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 8
      Width = 551
      Height = 20
      Margins.Top = 8
      Align = alClient
      Caption = 'LInfo'
      ExplicitLeft = 530
      ExplicitWidth = 20
      ExplicitHeight = 24
    end
    object BtnCancel: TBitBtn
      AlignWithMargins = True
      Left = 716
      Top = 3
      Width = 150
      Height = 25
      Align = alRight
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 0
    end
    object BtnOk: TBitBtn
      AlignWithMargins = True
      Left = 560
      Top = 3
      Width = 150
      Height = 25
      Align = alRight
      Caption = #1054#1082
      TabOrder = 1
    end
  end
  object PTop: TPanel
    Left = 0
    Top = 0
    Width = 869
    Height = 72
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    object PMat: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 863
      Height = 21
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object LMat: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 90
        Height = 15
        Align = alLeft
        AutoSize = False
        Caption = #1051#1080#1094#1072
      end
      object LMatInfo: TLabel
        AlignWithMargins = True
        Left = 835
        Top = 3
        Width = 25
        Height = 15
        Align = alRight
        Alignment = taRightJustify
        AutoSize = False
        Caption = '555'
        Enabled = False
        ExplicitLeft = 828
      end
      object BtnMat: TBitBtn
        Left = 812
        Top = 0
        Width = 20
        Height = 21
        Action = A_Mat
        Align = alRight
        Caption = '...'
        TabOrder = 1
      end
      object EMat: TEdit
        Left = 96
        Top = 0
        Width = 716
        Height = 21
        Align = alClient
        TabOrder = 0
        Text = 'EMat'
      end
    end
    object PInv: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 27
      Width = 863
      Height = 21
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object LInv: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 90
        Height = 15
        Align = alLeft
        AutoSize = False
        Caption = #1048#1089#1089#1083#1077#1076#1086#1074#1072#1085#1080#1077
      end
      object LInvInfo: TLabel
        AlignWithMargins = True
        Left = 835
        Top = 3
        Width = 25
        Height = 15
        Align = alRight
        Alignment = taRightJustify
        AutoSize = False
        Caption = '555'
        Enabled = False
        ExplicitLeft = 828
      end
      object BtnInv: TBitBtn
        Left = 812
        Top = 0
        Width = 20
        Height = 21
        Align = alRight
        Caption = '...'
        TabOrder = 1
      end
      object EInv: TComboBox
        Left = 96
        Top = 0
        Width = 716
        Height = 21
        Align = alClient
        TabOrder = 0
        Text = 'EInv'
      end
    end
    object PExp: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 51
      Width = 863
      Height = 21
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object LExp: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 90
        Height = 15
        Align = alLeft
        AutoSize = False
        Caption = #1069#1082#1089#1087#1077#1088#1090#1080#1079#1072
      end
      object LExpInfo: TLabel
        AlignWithMargins = True
        Left = 835
        Top = 3
        Width = 25
        Height = 15
        Align = alRight
        Alignment = taRightJustify
        AutoSize = False
        Caption = '555'
        Enabled = False
        ExplicitLeft = 827
      end
      object BtnExp: TBitBtn
        Left = 812
        Top = 0
        Width = 20
        Height = 21
        Action = AExpInfo
        Align = alRight
        Caption = '?'
        TabOrder = 1
      end
      object EExp: TComboBox
        Left = 96
        Top = 0
        Width = 716
        Height = 21
        Align = alClient
        TabOrder = 0
        Text = 'EExp'
      end
    end
  end
  object Tree: TTreeView
    AlignWithMargins = True
    Left = 3
    Top = 78
    Width = 863
    Height = 435
    Margins.Top = 6
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
    TabOrder = 2
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
  object AList: TActionList
    Left = 272
    Top = 288
    object A_Mat: TAction
      Caption = '...'
      Hint = #1042#1099#1073#1086#1088' '#1080#1089#1089#1083#1077#1076#1091#1077#1084#1099#1093' '#1083#1080#1094
      OnExecute = A_MatExecute
    end
    object AExpInfo: TAction
      Caption = '?'
      Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1101#1082#1089#1087#1077#1088#1090#1080#1079#1077
      OnExecute = AExpInfoExecute
    end
    object A_SelAll: TAction
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1074#1089#1105
      Hint = #1054#1090#1084#1077#1090#1080#1090#1100' '#1074#1089#1105
      OnExecute = A_SelAllExecute
    end
    object A_DeselAll: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1089#1105
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1089#1105
      OnExecute = A_DeselAllExecute
    end
  end
  object PMenu: TPopupMenu
    Left = 304
    Top = 288
    object N3: TMenuItem
      Action = A_SelAll
    end
    object N6: TMenuItem
      Action = A_DeselAll
    end
  end
end
