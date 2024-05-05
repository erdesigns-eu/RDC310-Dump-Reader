//------------------------------------------------------------------------------
// PROJECT        : RCD310 Dump Reader
// VERSION        : 1.0
// AUTHOR         : Ernst Reidinga (ERDesigns)
// STATUS         : Open Source - Copyright © Ernst Reidinga
// COMPATIBILITY  : Windows 7, 8/8.1, 10, 11
// CREATED DATE   : 05/05/2024
//------------------------------------------------------------------------------

program DumpReader;

uses
  Vcl.Forms,
  WinApi.Windows,
  untMain in 'untMain.pas' {frmMain},
  Radio.Dump.RCD310 in 'Radio.Dump.RCD310.pas';

{$R *.res}

const
  Title: string = 'RCD310 Dump Reader';

const
  WorksWith: string =
    'This application works with dumps from the following radios:' + sLineBreak + sLineBreak +

    'Skoda Swing (Delphi)'                                         + sLineBreak +
    'Serial starts with: SKZ4Z2'                                   + sLineBreak +
    'Part numbers: 1Z0035161, 3T0035161, 5J0035161'                + sLineBreak + sLineBreak +

    'VW RCD310 (Delphi)'                                           + sLineBreak +
    'Serial starts with: VWZ4Z2'                                   + sLineBreak +
    'Part numbers: 1Z0035161, 1K0035186'                           + sLineBreak + sLineBreak +

    'VW RCD310 (Delphi)'                                           + sLineBreak +
    'Serial starts with: VWZ4Z6'                                   + sLineBreak +
    'Part numbers: 1K0035164, 5N0035164';

begin
  // Set the application title
  Application.Title := Title;
  // Show message indicating what dumps this software works with
  MessageBox(Application.Handle, PChar(WorksWith), PChar(Application.Title), MB_ICONINFORMATION + MB_OK);
  // Initialize the application
  Application.Initialize;
  // Show the mainform on the taskbar
  Application.MainFormOnTaskbar := True;
  // Create the mainform
  Application.CreateForm(TfrmMain, frmMain);
  // Run the application
  Application.Run;
end.
