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

unit BreakPoint;

interface

uses
  Classes,
  I_BreakPoint,
  I_DebugThread,
  I_DebugProcess,
  I_DebugModule,
  I_LogManager;

type
  TBreakPoint = class(TInterfacedObject, IBreakPoint)
  strict private
    FOld_Opcode: Byte;
    FActive: Boolean;
    FAddress: Pointer;
    FBreakCount: integer;
    FProcess: IDebugProcess;
    FModule: IDebugModule;
    FDetails: TBreakPointDetail;
    FLogManager: ILogManager;

    procedure InternalClear(const AThread: IDebugThread; const aSetTrapFlag: Boolean);

    function DeActivate: Boolean;
    function Hit(const AThread: IDebugThread): Boolean;

    procedure Clear(const AThread: IDebugThread);

    procedure AddDetails(const AModuleName: string;
                         const AUnitName: string;
                         const ALineNumber: Integer);

    function Details: TBreakPointDetail;
    function DetailsToString: string;

    function IsActive: Boolean;

    function BreakCount: integer;
    procedure IncBreakCount;

    function Activate: Boolean;
    function Address: Pointer;
    function Module: IDebugModule;

    function GetCovered: Boolean;
  public
    constructor Create(const ADebugProcess: IDebugProcess;
                       const AAddress: Pointer;
                       const AModule: IDebugModule;
                       const ALogManager: ILogManager);
    procedure BeforeDestruction; override;
  end;

implementation

uses
  SysUtils,
  Windows,
  CoverageConfiguration,
  DebuggerUtils;

constructor TBreakPoint.Create(const ADebugProcess: IDebugProcess;
                               const AAddress: Pointer;
                               const AModule: IDebugModule;
                               const ALogManager: ILogManager);
begin
  inherited Create;

  FAddress := AAddress;
  FProcess := ADebugProcess;
  FActive := False;
  FBreakCount := 0;
  FModule := AModule;

  FLogManager := ALogManager;
end;

function TBreakPoint.Activate: Boolean;
var
  OpCode : Byte;
  BytesRead: DWORD;
  BytesWritten: DWORD;
begin
  Result := FActive;
  if not Result then
  begin
    BytesRead := FProcess.ReadProcessMemory(FAddress, @FOld_Opcode, 1, true);
    if BytesRead = 1 then
    begin
      OpCode := $CC;
      BytesWritten := FProcess.WriteProcessMemory(FAddress, @OpCode, 1, true);
      FlushInstructionCache(FProcess.Handle, FAddress, 1);
      if BytesWritten = 1 then
      begin
        FLogManager.Log('Activating ' + DetailsToString);
        FActive := True;
        Result  := True;
      end;
    end;
  end;
end;

function TBreakPoint.DeActivate: Boolean;
var
  BytesWritten: DWORD;
begin
  Result := not FActive;

  if not Result then
  begin
    BytesWritten := FProcess.writeProcessMemory(FAddress, @FOld_Opcode, 1,true);
    FlushInstructionCache(FProcess.Handle,FAddress,1);
    FLogManager.Log('Deactivating Breakpoint: ' + DetailsToString);
    Result  := (BytesWritten = 1);
    FActive := False;
  end;
end;

function TBreakPoint.Details: TBreakPointDetail;
begin
  Result := FDetails;
end;

function TBreakPoint.DetailsToString: string;
begin
  Result := Format('Breakpoint at %s: %s[%d]',[
            AddressToString(FAddress), FDetails.ModuleName, FDetails.Line ]);
end;

procedure TBreakPoint.AddDetails(const AModuleName: string;
                                 const AUnitName: string;
                                 const ALineNumber: Integer);
begin
  FDetails.ModuleName := AModuleName;
  FDetails.UnitName := AUnitName;
  FDetails.Line := ALineNumber;
end;

procedure TBreakPoint.Clear(const AThread: IDebugThread);
begin
  InternalClear(AThread, False);
end;

function TBreakPoint.IsActive: Boolean;
begin
  Result := FActive;
end;

function TBreakPoint.Address: Pointer;
begin
  Result := FAddress;
end;

function TBreakPoint.Module: IDebugModule;
begin
  Result := FModule;
end;

procedure TBreakPoint.BeforeDestruction;
begin
  FLogManager.Log('Destroying ' + DetailsToString + ' Hitcount: ' + IntToStr(FBreakCount));
  inherited BeforeDestruction;
end;

function TBreakPoint.BreakCount: Integer;
begin
  Result := FBreakCount;
end;

procedure TBreakPoint.IncBreakCount;
begin
  Inc(FBreakCount);
end;

procedure TBreakPoint.InternalClear(const AThread: IDebugThread; const aSetTrapFlag: Boolean);
const
  CONTEXT_FLAG_TRAP = $100;
var
  ContextRecord: CONTEXT;
  Result: BOOL;
begin
  FLogManager.Log('Clearing ' + DetailsToString + ' Hitcount: ' + IntToStr(FBreakCount));

  ContextRecord.ContextFlags := CONTEXT_CONTROL;
  Result := GetThreadContext(AThread.Handle, ContextRecord);
  if Result then
  begin
    DeActivate; // If aSetTrapFlag -> reenabled in the STATUS_SINGLE_STEP debugger event
    // Rewind to previous instruction
    {$IF Defined(CPUX64)}
    Dec(ContextRecord.Rip);
    {$ELSEIF Defined(CPUX86)}
    Dec(ContextRecord.Eip);
    {$ELSE}
      {$MESSAGE FATAL 'Unsupported Platform'}
    {$ENDIF}
    ContextRecord.ContextFlags := CONTEXT_CONTROL;
    if aSetTrapFlag then // Set TF (Trap Flag so we get debug exception after next instruction
      ContextRecord.EFlags := ContextRecord.EFlags or CONTEXT_FLAG_TRAP;
    Result := SetThreadContext(AThread.Handle, ContextRecord);
    if (not Result) then
      FLogManager.Log('Failed setting thread context:' + I_LogManager.LastErrorInfo);
  end
  else
    FLogManager.Log('Failed to get thread context   ' + I_LogManager.LastErrorInfo);
end;

function TBreakPoint.GetCovered: Boolean;
begin
  Result := FBreakCount > 0;
end;

function TBreakPoint.Hit(const AThread: IDebugThread): Boolean;
begin
  IncBreakCount;
  Result := BreakCount < G_CoverageConfiguration.LineCountLimit;
  InternalClear(AThread, Result);
end;

end.
