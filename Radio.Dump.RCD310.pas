//------------------------------------------------------------------------------
// UNIT           : Radio.Dump.RCD310.pas
// CONTENTS       : Radio Code Dump calculator for VW/Skoda RCD310
// VERSION        : 1.0
// TARGET         : Embarcadero Delphi 11 or higher
// AUTHOR         : Ernst Reidinga (ERDesigns)
// STATUS         : Open Source - Copyright © Ernst Reidinga
// COMPATIBILITY  : Windows 7, 8/8.1, 10, 11
// RELEASE DATE   : 05/05/2024
//------------------------------------------------------------------------------
unit Radio.Dump.RCD310;

interface

//------------------------------------------------------------------------------
// RECORDS
//------------------------------------------------------------------------------
type
  /// <summary>
  ///   Radio Dump Info
  /// </summary>
  TRadioDumpInfo = record
    /// <summary>
    ///   Software version
    /// </summary>
    SW: string;
    /// <summary>
    ///   Hardware version
    /// </summary>
    HW: string;
    /// <summary>
    ///   Serial Number
    /// </summary>
    SN: string;
    /// <summary>
    ///   Type description
    /// </summary>
    &Type: string;
    /// <summary>
    ///   Part number
    /// </summary>
    Part: string;
    /// <summary>
    ///   Radio code
    /// </summary>
    Code: string;
  end;

function ReadRadioDump(const Filename: string): TRadioDumpInfo;

implementation

uses System.Classes, System.SysUtils;

//------------------------------------------------------------------------------
// READ RADIO DUMP INFO
//------------------------------------------------------------------------------
function ReadRadioDump(const Filename: string): TRadioDumpInfo;

  function ReadAnsi(Stream: TStream; Position: Int64; Count: Int64): string;
  var
    Buffer: array of AnsiChar;
  begin
    // Set the length of the buffer to the expected length
    SetLength(Buffer, Count);
    // Set the position to start reading from
    Stream.Position := Position;
    // Read the stream into the buffer
    Stream.Read(Buffer[0], Count);
    // Set the output string from the buffer
    SetString(Result, PAnsiChar(@Buffer[0]), Count);
  end;

  function ReadAnsiEndsWith(Stream: TStream; Position: Int64; EndsWith: string): string;
  var
    Buffer: AnsiChar;
    EndsWithLen: Integer;
  begin
    // Set the position to start reading from
    Stream.Position := Position;
    // Clear the result string
    Result := '';
    // Set the length of the expected 'EndsWith' substring
    EndsWithLen := Length(EndsWith);

    // Loop over the stream from the start position
    while Stream.Position < Stream.Size do
    begin
      // Read a byte into the buffer
      Stream.Read(Buffer, 1);
      // Add the byte to the result string
      Result := Result + String(Buffer);

      // Check if the current string ends with the specified substring
      if Result.EndsWith(EndsWith) then
      begin
        // Trim off the 'EndsWith' substring
        SetLength(Result, Length(Result) - EndsWithLen);
        // Break the loop
        Break;
      end;
    end;
  end;

  function ReadAndXOR(Stream: TFileStream; StartPos: Integer; ByteCount: Integer; XORValue: Integer): string;
  var
    Bytes: array of Byte;
    Digit: Byte;
    S: string;
    I: Integer;
    HexValue: Integer;
  begin
    // Set the position to start reading from
    Stream.Position := StartPos;
    // Set the length of the buffer
    SetLength(Bytes, ByteCount);
    // Read the bytes into the buffer
    Stream.Read(Bytes[0], Length(Bytes));

    // Clear the temporary string
    S := '';
    // Extract the second hex digit of each byte
    for I := 0 to High(Bytes) do
    begin
      // Extract the lower nibble of the byte (which is the second hex digit)
      Digit := Bytes[I] and $0F;
      // Add the byte to the temporary string
      S := S + IntToHex(Digit, 1);
    end;

    // Convert result string from hex to integer
    HexValue := StrToInt('$' + S);

    // XOR with XORValue
    HexValue := HexValue xor XORValue;

    // Convert back to hex and return the result
    Result := IntToHex(HexValue, 4);
  end;

var
  FileStream: TFileStream;
begin
  // Create a filestream from the Dump file
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    // Read Software Version
    Result.SW := ReadAnsi(FileStream, 169, 4);
    // Read Hardware Version
    Result.HW := ReadAnsi(FileStream, 253, 3);
    // Read Serial Number
    Result.SN := ReadAnsi(FileStream, 215, 14);
    // Read Type Description until double space
    Result.&Type := ReadAnsiEndsWith(FileStream, 240, '  ');
    // Read Part Number
    Result.Part := ReadAnsi(FileStream, 229, 9);
    // Read the security code
    Result.Code := ReadAndXOR(FileStream, 160, 4, $5555);
  finally
    // Free the filestream
    FileStream.Free;
  end;
end;

end.
