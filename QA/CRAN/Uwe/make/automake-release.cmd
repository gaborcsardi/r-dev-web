call d:\RCompile\CRANpkg\make\set_Env_new.bat 
call d:\RCompile\CRANpkg\make\set_recent_Env.bat 
rem set mailMaintainer=no
set mailMaintainer=yes

d:
cd d:\Rcompile\CRANpkg\make
R CMD BATCH --no-restore --no-save Auto-Pakete.R log\Auto-Pakete-release.Rout
exit
