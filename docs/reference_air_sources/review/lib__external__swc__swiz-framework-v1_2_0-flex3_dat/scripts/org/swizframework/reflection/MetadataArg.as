package org.swizframework.reflection
{
   public class MetadataArg
   {
      
      public var key:String;
      
      public var value:String;
      
      public function MetadataArg(key:String, value:String)
      {
         super();
         this.key = key;
         this.value = value;
      }
      
      public function toString() : String
      {
         var str:String = "MetadataArg: ";
         return str + (this.key + " = " + this.value + "\n");
      }
   }
}

