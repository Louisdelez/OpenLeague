package org.igniterealtime.xiff.util
{
   public class Callback
   {
      
      private var _scope:Object;
      
      private var _callback:Function;
      
      private var _args:Array;
      
      public function Callback(param1:Object, param2:Function, ... rest)
      {
         super();
         this._scope = param1;
         this._callback = param2;
         this._args = rest.slice();
      }
      
      public function call(... rest) : Object
      {
         var _loc3_:Object = null;
         var _loc2_:Array = this._args.slice();
         for each(_loc3_ in rest)
         {
            _loc2_.push(_loc3_);
         }
         return this._callback.apply(this._scope,_loc2_);
      }
   }
}

