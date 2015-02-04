unit uPersistController;
// Classe abstrata deve ser implementada pelos controllers


interface

uses uMappingObject,uMenssagens, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics, uEnumComums,
  uValida, Data.DBXFirebird, Data.DB, Data.SqlExpr, DBXCommon, Data.FMTBcd;

type

  IPersistDados = Interface  // interface
    function PersisteDados(Obj: TObject): Boolean;
    function ExcluirRegistro(Obj: TObject): Boolean;
  End;

 // Implementa a interface
 TpersistDados = class( TInterfacedObject, IPersistDados )
private

 // para obter as messgens de erro
 FmsgError : string;

protected

 qrGeral   : TSQLQuery;
 contexto  : TMappingObject; // Contexto do ORM

 // Metodos Abastratos
 function PersisteDados(Obj: TObject): Boolean;   Virtual;
 function ExcluirRegistro(Obj: TObject): Boolean; Virtual;

public


  operacao   :TOperacao;  // Identifica o tipo da operação
  property    msgError :string read FmsgError write FmsgError;


  Constructor Create;
  Destructor  Destroy;Override;

end;


implementation

{ TpersistController }

uses uDmPrincipal;

constructor TpersistDados.Create;
begin
   contexto := TMappingObject.Create( dmPrincipal.conSindata ); // classe do framework de persistencia
   qrGeral  := TSQLQuery.Create(nil);
   qrGeral.SQLConnection := dmPrincipal.conSindata;
end;

destructor TpersistDados.Destroy;
begin
    FreeAndNil(qrGeral);
    FreeAndNil(contexto);
  inherited;
end;

function TpersistDados.ExcluirRegistro(Obj: TObject): Boolean;
{: metodo de exclusão de um objeto }
begin

     if contexto.Delete( Obj ) then
         Result := True
     else
      begin
         Result     := False;
         FmsgError  := contexto.msgError;
      end;

end;

function TpersistDados.PersisteDados(Obj: TObject): Boolean;
begin

  // realiza a persistencia do objetos tando Inserir como Alterar

   if operacao = tpOpInsert  then   // inserindo
  begin

      if contexto.Insert( Obj ) then
         Result := True
      else
       begin
         Result     := False;
         FmsgError  := contexto.msgError;
       end;

  end
   else   // atualizando
    begin

       if  contexto.Update( Obj ) then
          Result := True
       else
        begin
          Result    := False;
          FmsgError := contexto.msgError;
        end;

    end;



end;

end.
