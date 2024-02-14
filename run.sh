conan install . --deployer=full_deploy -s arch=x86_64 -s build_type=Release --build=missing
conan install . --deployer=full_deploy -s arch=armv8 -s build_type=Release --build=missing

conan bin:lipo create full_deploy/host --output-folder=universal

# just keep the last deployed architecture and rename to the universal architecture armv8.x86_64
rm build/Release/generators/fmt-release-x86_64-data.cmake
mv build/Release/generators/fmt-release-armv8-data.cmake build/Release/generators/fmt-release-armv8.x86_64-data.cmake

# substitute the paths in the files full_deploy/host now should point to universal:
sed -i '' 's|full_deploy/host|universal|g' build/Release/generators/conan_toolchain.cmake
sed -i '' 's|/armv8|/armv8.x86_64|g' build/Release/generators/conan_toolchain.cmake
sed -i '' 's|full_deploy/host|universal|g' build/Release/generators/fmt-release-armv8.x86_64-data.cmake
sed -i '' 's|/armv8|/armv8.x86_64|g' build/Release/generators/fmt-release-armv8.x86_64-data.cmake

cd build

cmake .. -DCMAKE_TOOLCHAIN_FILE=Release/generators/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release

cmake --build .  

lipo example -info

cd ..