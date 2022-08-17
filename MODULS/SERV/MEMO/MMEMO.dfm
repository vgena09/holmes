object FMEMO: TFMEMO
  Left = 0
  Top = 0
  Caption = 'FMEMO'
  ClientHeight = 326
  ClientWidth = 668
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
  object Edit: TRichEdit
    Left = 24
    Top = 32
    Width = 241
    Height = 177
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Times New Roman'
    Font.Style = []
    Lines.Strings = (
      'Edit')
    ParentFont = False
    TabOrder = 0
  end
  object PBottom: TPanel
    Left = 0
    Top = 295
    Width = 668
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 567
    object BtnOk: TBitBtn
      AlignWithMargins = True
      Left = 359
      Top = 3
      Width = 150
      Height = 25
      Align = alRight
      Caption = #1054#1082
      TabOrder = 0
      ExplicitLeft = 258
    end
    object BtnCancel: TBitBtn
      AlignWithMargins = True
      Left = 515
      Top = 3
      Width = 150
      Height = 25
      Align = alRight
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      ExplicitLeft = 414
    end
    object BtnVerify: TBitBtn
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 150
      Height = 25
      Align = alLeft
      Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
      TabOrder = 2
    end
    object BtnWord: TBitBtn
      AlignWithMargins = True
      Left = 159
      Top = 3
      Width = 150
      Height = 25
      Action = AWord
      Align = alLeft
      Caption = #1055#1077#1088#1077#1076#1072#1090#1100' '#1074' Word'
      TabOrder = 3
      ExplicitLeft = 203
    end
  end
  object EditDB: TDBRichEdit
    Left = 304
    Top = 32
    Width = 241
    Height = 177
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object AList: TActionList
    Images = FMAIN.ImgSys16
    Left = 48
    Top = 72
    object AVerify: TAction
      Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
      OnExecute = AVerifyExecute
    end
    object AWord: TAction
      Caption = #1055#1077#1088#1077#1076#1072#1090#1100' '#1074' Word'
      OnExecute = AWordExecute
    end
  end
end
