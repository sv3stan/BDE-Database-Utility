unit SQLBuild;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TSQLBuilder = class(TForm)
    Panel1: TPanel;
    procedure FormClose(
        Sender    : TObject;
        var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SQLBuilder: TSQLBuilder;

implementation

{$R *.DFM}

procedure TSQLBuilder.FormClose(
    Sender    : TObject;
    var Action: TCloseAction);
  begin
    Action := caFree;
  end;

end.
