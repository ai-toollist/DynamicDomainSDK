#!/bin/bash
# 用法: ./strip_go.sh <path_to_aar>
# 描述: 从 Gomobile 生成的 AAR 中移除重复的 Go 运行时类，以解决与其他 Go SDK (如 OpenIM) 的冲突。

set -e

if [ -z "$1" ]; then
    echo "错误: 请提供 AAR 文件路径。"
    echo "用法: $0 <path_to_aar>"
    exit 1
fi

AAR_PATH=$(realpath "$1")
AAR_NAME=$(basename "$AAR_PATH")
DIR_NAME=$(dirname "$AAR_PATH")
STRIPPED_NAME="${AAR_NAME%.aar}_stripped.aar"
TEMP_DIR=$(mktemp -d)

echo "--- 开始处理 $AAR_NAME ---"
echo "工作目录: $TEMP_DIR"

# 1. 解压 AAR
echo "1. 解压 AAR..."
unzip -q "$AAR_PATH" -d "$TEMP_DIR/aar_content"

# 2. 解压 classes.jar
echo "2. 解压 classes.jar..."
mkdir -p "$TEMP_DIR/jar_content"
unzip -q "$TEMP_DIR/aar_content/classes.jar" -d "$TEMP_DIR/jar_content"

# 3. 删除冲突的 Go 运行时
echo "3. 移除 go/ 目录..."
if [ -d "$TEMP_DIR/jar_content/go" ]; then
    rm -rf "$TEMP_DIR/jar_content/go"
    echo "   已移除 go/ 目录。"
else
    echo "   未找到 go/ 目录，跳过。"
fi

# 4. 重新打包 classes.jar
echo "4. 重新打包 classes.jar..."
rm "$TEMP_DIR/aar_content/classes.jar"
cd "$TEMP_DIR/jar_content"
zip -qr "$TEMP_DIR/aar_content/classes.jar" .

# 5. 重新打包 AAR
echo "5. 重新生成 AAR..."
cd "$TEMP_DIR/aar_content"
zip -qr "$DIR_NAME/$STRIPPED_NAME" .

echo "--- 处理完成 ---"
echo "已生成剥离后的 AAR: $DIR_NAME/$STRIPPED_NAME"
echo "请在项目中引用该文件，并确保项目依赖中包含另一个完整的 Go SDK (如 OpenIM)。"

# 清理
rm -rf "$TEMP_DIR"
