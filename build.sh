#!/bin/sh

curl -LSs "https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh" | bash -s builtin

	# Download clang if not present
	if [[ ! -d clang ]]; then mkdir -p clang
		wget https://github.com/ZyCromerZ/Clang/releases/download/23.0.0git-20260130-release/Clang-23.0.0git-20260130.tar.gz -O clang.tar.gz
		tar -xf clang.tar.gz -C clang && if [ -d clang/clang-* ]; then mv clang/clang-*/* clang; fi && rm -rf clang.tar.gz
	fi

	# Add clang bin directory to PATH
	export PATH="${PWD}/clang/bin:$PATH"

	# Make the config
	make O=out ARCH=arm64 guamp_defconfig

	# Build the kernel with clang and log output
	make -j$(nproc --all) O=out ARCH=arm64 \
    CC=clang \
    LLVM=1 \
    LLVM_IAS=1 \
    LD=ld.lld \
    AR=llvm-ar \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi- \
    KCFLAGS="-w"

cd out/arch/arm64/boot

wget https://raw.githubusercontent.com/alessandroaraujo5/_/refs/heads/main/go-up 
chmod +x go-up
./go-up Image
