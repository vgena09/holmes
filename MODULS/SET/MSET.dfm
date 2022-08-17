object FSET: TFSET
  Left = 642
  Top = 195
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 307
  ClientWidth = 669
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PBottom: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 279
    Width = 663
    Height = 25
    Margins.Top = 6
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object BtnClose: TBitBtn
      Left = 463
      Top = 0
      Width = 200
      Height = 25
      Align = alRight
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 1
      TabOrder = 0
    end
    object BtnReset: TBitBtn
      Left = 0
      Top = 0
      Width = 200
      Height = 25
      Action = AReset
      Align = alLeft
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
      TabOrder = 1
    end
  end
  object PControl: TPageControl
    Left = 0
    Top = 0
    Width = 669
    Height = 273
    ActivePage = TSUser
    Align = alClient
    TabOrder = 1
    object TSUser: TTabSheet
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      object PUser: TPanel
        Left = 0
        Top = 0
        Width = 661
        Height = 245
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object PPathUD: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 655
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object LPathUD: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 250
            Height = 15
            Margins.Left = 0
            Align = alLeft
            AutoSize = False
            Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077' '#1076#1077#1083
          end
          object BtnPathUD: TBitBtn
            Left = 635
            Top = 0
            Width = 20
            Height = 21
            Align = alRight
            Caption = '...'
            TabOrder = 0
            OnClick = BtnPathUDClick
          end
          object EPathUD: TComboBox
            Left = 253
            Top = 0
            Width = 382
            Height = 21
            Align = alClient
            TabOrder = 1
          end
        end
        object PPack: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 30
          Width = 655
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object LPack: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 250
            Height = 15
            Margins.Left = 0
            Align = alLeft
            AutoSize = False
            Caption = #1057#1078#1072#1090#1080#1077' '#1092#1072#1081#1083#1072' '#1076#1077#1083#1072' '#1087#1088#1080' '#1074#1099#1093#1086#1076#1077
          end
          object EPack: TComboBox
            Left = 253
            Top = 0
            Width = 402
            Height = 21
            Align = alClient
            TabOrder = 0
          end
        end
        object PWordZoom: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 57
          Width = 655
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object LWordZoom: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 250
            Height = 15
            Margins.Left = 0
            Align = alLeft
            AutoSize = False
            Caption = #1052#1072#1089#1096#1090#1072#1073' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074', %'
          end
          object EWordZoom: TEdit
            Left = 253
            Top = 0
            Width = 56
            Height = 21
            Align = alLeft
            TabOrder = 0
            Text = '0'
          end
          object UpDownWordZoom: TUpDown
            Left = 309
            Top = 0
            Width = 16
            Height = 21
            Associate = EWordZoom
            TabOrder = 1
          end
        end
        object PWordInterface: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 84
          Width = 655
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 3
          object LWordInterface: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 250
            Height = 15
            Margins.Left = 0
            Align = alLeft
            AutoSize = False
            Caption = 'Word-'#1080#1085#1090#1077#1088#1092#1077#1081#1089' '#1087#1088#1086#1074#1077#1088#1082#1080' '#1087#1088#1072#1074#1086#1087#1080#1089#1072#1085#1080#1103
          end
          object CBWordInterface: TCheckBox
            AlignWithMargins = True
            Left = 256
            Top = 3
            Width = 396
            Height = 15
            Hint = #1041#1086#1083#1100#1096#1077' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1077#1081' '#1087#1088#1086#1074#1077#1088#1082#1080', '#1085#1086' '#1085#1077' '#1085#1072' '#1074#1089#1077#1093' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1072#1093' '#1088#1072#1073#1086#1090#1072#1077#1090
            Align = alClient
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
        end
        object PAdministrator: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 138
          Width = 655
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 5
          object LAdministrator: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 250
            Height = 15
            Margins.Left = 0
            Align = alLeft
            AutoSize = False
            Caption = #1056#1077#1078#1080#1084' '#1072#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088#1072
          end
          object CBAdministrator: TCheckBox
            AlignWithMargins = True
            Left = 256
            Top = 3
            Width = 396
            Height = 15
            Align = alClient
            TabOrder = 0
          end
        end
        object POutlook: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 111
          Width = 655
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 4
          object LOutlook: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 250
            Height = 15
            Margins.Left = 0
            Align = alLeft
            AutoSize = False
            Caption = #1050#1086#1085#1090#1088#1086#1083#1100' '#1089#1088#1086#1082#1086#1074' '#1074' Outlook'
          end
          object CBOutlook: TCheckBox
            AlignWithMargins = True
            Left = 256
            Top = 3
            Width = 396
            Height = 15
            Hint = 
              #1057#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1103' '#1082#1086#1085#1090#1088#1086#1083#1100#1085#1099#1093' '#1089#1088#1086#1082#1086#1074' '#1076#1077#1083#1072' '#1087#1088#1080' '#1077#1075#1086' '#1086#1090#1082#1088#1099#1090#1080#1080' '#1080' '#1079#1072#1082#1088#1099#1090#1080 +
              #1080' '#1089' Outlook'
            Align = alClient
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
        end
      end
    end
    object TSAdmin: TTabSheet
      Caption = #1040#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088
      ImageIndex = 1
      object PAdmin: TPanel
        Left = 0
        Top = 0
        Width = 661
        Height = 245
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object PContact: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 149
          Width = 655
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object LContact: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 250
            Height = 15
            Margins.Left = 0
            Align = alLeft
            AutoSize = False
            Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
          end
          object EContact: TEdit
            Left = 253
            Top = 0
            Width = 402
            Height = 21
            Align = alClient
            TabOrder = 0
            Text = 'EContact'
          end
        end
        object PInfo: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 176
          Width = 655
          Height = 66
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          object LInfo: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 250
            Height = 60
            Margins.Left = 0
            Align = alLeft
            AutoSize = False
            Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077
            ExplicitHeight = 15
          end
          object EInfo: TMemo
            Left = 253
            Top = 0
            Width = 402
            Height = 66
            Align = alClient
            Lines.Strings = (
              'EInfo')
            TabOrder = 0
          end
        end
        object PBase: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 655
          Height = 140
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object LBase: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 250
            Height = 134
            Margins.Left = 0
            Align = alLeft
            AutoSize = False
            Caption = #1054#1090#1082#1088#1099#1090#1100' '#1073#1072#1079#1091' '#1076#1072#1085#1085#1099#1093
            ExplicitHeight = 15
          end
          object Panel1: TPanel
            Left = 253
            Top = 0
            Width = 402
            Height = 140
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object Button1: TButton
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 402
              Height = 25
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Action = ABDExpert
              Align = alTop
              TabOrder = 0
            end
            object Button2: TButton
              AlignWithMargins = True
              Left = 0
              Top = 28
              Width = 402
              Height = 25
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Action = ABDNorm
              Align = alTop
              TabOrder = 1
            end
            object Button3: TButton
              AlignWithMargins = True
              Left = 0
              Top = 56
              Width = 402
              Height = 25
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Action = ABDNewUD
              Align = alTop
              TabOrder = 2
            end
            object Button4: TButton
              AlignWithMargins = True
              Left = 0
              Top = 84
              Width = 402
              Height = 25
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Action = ABDSetGlobal
              Align = alTop
              TabOrder = 3
            end
            object Button5: TButton
              AlignWithMargins = True
              Left = 0
              Top = 112
              Width = 402
              Height = 25
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Action = ABDSetLocal
              Align = alTop
              TabOrder = 4
            end
          end
        end
      end
    end
  end
  object AList: TActionList
    Left = 16
    Top = 192
    object AReset: TAction
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
      OnExecute = AResetExecute
    end
    object ABDExpert: TAction
      Caption = #1069#1082#1089#1087#1077#1088#1090#1080#1079#1099
      OnExecute = ABDExpertExecute
    end
    object ABDNorm: TAction
      Caption = #1053#1086#1088#1084#1072#1090#1080#1074#1082#1072
      OnExecute = ABDNormExecute
    end
    object ABDSetLocal: TAction
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1083#1086#1082#1072#1083#1100#1085#1099#1077
      OnExecute = ABDSetLocalExecute
    end
    object ABDSetGlobal: TAction
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1075#1083#1086#1073#1072#1083#1100#1085#1099#1077
      OnExecute = ABDSetGlobalExecute
    end
    object ABDNewUD: TAction
      Caption = #1053#1086#1074#1086#1077' '#1076#1077#1083#1086
      OnExecute = ABDNewUDExecute
    end
  end
end
