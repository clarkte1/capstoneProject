unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.FMTBcd, Data.DB, Data.SqlExpr,
  Vcl.ComCtrls, Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,

    // delphi units
  Buttons, ExtCtrls, XPMan, ImgList, CommCtrl, Menus, Grids,
  ValEdit, ShellAPI, StrUtils, Clipbrd,
  // indy units
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  // third party libraries
  superobject, W7Taskbar,
  // mte components
  mteHelpers, mteTracker, mteLogger, mteLogging, mteProgressForm,
  mteBase, mteTaskHandler, RttiTranslation,
  // ms units
  msCore, msConfiguration, msLoader, msThreads, msOptionsForm,
  msEditForm, msSettingsManager, msTagManager, msSplashForm,
  // tes5edit units
  wbBSA, wbHelpers, wbInterface, wbImplementation, System.ImageList, Vcl.DBGrids;

type
  TForm1 = class(TForm)
    ButtonBuildPatch: TButton;
    ListBoxPlugins: TListBox;
    PageController: TPageControl;
    ArmorSheet: TTabSheet;
    WeaponSheet: TTabSheet;
    StatusPage: TTabSheet;
    LogListView: TListView;
    StatusPanelMessage: TPanel;
    ArmorGrid: TStringGrid;
    WeaponGrid: TStringGrid;
    MasterCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure LoaderStatus(s: string);
    procedure LogMessage(const group, &label, text: string);
    procedure UpdateLog;
    procedure InitDone;
    procedure FormDestroy(Sender: TObject);
    procedure ButtonBuildPatchClick(Sender: TObject);
    procedure PageControllerChange(Sender: TObject);
    procedure LogListViewData(Sender: TObject; Item: TListItem);
    procedure LogListViewDrawItem(Sender: TCustomListView; Item: TListItem; Rect: TRect; State: TOwnerDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBoxPluginsClick(Sender: TObject);
    procedure DisplayRecordLeveledListRecords(SelectedPlugin: TPlugin);
    procedure set_checkbox_alignment;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  splash: TSplashForm;
  Form1: TForm1;
  LastHint: string;
  LastURLTime, LastMessageTime, FormDisplayTime: double;
  bPatchesToBuild, bPatchesToCheck, bAutoScroll, bCreated, bClosing: boolean;
  pForm: TProgressForm;
  TaskHandler: TTaskHandler;

implementation

{$R *.dfm}




procedure InitLog;
begin
  BaseLog := TList.Create;
  Log := TList.Create;
  LabelFilters := TList.Create;
  GroupFilters := TList.Create;
  // INITIALIZE GROUP FILTERS
  GroupFilters.Add(TFilter.Create('GENERAL', true));
  GroupFilters.Add(TFilter.Create('LOAD', true));
  GroupFilters.Add(TFilter.Create('CLIENT', true));
  GroupFilters.Add(TFilter.Create('PATCH', true));
  GroupFilters.Add(TFilter.Create('PLUGIN', true));
  GroupFilters.Add(TFilter.Create('ERROR', true));
  // INITIALIZE LABEL FILTERS
  LabelFilters.Add(TFilter.Create('GENERAL', 'Game', true));
  LabelFilters.Add(TFilter.Create('GENERAL', 'Status', true));
  LabelFilters.Add(TFilter.Create('GENERAL', 'Path', true));
  LabelFilters.Add(TFilter.Create('GENERAL', 'Definitions', true));
  LabelFilters.Add(TFilter.Create('GENERAL', 'Dictionary', true));
  LabelFilters.Add(TFilter.Create('GENERAL', 'Load Order', true));
  LabelFilters.Add(TFilter.Create('GENERAL', 'Log', true));
  LabelFilters.Add(TFilter.Create('LOAD', 'Order', false));
  LabelFilters.Add(TFilter.Create('LOAD', 'Plugins', false));
  LabelFilters.Add(TFilter.Create('LOAD', 'Background', true));
  LabelFilters.Add(TFilter.Create('CLIENT', 'Connect', true));
  LabelFilters.Add(TFilter.Create('CLIENT', 'Login', true));
  LabelFilters.Add(TFilter.Create('CLIENT', 'Response', true));
  LabelFilters.Add(TFilter.Create('CLIENT', 'Update', true));
  LabelFilters.Add(TFilter.Create('CLIENT', 'Report', true));
  LabelFilters.Add(TFilter.Create('PATCH', 'Status', false));
  LabelFilters.Add(TFilter.Create('PATCH', 'Create', true));
  LabelFilters.Add(TFilter.Create('PATCH', 'Edit', true));
  LabelFilters.Add(TFilter.Create('PATCH', 'Check', true));
  LabelFilters.Add(TFilter.Create('PATCH', 'Clean', true));
  LabelFilters.Add(TFilter.Create('PATCH', 'Delete', true));
  LabelFilters.Add(TFilter.Create('PATCH', 'Build', true));
  LabelFilters.Add(TFilter.Create('PATCH', 'Report', true));
  LabelFilters.Add(TFilter.Create('PLUGIN', 'Report', true));
  LabelFilters.Add(TFilter.Create('PLUGIN', 'Check', true));
  LabelFilters.Add(TFilter.Create('PLUGIN', 'Tags', false));
  LabelFilters.Add(TFilter.Create('PLUGIN', 'Settings', true));
end;

procedure ProgressMessage(const s: string);
begin
  if s = '' then
    exit;
  Logger.Write(xEditLogGroup, xEditLogLabel, s);
end;

procedure TForm1.ListBoxPluginsClick(Sender: TObject);
var
  plugin : TPlugin;
  SelectedPlugin: string;
  I: Integer;
begin
  if ListBoxPlugins.ItemIndex = -1 then
    Exit;
  SelectedPlugin := ListBoxPlugins.Items[ListBoxPlugins.ItemIndex];

  for I := 0 to ArmorGrid.ColCount - 1 do
    ArmorGrid.Cols[I].Clear;

  ArmorGrid.Cells[0,0] := 'Editor ID';
  ArmorGrid.Cells[1,0] := 'Display Name';
  ArmorGrid.Cells[2,0] := 'Armor Rating';
  ArmorGrid.Cells[3,0] := 'HELLO HELLO';

  WeaponGrid.Cols[0].Text := 'Editor ID';
  WeaponGrid.Cols[1].Text := 'Display Name';
  WeaponGrid.Cols[2].Text := 'Weapon Damage';

  for I := 0 to ArmorGrid.ColCount - 1 do
    WeaponGrid.Cols[I].Clear;
  WeaponGrid.RowCount := 1;

  for plugin in PluginsList do
    if(plugin._File.Name = SelectedPlugin) then
      Logger.Write(xEditLogGroup, xEditLogLabel, SelectedPlugin);
      DisplayRecordLeveledListRecords(plugin);



end;

procedure TForm1.DisplayRecordLeveledListRecords(SelectedPlugin: TPlugin);
var
  PluginRecord: IwbMainRecord;
  I, Row, Row2, J: Integer;
  LeveledListsArmor : TStringList;
  NewCheckbox : TCheckbox;
begin

  LeveledListsArmor := TStringList.Create();

  for I := 0 to SelectedPlugin._File.RecordCount do
  begin


    PluginRecord := SelectedPlugin._File.Records[i];


    {Begin by sorting out all the armors in the data set}
    if (PluginRecord <> nil) and (PluginRecord.Signature = 'ARMO') then
    begin
      Logger.Write('DISPLAY', 'ARMOR RECORD TABLE', PluginRecord.DisplayName);



      Row := ArmorGrid.RowCount;
      ArmorGrid.RowCount := Row + 1;
      ArmorGrid.Cells[0, Row] := PluginRecord.FormID.ToString();
      ArmorGrid.Cells[1, Row] := PluginRecord.DisplayName;
      ArmorGrid.Cells[2, Row] := PluginRecord.ElementCount.ToString();

      for J := 0 to Pred(PluginRecord.ReferencedByCount) do
        begin
          if(PluginRecord.ReferencedByCount <> 0) then
          begin
            if(PluginRecord.ReferencedBy[J].Signature = 'LVLI') then
            begin
              if(-1 = LeveledListsArmor.IndexOf(PluginRecord.ReferencedBy[J].EditorID)) then
                begin
                  LeveledListsArmor.Add(PluginRecord.ReferencedBy[J].EditorID);
                  if(ArmorGrid.ColCount < LeveledListsArmor.Count - 3) then
                    ArmorGrid.ColCount := ArmorGrid.ColCount + 1;
                end;

                ArmorGrid.Cells[3 + LeveledListsArmor.IndexOf(PluginRecord.ReferencedBy[J].EditorID), 0] := PluginRecord.ReferencedBy[J].EditorID;

                NewCheckbox := TCheckbox.Create(Application);
                NewCheckBox.Width := 0;
                NewCheckBox.Visible := false;
                NewCheckBox.Caption := 'OK';
                NewCheckBox.Color := clWindow;
                NewCheckBox.Tag := J;
                NewCheckBox.OnClick := MasterCheckBox.OnClick; // Assign a previus OnClick event in an existing TCheckBox
                NewCheckBox.Parent := ArmorSheet;
                ArmorGrid.Objects[3 + LeveledListsArmor.IndexOf(PluginRecord.ReferencedBy[J].EditorID), Row] := NewCheckbox;



                Logger.Write('ARMOR LEVELED LIST', 'LEVELED LIST ITEMS', PluginRecord.ReferencedBy[J].EditorID);
            end;
          end;
        end;

      ArmorGrid.Row := Row;
    end;

    set_checkbox_alignment;

    {Weapons}
    if (PluginRecord <> nil) and (PluginRecord.Signature = 'WEAP') then
    begin
      Logger.Write('DISPLAY', 'WEAPON RECORD TABLE', PluginRecord.BaseName);
      Row2 := WeaponGrid.RowCount;
      WeaponGrid.RowCount := Row2 + 1;
      WeaponGrid.Cells[0, Row2] := PluginRecord.FormID.ToString();
      WeaponGrid.Cells[1, Row2] := PluginRecord.DisplayName;
      WeaponGrid.Row := Row2;
    end;

  end;
end;

Procedure TForm1.set_checkbox_alignment;
var
NewCheckBox: TCheckBox;
Rect: TRect;
i, j: Integer;
  begin
  for i := 1 to ArmorGrid.RowCount do
    begin
    for j := 1 to ArmorGrid.ColCount do
    begin
      NewCheckBox := (ArmorGrid.Objects[j,i] as TCheckBox);
      if NewCheckBox <> nil then
        begin
        Rect := ArmorGrid.CellRect(4,i); // here, we get the cell rect for our contol...
        NewCheckBox.Left := ArmorGrid.Left + Rect.Left+2;
        NewCheckBox.Top := ArmorGrid.Top + Rect.Top+2;
        NewCheckBox.Width := Rect.Right - Rect.Left;
        NewCheckBox.Height := Rect.Bottom - Rect.Top;
        NewCheckBox.Visible := True;
        end;
      end;
    end;
end;

procedure TForm1.LoaderStatus(s: string);
begin
  StatusPanelMessage.Caption := s;
end;

procedure TForm1.ButtonBuildPatchClick(Sender: TObject);
var
  item : TPlugin;
  records: iwbRecord;
  I: Integer;

begin
  Logger.Write(xEditLogGroup, xEditLogLabel, 'I pushed a button');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveLog(BaseLog);
end;

procedure TForm1.FormCreate(Sender: TObject);
var item : TPlugin;
begin
// INITIALIAZE BASE
  bCreated := false;
  AppStartTime := Now;
  InitLog;
  Logger.OnLogEvent := LogMessage;
  //bAutoScroll := true;
  InitializeTaskbarAPI;
  SetTaskbarProgressState(tbpsIndeterminate);
  xEditLogGroup := 'LOAD';
  xEditLogLabel := 'Plugins';
  wbProgressCallback := ProgressMessage;
  StatusCallback := LoaderStatus;


  InitCallback := InitDone;
  TInitThread.Create;

  if not InitBase then begin
    ProgramStatus.bClose := true;
    exit;
  end;

  // CREATE SPLASH
  splash := TSplashForm.Create(nil);
  try
    InitCallback := InitDone;
    TInitThread.Create;
    splash.ShowModal;
  finally
    splash.Free;
  end;



  // do translation dump?
  if bTranslationDump then
    TRttiTranslation.Save('lang\english.lang', self);

  // load language
  TRttiTranslation.Load(language, self);

  // finalize
  bCreated := true;


  for item in PluginsList do
    ListBoxPlugins.Items.Add(item._File.Name);


end;

{ Prints a message to the log }
procedure TForm1.LogMessage(const group, &label, text: string);
var
  msg: TLogMessage;
begin
  msg := TLogMessage.Create(
    FormatDateTime('hh:nn:ss', Now),
    FormatDateTime('hh:nn:ss', Now - AppStartTime),
    group, &label, text);
  BaseLog.Add(msg);

  // if message is enabled, add to log
  if MessageEnabled(msg) then begin
    Log.Add(msg);
    // if patch form is created, update log list view
    if bCreated then
      UpdateLog;
  end;
end;

procedure TForm1.PageControllerChange(Sender: TObject);
var
  ndx: integer;
begin
  ndx := TPageControl(Sender).ActivePageIndex;
  case ndx of
    0: begin

    end;
    1: begin

    end;
    2: begin

    end;
    3: begin
      ListView_CorrectWidth(LogListView);
    end;
  end;
end;

procedure TForm1.UpdateLog;
var
  bLogActive: boolean;
begin
  LogListView.Items.Count := Log.Count;
  bLogActive := PageController.ActivePage = StatusPage;
  // autoscroll if active
  if bAutoScroll and bLogActive then begin
    //LogListView.ClearSelection;
    //LogListView.Items[Pred(LogListView.Items.Count)].MakeVisible(false);
    SendMessage(LogListView.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
  end;
  // correct width if active
  if bLogActive then
    ListView_CorrectWidth(LogListView);
end;

procedure TForm1.InitDone;
begin
  Logger.Write('General', 'Status', 'Test');
  splash.ModalResult := mrOk;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // free lists
  FreeList(GroupFilters);
  FreeList(LabelFilters);

  // free other items
  TryToFree(TaskHandler);
end;


{******************************************************************************}
{ LogListView methods
}
{******************************************************************************}

procedure TForm1.LogListViewData(Sender: TObject; Item: TListItem);
var
  msg: TLogMessage;
begin
  if (Item.Index > Pred(Log.Count)) then
    exit;
  msg := TLogMessage(Log[Item.Index]);
  Item.Caption := msg.time;
  Item.SubItems.Add(msg.appTime);
  Item.SubItems.Add(msg.group);
  Item.SubItems.Add(msg.&label);
  Item.SubItems.Add(msg.text);

  // handle coloring
  if (msg.group = 'GENERAL') then
    LogListView.Canvas.Font.Color := settings.generalMessageColor
  else if (msg.group = 'LOAD') then
    LogListView.Canvas.Font.Color := settings.loadMessageColor
  else if (msg.group = 'CLIENT') then
    LogListView.Canvas.Font.Color := settings.clientMessageColor
  else if (msg.group = 'PATCH') then
    LogListView.Canvas.Font.Color := settings.patchMessageColor
  else if (msg.group = 'PLUGIN') then
    LogListView.Canvas.Font.Color := settings.pluginMessageColor
  else if (msg.group = 'ERROR') then
    LogListView.Canvas.Font.Color := settings.errorMessageColor;
end;

procedure TForm1.LogListViewDrawItem(Sender: TCustomListView;
  Item: TListItem; Rect: TRect; State: TOwnerDrawState);
var
  i, x, y: integer;
  ListView: TListView;
  R: TRect;
  msg: string;
  map: TStringList;
begin
  ListView := TListView(Sender);
  if Item.Selected then begin
    ListView.Canvas.Brush.Color := $FFEEDD;
    ListView.Canvas.FillRect(Rect);
  end;

  // prepare map
  map := TStringList.Create;
  map.Values[ListView.Columns[0].Caption] := Item.Caption;
  for i := 0 to Pred(Item.SubItems.Count) do
    map.Values[ListView.Columns[i + 1].Caption] := Item.SubItems[i];

  // prepare text rect
  R := Rect;
  R.Right := R.Left + ListView.Width - 3;
  x := Rect.Left + 3;
  y := (Rect.Bottom - Rect.Top - ListView.Canvas.TextHeight('Hg')) div 2 + Rect.Top;

  // draw message
  msg := ApplyTemplate(settings.logMessageTemplate, map);
  ListView.Canvas.TextRect(R, x, y, msg);

  // clean up
  map.Free;
end;

end.
