package com.riotgames.util.math
{
   import flash.geom.Point;
   
   public class MathUtil
   {
      
      public function MathUtil()
      {
         super();
      }
      
      public static function randomNumberInRange(param1:Number, param2:Number) : Number
      {
         return Math.floor(Math.random() * (param2 - param1) + 1) + param1;
      }
      
      public static function getFastDistance(param1:Point, param2:Point) : Number
      {
         var _loc3_:Number = param2.x - param1.x;
         var _loc4_:Number = param2.y - param1.y;
         return _loc3_ * _loc3_ + _loc4_ * _loc4_;
      }
      
      public static function getDistance(param1:Point, param2:Point) : Number
      {
         return Math.sqrt(getFastDistance(param1,param2));
      }
      
      public static function isWithinDistance(param1:Point, param2:Point, param3:Number) : Boolean
      {
         return getFastDistance(param1,param2) <= param3 * param3;
      }
   }
}

