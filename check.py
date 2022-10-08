import glob
from pathlib import Path
from zipfile import ZipFile
from shutil  import rmtree, copy

moose="./Moose/Moose.lua"
Moose=Path(moose)

missions="./"
Missions=Path(missions)

temp="temp/"
Temp=Path(temp)


for f in Missions.rglob("*.miz"):

    # Print file name.
    print(f)

    # Try to delete temp folder.
    try:
        rmtree(temp)
    except:
        pass
    
    # Extract all the contents of zip file in different directory
    with ZipFile(f, mode='r') as miz:
        miz.extractall(temp)

    # Copy Moose.lua to temp dir.
    copy(moose, Temp.joinpath("l10n/DEFAULT/"))

    # Create new miz file
    with ZipFile(f, mode='w') as archive:
        for file_path in Temp.rglob("*"):
            archive.write(file_path, arcname=file_path.relative_to(temp))

    try:
        rmtree(temp)
    except:
        pass

    if True:
        with ZipFile(f, mode='r') as zipObj:
            zipObj.printdir()
            #for filename in zipObj.namelist():
            #    print(filename)