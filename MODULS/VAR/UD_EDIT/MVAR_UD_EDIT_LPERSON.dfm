object FVAR_UD_EDIT_LPERSON: TFVAR_UD_EDIT_LPERSON
  Left = 223
  Top = 64
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'FVAR_UD_EDIT_LPERSON'
  ClientHeight = 463
  ClientWidth = 707
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PBottom: TPanel
    Left = 0
    Top = 432
    Width = 707
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object BtnClose: TBitBtn
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 707
      Height = 25
      Margins.Left = 0
      Margins.Right = 0
      Align = alClient
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 0
    end
  end
  object PControl: TPageControl
    Left = 0
    Top = 0
    Width = 707
    Height = 432
    ActivePage = TSMain
    Align = alClient
    TabOrder = 1
    object TSMain: TTabSheet
      Caption = #1044#1072#1085#1085#1099#1077
      object GBFIO: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 693
        Height = 195
        Align = alTop
        Caption = ' '#1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '
        TabOrder = 0
        object PIP: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 21
          Width = 683
          Height = 21
          Margins.Top = 6
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object LIP: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 106
            Height = 15
            Align = alLeft
            AutoSize = False
            Caption = #1048#1084#1077#1085#1080#1090#1077#1083#1100#1085#1099#1081
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object EIP: TDBEdit
            Left = 112
            Top = 0
            Width = 522
            Height = 21
            Align = alClient
            TabOrder = 0
          end
          object BtnAuto: TBitBtn
            AlignWithMargins = True
            Left = 637
            Top = 0
            Width = 46
            Height = 21
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alRight
            Caption = #1040#1074#1090#1086
            TabOrder = 1
          end
        end
        object PRP: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 45
          Width = 683
          Height = 21
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object LRP: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 106
            Height = 15
            Align = alLeft
            AutoSize = False
            Caption = #1056#1086#1076#1080#1090#1077#1083#1100#1085#1099#1081
          end
          object ERP: TDBEdit
            Left = 112
            Top = 0
            Width = 571
            Height = 21
            Align = alClient
            TabOrder = 0
          end
        end
        object PDP: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 69
          Width = 683
          Height = 21
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object LDP: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 106
            Height = 15
            Align = alLeft
            AutoSize = False
            Caption = #1044#1072#1090#1077#1083#1100#1085#1099#1081
          end
          object EDP: TDBEdit
            Left = 112
            Top = 0
            Width = 571
            Height = 21
            Align = alClient
            TabOrder = 0
          end
        end
        object PVP: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 93
          Width = 683
          Height = 21
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 3
          object LVP: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 106
            Height = 15
            Align = alLeft
            AutoSize = False
            Caption = #1042#1080#1085#1080#1090#1077#1083#1100#1085#1099#1081
          end
          object EVP: TDBEdit
            Left = 112
            Top = 0
            Width = 571
            Height = 21
            Align = alClient
            TabOrder = 0
          end
        end
        object PTP: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 117
          Width = 683
          Height = 21
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 4
          object LTP: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 106
            Height = 15
            Align = alLeft
            AutoSize = False
            Caption = #1058#1074#1086#1088#1080#1090#1077#1083#1100#1085#1099#1081
          end
          object ETP: TDBEdit
            Left = 112
            Top = 0
            Width = 571
            Height = 21
            Align = alClient
            TabOrder = 0
          end
        end
        object PPP: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 141
          Width = 683
          Height = 21
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 5
          object LPP: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 106
            Height = 15
            Align = alLeft
            AutoSize = False
            Caption = #1055#1088#1077#1076#1083#1086#1078#1085#1099#1081
          end
          object EPP: TDBEdit
            Left = 112
            Top = 0
            Width = 571
            Height = 21
            Align = alClient
            TabOrder = 0
          end
        end
        object PShort: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 165
          Width = 683
          Height = 21
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 6
          object LShort: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 106
            Height = 15
            Align = alLeft
            AutoSize = False
            Caption = #1057#1086#1082#1088#1072#1097#1077#1085#1085#1086#1077' '#1085#1072#1080#1084'.'
            ExplicitLeft = 0
          end
          object EShort: TDBEdit
            Left = 112
            Top = 0
            Width = 571
            Height = 21
            Align = alClient
            TabOrder = 0
          end
        end
      end
      object PStatus: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 204
        Width = 693
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
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EStatus: TDBComboBox
          Left = 116
          Top = 0
          Width = 577
          Height = 21
          Align = alClient
          TabOrder = 0
        end
      end
      object PBoss: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 228
        Width = 693
        Height = 21
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object LBoss: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 110
          Height = 15
          Align = alLeft
          AutoSize = False
          Caption = #1056#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1100
        end
        object EBoss: TDBEdit
          Left = 116
          Top = 0
          Width = 577
          Height = 21
          Align = alClient
          TabOrder = 0
        end
      end
      object PAddress: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 252
        Width = 693
        Height = 21
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 3
        object LAddress: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 110
          Height = 15
          Align = alLeft
          AutoSize = False
          Caption = #1040#1076#1088#1077#1089
        end
        object EAddress: TDBEdit
          Left = 116
          Top = 0
          Width = 577
          Height = 21
          Align = alClient
          TabOrder = 0
        end
      end
      object PContacts: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 276
        Width = 693
        Height = 21
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 4
        object LContacts: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 110
          Height = 15
          Align = alLeft
          AutoSize = False
          Caption = #1050#1086#1085#1090#1072#1082#1090#1099
        end
        object EContacts: TDBEdit
          Left = 116
          Top = 0
          Width = 577
          Height = 21
          Align = alClient
          TabOrder = 0
        end
      end
      object EHint: TDBMemo
        AlignWithMargins = True
        Left = 3
        Top = 300
        Width = 693
        Height = 101
        Align = alClient
        TabOrder = 5
      end
    end
    object TSSet: TTabSheet
      Caption = #1059#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ESet: TDBMemo
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 699
        Height = 373
        Margins.Left = 0
        Margins.Right = 0
        Align = alClient
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object BtnVer: TBitBtn
        Left = 0
        Top = 379
        Width = 699
        Height = 25
        Align = alBottom
        Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
        TabOrder = 1
      end
    end
  end
end
