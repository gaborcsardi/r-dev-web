call d:\RCompile\CRANpkg\make\set_Env_new.bat 
call d:\RCompile\CRANpkg\make\set_recent_Env.bat 

d:
cd d:\Rcompile\CRANpkg\make
R -f ReadMe.R --vanilla --quiet

pause
exit
