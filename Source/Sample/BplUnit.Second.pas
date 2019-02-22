unit BplUnit.Second;

interface

type
  TSomeRecord = record
    class procedure DoSomethingInBplUnit2; static;
  end;

  TClassWithGenerics = class
    procedure SimpleGenericProc<T>;
    class procedure ClassProc<T>;
  end;

procedure DoSomethingInBpl2;

implementation

uses
  Vcl.Dialogs;

procedure DoSomethingInBpl2;
begin
  ShowMessage('DoSomethingInBplUnit2');
end;

{ TSomeRecord }

class procedure TSomeRecord.DoSomethingInBplUnit2;
begin
  DoSomethingInBpl2;
end;

{ TClassWithGenerics }

class procedure TClassWithGenerics.ClassProc<T>;
begin
  //
end;

procedure TClassWithGenerics.SimpleGenericProc<T>;
begin
  //
end;

initialization

finalization
end.
