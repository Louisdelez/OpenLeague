package com.riotgames.rust.components.list
{
   import blix.assets.proxy.DisplayObjectProxy;
   import flash.geom.Point;
   
   public class VListLayoutHelper implements IListLayoutHelper
   {
      
      public function VListLayoutHelper()
      {
         super();
      }
      
      public function setPosition(param1:DisplayObjectProxy, param2:Number) : void
      {
         param1.setY(param2);
      }
      
      public function getSpan(param1:DisplayObjectProxy) : Number
      {
         var _loc2_:Point = param1.getExplicitSize();
         if(Boolean(_loc2_) && !isNaN(_loc2_.y))
         {
            return _loc2_.y;
         }
         return param1.getHeight();
      }
      
      public function getPosition(param1:DisplayObjectProxy) : Number
      {
         return param1.getY();
      }
   }
}

