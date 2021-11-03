unit Venda.Controller.VendaItem;

interface

uses
  Venda.Model.Interfaces;

type

   TControllerVendaItem = Class(TInterfacedObject, iVendaItem)
      private
         FModelVendaItem: iVendaItem;
      public
         Constructor Create;
         Destructor  Destroy; override;
         Class Function New: iVendaItem;

         function SetDescricao(Value: String): iVendaItem;
         function GetDescricao: String;
         function SetPreco(Value: String): iVendaItem;
         function GetPreco: Currency;
   End;

implementation

uses
  Venda.Model.VendaItem;

{ TControllerVendaItem }

constructor TControllerVendaItem.Create;
begin
    FModelVendaItem := TModelVendaItem.New;
end;

destructor TControllerVendaItem.Destroy;
begin

  inherited;
end;

function TControllerVendaItem.GetDescricao: String;
begin
   Result := FModelVendaItem.GetDescricao;
end;

function TControllerVendaItem.GetPreco: Currency;
begin
   Result := FModelVendaItem.GetPreco;
end;

class function TControllerVendaItem.New: iVendaItem;
begin
   Result := Self.Create;
end;

function TControllerVendaItem.SetDescricao(Value: String): iVendaItem;
begin
   Result := Self;
   FModelVendaItem.SetDescricao(Value);
end;

function TControllerVendaItem.SetPreco(Value: String): iVendaItem;
begin
   Result := Self;
   FModelVendaItem.SetPreco(Value);
end;

end.
