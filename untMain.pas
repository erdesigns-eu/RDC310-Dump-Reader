//------------------------------------------------------------------------------
// UNIT           : untMain.pas
// CONTENTS       : Radio Code Dump calculator for VW/Skoda RCD310
// VERSION        : 1.0
// TARGET         : Embarcadero Delphi 11 or higher
// AUTHOR         : Ernst Reidinga (ERDesigns)
// STATUS         : Closed Source - Copyright © Ernst Reidinga
// COMPATIBILITY  : Windows 7, 8/8.1, 10, 11
// RELEASE DATE   : 04/05/2024
//------------------------------------------------------------------------------
unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

//------------------------------------------------------------------------------
// CLASSES
//------------------------------------------------------------------------------
type
  /// <summary>
  ///   Radio Dump Calculator Main Form
  /// </summary>
  TfrmMain = class(TForm)
    OpenDialog: TOpenDialog;
    pnlBottom: TPanel;
    bvPnlLine: TBevel;
    btnAbout: TButton;
    btnOpen: TButton;
    imgLogo: TImage;
    bvImageLine: TBevel;
    pnlSerialNumber: TPanel;
    lblSerialNumber: TLabel;
    edtSerialNumber: TEdit;
    pnlType: TPanel;
    lblType: TLabel;
    edtType: TEdit;
    pnlHardwareNumber: TPanel;
    lblHardwareNumber: TLabel;
    edtHardwareNumber: TEdit;
    pnlPartNumber: TPanel;
    lblPartNumber: TLabel;
    edtPartNumber: TEdit;
    pnlSoftwareNumber: TPanel;
    lblSoftwareNumber: TLabel;
    edtSoftwareNumber: TEdit;
    pnlRadioCode: TPanel;
    lblRadioCode: TLabel;
    edtRadioCode: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
  end;

var
  frmMain: TfrmMain;

implementation

uses Radio.Dump.RCD310;

{$R *.dfm}

//------------------------------------------------------------------------------
// FORM ON CREATE
//------------------------------------------------------------------------------
procedure TfrmMain.FormCreate(Sender: TObject);
const
  Title: string = 'RCD310 Dump Reader';
begin
  // Set the caption
  Caption := Title;
  // Set the application title
  Application.Title := Title;
  // Set the labels captions
  lblSerialNumber.Caption   := 'Serial Number:';
  lblPartNumber.Caption     := 'Part Number:';
  lblType.Caption           := 'Type:';
  lblHardwareNumber.Caption := 'HW Number:';
  lblSoftwareNumber.Caption := 'SN Number:';
  lblRadioCode.Caption      := 'Radio Code:';
  // Set the button captions
  btnOpen.Caption := 'Open..';
  btnAbout.Caption := 'About..';
end;

//------------------------------------------------------------------------------
// OPEN FILE AND READ DUMP
//------------------------------------------------------------------------------
procedure TfrmMain.btnOpenClick(Sender: TObject);
var
  Info: TRadioDumpInfo;
begin
  if OpenDialog.Execute(Handle) then
  begin
    // Read the dump
    Info := ReadRadioDump(OpenDialog.FileName);
    edtSerialNumber.Text   := Info.SN;
    edtPartNumber.Text     := Info.Part;
    edtType.Text           := Info.&Type;
    edtHardwareNumber.Text := Info.HW;
    edtSoftwareNumber.Text := Info.SW;
    edtRadioCode.Text      := Info.Code;
  end;
end;

//------------------------------------------------------------------------------
// SHOW ABOUT DIALOG
//------------------------------------------------------------------------------
procedure TfrmMain.btnAboutClick(Sender: TObject);
const
  AboutText: string =
    'Skoda Swing & VW RCD310 Dump Reader' + sLineBreak + sLineBreak +
    'by Ernst Reidinga - ERDesigns'       + sLineBreak +
    'Version 1.0 (05/2024)';
begin
  MessageBox(Handle, PChar(AboutText), PChar(Caption), MB_ICONINFORMATION + MB_OK);
end;

end.
