object FVAR_REST_ADD: TFVAR_REST_ADD
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1083#1080#1094#1086
  ClientHeight = 81
  ClientWidth = 395
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
    Top = 47
    Width = 395
    Height = 3
    Align = alBottom
    ExplicitLeft = -130
    ExplicitTop = 85
    ExplicitWidth = 525
  end
  object PBottom: TPanel
    Left = 0
    Top = 50
    Width = 395
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object BtnCancel: TBitBtn
      AlignWithMargins = True
      Left = 272
      Top = 3
      Width = 120
      Height = 25
      Align = alRight
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
    end
    object BtnOk: TBitBtn
      AlignWithMargins = True
      Left = 146
      Top = 3
      Width = 120
      Height = 25
      Align = alRight
      Caption = #1054#1082
      TabOrder = 0
    end
  end
  object PFIO: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 12
    Width = 389
    Height = 21
    Margins.Top = 12
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object LFIO: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 38
      Height = 15
      Align = alLeft
      AutoSize = False
      Caption = #1060#1048#1054
      ExplicitLeft = 0
    end
    object BtnFIO: TBitBtn
      Left = 369
      Top = 0
      Width = 20
      Height = 21
      Align = alRight
      Caption = '...'
      TabOrder = 1
    end
    object EFIO: TComboBox
      Left = 44
      Top = 0
      Width = 325
      Height = 21
      Align = alClient
      TabOrder = 0
      Text = 'EFIO'
    end
  end
end
