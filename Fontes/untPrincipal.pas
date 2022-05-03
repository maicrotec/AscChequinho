unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RSPrint, Vcl.Grids,
  Vcl.Buttons, Vcl.ExtCtrls, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent;

type
  TfrmPrincipal = class(TForm)
    StringGridCliente: TStringGrid;
    RSPrinter: TRSPrinter;
    MmCliente: TMemo;
    pnl_topo: TPanel;
    spb_fechar: TSpeedButton;
    spb_minimizar: TSpeedButton;
    spb_salvartxt: TSpeedButton;
    pnl_barra_topo: TPanel;
    lbl_desenvolvido: TLabel;
    NetHTTPClient: TNetHTTPClient;
    spb_lercliente: TSpeedButton;
    procedure spb_fecharClick(Sender: TObject);
    procedure spb_minimizarClick(Sender: TObject);
    procedure spb_salvartxtClick(Sender: TObject);
    procedure StringGridClienteDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure spb_lerclienteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  index: integer;

implementation

{$R *.dfm}

uses System.JSON, RSPrint.Types.CommonTypes, WinSpool;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  StringGridCliente.cells[0,0] := 'Cheque';
  StringGridCliente.cells[1,0] := 'Nome do Cliente';
end;

procedure TfrmPrincipal.spb_fecharClick(Sender: TObject);
begin
  if (Application.MessageBox('Deseja Realmente Sair?','Anexo Solu��es - Aviso',36)=6)then
   begin
     Application.Terminate;
   end
   else
   begin
     Abort;
   end;
   FreeAndNil(frmPrincipal);
end;

procedure TfrmPrincipal.spb_lerclienteClick(Sender: TObject);
var
  JSonValue: TJSonValue;
  id, nome, st: string;
  count: integer;
begin
  index := 1;
  StringGridCliente.RowCount := 2;
  st := NetHTTPClient.Get('https://asc-puc.anexosolucoes.com.br/api/v1/checks')
    .ContentAsString;
  MmCliente.Lines.Text := st;
  JSonValue := TJSonObject.ParseJSONValue(st);
  count := 0;
  while True do
  begin
    try
      id := JSonValue.GetValue<string>('[' + IntToStr(count) + '].id');
    except
      id := '';
    end;
    if id <> '' then
    begin
      nome := JSonValue.GetValue<string>('[' + IntToStr(count) +
        '].associate.name');
      StringGridCliente.Cells[0, index] := id;
      StringGridCliente.Cells[1, index] := nome;
      inc(index);
      StringGridCliente.RowCount := index + 1;
    end
    else
    begin
      break;
    end;
    inc(count);
  end;

  JSonValue.Free;
end;

procedure TfrmPrincipal.spb_salvartxtClick(Sender: TObject);
var
  id, st, aux, aux2, conteudo: String;
  JSonValue: TJSonValue;
  count: integer;
  arq: TextFile;
  Valor: Real;
  CurrentLine: Integer;
  vSaltarLinha:String;
  function EspacoaEsqueda(str:string; qt:Integer) : string;
  var i : integer;
  begin
    result := str;

    for I := 1 to qt
    do result := ' '+result;
  end;
  function EspacoaDireita(str:string; qt:Integer) : string;
  var i : integer;
  begin
    result := str;

    for I := 1 to qt
    do result := result+' ';
  end;
  function PulaColuna(qt:Integer) : string;
  var i : integer;
  begin
    //result := EspacoaEsqueda('', qt);
    result := '';

    for I := 1 to qt
    do result := ' '+result;
  end;
begin
  vSaltarLinha := #$D#$A;

  id := StringGridCliente.Cells[0, StringGridCliente.Row];
  st := NetHTTPClient.Get('https://asc-puc.anexosolucoes.com.br/api/v1/checks/'+id).ContentAsString;
  JSonValue := TJSonObject.ParseJSONValue(st);
  count := 0;

  conteudo := '';
  //CurrentLine := 2;
  try

  //showmessage(JSonValue.ToString);

    while True do
    begin

      try
        // Pega o Valor do Id no Jason
        id := JSonValue.GetValue<string>('[' + IntToStr(count) + '].id');
      except
        id := '';
      end;
      if id <> '' then
      begin
        // Pega o N�mero da Matricula
        aux := JSonValue.GetValue<string>('['+IntToStr(count)+'].check.associate.registration');
        // Escreve o conteudo da string no jason sem saltar a linha
        conteudo := conteudo +vSaltarLinha+ vSaltarLinha+ vSaltarLinha+ PulaColuna(30)+ EspacoaDireita(aux, 40);

       // Pega o N�mero do Registro
        aux := JSonValue.GetValue<string>('['+IntToStr(count)+'].check.associate.rg'); //pega a estrutura do Jason
        // Escreve o conteudo da string no jason sem saltar a linha

        conteudo := conteudo + '         ' +  aux +'           '+ id;

        // Pega o N�mero do Cheque
        aux := JSonValue.GetValue<string>('['+IntToStr(count)+'].value');
        try
          Valor := StrToFloat(StringReplace(aux, '.',',',[rfReplaceAll, rfIgnoreCase]));
        except
          Valor := 0;
        end;

        //Pega o Nome do Cliente
        aux := JSonValue.GetValue<string>('['+IntToStr(count)+'].check.associate.name');
        // Escreve o conteudo da string no jason sem saltar a linha

        conteudo := conteudo +vSaltarLinha+vSaltarLinha+ PulaColuna(30)+ copy(aux,1,40);

        // Pega o Valor R$
        conteudo := conteudo +vSaltarLinha+ PulaColuna(10)+ EspacoaEsqueda( Format('%m',[Valor]), 12 );

        //
{        aux2 :=
           JSonValue.GetValue<string>('['+IntToStr(count)+'].check.associate.created_at');
}       {
        // Pega a Data da Cria��o
        aux := JSonValue.GetValue<string>('['+IntToStr(count)+'].check.created_at'); //pega a estrutura do Jason
        // Escreve o conteudo da string no jason sem saltar a linha
         }

        // Pega a Data de Validade
        aux := JSonValue.GetValue<string>('['+IntToStr(count)+'].check.expiration_date'); //pega a estrutura do Jason
        // Escreve o conteudo da string no jason sem saltar a linha

        conteudo := conteudo + '      ' +
 //         copy (aux2,9,2)+ '/' + copy (aux2,6,2)+ '/' +copy (aux2,3,2)+' a '+
          copy (aux,9,2)+ '/' + copy (aux,6,2)+ '/' +copy (aux,3,2);

        conteudo := conteudo + vSaltarLinha;

        if CurrentLine = RSPrinter.Lines-1 then
        begin
          CurrentLine := 1;
        end;
      end
      else
      begin
        break;
      end;
      inc(count);
    end;
    AssignFile(arq, 'D:\SISTEMAS\Delphi\AscChequinhoSimples\Txt\AscChequinho.txt');
    Rewrite(arq);
    Write(arq, conteudo);
    CloseFile(arq);
  finally
    JSonValue.Free;
  end;
end;

procedure TfrmPrincipal.spb_minimizarClick(Sender: TObject);
begin
  Application.Minimize; //Minimiza a Applica��o
end;

procedure TfrmPrincipal.StringGridClienteDblClick(Sender: TObject);
var
  id, st, aux, aux2, conteudo: String;
  JSonValue: TJSonValue;
  count: integer;
  arq: TextFile;
  Valor: Real;
  CurrentLine: Integer;

begin
  id := StringGridCliente.Cells[0, StringGridCliente.Row];
  st := NetHTTPClient.Get('https://asc-puc.anexosolucoes.com.br/api/v1/checks/'
    + id).ContentAsString;
  JSonValue := TJSonObject.ParseJSONValue(st);
  count := 0;

  conteudo := '';
  CurrentLine := 2;
  RSPrinter.Title := 'Anexo Solu��es - Chequinho';
  RSPrinter.SetModelName('Epson FX/LX/LQ');
  RSPrinter.BeginDoc;
  try

  //showmessage(JSonValue.ToString);

    while True do
    begin

      try
        // Pega o Valor do Id no Jason
        id := JSonValue.GetValue<string>('[' + IntToStr(count) + '].id');
      except
        id := '';
      end;
      if id <> '' then
      begin
        // Pega o N�mero da Matricula
        aux := JSonValue.GetValue<string>('[' + IntToStr(count) +
          '].check.associate.registration');
        // Escreve o conteudo da string no jason sem saltar a linha
        conteudo := aux;

       // Pega o N�mero do Registro
        aux := JSonValue.GetValue<string>('[' + IntToStr(count) +
          '].check.associate.rg'); //pega a estrutura do Jason
        // Escreve o conteudo da string no jason sem saltar a linha

        conteudo := conteudo + '         ' +  aux +'           '+ id;
        RSPrinter.Write(CurrentLine,  18, conteudo);
        CurrentLine := CurrentLine + 7;

        // Pega o N�mero do Cheque
        aux := JSonValue.GetValue<string>('[' + IntToStr(count) +
          '].value');
        try
          Valor := StrToFloat(StringReplace(aux, '.',',',[rfReplaceAll, rfIgnoreCase]));
        except
          Valor := 0;
        end;

        //Pega o Nome do Cliente
        aux := JSonValue.GetValue<string>('[' + IntToStr(count) +
          '].check.associate.name');
        // Escreve o conteudo da string no jason sem saltar a linha

        RSPrinter.Write(CurrentLine,  30, copy(aux,1,40));
        inc( CurrentLine,4);

        // Pega o Valor R$
        conteudo := Format('%m',[Valor]);

        //
{        aux2 :=
           JSonValue.GetValue<string>('[' + IntToStr(count) +
          '].check.associate.created_at');
}       {
         // Data da Cria��o
        aux := JSonValue.GetValue<string>('[' + IntToStr(count) +
          '].check.created_at'); //pega a estrutura do Jason
        // Escreve o conteudo da string no jason sem saltar a linha
        }

        // Pega a Data de Validade
        aux := JSonValue.GetValue<string>('[' + IntToStr(count) +
          '].check.expiration_date'); //pega a estrutura do Jason
        // Escreve o conteudo da string no jason sem saltar a linha

        conteudo := conteudo + '      '   +
 //         copy (aux2,9,2)+ '/' + copy (aux2,6,2)+ '/' +copy (aux2,3,2)+' a '+
          copy (aux,9,2)+ '/' + copy (aux,6,2)+ '/' +copy (aux,3,2);

        RSPrinter.Write(CurrentLine,  18, conteudo);
        inc(CurrentLine,7);

        if CurrentLine = RSPrinter.Lines-1 then
        begin
          CurrentLine := 1;
        end;
      end
      else
      begin
        break;
      end;
      inc(count);
    end;
   // AssignFile(arq, 'D:\SISTEMAS\Delphi\AscChequinhoSimples\Txt\AscChequinho.txt');
  //  Rewrite(arq);
  //  CloseFile(arq);
   RSPrinter.PreviewReal;
  // RSPrinter.PrintAll;
  finally
    JSonValue.Free;
  end;
end;

end.
