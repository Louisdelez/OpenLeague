package com.riotgames.pvpnet.endofgamegiftwindow
{
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.GiftButton;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IGiftButton;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class GiftButtonFactory implements IGiftButtonFactory
   {
      
      private static var _instance:GiftButtonFactory;
      
      public function GiftButtonFactory(param1:SingletonEnforcer)
      {
         super();
      }
      
      public static function getInstance() : IGiftButtonFactory
      {
         if(_instance == null)
         {
            _instance = new GiftButtonFactory(new SingletonEnforcer());
         }
         return _instance;
      }
      
      public function getGiftButton(param1:DisplayObjectContainer, param2:int, param3:Boolean, param4:Number, param5:IPlayerSummary, param6:Number, param7:DisplayObject, param8:Function = null, param9:Function = null) : IGiftButton
      {
         var _loc10_:GiftButton = new GiftButton(param3,param4,param5,param6,param7,param8,param9);
         param1.addChildAt(_loc10_ as DisplayObject,param2);
         return _loc10_ as IGiftButton;
      }
   }
}

class SingletonEnforcer
{
   
   public function SingletonEnforcer()
   {
      super();
   }
}
