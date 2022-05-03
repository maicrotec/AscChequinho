unit untRotinas;


interface

uses System.SysUtils, System.Variants, System.Classes;

function Separa(const sLinhaStr : String; const iQtdLinhas : Integer; var sQtdCaracters : String) : String;

Procedure Extenso2( Valor: String; Var Linha1, Linha2: String; TamPri, TamSeg: Integer);


function Extenso(const rValor : Real; const iQtdLinhas : Integer; sQtdCaracters : String) : String;


implementation

function Separa(const sLinhaStr : String; const iQtdLinhas : Integer; var sQtdCaracters : String) : String;
var
  aTabAux : Array of String;
  iTotCar,
  iQtdSp,
  iPosSp,
  iPos,
  iLoc,
  iAux,
  iInd : Integer;
  sResultado,
  sTxtAux,
  sTexto : String;
begin
  SetLength(aTabAux, iQtdLinhas);
  iLoc := 1;
  iTotCar := 0;
  sTexto := sLinhaStr;
  sResultado := '';
  for iInd := 0 to iQtdLinhas -1 do
  begin
    iAux := StrToInt(Copy(sQtdCaracters,iLoc,3));
    iTotCar := iTotCar + iAux;
    if iAux < Length(sTexto) then
    begin
      if (Copy(sTexto,iAux,1) = ' ') or (Pos(' ',sTexto) = 0) then
      begin
        aTabAux[iInd] := Copy(sTexto,1,iAux);
        sTexto := Copy(sTexto,iAux + 1,Length(sTexto) - iAux);
      end
      else
      begin
        iPos := iAux;
        while (Copy(sTexto,iPos,1) <> ' ') and (iPos > 0) do
        begin
          Dec(iPos);
        end;
        if iPos = 0 then
          iPos := iAux;
        aTabAux[iInd] := Copy(sTexto,1,iPos);
        sTexto := Copy(sTexto,iPos + 1,Length(sTexto) - iPos);
      end;
    end
    else
    begin
      aTabAux[iInd] := sTexto;
      sTexto := '';
    end;
    aTabAux[iInd] := TrimLeft(Trim(aTabAux[iInd]));
    sTxtAux := aTabAux[iInd];
    if (Pos(' ',sTxtAux) <> 0) and (Length(sTexto) > 0) then
    begin
      iQtdSp := iAux - Length(sTxtAux);
      iPosSp := Pos(' ',sTxtAux);
      while iQtdSp > 0 do
      begin
        if iPosSp > Length(sTxtAux) then
          iPosSp := Pos(' ',sTxtAux);
        if Copy(sTxtAux,iPosSp,1) = ' ' then
        begin
          Insert(' ',sTxtAux,iPosSp);
          Inc(iPosSp);
          Dec(iQtdSp);
        end;
        Inc(iPosSp);
      end;
      aTabAux[iInd] := sTxtAux;
    end;
    sResultado := sResultado + sTxtAux;
    Inc(iLoc,4);
  end;
  sQtdCaracters := IntToStr(iTotCar);
  Result := sResultado;
end;
function Extenso(const rValor : Real; const iQtdLinhas : Integer; sQtdCaracters : String) : String;
const
  aUnidades : Array [1..9,1..3] of String = ((' UM',' DEZ',' CEM'),(' DOIS',' VINTE',' DUZENTOS'),(' TRÊS',' TRINTA',' TREZENTOS'),(' QUATRO',' QUARENTA',' QUATROCENTOS'),(' CINCO',' CINQÜENTA',' QUINHENTOS'),(' SEIS',' SESSENTA',' SEISCENTOS'),(' SETE',' SETENTA',' SETECENTOS'),(' OITO',' OITENTA',' OITOCENTOS'),(' NOVE',' NOVENTA',' NOVECENTOS'));
  aOutrosNums : Array [1..9] of String = (' ONZE', ' DOZE', ' TREZE', ' QUATORZE', ' QUINZE', ' DEZESEIS', ' DEZESETE',' DEZOITO', ' DEZENOVE');
  aRelDescUnids : Array [1..11] of byte = (3,2,1,3,2,1,3,2,1,2,1);   // Relações para determinar a linha da matriz aDescUnids
  aDescUnids : Array [1..11] of String = (' MILHÕES ', ' MILHÕES ', ' MILHÃO ', ' MIL ', ' MIL ', ' MIL ', 'REAIS', 'REAIS', 'REAL', ' CENTAVOS', ' CENTAVO');
  aPosicoesE : Array [1..11,1..2] of byte = ((1,2),(1,3),(4,5),(4,6),(7,8),(7,9),(10,11),(9,10),(2,3),(5,6),(8,9));
var
  sConst1,
  sConst2,
  sConst3,
  sConst4,
  sExpressao1,
  sExpressao2,
  sExpressao3,
  sExpressao4,
  sExpressao,
  sConstStr,
  sValorInt,
  sValorDec,
  sValorStr : String;
  iPonteiro,
  iFinal,
  iPosPonto,
  iTam,
  iInd : Integer;
  aTabN : Array [1..12] of String;
  aTabF : Array [1..12] of String;
begin
  iPonteiro := 0;
  iFinal    := 0;
  sValorStr := Format('%f',[rValor]);
  sValorStr := Copy('***.**',1,12 - Length(sValorStr))+sValorStr;
  for iInd := 1 to 12 do
  begin
    aTabN[iInd] := '*';
    aTabF[iInd] := '****';
  end;
  iPosPonto := Pos(',',sValorStr);
  sValorInt := Copy(sValorStr,1,iPosPonto-1);
  sValorDec := Copy(sValorStr,iPosPonto+1,2);
  sValorStr := sValorInt + sValorDec;
  iInd := 11;
  for iTam := Length(sValorStr) downto 0 do
  begin
    aTabN[iInd] := Copy(sValorStr,iTam,1);
    Dec(iInd);
  end;
  for iInd := 1 to 11 do
  begin
   if aTabN[iInd] = '0' then
      aTabN[iInd] :='*';
  end;
// Escolhe qual constante deve usar no extenso
  for iInd := 1 to 4 do
  begin
    case iInd of
      1 : begin
            iPonteiro :=11;
            iFinal :=10;
          end;
      2 : begin
            iPonteiro :=9;
            iFinal :=7;
          end;
      3 : begin
            iPonteiro :=6;
            iFinal :=4;
          end;
      4 : begin
            iPonteiro :=3;
            iFinal :=1;
          end;
    end;
    sConstStr := '';
    while iPonteiro >= iFinal do
    begin
      if aTabN[iPonteiro] <> '*' then
      begin
        sConstStr := aDescUnids[iPonteiro];
        if (aRelDescUnids[iPonteiro] = 1) and (aTabN[iPonteiro] <> '*') and (aTabN[iPonteiro] <> '1') then
          sConstStr := aDescUnids[iPonteiro-1];
      end;
      Dec(iPonteiro);
    end;
    case iFinal of
      10 : sConst4 := sConstStr;
       7 : sConst3 := sConstStr;
       4 : sConst2 := sConstStr;
       1 : sConst1 := sConstStr;
    end;
  end;
  if rValor > 1.99 then
    sConst3 := ' REAIS';
  // Monta o extenso do valor informado
  for iInd := 1 to 11 do
  begin
    iPonteiro := iInd;
    iFinal := iInd;
    sConstStr := '****';
    while iPonteiro <= iFinal do
    begin
      if aTabN[iPonteiro] <> '*' then
      begin
        sConstStr := aUnidades[StrToInt(aTabN[iPonteiro]), aRelDescUnids[iPonteiro]];
        if (aRelDescUnids[iPonteiro] = 1) and (aTabN[iPonteiro-1] = '1') then
        begin
          sConstStr := aOutrosNums[StrToInt(aTabN[iPonteiro])];
          aTabF[iPonteiro-1] := '****';
        end;
        if (aRelDescUnids[iPonteiro] = 3) and (aTabN[iPonteiro] = '1') then
          if (aTabN[iPonteiro+1] <> '') or (aTabN[iPonteiro+2] <> '') then
            sConstStr := ' CENTO';
      end;
      Inc(iPonteiro);
    end;
    aTabF[iFinal] := TrimLeft(sConstStr);
  end;
  // Colocar o artigo E no extenso
  for iInd := 1 to 8 do
  begin
    iPonteiro := aPosicoesE[iInd,1];
    iFinal := aPosicoesE[iInd,2];
    if (aTabF[iPonteiro] <> '***') and (aTabF[iFinal] <> '***') then
    begin
      aTabF[iFinal] := ' E '+aTabF[iFinal];
    end;
  end;
  iInd := 1;
  iTam := 9;
  while iInd <= 7 do
  begin
    if aTabF[iInd] = '****' then
    begin
      iPonteiro := aPosicoesE[iTam,1];
      iFinal := aPosicoesE[iTam,2];
      if (aTabF[iPonteiro] <> '***') and (aTabF[iFinal] <> '***') then
      begin
        aTabF[iFinal] := ' E '+aTabF[iFinal];
      end;
    end;
    Inc(iInd,3);
    Inc(iTam);
  end;
  for iInd := 1 to 11 do
  begin
    if aTabF[iInd] = '****' then
    begin
      aTabF[iInd] := '';
    end;
  end;
  sExpressao1 := aTabF[1]+aTabF[2]+aTabF[3]+sConst1;
  sExpressao2 := aTabF[4]+aTabF[5]+aTabF[6]+sConst2;
  sExpressao3 := aTabF[7]+aTabF[8]+aTabF[9]+sConst3;
  sExpressao4 := aTabF[10]+aTabF[11]+sConst4;
  if Copy(sExpressao4,1,1) <> ' ' then
    sExpressao4 := ' '+sExpressao4;
  sExpressao := TrimLeft(Trim(sExpressao1+sExpressao2+sExpressao3+sExpressao4));
  sExpressao := Separa(sExpressao,iQtdLinhas,sQtdCaracters);
  iInd := StrToInt(sQtdCaracters) - Length(sExpressao);
  sExpressao1 := Copy('*********************',1,iInd);
  sExpressao := sExpressao + sExpressao1;
  Result := sExpressao;
end;

Procedure Extenso2( Valor: String; Var Linha1, Linha2: String; TamPri, TamSeg: Integer);
Label 111, 222, 333, 444, 445;
Var Cruzeiro, Mil,  Milhao, Bilhao, Letra, Aux: String;
    Unidade: Array[1..9] Of String;
    Dezena: Array[1..10] Of String;
    Dezenas: Array[1..8] Of String;
    Centena: Array[1..9] Of String;
    Moeda: Array[1..6] Of String;
    Moedas: Array[1..6] Of String;
    E, De, Ext, Hum, Centavo: String;
    Tamanho, I, TamIni, Quantos: Integer;
    Primeira: Boolean;
Begin
  TamIni := TamPri;
  Quantos := 0;
  Cruzeiro := ''; Mil := ''; Milhao := ''; Bilhao := ''; Letra := ''; Aux := '';
  Unidade[1] := '-UM ';
  Unidade[2] := '-DOIS ';
  Unidade[3] := '-TRES ';
  Unidade[4] := '-QUA-TRO ';
  Unidade[5] := '-CIN-CO ';
  Unidade[6] := '-SEIS ';
  Unidade[7] := '-SE-TE ';
  Unidade[8] := '-OI-TO ';
  Unidade[9] := '-NO-VE ';
  Dezena[1] := '-DEZ ';
  Dezena[2] := '-ON-ZE ';
  Dezena[3] := '-DO-ZE ';
  Dezena[4] := '-TRE-ZE ';
  Dezena[5] := '-QUA-TOR-ZE ';
  Dezena[6] := '-QUIN-ZE ';
  Dezena[7] := '-DE-ZES-SE-IS ';
  Dezena[8] := '-DE-ZES-SE-TE ';
  Dezena[9] := '-DE-ZOI-TO ';
  Dezena[10] := '-DE-ZE-NO-VE ';
  Dezenas[1] := '-VIN-TE ';
  Dezenas[2] := '-TRIN-TA ';
  Dezenas[3] := '-QUA-REN-TA ';
  Dezenas[4] := '-CIN-QUEN-TA ';
  Dezenas[5] := '-SES-SEN-TA ';
  Dezenas[6] := '-SE-TEN-TA ';
  Dezenas[7] := '-OI-TEN-TA ';
  Dezenas[8] := '-NO-VEN-TA ';
  Centena[1] := '-CEM ';
  Centena[2] := '-DU-ZEN-TOS ';
  Centena[3] := '-TRE-ZEN-TOS ';
  Centena[4] := '-QUA-TRO-CEN-TOS ';
  Centena[5] := '-QUI-NHEN-TOS ';
  Centena[6] := '-SEIS-CEN-TOS ';
  Centena[7] := '-SE-TE-CEN-TOS ';
  Centena[8] := '-OI-TO-CEN-TOS ';
  Centena[9] := '-NO-VE-CEN-TOS ';
  Moeda[1] := '-CEN-TA-VO ';
  Moeda[2] := '-RE-AL ';
  Moeda[3] := '-MIL ';
  Moeda[4] := '-MI-LHAO ';
  Moeda[5] := '-BI-LHAO ';
  Moeda[6] := '-REAL ';
  Moedas[1] := '-CEN-TA-VOS ';
  Moedas[2] := '-RE-AIS ';
  Moedas[3] := '-MIL ';
  Moedas[4] := '-MI-LHOES ';
  Moedas[5] := '-BI-LHOES ';
  Moedas[6] := '-REAIS ';
  E := '-E ';
  De := '-DE ';
  Hum := '-HUM ';
  Ext := '';
  Valor := FormatFloat('000,000,000,000.00',StrToFloat(Valor));
  Centavo := Copy(Valor,17,2);
  Cruzeiro := Copy(Valor,13,3);
  Mil := Copy(Valor,9,3);
  Milhao := Copy(Valor,5,3);
  Bilhao := Copy(Valor,1,3);
  If Bilhao > '000' Then
  Begin
    If Bilhao = '001' Then
    Begin
      Ext := Ext + Hum;
      GoTo 111;
      Exit
    End;
    If Copy(Bilhao,1,1) > '1' Then
      Ext := Ext + Centena[StrToInt(Copy(Bilhao,1,1))]
    Else
    Begin
      If (Copy(Bilhao,1,1) = '1') And (Copy(Bilhao,2,2) > '00') Then Ext := Ext + '-CEN-TO ';
      If (Copy(Bilhao,1,1) = '1') And (Copy(Bilhao,2,2) = '00') Then Ext := Ext + '-CEM ';
    End;
    If (Copy(Bilhao,2,2) > '00') And (Copy(Bilhao,1,1) > '0') Then Ext := Ext + E;
    If (Copy(Bilhao,2,2) > '00') And (Copy(Bilhao,2,2) < '10') Then
    Begin
      Ext := Ext + Unidade[StrToInt(Copy(Bilhao,3,1))];
      GoTo 111;
      Exit
    End;
    If (Copy(Bilhao,2,2) > '09') And (Copy(Bilhao,2,2) < '20') Then
    Begin
      Ext := Ext + Dezena[StrToInt(Copy(Bilhao,2,2))-9];
      GoTo 111;
      Exit;
    End;
    If Copy(Bilhao,2,2) > '19' Then
      Ext := Ext + Dezenas[StrToInt(Copy(Bilhao,2,1)) - 1];
    If (Copy(Bilhao,2,1) > '1') And (Copy(Bilhao,3,1) > '0') Then
      Ext := Ext + E + Unidade[StrToInt(Copy(Bilhao,3,1))];
  End;
  111:
  If Bilhao > '000' Then
  Begin
    If Bilhao > '001' Then
      Ext := Ext + Moedas[5]
    Else
      Ext := Ext + Moeda[5];
    If (Mil < '001') And (Cruzeiro < '001') And (Milhao < '001') Then
      Ext := Ext + ' DE '
    Else
      Ext := Ext + '- E ';
  End;
  If Milhao > '000' Then
  Begin
    If (Milhao = '001') And (Bilhao = '000') Then
    Begin
      Ext := Ext + Hum;
      GoTo 222;
      Exit;
    End;
    If Copy(Milhao,1,1) > '1' Then
      Ext := Ext + Centena[StrToInt(Copy(Milhao,1,1))]
    Else
    Begin
      If (Copy(Milhao,1,1) = '1') And (Copy(Milhao,2,2) > '00') Then Ext := Ext + '-CEN-TO ';
      If (Copy(Milhao,1,1) = '1') And (Copy(Milhao,2,2) = '00') Then Ext := Ext + '-CEM ';
    End;
    If (Copy(Milhao,2,2) > '00') And (Copy(Milhao,1,1) > '0') Then Ext := Ext + E;
    If (Copy(Milhao,2,2) > '00') And (Copy(Milhao,2,2) < '10') Then
    Begin
      Ext := Ext + Unidade[StrToInt(Copy(Milhao,3,1))];
      GoTo 222;
      Exit
    End;
    If (Copy(Milhao,2,2) > '09') And (Copy(Milhao,2,2) < '20') Then
    Begin
      Ext := Ext + Dezena[StrToInt(Copy(Milhao,2,2))-9];
      GoTo 222;
      Exit;
    End;
    If Copy(Milhao,2,2) > '19' Then
      Ext := Ext + Dezenas[StrToInt(Copy(Milhao,2,1)) - 1];
    If (Copy(Milhao,2,1) > '1') And (Copy(Milhao,3,1) > '0') Then
      Ext := Ext + E + Unidade[StrToInt(Copy(Milhao,3,1))];
  End;
  222:
  If Milhao > '000' Then
  Begin
    If Milhao > '001' Then
      Ext := Ext + Moedas[4]
    Else
      Ext := Ext + Moeda[4];
    If (Mil < '001') And (Cruzeiro < '001') Then
      Ext := Ext + ' DE '
    Else
      If Bilhao >= '000' Then Ext := Ext + '- E ';
  End;
  If Mil > '000' Then
  Begin
    If (Mil = '001') And (Milhao = '000') And (Bilhao = '000') Then
    Begin
      Ext := Ext + Hum;
      GoTo 333;
      Exit;
    End;
    If Copy(Mil,1,1) > '1' Then
      Ext := Ext + Centena[StrToInt(Copy(Mil,1,1))]
    Else
    Begin
      If (Copy(Mil,1,1) = '1') And (Copy(Mil,2,2) > '00') Then Ext := Ext + '-CEN-TO ';
      If (Copy(Mil,1,1) = '1') And (Copy(Mil,2,2) = '00') Then Ext := Ext + '-CEM ';
    End;
    If (Copy(Mil,2,2) > '00') And (Copy(Mil,1,1) > '0') Then Ext := Ext + E;
    If (Copy(Mil,2,2) > '00') And (Copy(Mil,2,2) < '10') Then
    Begin
      Ext := Ext + Unidade[StrToInt(Copy(Mil,3,1))];
      GoTo 333;
      Exit;
    End;
    If (Copy(Mil,2,2) > '09') And (Copy(Mil,2,2) < '20') Then
    Begin
      Ext := Ext + Dezena[StrToInt(Copy(Mil,2,2))-9];
      GoTo 333;
      Exit;
    End;
    If Copy(Mil,2,2) > '19' Then
      Ext := Ext + Dezenas[StrToInt(Copy(Mil,2,1)) - 1];
    If (Copy(Mil,2,1) > '1') And (Copy(Mil,3,1) > '0') Then
      Ext := Ext + E + Unidade[StrToInt(Copy(Mil,3,1))];
  End;
  333:
  If Mil > '000' Then
  Begin
    Ext := Ext + Moeda[3];
    If (Milhao = '000') And (Bilhao = '000') And (Cruzeiro > '000') Then
      Ext := Ext + '- E '
    Else
    Begin
      If Cruzeiro > '000' Then Ext := Ext + '- E ';
      If Cruzeiro = '000' Then Ext := Ext + ' ';
    End;
  End;
  If Cruzeiro > '000' Then
  Begin
    If (Cruzeiro = '001') And (Mil = '000') And (Milhao = '000') And (Bilhao = '000') Then
    Begin
      Ext := Ext + Hum;
      GoTo 444;
      Exit
    End;
    If (Copy(Cruzeiro,1,1) = '1') And (Copy(Cruzeiro, 2,2) > '00') Then
      Ext := Ext + '-CEN-TO ' + E
    Else
    Begin
      If Copy(Cruzeiro,1,1) > '0' Then
      Begin
        Ext := Ext + Centena[StrToInt(Copy(Cruzeiro,1,1))];
        If Copy(Cruzeiro,2,2) > '00' Then Ext := Ext + E;
      End;
    End;
    If (Copy(Cruzeiro,2,2) > '00') And (Copy(Cruzeiro,2,2) < '10') Then
    Begin
      Ext := Ext + Unidade[StrToInt(Copy(Cruzeiro,3,1))];
      GoTo 444;
      Exit;
    End;
    If (Copy(Cruzeiro,2,2) > '09') And (Copy(Cruzeiro,2,2) < '20') Then
    Begin
      Ext := Ext + Dezena[StrToInt(Copy(Cruzeiro,2,2))-9];
      GoTo 444;
      Exit;
    End;
    If Copy(Cruzeiro,2,2) > '19' Then
      Ext := Ext + Dezenas[StrToInt(Copy(Cruzeiro,2,1)) - 1];
    If (Copy(Cruzeiro,2,1) > '1') And (Copy(Cruzeiro,3,1) > '0') Then
      Ext := Ext + E + Unidade[StrToInt(Copy(Cruzeiro,3,1))];
  End;
  444:
  If Cruzeiro > '001' Then
    Ext := Ext + Moedas[2]
  Else
  If (Milhao > '000') Or (Bilhao > '000') Or (Cruzeiro > '000') Or (Mil > '000') Then
    Ext := Ext + Moedas[2]
  Else
    Ext := Ext + Moeda[2];
  If (Milhao > '000') Or (Bilhao > '000') Or (Cruzeiro > '000') Or (Mil > '000') Then
    Ext := Ext
  Else
    Ext := '';
  If (Centavo = '001') And (Cruzeiro = '000') And (Mil = '000') And (Milhao = '000') And (Bilhao = '000') Then
  Begin
    Ext := Ext + Hum;
    GoTo 445;
  End;
  If (Bilhao > '000') Or (Milhao > '000') Or (Mil > '000') Or (Cruzeiro > '000') Then
    If Centavo > '00' Then Ext := Ext + '- E ';
  If (Centavo > '00') And (Centavo < '10') Then
    Ext := Ext + Unidade[StrToInt(Centavo)];
  If (Centavo > '09') And (Centavo < '20') Then
    Ext := Ext + Dezena[StrToInt(Copy(Centavo,2,1))+1];
  If Centavo > '19' Then
    Ext := Ext + Dezenas[StrToInt(Copy(Centavo,1,1)) - 1];
  If (Copy(Centavo,1,1) > '1') And (Copy(Centavo,2,1) > '0') Then
    Ext := Ext + E + Unidade[StrToInt(Copy(Centavo,2,1))];
  445:
  If Centavo = '01' Then
    Ext := Ext + Moeda[1];
  If Centavo > '01' Then
    Ext := Ext + Moedas[1];
// Retira os (-) do extenso
  Tamanho := Length(Ext);
  Primeira := True;
  For I := 0 To Tamanho - 1 Do
  Begin
    Letra := Copy(Ext,I,1);
    If (Letra = '-') And (Length(Linha1) + 4 >= TamPri) Then
    Begin
      If Primeira Then
       If Copy(Linha1,Length(Linha1),1) <> ' ' Then
         Linha1 := Linha1 + Letra;
      Primeira := False;
      TamPri := Length(Linha1);
    End;
    If (Length(Linha1) < TamPri) Then
    Begin
      If Letra <> '-' Then
        Linha1 := Linha1 + Letra;
    End
    Else
    Begin
      If Letra <> '-'  Then
        Linha2 := Linha2 + Letra;
    End;
  End;
  Aux := Trim(Linha1);
  Quantos := TamIni - Length(Aux);
  If Linha2 <> '' Then Linha1 := '';
  If (Length(Aux) < TamIni) And (Linha2 <> '') Then
    For I := 1 To TamIni Do
    Begin
      Letra := Copy(Aux,I,1);
      Linha1 := Linha1 + Copy(Aux,I,1);
      If Quantos > 0 Then
      Begin
        If Letra = ' ' Then
        Begin
          Linha1 := Linha1 + ' ';
          Quantos := Quantos - 1;
        End;
      End;
    End;
  If Length(Linha1) <= TamPri Then
    For I := Length(Linha1) To TamPri Do
      If Linha2 = '' Then Linha1 := Linha1 + '*';
  If Length(Linha2) <= TamSeg Then
    For I := Length(Linha2) To TamSeg - 1 Do
      Linha2 := Linha2 + '*';
  Exit;
End;

end.
