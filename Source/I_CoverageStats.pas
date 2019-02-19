(***********************************************************************)
(* Delphi Code Coverage                                                *)
(*                                                                     *)
(* A quick hack of a Code Coverage Tool for Delphi                     *)
(* by Christer Fahlgren and Nick Ring                                  *)
(*                                                                     *) 
(* This Source Code Form is subject to the terms of the Mozilla Public *)
(* License, v. 2.0. If a copy of the MPL was not distributed with this *)
(* file, You can obtain one at http://mozilla.org/MPL/2.0/.            *)

unit I_CoverageStats;

interface

type
  TCoverageLine = record
    LineNumber: Integer;
    LineCount: Integer;
    function IsCovered: Boolean;
  end;

type
  ICoverageStats = interface
    // Statistics
    procedure Calculate;

    function CoveredLineCount: Integer;
    function LineCount: Integer;
    function PercentCovered: Integer;

    function Parent: ICoverageStats;
    function Count: Integer;

    function GetCoverageReportByIndex(const AIndex: Integer): ICoverageStats;
    property CoverageReport[const AIndex: Integer]: ICoverageStats read GetCoverageReportByIndex; default;

    function GetCoverageReportByName(const AName: string) : ICoverageStats;
    property CoverageReportByName[const AName: string]: ICoverageStats read GetCoverageReportByName;

    function ReportFileName: string;
    function Name: string;

    function GetCoverageLineCount: Integer;
    /// <summary>Returns a list of lines that have line information. Sorted by line numbers.</summary>
    function CoverageLines: TArray<TCoverageLine>;

    procedure AddLineCoverage(const ALineNumber: Integer; const ALineCount: Integer);
    /// <summary>Try to get coverage information.
    /// If the line number is known the out param will return the information and the result is true.
    /// </summary>
    function TryGetLineCoverage(const ALineNumber: Integer; out ACoverageLine: TCoverageLine) : Boolean;
  end;

implementation

function TCoverageLine.IsCovered: Boolean;
begin
  Result := LineCount > 0;
end;

end.
