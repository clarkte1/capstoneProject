object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 467
  ClientWidth = 819
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonBuildPatch: TButton
    Left = 8
    Top = 8
    Width = 105
    Height = 25
    Caption = 'ButtonBuildPatch'
    TabOrder = 0
    OnClick = ButtonBuildPatchClick
  end
  object ListBoxPlugins: TListBox
    Left = 8
    Top = 39
    Width = 105
    Height = 410
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBoxPluginsClick
  end
  object PageController: TPageControl
    Left = 119
    Top = 8
    Width = 692
    Height = 434
    ActivePage = ArmorSheet
    TabOrder = 2
    OnChange = PageControllerChange
    object ArmorSheet: TTabSheet
      Caption = 'ArmorSheet'
    end
    object WeaponSheet: TTabSheet
      Caption = 'Weapons'
      ImageIndex = 1
    end
    object SetsSheet: TTabSheet
      Caption = 'Weapon and Armor Sets'
      ImageIndex = 2
    end
    object StatusPage: TTabSheet
      Caption = 'StatusPage'
      ImageIndex = 3
      object LogListView: TListView
        Left = 3
        Top = 3
        Width = 367
        Height = 390
        Columns = <>
        TabOrder = 0
      end
      object StatusPanelMessage: TPanel
        Left = 376
        Top = 13
        Width = 241
        Height = 380
        Caption = 'StatusPanelMessage'
        TabOrder = 1
      end
    end
  end
  object DBGirdArmors: TDBGrid
    Left = 136
    Top = 39
    Width = 657
    Height = 386
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
end
