package mx.messaging.management
{
   import mx.utils.ObjectUtil;
   
   [RemoteClass(alias="flex.management.jmx.Attribute")]
   public class Attribute
   {
      
      public var value:Object;
      
      public var name:String;
      
      public function Attribute()
      {
         super();
      }
      
      public function toString() : String
      {
         return ObjectUtil.toString(this);
      }
   }
}

