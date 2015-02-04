unit uquerySqlServer;

interface

uses   Data.SqlExpr, System.SysUtils, uIquery, Data.Win.AdoDb;

Type TquerySQLServer = class( Tquery )
private
  qry               :TADOQuery;
  trans             :TTransactionDesc;
public

  procedure   startTransaction;     override;
  procedure   commitTransaction;    override;
  procedure   rollBackTransaction;  override;
  Constructor Create( Connection :TADOConnection );
  Destructor  Destroy; override;
  function    executaQuery(sql :string):Boolean;  override;
  function    trataMsgErro(erro :String):string;  override;

 ///  <summary>Busca o valor de um generator  </summary>
 ///  <param name="nameGen"> Nome do generator </param>
 ///  <param name="incQtd">  quantidade a ser incrementada </param>
 ///  <returns> um inteiro com o valor do generator </returns>
 ///  <remarks></remarks>
 ///  <exception cref="EIOErro"></exception>
  function    getValueGenerator( nameGen :String; incQtd :Integer ):Integer;

end;

implementation

{ Tquery }


procedure TquerySQLServer.commitTransaction;
begin
  qry.Connection.CommitTrans();  // comita no bamco
end;

constructor TquerySQLServer.Create( Connection :TADOConnection );
// recebe como parametro a conexao com o bamco
begin
  qry               := TADOQuery.Create(nil);
  qry.Connection    :=  Connection;
end;

destructor TquerySQLServer.Destroy;
begin
   qry.Free;
  inherited;
end;

{------------------------------------------------------------------------------}
function TquerySQLServer.executaQuery(sql: string): Boolean;
{ Executa uma query no banco de dados
  input   = comando sql
  output  = True caso operação com sucesso ou False caso ouver algum erro
}
var
  qr     : string;
begin

 // caso gerenciar a trans s automatico
  if autoTransaction then
    startTransaction;

  qr := sql;

  with qry do
  begin
    Close;
    SQL.Clear;
    SQL.Add(  qr );


    try
       ExecSQL;
       Result  := True;

       if autoTransaction then
         commitTransaction;

    except
      on E:Exception do
      begin
       msgError := trataMsgErro( E.Message );
       Result    := False;

       if autoTransaction then
        rollBackTransaction;

      end;
    end;

  end;

end;

function TquerySQLServer.getValueGenerator(nameGen: String; incQtd: Integer): Integer;
{: retorna o valor de uma generator }
begin


  with qry do
  begin

    Close;
    SQL.Clear;
    SQL.Add(' SELECT GEN_ID('+nameGen+','+inttostr( incQtd )+') FROM RDB$DATABASE ');

     try

        Open;
        Result :=  qry.fieldbyname('GEN_ID').AsInteger;
      except
      on E:exception do
       begin
         Result     := -1;
         msgError  := E.Message;
       end;
      end;

  end;

end;

procedure TquerySQLServer.rollBackTransaction;
begin
 //  qry.SQLConnection.Rollback( trans );
end;

procedure TquerySQLServer.startTransaction;
begin
     trans.IsolationLevel := xilREADCOMMITTED;
 //    qry.SQLConnection.StartTransaction( trans );   // inicia a transação
end;

function TquerySQLServer.trataMsgErro(erro: String): string;
{: trata as menssgens de erro do bamco }
begin

   if (Pos('FOREIGN KEY', UpperCase (erro)) <> 0) then begin
       Result :=   'Atenção !!!'+#13+#10 +
                   'Este registro não pode ser excluído,'+#13+#10 +
                   'pois outra(s) tabela(s) do sistema está se referenciado a ele.';
   end
    else
    if (Pos('PRIMARY OR UNIQUE KEY', UpperCase (erro)) <> 0) then
    begin
        Result :=   'Atenção !!!'+#13+#10 +
                   'Este registro não pode ser cadastrado ,'+#13+#10 +
                   'pois já existe outro registro no sitema com os mesmos campos chaves.';
    end
     else  // se não achar retorna o erro
      Result := erro;


end;

end.

