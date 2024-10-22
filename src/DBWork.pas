unit DBWork;

interface

uses
  SQLEdit, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,
  FileCtrl, StdCtrls, ComCtrls, Tabnotbk, ExtCtrls, RXSplit, Grids,
  DBGrids, RXDBCtrl, Db, DBTables, Mask, DBCtrls,
  RXCtrls, Tabs, RxQuery, Menus, RxMenus, ToolWin, dbiProcs, dbiTypes,
  RxPicClip, RxDBLists;

type
  TDBWorked = class(TForm)
    TableList: TDatabaseItems;
    DataSource1: TDataSource;
    BDEItems1: TBDEItems;
    DataSource2: TDataSource;
    Panel1: TPanel;
    RxDBGrid1: TRxDBGrid;
    RxSplitter1: TRxSplitter;
    RxDBGrid2: TRxDBGrid;
    RxSplitter2: TRxSplitter;
    DataSource3: TDataSource;
    Table1: TTable;
    Panel2: TPanel;
    Notebook1: TNotebook;
    Panel4: TPanel;
    TabSet1: TTabSet;
    RxDBGrid3: TRxDBGrid;
    Panel5: TPanel;
    RxDBGrid4: TRxDBGrid;
    RxSplitter3: TRxSplitter;
    Memo1: TMemo;
    Panel3: TPanel;
    TableItems1: TTableItems;
    TableItems2: TTableItems;
    Panel7: TPanel;
    RxSpeedButton1: TRxSpeedButton;
    RxSpeedButton2: TRxSpeedButton;
    RxSpeedButton3: TRxSpeedButton;
    Panel6: TPanel;
    ToolBar1: TToolBar;
    ProgressBar1: TProgressBar;
    DataSource4: TDataSource;
    Qry: TRxQuery;
    RxLabel1: TRxLabel;
    DBImage: TPicClip;
    TableImage: TPicClip;
    DataSource5: TDataSource;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    RadioGroup1: TRadioGroup;
    Sort: TRxQuery;
    DBNavigator1: TDBNavigator;
    Button1: TButton;
    Button2: TButton;
    procedure RxDBGrid1CellClick(Column: TColumn);
    procedure RxDBGrid2CellClick(Column: TColumn);
    procedure FormClose(
        Sender    : TObject;
        var Action: TCloseAction);
    procedure TabSet1Click(Sender: TObject);
    procedure RxSpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DataSource1DataChange(
        Sender: TObject;
        Field : TField);
    procedure DataSource3DataChange(
        Sender: TObject;
        Field : TField);
    procedure DataSource4DataChange(
        Sender: TObject;
        Field : TField);
    procedure RxDBGrid2DrawColumnCell(
        Sender    : TObject;
        const Rect: TRect;
        DataCol   : Integer;
        Column    : TColumn;
        State     : TGridDrawState);
    procedure RxDBGrid1DrawColumnCell(
        Sender    : TObject;
        const Rect: TRect;
        DataCol   : Integer;
        Column    : TColumn;
        State     : TGridDrawState);
    procedure RxDBGrid1Enter(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure DataSource5DataChange(
        Sender: TObject;
        Field : TField);
    procedure RxDBGrid3DrawColumnCell(
        Sender    : TObject;
        const Rect: TRect;
        DataCol   : Integer;
        Column    : TColumn;
        State     : TGridDrawState);
    procedure Table1CalcFields(DataSet: TDataSet);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DBWorked: TDBWorked;

  del: Boolean;

implementation

{$R *.DFM}

uses SQLBuild;

procedure TDBWorked.RxDBGrid1CellClick(Column: TColumn);
  Var
    ss, s: string;
  begin
    TableList.Active       := False;
    TableList.DatabaseName := BDEItems1.Fields[2].text;
    TableList.Active       := True;
    DBWorked.Caption       := BDEItems1.Fields[2].text;
    Str(
        BDEItems1.RecordCount,
        s);
    Str(
        BDEItems1.RecNo,
        ss);
    RxLabel1.Caption := ss + ':' + s;
  end;

procedure TDBWorked.RxDBGrid2CellClick(Column: TColumn);
  var
    i: Integer;
  begin
    Table1.Active            := False;
    Sort.Active              := False;
    TableItems1.Active       := False;
    TableItems2.Active       := False;
    Table1.DatabaseName      := BDEItems1.Fields[2].text;
    TableItems1.DatabaseName := BDEItems1.Fields[2].text;
    TableItems2.DatabaseName := BDEItems1.Fields[2].text;
    Sort.DatabaseName        := BDEItems1.Fields[2].text;
    Qry.DatabaseName         := BDEItems1.Fields[2].text;
    Sort.DatabaseName        := BDEItems1.Fields[2].text;
    Table1.TableName         := TableList.Fields[1].text + '.' +
        TableList.Fields[2].text;
    TableItems1.TableName := TableList.Fields[1].text;
    TableItems2.TableName := TableList.Fields[1].text;
    Table1.Active         := True;
    { dbiSetProp(hDBIObj(Table1.Handle), curSOFTDELETEON, 1);
      Table1.Refresh; }
    RxDBGrid3.DataSource := DataSource3;
    TableItems1.Active   := True;
    ComboBox1.Clear;
    if TableItems1.RecordCount > 0 then
      begin
        TableItems1.First; // Перемещаем указатель на первую запись
        while not TableItems1.Eof do
          begin
            ComboBox1.Items.Add(TableItems1.Fields[1].text);
            // Добавляем элемент
            TableItems1.Next; // Переходим к следующей записи
          end;
        ComboBox1.ItemIndex := 0; // Устанавливаем выбранный элемент
      end;

    TableItems2.Active := True;

  end;

procedure TDBWorked.FormClose(
    Sender    : TObject;
    var Action: TCloseAction);
  begin
    Action := caFree;
  end;

procedure TDBWorked.TabSet1Click(Sender: TObject);
  begin
    if TabSet1.tabindex <> 3 then
      Notebook1.ActivePage := 'Table';
    if TabSet1.tabindex = 0 then
      begin
        if Sort.Active = True then
          RxDBGrid3.DataSource := DataSource5
        else
          RxDBGrid3.DataSource := DataSource3;
        DataSource3.DataSet    := Table1;
      end;
    if TabSet1.tabindex = 1 then
      begin
        RxDBGrid3.DataSource := DataSource3;
        DataSource3.DataSet  := TableItems1;
      end;
    if TabSet1.tabindex = 2 then
      begin
        RxDBGrid3.DataSource := DataSource3;
        DataSource3.DataSet  := TableItems2;
      end;
    if TabSet1.tabindex = 3 then
      Notebook1.ActivePage := 'SQL';
  end;

procedure TDBWorked.RxSpeedButton1Click(Sender: TObject);
  begin
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL := Memo1.lines;
    Qry.ExecSQL;
    Qry.Active := True;
  end;

procedure TDBWorked.FormActivate(Sender: TObject);
  begin
    Notebook1.ActivePage := 'Table';
  end;

procedure TDBWorked.DataSource1DataChange(
    Sender: TObject;
    Field : TField);
  Var
    ss, s: string;
  begin
    Str(
        BDEItems1.RecordCount,
        s);
    Str(
        BDEItems1.RecNo,
        ss);
    RxLabel1.Caption := ss + ' : ' + s;
  end;

procedure TDBWorked.DataSource4DataChange(
    Sender: TObject;
    Field : TField);
  Var
    ss, s: string;
  begin
    Str(
        Qry.RecordCount,
        s);
    Str(
        Qry.RecNo,
        ss);
    RxLabel1.Caption := ss + ' : ' + s;
  end;

procedure TDBWorked.RxDBGrid2DrawColumnCell(
    Sender    : TObject;
    const Rect: TRect;
    DataCol   : Integer;
    Column    : TColumn;
    State     : TGridDrawState);
  begin
    if RxDBGrid2.Columns.Items[0].Fieldname = 'PICT' then
      begin
        DBImage.DrawCenter(
            RxDBGrid2.Canvas,
            Rect,
            0);
      end;
  end;

procedure TDBWorked.RxDBGrid1DrawColumnCell(
    Sender    : TObject;
    const Rect: TRect;
    DataCol   : Integer;
    Column    : TColumn;
    State     : TGridDrawState);
  var
    s, ss: string;
  begin
    if RxDBGrid1.Columns.Items[0].Fieldname = 'PICT' then
      begin
        TableImage.DrawCenter(
            RxDBGrid1.Canvas,
            Rect,
            2);
      end;
    if ((RxDBGrid1.Columns.Items[0].Fieldname = 'PICT') and
        (gdSelected in State)) then
      begin
        TableImage.DrawCenter(
            RxDBGrid1.Canvas,
            Rect,
            0);
      end;
  end;

procedure TDBWorked.RxDBGrid1Enter(Sender: TObject);
  Var
    ss, s: string;
  begin
    TableList.Active       := False;
    TableList.DatabaseName := BDEItems1.Fields[2].text;
    TableList.Active       := True;
    DBWorked.Caption       := BDEItems1.Fields[2].text;
    Str(
        BDEItems1.RecordCount,
        s);
    Str(
        BDEItems1.RecNo,
        ss);
    RxLabel1.Caption := ss + ':' + s;
  end;

procedure TDBWorked.Button1Click(Sender: TObject);
  begin
    Application.CreateForm(
        TSQLEditor,
        SQLEditor);
  end;

procedure TDBWorked.ComboBox1Change(Sender: TObject);
  begin
    Sort.Close;
    Sort.SQL.Clear;
    If RadioGroup1.ItemIndex = 0 then
      Sort.SQL.Add('Select * from ' + TableList.Fields[1].text + ' order by ' +
          ComboBox1.text + ' asc ');
    If RadioGroup1.ItemIndex = 1 then
      Sort.SQL.Add('Select * from ' + TableList.Fields[1].text + ' order by ' +
          ComboBox1.text + ' desc ');
    Sort.ExecSQL;
    RxDBGrid3.DataSource := DataSource5;
    Sort.Active          := True;
  end;

procedure TDBWorked.RadioGroup1Click(Sender: TObject);
  begin
    Sort.Close;
    Sort.SQL.Clear;
    If RadioGroup1.ItemIndex = 0 then
      Sort.SQL.Add('Select * from ' + TableList.Fields[1].text + ' order by ' +
          ComboBox1.text + ' asc ');
    If RadioGroup1.ItemIndex = 1 then
      Sort.SQL.Add('Select * from ' + TableList.Fields[1].text + ' order by ' +
          ComboBox1.text + ' desc ');
    Sort.ExecSQL;
    Sort.Active          := True;
    RxDBGrid3.DataSource := DataSource5;
  end;

procedure TDBWorked.DataSource5DataChange(
    Sender: TObject;
    Field : TField);
  Var
    ss, s: string;
  begin
    Str(
        Sort.RecordCount,
        s);
    Str(
        Sort.RecNo,
        ss);
    RxLabel1.Caption := ss + ' : ' + s;
  end;

procedure TDBWorked.DataSource3DataChange(
    Sender: TObject;
    Field : TField);
  Var
    ss, s: string;
  begin
    Str(
        Table1.RecordCount,
        s);
    Str(
        Table1.RecNo,
        ss);
    RxLabel1.Caption := ss + ' : ' + s;
  end;

procedure TDBWorked.RxDBGrid3DrawColumnCell(
    Sender    : TObject;
    const Rect: TRect;
    DataCol   : Integer;
    Column    : TColumn;
    State     : TGridDrawState);
  begin
    with RxDBGrid3.Canvas do
      begin
        if gdSelected in State then
          begin
            Brush.Color := clBlue;
            Font.Color  := clWhite;
          end;
        FillRect(Rect);
        TextOut(
            Rect.Left,
            Rect.Top,
            Column.Field.text);
      end;
  end;

procedure TDBWorked.Table1CalcFields(DataSet: TDataSet);
  begin
    showmessage('as');
  end;

end.
