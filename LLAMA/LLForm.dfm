object LeveledListForm: TLeveledListForm
  Left = 0
  Top = 0
  Caption = 'Leveled List Form'
  ClientHeight = 192
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SelectedLLText: TStaticText
    Left = 8
    Top = 8
    Width = 77
    Height = 17
    Caption = 'SelectedLLText'
    TabOrder = 0
  end
  object SpawnLevelText: TStaticText
    Left = 178
    Top = 8
    Width = 64
    Height = 17
    Caption = 'Spawn Level'
    TabOrder = 1
  end
  object SpawnLevelTextEdit: TEdit
    Left = 248
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object SpawnsInNotText: TStaticText
    Left = 8
    Top = 40
    Width = 71
    Height = 17
    Caption = 'Excluded Lists'
    TabOrder = 3
  end
  object IncludedListsText: TStaticText
    Left = 288
    Top = 40
    Width = 69
    Height = 17
    Caption = 'Included Lists'
    TabOrder = 4
  end
  object ListBox1: TListBox
    Left = 248
    Top = 63
    Width = 121
    Height = 121
    ItemHeight = 13
    TabOrder = 5
  end
  object ListBox2: TListBox
    Left = 8
    Top = 63
    Width = 121
    Height = 121
    ItemHeight = 13
    TabOrder = 6
  end
  object TransferButton: TButton
    Left = 135
    Top = 63
    Width = 107
    Height = 25
    Caption = '<- Transfer ->'
    TabOrder = 7
  end
  object OkButton: TButton
    Left = 152
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 8
    OnClick = OkButtonClick
  end
end
