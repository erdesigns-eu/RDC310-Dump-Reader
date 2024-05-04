program DumpReader;

uses
  Vcl.Forms,
  untMain in 'untMain.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles,
  Radio.Dump.RCD310 in 'Radio.Dump.RCD310.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
