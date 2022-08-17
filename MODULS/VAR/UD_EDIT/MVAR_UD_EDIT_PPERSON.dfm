object FVAR_UD_EDIT_PPERSON: TFVAR_UD_EDIT_PPERSON
  AlignWithMargins = True
  Left = 358
  Top = 146
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'FVAR_UD_EDIT_PPERSON'
  ClientHeight = 543
  ClientWidth = 982
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
  object PControl: TPageControl
    Left = 0
    Top = 0
    Width = 982
    Height = 512
    ActivePage = TSMain
    Align = alClient
    TabOrder = 1
    object TSMain: TTabSheet
      Caption = #1044#1072#1085#1085#1099#1077
      object EHint: TDBMemo
        AlignWithMargins = True
        Left = 3
        Top = 373
        Width = 968
        Height = 108
        Align = alClient
        TabOrder = 0
      end
      object PTop: TPanel
        Left = 0
        Top = 0
        Width = 974
        Height = 370
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object PTopRight: TPanel
          Left = 492
          Top = 0
          Width = 482
          Height = 370
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          object PGragd: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 252
            Width = 476
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 4
            object LGragd: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 110
              Height = 15
              Align = alLeft
              AutoSize = False
              Caption = #1043#1088#1072#1078#1076#1072#1085#1089#1090#1074#1086
            end
            object BtnGragd: TBitBtn
              Left = 456
              Top = 0
              Width = 20
              Height = 21
              Align = alRight
              Caption = '...'
              TabOrder = 1
            end
            object EGragd: TDBComboBox
              Left = 116
              Top = 0
              Width = 340
              Height = 21
              Align = alClient
              TabOrder = 0
            end
          end
          object PEducation: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 276
            Width = 476
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 5
            object LEducation: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 110
              Height = 15
              Align = alLeft
              AutoSize = False
              Caption = #1054#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077
            end
            object BtnEducation: TBitBtn
              Left = 456
              Top = 0
              Width = 20
              Height = 21
              Align = alRight
              Caption = '...'
              TabOrder = 1
            end
            object EEducation: TDBComboBox
              Left = 116
              Top = 0
              Width = 340
              Height = 21
              Align = alClient
              TabOrder = 0
            end
          end
          object PFamily: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 300
            Width = 476
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 6
            object LFamily: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 110
              Height = 15
              Align = alLeft
              AutoSize = False
              Caption = #1057#1077#1084#1077#1081#1085#1086#1077' '#1087#1086#1083#1086#1078#1077#1085'.'
            end
            object EFamily: TDBComboBox
              Left = 116
              Top = 0
              Width = 340
              Height = 21
              Align = alClient
              TabOrder = 0
            end
            object BtnFamily: TBitBtn
              Left = 456
              Top = 0
              Width = 20
              Height = 21
              Align = alRight
              Caption = '...'
              TabOrder = 1
            end
          end
          object PBornPlace: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 324
            Width = 476
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 7
            object LBornPlace: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 110
              Height = 15
              Align = alLeft
              AutoSize = False
              Caption = #1052#1077#1089#1090#1086' '#1088#1086#1078#1076#1077#1085#1080#1103
            end
            object EBornPlace: TDBComboBox
              Left = 116
              Top = 0
              Width = 340
              Height = 21
              Align = alClient
              TabOrder = 0
            end
            object BtnBornPlace: TBitBtn
              Left = 456
              Top = 0
              Width = 20
              Height = 21
              Align = alRight
              Caption = '...'
              TabOrder = 1
            end
          end
          object PBornDate: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 348
            Width = 476
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 8
            object LBornDate: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 110
              Height = 15
              Align = alLeft
              AutoSize = False
              Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
            end
            object LBornOld: TLabel
              AlignWithMargins = True
              Left = 268
              Top = 3
              Width = 205
              Height = 15
              Align = alClient
              Alignment = taRightJustify
              Caption = 'LBornOld'
              ExplicitLeft = 429
              ExplicitWidth = 44
              ExplicitHeight = 13
            end
            object EBornDate: TDateTimePicker
              Left = 116
              Top = 0
              Width = 149
              Height = 21
              Align = alLeft
              Date = 0.620052673606551300
              Time = 0.620052673606551300
              DateFormat = dfLong
              TabOrder = 0
            end
          end
          object PStatus: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 204
            Width = 476
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
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
              Width = 360
              Height = 21
              Align = alClient
              TabOrder = 0
            end
          end
          object GBSex: TDBRadioGroup
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 476
            Height = 42
            Align = alTop
            Caption = ' '#1055#1086#1083' '
            Columns = 2
            Items.Strings = (
              #1052#1091#1078#1095#1080#1085#1072
              #1046#1077#1085#1097#1080#1085#1072)
            ParentBackground = True
            TabOrder = 0
            Values.Strings = (
              'True'
              'False')
          end
          object GBDocument: TGroupBox
            AlignWithMargins = True
            Left = 3
            Top = 54
            Width = 476
            Height = 144
            Margins.Top = 6
            Align = alTop
            Caption = ' '#1044#1086#1082#1091#1084#1077#1085#1090' '
            TabOrder = 1
            object PDocType: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 18
              Width = 466
              Height = 21
              Margins.Bottom = 0
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              object LDocType: TLabel
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 110
                Height = 15
                Align = alLeft
                AutoSize = False
                Caption = #1058#1080#1087
              end
              object EDocType: TDBComboBox
                Left = 116
                Top = 0
                Width = 330
                Height = 21
                Align = alClient
                TabOrder = 0
              end
              object BtnDocType: TBitBtn
                Left = 446
                Top = 0
                Width = 20
                Height = 21
                Align = alRight
                Caption = '...'
                TabOrder = 1
              end
            end
            object PDocNomer: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 42
              Width = 466
              Height = 21
              Margins.Bottom = 0
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 1
              object LDocNomer: TLabel
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 110
                Height = 15
                Align = alLeft
                AutoSize = False
                Caption = #1057#1077#1088#1080#1103' '#1080' '#1085#1086#1084#1077#1088
              end
              object EDocNomer: TDBEdit
                Left = 116
                Top = 0
                Width = 350
                Height = 21
                Align = alClient
                TabOrder = 0
              end
            end
            object PDocPlace: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 66
              Width = 466
              Height = 21
              Margins.Bottom = 0
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 2
              object LDocPlace: TLabel
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 110
                Height = 15
                Align = alLeft
                AutoSize = False
                Caption = #1042#1099#1076#1072#1085
              end
              object EDocPlace: TDBComboBox
                Left = 116
                Top = 0
                Width = 330
                Height = 21
                Align = alClient
                TabOrder = 0
              end
              object BtnDocPlace: TBitBtn
                Left = 446
                Top = 0
                Width = 20
                Height = 21
                Align = alRight
                Caption = '...'
                TabOrder = 1
              end
            end
            object PDocDate: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 90
              Width = 466
              Height = 21
              Margins.Bottom = 0
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 3
              object LDocDate: TLabel
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 110
                Height = 15
                Align = alLeft
                AutoSize = False
                Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
              end
              object LDocOld: TLabel
                AlignWithMargins = True
                Left = 268
                Top = 3
                Width = 195
                Height = 15
                Align = alClient
                Alignment = taRightJustify
                Caption = 'LYearOld'
                ExplicitLeft = 419
                ExplicitWidth = 44
                ExplicitHeight = 13
              end
              object EDocDate: TDateTimePicker
                Left = 116
                Top = 0
                Width = 149
                Height = 21
                Align = alLeft
                Date = 0.620052673606551300
                Time = 0.620052673606551300
                DateFormat = dfLong
                TabOrder = 0
              end
            end
            object PPersNomer: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 114
              Width = 466
              Height = 21
              Margins.Bottom = 0
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 4
              object LPersNomer: TLabel
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 110
                Height = 15
                Align = alLeft
                AutoSize = False
                Caption = #1051#1080#1095#1085#1099#1081' '#1085#1086#1084#1077#1088
              end
              object EPersNomer: TDBEdit
                Left = 116
                Top = 0
                Width = 350
                Height = 21
                Align = alClient
                TabOrder = 0
              end
            end
          end
          object PArt: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 228
            Width = 476
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 3
            object LArt: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 110
              Height = 15
              Align = alLeft
              AutoSize = False
              Caption = #1057#1090#1072#1090#1100#1080
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object BtnArt: TBitBtn
              Left = 456
              Top = 0
              Width = 20
              Height = 21
              Align = alRight
              Caption = '...'
              TabOrder = 1
            end
            object EArt: TDBEdit
              Left = 116
              Top = 0
              Width = 340
              Height = 21
              Align = alClient
              TabOrder = 0
            end
          end
        end
        object PTopLeft: TPanel
          Left = 0
          Top = 0
          Width = 492
          Height = 370
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object GBFIO: TGroupBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 486
            Height = 195
            Align = alTop
            Caption = ' '#1060#1048#1054' ('#1087#1072#1076#1077#1078#1080') '
            TabOrder = 0
            object PIP: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 21
              Width = 476
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
                Width = 315
                Height = 21
                Align = alClient
                TabOrder = 0
              end
              object BtnAuto: TBitBtn
                AlignWithMargins = True
                Left = 430
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
              Width = 476
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
                Width = 364
                Height = 21
                Align = alClient
                TabOrder = 0
              end
            end
            object PDP: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 69
              Width = 476
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
                Width = 364
                Height = 21
                Align = alClient
                TabOrder = 0
              end
            end
            object PVP: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 93
              Width = 476
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
                Width = 364
                Height = 21
                Align = alClient
                TabOrder = 0
              end
            end
            object PTP: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 117
              Width = 476
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
                Width = 364
                Height = 21
                Align = alClient
                TabOrder = 0
              end
            end
            object PPP: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 141
              Width = 476
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
                Width = 364
                Height = 21
                Align = alClient
                TabOrder = 0
              end
            end
            object POld: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 165
              Width = 476
              Height = 21
              Margins.Bottom = 0
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 6
              object LOld: TLabel
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 106
                Height = 15
                Align = alLeft
                AutoSize = False
                Caption = #1055#1088#1077#1078#1076#1085#1080#1077
              end
              object EOld: TDBEdit
                Left = 112
                Top = 0
                Width = 364
                Height = 21
                Align = alClient
                TabOrder = 0
              end
            end
          end
          object PRegPlace: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 204
            Width = 486
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object LRegPlace: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 110
              Height = 15
              Align = alLeft
              AutoSize = False
              Caption = #1052#1077#1089#1090#1086' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
            end
            object ERegPlace: TDBEdit
              Left = 116
              Top = 0
              Width = 370
              Height = 21
              Align = alClient
              TabOrder = 0
            end
          end
          object PLivPlace: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 228
            Width = 486
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
            object LLivPlace: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 110
              Height = 15
              Align = alLeft
              AutoSize = False
              Caption = #1052#1077#1089#1090#1086' '#1078#1080#1090#1077#1083#1100#1089#1090#1074#1072
            end
            object ELivPlace: TDBEdit
              Left = 116
              Top = 0
              Width = 370
              Height = 21
              Align = alClient
              TabOrder = 0
            end
          end
          object PWorkPlace: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 252
            Width = 486
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 3
            object LWorkPlace: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 110
              Height = 15
              Align = alLeft
              AutoSize = False
              Caption = #1052#1077#1089#1090#1086' '#1088#1072#1073#1086#1090#1099
            end
            object EWorkPlace: TDBEdit
              Left = 116
              Top = 0
              Width = 370
              Height = 21
              Align = alClient
              TabOrder = 0
            end
          end
          object PContacts: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 300
            Width = 486
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 5
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
              Width = 370
              Height = 21
              Align = alClient
              TabOrder = 0
            end
          end
          object PSudimost: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 324
            Width = 486
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 6
            object LSudimost: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 110
              Height = 15
              Align = alLeft
              AutoSize = False
              Caption = #1057#1091#1076#1080#1084#1086#1089#1090#1080
            end
            object ESudimost: TDBEdit
              Left = 116
              Top = 0
              Width = 370
              Height = 21
              Align = alClient
              TabOrder = 0
            end
          end
          object PSoderg: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 348
            Width = 486
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 7
            object LSoderg: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 110
              Height = 15
              Align = alLeft
              AutoSize = False
              Caption = #1052#1077#1089#1090#1086' '#1089#1086#1076#1077#1088#1078#1072#1085#1080#1103
            end
            object ESoderg: TDBComboBox
              Left = 116
              Top = 0
              Width = 350
              Height = 21
              Align = alClient
              TabOrder = 0
            end
            object BtnSoderg: TBitBtn
              Left = 466
              Top = 0
              Width = 20
              Height = 21
              Align = alRight
              Caption = '...'
              TabOrder = 1
            end
          end
          object PWorkPost: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 276
            Width = 486
            Height = 21
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 4
            object LWorkPost: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 110
              Height = 15
              Align = alLeft
              AutoSize = False
              Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            end
            object EWorkPost: TDBEdit
              Left = 116
              Top = 0
              Width = 370
              Height = 21
              Align = alClient
              TabOrder = 0
            end
          end
        end
      end
    end
    object TSSet: TTabSheet
      Caption = #1059#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      ImageIndex = 1
      object ESet: TDBMemo
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 974
        Height = 453
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
        Top = 459
        Width = 974
        Height = 25
        Action = AVer
        Align = alBottom
        Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
        TabOrder = 1
      end
    end
  end
  object PBottom: TPanel
    Left = 0
    Top = 512
    Width = 982
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object BtnClose: TBitBtn
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 982
      Height = 25
      Margins.Left = 0
      Margins.Right = 0
      Align = alClient
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 0
    end
  end
  object AList: TActionList
    Images = FMAIN.ImgSys16
    Left = 344
    Top = 440
    object AVer: TAction
      Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
      ImageIndex = 31
      OnExecute = AVerExecute
    end
    object AArt: TAction
      Caption = '...'
      Hint = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
      OnExecute = AArtExecute
    end
  end
end
