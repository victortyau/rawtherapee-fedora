echo "running script to install rawtherapee on fedora"

starttime=$(date +%s)

arr_libraries=(cmake curl expat-devel fftw-devel gcc-c++ git gtk3-devel gtkmm30-devel 
lcms2-devel lensfun-devel libatomic libcanberra-devel libiptcdata-devel libjpeg-turbo-devel 
libpng-devel librsvg2-devel libtiff-devel zlib-devel)

arr_install_libraries=()

echo ${#arr_libraries[@]}
echo ${#arr_install_libraries[@]}

i=0

while [ $i -lt ${#arr_libraries[@]} ]
    do
        number=$(rpm -qa ${arr_libraries[$i]} | wc -c )
        if [ $number -gt 0 ];
        then
            echo -e "[\xE2\x9C\x94] ${arr_libraries[$i]} existing"
        else
            echo -e "[\xE2\x9D\x8C] ${arr_libraries[$i]} missing"
            arr_install_libraries+=(${arr_libraries[$i]})       
       fi
        i=$((i+1))
    done

echo ${#arr_libraries[@]}
echo ${#arr_install_libraries[@]}

libs=$(IFS=$' '; echo "${arr_install_libraries[*]}")

if [ ${#arr_install_libraries[@]} -gt 0 ];
  then
    sudo dnf install $libs
fi

git clone "git@github.com:Beep6581/RawTherapee.git"

cd RawTherapee

mkdir build

cd build

cmake \
    -DCMAKE_BUILD_TYPE="release"  \
    -DCACHE_NAME_SUFFIX="5-dev" \
    -DPROC_TARGET_NUMBER="2" \
    -DBUILD_BUNDLE="ON" \
    -DBUNDLE_BASE_INSTALL_DIR="$HOME/programs/rawtherapee" \
    -DOPTION_OMP="ON" \
    -DWITH_LTO="OFF" \
    -DWITH_PROF="OFF" \
    -DWITH_SAN="OFF" \
    -DWITH_SYSTEM_KLT="OFF" \
    ..

make --jobs=4

make install

endtime=$(date +%s)

secs=$(($endtime - $starttime))

printf 'Elapsed Time %dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))