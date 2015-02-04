unit uIquery;

interface

uses System.SysUtils;

// Interface do Dao que deve ser implementado pelo Dao especifico
Type IQuery = Interface
  procedure   startTransaction;
  procedure   commitTransaction;
  procedure   rollBackTransaction;
  function    executaQuery( sql :string  ):Boolean;
  function    trataMsgErro( erro :String ):string;
End;

Type Tquery = class(TInterfacedObject, Iquery )
private

  FmsgError         :string;
  FautoTransacation :Boolean;

public

  property msgError        :string  read FmsgError         write FmsgError;
  property autoTransaction :Boolean read FautoTransacation write FautoTransacation;

  procedure   startTransaction;     virtual; abstract;
  procedure   commitTransaction;    virtual; abstract;
  procedure   rollBackTransaction;  virtual; abstract;
  function    executaQuery(sql :string)  :Boolean;  virtual; abstract;
  function    trataMsgErro(erro :String) :string;   virtual; abstract;

 ///  <summary>Busca o valor de um generator  </summary>
 ///  <param name="nameGen"> Nome do generator </param>
 ///  <param name="incQtd">  quantidade a ser incrementada </param>
 ///  <returns> um inteiro com o valor do generator </returns>
 ///  <remarks></remarks>
 ///  <exception cref="EIOErro"></exception>
  function    getValueGenerator( nameGen :String; incQtd :Integer ):Integer;  virtual; abstract;


end;

implementation

{ Tquery }




end.

