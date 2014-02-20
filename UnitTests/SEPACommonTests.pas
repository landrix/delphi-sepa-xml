//
//   Unit tests for "SEPACommon.pas"
//   (beta version 0.2.0, 2014-02-20)
//
//   Copyright (C) 2013-2014 by Aaron Spettl
//
//   This program is free software; you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation; either version 2 of the License, or
//   (at your option) any later version.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of the GNU General Public License
//   along with this program; if not, write to the Free Software
//   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
//
//   Author:  Aaron Spettl
//            Virchowstr. 26
//            89075 Ulm
//            Germany
//   E-mail:  aaron@spettl.de
//
unit SEPACommonTests;

{$IFDEF FPC}                // Lazarus: set compiler mode and file encoding
{%encoding CP1252}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  SEPACommon, SEPATestCase,
  {$IFDEF FPC}
  fpcunit, testutils, testregistry
  {$ELSE}
  TestFrameWork
  {$ENDIF},
  SysUtils, DateUtils;

type
  TPublicMethodsTestCase = class(TSEPATestCase)
  published
    procedure TestSEPAGenerateUUID;

    procedure TestSEPACleanIBANorBICorCI;
    procedure TestSEPAModulo97;
    procedure TestSEPACheckIBAN;
    procedure TestSEPACheckBIC;
    procedure TestSEPACheckCI;
    procedure TestSEPAIsGermanIBAN;

    procedure TestSEPACleanString;
    procedure TestSEPACheckString;

    procedure TestSEPACheckRounded;
    procedure TestSEPAFormatAmount;
    procedure TestSEPAFormatBoolean;
    procedure TestSEPAFormatDate;
    procedure TestSEPAFormatDateTime;

    procedure TestSEPAWriteLine;
  end;

  TFinancialInstitutionTestCase = class(TSEPATestCase)
  private
    fFinInst: TFinancialInstitution;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestSetBIC;
    procedure TestValidate;
    procedure TestSaveToStream;
  end;

  TAccountIdentificationTestCase = class(TSEPATestCase)
  private
    fAccount: TAccountIdentification;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestSetIBAN;
    procedure TestValidate;
    procedure TestSaveToStream;
  end;

implementation

// private methods

function ComputeIBANChecksum(const country: String; const bban: String): String;
var
  n: Integer;
begin
  n := 98 - SEPAModulo97(bban+country+'00');

  if n < 10 then
    Result := '0'+IntToStr(n)
  else
    Result := IntToStr(n);
end;

function ComputeGermanIBANWithDefaultRule(const account_number: String; const bank_code: String): String;
var
  country, bban, check: String;
begin
  // note: account_number is expected to have exactly 10 characters, and
  //       bank_code must have 8 characters - but we do not check this because
  //       we want to generate IBANs with invalid length in the tests below

  country := COUNTRY_CODE_DE;
  bban    := bank_code+account_number;
  check   := ComputeIBANChecksum(country, bban);

  Result := country+check+bban;
end;

// TPublicMethodsTestCase

procedure TPublicMethodsTestCase.TestSEPAGenerateUUID;
var
  UUID1, UUID2: String;
begin
  UUID1 := SEPAGenerateUUID;
  UUID2 := SEPAGenerateUUID;

  CheckEquals(32, Length(UUID1),                           'UUID1 must have exactly 32 characters check');
  CheckEquals(32, Length(UUID2),                           'UUID2 must have exactly 32 characters check');
  CheckTrue(SEPACheckString(UUID1),                        'UUID1 must only contain valid characters check');
  CheckTrue(SEPACheckString(UUID2),                        'UUID2 must only contain valid characters check');
  CheckNotEquals(UUID1, UUID2,                             'Generated UUIDs must not be equal check');
end;

procedure TPublicMethodsTestCase.TestSEPACleanIBANorBICorCI;
begin
  CheckEquals('TEST', SEPACleanIBANorBICorCI('TEST'),      'Already clean string check');
  CheckEquals('TEST', SEPACleanIBANorBICorCI('TEST'+sLineBreak), 'Trim check');
  CheckEquals('TEST', SEPACleanIBANorBICorCI('TE ST'),     'Single white-space check');
  CheckEquals('TEST', SEPACleanIBANorBICorCI(' T E S T '), 'Multiple white-space check');
  CheckEquals('TEST', SEPACleanIBANorBICorCI('test'),      'Upper-case conversion check');
  CheckEquals('TEST�', SEPACleanIBANorBICorCI('test�'),    'Upper-case conversion check with special character');
end;

procedure TPublicMethodsTestCase.TestSEPAModulo97;
begin
  CheckEquals(0, SEPAModulo97('0'),                         'Modulo 97 check for zero');
  CheckEquals(1, SEPAModulo97('1'),                         'Modulo 97 check for 1');
  CheckEquals(96, SEPAModulo97('96'),                       'Modulo 97 check for 96');
  CheckEquals(0, SEPAModulo97('97'),                        'Modulo 97 check for 97');
  CheckEquals(1, SEPAModulo97('98'),                        'Modulo 97 check for 98');
  CheckEquals(88, SEPAModulo97('002300101023502601121700'), 'Modulo 97 with large number check');
  CheckEquals(88, SEPAModulo97('002300A1023502601CH00'),    'Modulo 97 with alpha characters translation check');
end;

procedure TPublicMethodsTestCase.TestSEPACheckIBAN;
begin
  CheckFalse(SEPACheckIBAN(''),                            'Empty IBAN check');
  CheckFalse(SEPACheckIBAN('DE'),                          'Invalid IBAN (only country code) check');
  CheckFalse(SEPACheckIBAN('DE00'),                        'Invalid IBAN (only country code and checksum) check');

  CheckTrue(SEPACheckIBAN('DE58123456780123456789'),       'Valid IBAN without spaces check');
  CheckTrue(SEPACheckIBAN('DE58 1234 5678 0123 4567 89'),  'Valid IBAN with spaces check');
  CheckFalse(SEPACheckIBAN('DE59 1234 5678 0123 4567 89'), 'Invalid checksum in IBAN check');

  CheckTrue(SEPACheckIBAN(ComputeGermanIBANWithDefaultRule('1234567890', '12345678')), 'Valid computed IBAN check');
  CheckFalse(SEPACheckIBAN(ComputeGermanIBANWithDefaultRule('123456789012345678901234567890', '12345678')), 'Invalid length in IBAN check');
end;

procedure TPublicMethodsTestCase.TestSEPACheckBIC;
begin
  CheckFalse(SEPACheckBIC(''),                             'Empty BIC check');
  CheckTrue(SEPACheckBIC('SOMEINST'),                      '8-character BIC with valid characters check');
  CheckTrue(SEPACheckBIC('SOMEFININST'),                   '11-character BIC with valid characters check');
  CheckTrue(SEPACheckBIC('SOME FIN INST '),                '11-character BIC with valid characters and spaces check');
  CheckFalse(SEPACheckBIC('SOMEFININS'),                   'BIC with invalid length check');
  CheckFalse(SEPACheckBIC('SOMEFININS-'),                  'BIC with invalid characters check');
end;

procedure TPublicMethodsTestCase.TestSEPACheckCI;
begin
  CheckFalse(SEPACheckCI(''),                              'Empty CI check');
  CheckTrue(SEPACheckCI('DE98ZZZ09999999999'),             'Valid CI without spaces check');
  CheckTrue(SEPACheckCI('DE98 ZZZ 09999999999'),           'Valid CI with spaces check');
  CheckFalse(SEPACheckCI('DE97ZZZ09999999999'),            'Invalid checksum in CI check');
end;

procedure TPublicMethodsTestCase.TestSEPAIsGermanIBAN;
begin
  CheckTrue(SEPAIsGermanIBAN('DE58123456780123456789'),    'Valid German IBAN check');
  CheckTrue(SEPAIsGermanIBAN('DE'),                        'Valid German IBAN check does not require IBAN validation');
  CheckTrue(SEPAIsGermanIBAN(' de '),                      'Valid German IBAN check accepts also non-clean strings');
  CheckFalse(SEPAIsGermanIBAN(''),                         'Empty string is not a valid German IBAN check');
  CheckFalse(SEPAIsGermanIBAN('CH'),                       'German IBAN really checks country code');
end;

procedure TPublicMethodsTestCase.TestSEPACleanString;
const
  numeric                = '01234567890';
  alpha_lower            = 'abcdefghijklmnopqrstuvwxyz';
  alpha_upper            = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  special                = ''':?,- (+.)/';
  special_german         = '�������&*$%';
  special_german_transf  = 'aouAOUs+...';
  special_invalid        = '!"�=#~_;{[]}\';
  special_invalid_transf = '             ';
begin
  CheckEquals('', SEPACleanString(''),                     'Clean empty string check');
  CheckEquals(' ', SEPACleanString(' '),                   'Clean string is not trimmed check');
  CheckEquals(numeric, SEPACleanString(numeric),           'Clean string check for numbers');
  CheckEquals(alpha_lower, SEPACleanString(alpha_lower),   'Clean string check for lower case letters');
  CheckEquals(alpha_upper, SEPACleanString(alpha_upper),   'Clean string check for upper case letters');
  CheckEquals(special, SEPACleanString(special),           'Clean string check for standard special characters');
  CheckEquals(special_invalid_transf, SEPACleanString(special_invalid), 'Clean string check for standard special characters');

  CheckEquals(special_german_transf, SEPACleanString(special_german), 'Clean string check for German special characters');
  SEPASupportSpecialChars := true;
  CheckEquals(special_german, SEPACleanString(special_german), 'Clean string check for German special characters (with German special characters allowed)');

  CheckEquals('', SEPACleanString('', 0),                   'Clean string max-length for empty string check');
  CheckEquals('', SEPACleanString(' ', 0),                  'Clean string max-length for empty string (with truncation) check');
  CheckEquals('abc', SEPACleanString('abc', 3),             'Clean string max-length for string check');
  CheckEquals('abc', SEPACleanString('abcdef', 3),          'Clean string max-length for string (with truncation) check');
  CheckEquals('abc', SEPACleanString('abc', 4),             'Clean string max-length for string (without truncation) check');
  CheckEquals('���', SEPACleanString('������', 3),          'Clean string max-length for string with two-byte characters in UTF-8 check');
end;

procedure TPublicMethodsTestCase.TestSEPACheckString;
begin
  CheckTrue(SEPACheckString(''),                            'Empty SEPA string check');
  CheckTrue(SEPACheckString('a'),                           'Simple SEPA string check');
  CheckTrue(SEPACheckString('a b'),                         'Simple SEPA string with space check');
  CheckTrue(SEPACheckString('a b '),                        'Simple SEPA string without trim check');
  CheckTrue(SEPACheckString('ab', 2),                       'Simple SEPA string with irrelvant max-length check');
  CheckFalse(SEPACheckString('abc', 2),                     'Simple SEPA string with relevant max-length check');

  CheckFalse(SEPACheckString('�'),                          'Simple SEPA string with German special character check');
  SEPASupportSpecialChars := true;
  CheckTrue(SEPACheckString('�'),                           'Simple SEPA string with German special character check (with German special characters allowed)');
end;

procedure TPublicMethodsTestCase.TestSEPACheckRounded;
begin
  CheckTrue(SEPACheckRounded(123),                          'Currency without decimal places check');
  CheckTrue(SEPACheckRounded(123.4),                        'Currency with one decimal place check');
  CheckTrue(SEPACheckRounded(123.45),                       'Currency with two decimal places check');
  CheckFalse(SEPACheckRounded(123.456),                     'Currency with three decimal places check');
  CheckFalse(SEPACheckRounded(123.4568),                    'Currency with four decimal places check');
  CheckTrue(SEPACheckRounded(123.45001),                    'Currency with irrelevant additional decimal places check');
end;

procedure TPublicMethodsTestCase.TestSEPAFormatAmount;
begin
  CheckEquals('123.00', SEPAFormatAmount(123),              'Currency without decimal places format check');
  CheckEquals('123.40', SEPAFormatAmount(123.4),            'Currency with one decimal place format check');
  CheckEquals('123.45', SEPAFormatAmount(123.45),           'Currency with two decimal places format check');
  CheckEquals('123.46', SEPAFormatAmount(123.456),          'Currency with three decimal places format check');
  CheckEquals('123.46', SEPAFormatAmount(123.4568),         'Currency with four decimal places format check');
  CheckEquals('123.45', SEPAFormatAmount(123.45001),        'Currency with irrelevant additional decimal places format check');
  CheckEquals('12345.67', SEPAFormatAmount(12345.67),       'Currency without thousand separator format check');
  CheckEquals('-123.45', SEPAFormatAmount(-123.45),         'Currency with negative value format check');
end;

procedure TPublicMethodsTestCase.TestSEPAFormatBoolean;
begin
  CheckEquals('false', SEPAFormatBoolean(false),            'Boolean false value check');
  CheckEquals('true', SEPAFormatBoolean(true),              'Boolean true value check');
end;

procedure TPublicMethodsTestCase.TestSEPAFormatDate;
begin
  CheckEquals('2014-02-01', SEPAFormatDate(EncodeDate(2014, 2, 1)), 'Date format check');
end;

procedure TPublicMethodsTestCase.TestSEPAFormatDateTime;
begin
  CheckEquals('2014-02-01T00:00:00.000Z', SEPAFormatDateTime(EncodeDate(2014, 2, 1)), 'Date-time format without time check');
  CheckEquals('2014-02-01T12:55:30.100Z', SEPAFormatDateTime(EncodeDateTime(2014, 2, 1, 12, 55, 30, 100)), 'Date-time format check');
end;

procedure TPublicMethodsTestCase.TestSEPAWriteLine;

  function SEPAWriteLine_GetBytes(const line: String): AnsiString;
  begin
    // write to stream
    SEPAWriteLine(SaveStream, line);
    // get written bytes
    Result := FetchAndResetSaveStream;
  end;

const
  Default_TestStr: String = '<abc>';
  Default_SpChar : String = '�';
  UTF8_LineBreak : AnsiString = {$IFDEF LINUX} #10 {$ELSE} #13#10 {$ENDIF};
  UTF8_TestStr   : AnsiString = '<abc>';
  UTF8_SpChar    : AnsiString = #195#164;
begin
  CheckEquals(UTF8_LineBreak, SEPAWriteLine_GetBytes(''),   'Empty line written check');
  CheckEquals(UTF8_TestStr+UTF8_LineBreak, SEPAWriteLine_GetBytes(Default_TestStr), 'Simple line written check');
  CheckEquals(UTF8_SpChar+UTF8_LineBreak, SEPAWriteLine_GetBytes(Default_SpChar), 'Special character line written as UTF-8 check');
end;

// TFinancialInstitutionTestCase

procedure TFinancialInstitutionTestCase.SetUp;
begin
  inherited;
  fFinInst := TFinancialInstitution.Create;
end;

procedure TFinancialInstitutionTestCase.TearDown;
begin
  fFinInst.Free;
  fFinInst := nil;
  inherited;
end;

procedure TFinancialInstitutionTestCase.TestCreate;
begin
  CheckEquals('', fFinInst.BIC);
  CheckEquals('', fFinInst.OthrID);
end;

procedure TFinancialInstitutionTestCase.TestSetBIC;
begin
  fFinInst.BIC := 'TEST';
  CheckEquals(SEPACleanString('TEST'), fFinInst.BIC);

  fFinInst.BIC := 'T E S T ';
  CheckEquals(SEPACleanString('TEST'), fFinInst.BIC);
end;

procedure TFinancialInstitutionTestCase.TestValidate;
begin
  // empty object (make sure that "invalid BIC" message does not appear)
  CheckValidation([EMPTY_BIC_OTHR_ID], fFinInst.Validate(SCHEMA_PAIN_008_003_02));

  // object with only (valid) BIC given
  fFinInst.BIC := 'SOMEFININST';
  CheckValidation([], fFinInst.Validate(SCHEMA_PAIN_008_003_02));

  // object with only (invalid) BIC given
  fFinInst.BIC := 'SOMEFININST2';
  CheckValidation([Format(INVALID_BIC, [fFinInst.BIC])], fFinInst.Validate(SCHEMA_PAIN_008_003_02));

  // object with both BIC and NOTPROVIDED given
  fFinInst.BIC    := 'SOMEFININST';
  fFinInst.OthrID := FIN_INSTN_NOTPROVIDED;
  CheckValidation([BOTH_BIC_OTHR_ID], fFinInst.Validate(SCHEMA_PAIN_008_003_02));

  // object with only NOTPROVIDED given
  fFinInst.BIC    := '';
  fFinInst.OthrID := FIN_INSTN_NOTPROVIDED;
  CheckValidation([], fFinInst.Validate(SCHEMA_PAIN_008_003_02));

  // object with only wrong value instead of NOTPROVIDED given
  fFinInst.BIC    := '';
  fFinInst.OthrID := FIN_INSTN_NOTPROVIDED+'_TEST';
  CheckValidation([INVALID_OTHR_ID], fFinInst.Validate(SCHEMA_PAIN_008_003_02));

  // object with only NOTPROVIDED given, but for old schema
  fFinInst.BIC    := '';
  fFinInst.OthrID := FIN_INSTN_NOTPROVIDED;
  CheckValidation([IBAN_ONLY_NOT_ALLOWED], fFinInst.Validate(SCHEMA_PAIN_008_002_02));

  // object with only NOTPROVIDED given, but for IBAN-only date in future
  IBAN_ONLY_DATE  := Now+1;
  fFinInst.BIC    := '';
  fFinInst.OthrID := FIN_INSTN_NOTPROVIDED;
  CheckValidation([IBAN_ONLY_NOT_ALLOWED], fFinInst.Validate(SCHEMA_PAIN_008_003_02));
end;

procedure TFinancialInstitutionTestCase.TestSaveToStream;
begin
  // empty object
  fFinInst.SaveToStream(SaveStream, SCHEMA_PAIN_008_003_02);
  CheckSaveStream('<FinInstnId><BIC></BIC></FinInstnId>');

  // object with only BIC given
  fFinInst.BIC := 'SOMEFININST';
  fFinInst.SaveToStream(SaveStream, SCHEMA_PAIN_008_003_02);
  CheckSaveStream('<FinInstnId><BIC>SOMEFININST</BIC></FinInstnId>');

  // object with only NOTPROVIDED given
  fFinInst.BIC    := '';
  fFinInst.OthrID := FIN_INSTN_NOTPROVIDED;
  fFinInst.SaveToStream(SaveStream, SCHEMA_PAIN_008_003_02);
  CheckSaveStream('<FinInstnId><Othr><Id>'+FIN_INSTN_NOTPROVIDED+'</Id></Othr></FinInstnId>');

  // object with both BIC and NOTPROVIDED given should only use BIC
  fFinInst.BIC    := 'SOMEFININST';
  fFinInst.OthrID := FIN_INSTN_NOTPROVIDED;
  fFinInst.SaveToStream(SaveStream, SCHEMA_PAIN_008_003_02);
  CheckSaveStream('<FinInstnId><BIC>SOMEFININST</BIC></FinInstnId>');

  // object with BIC and spaces
  fFinInst.BIC    := 'SOME FIN INST';
  fFinInst.OthrID := '';
  fFinInst.SaveToStream(SaveStream, SCHEMA_PAIN_008_003_02);
  CheckSaveStream('<FinInstnId><BIC>SOMEFININST</BIC></FinInstnId>');
end;

// TAccountIdentificationTestCase

procedure TAccountIdentificationTestCase.SetUp;
begin
  inherited;
  fAccount := TAccountIdentification.Create;
end;

procedure TAccountIdentificationTestCase.TearDown;
begin
  fAccount.Free;
  fAccount := nil;
  inherited;
end;

procedure TAccountIdentificationTestCase.TestCreate;
begin
  CheckEquals('', fAccount.IBAN);
end;

procedure TAccountIdentificationTestCase.TestSetIBAN;
begin
  fAccount.IBAN := 'DE58123456780123456789';
  CheckEquals(SEPACleanString('DE58123456780123456789'), fAccount.IBAN);

  fAccount.IBAN := 'DE58 1234 5678 0123 4567 89';
  CheckEquals(SEPACleanString('DE58123456780123456789'), fAccount.IBAN);
end;

procedure TAccountIdentificationTestCase.TestValidate;
begin
  // empty object (make sure that "invalid IBAN" message does not appear)
  CheckValidation([EMPTY_IBAN], fAccount.Validate(SCHEMA_PAIN_008_003_02));

  // object with only (valid) IBAN given
  fAccount.IBAN := 'DE58123456780123456789';
  CheckValidation([], fAccount.Validate(SCHEMA_PAIN_008_003_02));

  // object with only (invalid) IBAN given
  fAccount.IBAN := 'DE59123456780123456789';
  CheckValidation([Format(INVALID_IBAN, [fAccount.IBAN])], fAccount.Validate(SCHEMA_PAIN_008_003_02));
end;

procedure TAccountIdentificationTestCase.TestSaveToStream;
begin
  // empty object
  fAccount.SaveToStream(SaveStream, SCHEMA_PAIN_008_003_02);
  CheckSaveStream('<Id><IBAN></IBAN></Id>');

  // object with IBAN
  fAccount.IBAN := 'DE58123456780123456789';
  fAccount.SaveToStream(SaveStream, SCHEMA_PAIN_008_003_02);
  CheckSaveStream('<Id><IBAN>DE58123456780123456789</IBAN></Id>');

  // object with IBAN and spaces
  fAccount.IBAN := 'DE58 1234 5678 0123 4567 89';
  fAccount.SaveToStream(SaveStream, SCHEMA_PAIN_008_003_02);
  CheckSaveStream('<Id><IBAN>DE58123456780123456789</IBAN></Id>');
end;

initialization
  RegisterTest('SEPACommonTests Suite', TPublicMethodsTestCase.Suite);
  RegisterTest('SEPACommonTests Suite', TFinancialInstitutionTestCase.Suite);
  RegisterTest('SEPACommonTests Suite', TAccountIdentificationTestCase.Suite);

end.