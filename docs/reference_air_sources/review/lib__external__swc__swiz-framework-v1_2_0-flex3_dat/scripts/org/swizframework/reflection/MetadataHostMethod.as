package org.swizframework.reflection
{
   public class MetadataHostMethod extends BaseMetadataHost
   {
      
      protected var _returnType:Class;
      
      protected var _parameters:Array = [];
      
      public function MetadataHostMethod()
      {
         super();
      }
      
      public function get returnType() : Class
      {
         return this._returnType;
      }
      
      public function set returnType(value:Class) : void
      {
         this._returnType = value;
      }
      
      [ArrayElementType("org.swizframework.reflection.MethodParameter")]
      public function get parameters() : Array
      {
         return this._parameters;
      }
   }
}

