unit Venda.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList, Generics.collections, System.Classes, Venda.Model.Interfaces;

type
  TViewPrincipal = class(TForm)
    PnlVenda: TPanel;
    PnlRodape: TPanel;
    EdtNomeCliente: TLabeledEdit;
    EdtProduto: TLabeledEdit;
    EdtPreco: TLabeledEdit;
    BtAdicionar: TButton;
    Label1: TLabel;
    EdtTotal: TEdit;
    BtSair: TButton;
    BtFinalizar: TButton;
    PnlBusca: TPanel;
    MemVendas: TMemo;
    PnlTopoBusca: TPanel;
    EdtBuscar: TLabeledEdit;
    BtBuscar: TButton;
    BtBuscarVenda: TButton;
    STGProduto: TStringGrid;
    IMLIcones: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure BtSairClick(Sender: TObject);
    procedure BtBuscarVendaClick(Sender: TObject);
    procedure STGProdutoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure BtAdicionarClick(Sender: TObject);
    procedure BtFinalizarClick(Sender: TObject);
    procedure EdtPrecoEnter(Sender: TObject);
    procedure EdtPrecoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtPrecoKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtBuscarClick(Sender: TObject);
    procedure EdtPrecoExit(Sender: TObject);
    procedure EdtBuscarKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FVendas: TList<iVenda>;
    FCodVenda: Integer;

    function FormatarCampoMoeda(Value: String): String;
    function FormatarMoeda(Value: Currency): String;
    function ValidarFormulario: Boolean;
    procedure LimparFormulario;
  public
    { Public declarations }
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

uses
  Venda.Controller.Venda, Venda.Controller.VendaItem;

{$R *.dfm}

procedure TViewPrincipal.BtAdicionarClick(Sender: TObject);
Var
   I: Integer;
   lTotal: Currency;
   lValor: String;
begin
   if Not ValidarFormulario then
      Exit;

   lValor := StringReplace(EdtTotal.Text, '.', '', [rfReplaceAll]);
   lTotal := StrToCurrDef(lValor, 0);

   lValor := StringReplace(EdtPreco.Text, '.', '', [rfReplaceAll]);
   lTotal := (StrToCurrDef(lValor, 0) + lTotal);

   EdtTotal.Text := FormatarMoeda(lTotal);

   I := STGProduto.RowCount - 1;
   STGProduto.Cells[0, I] := EdtProduto.Text;
   STGProduto.Cells[1, I] := EdtPreco.Text;
   STGProduto.RowCount := STGProduto.RowCount + 1;
   EdtProduto.Clear;
   EdtPreco.Text := '0,00';
   EdtProduto.SetFocus;
end;

procedure TViewPrincipal.BtBuscarClick(Sender: TObject);
Var
  lCodVenda: Integer;
  lCodigoEncontrado: Boolean;
  I: Integer;
begin
   if (Trim(EdtBuscar.Text) = '') OR (Trim(EdtBuscar.Text) = '0') then
   begin
      Showmessage('Digite o Código da Venda para Pesquisar!');
      EdtBuscar.SetFocus;
      Exit;
   end;

   lCodVenda := StrtoInt(EdtBuscar.Text);
   lCodigoEncontrado := False;
   for I := 0 to Pred(FVendas.Count) do
   begin
      if FVendas.Items[I].GetCodVenda = lCodVenda then
      begin
        FVendas.Items[I].MostrarVenda(MemVendas);
        lCodigoEncontrado := True;
        Break;
      end;
   end;

   if Not lCodigoEncontrado then
   begin
      Showmessage('Código da Venda não Encontrado!');
      EdtBuscar.SetFocus;
      Exit;
   end;

end;

procedure TViewPrincipal.BtBuscarVendaClick(Sender: TObject);
begin
   if BtBuscarVenda.Tag = 0 then
   begin
       PnlVenda.Visible := False;
       PnlBusca.Visible := True;
       BtFinalizar.Visible := False;
       BtBuscarVenda.Caption := 'Voltar [F4]';
       BtBuscarVenda.ImageIndex := 0;
       BtBuscarVenda.Width := 110;
       BtBuscarVenda.Tag := 1;
       EdtBuscar.Clear;
       MemVendas.Clear;
       EdtBuscar.SetFocus;
   end
   else
   begin
       PnlVenda.Visible := True;
       PnlBusca.Visible := False;
       BtFinalizar.Visible := True;
       BtBuscarVenda.ImageIndex := 2;
       BtBuscarVenda.Caption := 'Buscar Venda [F4]';
       BtBuscarVenda.Width := 170;
       BtBuscarVenda.Tag := 0;
       EdtNomeCliente.SetFocus;
   end;
end;

procedure TViewPrincipal.BtFinalizarClick(Sender: TObject);
Var
   lVenda: iVenda;
   lItem: iVendaItem;
   I: Integer;
begin
   if STGProduto.RowCount < 3 then
   begin
     Showmessage('Adicione Produtos para Finalizar a Venda!');
     Exit;
   end;

   Inc(FCodVenda);
   lVenda := TControllerVenda.New;
   lVenda.SetCodVenda(FCodVenda)
         .SetNomeCliente(EdtNomeCliente.Text);

   for I := 1 to Pred(STGProduto.RowCount) do
   begin
      if STGProduto.Cells[0, I] <> '' then
      begin
          lItem := TControllerVendaItem.New
                                       .SetDescricao(STGProduto.Cells[0, I])
                                       .SetPreco(STGProduto.Cells[1, I]);
          lVenda.Adicionar(lItem);
      end;
   end;

   Showmessage('Venda Realizada com sucesso!' + #13#10 +
               'Código: ' + lVenda.GetCodVenda.ToString + #13#10 +
               'Data de Entrega: ' + lVenda.GetDataEntrega);

   FVendas.Add(lVenda);
   LimparFormulario;
   EdtNomeCliente.SetFocus;

end;

procedure TViewPrincipal.BtSairClick(Sender: TObject);
begin
   Close;
end;

procedure TViewPrincipal.EdtBuscarKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
      BtBuscar.Click;
end;

procedure TViewPrincipal.EdtPrecoEnter(Sender: TObject);
begin
   if Trim(EdtPreco.Text) = '0,00' then
      EdtPreco.Text := ''
   else
      PostMessage(EdtPreco.Handle, EM_SETSEL, 0, Length(EdtPreco.Text))
end;

procedure TViewPrincipal.EdtPrecoExit(Sender: TObject);
begin
   if Trim(EdtPreco.Text) = '' then
      EdtPreco.Text := '0,00';
end;

procedure TViewPrincipal.EdtPrecoKeyPress(Sender: TObject; var Key: Char);
begin
   if Not (CharInSet(Key, ['0'..'9', Chr(8), ','])) then
      Key := #0
end;

procedure TViewPrincipal.EdtPrecoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
Var
  lTexto: String;
begin
  if (Key in [96..107]) or (Key in [48..57]) then
  begin
      lTexto := FormatarCampoMoeda(EdtPreco.Text);
      EdtPreco.Text := lTexto;
      EdtPreco.SelStart := Length(lTexto);
  end;
end;

function TViewPrincipal.FormatarCampoMoeda(Value: String): String;
Var
   S: String;
begin
      Result := '';
      S := Value;
      S := StringReplace(S,',','',[rfReplaceAll]);
      S := StringReplace(S,'.','',[rfReplaceAll]);
      if Length(s) = 3 then
          s := Copy(s,1,1) + ',' + Copy(S,2,15)
      else
      begin
          if (Length(s) > 3) and (Length(s) < 6) then
             s := Copy(s,1,length(s)-2) + ',' + Copy(S,length(s)-1,15)
          else
          begin
            if (Length(s) >= 6) and (Length(s) < 9) then
               s := Copy(s,1,length(s)-5) + '.' + Copy(s,length(s)-4,3) + ',' + Copy(S,length(s)-1,15)
            else
               if (Length(s) >= 9) and (Length(s) < 12) then
                  s := Copy(s,1,length(s)-8) + '.' + Copy(s,length(s)-7,3) + '.' +
                       Copy(s,length(s)-4,3) + ',' + Copy(S,length(s)-1,15)
               else
                  if (Length(s) >= 12) and (Length(s) < 15)  then
                     s := Copy(s,1,length(s)-11) + '.' + Copy(s,length(s)-10,3) + '.' +
                          Copy(s,length(s)-7,3) + '.' + Copy(s,length(s)-4,3) + ',' + Copy(S,length(s)-1,15);
          end;
      end;
      Result := S;
end;

function TViewPrincipal.FormatarMoeda(Value: Currency): String;
begin
   Result := FormatCurr('###,###,##0.00', Value);
end;

procedure TViewPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   FreeAndNil(FVendas);
end;

procedure TViewPrincipal.FormCreate(Sender: TObject);
var
  I: Integer;
begin
    FVendas := TList<IVenda>.Create;
    FCodVenda := 0;
    Self.Width := 580;

    for I := 0 to Pred(ComponentCount) do
    begin
       if (Components[I] is TButton) then
          (Components[I] as TButton).Cursor := crHandPoint;
    end;

    ReportMemoryLeaksOnShutdown := True;
end;

procedure TViewPrincipal.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
      VK_F2 : BtAdicionar.Click;
      VK_F3 : BtSair.Click;
      VK_F4 : BtBuscarVenda.Click;
      VK_F5 : BtFinalizar.Click;
   end;
end;

procedure TViewPrincipal.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then
    begin
       Key := #0;
       Perform(WM_NEXTDLGCTL, 0, 0);
    end;
end;

procedure TViewPrincipal.FormShow(Sender: TObject);
begin
    EdtNomeCliente.SetFocus;
end;

procedure TViewPrincipal.LimparFormulario;
Var
  I: Integer;
begin
   EdtNomeCliente.Clear;
   EdtProduto.Clear;
   EdtPreco.Text := '0,00';
   EdtTotal.Text := '0,00';
   for I := 1 to Pred(STGProduto.RowCount) do
   begin
      STGProduto.Cells[0, I] := '';
      STGProduto.Cells[1, I] := '';
   end;
   STGProduto.RowCount := 2;
end;

procedure TViewPrincipal.STGProdutoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
var
  lDelta: Integer;
  lTexto: String;
  WidthOfText: integer;
  WidthOfCell: integer;
  LeftOffset: integer;
begin
  STGProduto.Brush.Color := clGreen;
  STGProduto.Font.Color := clBlue;
  STGProduto.Font.Size  := 16;

  With STGProduto do
  begin
     if ARow = 0 then
     begin
        Canvas.Font.Size  := 12;
        Canvas.Brush.Color := clBtnFace;
        if ACol = 0 then
        begin
           lTexto := 'Produto';
           Canvas.TextRect(Rect, Rect.Left , Rect.Top +2, lTexto);
        end
        else
        begin
           lTexto := 'Preço';
           WidthOfText := Canvas.TextWidth(lTexto);
           WidthOfCell := ColWidths[ACol];
           LeftOffset := WidthOfCell - WidthOfText;
           Canvas.TextRect(Rect, Rect.Left + LeftOffset, Rect.Top +2, lTexto);
        end;
     end
     else
     begin
        Canvas.Font.Size  := 10;
        Canvas.Brush.Color := clWhite;
        lTexto := Cells[ACol,ARow];
        if ACol = 0 then
           Canvas.TextRect(Rect, Rect.Left , Rect.Top +2, lTexto)
        else
        begin
           WidthOfText := Canvas.TextWidth(lTexto);
           WidthOfCell := ColWidths[ACol];
           LeftOffset := WidthOfCell - WidthOfText;
           Canvas.TextRect(Rect, Rect.Left + LeftOffset, Rect.Top +2, lTexto);
        end;
     end;
  end;
end;

function TViewPrincipal.ValidarFormulario: Boolean;
begin
   Result := False;
   if Trim(EdtNomeCliente.Text) = '' then
   begin
      Showmessage('O Campo Cliente deve ser Preenchido!');
      EdtNomeCliente.SetFocus;
      Exit;
   end;

   if Trim(EdtProduto.Text) = '' then
   begin
      Showmessage('O Campo Produto deve ser Preenchido!');
      EdtProduto.SetFocus;
      Exit;
   end;

   if Trim(EdtPreco.Text) = '0,00' then
   begin
      Showmessage('O Campo Preço não pode ser ZERO!');
      EdtPreco.SetFocus;
      Exit;
   end;
   Result := True;
end;

end.
