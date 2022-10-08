import glob
from zipfile import ZipFile

moose="./Moose/Moose.lua"

for f in glob.glob('./**/*.miz', recursive=True):
    print(f)

    with ZipFile(f, mode='r') as zipObj:
        zipObj.printdir()
        for filename in zipObj.namelist():
            print(filename)

    with ZipFile(f, mode='a') as zipObj:
        zipObj.write(moose, arcname="./l10n/DEFAULT/Moose.lua")

    with ZipFile(f, mode='r') as zipObj:
        zipObj.printdir()
        for filename in zipObj.namelist():
            print(filename)

    with ZipFile(f, mode='r') as zipObj:
        # Extract all the contents of zip file in different directory
        zipObj.extractall('temp')
