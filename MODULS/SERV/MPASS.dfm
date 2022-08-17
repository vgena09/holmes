object FPASS: TFPASS
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072'/'#1057#1084#1077#1085#1072' '#1087#1072#1088#1086#1083#1103
  ClientHeight = 137
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 95
    Width = 334
    Height = 2
    Align = alBottom
    ExplicitTop = 113
    ExplicitWidth = 340
  end
  object PBottom: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 106
    Width = 334
    Height = 25
    Margins.Left = 0
    Margins.Top = 9
    Margins.Right = 0
    Margins.Bottom = 6
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object BtnClose: TBitBtn
      Left = 234
      Top = 0
      Width = 100
      Height = 25
      Margins.Left = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Action = ACancel
      Align = alRight
      Caption = #1054#1090#1084#1077#1085#1072
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object BtnOk: TBitBtn
      AlignWithMargins = True
      Left = 114
      Top = 0
      Width = 100
      Height = 25
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 20
      Margins.Bottom = 0
      Action = AOk
      Align = alRight
      Caption = #1054#1082
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object POld: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 6
    Width = 328
    Height = 21
    Margins.Top = 6
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object LOld: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 106
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1057#1090#1072#1088#1099#1081' '#1087#1072#1088#1086#1083#1100
    end
    object EOld: TEdit
      Left = 112
      Top = 0
      Width = 216
      Height = 21
      Align = alClient
      TabOrder = 0
      Text = 'EOld'
      ExplicitLeft = 115
      ExplicitTop = 3
    end
  end
  object PNew: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 36
    Width = 328
    Height = 21
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LNew: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 106
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1053#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100
    end
    object ENew: TEdit
      Left = 112
      Top = 0
      Width = 216
      Height = 21
      Align = alClient
      TabOrder = 0
      Text = 'ENew'
    end
  end
  object PNew2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 66
    Width = 328
    Height = 21
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object LNew2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 106
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1053#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100
    end
    object ENew2: TEdit
      Left = 112
      Top = 0
      Width = 216
      Height = 21
      Align = alClient
      TabOrder = 0
      Text = 'ENew2'
    end
  end
  object AList: TActionList
    Left = 8
    Top = 104
    object AOk: TAction
      Caption = #1054#1082
      OnExecute = AOkExecute
    end
    object ACancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = ACancelExecute
    end
  end
end
