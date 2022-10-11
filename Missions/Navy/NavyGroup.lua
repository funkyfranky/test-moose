---
-- NAVYGROUP Test Cases
---

-- Select test case:
local testcase=8

-- Tracing and Profiler. Enable for debugging. This will impact the performance!
local tracelevel=2
local verbosity=3

if tracelevel>0 then
  -- Tracing
  BASE:TraceOn()
  BASE:TraceLevel(tracelevel)
  
  -- Classes to trace.
  BASE:TraceClass("ARMYGROUP")
  BASE:TraceClass("NAVYGROUP")
  BASE:TraceClass("AUFTRAG")

  -- Verbosity
  OPSGROUP.verbose=verbosity
  AUFTRAG.verbose=verbosity
else
  BASE:TraceOff()
end

-- Profile
PROFILER.Start()

-- Info message.
local text=string.format("Start Test Mission Case #%s", tostring(testcase))
MESSAGE:New(text, 60):ToAll()
env.info(text)

-- Common zones.
local Zone={}

-- Test cases:
if testcase==1 then

  ---
  -- Passing Waypoints
  -- 
  -- Naval group "USS Normandy Group" has four waypoints set in the Mission editor:
  -- 1.) Initial positon at speed 0 knots
  -- 2.) Heading North at 25 knots.
  -- 3.) Heading North-West at 15 knots.
  -- 4.) Heading South at 30 knots (full speed).
  -- 
  -- After passing waypoint 4, the group will proceed eastwards to waypoint 1 and redo the route until all eternaty.
  -- Note that usually a waypoint speed of zero is dangerous.
  -- 
  -- When a group passes a waypoint, it will trigger an event "PassingWaypoint" which can be captured by the OnAfterPassingWaypoint() function.
  -- 
  ---

  local navygroup=NAVYGROUP:New("USS Normandy Group")  
  navygroup:Activate()

  --- Function called each time the group passes a waypoint.
  function navygroup:OnAfterPassingWaypoint(From, Event, To, Waypoint)
    local waypoint=Waypoint --Ops.OpsGroup#OPSGROUP.Waypoint
    
    -- Debug info.
    local text=string.format("Group passed waypoint ID=%d (Index=%d) for the %d. time", waypoint.uid, navygroup:GetWaypointIndex(waypoint.uid), waypoint.npassed)
    MESSAGE:New(text, 60):ToAll()
    env.info(text)
    
  end
  
  function navygroup:OnAfterCruise(From, Event, To)
    local text="Group is cruising"
    MESSAGE:New(text, 60):ToAll()
    env.info(text)
  end
  
  function navygroup:OnAfterTurningStarted(From, Event, To)
    local text="Group started turning"
    MESSAGE:New(text, 60):ToAll()
    env.info(text)
  end  

  function navygroup:OnAfterTurningStopped(From, Event, To)
    local text="Group stopped turning"
    MESSAGE:New(text, 60):ToAll()
    env.info(text)
  end
  
  -- Monitor entering and leaving zones. There are four zones named "Zone Leg 1", "Zone Leg 2", ...
  local ZoneSet=SET_ZONE:New():FilterPrefixes("Zone Leg"):FilterOnce()
  
  navygroup:SetCheckZones(ZoneSet)
  
  function navygroup:OnAfterEnterZone(From, Event, To, Zone)
    local text=string.format("Group entered zone %s", Zone:GetName())
    MESSAGE:New(text, 60):ToAll()
    env.info(text)    
  end

  function navygroup:OnAfterLeaveZone(From, Event, To, Zone)
    local text=string.format("Group left zone %s", Zone:GetName())
    MESSAGE:New(text, 60):ToAll()
    env.info(text)    
  end

  
elseif testcase==2 then

  ---
  -- Steam Into Wind
  -- 
  -- This example shows how you let a group steam into the wind for a certain amount of time.
  -- 
  -- Naval group "USS Stennis Group" has two waypoint set in the Mission Editor.
  -- 
  -- * At 0815 hours, the group will start to steam into the wind until 0830. Mission starts at 0800.
  -- * Each time after reaching waypoint 2, the group will again steam into the wind.
  -- * Each time after reaching waypoint 1, the group will steam into the wind.
  -- 
  ---

  local navygroup=NAVYGROUP:New("USS Stennis Group")
  navygroup:Activate()
  
  -- Mark waypoints on F10 map.
  navygroup:MarkWaypoints(60)
  
  navygroup:SwitchTACAN(74, "XYZ")
  navygroup:SwitchICLS(1, "ABC")
  navygroup:SwitchRadio(130)
  navygroup:SwitchAlarmstate(ENUMS.AlarmState.Red)
  navygroup:SwitchROE(ENUMS.ROE.WeaponFree)
  
  -- Group will turn into the wind at 8:15 hours until 8:30. Wind on deck is 15 knots. Afterwards, the group will return to the position where the turn started and go to the next waypoint.
  navygroup:AddTurnIntoWind("8:15", "8:30", 15, true, -9)
  
  --- Function called each time the group passes a waypoint.
  function navygroup:OnAfterPassingWaypoint(From, Event, To, Waypoint)
    local waypoint=Waypoint --Ops.OpsGroup#OPSGROUP.Waypoint
    
    -- Debug info.
    local text=string.format("Group passed waypoint ID=%d, Index=%d for the %d time", waypoint.uid, navygroup:GetWaypointIndex(waypoint.uid), waypoint.npassed)
    env.info(text)
  
    if Waypoint.uid==1 then
      -- Turn into wind 15 min after waypoint ID=1 is passed for 20 min. U-turn=false, i.e. after turn into wind is over, it will directly go to the next waypoint.
      navygroup:AddTurnIntoWind(15*60, 20*60, 15, false, -9)
    elseif Waypoint.uid==2 then
      -- Turn into wind 15 minafter waypoint ID=2 is passed for 15 min. U-turn=true, i.e. group will resume its route at the position the turn started.
      navygroup:AddTurnIntoWind(15*60, 15*60, 20, true, -9)
    end
  
  end
  
  --- Function called each time the group starts turning into the wind.
  function navygroup:OnAfterTurnIntoWind(From, Event, To, TurnIntoWind)
    local tiw=TurnIntoWind --Ops.NavyGroup#NAVYGROUP.IntoWind
    local text=string.format("Group is turning into the wind for %d seconds. Speed=%d knots. U-turn=%s", tiw.Tstop-tiw.Tstart, tiw.Speed, tostring(tiw.Uturn))
    env.info(text)
  end

elseif testcase==3 then

  ---
  -- Waypoints: Passing, Adding and Removing
  -- 
  -- USS Normandy has four waypoints set in the Mission Editor.
  -- After passing a waypoint, it is removed.
  -- 
  ---

  local navygroup=NAVYGROUP:New("USS Normandy Group")
  navygroup:Activate()

  --- Function called each time the group passes a waypoint.
  function navygroup:OnAfterPassingWaypoint(From, Event, To, Waypoint)
    local waypoint=Waypoint --Ops.OpsGroup#OPSGROUP.Waypoint
    
    -- Remove the waypoint that has just been passed.
    navygroup:RemoveWaypointByID(waypoint.uid)
    
    -- After passing waypoint 3, go to Zone Alpha at 20 knots.
    if navygroup:GetWaypointUID(waypoint)==3 then      
      navygroup:AddWaypoint(ZONE:New("Zone Detour Alpha"):GetCoordinate(), 20, waypoint.uid)
    end
    
  end

elseif testcase==4 then

  ---
  -- Submarine Dive & Surface.
  ---

  local Uboot=NAVYGROUP:New("Sub 093 Group")
  Uboot:Activate(1)

  --- Function called each time the group passes a waypoint.
  function Uboot:OnAfterPassingWaypoint(From, Event, To, Waypoint)
    
    if Waypoint.uid==2 then
      Uboot:Dive(10)
    elseif Waypoint.uid==3 then
      Uboot:Surface()
    elseif Waypoint.uid==1 then
      Uboot:Cruise(20)
    end
  
  end

elseif testcase==5 then

  ---
  -- Task Fire At Point
  ---

  local navygroup=NAVYGROUP:New("USS Lake Erie Group")
  navygroup:Activate(5)
  
  local TargetGroup=GROUP:FindByName("Red Target X")
  local TargetCoord=TargetGroup:GetCoordinate()
   
  -- Add tasks to fire at target using cannons and cruise missiles.
  local task1=navygroup:AddTaskFireAtPoint(TargetCoord, "8:05", 100, 10, ENUMS.WeaponFlag.Cannons)
  local task2=navygroup:AddTaskFireAtPoint(TargetCoord, "8:10", 100,  2, ENUMS.WeaponFlag.CruiseMissile)

  -- Set ROE to "Open Fire" or the task will not work.  
  navygroup:SwitchROE(ENUMS.ROE.OpenFire)

elseif testcase==6 then

  ---
  -- Collision Warning & taking actions
  ---

  local navygroup=NAVYGROUP:New("USS Lake Erie Group")
  navygroup:Activate(5)

  local Coordinate=AIRBASE:FindByName("Kobuleti")
  local Coordinate=ZONE:New("Zone Kobuleti Sea")

  navygroup:AddWaypoint(Coordinate, 99)
  
  function navygroup:OnAfterCollisionWarning(From, Event, To, Distance)
    navygroup:GotoWaypoint(1)
  end

elseif testcase==7 then

  ---
  -- Collision Warning & taking actions
  ---

  local navygroup=NAVYGROUP:New("USS Lake Erie Group")
  navygroup:AddWeaponRange(10, 500, ENUMS.WeaponFlag.CruiseMissile)
  navygroup:AddWeaponRange(10, 50, ENUMS.WeaponFlag.Cannons)
  
  local target1=GROUP:FindByName("Red Target X")
  local target2=GROUP:FindByName("Red Target Poti")
  
  local auftrag1=AUFTRAG:NewARTY(target1, 5, 100)
  auftrag1:SetWeaponType(ENUMS.WeaponFlag.CruiseMissile)
  
  local auftrag2=AUFTRAG:NewARTY(target2, 10, 1000)
  auftrag2:SetWeaponType(ENUMS.WeaponFlag.CruiseMissile)
  
  navygroup:AddMission(auftrag1)
  navygroup:AddMission(auftrag2)

elseif testcase==8 then

  ---
  -- 
  ---

  local navygroup=NAVYGROUP:New("USS Lake Erie Group")

  local Coordinate1=navygroup:GetCoordinate():Translate(5000, 000)

  local auftrag1=AUFTRAG:NewONGUARD(Coordinate1)
  auftrag1:SetDuration(5*60)
  
  navygroup:AddMission(auftrag1)
  
else


end

