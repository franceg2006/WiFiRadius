object DM_WiFi: TDM_WiFi
  OldCreateOrder = False
  Height = 692
  Width = 1178
  object dsGrupo: TDataSource
    DataSet = FDQGrupo
    Left = 128
    Top = 104
  end
  object FDQGrupo: TFDQuery
    Connection = FD_Connect_WiFi
    FormatOptions.AssignedValues = [fvDefaultParamDataType]
    FormatOptions.DefaultParamDataType = ftString
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    SQL.Strings = (
      'select*'
      'from radusergroup')
    Left = 128
    Top = 38
    object FDQGrupousername: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'username'
      Origin = 'username'
      Size = 64
    end
    object FDQGrupogroupname: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'groupname'
      Origin = 'groupname'
      Size = 64
    end
    object FDQGrupopriority: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'priority'
      Origin = 'priority'
    end
  end
  object dsUserSenha: TDataSource
    DataSet = FDQUser_Senha
    Left = 200
    Top = 104
  end
  object DsFunc: TDataSource
    DataSet = FDQFunc
    Left = 280
    Top = 104
  end
  object FDQFunc: TFDQuery
    Connection = FD_Connect_WiFi
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    SQL.Strings = (
      'select *'
      'from funcionario')
    Left = 280
    Top = 40
    object FDQFunccodigo: TIntegerField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDQFuncnome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 80
    end
    object FDQFunccpf: TStringField
      FieldName = 'cpf'
      Origin = 'cpf'
      Required = True
      Size = 14
    end
    object FDQFuncsenha: TStringField
      FieldName = 'senha'
      Origin = 'senha'
      Required = True
      Size = 6
    end
    object FDQFunctipo: TStringField
      FieldName = 'tipo'
      Origin = 'tipo'
      Required = True
      Size = 1
    end
    object FDQFuncstatus: TStringField
      FieldName = 'status'
      Origin = 'status'
      Required = True
      Size = 1
    end
    object FDQFuncrg: TStringField
      FieldName = 'rg'
      Origin = 'rg'
      Required = True
      Size = 14
    end
    object FDQFuncendereco: TStringField
      FieldName = 'endereco'
      Origin = 'endereco'
      Required = True
      Size = 200
    end
    object FDQFuncdata: TDateField
      FieldName = 'data'
      Origin = 'data'
      Required = True
    end
  end
  object sqlRadusergroup: TFDCommand
    Connection = FD_Connect_WiFi
    CommandText.Strings = (
      'DELETE FROM radusergroup')
    Left = 416
    Top = 40
  end
  object sqlRadcheck: TFDCommand
    Connection = FD_Connect_WiFi
    CommandText.Strings = (
      'DELETE FROM radcheck')
    Left = 496
    Top = 40
  end
  object sqlID: TFDQuery
    Connection = FD_Connect_WiFi
    SQL.Strings = (
      'SELECT max(id)'
      'FROM radcheck')
    Left = 568
    Top = 40
    object sqlIDmaxid: TLongWordField
      AutoGenerateValue = arDefault
      FieldName = 'max(id)'
      Origin = '`max(id)`'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object FDQUser_Senha: TFDQuery
    Connection = FD_Connect_WiFi
    FormatOptions.AssignedValues = [fvDefaultParamDataType]
    FormatOptions.DefaultParamDataType = ftString
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    SQL.Strings = (
      'select *'
      'from radcheck')
    Left = 200
    Top = 40
    object FDQUser_Senhaid: TFDAutoIncField
      AutoGenerateValue = arNone
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ServerAutoIncrement = False
      AutoIncrementSeed = 1
      AutoIncrementStep = 1
      IdentityInsert = True
    end
    object FDQUser_Senhausername: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'username'
      Origin = 'username'
      Size = 64
    end
    object FDQUser_Senhaattribute: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'attribute'
      Origin = 'attribute'
      Size = 64
    end
    object FDQUser_Senhaop: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'op'
      Origin = 'op'
      FixedChar = True
      Size = 2
    end
    object FDQUser_Senhavalue: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'value'
      Origin = 'value'
      Size = 253
    end
  end
  object sqlCod_func: TFDQuery
    Connection = FD_Connect_WiFi
    SQL.Strings = (
      'select max(codigo) as codigo'
      'from funcionario')
    Left = 720
    Top = 40
  end
  object sqlData: TFDQuery
    Connection = FD_Connect_WiFi
    SQL.Strings = (
      'SELECT curdate() AS DATA')
    Left = 720
    Top = 104
  end
  object FD_Connect_WiFi: TFDConnection
    Params.Strings = (
      'Database=radius'
      'User_Name=root'
      'Password=lizard1240king'
      'Server=192.168.0.250'
      'DriverID=MySQL')
    LoginPrompt = False
    BeforeConnect = FD_Connect_WiFiBeforeConnect
    Left = 40
    Top = 30
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Sistemas\SIS_Wifi-XE8\libmysql.dll'
    Left = 72
    Top = 224
  end
  object FD_conecta_WiFiII: TFDConnection
    Params.Strings = (
      'Database=radius'
      'User_Name=root'
      'Password=lizard1230king'
      'Server=192.168.0.249'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 40
    Top = 105
  end
end
