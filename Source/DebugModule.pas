(***********************************************************************)
(* Delphi Code Coverage                                                *)
(*                                                                     *)
(* A quick hack of a Code Coverage Tool for Delphi                     *)
(* by Christer Fahlgren and Nick Ring                                  *)
(* Portions by Tobias R�rig                                            *)
(*                                                                     *) 
(* This Source Code Form is subject to the terms of the Mozilla Public *)
(* License, v. 2.0. If a copy of the MPL was not distributed with this *)
(* file, You can obtain one at http://mozilla.org/MPL/2.0/.            *)

unit DebugModule;

interface

uses
  Classes,
  I_DebugModule,
  JCLDebug;

type
  TDebugModule = class(TInterfacedObject, IDebugModule)
  strict private
    FName: String;
    FHFile: THandle;
    FBase: NativeUInt;
    FSize: Cardinal;
    FCodeBegin: NativeUInt;
    FCodeEnd: NativeUInt;
    FMapScanner: TJCLMapScanner;

    function Name: string;
    function HFile: THandle;
    function Base: NativeUInt;
    function Size: Cardinal;
    function CodeBegin: NativeUInt;
    function CodeEnd: NativeUInt;
    function MapScanner: TJCLMapScanner;
  public
    constructor Create(
      const AName: string;
      const AHFile: THandle;
      const ABase: NativeUInt;
      const ASize: Cardinal;
      const AMapScanner: TJCLMapScanner);
    destructor Destroy; override;
    procedure AfterConstruction; override;
  end;

implementation

uses
  System.SysUtils,
  Winapi.Windows,
  JclPEImage,
  UConsoleOutput,
  DebuggerUtils;

function TDebugModule.CodeBegin: NativeUInt;
begin
  Result := FCodeBegin;
end;

function TDebugModule.CodeEnd: NativeUInt;
begin
  Result := FCodeEnd;
end;

constructor TDebugModule.Create(
      const AName: string;
      const AHFile: THandle;
      const ABase: NativeUInt;
      const ASize: Cardinal;
      const AMapScanner: TJCLMapScanner);
begin
  inherited Create;
  FName := AName;
  FHFile:= AHFile;
  FBase := ABase;
  FSize := ASize;
  FMapScanner := AMapScanner;
end;

destructor TDebugModule.Destroy;
begin
  G_LogManager.LogFmt('Destroying Module for %s at %s with %d bytes - Code in [%s - %s]',
    [FName, AddressToString(FBase), FSize, AddressToString(FCodeBegin), AddressToString(FCodeEnd)]);
  inherited Destroy;
end;

function TDebugModule.HFile: THandle;
begin
  Result:= FHFile;
end;

function TDebugModule.Name: string;
begin
  Result := FName;
end;

procedure TDebugModule.AfterConstruction;
var
  PEImage: TJCLPEImage;
  vSectionHeader: TImageSectionHeader;
  vSectionNumber: Integer;
begin
  inherited AfterConstruction;
  PEImage := TJCLPEImage.Create;
  try
    PEImage.FileName := FName;

    // Code section
    // we may have several sections containing code, so we will iterate and take
    // the lowest given address will be our code begin and the highest the end.
    // Typical samples would be .text and .itext sections
    FCodeBegin := NativeUInt.MaxValue;
    FCodeEnd := 0;
    for vSectionNumber := 0 to PEImage.ImageSectionCount-1 do
    begin
      vSectionHeader := PEImage.ImageSectionHeaders[vSectionNumber];
      if ((vSectionHeader.Characteristics and IMAGE_SCN_CNT_CODE) <> 0) then
      begin
        FCodeBegin := Min(FBase + vSectionHeader.VirtualAddress, FCodeBegin);
        FCodeEnd := Max(FBase + vSectionHeader.VirtualAddress + vSectionHeader.Misc.VirtualSize, FCodeEnd);
      end;
    end;

    if (FCodeEnd = 0) then // This should not happen - but we will set the header data for the first section
    begin
      {$IF Defined(WIN32)}
      FCodeBegin := FBase + PEImage.OptionalHeader32.BaseOfCode;
      FCodeEnd := FCodeBegin + PEImage.OptionalHeader32.SizeOfCode;
      {$ELSEIF Defined(WIN64)}
      FCodeBegin := FBase + PEImage.OptionalHeader64.BaseOfCode;
      FCodeEnd := FCodeBegin + PEImage.OptionalHeader64.SizeOfCode;
      {$ELSE}
        {$MESSAGE FATAL 'Unsupported Platform'}
      {$ENDIF}
    end;
  finally
    PEImage.Free;
  end;
  G_LogManager.LogFmt('Adding Module for %s at %s with %d bytes - Code in [%s - %s]',
    [FName, AddressToString(FBase), FSize, AddressToString(FCodeBegin), AddressToString(FCodeEnd)]);
end;

function TDebugModule.Base: NativeUInt;
begin
  Result := FBase;
end;

function TDebugModule.Size: Cardinal;
begin
  Result := FSize;
end;

function TDebugModule.MapScanner: TJCLMapScanner;
begin
  Result := FMapScanner;
end;

end.
