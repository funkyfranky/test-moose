import os
from pathlib import Path
from zipfile import ZipFile
from shutil  import rmtree, copy
import argparse

# Command line argument parser.
parser = argparse.ArgumentParser(description='Blabla.')

# Add argument for Moose path.
parser.add_argument('MoosePath', metavar='moose', type=str, help='path to Moose.lua file', default="./")

# Add argument for Moose path.
parser.add_argument('MissionPath', metavar='missions', type=str, help='path to missions', default="./")


# Execute the parse_args() method
args = parser.parse_args()

# Path to Moose.lua
Moose=Path(args.MoosePath)

# Moose.lua file
MooseLua=Moose / "Moose.lua"

if MooseLua.exists():
    print(MooseLua)
    print("Moose.lua exists")
else:
    print(f"{MooseLua.name} does not exist")
    quit()

# Path to search for mission (miz) files
Missions=Path(args.MissionPath)

# Temp directory.
temp="temp/"
Temp=Path(temp)

# Try to delete temp folder.
if Temp.is_dir():
    rmtree(Temp)


for f in Missions.rglob("*.miz"):

    # Print file name.
    print(f)

    # Extract all the contents of zip file in different directory
    with ZipFile(f, mode='r') as miz:
        miz.extractall(Temp)

    # Copy Moose.lua to temp dir.
    #copy(MooseLua, Temp.joinpath("l10n/DEFAULT/"))
    copy(MooseLua, Temp / "l10n/DEFAULT/")

    # Create new miz file
    with ZipFile(f, mode='w') as archive:
        for file_path in Temp.rglob("*"):
            archive.write(file_path, arcname=file_path.relative_to(Temp))

    try:
        rmtree(Temp)
    except:
        pass

    if True:
        with ZipFile(f, mode='r') as zipObj:
            zipObj.printdir()
            #for filename in zipObj.namelist():
            #    print(filename)