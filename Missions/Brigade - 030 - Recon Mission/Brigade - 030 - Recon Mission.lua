---
-- BRIGADE: Recon Mission
-- 
-- The brigade is stationed at Senaki. It consists of multiple platoons
-- of different unit types and capabilities.
-- 
-- The brigade gets an assignment to carry out a recon mission.
-- 
-- Recon missions require a set of zones which are patrolled by the assigned
-- assets. The set is sorted by name. This determines the order in which the
-- assets move from zone to zone.
-- 
-- Detected groups are reported as a message and printed to the DCS log file.
---

-- The zone to patrol.
local zoneRecce=SET_ZONE:New():FilterPrefixes("Recce Alpha"):FilterOnce()

-- TPz Fuchs platoon.
local platoonAPC=PLATOON:New("TPz Fuchs Template", 5, "TPz Fuchs")
platoonAPC:AddMissionCapability({AUFTRAG.Type.OPSTRANSPORT}, 60)
platoonAPC:AddMissionCapability({AUFTRAG.Type.PATROLZONE, AUFTRAG.Type.RECON}, 40)

-- Paladin platoon
local platoonARTY=PLATOON:New("M109 Paladin Template", 3, "M109 Paladin")
platoonARTY:AddMissionCapability({AUFTRAG.Type.ARTY}, 70)
platoonARTY:AddWeaponRange(UTILS.KiloMetersToNM(0.5), UTILS.KiloMetersToNM(20))

-- MLRS platoon.
local platoonMLRS=PLATOON:New("MLRS M270 Template", 3, "MLRS M270")
platoonMLRS:AddMissionCapability({AUFTRAG.Type.ARTY}, 80)
platoonMLRS:AddWeaponRange(UTILS.KiloMetersToNM(10), UTILS.KiloMetersToNM(32))

-- Leopard Tank platoon.
local platoonTANK=PLATOON:New("Leopard-2A6M Template", 1, "Leopard-2A6M")
platoonTANK:AddMissionCapability({AUFTRAG.Type.PATROLZONE}, 90)
platoonTANK:AddMissionCapability({AUFTRAG.Type.ARTY}, 20)
platoonTANK:AddWeaponRange(0.1, 1.8)


-- Create a Brigade
local brigade=BRIGADE:New("Warehouse Senaki", "My Brigade")

-- Set spawn zone.
brigade:SetSpawnZone(ZONE:New("Warehouse Senaki Spawn Zone"))

-- Add platoons.
brigade:AddPlatoon(platoonAPC)
brigade:AddPlatoon(platoonARTY)
brigade:AddPlatoon(platoonMLRS)
brigade:AddPlatoon(platoonTANK)

-- Start brigade.
brigade:Start()


-- RECON mission.
local missionRecce=AUFTRAG:NewRECON(zoneRecce)
missionRecce:SetRequiredAssets(3)

-- Add mission to brigade.
brigade:AddMission(missionRecce)

--- Function called each time a group from the brigade is send on a mission.
function brigade:OnAfterArmyOnMission(From, Event, To, Armygroup, Mission)
  local armygroup=Armygroup --Ops.ArmyGroup#ARMYGROUP
  local mission=Mission --Ops.Auftrag#AUFTRAG
  
  -- Info text.
  local text=string.format("Armygroup %s on Mission %s [%s]", armygroup:GetName(), mission:GetName(), mission:GetType())
  MESSAGE:New(text, 60):ToAll()
  env.info(text)
  
  -- Switch on detection.
  armygroup:SetDetection(true)
  
  --- Function called each time a NEW group is detected.
  function armygroup:OnAfterDetectedGroupNew(From, Event, To, Group)
    local group=Group --Wrapper.Group#GROUP
      -- Info text.
      local text=string.format("Armygroup %s detected group %s", armygroup:GetName(), group:GetName())
      MESSAGE:New(text, 60):ToAll()
      env.info(text)      
  end
end