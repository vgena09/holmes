object FSTRUCT: TFSTRUCT
  Left = 0
  Top = 0
  Caption = 'FSTRUCT'
  ClientHeight = 174
  ClientWidth = 293
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Tree: TTreeView
    Left = 0
    Top = 0
    Width = 293
    Height = 174
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
  object PMenu: TPopupMenu
    Left = 128
    Top = 48
    object N1: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100
      object N3: TMenuItem
        Action = AAdd_PPerson
      end
      object N4: TMenuItem
        Action = AAdd_LPerson
      end
      object N5: TMenuItem
        Action = AAdd_DPerson
      end
      object N6: TMenuItem
        Action = AAdd_Object
      end
    end
    object N7: TMenuItem
      Action = AOpen
    end
    object N2: TMenuItem
      Action = ADel
    end
  end
  object AList: TActionList
    Left = 96
    Top = 48
    object AAdd_PPerson: TAction
      Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'...'
      OnExecute = AAdd_PPersonExecute
    end
    object AAdd_LPerson: TAction
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'...'
      OnExecute = AAdd_LPersonExecute
    end
    object AAdd_DPerson: TAction
      Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1077' '#1083#1080#1094#1086'...'
      OnExecute = AAdd_DPersonExecute
    end
    object AAdd_Object: TAction
      Caption = #1054#1073#1098#1077#1082#1090'...'
      OnExecute = AAdd_ObjectExecute
    end
    object AOpen: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100'...'
      OnExecute = AOpenExecute
    end
    object ADel: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = ADelExecute
    end
  end
end
