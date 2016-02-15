rm  -r shader-src
mkdir shader-src
mkdir shader-src/fragment
cp frag.source.glsl shader-src/fragment/fragment-inES.txt
./glsl_optimizer/glsl_optimizer_tests ./shader-src
cp shader-src/fragment/fragment-outES.txt frag.optimized.glsl 

