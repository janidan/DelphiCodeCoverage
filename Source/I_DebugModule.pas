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

unit I_DebugModule;

interface

uses Windows, JCLDebug;

type
   IDebugModule = interface
     ///<summary>Name of the Module as given on Disk</summary>
     function Name: string;
     ///<summary>Handle to the phyical file on Disk</summary>
     function HFile: THandle;
     ///<summary>Address of the base address of the Dll in the process address space</summary>
     function Base: NativeUInt;
     ///<summary>Codesize of the Dll</summary>
     function Size: Cardinal;

     ///<summary>Begin addess of the Code section</summary>
     function CodeBegin: NativeUInt;
     ///<summary>End address of the Code section</summary>
     function CodeEnd: NativeUInt;

     ///<summary>Map file associated with the module. Returns nil if no map file is given</summary>
     function MapScanner: TJCLMapScanner;
  end;

implementation
end.
