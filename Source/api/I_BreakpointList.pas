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

unit I_BreakPointList;

interface

uses
  I_BreakPoint,
  I_DebugModule;

type
  IBreakPointList = interface
    procedure Add(const ABreakPoint: IBreakPoint);

    procedure RemoveModuleBreakpoints(const AModule: IDebugModule);

    function Count: Integer;
    function GetBreakPoints:TArray<IBreakPoint>;

    function GetBreakPointByAddress(const AAddress: Pointer): IBreakPoint;
    property BreakPointByAddress[const AAddress: Pointer]: IBreakPoint read GetBreakPointByAddress;
  end;

implementation

end.
