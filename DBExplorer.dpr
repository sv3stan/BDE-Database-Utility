program DBExplorer;

uses
  Forms,
  Main in 'src\Main.pas' {SQLExplorer},
  SQLedit in 'src\SQLedit.pas' {SQLeditor},
  SQLView in 'src\SQLView.pas' {SQLviewer},
  DBWork in 'src\DBWork.pas' {DBWorked},
  SQLBuild in 'src\SQLBuild.pas' {SQLBuilder};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TSQLExplorer, SQLExplorer);
  Application.CreateForm(TSQLviewer, SQLviewer);
  Application.Run;
end.
