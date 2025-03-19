import os
import shutil

# Define source and destination directories
source_dir = os.path.expanduser('~/Downloads')

# Define categories and file extensions
categories = {
    'Images': ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.svg', '.webp'],
    'Documents': ['.doc', '.docx', '.pdf', '.txt', '.odt', '.html'],
    'Archives': ['.zip', '.rar', '.tar', '.gz', '.deb'],
    'Spreadsheets': ['.xls', '.xlsx', '.ods', '.csv'],
    'Presentations': ['.ppt', '.pptx', '.odp'],
    'Scripts': ['.py', '.sh', '.bat'],
    'Videos': ['.mp4', '.avi', '.mkv', '.mov'],
    'Audio': ['.mp3'],
}

# Organize files into categories
for category, extensions in categories.items():
    category_path = os.path.join(source_dir, category)
    if not os.path.exists(category_path):
        os.makedirs(category_path)

    for filename in os.listdir(source_dir):
        file_path = os.path.join(source_dir, filename)
        if os.path.isfile(file_path):
            if any(filename.lower().endswith(ext) for ext in extensions):
                shutil.move(file_path, category_path)
                print(f"Moved {filename} to {category}")
