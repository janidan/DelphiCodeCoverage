(***********************************************************************)
(* Delphi Code Coverage                                                *)
(*                                                                     *)
(* A quick hack of a Code Coverage Tool for Delphi                     *)
(* by Christer Fahlgren and Nick Ring                                  *)
(*                                                                     *) 
(* This Source Code Form is subject to the terms of the Mozilla Public *)
(* License, v. 2.0. If a copy of the MPL was not distributed with this *)
(* file, You can obtain one at http://mozilla.org/MPL/2.0/.            *)

unit I_BreakPoint;

interface

uses
  I_DebugThread, I_DebugModule;

type
  TBreakPointDetail = record
    ModuleName : string;
    UnitName   : string;
    Line       : Integer;
  end;

type
  IBreakPoint = interface
    procedure Clear(const AThread: IDebugThread);

    function Activate: Boolean;

    function DeActivate: Boolean;
    ///<summary>Hit the given Breakpoint. If the function returns true,
    /// the Breakpoint needs to be reactivated in the STATUS_SINGLE_STEP event.
    /// (Trap flag has been set.)</summary>
    function Hit(const AThread: IDebugThread): Boolean;
    function BreakCount:integer;

    procedure IncBreakCount;

    function Address: Pointer;
    function Module: IDebugModule;

    procedure AddDetails(
      const AModuleName: string;
      const AUnitName: string;
      const ALineNumber: Integer);

    function Details: TBreakPointDetail;
    function DetailsToString: string;

    function IsActive: Boolean;

    function GetCovered: Boolean;
    property IsCovered: Boolean read GetCovered;
  end;


implementation

end.
