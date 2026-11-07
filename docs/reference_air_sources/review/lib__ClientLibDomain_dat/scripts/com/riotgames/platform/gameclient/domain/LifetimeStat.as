package com.riotgames.platform.gameclient.domain
{
   public class LifetimeStat
   {
      
      public var total:Number;
      
      public var max:Number;
      
      public var average:Number;
      
      public function LifetimeStat(param1:Number, param2:Number)
      {
         super();
         this.max = param1;
         this.average = param2;
         this.total = 0;
      }
      
      public function toString() : String
      {
         return this.average + "/" + this.max + "/" + this.total;
      }
   }
}

