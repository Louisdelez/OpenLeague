package org.swizframework.processors
{
   import org.swizframework.core.Bean;
   import org.swizframework.metadata.PreDestroyMetadataTag;
   import org.swizframework.reflection.IMetadataTag;
   
   public class PreDestroyProcessor extends BaseMetadataProcessor
   {
      
      protected static const PRE_DESTROY:String = "PreDestroy";
      
      public function PreDestroyProcessor(metadataNames:Array = null)
      {
         super(metadataNames == null ? [PRE_DESTROY] : metadataNames,PreDestroyMetadataTag);
      }
      
      override public function get priority() : int
      {
         return ProcessorPriority.PRE_DESTROY;
      }
      
      override public function tearDownMetadataTags(metadataTags:Array, bean:Bean) : void
      {
         var metadataTag:IMetadataTag = null;
         var f:Function = null;
         super.tearDownMetadataTags(metadataTags,bean);
         metadataTags.sortOn("order",Array.NUMERIC);
         for each(metadataTag in metadataTags)
         {
            f = bean.source[metadataTag.host.name];
            f.apply();
         }
      }
   }
}

