unit Tasks;

{$savepcu false}

uses LightPT, DSLExample;

initialization
  ServerAddr := ReadAllText('server.dat');
  CheckTask := CheckTaskT;
finalization
end.