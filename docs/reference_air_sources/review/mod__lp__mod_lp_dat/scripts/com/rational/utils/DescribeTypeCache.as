package com.rational.utils
{
   import flash.Boot;
   import flash.utils.describeType;
   
   public class DescribeTypeCache
   {
      
      public var recordCache:Hash;
      
      public var factory:Function;
      
      public function DescribeTypeCache(param1:Function = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         factory = param1;
         recordCache = new Hash();
      }
      
      public function describeType(param1:Class) : Object
      {
         var _loc2_:String = Type.getClassName(param1);
         var _loc3_:Object = recordCache.get(_loc2_);
         if(_loc3_ != null)
         {
            return _loc3_;
         }
         var _loc4_:XML = flash.utils.describeType(param1);
         _loc3_ = factory(param1,_loc4_);
         recordCache.set(_loc2_,_loc3_);
         return _loc3_;
      }
   }
}

