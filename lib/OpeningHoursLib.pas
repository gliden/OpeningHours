unit OpeningHoursLib;

interface

uses
  System.Generics.Collections, System.SysUtils, DayLib;

type
  TOpeningSpan = class(TObject)
  private
    FOpenTime: TTime;
    FCloseTime: TTime;
  public
    function IsOverlapping(open, close: TTime): Boolean;
    function IsSame(hour: TOpeningSpan): Boolean;
    property OpenTime: TTime read FOpenTime write FOpenTime;
    property CloseTime: TTime read FCloseTime write FCloseTime;
  end;

  TOpeningHourList = class(TObject)
  private
    FHourList: TObjectList<TOpeningSpan>;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Add(open, close: TTime);
    function ToTimeString: String;
    function IsSame(value: TOpeningHourList): Boolean;
    procedure Sort;

    property HourList: TObjectList<TOpeningSpan> read FHourList;
  end;

  TOpeningDay = class(TOpeningHourList)
  private
    FDay: TDay;
  public
    function ToString: String; override;

    property Day: TDay read FDay write FDay;
  end;

  TConsolidatedList = class(TOpeningHourList)
  private
    FDays: TList<TDay>;
  public
    constructor Create;
    destructor Destroy;override;
    function ToString: String;override;

    procedure Assign(openDay: TOpeningDay);
    property Days: TList<TDay> read FDays;
  end;

  TOpeningList = class(TObject)
  private
    FDayList: TObjectList<TOpeningDay>;
    function getDayOpening(day: TDay): TOpeningDay;
    procedure SortDayList;
  public
    constructor Create;
    destructor Destroy;override;

    function ToString: String; override;
    function ToConsolidatedText: String;
    function ToSmallList: string;
    procedure Add(Day: TDay; open, close: TTime);
  end;

implementation

uses
  System.DateUtils, System.Generics.Defaults, System.Math;

{ TOpeningHoursList }

procedure TOpeningList.Add(Day: TDay; open, close: TTime);
var
  dayOpening: TOpeningDay;
begin
  dayOpening := getDayOpening(day);
  if dayOpening = nil then
  begin
    dayOpening := TOpeningDay.Create;
    dayOpening.Day := Day;
    FDayList.Add(dayOpening);
  end;
  dayOpening.Add(open, close);
end;

constructor TOpeningList.Create;
begin
  FDayList := TObjectList<TOpeningDay>.Create;
end;

destructor TOpeningList.Destroy;
begin
  FDayList.Free;
  inherited;
end;

function TOpeningList.getDayOpening(day: TDay): TOpeningDay;
var
  dayOpening: TOpeningDay;
begin
  Result := nil;
  for dayOpening in FDayList do
  begin
    if dayOpening.Day = day then
    begin
      Result := dayOpening;
      Break;
    end;
  end;
end;

procedure TOpeningList.SortDayList;
var
  day: TOpeningDay;
begin
  FDayList.Sort(TComparer<TOpeningDay>.Construct(
    function (const Day1, day2: TOpeningDay): Integer
    begin
      Result := CompareValue(Integer(day1.Day), Integer(day2.Day));
    end));

  for day in FDayList do
  begin
    day.Sort;
  end;
end;

function TOpeningList.ToConsolidatedText: String;
var
  day: TOpeningDay;
  currentDays: TList<TDay>;
  currentHours: TOpeningDay;

  procedure AppendText;
  var
    tmpDay: TDay;
    dayText: string;
  begin
    if Result <> '' then Result := Result +#13#10;
    dayText := '';
    for tmpDay in currentDays do
    begin
      if dayText <> '' then dayText := dayText+', ';
      dayText := dayText + tmpDay.ToShortDayName;
    end;
    Result := Result + dayText + ' '+currentHours.ToTimeString;
  end;
begin
  SortDayList;
  currentDays := TList<TDay>.Create;
  
  currentHours := nil;
  
  Result := '';
  for day in FDayList do
  begin
    if currentHours = nil then
    begin
      currentDays.Add(day.Day);
      currentHours := day;
    end else
    begin
      if day.IsSame(currentHours) then
      begin
        currentDays.Add(day.Day);
      end else
      begin
        AppendText;
        currentDays.Clear;
        currentDays.Add(day.Day);
        currentHours := day;
      end;
    end;
  end;

  if currentHours <> nil then AppendText;

  currentDays.Free;
end;

function TOpeningList.ToSmallList: string;
var
  openDay: TOpeningDay;
  lists: TObjectList<TConsolidatedList>;
  cList: TConsolidatedList;
  added: Boolean;
begin
  SortDayList;
  lists := TObjectList<TConsolidatedList>.Create;
  for openDay in FDayList do
  begin
    added:=false;
    for cList in lists do
    begin
      if cList.IsSame(openDay) then
      begin
        cList.Days.Add(openDay.Day);
        added := true;
        break;
      end;
    end;
    if not added then
    begin
      cList := TConsolidatedList.Create;
      lists.Add(cList);
      cList.Assign(openDay);
    end;
  end;

  Result := '';
  for cList in lists do
  begin
    if Result <> '' then Result := Result +#13#10;
    Result := Result + cList.ToString;
  end;

  lists.Free;
end;

function TOpeningList.ToString: String;
var
  day: TOpeningDay;
begin
  Result := '';
  SortDayList;
  for day in FDayList do
  begin
    if Result <> '' then Result := Result +#13#10;
    Result := Result + day.ToString;
  end;
end;

{ TDayOpening }

function TOpeningDay.ToString: String;
begin
  Result := day.ToDayName+': ';
  Result := Result + ToTimeString;
end;

{ TOpeningHour }

function TOpeningSpan.IsOverlapping(open, close: TTime): Boolean;
begin
  Result := false;
  if TimeInRange(open, FOpenTime, FCloseTime) or
     TimeInRange(close, FOpenTime, FCloseTime) then
  begin
    Result := true;
  end;
end;

function TOpeningSpan.IsSame(hour: TOpeningSpan): Boolean;
begin
  Result := SameTime(FOpenTime, hour.OpenTime) and SameTime(FCloseTime, hour.CloseTime);
end;

{ TOpeningHourList }

procedure TOpeningHourList.Add(open, close: TTime);
var
  hour: TOpeningSpan;
begin
  for hour in FHourList do
  begin
    if hour.IsOverlapping(open, close) then
    begin
      raise Exception.Create('Overlapping Time');
    end;
  end;

  hour := TOpeningSpan.Create;
  hour.OpenTime := open;
  hour.CloseTime := close;
  FHourList.Add(hour);

end;

constructor TOpeningHourList.Create;
begin
  FHourList := TObjectList<TOpeningSpan>.Create;
end;

destructor TOpeningHourList.Destroy;
begin
  FHourList.Free;
  inherited;
end;

function TOpeningHourList.IsSame(value: TOpeningHourList): Boolean;
var
  i: Integer;
  hour1: TOpeningSpan;
  hour2: TOpeningSpan;
begin
  if Self.HourList.Count <> value.HourList.Count then
  begin
    Result := false;
    exit;
  end;

  Result := true;
  for i := 0 to Self.HourList.Count-1 do
  begin
    hour1 := Self.HourList[i];
    hour2 := value.HourList[i];

    if not hour1.IsSame(hour2) then
    begin
      Result := false;
      break;
    end;
  end;
end;

procedure TOpeningHourList.Sort;
begin
  FHourList.Sort(TComparer<TOpeningSpan>.Construct(
      function(const span1, span2: TOpeningSpan): Integer
      begin
        Result := CompareTime(span1.OpenTime, span2.OpenTime);
        if Result = 0 then Result := CompareTime(span1.CloseTime, span2.CloseTime);
      end
    ));
end;

function TOpeningHourList.ToTimeString: String;
var
  hour: TOpeningSpan;
begin
  for hour in FHourList do
  begin
    if Result <> '' then Result := Result+' / ';
    Result := Result+FormatDateTime('hh:nn', hour.OpenTime)+' - '+FormatDateTime('hh:nn', hour.CloseTime);
  end;
end;

{ TConsolidatedList }

procedure TConsolidatedList.Assign(openDay: TOpeningDay);
var
  openSpan: TOpeningSpan;
begin
  for openSpan in openDay.HourList do
  begin
    Self.HourList.Add(openSpan);
  end;
  self.Days.Add(openDay.Day);
end;

constructor TConsolidatedList.Create;
begin
  inherited;
  FHourList.OwnsObjects := false;
  FDays := TList<TDay>.Create;
end;

destructor TConsolidatedList.Destroy;
begin
  FDays.Free;
  inherited;
end;

function TConsolidatedList.ToString: String;
var
  dayStr: string;
  day: TDay;
begin
  Result := '';
  dayStr := '';
  for day in FDays do
  begin
    if dayStr <> '' then dayStr := dayStr+', ';
    dayStr := dayStr + day.ToShortDayName;
  end;
  Result := dayStr + ': ' + ToTimeString;
end;

end.
