#!/usr/bin/env python3
"""
Script để tự động thêm fontFamily: 'FilsonPro' vào tất cả TextStyle trong project Flutter
"""

import os
import re
import sys

def add_font_family_to_textstyle(content):
    """
    Thêm fontFamily: 'FilsonPro' vào TextStyle nếu chưa có fontFamily
    """
    # Pattern để tìm TextStyle() mà chưa có fontFamily
    pattern = r'TextStyle\s*\(\s*([^)]*?)\s*\)'
    
    def replace_textstyle(match):
        textstyle_content = match.group(1).strip()
        
        # Kiểm tra xem đã có fontFamily chưa
        if 'fontFamily' in textstyle_content:
            return match.group(0)  # Không thay đổi nếu đã có fontFamily
        
        # Nếu TextStyle trống
        if not textstyle_content:
            return "TextStyle(\n      fontFamily: 'FilsonPro',\n    )"
        
        # Nếu có nội dung khác, thêm fontFamily vào đầu
        lines = textstyle_content.split('\n')
        if len(lines) == 1 and not textstyle_content.endswith(','):
            # Single line without trailing comma
            return f"TextStyle(\n      fontFamily: 'FilsonPro',\n      {textstyle_content},\n    )"
        else:
            # Multi-line hoặc có trailing comma
            return f"TextStyle(\n      fontFamily: 'FilsonPro',\n      {textstyle_content}\n    )"
    
    return re.sub(pattern, replace_textstyle, content, flags=re.DOTALL)

def add_font_family_to_google_fonts(content):
    """
    Thêm fontFamily: 'FilsonPro' vào GoogleFonts.xxx() styles
    """
    # Pattern để tìm GoogleFonts.xxx() calls
    pattern = r'GoogleFonts\.\w+\s*\(\s*([^)]*?)\s*\)'
    
    def replace_google_fonts(match):
        google_fonts_content = match.group(1).strip()
        
        # Kiểm tra xem đã có fontFamily chưa
        if 'fontFamily' in google_fonts_content:
            return match.group(0)  # Không thay đổi nếu đã có fontFamily
        
        # Thay thế bằng TextStyle với FilsonPro
        if not google_fonts_content:
            return "TextStyle(\n      fontFamily: 'FilsonPro',\n    )"
        else:
            # Giữ lại các properties khác, thêm fontFamily
            return f"TextStyle(\n      fontFamily: 'FilsonPro',\n      {google_fonts_content}\n    )"
    
    return re.sub(pattern, replace_google_fonts, content, flags=re.DOTALL)

def process_file(file_path):
    """
    Xử lý một file Dart
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Thêm fontFamily vào TextStyle
        content = add_font_family_to_textstyle(content)
        
        # Thêm fontFamily vào GoogleFonts
        content = add_font_family_to_google_fonts(content)
        
        # Nếu có thay đổi, ghi lại file
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"✅ Updated: {file_path}")
            return True
        else:
            print(f"⏭️  No changes: {file_path}")
            return False
            
    except Exception as e:
        print(f"❌ Error processing {file_path}: {e}")
        return False

def find_dart_files(root_dir):
    """
    Tìm tất cả file .dart trong project
    """
    dart_files = []
    exclude_dirs = {'.dart_tool', 'build', '.git', 'ios', 'android', 'windows', 'linux', 'macos', 'web'}
    
    for root, dirs, files in os.walk(root_dir):
        # Loại bỏ các thư mục không cần thiết
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        
        for file in files:
            if file.endswith('.dart'):
                dart_files.append(os.path.join(root, file))
    
    return dart_files

def main():
    """
    Main function
    """
    project_root = "/Users/huuthanhflutter/LinkTC/openim_flutter_cnl"
    
    print("🚀 Starting to add fontFamily: 'FilsonPro' to all TextStyle...")
    print(f"📁 Project root: {project_root}")
    
    # Tìm tất cả file .dart
    dart_files = find_dart_files(project_root)
    print(f"📄 Found {len(dart_files)} Dart files")
    
    # Xử lý từng file
    updated_count = 0
    for file_path in dart_files:
        if process_file(file_path):
            updated_count += 1
    
    print(f"\n🎉 Complete! Updated {updated_count} files out of {len(dart_files)} Dart files")
    print("💡 Remember to run 'flutter pub get' and test your app!")

if __name__ == "__main__":
    main()
