uses crt, graph, math;

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

type
  ChujMoveOutcome = (Nothing);

type
  Game = Object
    chuj_x: BYTE;
    chuj_y: BYTE;
    chuj_a: SINGLE;
    finish: BOOLEAN;
    constructor Build;
    function MoveChuj: ChujMoveOutcome;
    procedure DrawChuj;
  end;

constructor Game.Build();
begin
  chuj_x := 139;
  chuj_y := 62;
  chuj_a := DegToRad(single(270));
  finish := FALSE;
end;  

procedure Game.DrawChuj;
begin
  PutPixel(chuj_x, chuj_y, 1);
end;

function Game.MoveChuj: ChujMoveOutcome;
begin
  chuj_x := Byte(Round(single(chuj_x) + sin(chuj_a)));
  chuj_y := Byte(Round(single(chuj_y) + cos(chuj_a)));

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
  end;

end.


