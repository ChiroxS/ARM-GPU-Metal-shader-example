rm -f ./Libs/add.ir
rm -f ./Libs/add.metallib
xcrun -sdk macosx metal -o Libs/add.ir  -c Kernels/add.metal
xcrun -sdk macosx metallib -o Libs/add.metallib Libs/add.ir
