unit BplUnit;

interface

type
  TSimpleClass = class
    procedure SimpleProc;
    constructor Create;
    destructor Destroy; override;
  end;

  TSimpleClassMeth = class
    class procedure ClassProc;

    class constructor Create;
    class destructor Destroy;
  end;

  TSimpleGeneric<T> = class
    procedure SimpleProc;
    class procedure ClassProc;
  end;

  TSimpleClassWithGeneric = class
    procedure SimpleProc<T>;
    class procedure ClassProc<T>;
  end;

  TAnonMethRef = reference to procedure;

  TAnonymousMeth = class
    class procedure ClassProcAnon;
  end;

  TMetaAttribute = class (TCustomAttribute);

  [TMeta]
  TMetaAttClass = class
   [TMeta]
   procedure SimpleProc;
  end;

procedure DoSomethingInBpl;

implementation

uses
  Vcl.Dialogs;

procedure DoSomethingInBpl;
begin
  ShowMessage('DoSomethingInBpl');
end;

{ TSimpleClass }

constructor TSimpleClass.Create;
begin
  //
end;

destructor TSimpleClass.Destroy;
begin
  //
end;

procedure TSimpleClass.SimpleProc;
begin
  //
end;

{ TSimpleClassMeth }

class procedure TSimpleClassMeth.ClassProc;
begin
  //
end;

class constructor TSimpleClassMeth.Create;
begin
  //
end;

class destructor TSimpleClassMeth.Destroy;
begin
  //
end;

{ TSimpleGeneric<T> }

class procedure TSimpleGeneric<T>.ClassProc;
begin
  //
end;

procedure TSimpleGeneric<T>.SimpleProc;
begin
  //
end;

{ TSimpleClassWithGeneric }

class procedure TSimpleClassWithGeneric.ClassProc<T>;
begin
  //
end;

procedure TSimpleClassWithGeneric.SimpleProc<T>;
begin
  //
end;

{ TAnonymousMeth }

class procedure TAnonymousMeth.ClassProcAnon;
var
  a : TAnonMethRef;
begin
  a := procedure
       begin
         //
       end;
end;

{ TMetaAttClass }

procedure TMetaAttClass.SimpleProc;
begin
  //
end;

initialization

finalization

end.
