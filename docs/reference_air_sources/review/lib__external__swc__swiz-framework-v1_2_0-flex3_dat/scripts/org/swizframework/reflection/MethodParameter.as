package org.swizframework.reflection
{
   public class MethodParameter
   {
      
      public var index:int;
      
      public var type:Class;
      
      public var optional:Boolean;
      
      public function MethodParameter(index:int, type:Class, optional:Boolean)
      {
         super();
         this.index = index;
         this.type = type;
         this.optional = optional;
      }
   }
}

