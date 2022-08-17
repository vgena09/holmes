object FVerify: TFVerify
  Left = 279
  Top = 201
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1086#1088#1092#1086#1075#1088#1072#1092#1080#1080
  ClientHeight = 371
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 410
    Height = 13
    Align = alTop
    Caption = #1053#1077#1090' '#1074' '#1089#1083#1086#1074#1072#1088#1077
    ExplicitWidth = 73
  end
  object REdit: TRichEdit
    Left = 0
    Top = 19
    Width = 416
    Height = 104
    Align = alTop
    Color = clBtnFace
    Enabled = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 0
  end
  object PMain: TPanel
    Left = 0
    Top = 123
    Width = 416
    Height = 248
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object PRight: TPanel
      AlignWithMargins = True
      Left = 263
      Top = 3
      Width = 150
      Height = 242
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BtnChange: TButton
        AlignWithMargins = True
        Left = 3
        Top = 152
        Width = 144
        Height = 25
        Align = alBottom
        Caption = #1047#1072#1084#1077#1085#1080#1090#1100
        ModalResult = 1
        TabOrder = 0
        OnClick = BtnChangeClick
      end
      object BtnIgnore: TButton
        AlignWithMargins = True
        Left = 3
        Top = 183
        Width = 144
        Height = 25
        Align = alBottom
        Caption = #1055#1088#1086#1087#1091#1089#1090#1080#1090#1100
        ModalResult = 5
        TabOrder = 1
      end
      object BtnAbort: TButton
        AlignWithMargins = True
        Left = 3
        Top = 214
        Width = 144
        Height = 25
        Align = alBottom
        Caption = #1055#1088#1077#1082#1088#1072#1090#1080#1090#1100
        ModalResult = 3
        TabOrder = 2
        OnClick = BtnAbortClick
      end
    end
    object GBox: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 254
      Height = 242
      Align = alClient
      Caption = ' '#1047#1072#1084#1077#1085#1080#1090#1100' '#1085#1072' '
      TabOrder = 1
      object Label2: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 45
        Width = 244
        Height = 13
        Align = alTop
        Caption = #1042#1072#1088#1080#1072#1085#1090#1099
        ExplicitWidth = 50
      end
      object EdReplaceWith: TEdit
        AlignWithMargins = True
        Left = 5
        Top = 18
        Width = 244
        Height = 21
        Align = alTop
        TabOrder = 0
        OnChange = EdReplaceWithChange
      end
      object ListVariants: TListBox
        AlignWithMargins = True
        Left = 5
        Top = 64
        Width = 244
        Height = 173
        Align = alClient
        ItemHeight = 13
        TabOrder = 1
        OnClick = ListVariantsClick
        OnDblClick = ListVariantsDblClick
      end
    end
  end
end
