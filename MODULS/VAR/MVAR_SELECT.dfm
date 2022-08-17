object FVAR_SELECT: TFVAR_SELECT
  Left = 710
  Top = 153
  Align = alClient
  Caption = 'FVAR_SELECT'
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
  object BtnEditList: TBitBtn
    AlignWithMargins = True
    Left = 0
    Top = 231
    Width = 388
    Height = 25
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Action = AEditList
    Align = alBottom
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
    TabOrder = 0
  end
  object LBox: TCheckListBox
    Left = 0
    Top = 0
    Width = 388
    Height = 228
    Align = alClient
    ItemHeight = 13
    Items.Strings = (
      #1074#1091#1072#1099
      #1099#1074#1072
      #1099#1074#1072
      #1099#1074)
    TabOrder = 1
    ExplicitTop = 19
    ExplicitHeight = 212
  end
  object AList: TActionList
    Images = FMAIN.ImgSys16
    Left = 88
    Top = 56
    object AEditList: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
      OnExecute = AEditListExecute
    end
  end
end
