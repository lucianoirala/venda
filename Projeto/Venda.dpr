program Venda;

uses
  Vcl.Forms,
  Venda.View.Principal in '..\View\Venda.View.Principal.pas' {ViewPrincipal},
  Venda.Model.Interfaces in '..\Model\Venda.Model.Interfaces.pas',
  Venda.Model.Venda in '..\Model\Venda.Model.Venda.pas',
  Venda.Model.VendaItem in '..\Model\Venda.Model.VendaItem.pas',
  Venda.Controller.VendaItem in '..\Controller\Venda.Controller.VendaItem.pas',
  Venda.Controller.Venda in '..\Controller\Venda.Controller.Venda.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.Run;
end.
