package com.riotgames.platform.common.utils
{
   import mx.resources.IResourceBundle;
   import mx.resources.ResourceBundle;
   
   public class UserResourceBundle extends ResourceBundle implements IResourceBundle
   {
      
      private static const lineBreakRegExp:RegExp = /\\n/g;
      
      private var _locale:String;
      
      private var _content:Object;
      
      private var _bundleName:String;
      
      public function UserResourceBundle(param1:String, param2:String)
      {
         super();
         this._bundleName = param1;
         this._locale = param2;
      }
      
      public function parse(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         this._content = {};
         var _loc2_:Array = param1.split("\n");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.indexOf("=");
            if(_loc4_ != -1)
            {
               _loc5_ = this.trim(_loc3_.substring(0,_loc4_));
               _loc6_ = this.trim(_loc3_.substr(_loc4_ + 1));
               _loc6_ = _loc6_.replace(lineBreakRegExp,"\n");
               if(_loc5_)
               {
                  this._content[_loc5_] = _loc6_;
               }
            }
         }
      }
      
      public function set bundleName(param1:String) : void
      {
         this._bundleName = param1;
      }
      
      public function set content(param1:Object) : void
      {
         this._content = param1;
      }
      
      override public function get bundleName() : String
      {
         return this._bundleName;
      }
      
      private function trim(param1:String) : String
      {
         if(!param1)
         {
            return param1;
         }
         return param1.replace(/^\s+|\s+$/g,"");
      }
      
      override public function get content() : Object
      {
         return this._content;
      }
      
      override public function get locale() : String
      {
         return this._locale;
      }
      
      public function set locale(param1:String) : void
      {
         this._locale = param1;
      }
   }
}

