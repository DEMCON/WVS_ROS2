cd host
git config --global --add safe.directory '*' 
cmd /c 'vcs import < wvs_ros2_dotnet_humble.repos'
colcon build --cmake-args "-DBUILD_STANDALONE=ON" "-DCMAKE_BUILD_TYPE=Release" --merge-install --event-handlers console_cohesion+
cp wvs_ros2.nuspec install/bin
nuget pack install/bin/wvs_ros2.nuspec -Version "$(GitVersion /ShowVariable SemVer)" -Verbosity detailed