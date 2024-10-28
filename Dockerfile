FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019

RUN powershell [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

ENV chocolateyUseWindowsCompression=false
RUN powershell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN powershell choco config set cachelocation C:\Downloads\ChocoCache; \
    choco feature disable --name "showDownloadProgress"; \
    choco install -y python --version 3.8.3; \
    choco install -y openssl --version 1.1.1.1900; \
    choco install -y vcredist2013 --version 12.0.40660.20180427; \
    choco install -y vcredist140 --version 14.34.31931; \
    choco install -y cmake --version 3.25.1; \
    choco install -y cppcheck --version 2.9; \
    choco install -y curl --version 7.87.0; \
    choco install -y git --version 2.39.0; \
    choco install -y winflexbison3 --version 2.5.24.20210105; \
    choco install -y 7zip --version 24.8.0; \
    choco install -y mono --version 6.12.0.206; \
    choco install -y dotnet-8.0-sdk --version 8.0.303; \
    choco install -y gitversion.portable --version 6.0.2; \
    choco install -y nuget.commandline --version 6.10.2; \
    Remove-Item -Recurse -Force C:\Downloads\*

RUN powershell wget https://github.com/ros2/choco-packages/releases/download/2022-03-15/asio.1.12.1.nupkg -OutFile C:\Downloads\asio.1.12.1.nupkg; \
    wget https://github.com/ros2/choco-packages/releases/download/2022-03-15/bullet.3.17.nupkg -OutFile C:\Downloads\bullet.3.17.nupkg; \
    wget https://github.com/ros2/choco-packages/releases/download/2022-03-15/cunit.2.1.3.nupkg -OutFile C:\Downloads\cunit.2.1.3.nupkg; \
    wget https://github.com/ros2/choco-packages/releases/download/2022-03-15/eigen.3.3.4.nupkg -OutFile C:\Downloads\eigen-3.3.4.nupkg; \
    wget https://github.com/ros2/choco-packages/releases/download/2022-03-15/tinyxml-usestl.2.6.2.nupkg -OutFile C:\Downloads\tinyxml-usestl.2.6.2.nupkg; \
    wget https://github.com/ros2/choco-packages/releases/download/2022-03-15/tinyxml2.6.0.0.nupkg -OutFile C:\Downloads\tinyxml2.6.0.0.nupkg; \
    choco install -y -s C:\Downloads asio cunit eigen tinyxml-usestl tinyxml2 bullet; \
    Remove-Item -Recurse -Force C:\Downloads\*

RUN powershell python -m pip install -U pip setuptools==59.6.0; \
    pip install catkin_pkg==1.0.0 cryptography==43.0.1 empy==3.3.4 importlib-metadata==8.5.0 lark==1.1.1 lxml==5.3.0 matplotlib==3.7.5 \
    netifaces==0.11.0 numpy==1.24.4 opencv-python==4.10.0.84 PyQt5==5.15.11 pillow==10.4.0 psutil==6.0.0 pycairo==1.26.1 pydot==1.4.2 pyparsing==2.4.7 \
    pyyaml==6.0.2 rosdistro==0.9.1 colcon-common-extensions==0.3.0 coverage==7.6.1 flake8==7.1.1 flake8-blind-except==0.2.1 flake8-builtins==2.5.0 \
    flake8-class-newline==1.6.0 flake8-comprehensions==3.15.0 flake8-deprecated==2.2.1 flake8-docstrings==1.7.0 flake8-import-order==0.18.2 \
    flake8-quotes==3.4.0 mock==5.1.0 mypy==0.931 pep8==1.7.1 pydocstyle==6.3.0 pytest==8.3.3 pytest-mock==3.14.0 vcstool==0.3.0

RUN powershell -NoProfile -ExecutionPolicy Bypass -Command Invoke-WebRequest "https://aka.ms/vs/16/release/vs_community.exe" -OutFile "%TEMP%\vs_community.exe" -UseBasicParsing

RUN "%TEMP%\vs_community.exe"  --quiet --wait --norestart --noUpdateInstaller --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop

RUN powershell wget https://github.com/ros2/ros2/releases/download/release-humble-20240807/ros2-humble-20240807-windows-release-amd64.zip -OutFile C:\Downloads\ros2-humble.zip; \
    Expand-Archive -LiteralPath C:\Downloads\ros2-humble.zip -DestinationPath C:/; \
    Remove-Item -Recurse -Force C:\Downloads\*

RUN powershell New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force

ENTRYPOINT C:/ros2-windows/local_setup.bat && C:\"Program Files (x86)"\"Microsoft Visual Studio"\2019\Community\Common7\Tools\VsDevCmd.bat && powershell.exe -NoLogo -ExecutionPolicy Bypass