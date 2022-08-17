object FVAR_EDIT: TFVAR_EDIT
  Left = 710
  Top = 153
  Align = alClient
  Caption = 'FVAR_EDIT'
  ClientHeight = 256
  ClientWidth = 388
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
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object LList: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 49
    Width = 382
    Height = 13
    Align = alTop
    Caption = #1042#1072#1088#1080#1072#1085#1090#1099
    ExplicitWidth = 50
  end
  object LName: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 382
    Height = 13
    Align = alTop
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077
    ExplicitWidth = 48
  end
  object MList: TListBox
    AlignWithMargins = True
    Left = 0
    Top = 68
    Width = 388
    Height = 160
    Margins.Left = 0
    Margins.Right = 0
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    OnClick = MListClick
  end
  object BtnEditList: TBitBtn
    Left = 0
    Top = 231
    Width = 388
    Height = 25
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Action = AEditList
    Align = alBottom
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
    TabOrder = 1
  end
  object PEdit: TPanel
    Left = 0
    Top = 19
    Width = 388
    Height = 27
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object MEdit: TDBEdit
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 356
      Height = 21
      Margins.Left = 0
      Align = alClient
      TabOrder = 0
      OnChange = MEditChange
    end
    object BtnVerify: TBitBtn
      AlignWithMargins = True
      Left = 359
      Top = 3
      Width = 29
      Height = 21
      Margins.Left = 0
      Margins.Right = 0
      Action = AVerify
      Align = alRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
  object AList: TActionList
    Images = FMAIN.ImgSys16
    Left = 24
    Top = 104
    object AEditList: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
      OnExecute = AEditListExecute
    end
    object AVerify: TAction
      Hint = #1055#1088#1086#1074#1077#1088#1080#1090#1100' '#1089#1088#1077#1076#1089#1090#1074#1072#1084#1080' Word'
      ImageIndex = 6
      ShortCut = 118
      OnExecute = AVerifyExecute
    end
  end
end
