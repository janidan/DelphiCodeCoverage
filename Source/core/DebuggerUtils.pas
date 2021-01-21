(***********************************************************************)
(* Delphi Code Coverage                                                *)
(*                                                                     *)
(* A quick hack of a Code Coverage Tool for Delphi                     *)
(* by Christer Fahlgren and Nick Ring                                  *)
(* Portions by Tobias Rörig                                            *)
(*                                                                     *)
(* This Source Code Form is subject to the terms of the Mozilla Public *)
(* License, v. 2.0. If a copy of the MPL was not distributed with this *)
(* file, You can obtain one at http://mozilla.org/MPL/2.0/.            *)
unit DebuggerUtils;

interface

uses
  Winapi.Windows,
  I_BreakPoint;

function AddressToString(const address:Pointer): string; overload;
function AddressToString(const address:NativeUInt): string; overload;
function AddressToString(const address:UInt32): string; overload;
function AddressToString(const address:UInt64): string; overload;

function VAFromAddress(const AAddr: Pointer; const AAddressCodebase: NativeUInt): DWORD; inline;
function AddressFromVA(const AVA: DWORD; const AAddressCodebase: NativeUInt): Pointer; inline;

function GetDllName(const aProcessHandle: THandle; const lpBaseOfDll: Pointer): string;

function Min(a, b: NativeUInt): NativeUInt;
function Max(a, b: NativeUInt): NativeUInt;

type
  TBreakPointDetailHelper = record helper for TBreakPointDetail
    procedure ParseFullyQualifiedName;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.IOUtils,
  System.Classes,
  Winapi.PsAPI,
  I_CoverageConfiguration;

function AddressToString(const address:Pointer): string;
begin
  // Respect the internal/native Bitness of the pointer
  Result := IntToHex(NativeUInt(address));
end;

function AddressToString(const address:NativeUInt): string; overload;
begin
  // Respect the internal/native Bitness of the pointer
  Result := IntToHex(address);
end;

function AddressToString(const address:UInt32): string; overload;
begin
  Result := IntToHex(address, 8);
end;

function AddressToString(const address:UInt64): string; overload;
begin
  Result := IntToHex(address, 16);
end;

function VAFromAddress(const AAddr: Pointer;  const AAddressCodebase: NativeUInt): DWORD; inline;
begin
  Result := NativeUInt(AAddr) - AAddressCodebase;
end;

function AddressFromVA(const AVA: DWORD;  const AAddressCodebase: NativeUInt): Pointer; inline;
begin
  Result := Pointer(NativeUInt(AVA + AAddressCodebase));
end;

function ExpandVolumeName(const AFileName: string): string;
var
  LogicalDrives: TArray<string>;
  Drive: string;
  DeviceDrive: string;

  TempVolumeName: array[0..MAX_PATH + 1] of Char;
  TempVolumeNameLength: DWORD;
  VolumeName: string;
begin
  LogicalDrives:= TDirectory.GetLogicalDrives;
  for Drive in LogicalDrives do
  begin
    DeviceDrive := Copy(Drive,1,2); // remove the tailing Backslash for the QueryDosDevice API call
    TempVolumeNameLength := QueryDosDevice(PChar(DeviceDrive), TempVolumeName, MAX_PATH);
    if TempVolumeNameLength > 0 then
    begin
      VolumeName := TempVolumeName;
      if Pos(VolumeName, AFileName) > 0 then
      begin
        TempVolumeNameLength := Length(VolumeName);
        Result := DeviceDrive + Copy(AFileName, TempVolumeNameLength + 1, DWORD(Length(AFileName)) - TempVolumeNameLength);
        Break;
      end;
    end;
  end;
end;

function GetDllName(const aProcessHandle: THandle; const lpBaseOfDll: Pointer): string;
var
  MappedName: array [0..MAX_PATH + 1] of Char;
begin
  Result := '';
  if GetMappedFileName(aProcessHandle, lpBaseOfDll, @MappedName[0], MAX_PATH) > 0 then
    Result := ExpandVolumeName(MappedName);
end;

function Min(a, b: NativeUInt): NativeUInt;
begin
  Result := a;
  if Result > b then
    Result := b;
end;

function Max(a, b: NativeUInt): NativeUInt;
begin
  Result := a;
  if Result < b then
    Result := b;
end;

{ TBreakPointDetailHelper }

procedure TBreakPointDetailHelper.ParseFullyQualifiedName;
var
//  List: TStrings;
//  ClassName: string;
//  ProcedureName: string;
  I: Integer;
//  ClassProcName: string;
//  UnitNameNoExt:string;
begin
  // The typical form of this is ModuleName( typically unit without extention).ClassName.Methodname
  // Note that the unitname and the modulename may differ.
  // Also not that generics may have dotted namespaces. example:
  // ClassInfoUnit.{System.Generics.Collections}TList<ClassInfoUnit.TModuleInfo>.Add
  // Exception to this is the intialization section of a unit e.g.
  // BplUnit.BplUnit -> initialization section
  // BplUnit.Second.BplUnit.Second
  if (FullyQualifiedMethodName = ModuleName + '.' + ModuleName) then
  begin
    ClassName := 'Unit';
    MethodName := 'Initialization';
  end else
  begin
    I := LastDelimiter('.', FullyQualifiedMethodName);
    MethodName := Copy(FullyQualifiedMethodName, i + 1,Length(FullyQualifiedMethodName) - i);
    ClassName := Copy(FullyQualifiedMethodName,
                      Length(ModuleName) + 2 {dot and firstletter},
                      i - Length(ModuleName) - 2 {dot and firstletter});
  end;

  // Exceptions that we also cover:
  // BplUnit.DoSomethingInBpl -> Method declared in a unit
  // BplUnit.Finalization -> Finalization section
  // After the above parsing the classname is empty. We will bind it to the "unit" class
  if (ClassName = '') then
    ClassName := 'Unit';

  // Generic classes -> Handled correctly above
  // mainForm..{BplUnit}TSimpleGeneric<System.Byte>
  // mainForm.{BplUnit}TSimpleGeneric<System.Byte>.ClassProc
  // mainForm.{BplUnit}TSimpleGeneric<System.Byte>.SimpleProc

  // Line numbers of Generic types refer to the defining pas file.
  // Where as the address referrs to this module.
  // e.g. mainForm.{BplUnit}TSimpleGeneric<System.Byte>.ClassProc
  // Line numbers for mainForm(BplUnit.pas) segment .text
  // 92 0001:00001C78    94 0001:00001C7F
  DefiningModule := ModuleName;
  if G_CoverageConfiguration.UseDefiningModuleForCoverage then
    DefiningModule := ChangeFileExt(UnitName,'');

  // Class constructors + Destructor suffix is @ -> they are correctly handled above
  // BplUnit.TSimpleClass.Create@
  // BplUnit.TSimpleClass.Destroy@



  // Intialization reads nicer and more intuative
  //if (MethodName = UnitNameNoExt) then
  //  MethodName := 'initialization';

//  List := TStringList.Create;
//  try
//    ClassProcName := RightStr(BreakpointDetails.ProcName, Length(BreakpointDetails.ProcName) - (Length(BreakpointDetails.ModuleName) + 1));
//    // detect module initialization section
//    if ClassProcName = BreakpointDetails.ModuleName then
//      ClassProcName := 'Initialization';
//
//    if EndsStr(TProcedureInfo.BodySuffix, ClassProcName) then
//      ClassProcName := LeftStr(ClassProcName, Length(ClassProcName) - Length(TProcedureInfo.BodySuffix));
//
//    ExtractStrings(['.'], [], PWideChar(ClassProcName), List);
//    if List.Count > 0 then
//    begin
//      ProcedureNameParts := SplitString(List[List.Count - 1], '$');
//      ProcedureName := ProcedureNameParts[0];
//
//      if List.Count > 2 then
//      begin
//        ClassName := '';
//        for I := 0 to List.Count - 2 do
//          ClassName := IfThen(ClassName = '', '', ClassName + '.') + List[I];
//      end
//      else
//      begin
//        if SameText(List[0], 'finalization') or SameText(List[0], 'initialization') then
//          ClassName := StringReplace(BreakpointDetails.ModuleName, '.', '_', [rfReplaceAll])
//        else
//          ClassName := List[0];
//      end;
//    end;
//  finally
//    List.Free;
//  end;
end;

end.
