AddCSLuaFile()

CreateConVar("randomat_murder_knifedmg", 50, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the traitor's knife")

SWEP.HoldType               = "knife"

if CLIENT then
   SWEP.PrintName           = "knife_name"
   SWEP.Slot                = 0

   SWEP.ViewModelFlip       = false
   SWEP.ViewModelFOV        = 54
   SWEP.DrawCrosshair       = false

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "knife_desc"
   };

   SWEP.Icon                = "vgui/ttt/icon_knife"
   SWEP.IconLetter          = "j"
end

SWEP.Base                   = "weapon_tttbase"

SWEP.UseHands               = true
SWEP.ViewModel              = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel             = "models/weapons/w_knife_t.mdl"

SWEP.Primary.Damage         = GetConVar("randomat_murder_knifedmg"):GetInt()
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay          = 1.1
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 1.4

SWEP.Kind                   = WEAPON_MELEE
SWEP.LimitedStock           = true -- only buyable once
SWEP.WeaponID               = AMMO_KNIFE

SWEP.IsSilent               = true

-- Pull out faster than standard guns
SWEP.DeploySpeed            = 2
SWEP.AllowDrop              = false

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

   if not IsValid(self:GetOwner()) then return end

   self:GetOwner():LagCompensation(true)

   local spos = self:GetOwner():GetShootPos()
   local sdest = spos + (self:GetOwner():GetAimVector() * 70)

   local kmins = Vector(1,1,1) * -10
   local kmaxs = Vector(1,1,1) * 10

   local tr = util.TraceHull({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

   -- Hull might hit environment stuff that line does not hit
   if not IsValid(tr.Entity) then
      tr = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
   end

   local hitEnt = tr.Entity

   -- effects
   if IsValid(hitEnt) then
      self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

      local edata = EffectData()
      edata:SetStart(spos)
      edata:SetOrigin(tr.HitPos)
      edata:SetNormal(tr.Normal)
      edata:SetEntity(hitEnt)

      if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
         util.Effect("BloodImpact", edata)
      end
   else
      self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
   end

   if SERVER then
      self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
   end


   if SERVER and tr.Hit and tr.HitNonWorld and IsValid(hitEnt) then
      if hitEnt:IsPlayer() then
          local dmg = DamageInfo()
          dmg:SetDamage(self.Primary.Damage)
          dmg:SetAttacker(self:GetOwner())
          dmg:SetInflictor(self.Weapon or self)
          dmg:SetDamageForce(self:GetOwner():GetAimVector() * 5)
          dmg:SetDamagePosition(self:GetOwner():GetPos())
          dmg:SetDamageType(DMG_SLASH)

          hitEnt:DispatchTraceAttack(dmg, spos + (self:GetOwner():GetAimVector() * 3), sdest)
      end
   end

   self:GetOwner():LagCompensation(false)
end

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:SecondaryAttack()
  return false
end

function SWEP:Equip()
   self.Weapon:SetNextPrimaryFire( CurTime() + (self.Primary.Delay * 1.5) )
   self.Weapon:SetNextSecondaryFire( CurTime() + (self.Secondary.Delay * 1.5) )
end

function SWEP:PreDrop()
   -- for consistency, dropped knife should not have DNA/prints
   self.fingerprints = {}
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() and self:GetOwner():Alive() then
      RunConsoleCommand("lastinv")
   end
end

if CLIENT then
   local T = LANG.GetTranslation
   function SWEP:DrawHUD()
      local tr = self:GetOwner():GetEyeTrace(MASK_SHOT)

      if tr.HitNonWorld and IsValid(tr.Entity) and tr.Entity:IsPlayer()
         and tr.Entity:Health() < (self.Primary.Damage + 10) then

         local x = ScrW() / 2.0
         local y = ScrH() / 2.0

         surface.SetDrawColor(255, 0, 0, 255)

         local outer = 20
         local inner = 10
         surface.DrawLine(x - outer, y - outer, x - inner, y - inner)
         surface.DrawLine(x + outer, y + outer, x + inner, y + inner)

         surface.DrawLine(x - outer, y + outer, x - inner, y + inner)
         surface.DrawLine(x + outer, y - outer, x + inner, y - inner)

         draw.SimpleText(T("knife_instant"), "TabLarge", x, y - 30, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
      end

      return self.BaseClass.DrawHUD(self)
   end
end


