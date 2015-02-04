unit uMappingObject;

interface

uses uAttributes, Data.FMTBcd, Data.DB, Data.SqlExpr,
  System.SysUtils, uQueryFirebird, uIQuery, Data.Win.ADODB, uQuerySqlServer;

type

  IPersistencia = Interface  // interface
    function Insert(Obj: TObject): Boolean;
    function Update(Obj: TObject): Boolean;
    function Delete(Obj: TObject): Boolean;
    function Select(Obj: TObject): Boolean;
  End;


  TMappingObject = class( TInterfacedObject, IPersistencia )
  private
   FmsgError  :string;
  public

   Dao        :Tquery;

    Constructor Create( Connection :TSQLConnection ); overload;
    Constructor Create( Connection :TADOConnection ); overload;
    Destructor  Destroy;Override;

    property msgError :string read FmsgError write FmsgError;

   // implementa a interface
    function Insert(Obj: TObject): Boolean;
    function Update(Obj: TObject): Boolean;
    function Delete(Obj: TObject): Boolean;
    function Select(Obj: TObject): Boolean;
  end;

implementation
uses
  RTTI;

{ TMappingObject }

constructor TMappingObject.Create( Connection :TSQLConnection);
{: Construtor para firebird }
begin
  Dao  := TqueryFB.Create( Connection );
end;

constructor TMappingObject.Create(Connection: TADOConnection);
{: Construtor para Sql Server }
begin
 Dao := TquerySQLServer.Create( Connection );
end;

function TMappingObject.Delete(Obj: TObject): Boolean;
var
  ctx: TRttiContext;
  RTT: TRttiType;
  RTP: TRttiProperty;
  ATT: TCustomAttribute;
  strSql, strWhere: String;
  firstWhere :Boolean;
begin
  firstWhere := True;

  try
    ctx := TRttiContext.Create;
    RTT := ctx.GetType(Obj.ClassType);

    // pegando o nome da tabela
    for ATT in RTT.GetAttributes do
    begin
      if ATT is TableName then
        strSql := 'DELETE FROM ' + TableName(ATT).Name;
    end;

    // pegando os nomes dos campos
    for RTP in RTT.GetProperties do
    begin
      for ATT in RTP.GetAttributes do
      begin
        if ATT is PrimaryKey then
        begin

          if firstWhere then
          begin
             strWhere := ' WHERE ' + PrimaryKey(ATT).Name + ' = ''' +
             RTP.GetValue(Obj).ToString+ ''' ';
             firstWhere := False;
          end
           else
            begin
             strWhere := strWhere +' AND ' + PrimaryKey(ATT).Name + ' = ''' +
             RTP.GetValue(Obj).ToString+ ''' ';
            end;

        end;
      end;
    end;

    strSql := strSql + strWhere;

     Result := Dao.executaQuery(strSql);

     if Result = False then
       msgError := Dao.msgError;

  finally
    ctx.Free;
  end;
end;

destructor TMappingObject.Destroy;
begin
  FreeAndNil(Dao);
  inherited;
end;

function TMappingObject.Insert(Obj: TObject): Boolean;
{ Input   = Um ojeto do delphi
  OutPut  = Retorna True caso inserir no banco, ou  False caso ocorra um erro }
var
  ctx: TRttiContext;
  RTT: TRttiType;
  RTP: TRttiProperty;
  ATT: TCustomAttribute;
  strSql, strField, strValue: String;
  valor :string;
  vlrformatado :String;
begin

  try

    ctx := TRttiContext.Create;
    RTT := ctx.GetType(Obj.ClassType);

    // pegando o nome da tabela
    for ATT in RTT.GetAttributes do
    begin
      if ATT is TableName then
        strSql := 'INSERT INTO ' + TableName(ATT).Name;
    end;

    // pegando os nomes dos campos
    for RTP in RTT.GetProperties do
    begin

      for ATT in RTP.GetAttributes do
      begin

        if ATT IS PrimaryKey then
        begin

         // caso seja autoIncrement nao joga no insert
         if PrimaryKey(ATT).AutoInc  = 'AI' then
         begin
            strField := '';
            strValue := '';
         end
          else
           begin
            strField := strField + PrimaryKey(ATT).Name + ', ';

            if RTP.PropertyType.Name = 'TDate' then
               vlrformatado := FormatDateTime('dd.mm.yyyy', RTP.GetValue(Obj).AsType<TDate> )
            else if RTP.PropertyType.Name = 'TDateTime'  then
               vlrformatado := FormatDateTime('dd.mm.yyyy hh:mm:ss', RTP.GetValue(Obj).AsType<TDateTime> )
             else
              vlrformatado :=  RTP.GetValue(Obj).ToString;

            strValue := strValue + QuotedStr(vlrformatado) + ', ';
           end;

        end
        else if ATT is FieldName then
        begin
          begin

            valor :=  RTP.GetValue(Obj).ToString;

            if valor <> '' then // caso for string vazia
            begin

              strField := strField + FieldName(ATT).Name + ', ';

              // se for Tdate formata no padrao do firebird
              if RTP.PropertyType.Name = 'TDate' then
                  vlrformatado := FormatDateTime('dd.mm.yyyy', RTP.GetValue(Obj).AsType<TDate> )
               else if RTP.PropertyType.Name = 'TDateTime'  then
                  vlrformatado := FormatDateTime('dd.mm.yyyy hh:mm:ss', RTP.GetValue(Obj).AsType<TDateTime> )
               else
                if RTP.PropertyType.Name = 'Double' then // ser for Float formata tira a virgula
                  vlrformatado :=  StringReplace(valor,  ',', '.', [rfReplaceAll] )
                 else
                  vlrformatado := valor;

              strValue := strValue + QuotedStr( vlrformatado ) + ', ';

            end;

          end;
        end;
      end;
    end;

    strField := Copy(strField, 1, Length(strField) - 2);
    strValue := Copy(strValue, 1, Length(strValue) - 2);

    strSql := strSql + '(' + strField + ') VALUES (' + strValue + ')';

    Result := Dao.executaQuery(strSql);

     if Result = False then
       FmsgError := Dao.msgError;

  finally
    ctx.Free;
  end;

end;

function TMappingObject.Select(Obj: TObject): Boolean;
var
  ctx: TRttiContext;
  RTT: TRttiType;
  RTP: TRttiProperty;
  ATT: TCustomAttribute;
  strSql, strField, strInner, strWhere: String;
begin
  try
    ctx := TRttiContext.Create;
    RTT := ctx.GetType(Obj.ClassType);

    strSql := 'SELECT ';
    // pegando os nomes dos campos
    for RTP in RTT.GetProperties do
    begin
      for ATT in RTP.GetAttributes do
      begin
        if ATT is FieldName then
        begin
          strField := strField +' '+FieldName(ATT).Name + ', ';
        end
      end;
    end;

    strSql := strSql + Copy(strField, 1, Length(strField) - 1);

    // pegando o nome da tabela
    for ATT in RTT.GetAttributes do
    begin
      if ATT is TableName then
      begin
        strSql := strSql + ' FROM '+TableName(ATT).Name;
      end;
    end;

    // pegando o nome da tabela estrangeira
    for RTP in RTT.GetProperties do
    begin
      for ATT in RTP.GetAttributes do
      begin
        if ATT is TableForeignName then
          strInner := ' INNER JOIN '+TableForeignName(ATT).Name +' ON('
      end;
    end;

    // pegando os campos associados com as chaves
    for RTP in rtt.GetProperties do
    begin
      for ATT in RTP.GetAttributes do
      begin
        if att is ForeignKeyName then
          strInner := strInner +ForeignKeyName(ATT).Name
        else if ATT is ForeignKey then
          strInner := strInner +' = ' + ForeignKey(ATT).Name +')';
      end;
    end;

    // pegando o campo Primary key
    for RTP in RTT.GetProperties do
    begin
      for ATT in RTP.GetAttributes do
      begin
        if ATT is PrimaryKey then
        begin
          strWhere := ' WHERE 1 = 1 ORDER BY ' + PrimaryKey(ATT).Name;
        end;
      end;
    end;

    strSql := strSql + strInner + strWhere;
    Result := Dao.executaQuery(strSql);
  finally
    ctx.Free;
  end;
end;

 function TMappingObject.Update(Obj: TObject): Boolean;
var
  ctx: TRttiContext;
  RTT: TRttiType;
  RTP: TRttiProperty;
  ATT: TCustomAttribute;
  strSql, strField, strWhere: String;
  valor        :string;
  vlrFormatado :string;
  firstWhere   :Boolean;
begin

  firstWhere := True;

  try
    ctx := TRttiContext.Create;
    RTT := ctx.GetType(Obj.ClassType);

    // pegando o nome da tabela
    for ATT in RTT.GetAttributes do
    begin
      if ATT is TableName then
        strSql := 'UPDATE ' + TableName(ATT).Name + ' SET ';
    end;

    for RTP in RTT.GetProperties do
    begin
      for ATT in RTP.GetAttributes do
      begin
        if ATT IS PrimaryKey then
          strField := ''
        else
         if ATT is FieldName then
         begin

           valor := QuotedStr(RTP.GetValue(Obj).ToString);

       //    if valor <> '''''' then
        //   begin
             // caso for data formata para o padrão do firebird
             if RTP.PropertyType.Name = 'TDate' then
                vlrFormatado :=  QuotedStr(FormatDateTime('dd.mm.yyyy', RTP.GetValue(Obj).AsType<TDate> )  )
              else
               if RTP.PropertyType.Name = 'Double' then // ser for Float formata tira a virgula
                  vlrformatado :=  StringReplace(valor,  ',', '.', [rfReplaceAll] )
              else
                vlrFormatado  := valor;

              strField := strField + FieldName(ATT).Name + ' = ' + vlrFormatado + ', ';

          // end;

         end;
      end;
    end;

    strField := Copy(strField, 1, Length(strField) - 2);
    // pegando o campo PrimaryKey
    for RTP in RTT.GetProperties do
    begin
      for ATT in RTP.GetAttributes do
      begin
        if ATT is PrimaryKey then
        begin

         if firstWhere then
         begin
            strWhere   := ' WHERE ' + PrimaryKey(ATT).Name + ' = ''' + RTP.GetValue(Obj).ToString+''' ';
            firstWhere := False;
         end
          else
           begin
            strWhere   := strWhere +' AND ' + PrimaryKey(ATT).Name + ' = ''' + RTP.GetValue(Obj).ToString+''' ';
           end;

        end;
      end;
    end;

   strSql := strSql + strField + strWhere;


   Result := Dao.executaQuery(strSql);

     if Result = False then
       FmsgError := Dao.msgError;

  finally
    ctx.Free;
  end;
end;


end.

