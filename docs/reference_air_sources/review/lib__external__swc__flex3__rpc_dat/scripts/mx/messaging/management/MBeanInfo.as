package mx.messaging.management
{
   import mx.utils.ObjectUtil;
   
   [RemoteClass(alias="flex.management.jmx.MBeanInfo")]
   public class MBeanInfo
   {
      
      public var className:String;
      
      public var attributes:Array;
      
      public var constructors:Array;
      
      public var operations:Array;
      
      public var description:String;
      
      public function MBeanInfo()
      {
         super();
      }
      
      public function toString() : String
      {
         return ObjectUtil.toString(this);
      }
   }
}

