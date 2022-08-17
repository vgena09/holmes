object FVAR_REST: TFVAR_REST
  Left = 330
  Top = 120
  Align = alClient
  Caption = 'FVAR_REST'
  ClientHeight = 398
  ClientWidth = 702
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
  PixelsPerInch = 96
  TextHeight = 13
  object BtnAdd: TBitBtn
    AlignWithMargins = True
    Left = 0
    Top = 373
    Width = 702
    Height = 25
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Action = AAdd
    Align = alBottom
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 0
  end
  object Grid: TStringGrid
    Left = 0
    Top = 0
    Width = 702
    Height = 370
    Margins.Left = 0
    Margins.Right = 0
    Align = alClient
    ScrollBars = ssNone
    TabOrder = 1
    ExplicitTop = 19
    ExplicitHeight = 351
  end
  object ActionList1: TActionList
    Left = 296
    Top = 144
    object AAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090
      ImageIndex = 13
      ShortCut = 45
      OnExecute = AAddExecute
    end
    object ADel: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090
      ImageIndex = 14
      ShortCut = 46
      OnExecute = ADelExecute
    end
    object AEdit: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      ShortCut = 115
      OnExecute = AEditExecute
    end
    object AUp: TAction
      Caption = #1055#1086#1076#1085#1103#1090#1100
      OnExecute = AUpExecute
    end
    object ADown: TAction
      Caption = #1054#1087#1091#1089#1090#1080#1090#1100
      OnExecute = ADownExecute
    end
  end
  object PMenu: TPopupMenu
    Left = 328
    Top = 144
    object N1: TMenuItem
      Action = AAdd
    end
    object N4: TMenuItem
      Action = AEdit
    end
    object N3: TMenuItem
      Action = ADel
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N5: TMenuItem
      Action = AUp
    end
    object N6: TMenuItem
      Action = ADown
    end
  end
end
