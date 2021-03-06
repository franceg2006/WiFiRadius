object DM: TDM
  OldCreateOrder = False
  Height = 542
  Width = 932
  object FDC_GradEAD: TFDConnection
    Params.Strings = (
      'Protocol=TCPIP'
      'Database=/bds/ead/SGA_6.FDB'
      'User_Name=WIFI_USER'
      'Password=djah28$21'
      'Server=172.16.0.83'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 40
    Top = 32
  end
  object FDQGradEAD: TFDQuery
    Connection = FDC_GradEAD
    SQL.Strings = (
      'select distinct c.rgm, a.senha from matricula m '
      'inner join turma t on (t.id = m.turma) '
      'inner join contrato c on (c.id = m.contrato) '
      'inner join aluno a on (a.id = c.aluno)'
      'where m.status = '#39'A'#39' and t.ano >= 20211')
    Left = 40
    Top = 88
    object FDQGradEADRGM: TWideStringField
      FieldName = 'RGM'
      Origin = 'RGM'
    end
    object FDQGradEADSENHA: TWideStringField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      Size = 50
    end
  end
  object DsGradEAD: TDataSource
    DataSet = FDQGradEAD
    Left = 40
    Top = 144
  end
  object FDC_Colegio: TFDConnection
    Params.Strings = (
      'Database=/bds/Anglo/Anglo_2022.gdb'
      'User_Name=SYSDBA'
      'Protocol=TCPIP'
      'Server=172.16.0.78'
      'Password=plkh%321'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 112
    Top = 32
  end
  object FDQ_Colegio: TFDQuery
    Active = True
    Connection = FDC_Colegio
    SQL.Strings = (
      'SELECT codigo, senha'
      'FROM alunos')
    Left = 112
    Top = 88
    object FDQ_ColegioCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDQ_ColegioSENHA: TStringField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      Size = 10
    end
  end
  object Ds_Colegio: TDataSource
    DataSet = FDQ_Colegio
    Left = 112
    Top = 144
  end
  object FDC_GradPres: TFDConnection
    Params.Strings = (
      'Database=/bancos/presencial/academico_db.fdb'
      'Server=172.16.0.77'
      'Protocol=TCPIP'
      'User_Name=USER_WIFI'
      'Password=shd3821'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 192
    Top = 35
  end
  object FDQ_GradPres: TFDQuery
    Connection = FDC_GradPres
    SQL.Strings = (
      'SELECT DISTINCT RGM.RGM, ALN.SENHA'
      'FROM ALUNOS ALN'
      'JOIN CONTRATO CNT ON (CNT.ALN_ID = ALN.ALN_ID)'
      'JOIN MATRICULAS MTR ON (MTR.CNT_ID = CNT.CNT_ID)'
      
        'JOIN TES_CURSO_DET CRD ON (CRD.CRD_ID = MTR.CRD_ID AND CRD.PERIO' +
        'DO <> '#39'S'#39')'
      'JOIN CURSOS CRS ON (CRS.CRS_ID = CNT.CRS_ID AND CRS.CRT_ID = 1)'
      
        'JOIN RGMS RGM ON (RGM.CNT_ID = CNT.CNT_ID AND RGM.CRD_ID = MTR.C' +
        'RD_ID)'
      'JOIN SEC_CONFIG CFG ON 1=1'
      'WHERE MTR.ANO = CFG.ANO_ATUAL AND MTR.SIT_ID = 1')
    Left = 192
    Top = 88
    object FDQ_GradPresRGM: TStringField
      FieldName = 'RGM'
      Origin = 'RGM'
      Required = True
      Size = 10
    end
    object FDQ_GradPresSENHA: TStringField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      Size = 6
    end
  end
  object Ds_GradPres: TDataSource
    DataSet = FDQ_GradPres
    Left = 192
    Top = 147
  end
  object FDC_PosEAD: TFDConnection
    Params.Strings = (
      'Database=/bds/posead/posdistancia.fdb'
      'Server=172.16.0.83'
      'User_Name=WIFI_USER'
      'Password=djah28$21'
      'Protocol=TCPIP'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 368
    Top = 36
  end
  object FDQ_PosEAD: TFDQuery
    Connection = FDC_PosEAD
    SQL.Strings = (
      'select    distinct c.rgm  , aluno.senha'
      'from'
      ' matricula'
      'join'
      ' contrato c on (matricula.contrato = c.id)'
      'join'
      ' aluno on (aluno.id = c.aluno)'
      'join'
      ' turma on (matricula.turma = turma.id)'
      'where    matricula.status = '#39'A'#39
      'and'
      ' (turma.ano = extract(year from current_date)'
      'or'
      ' turma.ano = (extract(year from current_date)-1))'
      'and'
      ' c.curso <> '#39'600'#39)
    Left = 368
    Top = 88
    object FDQ_PosEADRGM: TStringField
      FieldName = 'RGM'
      Origin = 'RGM'
      Size = 15
    end
    object FDQ_PosEADSENHA: TStringField
      FieldName = 'SENHA'
      Origin = 'SENHA'
      Size = 50
    end
  end
  object Ds_PosEAD: TDataSource
    DataSet = FDQ_PosEAD
    Left = 368
    Top = 148
  end
  object Ds_PosPresDdos: TDataSource
    DataSet = FDQ_PosPresDdos
    Left = 448
    Top = 152
  end
  object FDC_PosPresDdos: TFDConnection
    Params.Strings = (
      'Database=/bancos/presencial/pos_presencial.fdb'
      'Server=172.16.0.77'
      'User_Name=USER_POS'
      'Password=vfk_19212'
      'Protocol=TCPIP'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 456
    Top = 40
  end
  object FDQ_PosPresDdos: TFDQuery
    Connection = FDC_PosPresDdos
    SQL.Strings = (
      'select distinct matricula.rgm, aluno.senha'
      'from matricula'
      'join aluno on (aluno.codigo = matricula.aluno)'
      
        'where matricula.status = '#39'A'#39' and (matricula.ano = extract(year f' +
        'rom current_date) or matricula.ano = (extract(year from current_' +
        'date)-1))')
    Left = 456
    Top = 88
    object FDQ_PosPresDdosRGM: TStringField
      FieldName = 'RGM'
      Origin = 'RGM'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 10
    end
    object FDQ_PosPresDdosSENHA: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'SENHA'
      Origin = 'SENHA'
      ProviderFlags = []
      ReadOnly = True
      Size = 15
    end
  end
  object FDC_PosPresCG: TFDConnection
    Params.Strings = (
      'Database=/bancos/pos_presencial/pospresencial_cg.fdb'
      'Server=192.168.6.250'
      'User_Name=USER_POS'
      'Password=mjw91_12'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 552
    Top = 32
  end
  object FDQ_PosPresCG: TFDQuery
    Active = True
    Connection = FDC_PosPresCG
    SQL.Strings = (
      'select distinct matricula.rgm, aluno.senha'
      'from matricula'
      'join aluno on (aluno.codigo = matricula.aluno)'
      
        'where matricula.status = '#39'A'#39' and (matricula.ano = extract(year f' +
        'rom current_date) or matricula.ano = (extract(year from current_' +
        'date)-1))')
    Left = 552
    Top = 96
    object FDQ_PosPresCGRGM: TStringField
      FieldName = 'RGM'
      Origin = 'RGM'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 10
    end
    object FDQ_PosPresCGSENHA: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'SENHA'
      Origin = 'SENHA'
      ProviderFlags = []
      ReadOnly = True
      Size = 15
    end
  end
  object Ds_PosPresCG: TDataSource
    DataSet = FDQ_PosPresCG
    Left = 552
    Top = 152
  end
  object FDC_GradPresCG: TFDConnection
    Params.Strings = (
      'Database=/bancos/presencial/plenus_cg.fdb'
      'User_Name=USER_WIFI'
      'Password=shd3821'
      'Server=192.168.6.250'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 288
    Top = 32
  end
  object FDQ_GradPresCG: TFDQuery
    Connection = FDC_GradPresCG
    SQL.Strings = (
      'SELECT DISTINCT RGM.RGM, ALN.SENHA'
      'FROM ALUNOS ALN'
      'JOIN CONTRATO CNT ON (CNT.ALN_ID = ALN.ALN_ID)'
      'JOIN MATRICULAS MTR ON (MTR.CNT_ID = CNT.CNT_ID)'
      
        'JOIN RGMS RGM ON (RGM.CNT_ID = CNT.CNT_ID AND RGM.CRD_ID = MTR.C' +
        'RD_ID)'
      'JOIN SEC_CONFIG CFG ON 1=1'
      
        'WHERE MTR.ANO = CFG.ANO_ATUAL AND MTR.SIT_ID = 1 AND MTR.CRD_ID ' +
        '< 700')
    Left = 280
    Top = 88
  end
  object Ds_GradPresCG: TDataSource
    DataSet = FDQ_GradPresCG
    Left = 280
    Top = 152
  end
end
