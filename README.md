# MikanOS-docker

[MikanOS](https://github.com/uchan-nos/mikanos)を動かすためのDockerfile

[ここ](https://github.com/uchan-nos/mikanos-build)をDockerfileに閉じ込めただけ

## 使い方

### イメージのビルド

    $ make docker-build

### MikanOSのソースコードの入手

このリポジトリのsubmoduleになっているのでsubmodule updateするだけ

    $ git submodule update --init

### ブートローダーのビルド

    $ make MikanLoader

build/edk2/MikanLoaderX64 以下に色々できる

### MikanOSのビルド

    $ make image

イメージファイルの実体は mikanos/disk.img

### qemuで実行する

    $ make run-qemu

qemuのウィンドウが立ち上がり，少し待てばMikanOSが起動するはず

## 備考

Ubuntu20.04でのみ動作確認済み

