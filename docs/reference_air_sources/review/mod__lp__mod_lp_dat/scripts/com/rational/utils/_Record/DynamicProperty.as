package com.rational.utils._Record
{
   import com.rational.utils.IProperty;
   import flash.Boot;
   
   public class DynamicProperty implements IProperty
   {
      
      public var name:String;
      
      public function DynamicProperty(param1:String = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         name = param1;
      }
      
      public function getType() : Class
      {
         return Object;
      }
      
      public function getName() : String
      {
         return name;
      }
      
      public function getElementType() : Class
      {
         return Object;
      }
      
      public function getAccess() : String
      {
         return "readwrite";
      }
   }
}

