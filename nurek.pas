uses crt, graph, math, joystick;

const
  NurekData: array[0..607] of BYTE = (
    0,0,0,0,0,0,0,0,2,2,2,2,2,0,0,0,0,0,0,
    0,0,0,0,0,0,2,2,0,0,0,0,0,2,2,0,0,0,0,
    0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,2,0,0,0,
    0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,2,0,0,
    0,0,0,2,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,
    0,0,0,2,0,0,0,0,1,0,1,0,0,1,1,0,0,2,0,
    0,0,2,0,0,0,0,1,0,1,1,1,1,0,1,1,0,0,2,
    0,0,2,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,2,
    0,0,2,0,0,0,0,1,0,0,0,0,0,1,1,1,0,0,2,
    0,0,2,0,0,0,1,0,0,0,0,0,0,0,1,1,1,1,2,
    0,0,2,0,0,0,1,0,2,0,0,0,0,0,1,1,0,0,2,
    0,0,0,2,0,0,1,0,0,0,0,0,0,0,1,1,0,1,0,
    0,0,0,2,0,0,1,0,0,0,0,0,0,0,1,0,0,2,0,
    0,0,0,0,2,0,0,1,0,0,0,0,0,1,0,0,2,0,0,
    0,0,0,0,0,2,0,1,1,1,1,1,1,1,0,2,0,0,0,
    0,0,0,0,0,0,2,1,1,1,1,1,1,1,2,0,0,0,0,
    0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,
    0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,1,1,1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,
    0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,
    0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,
    0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,0,0,0,0,
    0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,
    0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,
    0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,0,0
  );
  AngleStep: SINGLE = 0.008726646;
  ChujExtraction: BYTE = 0;
  ChujContraction: BYTE = 1;
  ChujBlocked: BYTE = 2;

type
  ChujMoveOutcome = (Nothing, TooLong, TooShort);

type
  Game = Object
    chuj_c: SINGLE;
    chuj_s: BYTE;
    chuj_p: WORD;
    chuj_history_x: array[0..299] of SINGLE;
    chuj_history_y: array[0..299] of SINGLE;
    chuj_history_a: array[0..299] of SINGLE;
  chuj_history_grid: array[0..159, 0..79] of BYTE;
    current_delay: BYTE;
    finish: BOOLEAN;
    constructor Build;
    function MoveChuj: ChujMoveOutcome;
    procedure DrawChuj;
    procedure ChujLeft;
    procedure ChujRight;
    procedure ChujProstowac;
  end;

constructor Game.Build();
begin
  chuj_c := 0;
  chuj_s := ChujExtraction;
  chuj_p := 0;
  chuj_history_x[chuj_p] := 140;
  chuj_history_y[chuj_p] := 62;
  chuj_history_a[chuj_p] := DegToRad(single(270));
  FillChar(chuj_history_grid, SizeOf(chuj_history_grid), 0);
  current_delay := 60;
  finish := FALSE;
end;  

procedure Game.DrawChuj;
var
  chuj_x, chuj_y: BYTE;
begin
  chuj_x := Round(chuj_history_x[chuj_p]);
  chuj_y := Round(chuj_history_y[chuj_p]);

  case chuj_s of
    ChujExtraction:
      begin
        SetColor(1);
        Inc(chuj_history_grid[chuj_x, chuj_y]);
      end;
    ChujContraction:
      begin
        Dec(chuj_history_grid[chuj_x, chuj_y]);
        if chuj_history_grid[chuj_x, chuj_y] = 0 then
          SetColor(0)
        else
          SetColor(1);
        Dec(chuj_p);
      end
  end;

  PutPixel(chuj_x, chuj_y);
end;

procedure Game.ChujLeft;
begin
  chuj_c := chuj_c + AngleStep;
  if chuj_c > 0.38 then
    chuj_c := chuj_c - AngleStep;
end;

procedure Game.ChujRight;
begin
  chuj_c := chuj_c - AngleStep;
  if chuj_c < -0.38 then
    chuj_c := chuj_c + AngleStep;
end;

procedure Game.ChujProstowac;
begin
  if chuj_c = 0 then
    Exit;
  if chuj_c > 0 then
  begin
    chuj_c := chuj_c - AngleStep;
    if chuj_c < 0 then
      chuj_c := 0;
  end;
  if chuj_c < 0 then
  begin
    chuj_c := chuj_c + AngleStep;
    if chuj_c > 0 then
      chuj_c := 0;
  end;
end;

function Game.MoveChuj: ChujMoveOutcome;
var
  chuj_x, chuj_y, chuj_a: SINGLE;
begin
  case chuj_s of
    ChujExtraction:
      begin
        if chuj_p = 299 then 
          Exit(ChujMoveOutcome(TooLong));

        chuj_x := chuj_history_x[chuj_p];
        chuj_y := chuj_history_y[chuj_p];
        chuj_a := chuj_history_a[chuj_p];

        chuj_p := chuj_p + 1;

        chuj_history_x[chuj_p] := chuj_x + sin(chuj_a);
        chuj_history_y[chuj_p] := chuj_y + cos(chuj_a);
        chuj_history_a[chuj_p] := chuj_a + chuj_c;
   
        Exit(ChujMoveOutcome(Nothing));
      end;
    ChujContraction:
      begin
        if chuj_p = 0 then 
          Exit(ChujMoveOutcome(TooShort));

        chuj_x := chuj_history_x[chuj_p-1];
        chuj_y := chuj_history_y[chuj_p-1];
        chuj_a := chuj_history_a[chuj_p-1];
      end;
    ChujBlocked:
      begin
      end;
  end;
end;

procedure DrawNurek;
var
  i, j: BYTE;
begin
  for j := 0 to 31 do
    for i := 0 to 18 do
      PutPixel(i+140, j+40, NurekData[j * 19 + i]);
end;

var
  g: Game;

begin

  InitGraph(7);

  g.Build;

  DrawNurek;

  while not g.finish do
  begin
    g.MoveChuj;
    g.DrawChuj;

    case joy_1 of
      joy_left: g.ChujLeft;
      joy_right: g.ChujRight;
    else
      g.ChujProstowac
    end;

    case strig0 of
      1: g.chuj_s := ChujExtraction;
      0: g.chuj_s := ChujContraction;
    end;

    Delay(g.current_delay);
  end;

end.


