package spark.utils
{
   import flash.utils.flash_proxy;
   import mx.binding.BindabilityInfo;
   import mx.utils.DescribeTypeCache;
   import mx.utils.ObjectProxy;
   
   use namespace flash_proxy;
   
   [RemoteClass(alias="spark.utils.DataItem")]
   public dynamic class DataItem extends ObjectProxy
   {
      
      public function DataItem()
      {
         super();
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         var info:BindabilityInfo = null;
         info = DescribeTypeCache.describeType(this).bindabilityInfo;
         var events:Object = info.getChangeEvents(name);
         if(events["propertyChange"] === undefined)
         {
            events["propertyChange"] = true;
         }
         super.flash_proxy::setProperty(name,value);
      }
   }
}

