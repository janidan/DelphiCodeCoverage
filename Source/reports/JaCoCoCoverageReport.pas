(***********************************************************************)
(* Delphi Code Coverage                                                *)
(*                                                                     *)
(* A quick hack of a Code Coverage Tool for Delphi                     *)
(* by Christer Fahlgren and Nick Ring                                  *)
(* JaCoCo implementation by Tobias Rörig                               *)
(*                                                                     *) 
(* This Source Code Form is subject to the terms of the Mozilla Public *)
(* License, v. 2.0. If a copy of the MPL was not distributed with this *)
(* file, You can obtain one at http://mozilla.org/MPL/2.0/.            *)

unit JaCoCoCoverageReport;

interface

uses
  I_Report,
  I_CoverageStats,
  JaCoCoXmlDataBinding,
  I_CoverageConfiguration,
  ClassInfoUnit,
  I_LogManager;

type
  TJaCoCoCoverageReport = class(TInterfacedObject, IReport)
  strict private
    FCoverageConfiguration: ICoverageConfiguration;

    procedure AddSessionInfo( const aElement: IXMLSessioninfoTypeList );
    procedure AddCounterData( const aElement: IXMLCounterTypeList; const aModuleInfoList: TModuleList; const ACoverage: ICoverageStats );
    procedure AddPackages( const aPackages: IXMLPackageTypeList; const aModuleInfoList: TModuleList; const ACoverage: ICoverageStats );
    procedure AddPackage( const aPackage: IXMLPackageType; const aModule: TModuleInfo; const ACoverage: ICoverageStats );
    procedure AddSourceFile ( const aSourceFile: IXMLSourcefileType; const aFileCoverage: ICoverageStats );
    procedure AddClass( const aClass: IXMLClassType; const aClassInfo: TClassInfo );
    procedure AddMethod( const aMethod: IXMLMethodType; aProcInfo: TProcedureInfo );
  public
    constructor Create(const ACoverageConfiguration: ICoverageConfiguration);

    procedure Generate(
      const ACoverage: ICoverageStats;
      const AModuleInfoList: TModuleList;
      const ALogManager: ILogManager);
  end;

implementation

uses
  System.SysUtils,
  JclFileUtils;

procedure TJaCoCoCoverageReport.AddClass(const aClass: IXMLClassType;
  const aClassInfo: TClassInfo);
var
  vCounter: IXMLCounterType;
begin
  aClass.Name := aClassInfo.TheClassName;
  aClass.Sourcefilename := aClassInfo.Module;

  for var vMeth in aClassInfo do
    AddMethod( aClass.Method.Add, vMeth );

  vCounter := aClass.Counter.Add;
  vCounter.Type_ := 'LINE';
  vCounter.Missed := IntToStr( aClassInfo.LineCount - aClassInfo.CoveredLineCount );
  vCounter.Covered := IntToStr( aClassInfo.CoveredLineCount );

  vCounter := aClass.Counter.Add;
  vCounter.Type_ := 'METHOD';
  vCounter.Missed := IntToStr( aClassInfo.ProcedureCount - aClassInfo.CoveredProcedureCount );
  vCounter.Covered := IntToStr( aClassInfo.CoveredProcedureCount );
end;

procedure TJaCoCoCoverageReport.AddCounterData(
  const aElement: IXMLCounterTypeList; const aModuleInfoList: TModuleList; const ACoverage: ICoverageStats);
var
  vCounter: IXMLCounterType;
begin
  vCounter := aElement.Add;
  vCounter.Type_ := 'LINE';
  vCounter.Missed := IntToStr( aModuleInfoList.LineCount - aModuleInfoList.CoveredLineCount );
  vCounter.Covered := IntToStr( aModuleInfoList.CoveredLineCount );

  vCounter := aElement.Add;
  vCounter.Type_ := 'METHOD';
  vCounter.Missed := IntToStr( aModuleInfoList.MethodCount - aModuleInfoList.CoveredMethodCount );
  vCounter.Covered := IntToStr( aModuleInfoList.CoveredMethodCount );

  vCounter := aElement.Add;
  vCounter.Type_ := 'CLASS';
  vCounter.Missed := IntToStr( aModuleInfoList.ClassCount - aModuleInfoList.CoveredClassCount );
  vCounter.Covered := IntToStr( aModuleInfoList.CoveredClassCount );
end;

procedure TJaCoCoCoverageReport.AddMethod(const aMethod: IXMLMethodType;
  aProcInfo: TProcedureInfo);
var
  vCounter: IXMLCounterType;
begin
  aMethod.Name := aProcInfo.Name;

  vCounter := aMethod.Add;
  vCounter.Type_ := 'LINE';
  vCounter.Missed := IntToStr( aProcInfo.LineCount - aProcInfo.CoveredLineCount );
  vCounter.Covered := IntToStr( aProcInfo.CoveredLineCount );
end;

procedure TJaCoCoCoverageReport.AddPackage(const aPackage: IXMLPackageType;
  const aModule: TModuleInfo; const ACoverage: ICoverageStats);
var
  vCounter: IXMLCounterType;
  vModuleCoverage: ICoverageStats;
begin
  aPackage.Name := aModule.ModuleName;
  for var vClass in aModule do
    AddClass( aPackage.Class_.Add, vClass );

  vCounter := aPackage.Counter.Add;
  vCounter.Type_ := 'LINE';
  vCounter.Missed := IntToStr( aModule.LineCount - aModule.CoveredLineCount );
  vCounter.Covered := IntToStr( aModule.CoveredLineCount );

  vCounter := aPackage.Counter.Add;
  vCounter.Type_ := 'METHOD';
  vCounter.Missed := IntToStr( aModule.MethodCount - aModule.CoveredMethodCount );
  vCounter.Covered := IntToStr( aModule.CoveredMethodCount );

  vCounter := aPackage.Counter.Add;
  vCounter.Type_ := 'CLASS';
  vCounter.Missed := IntToStr( aModule.ClassCount - aModule.CoveredClassCount );
  vCounter.Covered := IntToStr( aModule.CoveredClassCount );

  vModuleCoverage := ACoverage.GetCoverageReport( aModule.ModuleName );
  for var vSourceUnit: ICoverageStats in vModuleCoverage.GetCoverageReports do
    AddSourceFile( aPackage.Sourcefile.Add, vSourceUnit );
end;

procedure TJaCoCoCoverageReport.AddPackages(
  const aPackages: IXMLPackageTypeList; const aModuleInfoList: TModuleList; const ACoverage: ICoverageStats);
begin
  for var vModule in aModuleInfoList do
    AddPackage( aPackages.Add, vModule, ACoverage );
end;

procedure TJaCoCoCoverageReport.AddSessionInfo(
  const aElement: IXMLSessioninfoTypeList);
var
  vSessionInfo: IXMLSessioninfoType;
begin
  vSessionInfo := aElement.Add;

  vSessionInfo.Id := 'SessionId';
  vSessionInfo.Start := 'Start';
  vSessionInfo.Dump := 'Dump';
end;

procedure TJaCoCoCoverageReport.AddSourceFile(
  const aSourceFile: IXMLSourcefileType; const aFileCoverage: ICoverageStats);
var
  vSourceline: TCoverageLine;
  vXmlLine: IXMLLineType;
  vCounter: IXMLCounterType;
begin
  aSourceFile.Name := aFileCoverage.Name;
  for vSourceline in aFileCoverage.CoverageLines do
  begin
    vXmlLine := aSourceFile.Line.Add;
    vXmlLine.Nr := IntToStr( vSourceline.LineNumber );
    vXmlLine.Ci := IntToStr( vSourceline.LineCount );
  end;

  vCounter := aSourceFile.Counter.Add;
  vCounter.Type_ := 'LINE';
  vCounter.Missed := IntToStr( aFileCoverage.LineCount - aFileCoverage.CoveredLineCount );
  vCounter.Covered := IntToStr( aFileCoverage.CoveredLineCount );
end;

constructor TJaCoCoCoverageReport.Create(
  const ACoverageConfiguration: ICoverageConfiguration);
begin
  inherited Create;
  FCoverageConfiguration := ACoverageConfiguration;
end;

procedure TJaCoCoCoverageReport.Generate(
  const ACoverage: ICoverageStats;
  const AModuleInfoList: TModuleList;
  const ALogManager: ILogManager);

var
  vReport: IXMLReportType;
begin
  vReport := Newreport;
  vReport.Name := ACoverage.Name;
  //AddSessionInfo( vReport.Sessioninfo );
  AddCounterData( vReport.Counter, AModuleInfoList, ACoverage );
  AddPackages ( vReport.Package, AModuleInfoList, ACoverage );

  vReport.OwnerDocument.SaveToFile(
      PathAppend(FCoverageConfiguration.OutputDir, 'CodeCoverage_JaCoCo.xml')
    );
end;


end.
