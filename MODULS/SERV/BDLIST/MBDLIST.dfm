object FBDList: TFBDList
  Left = 372
  Top = 194
  BorderStyle = bsDialog
  Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1089#1087#1080#1089#1082#1072' '#1087#1086#1076#1089#1090#1072#1085#1086#1074#1082#1080
  ClientHeight = 535
  ClientWidth = 513
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
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 513
    Height = 473
    Align = alClient
    BorderStyle = bsNone
    Options = [dgEditing, dgColumnResize, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object BtnClose: TButton
    AlignWithMargins = True
    Left = 3
    Top = 507
    Width = 507
    Height = 25
    Align = alBottom
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
  end
  object Nav: TDBNavigator
    AlignWithMargins = True
    Left = 3
    Top = 476
    Width = 507
    Height = 25
    VisibleButtons = [nbInsert, nbDelete]
    Align = alBottom
    Hints.Strings = (
      'First record'
      'Prior record'
      'Next record'
      'Last record'
      #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      'Edit record'
      'Post edit'
      'Cancel edit'
      'Refresh data'
      'Apply updates'
      'Cancel updates')
    Kind = dbnHorizontal
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
end
