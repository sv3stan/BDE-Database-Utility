unit SQLedit;

interface

uses
  SQLView, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls, RxRichEd, RXCtrls, ComCtrls, ExtCtrls;

type
  TSQLeditor = class(TForm)
    RxRichEdit1: TRxRichEdit;
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    RxSpeedButton2: TRxSpeedButton;
    RxSpeedButton3: TRxSpeedButton;
    RxSpeedButton1: TRxSpeedButton;
    procedure RxSpeedButton1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
    procedure RxSpeedButton3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(
        Sender    : TObject;
        var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SQLeditor: TSQLeditor;

implementation

{ uses Unit1; }

{$R *.DFM}

procedure TSQLeditor.RxSpeedButton1Click(Sender: TObject);
  var
    s, ss: string;
  begin
    if SqlViewer.Visible = true then
      SqlViewer.close;

    Application.CreateForm(
        TSQLViewer,
        SqlViewer);
    SqlViewer.Visible := true;

    with SqlViewer do
      begin
        qry.close;
        qry.SQL.Clear;
        qry.SQL := RxRichEdit1.lines;
        qry.ExecSQL;
        qry.Active := true;
        str(
            qry.recordCount,
            s);
        str(
            qry.recno,
            ss);
        StatusBar1.SimpleText  := s + ' : ' + ss;
        StatusBar1.SimplePanel := true;
        RxDBGrid1.DataSource   := DataSource1;

      end;
  end;

procedure TSQLeditor.FormResize(Sender: TObject);
  begin
    RxRichEdit1.Width  := SQLeditor.Width - 10;
    RxRichEdit1.Height := SQLeditor.Height - 80;
  end;

procedure TSQLeditor.RxSpeedButton2Click(Sender: TObject);
  var
    s: string;
  begin
    if OpenDialog1.Execute then
      begin
        RxRichEdit1.lines.LoadFromFile(OpenDialog1.FileName);
        StatusBar1.SimpleText  := ExtractFileName(OpenDialog1.FileName);
        StatusBar1.SimplePanel := true;
      end;
  end;

procedure TSQLeditor.RxSpeedButton3Click(Sender: TObject);
  begin
    if SaveDialog1.Execute then
      RxRichEdit1.lines.SaveToFile(SaveDialog1.FileName);
  end;

procedure TSQLeditor.FormActivate(Sender: TObject);
  begin
    Height  := 150;
    Width   := 400;
    Visible := true;

  end;

procedure TSQLeditor.FormClose(
    Sender    : TObject;
    var Action: TCloseAction);
  begin
    Action := caFree;
  end;

end.
