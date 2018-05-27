set targetDir=%~1
set solutionDir=%~2
set targetName=%~3

echo TARGETDIR=%targetDir%
echo SOLUTIONDIR=%solutionDir%
echo TARGETNAME=%targetName%

cd "%targetDir%"
<NUL set /p="PWD="
cd

set tools="%solutionDir%tools"
echo TOOLSDIR=%tools%

"%tools%\ildasm" %targetName%.dll /out=%targetName%.il /linenum

dotnet "%tools%\MethodRenamer.dll" RenameMappings.json %targetName%.il %targetName%.fixed.il

del %targetName%.dll %targetName%.pdb

rem although /pdb is specified, no pdb file is created
rem probably related to https://github.com/dotnet/coreclr/issues/15299
"%tools%\ilasm" %targetName%.fixed.il /OUTPUT=%targetName%.dll /dll /pdb

del %targetName%.il %targetName%.fixed.il del %targetName%.res *.resources
