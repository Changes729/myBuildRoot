```sh
$ make BR2_EXTERNAL = ../my_tree/ my_x86_board_defconfig
#
# configuration written to /home/alexey/dev/article/ramdisk/buildroot/.config
#
$ make menuconfig
```

or

```sh
$ cd /tmp/build; make O=$PWD -C path/to/buildroot menuconfig
$ make all
```

take care of, in this dir, you should use `$(BR2_EXTERNAL_my_tree_PATH)` in configs and use `$BR2_EXTERNAL_my_tree_PATH` in `post-build.sh`
