unit uAttributes;

interface

type

 TautoInc = (AutoIncrement, None);

   // atributo que define o nome da tabela
  TableName = class(TCustomAttribute)
  private
    FName: String;
    procedure SetName(const Value: String);
  public
    constructor Create(strName: String);
    property Name: String read FName write SetName;
  end;

  // atributo que define o nome do campo
  FieldName = class(TCustomAttribute)
  private
    FName: String;
    procedure SetName(const Value: String);
  public
    constructor Create(strName: String);
    property Name: String read FName write SetName;
  end;

  // define o nome da chave primaria
  PrimaryKey = class(TCustomAttribute)
  private
    FName:    String;
    FautoInc: String;
    procedure SetName(const Value: String);
    procedure SetAutoInc(const value :String);
  public
    constructor Create(strName: String; autoINc :String);
    property Name:    String   read FName    write SetName;
    property AutoInc: String   read FautoInc write SetAutoInc;
  end;

  TableForeignName = class(TCustomAttribute)
  private
    FName: String;
    procedure SetName(const Value: String);
  public
    constructor Create(strName: String);
    property Name: String read FName write SetName;
  end;

  FieldForeignName = class(TCustomAttribute)
  private
    FName: String;
    procedure SetName(const Value: String);
  public
    constructor Create(strName: String);
    property Name: String read FName write SetName;
  end;

  ForeignKey = class(TCustomAttribute)
  private
    FName: String;
    procedure SetName(const Value: String);
  public
    constructor Create(strName: String);
    property Name: String read FName write SetName;
  end;

  ForeignKeyName = class(TCustomAttribute)
  private
    FName: String;
    procedure SetName(const Value: String);
  public
    constructor Create(strName: String);
    property Name: String read FName write SetName;
  end;

implementation

{ TableName }

constructor TableName.Create(strName: String);
begin
  FName := strName;
end;

procedure TableName.SetName(const Value: String);
begin
  FName := Value;
end;

{ FieldName }

constructor FieldName.Create(strName: String);
begin
  FName := strName;
end;

procedure FieldName.SetName(const Value: String);
begin
  FName := Value;
end;

{ PrimaryKey }

constructor PrimaryKey.Create(strName: String; autoInc :String);
begin
  FName     := strName;
  FautoInc  := autoInc;
end;

procedure PrimaryKey.SetAutoInc(const value: String);
begin
 FautoInc := value;
end;

procedure PrimaryKey.SetName(const Value: String);
begin
  FName := Value;
end;

{ TTableForeignName }

constructor TableForeignName.Create(strName: String);
begin
  FName := strName;
end;

procedure TableForeignName.SetName(const Value: String);
begin
  FName := Value;
end;

{ FieldForeignName }

constructor FieldForeignName.Create(strName: String);
begin
  FName := strName;
end;

procedure FieldForeignName.SetName(const Value: String);
begin
  FName := Value;
end;

{ ForeignKey }

constructor ForeignKey.Create(strName: String);
begin
  FName := strName;
end;

procedure ForeignKey.SetName(const Value: String);
begin
  FName := Value;
end;

{ ForeignKeyName }

constructor ForeignKeyName.Create(strName: String);
begin
  FName := strName;
end;

procedure ForeignKeyName.SetName(const Value: String);
begin
  FName := Value;
end;

end.

