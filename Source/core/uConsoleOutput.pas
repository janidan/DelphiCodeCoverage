(***********************************************************************)
(* Delphi Code Coverage                                                *)
(*                                                                     *)
(* A quick hack of a Code Coverage Tool for Delphi                     *)
(* by Christer Fahlgren and Nick Ring                                  *)
(*                                                                     *) 
(* This Source Code Form is subject to the terms of the Mozilla Public *)
(* License, v. 2.0. If a copy of the MPL was not distributed with this *)
(* file, You can obtain one at http://mozilla.org/MPL/2.0/.            *)

unit UConsoleOutput;

interface

uses
  I_LogManager;

procedure ConsoleOutput(const AMessage: string);
procedure VerboseOutput(const AMessage: string);

var
  G_Verbose_Output: Boolean;

implementation

uses
  LogManager;

procedure Log(const AMessage: string);
begin
  G_LogManager.Log(AMessage);
end;

procedure ConsoleOutput(const AMessage: string);
begin
  {$IFNDEF CONSOLE_TESTRUNNER}
  if IsConsole then
  begin
    Writeln(AMessage);
  end;
  {$ENDIF}
  Log(AMessage);
end;

procedure VerboseOutput(const AMessage: string);
begin
  if G_Verbose_Output then
  begin
    ConsoleOutput(AMessage);
  end
  else
  begin
    Log(AMessage);
  end;
end;

initialization
  G_Verbose_Output := False;

end.
