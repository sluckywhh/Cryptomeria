unit CryptoSetAES;

interface

uses TPLB3.CryptographicLibrary, TPLB3.Codec;

type
  ICryptoSetAES = interface
    ['{437E3DD7-21EC-4674-8A7F-1699B8D08CCE}']
    function GetCodec: TCodec;
    property Codec: TCodec read GetCodec;
  end;

  TCryptoSetAES = class(TInterfacedObject, ICryptoSetAES)
  private
    FCryptographicLibrary: TCryptographicLibrary;
    FCodec: TCodec;
  public const
    DefaultKeySize = 256;
  public
    function GetCodec: TCodec;
    property Codec: TCodec read GetCodec;

    constructor Create(AKeySize: integer = DefaultKeySize);
    destructor Destroy; override;
  end;

implementation

uses System.SysUtils, TPLB3.Constants, TPLB3.Random, Logger;

{ TCryptoSetAES }

constructor TCryptoSetAES.Create(AKeySize: integer = DefaultKeySize);
begin
  inherited Create;

  TRandomStream.Instance.Randomize();
  FCryptographicLibrary := TCryptographicLibrary.Create(nil);
  try
    FCodec := TCodec.Create(nil);
    try
      FCodec.CryptoLibrary := FCryptographicLibrary;
      FCodec.StreamCipherId := BlockCipher_ProgId;
      FCodec.BlockCipherId := Format(AES_ProgId, [AKeySize]);
      FCodec.ChainModeId := CBC_ProgId;
    except
      FreeAndNil(FCodec);
    end;
  except
    FreeAndNil(FCryptographicLibrary);
  end;
end;

destructor TCryptoSetAES.Destroy;
begin
  if FCodec <> nil then
    FreeAndNil(FCodec)
  else
    TLogger.LogError('FCodec = nil');

  if FCryptographicLibrary <> nil then
    FreeAndNil(FCryptographicLibrary)
  else
    TLogger.LogError('FCryptographicLibrary = nil');

  inherited;
end;

function TCryptoSetAES.GetCodec: TCodec;
begin
  Assert(FCodec <> nil);
  Result := FCodec;
end;

end.
