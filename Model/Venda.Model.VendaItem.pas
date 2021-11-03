unit Venda.Model.VendaItem;

interface

uses
  Venda.Model.Interfaces, SysUtils;

type

  TModelVendaItem = Class(TInterfacedObject, iVendaItem)
     private
        FDescricao: String;
        FPreco: Currency;
     public
        Constructor Create;
        Destructor Destroy; override;
        Class Function New: iVendaItem;

        function SetDescricao(Value: String): iVendaItem;
        function GetDescricao: String;
        function SetPreco(Value: String): iVendaItem;
        function GetPreco: Currency;

  End;

implementation

{ TModelVendaItem }

constructor TModelVendaItem.Create;
begin

end;

destructor TModelVendaItem.Destroy;
begin

  inherited;
end;

function TModelVendaItem.GetDescricao: String;
begin
   Result := FDescricao;
end;

function TModelVendaItem.GetPreco: Currency;
begin
   Result := FPreco;
end;

class function TModelVendaItem.New: iVendaItem;
begin
   Result := Self.Create;
end;

function TModelVendaItem.SetDescricao(Value: String): iVendaItem;
begin
   Result := Self;
   FDescricao := Value;
end;

function TModelVendaItem.SetPreco(Value: String): iVendaItem;
begin
   Result := Self;
   Value := StringReplace(Value, '.', '', [rfReplaceAll]);
   FPreco := StrToCurrDef(Value, 0);
end;

end.
