# Asar 文件说明

本目录下的 .part_* 文件是分割的大文件，需要合并后使用。

## 合并方法

```bash
# 合并汉化版
cat data/zh.part_* > data/app-asar-zh.bin

# 合并英文版
cat data/en.part_* > data/app-asar-en.bin
```

合并后删除分片文件：
```bash
rm data/*.part_*
```
