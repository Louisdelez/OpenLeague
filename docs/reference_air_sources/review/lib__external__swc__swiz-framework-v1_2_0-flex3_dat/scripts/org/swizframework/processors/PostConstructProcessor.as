package org.swizframework.processors
{
   import org.swizframework.core.Bean;
   import org.swizframework.metadata.PostConstructMetadataTag;
   import org.swizframework.reflection.IMetadataTag;
   
   public class PostConstructProcessor extends BaseMetadataProcessor
   {
      
      protected static const POST_CONSTRUCT:String = "PostConstruct";
      
      public function PostConstructProcessor(metadataNames:Array = null)
      {
         super(metadataNames == null ? [POST_CONSTRUCT] : metadataNames,PostConstructMetadataTag);
      }
      
      override public function get priority() : int
      {
         return ProcessorPriority.POST_CONSTRUCT;
      }
      
      override public function setUpMetadataTags(metadataTags:Array, bean:Bean) : void
      {
         var metadataTag:IMetadataTag = null;
         var f:Function = null;
         super.setUpMetadataTags(metadataTags,bean);
         metadataTags.sortOn("order",Array.NUMERIC);
         for each(metadataTag in metadataTags)
         {
            f = bean.source[metadataTag.host.name];
            f.apply();
         }
      }
   }
}

