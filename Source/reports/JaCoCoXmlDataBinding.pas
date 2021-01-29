
{**********************************************************************}
{                                                                      }
{                           XML Data Binding                           }
{                                                                      }
{         Generated on: 22.01.2021 16:32:54                            }
{       Generated from: D:\Dokumente\code coverage\jacoco\report.dtd   }
{   Settings stored in: D:\Dokumente\code coverage\jacoco\report.xdb   }
{                                                                      }
{**********************************************************************}

unit JaCoCoXmlDataBinding;

interface

uses Xml.xmldom, Xml.XMLDoc, Xml.XMLIntf;

type

{ Forward Decls }

  IXMLReportType = interface;
  IXMLSessioninfoType = interface;
  IXMLSessioninfoTypeList = interface;
  IXMLGroupType = interface;
  IXMLGroupTypeList = interface;
  IXMLPackageType = interface;
  IXMLPackageTypeList = interface;
  IXMLClassType = interface;
  IXMLClassTypeList = interface;
  IXMLMethodType = interface;
  IXMLMethodTypeList = interface;
  IXMLCounterType = interface;
  IXMLCounterTypeList = interface;
  IXMLSourcefileType = interface;
  IXMLSourcefileTypeList = interface;
  IXMLLineType = interface;
  IXMLLineTypeList = interface;

{ IXMLReportType }

  IXMLReportType = interface(IXMLNode)
    ['{5B34E3B8-4382-49FA-A5A8-6D0035B007C1}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Sessioninfo: IXMLSessioninfoTypeList;
    function Get_Group: IXMLGroupTypeList;
    function Get_Package: IXMLPackageTypeList;
    function Get_Counter: IXMLCounterTypeList;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Sessioninfo: IXMLSessioninfoTypeList read Get_Sessioninfo;
    property Group: IXMLGroupTypeList read Get_Group;
    property Package: IXMLPackageTypeList read Get_Package;
    property Counter: IXMLCounterTypeList read Get_Counter;
  end;

{ IXMLSessioninfoType }

  IXMLSessioninfoType = interface(IXMLNode)
    ['{594E52A1-61B9-4199-8CBA-00CCAC67B68B}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_Start: UnicodeString;
    function Get_Dump: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_Start(Value: UnicodeString);
    procedure Set_Dump(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
    property Start: UnicodeString read Get_Start write Set_Start;
    property Dump: UnicodeString read Get_Dump write Set_Dump;
  end;

{ IXMLSessioninfoTypeList }

  IXMLSessioninfoTypeList = interface(IXMLNodeCollection)
    ['{C39F9CAB-4B97-4CE8-904A-2A148EA4512C}']
    { Methods & Properties }
    function Add: IXMLSessioninfoType;
    function Insert(const Index: Integer): IXMLSessioninfoType;

    function Get_Item(Index: Integer): IXMLSessioninfoType;
    property Items[Index: Integer]: IXMLSessioninfoType read Get_Item; default;
  end;

{ IXMLGroupType }

  IXMLGroupType = interface(IXMLNode)
    ['{1C07179E-61BE-4A66-AB49-A241283A5B8A}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Group: IXMLGroupTypeList;
    function Get_Package: IXMLPackageTypeList;
    function Get_Counter: IXMLCounterTypeList;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Group: IXMLGroupTypeList read Get_Group;
    property Package: IXMLPackageTypeList read Get_Package;
    property Counter: IXMLCounterTypeList read Get_Counter;
  end;

{ IXMLGroupTypeList }

  IXMLGroupTypeList = interface(IXMLNodeCollection)
    ['{D0AB8B22-40B0-4FDA-9894-3B487A813A92}']
    { Methods & Properties }
    function Add: IXMLGroupType;
    function Insert(const Index: Integer): IXMLGroupType;

    function Get_Item(Index: Integer): IXMLGroupType;
    property Items[Index: Integer]: IXMLGroupType read Get_Item; default;
  end;

{ IXMLPackageType }

  IXMLPackageType = interface(IXMLNode)
    ['{963C2A4A-6EF6-4BDA-A46A-CD677B944285}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Class_: IXMLClassTypeList;
    function Get_Sourcefile: IXMLSourcefileTypeList;
    function Get_Counter: IXMLCounterTypeList;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Class_: IXMLClassTypeList read Get_Class_;
    property Sourcefile: IXMLSourcefileTypeList read Get_Sourcefile;
    property Counter: IXMLCounterTypeList read Get_Counter;
  end;

{ IXMLPackageTypeList }

  IXMLPackageTypeList = interface(IXMLNodeCollection)
    ['{6AE09741-6492-4AA8-8536-A1A99F9F0B57}']
    { Methods & Properties }
    function Add: IXMLPackageType;
    function Insert(const Index: Integer): IXMLPackageType;

    function Get_Item(Index: Integer): IXMLPackageType;
    property Items[Index: Integer]: IXMLPackageType read Get_Item; default;
  end;

{ IXMLClassType }

  IXMLClassType = interface(IXMLNode)
    ['{2F8AD314-E6A6-4EEC-B499-BB79A43B8D4E}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Sourcefilename: UnicodeString;
    function Get_Method: IXMLMethodTypeList;
    function Get_Counter: IXMLCounterTypeList;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Sourcefilename(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Sourcefilename: UnicodeString read Get_Sourcefilename write Set_Sourcefilename;
    property Method: IXMLMethodTypeList read Get_Method;
    property Counter: IXMLCounterTypeList read Get_Counter;
  end;

{ IXMLClassTypeList }

  IXMLClassTypeList = interface(IXMLNodeCollection)
    ['{9E997902-2228-4F15-9F27-2CF07947FC3C}']
    { Methods & Properties }
    function Add: IXMLClassType;
    function Insert(const Index: Integer): IXMLClassType;

    function Get_Item(Index: Integer): IXMLClassType;
    property Items[Index: Integer]: IXMLClassType read Get_Item; default;
  end;

{ IXMLMethodType }

  IXMLMethodType = interface(IXMLNodeCollection)
    ['{C8B1A0C3-C2EC-4044-BB83-EE68303A11D5}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Desc: UnicodeString;
    function Get_Line: UnicodeString;
    function Get_Counter(Index: Integer): IXMLCounterType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Desc(Value: UnicodeString);
    procedure Set_Line(Value: UnicodeString);
    { Methods & Properties }
    function Add: IXMLCounterType;
    function Insert(const Index: Integer): IXMLCounterType;
    property Name: UnicodeString read Get_Name write Set_Name;
    property Desc: UnicodeString read Get_Desc write Set_Desc;
    property Line: UnicodeString read Get_Line write Set_Line;
    property Counter[Index: Integer]: IXMLCounterType read Get_Counter; default;
  end;

{ IXMLMethodTypeList }

  IXMLMethodTypeList = interface(IXMLNodeCollection)
    ['{47A07FF5-ABA1-4492-9E61-858A9948F02E}']
    { Methods & Properties }
    function Add: IXMLMethodType;
    function Insert(const Index: Integer): IXMLMethodType;

    function Get_Item(Index: Integer): IXMLMethodType;
    property Items[Index: Integer]: IXMLMethodType read Get_Item; default;
  end;

{ IXMLCounterType }

  IXMLCounterType = interface(IXMLNode)
    ['{D1CBF0A2-6ADF-4241-B320-1EADFC62FB3B}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Missed: UnicodeString;
    function Get_Covered: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Missed(Value: UnicodeString);
    procedure Set_Covered(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Missed: UnicodeString read Get_Missed write Set_Missed;
    property Covered: UnicodeString read Get_Covered write Set_Covered;
  end;

{ IXMLCounterTypeList }

  IXMLCounterTypeList = interface(IXMLNodeCollection)
    ['{A582D92C-113E-4165-8F2D-E99406F0C7F7}']
    { Methods & Properties }
    function Add: IXMLCounterType;
    function Insert(const Index: Integer): IXMLCounterType;

    function Get_Item(Index: Integer): IXMLCounterType;
    property Items[Index: Integer]: IXMLCounterType read Get_Item; default;
  end;

{ IXMLSourcefileType }

  IXMLSourcefileType = interface(IXMLNode)
    ['{C7FCA1F3-61A5-4949-8419-E15E66F8A3AC}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Line: IXMLLineTypeList;
    function Get_Counter: IXMLCounterTypeList;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Line: IXMLLineTypeList read Get_Line;
    property Counter: IXMLCounterTypeList read Get_Counter;
  end;

{ IXMLSourcefileTypeList }

  IXMLSourcefileTypeList = interface(IXMLNodeCollection)
    ['{B7F4D554-C791-4611-A6CC-ED9040726AFA}']
    { Methods & Properties }
    function Add: IXMLSourcefileType;
    function Insert(const Index: Integer): IXMLSourcefileType;

    function Get_Item(Index: Integer): IXMLSourcefileType;
    property Items[Index: Integer]: IXMLSourcefileType read Get_Item; default;
  end;

{ IXMLLineType }

  IXMLLineType = interface(IXMLNode)
    ['{79929EF3-43A3-476F-B9F7-B44487E3DF21}']
    { Property Accessors }
    function Get_Nr: UnicodeString;
    function Get_Mi: UnicodeString;
    function Get_Ci: UnicodeString;
    function Get_Mb: UnicodeString;
    function Get_Cb: UnicodeString;
    procedure Set_Nr(Value: UnicodeString);
    procedure Set_Mi(Value: UnicodeString);
    procedure Set_Ci(Value: UnicodeString);
    procedure Set_Mb(Value: UnicodeString);
    procedure Set_Cb(Value: UnicodeString);
    { Methods & Properties }
    property Nr: UnicodeString read Get_Nr write Set_Nr;
    property Mi: UnicodeString read Get_Mi write Set_Mi;
    property Ci: UnicodeString read Get_Ci write Set_Ci;
    property Mb: UnicodeString read Get_Mb write Set_Mb;
    property Cb: UnicodeString read Get_Cb write Set_Cb;
  end;

{ IXMLLineTypeList }

  IXMLLineTypeList = interface(IXMLNodeCollection)
    ['{F53387AE-63AB-477D-A30F-FAA667C94A62}']
    { Methods & Properties }
    function Add: IXMLLineType;
    function Insert(const Index: Integer): IXMLLineType;

    function Get_Item(Index: Integer): IXMLLineType;
    property Items[Index: Integer]: IXMLLineType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLReportType = class;
  TXMLSessioninfoType = class;
  TXMLSessioninfoTypeList = class;
  TXMLGroupType = class;
  TXMLGroupTypeList = class;
  TXMLPackageType = class;
  TXMLPackageTypeList = class;
  TXMLClassType = class;
  TXMLClassTypeList = class;
  TXMLMethodType = class;
  TXMLMethodTypeList = class;
  TXMLCounterType = class;
  TXMLCounterTypeList = class;
  TXMLSourcefileType = class;
  TXMLSourcefileTypeList = class;
  TXMLLineType = class;
  TXMLLineTypeList = class;

{ TXMLReportType }

  TXMLReportType = class(TXMLNode, IXMLReportType)
  private
    FSessioninfo: IXMLSessioninfoTypeList;
    FGroup: IXMLGroupTypeList;
    FPackage: IXMLPackageTypeList;
    FCounter: IXMLCounterTypeList;
  protected
    { IXMLReportType }
    function Get_Name: UnicodeString;
    function Get_Sessioninfo: IXMLSessioninfoTypeList;
    function Get_Group: IXMLGroupTypeList;
    function Get_Package: IXMLPackageTypeList;
    function Get_Counter: IXMLCounterTypeList;
    procedure Set_Name(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSessioninfoType }

  TXMLSessioninfoType = class(TXMLNode, IXMLSessioninfoType)
  protected
    { IXMLSessioninfoType }
    function Get_Id: UnicodeString;
    function Get_Start: UnicodeString;
    function Get_Dump: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_Start(Value: UnicodeString);
    procedure Set_Dump(Value: UnicodeString);
  end;

{ TXMLSessioninfoTypeList }

  TXMLSessioninfoTypeList = class(TXMLNodeCollection, IXMLSessioninfoTypeList)
  protected
    { IXMLSessioninfoTypeList }
    function Add: IXMLSessioninfoType;
    function Insert(const Index: Integer): IXMLSessioninfoType;

    function Get_Item(Index: Integer): IXMLSessioninfoType;
  end;

{ TXMLGroupType }

  TXMLGroupType = class(TXMLNode, IXMLGroupType)
  private
    FGroup: IXMLGroupTypeList;
    FPackage: IXMLPackageTypeList;
    FCounter: IXMLCounterTypeList;
  protected
    { IXMLGroupType }
    function Get_Name: UnicodeString;
    function Get_Group: IXMLGroupTypeList;
    function Get_Package: IXMLPackageTypeList;
    function Get_Counter: IXMLCounterTypeList;
    procedure Set_Name(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLGroupTypeList }

  TXMLGroupTypeList = class(TXMLNodeCollection, IXMLGroupTypeList)
  protected
    { IXMLGroupTypeList }
    function Add: IXMLGroupType;
    function Insert(const Index: Integer): IXMLGroupType;

    function Get_Item(Index: Integer): IXMLGroupType;
  end;

{ TXMLPackageType }

  TXMLPackageType = class(TXMLNode, IXMLPackageType)
  private
    FClass_: IXMLClassTypeList;
    FSourcefile: IXMLSourcefileTypeList;
    FCounter: IXMLCounterTypeList;
  protected
    { IXMLPackageType }
    function Get_Name: UnicodeString;
    function Get_Class_: IXMLClassTypeList;
    function Get_Sourcefile: IXMLSourcefileTypeList;
    function Get_Counter: IXMLCounterTypeList;
    procedure Set_Name(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPackageTypeList }

  TXMLPackageTypeList = class(TXMLNodeCollection, IXMLPackageTypeList)
  protected
    { IXMLPackageTypeList }
    function Add: IXMLPackageType;
    function Insert(const Index: Integer): IXMLPackageType;

    function Get_Item(Index: Integer): IXMLPackageType;
  end;

{ TXMLClassType }

  TXMLClassType = class(TXMLNode, IXMLClassType)
  private
    FMethod: IXMLMethodTypeList;
    FCounter: IXMLCounterTypeList;
  protected
    { IXMLClassType }
    function Get_Name: UnicodeString;
    function Get_Sourcefilename: UnicodeString;
    function Get_Method: IXMLMethodTypeList;
    function Get_Counter: IXMLCounterTypeList;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Sourcefilename(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLClassTypeList }

  TXMLClassTypeList = class(TXMLNodeCollection, IXMLClassTypeList)
  protected
    { IXMLClassTypeList }
    function Add: IXMLClassType;
    function Insert(const Index: Integer): IXMLClassType;

    function Get_Item(Index: Integer): IXMLClassType;
  end;

{ TXMLMethodType }

  TXMLMethodType = class(TXMLNodeCollection, IXMLMethodType)
  protected
    { IXMLMethodType }
    function Get_Name: UnicodeString;
    function Get_Desc: UnicodeString;
    function Get_Line: UnicodeString;
    function Get_Counter(Index: Integer): IXMLCounterType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Desc(Value: UnicodeString);
    procedure Set_Line(Value: UnicodeString);
    function Add: IXMLCounterType;
    function Insert(const Index: Integer): IXMLCounterType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMethodTypeList }

  TXMLMethodTypeList = class(TXMLNodeCollection, IXMLMethodTypeList)
  protected
    { IXMLMethodTypeList }
    function Add: IXMLMethodType;
    function Insert(const Index: Integer): IXMLMethodType;

    function Get_Item(Index: Integer): IXMLMethodType;
  end;

{ TXMLCounterType }

  TXMLCounterType = class(TXMLNode, IXMLCounterType)
  protected
    { IXMLCounterType }
    function Get_Type_: UnicodeString;
    function Get_Missed: UnicodeString;
    function Get_Covered: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Missed(Value: UnicodeString);
    procedure Set_Covered(Value: UnicodeString);
  end;

{ TXMLCounterTypeList }

  TXMLCounterTypeList = class(TXMLNodeCollection, IXMLCounterTypeList)
  protected
    { IXMLCounterTypeList }
    function Add: IXMLCounterType;
    function Insert(const Index: Integer): IXMLCounterType;

    function Get_Item(Index: Integer): IXMLCounterType;
  end;

{ TXMLSourcefileType }

  TXMLSourcefileType = class(TXMLNode, IXMLSourcefileType)
  private
    FLine: IXMLLineTypeList;
    FCounter: IXMLCounterTypeList;
  protected
    { IXMLSourcefileType }
    function Get_Name: UnicodeString;
    function Get_Line: IXMLLineTypeList;
    function Get_Counter: IXMLCounterTypeList;
    procedure Set_Name(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSourcefileTypeList }

  TXMLSourcefileTypeList = class(TXMLNodeCollection, IXMLSourcefileTypeList)
  protected
    { IXMLSourcefileTypeList }
    function Add: IXMLSourcefileType;
    function Insert(const Index: Integer): IXMLSourcefileType;

    function Get_Item(Index: Integer): IXMLSourcefileType;
  end;

{ TXMLLineType }

  TXMLLineType = class(TXMLNode, IXMLLineType)
  protected
    { IXMLLineType }
    function Get_Nr: UnicodeString;
    function Get_Mi: UnicodeString;
    function Get_Ci: UnicodeString;
    function Get_Mb: UnicodeString;
    function Get_Cb: UnicodeString;
    procedure Set_Nr(Value: UnicodeString);
    procedure Set_Mi(Value: UnicodeString);
    procedure Set_Ci(Value: UnicodeString);
    procedure Set_Mb(Value: UnicodeString);
    procedure Set_Cb(Value: UnicodeString);
  end;

{ TXMLLineTypeList }

  TXMLLineTypeList = class(TXMLNodeCollection, IXMLLineTypeList)
  protected
    { IXMLLineTypeList }
    function Add: IXMLLineType;
    function Insert(const Index: Integer): IXMLLineType;

    function Get_Item(Index: Integer): IXMLLineType;
  end;

{ Global Functions }

function Getreport(Doc: IXMLDocument): IXMLReportType;
function Loadreport(const FileName: string): IXMLReportType;
function Newreport: IXMLReportType;

const
  TargetNamespace = '';

implementation

uses Xml.xmlutil;

{ Global Functions }

function Getreport(Doc: IXMLDocument): IXMLReportType;
begin
  Result := Doc.GetDocBinding('report', TXMLReportType, TargetNamespace) as IXMLReportType;
end;

function Loadreport(const FileName: string): IXMLReportType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('report', TXMLReportType, TargetNamespace) as IXMLReportType;
end;

function Newreport: IXMLReportType;
begin
  Result := NewXMLDocument.GetDocBinding('report', TXMLReportType, TargetNamespace) as IXMLReportType;
end;

{ TXMLReportType }

procedure TXMLReportType.AfterConstruction;
begin
  RegisterChildNode('sessioninfo', TXMLSessioninfoType);
  RegisterChildNode('group', TXMLGroupType);
  RegisterChildNode('package', TXMLPackageType);
  RegisterChildNode('counter', TXMLCounterType);
  FSessioninfo := CreateCollection(TXMLSessioninfoTypeList, IXMLSessioninfoType, 'sessioninfo') as IXMLSessioninfoTypeList;
  FGroup := CreateCollection(TXMLGroupTypeList, IXMLGroupType, 'group') as IXMLGroupTypeList;
  FPackage := CreateCollection(TXMLPackageTypeList, IXMLPackageType, 'package') as IXMLPackageTypeList;
  FCounter := CreateCollection(TXMLCounterTypeList, IXMLCounterType, 'counter') as IXMLCounterTypeList;
  inherited;
end;

function TXMLReportType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLReportType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLReportType.Get_Sessioninfo: IXMLSessioninfoTypeList;
begin
  Result := FSessioninfo;
end;

function TXMLReportType.Get_Group: IXMLGroupTypeList;
begin
  Result := FGroup;
end;

function TXMLReportType.Get_Package: IXMLPackageTypeList;
begin
  Result := FPackage;
end;

function TXMLReportType.Get_Counter: IXMLCounterTypeList;
begin
  Result := FCounter;
end;

{ TXMLSessioninfoType }

function TXMLSessioninfoType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['id'].Text;
end;

procedure TXMLSessioninfoType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('id', Value);
end;

function TXMLSessioninfoType.Get_Start: UnicodeString;
begin
  Result := AttributeNodes['start'].Text;
end;

procedure TXMLSessioninfoType.Set_Start(Value: UnicodeString);
begin
  SetAttribute('start', Value);
end;

function TXMLSessioninfoType.Get_Dump: UnicodeString;
begin
  Result := AttributeNodes['dump'].Text;
end;

procedure TXMLSessioninfoType.Set_Dump(Value: UnicodeString);
begin
  SetAttribute('dump', Value);
end;

{ TXMLSessioninfoTypeList }

function TXMLSessioninfoTypeList.Add: IXMLSessioninfoType;
begin
  Result := AddItem(-1) as IXMLSessioninfoType;
end;

function TXMLSessioninfoTypeList.Insert(const Index: Integer): IXMLSessioninfoType;
begin
  Result := AddItem(Index) as IXMLSessioninfoType;
end;

function TXMLSessioninfoTypeList.Get_Item(Index: Integer): IXMLSessioninfoType;
begin
  Result := List[Index] as IXMLSessioninfoType;
end;

{ TXMLGroupType }

procedure TXMLGroupType.AfterConstruction;
begin
  RegisterChildNode('group', TXMLGroupType);
  RegisterChildNode('package', TXMLPackageType);
  RegisterChildNode('counter', TXMLCounterType);
  FGroup := CreateCollection(TXMLGroupTypeList, IXMLGroupType, 'group') as IXMLGroupTypeList;
  FPackage := CreateCollection(TXMLPackageTypeList, IXMLPackageType, 'package') as IXMLPackageTypeList;
  FCounter := CreateCollection(TXMLCounterTypeList, IXMLCounterType, 'counter') as IXMLCounterTypeList;
  inherited;
end;

function TXMLGroupType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLGroupType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLGroupType.Get_Group: IXMLGroupTypeList;
begin
  Result := FGroup;
end;

function TXMLGroupType.Get_Package: IXMLPackageTypeList;
begin
  Result := FPackage;
end;

function TXMLGroupType.Get_Counter: IXMLCounterTypeList;
begin
  Result := FCounter;
end;

{ TXMLGroupTypeList }

function TXMLGroupTypeList.Add: IXMLGroupType;
begin
  Result := AddItem(-1) as IXMLGroupType;
end;

function TXMLGroupTypeList.Insert(const Index: Integer): IXMLGroupType;
begin
  Result := AddItem(Index) as IXMLGroupType;
end;

function TXMLGroupTypeList.Get_Item(Index: Integer): IXMLGroupType;
begin
  Result := List[Index] as IXMLGroupType;
end;

{ TXMLPackageType }

procedure TXMLPackageType.AfterConstruction;
begin
  RegisterChildNode('class', TXMLClassType);
  RegisterChildNode('sourcefile', TXMLSourcefileType);
  RegisterChildNode('counter', TXMLCounterType);
  FClass_ := CreateCollection(TXMLClassTypeList, IXMLClassType, 'class') as IXMLClassTypeList;
  FSourcefile := CreateCollection(TXMLSourcefileTypeList, IXMLSourcefileType, 'sourcefile') as IXMLSourcefileTypeList;
  FCounter := CreateCollection(TXMLCounterTypeList, IXMLCounterType, 'counter') as IXMLCounterTypeList;
  inherited;
end;

function TXMLPackageType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLPackageType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLPackageType.Get_Class_: IXMLClassTypeList;
begin
  Result := FClass_;
end;

function TXMLPackageType.Get_Sourcefile: IXMLSourcefileTypeList;
begin
  Result := FSourcefile;
end;

function TXMLPackageType.Get_Counter: IXMLCounterTypeList;
begin
  Result := FCounter;
end;

{ TXMLPackageTypeList }

function TXMLPackageTypeList.Add: IXMLPackageType;
begin
  Result := AddItem(-1) as IXMLPackageType;
end;

function TXMLPackageTypeList.Insert(const Index: Integer): IXMLPackageType;
begin
  Result := AddItem(Index) as IXMLPackageType;
end;

function TXMLPackageTypeList.Get_Item(Index: Integer): IXMLPackageType;
begin
  Result := List[Index] as IXMLPackageType;
end;

{ TXMLClassType }

procedure TXMLClassType.AfterConstruction;
begin
  RegisterChildNode('method', TXMLMethodType);
  RegisterChildNode('counter', TXMLCounterType);
  FMethod := CreateCollection(TXMLMethodTypeList, IXMLMethodType, 'method') as IXMLMethodTypeList;
  FCounter := CreateCollection(TXMLCounterTypeList, IXMLCounterType, 'counter') as IXMLCounterTypeList;
  inherited;
end;

function TXMLClassType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLClassType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLClassType.Get_Sourcefilename: UnicodeString;
begin
  Result := AttributeNodes['sourcefilename'].Text;
end;

procedure TXMLClassType.Set_Sourcefilename(Value: UnicodeString);
begin
  SetAttribute('sourcefilename', Value);
end;

function TXMLClassType.Get_Method: IXMLMethodTypeList;
begin
  Result := FMethod;
end;

function TXMLClassType.Get_Counter: IXMLCounterTypeList;
begin
  Result := FCounter;
end;

{ TXMLClassTypeList }

function TXMLClassTypeList.Add: IXMLClassType;
begin
  Result := AddItem(-1) as IXMLClassType;
end;

function TXMLClassTypeList.Insert(const Index: Integer): IXMLClassType;
begin
  Result := AddItem(Index) as IXMLClassType;
end;

function TXMLClassTypeList.Get_Item(Index: Integer): IXMLClassType;
begin
  Result := List[Index] as IXMLClassType;
end;

{ TXMLMethodType }

procedure TXMLMethodType.AfterConstruction;
begin
  RegisterChildNode('counter', TXMLCounterType);
  ItemTag := 'counter';
  ItemInterface := IXMLCounterType;
  inherited;
end;

function TXMLMethodType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLMethodType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLMethodType.Get_Desc: UnicodeString;
begin
  Result := AttributeNodes['desc'].Text;
end;

procedure TXMLMethodType.Set_Desc(Value: UnicodeString);
begin
  SetAttribute('desc', Value);
end;

function TXMLMethodType.Get_Line: UnicodeString;
begin
  Result := AttributeNodes['line'].Text;
end;

procedure TXMLMethodType.Set_Line(Value: UnicodeString);
begin
  SetAttribute('line', Value);
end;

function TXMLMethodType.Get_Counter(Index: Integer): IXMLCounterType;
begin
  Result := List[Index] as IXMLCounterType;
end;

function TXMLMethodType.Add: IXMLCounterType;
begin
  Result := AddItem(-1) as IXMLCounterType;
end;

function TXMLMethodType.Insert(const Index: Integer): IXMLCounterType;
begin
  Result := AddItem(Index) as IXMLCounterType;
end;

{ TXMLMethodTypeList }

function TXMLMethodTypeList.Add: IXMLMethodType;
begin
  Result := AddItem(-1) as IXMLMethodType;
end;

function TXMLMethodTypeList.Insert(const Index: Integer): IXMLMethodType;
begin
  Result := AddItem(Index) as IXMLMethodType;
end;

function TXMLMethodTypeList.Get_Item(Index: Integer): IXMLMethodType;
begin
  Result := List[Index] as IXMLMethodType;
end;

{ TXMLCounterType }

function TXMLCounterType.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['type'].Text;
end;

procedure TXMLCounterType.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('type', Value);
end;

function TXMLCounterType.Get_Missed: UnicodeString;
begin
  Result := AttributeNodes['missed'].Text;
end;

procedure TXMLCounterType.Set_Missed(Value: UnicodeString);
begin
  SetAttribute('missed', Value);
end;

function TXMLCounterType.Get_Covered: UnicodeString;
begin
  Result := AttributeNodes['covered'].Text;
end;

procedure TXMLCounterType.Set_Covered(Value: UnicodeString);
begin
  SetAttribute('covered', Value);
end;

{ TXMLCounterTypeList }

function TXMLCounterTypeList.Add: IXMLCounterType;
begin
  Result := AddItem(-1) as IXMLCounterType;
end;

function TXMLCounterTypeList.Insert(const Index: Integer): IXMLCounterType;
begin
  Result := AddItem(Index) as IXMLCounterType;
end;

function TXMLCounterTypeList.Get_Item(Index: Integer): IXMLCounterType;
begin
  Result := List[Index] as IXMLCounterType;
end;

{ TXMLSourcefileType }

procedure TXMLSourcefileType.AfterConstruction;
begin
  RegisterChildNode('line', TXMLLineType);
  RegisterChildNode('counter', TXMLCounterType);
  FLine := CreateCollection(TXMLLineTypeList, IXMLLineType, 'line') as IXMLLineTypeList;
  FCounter := CreateCollection(TXMLCounterTypeList, IXMLCounterType, 'counter') as IXMLCounterTypeList;
  inherited;
end;

function TXMLSourcefileType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLSourcefileType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLSourcefileType.Get_Line: IXMLLineTypeList;
begin
  Result := FLine;
end;

function TXMLSourcefileType.Get_Counter: IXMLCounterTypeList;
begin
  Result := FCounter;
end;

{ TXMLSourcefileTypeList }

function TXMLSourcefileTypeList.Add: IXMLSourcefileType;
begin
  Result := AddItem(-1) as IXMLSourcefileType;
end;

function TXMLSourcefileTypeList.Insert(const Index: Integer): IXMLSourcefileType;
begin
  Result := AddItem(Index) as IXMLSourcefileType;
end;

function TXMLSourcefileTypeList.Get_Item(Index: Integer): IXMLSourcefileType;
begin
  Result := List[Index] as IXMLSourcefileType;
end;

{ TXMLLineType }

function TXMLLineType.Get_Nr: UnicodeString;
begin
  Result := AttributeNodes['nr'].Text;
end;

procedure TXMLLineType.Set_Nr(Value: UnicodeString);
begin
  SetAttribute('nr', Value);
end;

function TXMLLineType.Get_Mi: UnicodeString;
begin
  Result := AttributeNodes['mi'].Text;
end;

procedure TXMLLineType.Set_Mi(Value: UnicodeString);
begin
  SetAttribute('mi', Value);
end;

function TXMLLineType.Get_Ci: UnicodeString;
begin
  Result := AttributeNodes['ci'].Text;
end;

procedure TXMLLineType.Set_Ci(Value: UnicodeString);
begin
  SetAttribute('ci', Value);
end;

function TXMLLineType.Get_Mb: UnicodeString;
begin
  Result := AttributeNodes['mb'].Text;
end;

procedure TXMLLineType.Set_Mb(Value: UnicodeString);
begin
  SetAttribute('mb', Value);
end;

function TXMLLineType.Get_Cb: UnicodeString;
begin
  Result := AttributeNodes['cb'].Text;
end;

procedure TXMLLineType.Set_Cb(Value: UnicodeString);
begin
  SetAttribute('cb', Value);
end;

{ TXMLLineTypeList }

function TXMLLineTypeList.Add: IXMLLineType;
begin
  Result := AddItem(-1) as IXMLLineType;
end;

function TXMLLineTypeList.Insert(const Index: Integer): IXMLLineType;
begin
  Result := AddItem(Index) as IXMLLineType;
end;

function TXMLLineTypeList.Get_Item(Index: Integer): IXMLLineType;
begin
  Result := List[Index] as IXMLLineType;
end;

end.