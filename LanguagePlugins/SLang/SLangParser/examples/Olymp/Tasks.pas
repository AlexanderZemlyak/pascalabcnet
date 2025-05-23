unit Tasks;

{$savepcu false}

uses LightPT, TasksOlymp1;

initialization
  ServerAddr := ReadAllText('server.dat');
  CheckTask := CheckTaskT;
finalization
end.