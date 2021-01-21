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

unit ClassInfoUnit;

interface

uses
  Generics.Collections,
  I_BreakPoint,
  I_DebugModule,
  I_LogManager;

type
  TSimpleBreakPointList = class(TList<IBreakPoint>)
  private
    FLine: Integer;
  public
    constructor Create(const aLine: Integer);
    procedure RemoveBreakPointsForModule(const ABinaryModule: IDebugModule);

    property Line: Integer read FLine;
  end;

  TProcedureInfo = class(TEnumerable<Integer>)
  private
    FName: String;
    FLines: TDictionary <Integer, TSimpleBreakPointList> ;
    function IsCovered(const ABreakPointList: TSimpleBreakPointList): Boolean;
    procedure ClearLines;

    function GetName: string;
  protected
    function DoGetEnumerator: TEnumerator<Integer>; override;
  public
    const BodySuffix = '$Body';

    function LineCount: Integer;
    function CoveredLineCount: Integer;
    function PercentCovered: Integer;

    property Name: string read GetName;

    constructor Create(const AName: string);
    destructor Destroy; override;
    procedure AddBreakPoint(
      const ALineNo: Integer;
      const ABreakPoint: IBreakPoint);
    function IsLineCovered(const ALineNo: Integer): Boolean;

    procedure HandleBreakPoint(const ABreakPoint: IBreakPoint);
    procedure RemoveBreakPointsForModule(const ABinaryModule: IDebugModule);
  end;

  TClassInfo = class(TEnumerable<TProcedureInfo>)
  strict private
    FModule: String;
    FName: String;
    FProcedures: TDictionary<string, TProcedureInfo>;
    procedure ClearProcedures;

    function GetProcedureCount: Integer;
    function GetCoveredProcedureCount: Integer;
    function GetModule: string;
    function GetClassName: string;

    function GetIsCovered: Boolean;
  protected
    function DoGetEnumerator: TEnumerator<TProcedureInfo>; override;
  public
    property ProcedureCount: Integer read GetProcedureCount;
    property CoveredProcedureCount: Integer read GetCoveredProcedureCount;
    property Module: string read GetModule;
    property TheClassName: string read GetClassName;
    property IsCovered: Boolean read GetIsCovered;

    function LineCount: Integer;
    function CoveredLineCount: Integer;
    function PercentCovered: Integer;

    constructor Create(
      const AModuleName: string;
      const AClassName: string);
    destructor Destroy; override;
    function EnsureProcedure(const AProcedureName: string): TProcedureInfo;
    procedure HandleBreakPoint(const ABreakPoint: IBreakPoint);
    procedure RemoveBreakPointsForModule(const ABinaryModule: IDebugModule);
  end;

  TModuleInfo = class(TEnumerable<TClassInfo>)
  strict private
    FName: string;
    FFileName: string;
    FClasses: TDictionary<string, TClassInfo>;
    FBinaryModule: IDebugModule;
    function GetModuleName: string;
    function GetModuleFileName: string;
    function GetClassCount: Integer;
    function GetCoveredClassCount: Integer;
    function GetMethodCount: Integer;
    function GetCoveredMethodCount: Integer;
  protected
    function DoGetEnumerator: TEnumerator<TClassInfo>; override;
  public
    property BinaryModule: IDebugModule read FBinaryModule;
    property ModuleName: string read GetModuleName;
    property ModuleFileName: string read GetModuleFileName;

    property ClassCount: Integer read GetClassCount;
    property CoveredClassCount: Integer read GetCoveredClassCount;

    property MethodCount: Integer read GetMethodCount;
    property CoveredMethodCount: Integer read GetCoveredMethodCount;

    function LineCount: Integer;
    function CoveredLineCount: Integer;

    constructor Create(
     const ABinaryModule: IDebugModule;
     const AModuleName: string;
     const AModuleFileName: string);
    destructor Destroy; override;

    function ToString: string; override;

    function EnsureClassInfo(
      const AModuleName: string;
      const AClassName: string): TClassInfo;
    procedure ClearClasses;

    procedure HandleBreakPoint(const ABreakPoint: IBreakPoint);
    procedure RemoveBreakPointsForModule(const ABinaryModule: IDebugModule);
  end;

  TModuleList = class(TEnumerable<TModuleInfo>)
  strict private
    FModules: TDictionary<string, TModuleInfo>;
    procedure ClearModules;
    function GetCount: Integer;
    function GetTotalClassCount: Integer;
    function GetTotalCoveredClassCount: Integer;
    function GetTotalMethodCount: Integer;
    function GetTotalCoveredMethodCount: Integer;
    function GetTotalLineCount: Integer;
    function GetTotalCoveredLineCount: Integer;
  protected
    function DoGetEnumerator: TEnumerator<TModuleInfo>; override;
  public
    property Count: Integer read GetCount;

    property ClassCount: Integer read GetTotalClassCount;
    property CoveredClassCount: Integer read GetTotalCoveredClassCount;

    property MethodCount: Integer read GetTotalMethodCount;
    property CoveredMethodCount: Integer read GetTotalCoveredMethodCount;

    property LineCount: Integer read GetTotalLineCount;
    property CoveredLineCount: Integer read GetTotalCoveredLineCount;

    constructor Create;
    destructor Destroy; override;

    function EnsureModuleInfo(
      const ABinaryModule: IDebugModule;
      const AModuleName: string;
      const AModuleFileName: string): TModuleInfo;


    procedure HandleBreakPoint(const ABreakPoint: IBreakPoint; const ALogManager: ILogManager);
    procedure RemoveBreakPointsForModule(const ABinaryModule: IDebugModule);
  end;

implementation

uses
  Types,
  SysUtils,
  StrUtils,
  Math,
  {$IF CompilerVersion < 21}
  StrUtilsD9,
  {$IFEND}
  Classes,
  I_CoverageConfiguration,
  uConsoleOutput;

{$region 'TModuleList'}
constructor TModuleList.Create;
begin
  inherited Create;
  FModules := TDictionary<string, TModuleInfo>.Create;
end;

destructor TModuleList.Destroy;
begin
  ClearModules;
  FModules.Free;

  inherited Destroy;
end;

procedure TModuleList.ClearModules;
var
  Key: string;
begin
  for Key in FModules.Keys do
  begin
    FModules[Key].Free;
  end;
end;

function TModuleList.GetCount: Integer;
begin
  Result := FModules.Count;
end;

function TModuleList.DoGetEnumerator: TEnumerator<TModuleInfo>;
begin
  Result := FModules.Values.GetEnumerator;
end;

function TModuleList.GetTotalClassCount: Integer;
var
  CurrentModuleInfo: TModuleInfo;
begin
  Result := 0;
  for CurrentModuleInfo in FModules.Values do
  begin
    Inc(Result, CurrentModuleInfo.ClassCount);
  end;
end;

function TModuleList.GetTotalCoveredClassCount: Integer;
var
  CurrentModuleInfo: TModuleInfo;
begin
  Result := 0;
  for CurrentModuleInfo in FModules.Values do
  begin
    Inc(Result, CurrentModuleInfo.CoveredClassCount);
  end;
end;

function TModuleList.GetTotalMethodCount: Integer;
var
  CurrentModuleInfo: TModuleInfo;
begin
  Result := 0;
  for CurrentModuleInfo in FModules.Values do
  begin
    Inc(Result, CurrentModuleInfo.MethodCount);
  end;
end;

function TModuleList.GetTotalCoveredMethodCount: Integer;
var
  CurrentModuleInfo: TModuleInfo;
begin
  Result := 0;
  for CurrentModuleInfo in FModules.Values do
  begin
    Inc(Result, CurrentModuleInfo.CoveredMethodCount);
  end;
end;

function TModuleList.GetTotalLineCount: Integer;
var
  CurrentModuleInfo: TModuleInfo;
begin
  Result := 0;
  for CurrentModuleInfo in FModules.Values do
  begin
    Inc(Result, CurrentModuleInfo.LineCount);
  end;
end;

function TModuleList.GetTotalCoveredLineCount(): Integer;
var
  CurrentModuleInfo: TModuleInfo;
begin
  Result := 0;
  for CurrentModuleInfo in FModules.Values do
  begin
    Inc(Result, CurrentModuleInfo.CoveredLineCount);
  end;
end;

function TModuleList.EnsureModuleInfo( const ABinaryModule: IDebugModule;
  const AModuleName: string;
  const AModuleFileName: string): TModuleInfo;
begin
  if not FModules.TryGetValue(AModuleName, Result) then
  begin
    Result := TModuleInfo.Create(ABinaryModule, AModuleName, AModuleFileName);
    FModules.Add(AModuleName, Result);
  end;
end;

procedure TModuleList.HandleBreakPoint(
  const ABreakPoint: IBreakPoint;
  const ALogManager: ILogManager);
var
  BreakpointDetails: TBreakPointDetail;
  ClsInfo: TClassInfo;
  ProcInfo: TProcedureInfo;
  Module: TModuleInfo;
begin
  BreakpointDetails := ABreakPoint.Details;

  ALogManager.Log('Adding breakpoint for ' + BreakpointDetails.FullyQualifiedMethodName + ' in ' + ABreakPoint.Module.Name);
  ALogManager.Indent;
  Module := EnsureModuleInfo(ABreakPoint.Module, BreakpointDetails.DefiningModule, BreakpointDetails.UnitName );
  Module.HandleBreakPoint(ABreakPoint);
  ALogManager.Undent;
end;

procedure TModuleList.RemoveBreakPointsForModule(const ABinaryModule: IDebugModule);
var
  CurrentModuleInfo: TModuleInfo;
begin
  for CurrentModuleInfo in FModules.Values.ToArray do
  begin
    G_LogManager.Indent;
    CurrentModuleInfo.RemoveBreakPointsForModule(ABinaryModule);
    G_LogManager.Undent;
    if (CurrentModuleInfo.ClassCount = 0) then
    begin
      FModules.Remove( CurrentModuleInfo.ModuleName );
      CurrentModuleInfo.Free;
    end;
  end;
end;

{$endregion 'TModuleList'}

{$region 'TModuleInfo'}

constructor TModuleInfo.Create(
  const ABinaryModule: IDebugModule;
  const AModuleName: string;
  const AModuleFileName: string);
begin
  inherited Create;

  FBinaryModule := ABinaryModule;
  FName := AModuleName;
  FFileName := AModuleFileName;
  FClasses := TDictionary<string, TClassInfo>.Create;
  G_LogManager.LogFmt('Adding ModuleInfo for %s, %s in %s ',[ABinaryModule.Name, AModuleName, AModuleFileName]);
end;

destructor TModuleInfo.Destroy;
begin
  G_LogManager.LogFmt('Destroying ModuleInfo for %s, %s in %s ',[FBinaryModule.Name, FName, FFileName]);
  G_LogManager.Indent;
  ClearClasses;
  FClasses.Free;
  G_LogManager.Undent;

  inherited Destroy;
end;

procedure TModuleInfo.ClearClasses;
var
  Key: string;
begin
  for Key in FClasses.Keys do
  begin
    FClasses[Key].Free;
  end;
end;

function TModuleInfo.ToString: string;
begin
  Result := 'ModuleInfo[ modulename=' + FName + ', filename=' + FFileName + ' ]';
end;

function TModuleInfo.GetModuleName: string;
begin
  Result := FName;
end;

procedure TModuleInfo.HandleBreakPoint(const ABreakPoint: IBreakPoint);
var
  BreakpointDetails: TBreakPointDetail;
  ClsInfo: TClassInfo;
  ProcInfo: TProcedureInfo;
  Module: TModuleInfo;
begin
  BreakpointDetails := ABreakPoint.Details;
  G_LogManager.LogFmt('Adding breakpoint to module %s ', [BreakpointDetails.ModuleName]);
  G_LogManager.Indent;
  ClsInfo := EnsureClassInfo(BreakpointDetails.ModuleName, BreakpointDetails.ClassName);
  ClsInfo.HandleBreakPoint(ABreakPoint);
  G_LogManager.Undent;
end;

function TModuleInfo.GetModuleFileName: string;
begin
  Result := FFileName;
end;

function TModuleInfo.EnsureClassInfo(
  const AModuleName: string;
  const AClassName: string): TClassInfo;
begin
  if not FClasses.TryGetValue(AClassName, Result) then
  begin
    Result := TClassInfo.Create(AModuleName, AClassName);
    FClasses.Add(AClassName, Result);
  end;
end;

function TModuleInfo.GetClassCount: Integer;
begin
  Result := FClasses.Count;
end;

function TModuleInfo.DoGetEnumerator: TEnumerator<TClassInfo>;
begin
  Result := FClasses.Values.GetEnumerator;
end;

function TModuleInfo.GetCoveredClassCount: Integer;
var
  CurrentClassInfo: TClassInfo;
begin
  Result := 0;
  for CurrentClassInfo in FClasses.Values do
  begin
    Inc(Result, IfThen(CurrentClassInfo.IsCovered, 1, 0));
  end;
end;

function TModuleInfo.GetMethodCount: Integer;
var
  CurrentClassInfo: TClassInfo;
begin
  Result := 0;
  for CurrentClassInfo in FClasses.Values do
  begin
    Inc(Result, CurrentClassInfo.ProcedureCount);
  end;
end;

function TModuleInfo.GetCoveredMethodCount: Integer;
var
  CurrentClassInfo: TClassInfo;
begin
  Result := 0;
  for CurrentClassInfo in FClasses.Values do
  begin
    Inc(Result, CurrentClassInfo.CoveredProcedureCount);
  end;
end;

function TModuleInfo.LineCount: Integer;
var
  CurrentClassInfo: TClassInfo;
begin
  Result := 0;
  for CurrentClassInfo in FClasses.Values do
  begin
    Inc(Result, CurrentClassInfo.LineCount);
  end;
end;

procedure TModuleInfo.RemoveBreakPointsForModule(const ABinaryModule: IDebugModule);
var
  CurrentClassInfo: TClassInfo;
begin
  for CurrentClassInfo in FClasses.Values.ToArray do
  begin
    G_LogManager.Indent;
    CurrentClassInfo.RemoveBreakPointsForModule(ABinaryModule);
    G_LogManager.Undent;
    if (CurrentClassInfo.ProcedureCount = 0) then
    begin
      FClasses.Remove( CurrentClassInfo.TheClassName );
      CurrentClassInfo.Free;
    end;
  end;
end;

function TModuleInfo.CoveredLineCount: Integer;
var
  CurrentClassInfo: TClassInfo;
begin
  Result := 0;
  for CurrentClassInfo in FClasses.Values do
  begin
    Inc(Result, CurrentClassInfo.CoveredLineCount);
  end;
end;
{$endregion 'TModuleInfo'}

{$region 'TClassInfo'}
constructor TClassInfo.Create(const AModuleName: string; const AClassName: string);
begin
  inherited Create;

  FModule := AModuleName;
  FName := AClassName;
  FProcedures := TDictionary<string, TProcedureInfo>.Create;
  G_LogManager.LogFmt('Creating ClassInfo for %s in %s ',[FName, FModule]);
end;

destructor TClassInfo.Destroy;
begin
  G_LogManager.LogFmt('Destroying ClassInfo for %s in %s ',[FName, FModule]);
  G_LogManager.Indent;
  ClearProcedures;
  FProcedures.Free;
  G_LogManager.Undent;

  inherited Destroy;
end;

function TClassInfo.DoGetEnumerator: TEnumerator<TProcedureInfo>;
begin
  Result := FProcedures.Values.GetEnumerator;
end;

procedure TClassInfo.ClearProcedures;
var
  Key: string;
begin
  for Key in FProcedures.Keys do
  begin
    FProcedures[Key].Free;
  end;
end;

function TClassInfo.EnsureProcedure(const AProcedureName: string): TProcedureInfo;
begin
  if not FProcedures.TryGetValue(AProcedureName, Result) then
  begin
    Result := TProcedureInfo.Create(AProcedureName);
    FProcedures.Add(AProcedureName, Result);
  end;
end;

function TClassInfo.PercentCovered: Integer;
var
  Total: Integer;
  Covered: Integer;
  CurrentInfo: TProcedureInfo;
begin
  Total := 0;
  Covered := 0;

  for CurrentInfo in FProcedures.Values do
  begin
    Total := Total + CurrentInfo.LineCount;
    Covered := Covered + CurrentInfo.CoveredLineCount;
  end;

  Result := Covered * 100 div Total;
end;

procedure TClassInfo.RemoveBreakPointsForModule(const ABinaryModule: IDebugModule);
var
  CurrentInfo: TProcedureInfo;
begin
  for CurrentInfo in FProcedures.Values.ToArray do
  begin
    G_LogManager.Indent;
    CurrentInfo.RemoveBreakPointsForModule(ABinaryModule);
    G_LogManager.Undent;
    if (CurrentInfo.LineCount = 0) then
    begin
      FProcedures.Remove( CurrentInfo.Name );
      CurrentInfo.Free;
    end;
  end;
end;

function TClassInfo.GetModule: string;
begin
  Result := FModule;
end;

function TClassInfo.GetClassName: string;
begin
  Result := FName;
end;

function TClassInfo.GetProcedureCount: Integer;
begin
  Result := FProcedures.Count;
end;

procedure TClassInfo.HandleBreakPoint(const ABreakPoint: IBreakPoint);
var
  BreakpointDetails: TBreakPointDetail;
  ClsInfo: TClassInfo;
  ProcInfo: TProcedureInfo;
  Module: TModuleInfo;
begin
  BreakpointDetails := ABreakPoint.Details;
  G_LogManager.LogFmt('Adding breakpoint to class %s ', [BreakpointDetails.ClassName]);
  G_LogManager.Indent;
  ProcInfo := EnsureProcedure(BreakpointDetails.MethodName);
  ProcInfo.HandleBreakPoint(ABreakPoint);
  G_LogManager.Undent;
end;

function TClassInfo.GetCoveredProcedureCount: Integer;
var
  CurrentProcedureInfo: TProcedureInfo;
begin
  Result := 0;

  for CurrentProcedureInfo in FProcedures.Values do
  begin
    if CurrentProcedureInfo.CoveredLineCount > 0 then
    begin
      Inc(Result);
    end;
  end;
end;

function TClassInfo.LineCount: Integer;
var
  CurrentProcedureInfo: TProcedureInfo;
begin
  Result := 0;
  for CurrentProcedureInfo in FProcedures.Values do
  begin
    Inc(Result, CurrentProcedureInfo.LineCount);
  end;
end;

function TClassInfo.CoveredLineCount: Integer;
var
  CurrentProcedureInfo: TProcedureInfo;
begin
  Result := 0;
  for CurrentProcedureInfo in FProcedures.Values do
  begin
    Inc(Result, CurrentProcedureInfo.CoveredLineCount);
  end;
end;

function TClassInfo.GetIsCovered: Boolean;
begin
  Result := CoveredLineCount > 0;
end;
{$endregion 'TClassInfo'}

{$region 'TProcedureInfo'}
constructor TProcedureInfo.Create(const AName: string);
begin
  inherited Create;

  FName := AName;
  FLines := TDictionary<Integer, TSimpleBreakPointList>.Create;
  G_LogManager.LogFmt('Creating ProcedureInfo for %s',[FName]);
end;

destructor TProcedureInfo.Destroy;
begin
  G_LogManager.LogFmt('Destroying ProcedureInfo for %s',[FName]);
  G_LogManager.Indent;
  ClearLines;
  FLines.Free;
  G_LogManager.Undent;
  inherited Destroy;
end;

function TProcedureInfo.DoGetEnumerator: TEnumerator<Integer>;
begin
  Result := FLines.Keys.GetEnumerator;
end;

procedure TProcedureInfo.ClearLines;
var
  I: Integer;
begin
  for I in FLines.Keys do
  begin
    FLines[I].Free;
  end;
end;

procedure TProcedureInfo.AddBreakPoint(
  const ALineNo: Integer;
  const ABreakPoint: IBreakPoint);
var
  BreakPointList: TSimpleBreakPointList;
begin
  if not (FLines.TryGetValue(ALineNo, BreakPointList)) then
  begin
    BreakPointList := TSimpleBreakPointList.Create(ALineNo);
    FLines.Add(ALineNo, BreakPointList);
  end;
  G_LogManager.Log('Adding Breakpoint to ProcedureInfo: ' + ABreakPoint.DetailsToString);
  BreakPointList.Add(ABreakPoint);
end;

function TProcedureInfo.LineCount: Integer;
begin
  Result := FLines.Keys.Count;
end;

function TProcedureInfo.CoveredLineCount: Integer;
var
  I: Integer;
  BreakPointList: TSimpleBreakPointList;
begin
  Result := 0;
  for I in FLines.Keys do
  begin
    BreakPointList := FLines[I];
    if IsCovered(BreakPointList) then
    begin
      Inc(Result);
    end;
  end;
end;

function TProcedureInfo.IsCovered(const ABreakPointList: TSimpleBreakPointList): Boolean;
var
  CurrentBreakPoint: IBreakPoint;
begin
  Result := False;
  for CurrentBreakPoint in ABreakPointList do
  begin
    if CurrentBreakPoint.IsCovered then
    begin
      Exit(True);
    end;
  end;
end;

function TProcedureInfo.IsLineCovered(const ALineNo: Integer): Boolean;
var
  BreakPointList: TSimpleBreakPointList;
begin
  Result := false;
  if FLines.TryGetValue(ALineNo, BreakPointList) then
  begin
    Result := IsCovered(BreakPointList);
  end;
end;

function TProcedureInfo.PercentCovered: Integer;
begin
  Result := (100 * CoveredLineCount) div LineCount;
end;

procedure TProcedureInfo.RemoveBreakPointsForModule(const ABinaryModule: IDebugModule);
var
  BreakPointList: TSimpleBreakPointList;
begin
  for BreakPointList in FLines.Values.ToArray do
  begin
    G_LogManager.Indent;
    BreakPointList.RemoveBreakPointsForModule(ABinaryModule);
    G_LogManager.Undent;
    if (BreakPointList.Count = 0) then
    begin
      FLines.Remove(BreakPointList.Line);
      BreakPointList.Free;
    end;
  end;
end;

function TProcedureInfo.GetName: string;
begin
  Result := FName;
end;
procedure TProcedureInfo.HandleBreakPoint(const ABreakPoint: IBreakPoint);
begin
  G_LogManager.Indent;
  AddBreakPoint(ABreakPoint.Details.Line, ABreakPoint);
  G_LogManager.Undent;
end;

{$endregion 'TProcedureInfo'}

{ TSimpleBreakPointList }

constructor TSimpleBreakPointList.Create(const aLine: Integer);
begin
  inherited Create;
  FLine := aLine;
end;

procedure TSimpleBreakPointList.RemoveBreakPointsForModule(const ABinaryModule: IDebugModule);
var
  BreakPoint: IBreakPoint;
begin
  for BreakPoint in ToArray do
    if (BreakPoint.Module = ABinaryModule) then
      Remove( BreakPoint );
end;


end.
