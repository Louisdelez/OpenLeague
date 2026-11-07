package com.riotgames.pvpnet.cap.model
{
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   
   public class CapRoles
   {
      
      public static const ANY:CapRole = createAnyRole();
      
      public static const ASSASSIN:CapRole = createAssassinRole();
      
      public static const FIGHTER:CapRole = createFighterRole();
      
      public static const MAGE:CapRole = createMageRole();
      
      public static const MARKSMAN:CapRole = createMarksmanRole();
      
      public static const SUPPORT:CapRole = createSupportRole();
      
      public static const TANK:CapRole = createTankRole();
      
      public function CapRoles()
      {
         super();
      }
      
      private static function createAnyRole() : CapRole
      {
         var _loc1_:CapRole = new CapRole();
         _loc1_.id = "ANY";
         _loc1_.name = CapLocaleUtil.getResourceString("gf_role_any","Any");
         _loc1_.description = CapLocaleUtil.getResourceString("gf_role_any_description","Any Description");
         _loc1_.championSearchTag = "any";
         return _loc1_;
      }
      
      public static function roleCompareFunction(param1:CapRole, param2:CapRole) : int
      {
         if(param1.id == CapRoles.ANY.id)
         {
            return -1;
         }
         var _loc3_:String = param1.name.toLowerCase();
         var _loc4_:String = param2.name.toLowerCase();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      private static function createSupportRole() : CapRole
      {
         var _loc1_:CapRole = new CapRole();
         _loc1_.id = "SUPPORT";
         _loc1_.name = CapLocaleUtil.getResourceString("gf_role_support","Support");
         _loc1_.description = CapLocaleUtil.getResourceString("gf_role_support_description","Support Description");
         _loc1_.championSearchTag = "support";
         return _loc1_;
      }
      
      private static function createMageRole() : CapRole
      {
         var _loc1_:CapRole = new CapRole();
         _loc1_.id = "MAGE";
         _loc1_.name = CapLocaleUtil.getResourceString("gf_role_mage","Mage");
         _loc1_.description = CapLocaleUtil.getResourceString("gf_role_mage_description","Mage Description");
         _loc1_.championSearchTag = "mage";
         return _loc1_;
      }
      
      private static function createMarksmanRole() : CapRole
      {
         var _loc1_:CapRole = new CapRole();
         _loc1_.id = "MARKSMAN";
         _loc1_.name = CapLocaleUtil.getResourceString("gf_role_marksman","Marksman");
         _loc1_.description = CapLocaleUtil.getResourceString("gf_role_marksman_description","Marksman Description");
         _loc1_.championSearchTag = "marksman";
         return _loc1_;
      }
      
      private static function createAssassinRole() : CapRole
      {
         var _loc1_:CapRole = new CapRole();
         _loc1_.id = "ASSASSIN";
         _loc1_.name = CapLocaleUtil.getResourceString("gf_role_assassin","Assassin");
         _loc1_.description = CapLocaleUtil.getResourceString("gf_role_assassin_description","Assassin Description");
         _loc1_.championSearchTag = "assassin";
         return _loc1_;
      }
      
      private static function createFighterRole() : CapRole
      {
         var _loc1_:CapRole = new CapRole();
         _loc1_.id = "FIGHTER";
         _loc1_.name = CapLocaleUtil.getResourceString("gf_role_fighter","Fighter");
         _loc1_.description = CapLocaleUtil.getResourceString("gf_role_fighter_description","Fighter Description");
         _loc1_.championSearchTag = "fighter";
         return _loc1_;
      }
      
      private static function createTankRole() : CapRole
      {
         var _loc1_:CapRole = new CapRole();
         _loc1_.id = "TANK";
         _loc1_.name = CapLocaleUtil.getResourceString("gf_role_tank","Tank");
         _loc1_.description = CapLocaleUtil.getResourceString("gf_role_tank_description","Tank Description");
         _loc1_.championSearchTag = "tank";
         return _loc1_;
      }
   }
}

