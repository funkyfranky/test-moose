from zipfile import ZipFile
from pathlib import Path

directory = Path("temp/")

with ZipFile("hallo.zip", mode='w') as archive:
    for file_path in directory.rglob("*"):
        archive.write(file_path, arcname=file_path.relative_to(directory))
