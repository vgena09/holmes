object FVAR_MEMO: TFVAR_MEMO
  Left = 826
  Top = 167
  Align = alClient
  Caption = 'FVAR_MEMO'
  ClientHeight = 308
  ClientWidth = 446
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
  PixelsPerInch = 96
  TextHeight = 13
  object MMemo: TDBMemo
    Left = 0
    Top = 0
    Width = 446
    Height = 280
    Margins.Left = 0
    Margins.Right = 0
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    PopupMenu = PMenu
    TabOrder = 0
    OnChange = MMemoChange
    ExplicitTop = 22
    ExplicitHeight = 258
  end
  object BtnVer: TBitBtn
    AlignWithMargins = True
    Left = 0
    Top = 283
    Width = 446
    Height = 25
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Action = AVerify
    Align = alBottom
    Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
    TabOrder = 1
  end
  object AList: TActionList
    Images = FMAIN.ImgSys16
    Left = 16
    Top = 56
    object AVerify: TAction
      Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
      ImageIndex = 6
      ShortCut = 118
      OnExecute = AVerifyExecute
    end
    object ACut: TAction
      Caption = #1042#1099#1088#1077#1079#1072#1090#1100
      ImageIndex = 2
      ShortCut = 16472
      OnExecute = ACutExecute
    end
    object ACopy: TAction
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16451
      OnExecute = ACopyExecute
    end
    object APaste: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      ImageIndex = 4
      ShortCut = 16470
      OnExecute = APasteExecute
    end
    object AUndo: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ImageIndex = 5
      ShortCut = 16474
      OnExecute = AUndoExecute
    end
  end
  object PMenu: TPopupMenu
    Images = FMAIN.ImgSys16
    Left = 48
    Top = 56
    object N2: TMenuItem
      Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
      ImageIndex = 0
      ShortCut = 118
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Action = ACut
    end
    object N5: TMenuItem
      Action = ACopy
    end
    object N6: TMenuItem
      Action = APaste
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object N8: TMenuItem
      Action = AUndo
    end
  end
end
