import pathlib

directory = pathlib.Path("temp/")

for file_path in directory.rglob("*"):
    print(file_path)