object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Form1'
  ClientHeight = 513
  ClientWidth = 815
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 264
    Top = 7
    Width = 19
    Height = 13
    Caption = 'CEP'
  end
  object Label2: TLabel
    Left = 32
    Top = 53
    Width = 33
    Height = 13
    Caption = 'Estado'
  end
  object Label3: TLabel
    Left = 71
    Top = 53
    Width = 33
    Height = 13
    Caption = 'Cidade'
  end
  object Label4: TLabel
    Left = 198
    Top = 53
    Width = 55
    Height = 13
    Caption = 'Logradouro'
  end
  object Label5: TLabel
    Left = 32
    Top = 97
    Width = 80
    Height = 13
    Caption = 'Tipo de Pesquisa'
  end
  object Label6: TLabel
    Left = 32
    Top = 143
    Width = 87
    Height = 13
    Caption = 'Resultado Obtido:'
  end
  object Label7: TLabel
    Left = 39
    Top = 8
    Width = 51
    Height = 10
    Caption = 'Conex'#227'o'
  end
  object Label8: TLabel
    Left = 96
    Top = 8
    Width = 20
    Height = 13
    Caption = '.....'
  end
  object btnConsultarCep: TBitBtn
    Left = 390
    Top = 22
    Width = 129
    Height = 25
    Caption = 'Consultar CEP'
    TabOrder = 1
    OnClick = btnConsultarCepClick
  end
  object memoResultado: TMemo
    Left = 32
    Top = 161
    Width = 481
    Height = 138
    TabOrder = 7
  end
  object edtLogradouro: TEdit
    Left = 198
    Top = 72
    Width = 178
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 4
  end
  object edtCidade: TEdit
    Left = 71
    Top = 72
    Width = 121
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 3
  end
  object edtEstado: TEdit
    Left = 32
    Top = 72
    Width = 33
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 2
    TabOrder = 2
    OnKeyPress = edtEstadoKeyPress
  end
  object cbFormato: TComboBox
    Left = 32
    Top = 116
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 6
  end
  object btconsultarEndereco: TBitBtn
    Left = 382
    Top = 70
    Width = 129
    Height = 25
    Caption = 'Consultar endere'#231'o'
    TabOrder = 5
    OnClick = btconsultarEnderecoClick
  end
  object edtCEP: TMaskEdit
    Left = 264
    Top = 26
    Width = 120
    Height = 21
    EditMask = '99999\-999;1;_'
    MaxLength = 9
    TabOrder = 0
    Text = '     -   '
  end
  object DBGrid1: TDBGrid
    Left = 32
    Top = 320
    Width = 769
    Height = 169
    DataSource = DataSource1
    ReadOnly = True
    TabOrder = 8
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'CODIGO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CEP'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LOGRADOURO'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BAIRRO'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CIDADE'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'UF'
        Visible = True
      end>
  end
  object btGravarAlt: TBitBtn
    Left = 390
    Top = 70
    Width = 129
    Height = 25
    Caption = 'Gravar Altera'#231#245'es'
    TabOrder = 9
    Visible = False
    OnClick = btGravarAltClick
  end
  object edtConexao: TEdit
    Left = 32
    Top = 24
    Width = 193
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 10
  end
  object BitBtn1: TBitBtn
    Left = 231
    Top = 22
    Width = 27
    Height = 25
    Caption = '...'
    TabOrder = 11
    OnClick = BitBtn1Click
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 752
    Top = 8
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'gen_tb_cep_id'
    UpdateOptions.AutoIncFields = 'CODIGO'
    SQL.Strings = (
      'SELECT * FROM TB_CEP')
    Left = 752
    Top = 56
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 752
    Top = 112
  end
  object OpenDialog1: TOpenDialog
    Left = 616
    Top = 16
  end
end
