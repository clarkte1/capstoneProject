unit LLForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TLeveledListForm = class(TForm)
    SelectedLLText: TStaticText;
    SpawnLevelText: TStaticText;
    SpawnLevelTextEdit: TEdit;
    SpawnsInNotText: TStaticText;
    IncludedListsText: TStaticText;
    ListBox1: TListBox;
    ListBox2: TListBox;
    TransferButton: TButton;
    OkButton: TButton;
    procedure OkButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LeveledListForm: TLeveledListForm;

implementation

{$R *.dfm}
procedure TLeveledListForm.OkButtonClick(Sender: TObject);
begin
 LeveledListForm.Hide;
end;

end.

