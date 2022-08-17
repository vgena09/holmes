object FVAR_EXPERT: TFVAR_EXPERT
  Left = 257
  Top = 131
  Align = alClient
  Caption = 'FVAR_EXPERT'
  ClientHeight = 470
  ClientWidth = 674
  Color = clWindow
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
  object BtnQst: TBitBtn
    AlignWithMargins = True
    Left = 0
    Top = 445
    Width = 674
    Height = 25
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Action = A_Helper
    Align = alBottom
    Caption = #1055#1086#1084#1086#1097#1085#1080#1082' ...'
    TabOrder = 0
  end
  object Tree: TTreeView
    Left = 0
    Top = 0
    Width = 674
    Height = 442
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Align = alClient
    AutoExpand = True
    DragMode = dmAutomatic
    HideSelection = False
    Images = FMAIN.ImgSys16
    Indent = 19
    TabOrder = 1
    Items.NodeData = {
      0301000000280000000000000001000000FFFFFFFFFFFFFFFF00000000000000
      0001000000010531003200310032003100280000000200000003000000FFFFFF
      FFFFFFFFFF000000000000000000000000010531006400770073006500}
  end
  object AList: TActionList
    Left = 264
    Top = 56
    object A_Helper: TAction
      Caption = #1055#1086#1084#1086#1097#1085#1080#1082' ...'
      Hint = #1055#1086#1084#1086#1097#1085#1080#1082' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' '#1101#1082#1089#1087#1077#1088#1090#1080#1079
      ShortCut = 112
      OnExecute = A_HelperExecute
    end
    object A_IncExp: TAction
      Caption = #1053#1086#1074#1072#1103' '#1101#1082#1089#1087#1077#1088#1090#1080#1079#1072
      OnExecute = A_IncExpExecute
    end
    object A_IncQst: TAction
      Caption = #1053#1086#1074#1099#1081' '#1074#1086#1087#1088#1086#1089
      OnExecute = A_IncQstExecute
    end
    object A_IncMat_PPerson: TAction
      Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
      OnExecute = A_IncMat_PPersonExecute
    end
    object A_IncMat_Object: TAction
      Caption = #1054#1073#1098#1077#1082#1090
      OnExecute = A_IncMat_ObjectExecute
    end
    object A_Del: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ShortCut = 16430
      OnExecute = A_DelExecute
    end
    object A_DelAll: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077
      OnExecute = A_DelAllExecute
    end
    object A_Edit: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      ShortCut = 115
      OnExecute = A_EditExecute
    end
  end
  object PMenu: TPopupMenu
    OnPopup = PMenuPopup
    Left = 296
    Top = 56
    object N6: TMenuItem
      Action = A_Helper
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N11: TMenuItem
      Action = A_IncExp
    end
    object N13: TMenuItem
      Action = A_IncQst
    end
    object N3: TMenuItem
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1084#1072#1090#1077#1088#1080#1072#1083#1099
      object AIncMatPPerson1: TMenuItem
        Action = A_IncMat_PPerson
        Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      end
      object AIncMatObject1: TMenuItem
        Action = A_IncMat_Object
        Caption = #1054#1073#1098#1077#1082#1090#1099
      end
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Action = A_Edit
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Action = A_Del
      ShortCut = 46
    end
    object N10: TMenuItem
      Action = A_DelAll
    end
  end
end
