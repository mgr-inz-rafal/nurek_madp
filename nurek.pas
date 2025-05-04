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

type
  ChujMoveOutcome = (Nothing);

type
  Game = Object
    chuj_x: SINGLE;
    chuj_y: SINGLE;
    chuj_a: SINGLE;
    chuj_c: SINGLE;
    current_delay: BYTE;
    finish: BOOLEAN;
    constructor Build;
    function MoveChuj: ChujMoveOutcome;
    procedure DrawChuj;
    procedure ChujLeft;
    procedure ChujRight;
  end;

constructor Game.Build();
begin
  chuj_x := 139;
  chuj_y := 62;
  chuj_c := 0;
  chuj_a := DegToRad(single(270));
  current_delay := 60;
  finish := FALSE;
end;  

procedure Game.DrawChuj;
begin
  PutPixel(Round(chuj_x), Round(chuj_y), 1);
end;

procedure Game.ChujLeft;
begin
  chuj_c := chuj_c + AngleStep;
end;

procedure Game.ChujRight;
begin
  chuj_c := chuj_c - AngleStep;
end;

function Game.MoveChuj: ChujMoveOutcome;
begin
  chuj_x := chuj_x + sin(chuj_a);
  chuj_y := chuj_y + cos(chuj_a);
  chuj_a := chuj_a + chuj_c;

  Result := ChujMoveOutcome(Nothing);
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
    g.DrawChuj;
    g.MoveChuj;

    case joy_1 of
      joy_left: g.ChujLeft;
      joy_right: g.ChujRight;
    end;

    Delay(g.current_delay);
  end;

end.


