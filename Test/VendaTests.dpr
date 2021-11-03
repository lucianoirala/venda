program VendaTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  TestVenda.Model in 'TestVenda.Model.pas',
  Venda.Model.Venda in '..\Model\Venda.Model.Venda.pas',
  Venda.Model.Interfaces in '..\Model\Venda.Model.Interfaces.pas',
  Venda.Model.VendaItem in '..\Model\Venda.Model.VendaItem.pas';

{R *.RES}

begin
   DUnitTestRunner.RunRegisteredTests;
end.

