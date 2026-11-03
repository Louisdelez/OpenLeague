package com.riotgames.platform.common.utils.file
{
   import flash.utils.Dictionary;
   
   public class CfgCategory
   {
      
      public var contents:Array = [];
      
      public var name:String;
      
      private var propertyCache:Dictionary;
      
      public function CfgCategory()
      {
         super();
      }
      
      public function readValue(param1:String) : String
      {
         var _loc2_:CfgEntry = this.propertyCache[param1];
         if(Boolean(_loc2_))
         {
            return _loc2_.value;
         }
         return null;
      }
      
      public function render() : String
      {
         return "[" + this.name + "]";
      }
      
      public function createCache() : void
      {
         var _loc1_:CfgEntry = null;
         this.propertyCache = new Dictionary();
         for each(_loc1_ in this.contents)
         {
            if(Boolean(_loc1_.key))
            {
               this.propertyCache[_loc1_.key] = _loc1_;
            }
         }
      }
      
      public function setValue(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:CfgEntry = this.propertyCache[param1];
         if(!_loc4_)
         {
            _loc4_ = new CfgEntry();
            _loc4_.key = param1;
            this.contents.push(_loc4_);
            this.propertyCache[param1] = _loc4_;
         }
         _loc4_.value = param2;
         if(param3 != null)
         {
            _loc4_.lineComment = param3;
         }
      }
   }
}

