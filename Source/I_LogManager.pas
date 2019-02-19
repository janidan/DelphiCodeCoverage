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

unit I_LogManager;

interface

uses
  I_Logger;

type
  ILogManager = interface
    procedure Log(const AMessage : string);

    procedure AddLogger(const ALogger : ILogger);
    /// <summary>Indent the output - for better reading an grouping.</summary>
    procedure Indent;
    /// <summary>Remove a indentation.</summary>
    procedure Undent;
  end;

function LastErrorInfo: string;

implementation

uses
  Windows,
  SysUtils;

function LastErrorInfo: string;
var
  LastError: DWORD;
begin
  LastError := GetLastError;
  Result := IntToStr(LastError) +
            '(' + IntToHex(LastError, 8) + ') -> ' +
            SysUtils.SysErrorMessage(LastError);
end;

end.
