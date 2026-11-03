package mx.messaging.management
{
   [RemoteClass(alias="flex.management.jmx.MBeanOperationInfo")]
   public class MBeanOperationInfo extends MBeanFeatureInfo
   {
      
      public var impact:int;
      
      public var returnType:String;
      
      public const INFO:int = 0;
      
      public const UNKNOWN:int = 3;
      
      public const ACTION:int = 1;
      
      public const ACTION_INFO:int = 2;
      
      public var signature:Array;
      
      public function MBeanOperationInfo()
      {
         super();
      }
   }
}

