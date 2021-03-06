program OpeningHoursTest;
{

  Delphi DUnit-Testprojekt
  -------------------------
  Dieses Projekt enth�lt das DUnit-Test-Framework und die GUI/Konsolen-Test-Runner.
  F�gen Sie den Bedingungen in den Projektoptionen "CONSOLE_TESTRUNNER" hinzu,
  um den Konsolen-Test-Runner zu verwenden.  Ansonsten wird standardm��ig der
  GUI-Test-Runner verwendet.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  TestOpeningHoursLib in 'TestOpeningHoursLib.pas',
  OpeningHoursLib in '..\lib\OpeningHoursLib.pas',
  DayLib in '..\lib\DayLib.pas',
  DUnitTestRunner;

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

