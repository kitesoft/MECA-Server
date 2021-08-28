unit Service.Campanha;

interface

uses
  System.SysUtils, System.Classes, Service.Module, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,System.JSON,
  System.Generics.Collections;

type
  TServiceCampanha = class(TServiceModule)
  private
    { Private declarations }
  public
    { Public declarations }
    function List(AFilter : TDictionary<String,String>): TDataset; // Retrieves all items from Produto Table
    function GetByID(ID : Integer): TDataset; //Does as the name says
    function Insert(JSON : TJSONObject) : Boolean;
    function Update(JSON : TJSONObject) : Boolean;
    function Delete : Boolean;
  end;

implementation

uses Dataset.Serialize;

{$R *.dfm}

{ TServiceCampanha }

function TServiceCampanha.Delete: Boolean;
begin
  qUpdate.Delete;
  Result := qUpdate.ApplyUpdates(0) = 0;
end;

function TServiceCampanha.GetByID(ID: Integer): TDataset;
begin
  Result:= qUpdate;
  qUpdate.SQL.Add('WHERE idcampanha = :ID');
  qUpdate.ParamByName('ID').AsInteger := ID;
  qUpdate.Open;
end;

function TServiceCampanha.Insert(JSON: TJSONObject): Boolean;
begin
  qUpdate.SQL.Add('WHERE 1<>1');
  qUpdate.Open;
  qUpdate.LoadFromJSON(JSON, False);
  Result := qUpdate.ApplyUpdates(0) = 0;
end;

function TServiceCampanha.List(AFilter : TDictionary<String,String>): TDataset;
var
  I: Integer;
begin
  Result:= Query;

  if(Assigned(AFilter)) then
  begin

    if AFilter.ContainsKey('limit') then begin
      Query.FetchOptions.RecsMax := AFilter.Items['limit'].ToInt64;
    end;

    if AFilter.ContainsKey('offset') then begin
      Query.FetchOptions.RecsSkip := AFilter.Items['offset'].ToInt64;
    end;

    for I := 0 to Query.ParamCount - 1 do begin

      if (AFilter.ContainsKey(Query.Params[I].Name.ToLower)) then begin
        Query.Params[I].AsString := AFilter.Items[Query.Params[I].Name.ToLower];
      end;


    end;

  end;

  Query.Open;
end;

function TServiceCampanha.Update(JSON: TJSONObject): Boolean;
begin
  qUpdate.Open;
  qUpdate.MergeFromJSONObject(JSON,False);
  Result := qUpdate.ApplyUpdates(0) = 0;
end;

end.
