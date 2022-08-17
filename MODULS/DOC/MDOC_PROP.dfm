object FDOC_PROP: TFDOC_PROP
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  ClientHeight = 162
  ClientWidth = 519
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    AlignWithMargins = True
    Left = 3
    Top = 123
    Width = 513
    Height = 2
    Align = alBottom
    ExplicitTop = 87
  end
  object PBottom: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 131
    Width = 513
    Height = 25
    Margins.Bottom = 6
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object BtnClose: TBitBtn
      Left = 185
      Top = 0
      Width = 200
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 1
      TabOrder = 0
    end
  end
  object PCaption: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 6
    Width = 513
    Height = 21
    Margins.Top = 6
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LCaption: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 6
      Width = 80
      Height = 15
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alLeft
      AutoSize = False
      Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
      ExplicitTop = 3
    end
    object ECaption: TDBEdit
      Left = 86
      Top = 0
      Width = 427
      Height = 21
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alClient
      TabOrder = 0
    end
  end
  object PDate: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 33
    Width = 513
    Height = 21
    Margins.Top = 0
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object LDate: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 80
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1044#1072#1090#1072
    end
    object LDay: TLabel
      AlignWithMargins = True
      Left = 359
      Top = 3
      Width = 151
      Height = 15
      Align = alClient
      Alignment = taRightJustify
      Caption = 'LDay'
      ExplicitLeft = 486
      ExplicitWidth = 24
      ExplicitHeight = 13
    end
    object EDate: TDateTimePicker
      AlignWithMargins = True
      Left = 86
      Top = 0
      Width = 267
      Height = 21
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alLeft
      Date = 0.620052673606551300
      Format = 'dd MMMM yyyy '#1075'.'
      Time = 0.620052673606551300
      TabOrder = 0
    end
  end
  object PControl: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 60
    Width = 513
    Height = 21
    Margins.Top = 0
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object LControl: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 80
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1050#1086#1085#1090#1088#1086#1083#1100
    end
    object LControlOld: TLabel
      AlignWithMargins = True
      Left = 359
      Top = 3
      Width = 151
      Height = 15
      Align = alClient
      Alignment = taRightJustify
      Caption = 'LControlOld'
      ExplicitLeft = 454
      ExplicitWidth = 56
      ExplicitHeight = 13
    end
    object EControl: TDateTimePicker
      AlignWithMargins = True
      Left = 105
      Top = 0
      Width = 248
      Height = 21
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alLeft
      Date = 0.620052673606551300
      Format = 'dd MMMM yyyy '#1075'., HH '#1095#1072#1089'. mm '#1084#1080#1085'.'
      Time = 0.620052673606551300
      TabOrder = 0
    end
    object CBControl: TCheckBox
      Left = 86
      Top = 0
      Width = 16
      Height = 21
      Align = alLeft
      TabOrder = 1
    end
  end
  object POk: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 87
    Width = 513
    Height = 21
    Margins.Top = 0
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object LOk: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 80
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1043#1086#1090#1086#1074#1086
    end
    object EOk: TDBCheckBox
      Left = 86
      Top = 0
      Width = 427
      Height = 21
      Align = alClient
      TabOrder = 0
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
  end
end
