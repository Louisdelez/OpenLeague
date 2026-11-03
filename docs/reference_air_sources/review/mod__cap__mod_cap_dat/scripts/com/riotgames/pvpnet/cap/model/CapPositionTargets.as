package com.riotgames.pvpnet.cap.model
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class CapPositionTargets
   {
      
      private var locationData:Dictionary;
      
      public function CapPositionTargets(param1:MovieClip, param2:Array)
      {
         var _loc3_:CapPosition = null;
         super();
         this.locationData = new Dictionary();
         for each(_loc3_ in param2)
         {
            this.locationData[_loc3_] = param1[_loc3_.tweenAssetInstanceName];
         }
      }
      
      public function getCoordinates(param1:CapPosition, param2:int, param3:int) : Point
      {
         var _loc4_:MovieClip = this.locationData[param1];
         var _loc5_:MovieClip = _loc4_[param1.instanceNamePrefix + "_" + param3 + "_" + param2];
         return new Point(_loc5_.x,_loc5_.y);
      }
   }
}

