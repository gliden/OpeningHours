unit DayLib;

interface

type
  TDay = (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday);

  TDayHelper = record helper for TDay
    function ToDayIndex: Integer;
    function ToDayName: String;
    function ToShortDayName: String;
    class function IndexToDay(index: Integer): TDay; static;
  end;

implementation

uses
  System.SysUtils, System.DateUtils;

{ TDayHelper }

class function TDayHelper.IndexToDay(index: Integer): TDay;
begin
  case index of
    1: Result := TDay.Monday;
    2: Result := TDay.Tuesday;
    3: Result := TDay.Wednesday;
    4: Result := TDay.Thursday;
    5: Result := TDay.Friday;
    6: Result := TDay.Saturday;
    7: Result := TDay.Sunday;
    else raise Exception.Create('Unknown Index');
  end;
end;

function TDayHelper.ToDayIndex: Integer;
begin
  case Self of
    Monday    : Result := 1;
    Tuesday   : Result := 2;
    Wednesday : Result := 3;
    Thursday  : Result := 4;
    Friday    : Result := 5;
    Saturday  : Result := 6;
    Sunday    : Result := 7;
    else raise Exception.Create('Unknown Day');
  end;
end;

function TDayHelper.ToDayName: String;
begin
  case Self of
    Monday    : Result := FormatSettings.LongDayNames[2];
    Tuesday   : Result := FormatSettings.LongDayNames[3];
    Wednesday : Result := FormatSettings.LongDayNames[4];
    Thursday  : Result := FormatSettings.LongDayNames[5];
    Friday    : Result := FormatSettings.LongDayNames[6];
    Saturday  : Result := FormatSettings.LongDayNames[7];
    Sunday    : Result := FormatSettings.LongDayNames[1];
    else raise Exception.Create('Unknown Day');
  end;
end;

function TDayHelper.ToShortDayName: String;
begin
  case Self of
    Monday    : Result := FormatSettings.ShortDayNames[2];
    Tuesday   : Result := FormatSettings.ShortDayNames[3];
    Wednesday : Result := FormatSettings.ShortDayNames[4];
    Thursday  : Result := FormatSettings.ShortDayNames[5];
    Friday    : Result := FormatSettings.ShortDayNames[6];
    Saturday  : Result := FormatSettings.ShortDayNames[7];
    Sunday    : Result := FormatSettings.ShortDayNames[1];
    else raise Exception.Create('Unknown Day');
  end;
end;

end.
