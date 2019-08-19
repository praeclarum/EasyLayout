

SRCS = EasyLayout/Layout.cs

all: pack

pack: EasyLayout/bin/Debug/EasyLayout.dll Makefile
	nuget pack EasyLayout.nuspec

EasyLayout/bin/Release/EasyLayout.dll: EasyLayout/EasyLayout.csproj $(SRCS)
	msbuild EasyLayout.sln /p:Configuration=Release









