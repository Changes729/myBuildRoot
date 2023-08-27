```sh
[alexey@alexey-pc buildroot] $ make BR2_EXTERNAL = ../my_tree/ my_x86_board_defconfig
#
# configuration written to /home/alexey/dev/article/ramdisk/buildroot/.config
#
[alexey@alexey-pc buildroot] $ make menuconfig
```

take care of, in this dir, you should use `$(BR2_EXTERNAL_my_tree_PATH)` in configs and use `$BR2_EXTERNAL_my_tree_PATH` in `post-build.sh`