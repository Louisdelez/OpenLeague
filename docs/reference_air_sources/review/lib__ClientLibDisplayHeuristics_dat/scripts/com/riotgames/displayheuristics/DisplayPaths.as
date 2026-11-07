package com.riotgames.displayheuristics
{
   import avmplus.getQualifiedClassName;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   
   public class DisplayPaths
   {
      
      public function DisplayPaths()
      {
         super();
         throw new Error("DisplayPaths is a static utility class.");
      }
      
      public static function getRelativeDisplayPath(param1:DisplayObjectContainer, param2:DisplayObject, param3:Boolean = false) : String
      {
         var _loc4_:DisplayObject = param2;
         var _loc5_:Vector.<String> = new Vector.<String>();
         while(_loc4_ != null && _loc4_ != param1 && !(_loc4_ is Stage))
         {
            if(param3)
            {
               _loc5_.unshift("<font color=\'#000000\'>" + _loc4_.name + "</font>:<font color=\'#7AC5CD\'>" + getQualifiedClassName(_loc4_) + "</font>");
            }
            else
            {
               _loc5_.unshift(_loc4_.name);
            }
            _loc4_ = _loc4_.parent;
         }
         return _loc5_.join(".");
      }
      
      public static function getRelativeTarget(param1:DisplayObjectContainer, param2:String) : DisplayObject
      {
         var _loc7_:String = null;
         var _loc3_:Array = param2.split(".");
         var _loc4_:uint = _loc3_.length;
         var _loc5_:DisplayObject = param1;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = _loc3_.shift();
            if(_loc5_ == null)
            {
               return null;
            }
            _loc5_ = (_loc5_ as DisplayObjectContainer).getChildByName(_loc7_);
            _loc6_++;
         }
         return _loc5_;
      }
      
      public static function getPaths(param1:DisplayObjectContainer) : Vector.<PathInfo>
      {
         var _loc2_:Vector.<PathInfo> = new Vector.<PathInfo>();
         internalGetPaths(param1,param1,_loc2_);
         return _loc2_;
      }
      
      private static function internalGetPaths(param1:DisplayObjectContainer, param2:DisplayObject, param3:Vector.<PathInfo>) : void
      {
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:uint = 0;
         var _loc7_:DisplayObject = null;
         var _loc4_:String = getRelativeDisplayPath(param1,param2);
         param3[param3.length] = new PathInfo(_loc4_);
         if(param2 is DisplayObjectContainer)
         {
            _loc5_ = param2 as DisplayObjectContainer;
            _loc6_ = uint(_loc5_.numChildren);
            while(Boolean(_loc6_--))
            {
               _loc7_ = _loc5_.getChildAt(_loc6_);
               internalGetPaths(param1,_loc7_,param3);
            }
         }
      }
      
      public static function retrieveDisplayObjectsFromPaths(param1:DisplayObjectContainer, param2:Vector.<PathInfoResult>) : Vector.<DisplayObject>
      {
         var _loc4_:PathInfoResult = null;
         var _loc3_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         for each(_loc4_ in param2)
         {
            _loc3_[_loc3_.length] = getRelativeTarget(param1,_loc4_.path);
         }
         return _loc3_;
      }
   }
}

