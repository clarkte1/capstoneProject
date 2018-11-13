object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 677
  ClientWidth = 1105
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
    Height = 630
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBoxPluginsClick
  end
  object PageController: TPageControl
    Left = 119
    Top = 8
    Width = 978
    Height = 665
    ActivePage = ArmorSheet
    TabOrder = 2
    OnChange = PageControllerChange
    object ArmorSheet: TTabSheet
      Caption = 'ArmorSheet'
      object ArmorGrid: TStringGrid
        Left = 14
        Top = 20
        Width = 947
        Height = 613
        ColCount = 3
        TabOrder = 0
        ColWidths = (
          64
          64
          118)
      end
    end
    object WeaponSheet: TTabSheet
      Caption = 'Weapons'
      ImageIndex = 1
      object WeaponGrid: TStringGrid
        Left = 3
        Top = 3
        Width = 964
        Height = 630
        TabOrder = 0
        ColWidths = (
          64
          64
          144
          353
          338)
      end
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
      object MasterCheckBox: TCheckBox
        Left = 16
        Top = 416
        Width = 97
        Height = 17
        Caption = 'Enable Editing'
        TabOrder = 2
        Visible = False
      end
    end
  end
end
