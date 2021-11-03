unit Venda.Model.Interfaces;

interface

uses
  Vcl.StdCtrls;

type
  iVendaItem = interface;

  iVenda = interface
    ['{79640664-A613-41E6-9A85-8131FDEA502C}']
    function  SetCodVenda(Value: Integer): iVenda;
    function  SetNomeCliente(Value: String): iVenda;
    function  GetNomeCliente: String;
    function  Adicionar(Value: iVendaItem): iVenda;
    function  GetItem(Value: integer): iVendaItem;
    function  GetDataVenda: String;
    function  GetDataEntrega: String;
    function  GetQtdItens: Integer;
    function  GetCodVenda: Integer;
    function  MostrarVenda(Value: TMemo): iVenda;
  end;

  iVendaItem = interface
    ['{119CD783-ED31-4A47-B2FB-1E60CF889293}']
    function  SetDescricao(Value: String): iVendaItem;
    function  GetDescricao: String;
    function  SetPreco(Value: String): iVendaItem;
    function  GetPreco: Currency;
  end;


implementation

end.
