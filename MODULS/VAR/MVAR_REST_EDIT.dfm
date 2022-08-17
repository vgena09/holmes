object FVAR_REST_EDIT: TFVAR_REST_EDIT
  Left = 358
  Top = 146
  BorderStyle = bsDialog
  Caption = 'FVAR_REST_EDIT'
  ClientHeight = 145
  ClientWidth = 525
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
  object Bevel1: TBevel
    Left = 0
    Top = 111
    Width = 525
    Height = 3
    Align = alBottom
    ExplicitLeft = -3
    ExplicitTop = 75
  end
  object PBottom: TPanel
    Left = 0
    Top = 114
    Width = 525
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object BtnCancel: TBitBtn
      AlignWithMargins = True
      Left = 402
      Top = 3
      Width = 120
      Height = 25
      Align = alRight
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
    end
    object BtnOk: TBitBtn
      AlignWithMargins = True
      Left = 276
      Top = 3
      Width = 120
      Height = 25
      Align = alRight
      Caption = #1054#1082
      TabOrder = 0
    end
  end
  object PStatus: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 30
    Width = 519
    Height = 21
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LStatus: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 110
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object BtnStatus: TBitBtn
      Left = 499
      Top = 0
      Width = 20
      Height = 21
      Align = alRight
      Caption = '...'
      TabOrder = 1
    end
    object EStatus: TComboBox
      Left = 116
      Top = 0
      Width = 383
      Height = 21
      Align = alClient
      TabOrder = 0
      Text = 'EStatus'
    end
  end
  object PPlace: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 54
    Width = 519
    Height = 21
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object LPlace: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 110
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1052#1077#1089#1090#1086' '#1088#1072#1073#1086#1090#1099'/'#1078#1080#1090'.'
    end
    object BtnPlace: TBitBtn
      Left = 499
      Top = 0
      Width = 20
      Height = 21
      Align = alRight
      Caption = '...'
      TabOrder = 1
    end
    object EPlace: TComboBox
      Left = 116
      Top = 0
      Width = 383
      Height = 21
      Align = alClient
      TabOrder = 0
      Text = 'EPlace'
    end
  end
  object PFIO: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 6
    Width = 519
    Height = 21
    Margins.Top = 6
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object LFIO: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 110
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1060#1048#1054
    end
    object BtnFIO: TBitBtn
      Left = 499
      Top = 0
      Width = 20
      Height = 21
      Align = alRight
      Caption = '...'
      TabOrder = 1
    end
    object EFIO: TComboBox
      Left = 116
      Top = 0
      Width = 383
      Height = 21
      Align = alClient
      TabOrder = 0
      Text = 'EFIO'
    end
  end
  object PRight: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 78
    Width = 519
    Height = 21
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object LRight: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 110
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1055#1088#1072#1074#1072
    end
    object BtnRight: TBitBtn
      Left = 499
      Top = 0
      Width = 20
      Height = 21
      Align = alRight
      Caption = '...'
      TabOrder = 1
    end
    object ERight: TComboBox
      Left = 116
      Top = 0
      Width = 383
      Height = 21
      Align = alClient
      TabOrder = 0
      Text = 'EPlace'
    end
  end
  object ActionList1: TActionList
    Left = 72
    Top = 8
    object AOk: TAction
      Caption = #1054#1082
      OnExecute = AOkExecute
    end
    object ACancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = ACancelExecute
    end
    object ARight: TAction
      Caption = '...'
      OnExecute = ARightExecute
    end
  end
end
