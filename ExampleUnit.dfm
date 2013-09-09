object ExampleForm: TExampleForm
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'SEPA XML file example'
  ClientHeight = 607
  ClientWidth = 915
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 32
    Top = 80
    Width = 2
    Height = 25
  end
  object Bevel2: TBevel
    Left = 32
    Top = 105
    Width = 17
    Height = 2
  end
  object Bevel3: TBevel
    Left = 64
    Top = 304
    Width = 2
    Height = 25
  end
  object Bevel4: TBevel
    Left = 64
    Top = 329
    Width = 17
    Height = 2
  end
  object Bevel5: TBevel
    Left = 472
    Top = 329
    Width = 17
    Height = 2
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 16
    Width = 377
    Height = 57
    Caption = 'Group header'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 103
      Height = 13
      Caption = 'Initiating party (name):'
    end
    object InitiatingPartyNameEdit: TEdit
      Left = 128
      Top = 24
      Width = 225
      Height = 21
      MaxLength = 70
      TabOrder = 0
      Text = 'My name'
    end
  end
  object SaveButton: TButton
    Left = 376
    Top = 560
    Width = 91
    Height = 25
    Caption = 'Save XML file...'
    TabOrder = 4
    OnClick = SaveButtonClick
  end
  object GroupBox2: TGroupBox
    Left = 56
    Top = 88
    Width = 377
    Height = 209
    Caption = 'Payment instruction'
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 107
      Height = 13
      Caption = 'Local instrument code:'
    end
    object Label3: TLabel
      Left = 8
      Top = 48
      Width = 75
      Height = 13
      Caption = 'Sequence type:'
    end
    object Label4: TLabel
      Left = 8
      Top = 72
      Width = 98
      Height = 13
      Caption = 'Req. collection date:'
    end
    object Label5: TLabel
      Left = 8
      Top = 96
      Width = 68
      Height = 13
      Caption = 'Creditor name:'
    end
    object Label6: TLabel
      Left = 8
      Top = 120
      Width = 115
      Height = 13
      Caption = 'Creditor account (IBAN):'
    end
    object Label7: TLabel
      Left = 8
      Top = 144
      Width = 104
      Height = 13
      Caption = 'Creditor fin. inst. (BIC):'
    end
    object Label8: TLabel
      Left = 8
      Top = 168
      Width = 81
      Height = 13
      Caption = 'Creditor identifier:'
    end
    object CreditorNameEdit: TEdit
      Left = 128
      Top = 96
      Width = 225
      Height = 21
      MaxLength = 70
      TabOrder = 3
      Text = 'My name'
    end
    object CreditorAccountIBANEdit: TEdit
      Left = 128
      Top = 120
      Width = 225
      Height = 21
      MaxLength = 34
      TabOrder = 4
      Text = 'DE0012345678123456789'
    end
    object CreditorAccountBICEdit: TEdit
      Left = 128
      Top = 144
      Width = 225
      Height = 21
      MaxLength = 11
      TabOrder = 5
      Text = 'SOMEFININST'
    end
    object CreditorIdentifierEdit: TEdit
      Left = 128
      Top = 168
      Width = 225
      Height = 21
      MaxLength = 35
      TabOrder = 6
      Text = 'DE98ZZZ09999999999'
    end
    object RequestedCollectionDateEdit: TDateTimePicker
      Left = 128
      Top = 72
      Width = 186
      Height = 21
      CalAlignment = dtaLeft
      Date = 41526.3194741551
      Time = 41526.3194741551
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 2
    end
    object LocalInstrumentCodeComboBox: TComboBox
      Left = 128
      Top = 24
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = 'CORE'
      Items.Strings = (
        'CORE'
        'B2B'
        'COR1')
    end
    object SequenceTypeComboBox: TComboBox
      Left = 128
      Top = 48
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'FRST'
      Items.Strings = (
        'FRST'
        'RCUR'
        'OOFF'
        'FNAL')
    end
  end
  object GroupBox3: TGroupBox
    Left = 88
    Top = 312
    Width = 377
    Height = 225
    Caption = 'Direct debit transaction'
    TabOrder = 2
    object Label9: TLabel
      Left = 8
      Top = 24
      Width = 69
      Height = 13
      Caption = 'End-to-end ID:'
    end
    object Label12: TLabel
      Left = 8
      Top = 48
      Width = 88
      Height = 13
      Caption = 'Instructed amount:'
    end
    object Label13: TLabel
      Left = 8
      Top = 96
      Width = 111
      Height = 13
      Caption = 'Debtor account (IBAN):'
    end
    object Label14: TLabel
      Left = 8
      Top = 120
      Width = 100
      Height = 13
      Caption = 'Debtor fin. inst. (BIC):'
    end
    object Label15: TLabel
      Left = 8
      Top = 144
      Width = 111
      Height = 26
      Caption = 'Remittance information (unstructured):'
      WordWrap = True
    end
    object Label10: TLabel
      Left = 240
      Top = 48
      Width = 23
      Height = 13
      Caption = 'EUR'
    end
    object Label11: TLabel
      Left = 8
      Top = 72
      Width = 64
      Height = 13
      Caption = 'Debtor name:'
    end
    object InstructedAmountEdit: TEdit
      Left = 128
      Top = 48
      Width = 105
      Height = 21
      TabOrder = 1
      Text = '123.45'
    end
    object DebtorIBANEdit: TEdit
      Left = 128
      Top = 96
      Width = 225
      Height = 21
      MaxLength = 34
      TabOrder = 3
      Text = 'DE0012345678123456789'
    end
    object DebtorBICEdit: TEdit
      Left = 128
      Top = 120
      Width = 225
      Height = 21
      MaxLength = 11
      TabOrder = 4
      Text = 'SOMEFININST'
    end
    object EndToEndIdComboBox: TComboBox
      Left = 128
      Top = 24
      Width = 225
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      MaxLength = 35
      TabOrder = 0
      Text = 'NOTPROVIDED'
      Items.Strings = (
        'NOTPROVIDED')
    end
    object DebtorNameEdit: TEdit
      Left = 128
      Top = 72
      Width = 225
      Height = 21
      MaxLength = 70
      TabOrder = 2
      Text = 'Customer name'
    end
    object RemittanceInformationMemo: TMemo
      Left = 128
      Top = 144
      Width = 225
      Height = 57
      Lines.Strings = (
        'Customer number 123, invoice number 456')
      MaxLength = 140
      ScrollBars = ssVertical
      TabOrder = 5
      WantReturns = False
    end
  end
  object GroupBox4: TGroupBox
    Left = 496
    Top = 312
    Width = 377
    Height = 225
    Caption = 'Mandate related information'
    TabOrder = 3
    object Label17: TLabel
      Left = 8
      Top = 24
      Width = 59
      Height = 13
      Caption = 'Mandate ID:'
    end
    object Label18: TLabel
      Left = 8
      Top = 176
      Width = 111
      Height = 13
      Caption = 'Debtor account (IBAN):'
    end
    object Label19: TLabel
      Left = 8
      Top = 200
      Width = 74
      Height = 13
      Caption = 'Debtor fin. inst.:'
    end
    object Label20: TLabel
      Left = 8
      Top = 104
      Width = 59
      Height = 13
      Caption = 'Mandate ID:'
    end
    object Label22: TLabel
      Left = 8
      Top = 48
      Width = 84
      Height = 13
      Caption = 'Date of signature:'
    end
    object Label16: TLabel
      Left = 8
      Top = 128
      Width = 68
      Height = 13
      Caption = 'Creditor name:'
    end
    object Label21: TLabel
      Left = 8
      Top = 152
      Width = 81
      Height = 13
      Caption = 'Creditor identifier:'
    end
    object MandateIdEdit: TEdit
      Left = 128
      Top = 24
      Width = 225
      Height = 21
      MaxLength = 35
      TabOrder = 0
      Text = 'MNDTID'
    end
    object OriginalDebtorAccountIBANEdit: TEdit
      Left = 128
      Top = 176
      Width = 225
      Height = 21
      MaxLength = 34
      TabOrder = 6
    end
    object OriginalMandateIdEdit: TEdit
      Left = 128
      Top = 104
      Width = 225
      Height = 21
      MaxLength = 35
      TabOrder = 3
    end
    object MandateDateOfSignatureEdit: TDateTimePicker
      Left = 128
      Top = 48
      Width = 186
      Height = 21
      CalAlignment = dtaLeft
      Date = 41526.3194741551
      Time = 41526.3194741551
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 1
    end
    object MandateAmendmentInformationDetailsCheckBox: TCheckBox
      Left = 8
      Top = 80
      Width = 249
      Height = 17
      Caption = 'Amendment information details (only changes):'
      TabOrder = 2
    end
    object OriginalDebtorFinInstSMNDACheckBox: TCheckBox
      Left = 128
      Top = 200
      Width = 233
      Height = 17
      Caption = 'SMNDA (same mandate, new debtor agent)'
      TabOrder = 7
    end
    object OriginalCreditorNameEdit: TEdit
      Left = 128
      Top = 128
      Width = 225
      Height = 21
      MaxLength = 70
      TabOrder = 4
    end
    object OriginalCreditorIdentifierEdit: TEdit
      Left = 128
      Top = 152
      Width = 225
      Height = 21
      MaxLength = 35
      TabOrder = 5
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'XML files (*.xml)|*.xml|All files|*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save XML file'
    Left = 472
    Top = 560
  end
end