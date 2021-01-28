(***********************************************************************)
(* Delphi Code Coverage                                                *)
(*                                                                     *)
(* A quick hack of a Code Coverage Tool for Delphi                     *)
(* by Christer Fahlgren and Nick Ring                                  *)
(*                                                                     *) 
(* This Source Code Form is subject to the terms of the Mozilla Public *)
(* License, v. 2.0. If a copy of the MPL was not distributed with this *)
(* file, You can obtain one at http://mozilla.org/MPL/2.0/.            *)
program CodeCoverageTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Classes,
  SysUtils,
  Windows,
  Forms,
  TestFramework,
  GUITestRunner,
  XmlTestRunner,
  StrUtilsD9 in '..\3rdParty\StrUtilsD9.pas',
  I_CoverageConfiguration in '..\Source\api\I_CoverageConfiguration.pas',
  I_CoverageStats in '..\Source\api\I_CoverageStats.pas',
  I_Debugger in '..\Source\api\I_Debugger.pas',
  I_DebugModule in '..\Source\api\I_DebugModule.pas',
  I_DebugProcess in '..\Source\api\I_DebugProcess.pas',
  I_DebugThread in '..\Source\api\I_DebugThread.pas',
  I_Logger in '..\Source\api\I_Logger.pas',
  I_LogManager in '..\Source\api\I_LogManager.pas',
  I_ParameterProvider in '..\Source\api\I_ParameterProvider.pas',
  I_Report in '..\Source\api\I_Report.pas',
  I_BreakPoint in '..\Source\api\I_BreakPoint.pas',
  I_BreakpointList in '..\Source\api\I_BreakpointList.pas',
  BreakpointList in '..\Source\core\BreakpointList.pas',
  ClassInfoUnit in '..\Source\core\ClassInfoUnit.pas',
  CommandLineProvider in '..\Source\core\CommandLineProvider.pas',
  CoverageConfiguration in '..\Source\core\CoverageConfiguration.pas',
  CoverageStats in '..\Source\core\CoverageStats.pas',
  Debugger in '..\Source\core\Debugger.pas',
  DebuggerUtils in '..\Source\core\DebuggerUtils.pas',
  DebugModule in '..\Source\core\DebugModule.pas',
  DebugProcess in '..\Source\core\DebugProcess.pas',
  DebugThread in '..\Source\core\DebugThread.pas',
  LoggerAPI in '..\Source\core\LoggerAPI.pas',
  LoggerConsole in '..\Source\core\LoggerConsole.pas',
  LoggerTextFile in '..\Source\core\LoggerTextFile.pas',
  LogManager in '..\Source\core\LogManager.pas',
  ModuleNameSpaceUnit in '..\Source\core\ModuleNameSpaceUnit.pas',
  uConsoleOutput in '..\Source\core\uConsoleOutput.pas',
  BreakPoint in '..\Source\core\BreakPoint.pas',
  EmmaCoverageFileUnit in '..\Source\reports\EmmaCoverageFileUnit.pas',
  EmmaDataFile in '..\Source\reports\EmmaDataFile.pas',
  EmmaFileHelper in '..\Source\reports\EmmaFileHelper.pas',
  EmmaMergable in '..\Source\reports\EmmaMergable.pas',
  EmmaMetaData in '..\Source\reports\EmmaMetaData.pas',
  HTMLCoverageReport in '..\Source\reports\HTMLCoverageReport.pas',
  HtmlHelper in '..\Source\reports\HtmlHelper.pas',
  XMLCoverageReport in '..\Source\reports\XMLCoverageReport.pas',
  EmmaCoverageData in '..\Source\reports\EmmaCoverageData.pas',
  CoverageConfigurationTest in 'CoverageConfigurationTest.pas',
  EmmaDataInputTests in 'EmmaDataInputTests.pas',
  EmmaDataOutputTests in 'EmmaDataOutputTests.pas',
  MockCommandLineProvider in 'MockCommandLineProvider.pas',
  StrUtilsD9Tests in 'StrUtilsD9Tests.pas',
  ClassInfoUnitTest in 'ClassInfoUnitTest.pas',
  JaCoCoCoverageReport in '..\Source\reports\JaCoCoCoverageReport.pas',
  JaCoCoXmlDataBinding in '..\Source\reports\JaCoCoXmlDataBinding.pas';

{$R *.RES}

begin
  try
    Application.Initialize;
    if IsConsole then
      XmlTestRunner.RunTestsAndClose
    else
      GUITestRunner.RunRegisteredTests;
  except
    on E: Exception do
    begin
      if IsConsole then
      begin
        writeln('Exception caught:');
        writeln(#9 + E.ClassName);
        writeln(#9 + E.Message);
      end
      else
      begin
        Application.MessageBox(PChar(E.ClassName +
                                     System.sLineBreak +
                                     E.Message),
                               'Exception Caught',
                               MB_ICONERROR or MB_OK);
      end;
    end;
  end;
end.
