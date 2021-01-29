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
program CodeCoverage;
{$APPTYPE CONSOLE}

uses
  SysUtils,
  I_CoverageStats in 'api\I_CoverageStats.pas',
  I_Debugger in 'api\I_Debugger.pas',
  I_DebugProcess in 'api\I_DebugProcess.pas',
  I_DebugThread in 'api\I_DebugThread.pas',
  I_Logger in 'api\I_Logger.pas',
  I_LogManager in 'api\I_LogManager.pas',
  I_ParameterProvider in 'api\I_ParameterProvider.pas',
  I_Report in 'api\I_Report.pas',
  I_BreakPoint in 'api\I_BreakPoint.pas',
  I_BreakpointList in 'api\I_BreakpointList.pas',
  I_CoverageConfiguration in 'api\I_CoverageConfiguration.pas',
  I_DebugModule in 'api\I_DebugModule.pas',
  EmmaDataFile in 'reports\EmmaDataFile.pas',
  EmmaFileHelper in 'reports\EmmaFileHelper.pas',
  EmmaMergable in 'reports\EmmaMergable.pas',
  EmmaMetaData in 'reports\EmmaMetaData.pas',
  HTMLCoverageReport in 'reports\HTMLCoverageReport.pas',
  HtmlHelper in 'reports\HtmlHelper.pas',
  XMLCoverageReport in 'reports\XMLCoverageReport.pas',
  EmmaCoverageData in 'reports\EmmaCoverageData.pas',
  EmmaCoverageFileUnit in 'reports\EmmaCoverageFileUnit.pas',
  CoverageStats in 'core\CoverageStats.pas',
  Debugger in 'core\Debugger.pas',
  DebuggerUtils in 'core\DebuggerUtils.pas',
  DebugModule in 'core\DebugModule.pas',
  DebugProcess in 'core\DebugProcess.pas',
  DebugThread in 'core\DebugThread.pas',
  LoggerAPI in 'core\LoggerAPI.pas',
  LoggerConsole in 'core\LoggerConsole.pas',
  LoggerTextFile in 'core\LoggerTextFile.pas',
  LogManager in 'core\LogManager.pas',
  ModuleNameSpaceUnit in 'core\ModuleNameSpaceUnit.pas',
  uConsoleOutput in 'core\uConsoleOutput.pas',
  CommandLineProvider in 'core\CommandLineProvider.pas',
  CoverageConfiguration in 'core\CoverageConfiguration.pas',
  BreakPoint in 'core\BreakPoint.pas',
  BreakpointList in 'core\BreakpointList.pas',
  ClassInfoUnit in 'core\ClassInfoUnit.pas',
  JaCoCoXmlDataBinding in 'reports\JaCoCoXmlDataBinding.pas',
  JaCoCoCoverageReport in 'reports\JaCoCoCoverageReport.pas';

var
  // Delphi 7 leaks interfaces from here :-(
  ADebugger: TDebugger;
  {$define FullDebugMode}
begin
  try
    ADebugger := TDebugger.Create;
    try
      ADebugger.Start();
    finally
      ADebugger.Free;
    end;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.message);
  end;
end.

