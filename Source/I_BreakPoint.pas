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

unit I_BreakPoint;

interface

uses
  I_DebugThread, I_DebugModule;

type
  /// <summary>Source information of a breakpoint</summary>
  TBreakPointDetail = record
    /// <summary>The fully qualifified name of the method, as defined in the MAP file.
    /// This typically consists of ModuleName.ClassName.Methodname</summary>
    FullyQualifiedMethodName: string;
    /// <summary>The mapped / scoped name for documentation.</summary>
    MappedModuleName: string;
    /// <summary>The name of the module. This is the name of the unit (without .pas) where the binary code resides</summary>
    ModuleName: string;
    /// <summary>This is the name of the module where code is defined. UnitName w/o pas</summary>
    DefiningModule: string;
    /// <summary>This is the name of the unit (including .pas) where the class/method is defined.</summary>
    UnitName: string;
    /// <summary>This is the name of class that contains the procedure</summary>
    ClassName: string;
    /// <summary>The name of the method where this breakpoint is defined</summary>
    MethodName: string;
    /// <summary>The line of source code this breakpoint covers in the unit name.</summary>
    Line: Integer;
  end;

type
  /// <summary>
  /// Interface of a source code breakpoint.
  /// The debugger will halt on active breakpoints.
  /// </summary>
  IBreakPoint = interface
    ///<summary>Removes Breakpoint without updating the BreakCount.</summary>
    procedure Clear(const AThread: IDebugThread);
    /// <summary>Activate the breakpoint. The Debugger will halt when it is hit.</summary>
    function Activate: Boolean;
    /// <summary>Deactivate the breakpoint. The Debugger will no longer halt on this position. Warning! This method does not reset the instruction pointer.</summary>
    function DeActivate: Boolean;
    ///<summary>Hit the given Breakpoint. If the function returns true,
    /// the Breakpoint needs to be reactivated in the STATUS_SINGLE_STEP event.
    /// (Trap flag has been set.)</summary>
    function Hit(const AThread: IDebugThread): Boolean;
    /// <summary>Number of times the breakpoint was hit.</summary>
    function BreakCount:integer;
    /// <summary>The memory address of the breakpoint. This is a absolute address.</summary>
    function Address: Pointer;
    /// <summary>Module to which this breakpoint belongs.</summary>
    function Module: IDebugModule;
    /// <summary>Add the Source details for the coverage.</summary>
//    procedure AddDetails(
//      const AModuleName: string;
//      const AUnitName: string;
//      const ALineNumber: Integer);
    /// <summary>Get the source details for the given breakpoint.</summary>
    function Details: TBreakPointDetail;
    /// <summary>Convienience method that gives a nice string representation for logging.</summary>
    function DetailsToString: string;
    /// <summary>Is the breakpoint currently active.</summary>
    function IsActive: Boolean;
    /// <summary>Query if the breakpoint was hit at least once.</summary>
    function GetCovered: Boolean;
    property IsCovered: Boolean read GetCovered;
  end;


implementation

end.
