unit SQLView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, RXDBCtrl, DBTables, Db, RXCtrls, StdCtrls,
  RxDBIndex, RxDBFilter, RxQuery, RxDBComb, ComCtrls, RxPlacemnt;

type
  TSQLviewer = class(TForm)
    RxDBGrid1: TRxDBGrid;
    DataSource1: TDataSource;
    Table1: TTable;
    DataSource2: TDataSource;
    FormStorage1: TFormStorage;
    qry: TRxQuery;
    StatusBar1: TStatusBar;
    procedure FormResize(Sender: TObject);
    procedure RxDBGrid1MouseDown(
        Sender: TObject;
        Button: TMouseButton;
        Shift : TShiftState;
        X, Y  : Integer);
    procedure RxDBGrid1KeyUp(
        Sender : TObject;
        var Key: Word;
        Shift  : TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SQLviewer: TSQLviewer;

implementation

uses SQLedit;

{$R *.DFM}

procedure TSQLviewer.FormResize(Sender: TObject);
  begin
    RxDBGrid1.Width  := SQLviewer.Width - 10;
    RxDBGrid1.Height := SQLviewer.Height - 74;

  end;

procedure TSQLviewer.RxDBGrid1MouseDown(
    Sender: TObject;
    Button: TMouseButton;
    Shift : TShiftState;
    X, Y  : Integer);
  var
    s, ss, sss: string;
  begin
    str(
        qry.recordCount,
        s);
    str(
        qry.recno,
        ss);
    sss := RxDBGrid1.SelectedField.FieldName;

    StatusBar1.SimpleText  := sss + ' : ' + s + ' : ' + ss;
    StatusBar1.SimplePanel := true;
  end;

procedure TSQLviewer.RxDBGrid1KeyUp(
    Sender : TObject;
    var Key: Word;
    Shift  : TShiftState);
  var
    s, ss: string;
  begin
    str(
        qry.recordCount,
        s);
    str(
        qry.recno,
        ss);
    StatusBar1.SimpleText  := s + ' : ' + ss;
    StatusBar1.SimplePanel := true;
  end;

end.
