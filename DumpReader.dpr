program DumpReader;

uses
  Vcl.Forms,
  untMain in 'untMain.pas' {frmMain},
  Radio.Dump.RCD310 in '..\Dump\Radio.Dump.RCD310.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
