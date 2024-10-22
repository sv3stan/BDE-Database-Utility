unit Main;

interface

uses
  SQLBuild, DBWork, SQLView, SQLedit, Windows, Messages, SysUtils, Classes,
  Graphics,
  Controls, Forms, Dialogs, Db, DBTables, RxDBLISTS, BDE, StdCtrls, Grids,
  DBGrids, RXDBCtrl, Mask, RxToolEdit, RxCurrEdit, RXCtrls, RxLookup, RxDBIndex,
  RxDbPrgrss, RxHook, RxAppEvent, RxRichEd, RxDBRichEd, RxSpeedBar, ExtCtrls,
  DBCtrls,
  ComObj, OleCtnrs, DdeMan, ComCtrls, RXShell, RxPageMngr, RxMRUList, RxPicClip,
  Menus, RxMenus, Buttons;

type
  TSQLExplorer = class(TForm)
    SpeedBar1: TSpeedBar;
    SpeedbarSection1: TSpeedbarSection;
    SpeedbarSection3: TSpeedbarSection;
    SpeedItem1: TSpeedItem;
    SpeedItem2: TSpeedItem;
    SpeedItem3: TSpeedItem;
    SpeedItem4: TSpeedItem;
    SpeedItem8: TSpeedItem;
    DBEdit1: TDBEdit;
    DBImage: TPicClip;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    SpeedItem9: TSpeedItem;
    SaveDialog1: TSaveDialog;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    DBF1: TMenuItem;
    Table2: TTable;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    Timer1: TTimer;

    procedure Button1Click(Sender: TObject);
    procedure SpeedItem2Click(Sender: TObject);
    procedure SpeedItem4Click(Sender: TObject);
    procedure SpeedItem1Click(Sender: TObject);
    procedure RxDBGrid1DrawDataCell(
        Sender    : TObject;
        const rect: trect;
        Field     : TField;
        State     : TGridDrawState);
    procedure SpeedItem9Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);

  private
    { Private declarations }

  public
  end;

var
  SQLExplorer: TSQLExplorer;
  DBName     : string;

implementation

{$R *.DFM}

procedure TSQLExplorer.Button1Click(Sender: TObject);
  var
    h : HDBICur;
    ph: PHDBICur;
    s : string;
  begin
    s := DBName;
    ShowMessage(s);
    { Qry.Prepare;Check(dbiQExec(Qry.StmtHandle, ph));h := ph^;
      Check(DbiMakePermanent(h, Pchar(ExtractFilePath(Application.ExeName)+'qry.dbf'), True)); }
  end;

procedure TSQLExplorer.SpeedItem2Click(Sender: TObject);
  var
    EXCELApp, WorkBooks, Range, Cell1, Cell2, ArrayData, NewWorkBook: Variant;
    Obl: Variant;
    BeginCol, BeginRow, i, j: integer;
    RowCount, ColCount      : integer;
  begin
    dbworked.ProgressBar1.Min  := 0;
    dbworked.ProgressBar1.Max  := dbworked.Qry.RecordCount;
    dbworked.ProgressBar1.Step := dbworked.Qry.RecordCount div 200;
    SaveDialog1.FileName       := dbworked.TableList.Fields[1].Text + '_SQL';
    if SaveDialog1.Execute then
      begin
        { DBWorked.RxDBGrid4.DefaultDrawing:=False; }
        BeginCol := 1;
        BeginRow := 1;
        RowCount := dbworked.Qry.RecordCount + 1;
        ColCount := dbworked.Qry.FieldCount - 1;
        { ArrayData := VarArrayCreate([1, RowCount, 0, ColCount], varVariant); }
        EXCELApp         := CreateOleObject('EXCEL.Application');
        EXCELApp.Caption := 'DBExplorer';
        NewWorkBook      := EXCELApp.WorkBooks;
        WorkBooks        := NewWorkBook.Add();
        EXCELApp.Application.EnableEvents := false;
        for j             := 0 to ColCount do
          ArrayData[1, j] := dbworked.Qry.Fields[j].FieldName;

        dbworked.Qry.First;
        for i := 2 to RowCount do
          begin
            for j             := 0 to ColCount do
              ArrayData[i, j] := dbworked.Qry.Fields[j].Text;
            dbworked.ProgressBar1.Stepit;
            dbworked.Qry.Next;
          end;
        Cell1 := WorkBooks.WorkSheets[1].Cells[BeginRow, BeginCol];
        Cell2 := WorkBooks.WorkSheets[1].Cells[BeginRow + RowCount - 1,
            BeginCol + ColCount];
        Range       := WorkBooks.WorkSheets[1].Range[Cell1, Cell2];
        Range.Value := ArrayData;

        Obl           := WorkBooks.WorkSheets[1].Range[Cell1, Cell2];
        Obl.font.size := 8;
        Obl           := EXCELApp.Columns.Autofit;
        EXCELApp.ActiveWorkbook.SaveAS(SaveDialog1.FileName);
        EXCELApp.quit;
      end;
    { DBWorked.RxDBGrid4.DefaultDrawing:=True; }
  end;

procedure TSQLExplorer.SpeedItem4Click(Sender: TObject);
  var
    j, i: integer;
  begin
    for i := 0 to Table2.FieldCount - 1 do
      begin
        Table2.Fields[i].FieldName := ' ';
      end;
    with Table2 do
      begin
        Active       := false;
        DatabaseName := 'C:\DataWork';
        TableName    := 'QWE';
        TableType    := ttDBase;
        with FieldDefs do
          begin
            Clear;
            for i := 0 to SQLViewer.Qry.FieldCount - 1 do
              begin

                Add(
                    SQLViewer.Qry.Fields[i].FieldName,
                    SQLViewer.Qry.FieldDefs.Items[i].DataType,
                    SQLViewer.Qry.FieldDefs.Items[i].size,
                    True);
              end;
            Add(
                'Index',
                ftInteger,
                0,
                True);
          end;

        with IndexDefs do
          begin
            Clear;
            Add(
                '',
                'Index',
                [ixPrimary, ixUnique]);
          end;

        CreateTable;
      end;

    Table2.Active      := True;
    DBEdit1.DataSource := SQLViewer.DataSource1;
    for j              := 1 to SQLViewer.Qry.RecordCount + 1 do
      begin
        Table2.Append;
        for i := 0 to SQLViewer.Qry.FieldCount - 1 do
          begin
            DBEdit1.datafield := SQLViewer.Qry.Fields[i].FieldName;
            Table2.Fields.Fields[i].asstring := DBEdit1.Text;
          end;
        Table2.Fields.Fields[i].asinteger := j;
        SQLViewer.Qry.Next;
      end;
    Table2.Active := false;
  end;

procedure TSQLExplorer.SpeedItem1Click(Sender: TObject); { Открыть БД }
  begin
    Application.CreateForm(
        TDBWorked,
        dbworked);
  end;

procedure TSQLExplorer.RxDBGrid1DrawDataCell(
    Sender    : TObject;
    const rect: trect;
    Field     : TField;
    State     : TGridDrawState);
  begin
    { if RXDBGrid1.Columns.Items[7].Fieldname = 'PICT' then begin
      {  if Field.FieldName = 'PICT' then begin }
    ShowMessage('s');
    { if TableListVIEW.AsBoolean then I := 1 else I := 0; }
    { DbImage.DrawCenter(RXDBGrid1.Canvas, Rect, 0);
      end; }
  end;

procedure TSQLExplorer.SpeedItem9Click(Sender: TObject);
  begin
    Application.CreateForm(
        TSQLBuilder,
        SQLBuilder);
  end;

procedure TSQLExplorer.N7Click(Sender: TObject);
  begin
    cascade;
  end;

procedure TSQLExplorer.N11Click(Sender: TObject);
  begin
    Close;
  end;

procedure TSQLExplorer.BitBtn1Click(Sender: TObject);
  var
    s: string;
    i: integer;
  begin

    i := dbworked.ComponentIndex;
    str(
        i,
        s);
    ShowMessage(s);
    { Timer1.Enabled:=True; }

    { ProgressBar1.Max:=DBWorked.Qry.RecordCount; }

  end;

end.
