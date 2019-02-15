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
  Winapi.Windows;

function AddressToString(const address:Pointer): string; overload;
function AddressToString(const address:NativeUInt): string; overload;
function AddressToString(const address:UInt32): string; overload;
function AddressToString(const address:UInt64): string; overload;

function VAFromAddress(const AAddr: Pointer; const AAddressCodebase: NativeUInt): DWORD; inline;
function AddressFromVA(const AVA: DWORD; const AAddressCodebase: NativeUInt): Pointer; inline;

implementation

uses
  System.SysUtils;

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


end.
