-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Settings
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Enable components.
local RangeON          = true
local AtisON           = true
local AtcON            = true
local AirwingOn        = false
local foxON            = true
local miscON           = false
local StennisON        = true
local CarrierStaticsON = false
local WarehouseON      = false
local SRSON            = true

-- Setting defaults.
_SETTINGS:SetPlayerMenuOn()
_SETTINGS:SetMenutextShort(true)
_SETTINGS:SetMenuStatic(true)

-- Debug and trace.
BASE:TraceOff()
--PROFILER.Start()

local SRSpath=nil
if SRSON then
  SRSpath="D:/DCS/_SRS"
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Zones
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Zone table.
local zone={}

zone.DronesRedAlpha=ZONE:New("Zone Drones Red Alpha")       --Core.Zone#ZONE
zone.TankerBlueAlpha=ZONE:New("Zone Tanker Blue Alpha")     --Core.Zone#ZONE
zone.TankerBlueBravo=ZONE:New("Zone Tanker Blue Bravo")     --Core.Zone#ZONE
zone.TankerBlueCharlie=ZONE:New("Zone Tanker Blue Charlie") --Core.Zone#ZONE
zone.AWACSBlueAlpha=ZONE:New("Zone AWACS Blue Alpha")       --Core.Zone#ZONE
zone.AWACSBlueBravo=ZONE:New("Zone AWACS Blue Bravo")       --Core.Zone#ZONE
zone.RangePalmyra=ZONE:New("Zone Range Palmyra")            --Core.Zone#ZONE
zone.RangeTripoli=ZONE:New("Zone Range Tripoli")            --Core.Zone#ZONE
zone.RangeAbuAlDuhur=ZONE:New("Zone Range Abu al-Duhur")    --Core.Zone#ZONE
zone.RangeTabqa=ZONE:New("Zone Range Tabqa")                --Core.Zone#ZONE
zone.RangeRuConvoy=ZONE:New("Zone Range Ru Convoy")         --Core.Zone#ZONE
zone.RangeCypressNorth=ZONE:New("Zone Range Cypress North") --Core.Zone#ZONE

for _,_zone in pairs(zone) do
  local z=_zone --Core.Zone#ZONE
  z:DrawZone()
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ATIS
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

local atis={}

if AtisON then

  local freq=130.0

  atis.Bassel_Al_Assad=ATIS:New(AIRBASE.Syria.Bassel_Al_Assad, freq) --Ops.ATIS#ATIS
  atis.Bassel_Al_Assad:SetRadioRelayUnitName("ATIS Relay Bassel Al-Assad")
  atis.Bassel_Al_Assad:SetTowerFrequencies({250.500, 118.100})
  atis.Bassel_Al_Assad:AddILS(109.10, "17")
  atis.Bassel_Al_Assad:SetVOR(114.80)
  atis.Bassel_Al_Assad:SetSRS(SRSpath)
  atis.Bassel_Al_Assad:Start()

  local freq=131.0

  atis.Beirut_Rafic_Hariri=ATIS:New(AIRBASE.Syria.Beirut_Rafic_Hariri, freq) --Ops.ATIS#ATIS
  atis.Beirut_Rafic_Hariri:SetRadioRelayUnitName("ATIS Relay Bairut-Rafic Hariri")
  atis.Beirut_Rafic_Hariri:SetTowerFrequencies({251.4, 118.9})
  atis.Beirut_Rafic_Hariri:AddILS(109.50, "17")
  atis.Beirut_Rafic_Hariri:SetVOR(112.6)
  atis.Beirut_Rafic_Hariri:SetSRS(SRSpath)
  atis.Beirut_Rafic_Hariri:Start()

  local freq=132.0

  atis.Incirlik=ATIS:New(AIRBASE.Syria.Incirlik, freq) --Ops.ATIS#ATIS
  atis.Incirlik:SetRadioRelayUnitName("ATIS Relay Incirlik")
  atis.Incirlik:SetTowerFrequencies({360.1, 129.4})
  atis.Incirlik:AddILS(111.70, "23")
  atis.Incirlik:AddILS(109.3, "05")
  atis.Incirlik:SetVOR(108.4)
  atis.Incirlik:SetTACAN(21)
  atis.Incirlik:SetSRS(SRSpath)
  atis.Incirlik:Start()
  
  local freq=133.0

  atis.Akrotiri=ATIS:New(AIRBASE.Syria.Akrotiri, freq) --Ops.ATIS#ATIS
  atis.Akrotiri:SetRadioRelayUnitName("ATIS Relay Akrotiri")
  atis.Akrotiri:SetTowerFrequencies({251.7, 128.9})
  atis.Akrotiri:AddILS(109.7, "29")
  atis.Akrotiri:SetVOR(116)
  atis.Akrotiri:SetTACAN(107)
  atis.Akrotiri:AddNDBinner(365, "29")
  atis.Akrotiri:SetSRS(SRSpath)
  atis.Akrotiri:Start()  

end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ATC
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

local atc={}

if AtcON then

  local FC_Assad=FLIGHTCONTROL:New(AIRBASE.Syria.Bassel_Al_Assad, 251, nil, SRSpath)
  FC_Assad:SetParkingGuard("Parking Guard")
  FC_Assad:Start()

end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tankers for AAR
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function tankerKC130spawned(group)
  local flightgroup=FLIGHTGROUP:New(group)
  flightgroup:SetDefaultCallsign(CALLSIGN.Tanker.Arco, 1)
  flightgroup:SetDefaultTACAN(10, "ALF"):SetDefaultRadio(310)
  local auftrag=AUFTRAG:NewTANKER(zone.TankerBlueCharlie:GetCoordinate(), 15000, 350, 90, 50)
  flightgroup:AddMission(auftrag)
end

local function tankerKC135spawned(group)
  local flightgroup=FLIGHTGROUP:New(group)
  flightgroup:SetDefaultCallsign(CALLSIGN.Tanker.Arco, 2)
  flightgroup:SetDefaultTACAN(11, "BRA"):SetDefaultRadio(311)
  local auftrag=AUFTRAG:NewTANKER(zone.TankerBlueCharlie:GetCoordinate(), 16000, 350, 90, 50)
  flightgroup:AddMission(auftrag)
end

local tankerKC130=SPAWN:New("KC-130 Template"):OnSpawnGroup(tankerKC130spawned):SpawnInZone(zone.TankerBlueCharlie, nil, UTILS.FeetToMeters(10000), UTILS.FeetToMeters(10000))
local tankerKC135=SPAWN:New("KC-135 Template"):OnSpawnGroup(tankerKC135spawned):SpawnInZone(zone.TankerBlueCharlie, nil, UTILS.FeetToMeters(11000), UTILS.FeetToMeters(11000))

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Warehouses
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Warehouse table.
local warehouse={}

if WarehouseON then
  
  warehouse.Incirlik   = WAREHOUSE:New(STATIC:FindByName("Warehouse Incirlik"))      --Functional.Warehouse#WAREHOUSE
  warehouse.Jirah      = WAREHOUSE:New(STATIC:FindByName("Warehouse Jirah"))         --Functional.Warehouse#WAREHOUSE
  warehouse.Stennis    = WAREHOUSE:New("USS Stennis")                                --Functional.Warehouse#WAREHOUSE
  
  -- Start warehouses, no reports.
  for _,_warehouse in pairs(warehouse) do
    local wh=_warehouse --Functional.Warehouse#WAREHOUSE
    wh:SetReportOff()
    wh:Start()
  end

  ------------------
  -- Al Dhafra AB --
  ------------------
  
  warehouse.Jirah:AddAsset("F-14B Group",   2, nil, nil, nil, nil, AI.Skill.EXCELLENT, nil, "Goto Stennis")
  warehouse.Jirah:AddAsset("F/A-18C Group", 2, nil, nil, nil, nil, AI.Skill.EXCELLENT, nil, "Goto Stennis")
  
  warehouse.Jirah:AddRequest(warehouse.Stennis, WAREHOUSE.Descriptor.GROUPNAME, "F-14B Group",   1, nil, nil, nil, "Go Stennis")
  warehouse.Jirah:AddRequest(warehouse.Stennis, WAREHOUSE.Descriptor.GROUPNAME, "F/A-18C Group", 2, nil, nil, nil, "Go Stennis")

  -----------------
  -- USS Stennis --
  -----------------

  warehouse.Stennis:AddRequest(warehouse.Incirlik, WAREHOUSE.Descriptor.GROUPNAME, "F-14B Group", 1, nil, nil, nil, "Go Stennis")
  
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Airwings
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Red (Russian) side.
local Ru={}
Ru.Squad={} -- Russian squadrons.
Ru.Wing={}  -- Russian airwings.

-- Blue (US) side.
local US={}
US.Squad={} -- US squadrons.
US.Wing={}  -- US airwings.

if AirwingOn then

  ---
  -- BLUE (US)
  ---

  US.Wing.Incirlik = AIRWING:New(STATIC:FindByName("Warehouse Incirlik"), "Incirlik")  --Ops.AirWing#AIRWING
  
  US.Squad.Tanker97th=SQUADRON:New("KC-135MPRS Template", 5, "97th Air Refueling") --Ops.Squadron#SQUADRON
  US.Squad.Tanker97th:AddMissionCapability({AUFTRAG.Type.TANKER})
  US.Squad.Tanker97th:SetModex(800)
  US.Squad.Tanker97th:SetCallsign(CALLSIGN.Tanker.Texaco, 1)
  
  US.Squad.AirControl963rd=SQUADRON:New("E-3A Template", 5, "963rd Airborne Air Control") --Ops.Squadron#SQUADRON
  US.Squad.AirControl963rd:AddMissionCapability({AUFTRAG.Type.AWACS})
  US.Squad.AirControl963rd:SetModex(900)
  US.Squad.AirControl963rd:SetCallsign(CALLSIGN.AWACS.Darkstar, 1)  
  
  US.Wing.Incirlik:AddPatrolPointTANKER(zone.TankerBlueAlpha:GetCoordinate(), 20000, 350, 090, 20)
  US.Wing.Incirlik:AddPatrolPointTANKER(zone.TankerBlueBravo:GetCoordinate(), 20000, 350, 090, 20)

  US.Wing.Incirlik:AddPatrolPointAWACS(zone.AWACSBlueAlpha:GetCoordinate(), 30000, 350, 000, 20)
  US.Wing.Incirlik:AddPatrolPointAWACS(zone.AWACSBlueBravo:GetCoordinate(), 30000, 350, 000, 20)
  
  US.Wing.Incirlik:SetNumberTankerBoom(1)
  US.Wing.Incirlik:SetNumberAWACS(1)

  -- Add squads to airwing.
  for _,Squadron in pairs(US.Squad) do
    US.Wing.Incirlik:AddSquadron(Squadron)
  end

  -- Start airwing.  
  US.Wing.Incirlik:Start()


  ---
  -- RED (Russian)
  ---

  Ru.Wing.Jirah = AIRWING:New(STATIC:FindByName("Warehouse Jirah"), "Jirah")  --Ops.AirWing#AIRWING
  
  Ru.Squad.Fighter2nd=SQUADRON:New("MiG-23MLD", 10, "2nd Russian Fighter") --Ops.Squadron#SQUADRON
  Ru.Squad.Fighter2nd:AddMissionCapability({AUFTRAG.Type.ORBIT})
  Ru.Squad.Fighter2nd:SetModex(100)
  Ru.Squad.Fighter2nd:SetCallsign(CALLSIGN.Aircraft.Uzi)
  
  Ru.Wing.Jirah:NewPayload(GROUP:FindByName("MiG-23MLD"), -1, {AUFTRAG.Type.ORBIT})
    
  -- Add squads to airwing.
  for _,Squadron in pairs(Ru.Squad) do
    Ru.Wing.Jirah:AddSquadron(Squadron)
  end  
  
  -- Start airwing.
  Ru.Wing.Jirah:Start()

  -- Drones
  for i=1,5 do
  
    local mission=AUFTRAG:NewORBIT(zone.DronesRedAlpha:GetRandomCoordinate(), math.random(10,15)*1000, 350, 180, 10)
    
    -- Simple drones for target practice. No reaction at all.
    mission:SetROE(ENUMS.ROE.WeaponHold)
    mission:SetROT(ENUMS.ROT.NoReaction)
    
    Ru.Wing.Jirah:AddMission(mission)
    
  end

end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Bombing Ranges
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Range Table.
local range={}

if RangeON then
  
  --- Range Palmyra
  range.Palmyra=RANGE:New("Palmyra")  --Functional.Range#RANGE
  range.Palmyra:SetRangeZone(zone.RangePalmyra)
  range.Palmyra:AddBombingTargetCoordinate(STATIC:FindByName("Range Palmyra Circle A"):GetCoordinate(), "Circle A", 50)
  range.Palmyra:AddBombingTargetCoordinate(STATIC:FindByName("Range Palmyra Circle B"):GetCoordinate(), "Circle B", 50)
  range.Palmyra:AddStrafePit("Range Palmyra Strafe Pit 1",  nil, nil, nil, true)
  range.Palmyra:SetRangeControl(125.000, "Range Palmyra Control Relay")
  range.Palmyra:SetInstructorRadio(125.000, "Range Palmyra Instructor Relay")
  
  --- Range Tripoli
  range.Tripoli=RANGE:New("Tripoli")  --Functional.Range#RANGE
  range.Tripoli:SetRangeZone(zone.RangeTripoli)
  range.Tripoli:AddBombingTargetGroup(GROUP:FindByName("Red Cargo Ship Tripoli"), 50)
  range.Tripoli:SetRangeControl(125.500, "Range Tripoli Control Relay")
  range.Tripoli:SetInstructorRadio(125.500, "Range Tripoli Instructor Relay")
  
  --- Range Tabqa
  range.Tabqa=RANGE:New("Tabqa")  --Functional.Range#RANGE
  range.Tabqa:SetRangeZone(zone.RangeTabqa)
  range.Tabqa:AddBombingTargetGroup(GROUP:FindByName("SA-2 Tabqua"), 50)
  range.Tabqa:SetRangeControl(126.000, "Range Tabqa Control Relay")
  range.Tabqa:SetInstructorRadio(126.000, "Range Tabqa Instructor Relay")
    
  --- Range Abu al-Duhr
  range.AbuAlDuhur=RANGE:New("Abu al-Duhr")  --Functional.Range#RANGE
  range.AbuAlDuhur:SetRangeZone(zone.RangeAbuAlDuhur)
  for i=1,6 do
    local name="Range Abu al-Duhur Static-"..i
    range.AbuAlDuhur:AddBombingTargetUnit(STATIC:FindByName(name, false), 50)
  end
  range.AbuAlDuhur:SetRangeControl(126.500, "Range Abu al-Duhur Control Relay")
  range.AbuAlDuhur:SetInstructorRadio(126.500, "Range Abu al-Duhur Instructor Relay")

  --- Range Russian Convoy (Tankers)
  range.RuConvoy=RANGE:New("Russian Convoy Tanker")  --Functional.Range#RANGE
  range.RuConvoy:SetRangeZone(zone.RangeRuConvoy)
  range.RuConvoy:AddBombingTargetGroup(GROUP:FindByName("Ru Convoy"), 50)
  
  --- Range Russian Convoy (Tankers)
  range.CypressNorth=RANGE:New("Range Cypress North")  --Functional.Range#RANGE
  range.CypressNorth:SetRangeZone(zone.RangeCypressNorth)
  range.CypressNorth:AddBombingTargetGroup(GROUP:FindByName("Range Cypress North-1"), 50)  
  range.CypressNorth:SetRangeControl(125.500, "Range Cypress North Control Relay")
  range.CypressNorth:SetInstructorRadio(125.500, "Range Cypress North Instructor Relay")
  
  -- Start ranges and set some default parameters.
  for _,_myrange in pairs(range) do
    local myrange=_myrange --Functional.Range#RANGE
    
    -- No smoke on bomb impact point by default.
    myrange:SetDefaultPlayerSmokeBomb(false)
    
    -- Automatically save score.
    myrange:SetAutosaveOn()
    
    -- Start range.
    myrange:Start()    
  end
    
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FOX Missile Trainer
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

if foxON then

  local fox=FOX:New()
  fox:AddLaunchZone(zone.RangeTabqa)
  fox:__Start(1)
  
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Misc Stuff
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

if miscON then

  local kc130i=FLIGHTGROUP:New("KC-130 Incirlik")
  kc130i:SetDefaultCallsign(CALLSIGN.Tanker.Shell, 1)
  kc130i:SetDefaultRadio(251)
  kc130i:SetDefaultTACAN(80)
  
  local tankercharlie=AUFTRAG:NewTANKER(ZONE:New("Zone Taker Charlie"):GetCoordinate(), 20000, 400, 090, 50)
  kc130i:AddMission(tankercharlie)

  -- JTAC to lase one ship.
  local JTACtripoli=ARMYGROUP:New("JTAC Alpha")
  JTACtripoli:__LaserOn(10, UNIT:FindByName("Red Cargo Ship Tripoli-3"))
  
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Strike Group Stennis
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

local carrierName="CVN-71"

local carrier=UNIT:FindByName(carrierName)

-- Some parameters for the liveries in case you want to change them easily.
local hornetlivery="VFA-106 high visibility"
local tomcatlivery="VF-102 Diamondbacks"

--- Function that spawns statics on the carrier deck.
local function SpawnDeck(statics, prefix)

  for i,static in pairs(statics) do
    local name=string.format("%s#%d03", prefix, i)  -- This MUST be a UNIQUE name!
    
    -- Spawn the static object.
    local static=SPAWNSTATIC:NewFromType(static.type, static.category):InitLinkToUnit(carrier, static.x, static.y, static.heading):InitLivery(static.livery):InitShape(static.shape):Spawn(nil, name)
    
  end
  
end

-- Set prefixes so we can delete certain statics easily.
local PrefixClearDeck="sc8clear"
local PrefixBlockedDeck="sc8blocked"
local PrefixMassLaunch="scmasslaunch"
local PrefixMassRecovery="scmassrecovery"

--- Function that spawn the clear deck statics.
local function SpawnClearDeck()

  local sc8clear={}
  sc8clear[ 1]={type="FA-18C_hornet", category="Planes", x=23.392320767991,  y=31.035356269975,  heading=math.deg(4.7123889803847), livery=hornetlivery}
  sc8clear[ 2]={type="FA-18C_hornet", category="Planes", x=33.698838333992,  y=31.61437411001,   heading=math.deg(4.7123889803847), livery=hornetlivery}
  sc8clear[ 3]={type="FA-18C_hornet", category="Planes", x=61.561528349994,  y=34.190822379955,  heading=math.deg(3.3335788713092), livery=hornetlivery}
  sc8clear[ 4]={type="E-2C",          category="Planes", x=8.8025239199924,  y=30.665721859958,  heading=math.deg(4.6949356878647), livery="E-2D Demo"}
  sc8clear[ 5]={type="SH-60B",   category="Helicopters", x=-120.511512843,   y=-25.023610410048, heading=math.deg(1.7976891295542), livery="standard"}
  sc8clear[ 6]={type="AS32-36A", category="ADEquipment", x=0.755692206003,   y=33.281995239959,  heading=math.deg(4.6600291028249)}
  sc8clear[ 7]={type="AS32-p25", category="ADEquipment", x=72.724640796994,  y=32.424999079958,  heading=math.deg(5.4279739737024)}
  sc8clear[ 8]={type="AS32-31A", category="ADEquipment", x=-79.610005513998, y=30.242116749985,  heading=math.deg(2.4958208303519)}
  sc8clear[ 9]={type="AS32-31A", category="ADEquipment", x=-0.2022494480043, y=18.819578160008,  heading=math.deg(4.1713369122664)}
  sc8clear[10]={type="AS32-31A", category="ADEquipment", x=-111.66933041,    y=29.150888629956,  heading=math.deg(5.1138147083434)}  
  sc8clear[11]={type="Carrier LSO Personell",   category="Personnel", x=-130.61201797701, y=-22.370473980031, heading=math.deg(2.4434609527921), shape="carrier_lso_usa"}
  sc8clear[12]={type="Carrier LSO Personell 1", category="Personnel", x=-129.42353100701, y=-21.789118479996, heading=math.deg(4.2935099599061), shape="carrier_lso1_usa"}
  sc8clear[13]={type="Carrier Seaman",          category="Personnel", x=-78.473079361007, y=31.255831669958,  heading=math.deg(4.7472955654246), shape="carrier_seaman_USA"}
  sc8clear[14]={type="Carrier Seaman",          category="Personnel", x=-87.794107105001, y=-35.76436746004,  heading=math.deg(1.6580627893946), shape="carrier_seaman_USA"}
  sc8clear[15]={type="us carrier tech",         category="Personnel", x=-129.497732263,   y=-22.656188270019, heading=math.deg(1.850049007114),  shape="carrier_tech_USA", livery="white"}
  sc8clear[16]={type="us carrier tech",         category="Personnel", x=58.869844022993,  y=31.799837369996,  heading=math.deg(1.850049007114),  shape="carrier_tech_USA", livery="white"}
  sc8clear[17]={type="us carrier tech",         category="Personnel", x=60.15744568099,   y=36.657607259986,  heading=math.deg(5.9341194567807), shape="carrier_tech_USA", livery="purple"}
  sc8clear[18]={type="us carrier tech",         category="Personnel", x=67.356309497001,  y=32.502165549959,  heading=math.deg(2.460914245312),  shape="carrier_tech_USA", livery="purple"}
  sc8clear[19]={type="us carrier tech",         category="Personnel", x=13.844755134996,  y=24.753144659975,  heading=math.deg(5.218534463463),  shape="carrier_tech_USA", livery="yellow"}
  sc8clear[20]={type="us carrier tech",         category="Personnel", x=-19.085825937,    y=19.767758169968,  heading=math.deg(1.5882496193148), shape="carrier_tech_USA", livery="yellow"}
  sc8clear[21]={type="us carrier tech",         category="Personnel", x=-89.908392819008, y=-33.335796030005, heading=math.deg(3.6651914291881), shape="carrier_tech_USA", livery="green"}
  sc8clear[22]={type="us carrier tech",         category="Personnel", x=-2.3569001290016, y=17.940128899994,  heading=math.deg(1.0471975511966), shape="carrier_tech_USA", livery="yellow"}  
  sc8clear[23]={type="us carrier tech",         category="Personnel", x=-111.053451471,   y=32.040782110009,  heading=math.deg(4.6425758103049), shape="carrier_tech_USA", livery="yellow"}
  
  SpawnDeck(sc8clear, PrefixClearDeck) 
end

--- Function that spawns the blocked deck statics.
local function SpawnBlockedDeck()

  local sc8blocked={}  
  sc8blocked[1]={type="S-3B Tanker",   category="Planes", x=-136.44656968401, y=26.462317789963, heading=math.deg(0.034906585039887), livery="usaf standard"}
  sc8blocked[2]={type="F-14B",         category="Planes", x=-123.20911407401, y=26.834156429977, heading=math.deg(0.034906585039887), livery=tomcatlivery}
  sc8blocked[3]={type="F-14B",         category="Planes", x=-104.617182038,   y=33.229781050002, heading=math.deg(4.6949356878647),   livery=tomcatlivery}
  sc8blocked[4]={type="F-14B",         category="Planes", x=-91.664486535999, y=32.607335179986, heading=math.deg(4.6949356878647),   livery=tomcatlivery}
  sc8blocked[5]={type="FA-18C_hornet", category="Planes", x=-71.796896190004, y=20.882562899962, heading=math.deg(5.3930673886625),   livery=hornetlivery}
  sc8blocked[6]={type="FA-18C_hornet", category="Planes", x=-58.370438072001, y=17.046432009956, heading=math.deg(5.7770398241012),   livery=hornetlivery}
  sc8blocked[7]={type="FA-18C_hornet", category="Planes", x=-45.576714306007, y=14.469786549977, heading=math.deg(5.3407075111026),   livery=hornetlivery}

  SpawnDeck(sc8blocked, PrefixBlockedDeck)
end  

--- Function that spawns the mass launch statics.
local function SpawnMassLaunch()

  local masslaunch={}
  
  -- Hornets.
  masslaunch[1]={type="FA-18C_hornet", category="Planes", x=-158.547306564, y=-5.8173064400326, heading=math.deg(1.2566370614359),  livery=hornetlivery}
  masslaunch[2]={type="FA-18C_hornet", category="Planes", x=-148.360713827, y=-8.4159270400414, heading=math.deg(1.2566370614359),  livery=hornetlivery}
  masslaunch[3]={type="FA-18C_hornet", category="Planes", x=-138.48595556,  y=-11.118492459995, heading=math.deg(1.2566370614359),  livery=hornetlivery}
  masslaunch[4]={type="FA-18C_hornet", category="Planes", x=-127.467804232, y=-13.301333760028, heading=math.deg(0.97738438111682), livery=hornetlivery}
  masslaunch[5]={type="FA-18C_hornet", category="Planes", x=-151.790893014, y=8.8389137199847,  heading=math.deg(6.1261056745001),  livery=hornetlivery}
  
  SpawnDeck(masslaunch, PrefixMassLaunch)
end

--- Function that spawns the mass recovery statics.
local function SpawnMassRecovery()

  local massrecovery={}
  
  -- Hornets on CAT 1.
  massrecovery[1]={type="FA-18C_hornet", category="Planes", x=157.17722058357, y=9.4148222083459, heading=math.deg(6.1784655520599), livery=hornetlivery}
  massrecovery[2]={type="FA-18C_hornet", category="Planes", x=139.74341288069, y=9.4148222091026, heading=math.deg(5.8643062867009), livery=hornetlivery}
  massrecovery[3]={type="FA-18C_hornet", category="Planes", x=124.83291945075, y=11.173495793249, heading=math.deg(5.7072266540215), livery=hornetlivery}
  massrecovery[4]={type="FA-18C_hornet", category="Planes", x=110.68706670946, y=12.243992757576, heading=math.deg(5.7246799465414), livery=hornetlivery}
  massrecovery[5]={type="FA-18C_hornet", category="Planes", x=93.329723075571, y=14.079130410682, heading=math.deg(5.6199601914217), livery=hornetlivery}
  massrecovery[6]={type="FA-18C_hornet", category="Planes", x=77.900436216994, y=17.661255949992, heading=math.deg(6.1784655520599), livery=hornetlivery}
  massrecovery[7]={type="FA-18C_hornet", category="Planes", x=63.508736215706, y=18.284654198971, heading=math.deg(5.6025068989018), livery=hornetlivery}
  
  -- Hornets on CAT 2.
  massrecovery[8] ={type="FA-18C_hornet", category="Planes", x=154.99358265282, y=-8.4167411836679, heading=math.deg(0.27925268031909), livery=hornetlivery}
  massrecovery[9] ={type="FA-18C_hornet", category="Planes", x=143.11477288499, y=-7.7287177100079, heading=math.deg(0.73303828583762), livery=hornetlivery}
  massrecovery[10]={type="FA-18C_hornet", category="Planes", x=130.918647436,   y=-7.7287177100079, heading=math.deg(0.50614548307836), livery=hornetlivery}
  massrecovery[11]={type="FA-18C_hornet", category="Planes", x=117.83406251699, y=-8.8594843100291, heading=math.deg(0.83775804095728), livery=hornetlivery}
  massrecovery[12]={type="FA-18C_hornet", category="Planes", x=106.88254922599, y=-8.95903232001,   heading=math.deg(0.82030474843733), livery=hornetlivery}
  massrecovery[13]={type="FA-18C_hornet", category="Planes", x=94.89565438799,  y=-7.3248725000303, heading=math.deg(0.59341194567807), livery=hornetlivery}
  massrecovery[14]={type="FA-18C_hornet", category="Planes", x=81.164917126996, y=-5.3056464300025, heading=math.deg(0.68067840827779), livery=hornetlivery}
  massrecovery[15]={type="FA-18C_hornet", category="Planes", x=64.930339543003, y=-3.2056513199932, heading=math.deg(0.36651914291881), livery=hornetlivery}
  
  SpawnDeck(massrecovery, PrefixMassRecovery)
end

  
--- Function to remove statics.
local function ClearDeck(Prefix)
  local function removestatic(static)
    static:Destroy()
  end
  local set=SET_STATIC:New():FilterPrefixes(Prefix):FilterOnce()
  set:ForEachStatic(removestatic)
end


local stennis={}

if StennisON then

  -- S-3B Recovery Tanker spawning in air.
  stennis.tanker=RECOVERYTANKER:New(carrierName, "S-3B Tanker Template Group")
  stennis.tanker:SetTakeoffAir()
  stennis.tanker:SetRadio(145.5)
  stennis.tanker:SetModex(511)
  stennis.tanker:SetCallsign(CALLSIGN.Tanker.Arco)
  stennis.tanker:SetTACAN(1, "TKR")
  stennis.tanker:__Start(1)
  
  -- E-2D AWACS spawning on Stennis.
  stennis.awacs=RECOVERYTANKER:New(carrierName, "E-2D Template Group")
  stennis.awacs:SetAWACS()
  stennis.awacs:SetRadio(260)
  stennis.awacs:SetAltitude(20000)
  stennis.awacs:SetCallsign(CALLSIGN.AWACS.Wizard)
  stennis.awacs:SetRacetrackDistances(30, 15)
  stennis.awacs:SetModex(611)
  stennis.awacs:SetTACAN(2, "WIZ")
  stennis.awacs:__Start(1)
  
  
  -- Rescue Helo with home base Lake Erie. Has to be a global object!
  stennis.rescuehelo=RESCUEHELO:New(carrierName, "SH-60B Template Group")  --Ops.RescueHelo#RESCUEHELO
  --stennis.rescuehelo:SetHomeBase(AIRBASE:FindByName("USS Ford"))
  stennis.rescuehelo:SetModex(42)
  stennis.rescuehelo:__Start(1)
    
  -- Create AIRBOSS object.
  stennis.airboss=AIRBOSS:New(carrierName)
  
  -- Add recovery windows:
  -- Case I from 9 to 10 am.
  local window1=stennis.airboss:AddRecoveryWindow( "5:21", "10:00",   1, nil, true, 25)
  -- Case II with +15 degrees holding offset from 15:00 for 60 min.
  local window2=stennis.airboss:AddRecoveryWindow("15:00", "16:00",   2,  15, true, 23)
  local window3=stennis.airboss:AddRecoveryWindow("17:10", "19:00",   1, nil, true, 25)
  -- Case III with +30 degrees holding offset from 2100 to 2200.
  local window4=stennis.airboss:AddRecoveryWindow("22:06", "00:00+1", 3,  30, true, 21)
  
  -- Set folder of airboss sound files within miz file.
  stennis.airboss:SetSoundfilesFolder("Airboss Soundfiles/")
  
  -- Single carrier menu optimization.
  stennis.airboss:SetMenuSingleCarrier()
  
  -- Skipper menu.
  stennis.airboss:SetMenuRecovery(30, 20, false)
  
  -- Remove landed AI planes from flight deck.
  stennis.airboss:SetDespawnOnEngineShutdown()
  
  -- Load all saved player grades from your "Saved Games\DCS" folder (if lfs was desanitized).
  stennis.airboss:Load()
  
  -- Automatically save player results to your "Saved Games\DCS" folder each time a player get a final grade from the LSO.
  stennis.airboss:SetAutoSave()
  
  -- Enable trap sheet.
  stennis.airboss:SetTrapSheet()

  --- Function called when the airboss is started.
  function stennis.airboss:OnAfterStart(From,Event,To)

    if CarrierStaticsON then
      
      -- Spawn clear deck statics. This can stay also when recovering.
      SpawnClearDeck()
      
      -- Spawn statics that block the taxi way to the parking area. This must be removed when aircraft begin to recover.
      SpawnBlockedDeck()
      
      -- Add some AC at the fantail.
      SpawnMassLaunch()
      
    end
    
  end
  
  --- Function called when a recovery window opens.
  function stennis.airboss:OnAfterRecoveryStart(From, Event, To, Case, Offset)

    if CarrierStaticsON then
    
      MESSAGE:New(string.format("Preparing deck for Case %d recovery!", Case), 30):ToAll()
    
      -- Remove blocked deck statics so incoming AC can taxi to the parking area.
      ClearDeck(PrefixBlockedDeck)
      
      -- Remove AC at the fantail.
      ClearDeck(PrefixMassLaunch)
      
      -- Spawn aircraft on CAT 1 and 2.
      SpawnMassRecovery()
      
    end
  
  end
  
  --- Function called when a recovery window closes.
  function stennis.airboss:OnAfterRecoveryStop(From, Event, To)

    if CarrierStaticsON then
  
      MESSAGE:New("Recovery stopped. Preparing deck for launches.", 30):ToAll()
      
      -- Remove clear mass recovery statics.
      ClearDeck(PrefixMassRecovery)
    
      -- Spawn statics that block the taxi way to the parking area. This must be removed when aircraft begin to recover.
      SpawnBlockedDeck()
      
      -- Add some AC at the fantail.
      SpawnMassLaunch()
      
    end
    
  end

  -- Start airboss class.
  stennis.airboss:Start()
  
  
  --- Function called when recovery tanker is started.
  function stennis.tanker:OnAfterStart(From,Event,To)
  
    -- Set recovery tanker.
    stennis.airboss:SetRecoveryTanker(self)  
  
    -- Use tanker as radio relay unit for LSO transmissions.
    stennis.airboss:SetRadioRelayLSO(self:GetUnitName())
    
  end
  
  --- Function called when AWACS is started.
  function stennis.awacs:OnAfterStart(From,Event,To)
    -- Set AWACS.
    stennis.airboss:SetAWACS(self)
  end
  
  
  --- Function called when rescue helo is started.
  function stennis.rescuehelo:OnAfterStart(From,Event,To)
    -- Use rescue helo as radio relay for Marshal.
    stennis.airboss:SetRadioRelayMarshal(self:GetUnitName())
  end
  
  --- Function called when a player gets graded by the LSO.
  function stennis.airboss:OnAfterLSOGrade(From, Event, To, playerData, grade)
    local PlayerData=playerData --Ops.Airboss#AIRBOSS.PlayerData
    local Grade=grade --Ops.Airboss#AIRBOSS.LSOgrade
  
    ----------------------------------------
    --- Interface your Discord bot here! ---
    ----------------------------------------
    
    local score=tonumber(Grade.points)
    local name=tostring(PlayerData.name)
    
    -- Report LSO grade to dcs.log file.
    env.info(string.format("Player %s scored %.1f", name, score))
  end

end


