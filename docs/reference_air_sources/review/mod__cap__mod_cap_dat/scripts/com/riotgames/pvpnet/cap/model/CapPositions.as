package com.riotgames.pvpnet.cap.model
{
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   
   public class CapPositions
   {
      
      public static const JUNGLE:CapPosition = createJunglePosition();
      
      public static const MIDDLE:CapPosition = createMiddlePosition();
      
      public static const BOTTOM:CapPosition = createBottomPosition();
      
      public static const TOP:CapPosition = createTopPosition();
      
      public function CapPositions()
      {
         super();
      }
      
      private static function createTopPosition() : CapPosition
      {
         var _loc1_:CapPosition = new CapPosition();
         _loc1_.id = "TOP";
         _loc1_.name = CapLocaleUtil.getResourceString("gf_position_top","Top");
         _loc1_.tweenAssetInstanceName = "tweens_top";
         _loc1_.instanceNamePrefix = "top";
         return _loc1_;
      }
      
      private static function createJunglePosition() : CapPosition
      {
         var _loc1_:CapPosition = new CapPosition();
         _loc1_.id = "JUNGLE";
         _loc1_.name = CapLocaleUtil.getResourceString("gf_position_jungle","Jungle");
         _loc1_.tweenAssetInstanceName = "tweens_jungle";
         _loc1_.instanceNamePrefix = "jungle";
         return _loc1_;
      }
      
      private static function createBottomPosition() : CapPosition
      {
         var _loc1_:CapPosition = new CapPosition();
         _loc1_.id = "BOTTOM";
         _loc1_.name = CapLocaleUtil.getResourceString("gf_position_bottom","Bottom");
         _loc1_.tweenAssetInstanceName = "tweens_bot";
         _loc1_.instanceNamePrefix = "bot";
         return _loc1_;
      }
      
      private static function createMiddlePosition() : CapPosition
      {
         var _loc1_:CapPosition = new CapPosition();
         _loc1_.id = "MIDDLE";
         _loc1_.name = CapLocaleUtil.getResourceString("gf_position_middle","Middle");
         _loc1_.tweenAssetInstanceName = "tweens_mid";
         _loc1_.instanceNamePrefix = "mid";
         return _loc1_;
      }
   }
}

