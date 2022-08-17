object FVAR_UD: TFVAR_UD
  Left = 233
  Top = 147
  Align = alClient
  BorderStyle = bsDialog
  Caption = 'FVAR_UD'
  ClientHeight = 226
  ClientWidth = 343
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid: TDBGrid
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 343
    Height = 173
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Align = alClient
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object BtnAdd: TBitBtn
    Left = 0
    Top = 201
    Width = 343
    Height = 25
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Action = A_Add
    Align = alBottom
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 1
  end
  object PBottom: TPanel
    Left = 0
    Top = 176
    Width = 343
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object BtnOk: TBitBtn
      Left = 193
      Top = 0
      Width = 150
      Height = 25
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = #1054#1082
      TabOrder = 0
    end
  end
  object ActionList1: TActionList
    Left = 72
    Top = 56
    object A_Add: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090
      ImageIndex = 13
      ShortCut = 45
      OnExecute = A_AddClick
    end
    object A_Del: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090
      ImageIndex = 14
      ShortCut = 46
      OnExecute = A_DelClick
    end
    object A_UnCheckAll: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1074#1099#1073#1086#1088
      OnExecute = A_UnCheckAllExecute
    end
  end
  object PMenu: TPopupMenu
    OnPopup = PMenuPopup
    Left = 104
    Top = 56
    object N1: TMenuItem
      Action = A_Add
    end
    object N3: TMenuItem
      Action = A_Del
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Action = A_UnCheckAll
    end
  end
end
