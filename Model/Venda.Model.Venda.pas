unit Venda.Model.Venda;

interface

uses
    Venda.Model.Interfaces, Generics.Collections, Vcl.StdCtrls;

type

   TTipoAlinhamento = (tpDireita, tpEsquerda);

   TModelVenda = Class(TInterfacedObject, iVenda)
     private
        FCodVenda: Integer;
        FLista: TList<iVendaItem>;
        FNomeCliente: String;
        FQtdItens: Integer;
        FDataVenda: TDate;
        FDataEntrega: TDate;

        procedure DataEntrega;
        function  Alinhar(pTexto: String; pAlinhamento: TTipoAlinhamento): String;
        function FormatarMoeda(Value: Currency): String;
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
        function MostrarVenda(Value: TMemo): iVenda;
   End;

implementation

uses
  Venda.Model.VendaItem, System.SysUtils, DateUtils, Vcl.Graphics;

{ TModelVenda }

function TModelVenda.Adicionar(Value: iVendaItem): iVenda;
begin
   Result := Self;
   FLista.Add(Value);
end;

function TModelVenda.Alinhar(pTexto: String; pAlinhamento: TTipoAlinhamento): String;
Var
  lTamanhoTexto: Integer;
begin
  lTamanhoTexto := 20 - length(pTexto);
  case pAlinhamento of
     tpDireita : pTexto := StringOfChar(' ', lTamanhoTexto) + pTexto;
     tpEsquerda: pTexto := pTexto + StringOfChar(' ', lTamanhoTexto);
  end;
  Result := pTexto;
end;

constructor TModelVenda.Create;
begin
   FLista := TList<iVendaItem>.Create;
   FDataVenda := Date;
   DataEntrega;
end;

procedure TModelVenda.DataEntrega;
Var
  lContadorDias: Integer;
begin
   FDataEntrega := Date;
   lContadorDias := 0;
   while lContadorDias < 10 do
   begin
      if ((DayOfWeek(FDataEntrega) <> 1) and (DayOfWeek(FDataEntrega) <> 7)) then
         Inc(lContadorDias);

      if lContadorDias < 10 then
         FDataEntrega := IncDay(FDataEntrega, 1);
   end;
end;

destructor TModelVenda.Destroy;
begin
    FreeAndNil(FLista);
  inherited;
end;

function TModelVenda.FormatarMoeda(Value: Currency): String;
begin
  Result := 'R$ ' + FormatCurr('###,###,##0.00', Value);
end;

function TModelVenda.GetCodVenda: Integer;
begin
   Result := FCodVenda;
end;

function TModelVenda.GetDataEntrega: String;
begin
   Result := DateToStr(FDataEntrega);
end;

function TModelVenda.GetDataVenda: String;
begin
   Result := DateToStr(FDataVenda);
end;

function TModelVenda.GetItem(Value: integer): iVendaItem;
begin
   Result := FLista.Items[Value];
end;

function TModelVenda.GetNomeCliente: String;
begin
   Result := FNomeCliente;
end;

class function TModelVenda.New: iVenda;
begin
   Result := Self.Create;
end;

function TModelVenda.GetQtdItens: Integer;
begin
   Result := FLista.Count;
end;

function TModelVenda.MostrarVenda(Value: TMemo): iVenda;
Var
  I: Integer;
  lProduto: String;
  lPreco: String;
  lTotal: Currency;
begin
   lTotal := 0;
   Value.Clear;
   With Value.Lines do
   begin
       Append('=========== Dados da Venda ============');
       Append('Código.........: ' + FCodVenda.ToString);
       Append('Cliente........: ' + FNomeCliente);
       Append('Data da Compra.: ' + DateToStr(FDataVenda));
       Append('Data da Entrega: ' + DateToStr(FDataEntrega));
       Append('----------------------------------------');
       Append(Alinhar('Produto', tpEsquerda) + Alinhar('Preço', tpDireita));
       Append('----------------------------------------');

       for I := 0 to Pred(FLista.Count) do
       begin
          lProduto:= FLista.Items[I].GetDescricao;
          lTotal := lTotal + FLista.Items[I].GetPreco;
          lPreco := FormatarMoeda(FLista.Items[I].GetPreco);
          Append(Alinhar(lProduto, tpEsquerda) + Alinhar(lPreco, tpDireita));
       end;
       Append('----------------------------------------');

       Append(Alinhar('Total da Venda: ', tpEsquerda) +
              Alinhar(FormatarMoeda(lTotal), tpDireita));
       Append('----------------------------------------');
   end;
end;

function TModelVenda.SetCodVenda(Value: Integer): iVenda;
begin
   Result := Self;
   FCodVenda := Value;
end;

function TModelVenda.SetNomeCliente(Value: String): iVenda;
begin
  Result := Self;
  FNomeCliente := Value;
end;

end.
