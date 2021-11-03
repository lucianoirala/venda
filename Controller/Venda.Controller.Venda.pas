unit Venda.Controller.Venda;

interface

uses
  Venda.Model.Interfaces, Vcl.StdCtrls;

type

   TControllerVenda = Class(TInterfacedObject, iVenda)
      private
         FModelVenda: iVenda;
      public
         Constructor Create;
         Destructor  Destroy; override;
         Class Function New: iVenda;

         function SetCodVenda(Value: Integer): iVenda;
         function SetNomeCliente(Value: String): iVenda;
         function GetNomeCliente: String;
         function Adicionar(Value: iVendaItem): iVenda;
         function GetItem(Value: integer): iVendaItem;
         function GetDataVenda: String;
         function GetDataEntrega: String;
         function GetQtdItens: Integer;
         function GetCodVenda: Integer;
         function  MostrarVenda(Value: TMemo): iVenda;
   End;

implementation

uses
  Venda.Model.Venda;

{ TControllerVenda }

function TControllerVenda.Adicionar(Value: iVendaItem): iVenda;
begin
   Result := Self;
   FModelVenda.Adicionar(Value);
end;

constructor TControllerVenda.Create;
begin
   FModelVenda := TModelVenda.New;
end;

destructor TControllerVenda.Destroy;
begin

  inherited;
end;

function TControllerVenda.GetCodVenda: Integer;
begin
   Result := FModelVenda.GetCodVenda;
end;

function TControllerVenda.GetDataEntrega: String;
begin
   Result := FModelVenda.GetDataEntrega;
end;

function TControllerVenda.GetDataVenda: String;
begin
   Result := FModelVenda.GetDataVenda;
end;

function TControllerVenda.GetItem(Value: integer): iVendaItem;
begin
   Result := FModelVenda.GetItem(Value);
end;

function TControllerVenda.GetNomeCliente: String;
begin
   Result := FModelVenda.GetNomeCliente;
end;

class function TControllerVenda.New: iVenda;
begin
   Result := Self.Create;
end;

function TControllerVenda.GetQtdItens: Integer;
begin
   Result := FModelVenda.GetQtdItens;
end;

function TControllerVenda.MostrarVenda(Value: TMemo): iVenda;
begin
   Result := Self;
   FModelVenda.MostrarVenda(Value);
end;

function TControllerVenda.SetCodVenda(Value: Integer): iVenda;
begin
   Result := Self;
   FModelVenda.SetCodVenda(Value);
end;

function TControllerVenda.SetNomeCliente(Value: String): iVenda;
begin
   Result := Self;
   FModelVenda.SetNomeCliente(Value);
end;

end.
