unit TestOpeningHoursLib;
{

  Delphi DUnit-Testfall
  ----------------------
  Diese Unit enthält ein Skeleton einer Testfallklasse, das vom Experten für Testfälle erzeugt wurde.
  Ändern Sie den erzeugten Code so, dass er die Methoden korrekt einrichtet und aus der 
  getesteten Unit aufruft.

}

interface

uses
  TestFramework, DayLib, OpeningHoursLib, System.Generics.Collections,
  System.SysUtils;

type
  // Testmethoden für Klasse TOpeningList

  TestTOpeningList = class(TTestCase)
  strict private
    FOpeningList: TOpeningList;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestToString;
    procedure TestToConsolidatedText;
    procedure TestToSmallList;
  end;

implementation

procedure TestTOpeningList.SetUp;
begin
  FOpeningList := TOpeningList.Create;

  FOpeningList.Add(TDay.Tuesday, StrToTime('13:00'), StrToTime('18:00'));
  FOpeningList.Add(TDay.Tuesday, StrToTime('08:00'), StrToTime('12:30'));
  FOpeningList.Add(TDay.Monday, StrToTime('13:00'), StrToTime('18:00'));
  FOpeningList.Add(TDay.Monday, StrToTime('08:00'), StrToTime('12:30'));
  FOpeningList.Add(TDay.Wednesday, StrToTime('08:00'), StrToTime('14:00'));
  FOpeningList.Add(TDay.Friday, StrToTime('13:00'), StrToTime('18:00'));
  FOpeningList.Add(TDay.Friday, StrToTime('08:00'), StrToTime('12:30'));
  FOpeningList.Add(TDay.Thursday, StrToTime('13:00'), StrToTime('18:00'));
  FOpeningList.Add(TDay.Thursday, StrToTime('08:00'), StrToTime('12:30'));
  FOpeningList.Add(TDay.Saturday, StrToTime('10:00'), StrToTime('14:00'));
  FOpeningList.Add(TDay.Sunday, StrToTime('10:00'), StrToTime('14:00'));
end;

procedure TestTOpeningList.TearDown;
begin
  FOpeningList.Free;
  FOpeningList := nil;
end;

procedure TestTOpeningList.TestToString;
var
  ReturnValue: string;
begin
  ReturnValue := FOpeningList.ToString;

  CheckEquals('Montag: 08:00 - 12:30 / 13:00 - 18:00'+#13#10+'Dienstag: 08:00 - 12:30 / 13:00 - 18:00'+#13#10+'Mittwoch: 08:00 - 14:00'+#13#10+'Donnerstag: 08:00 - 12:30 / 13:00 - 18:00'+#13#10+'Freitag: 08:00 - 12:30 / 13:00 - 18:00'+#13#10+'Samstag: 10:00 - 14:00'+#13#10+'Sonntag: 10:00 - 14:00', ReturnValue);
end;

procedure TestTOpeningList.TestToConsolidatedText;
var
  ReturnValue: string;
begin
  ReturnValue := FOpeningList.ToConsolidatedText;

  CheckEquals('Mo, Di 08:00 - 12:30 / 13:00 - 18:00'+#13#10+'Mi 08:00 - 14:00'+#13#10+'Do, Fr 08:00 - 12:30 / 13:00 - 18:00'+#13#10+'Sa, So 10:00 - 14:00', ReturnValue);
end;

procedure TestTOpeningList.TestToSmallList;
var
  ReturnValue: string;
begin
  ReturnValue := FOpeningList.ToSmallList;

  CheckEquals('Mo, Di, Do, Fr: 08:00 - 12:30 / 13:00 - 18:00'+#13#10+'Mi: 08:00 - 14:00'+#13#10+'Sa, So: 10:00 - 14:00', ReturnValue);
end;

initialization
  // Alle Testfälle beim Testprogramm registrieren
  RegisterTest(TestTOpeningList.Suite);
end.

