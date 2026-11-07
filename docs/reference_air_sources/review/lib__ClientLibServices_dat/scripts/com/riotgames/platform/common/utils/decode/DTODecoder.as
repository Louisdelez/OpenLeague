package com.riotgames.platform.common.utils.decode
{
   import flash.utils.getDefinitionByName;
   
   public class DTODecoder implements IDecode
   {
      
      private var _decoder:IDecode;
      
      private var _targetClass:Class;
      
      public function DTODecoder(param1:IDecode, param2:Class = null)
      {
         super();
         this._decoder = param1;
         this._targetClass = param2;
      }
      
      private function generateDTO(param1:Object) : Object
      {
         var _loc2_:Class = getDefinitionByName(param1.className) as Class;
         if(this._targetClass != null && !(_loc2_ as this._targetClass))
         {
            throw new Error("Unable to deserialize response to target class: " + this._targetClass);
         }
         return _loc2_ == null ? null : new _loc2_(param1);
      }
      
      public function decode(param1:String) : Object
      {
         if(this._decoder == null)
         {
            return null;
         }
         var _loc2_:Object = this._decoder.decode(param1);
         return this.generateDTO(_loc2_);
      }
   }
}

