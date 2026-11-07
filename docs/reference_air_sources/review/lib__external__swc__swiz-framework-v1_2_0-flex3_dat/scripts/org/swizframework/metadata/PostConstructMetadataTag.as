package org.swizframework.metadata
{
   import org.swizframework.reflection.BaseMetadataTag;
   import org.swizframework.reflection.IMetadataTag;
   
   public class PostConstructMetadataTag extends BaseMetadataTag
   {
      
      protected var _order:int = 1;
      
      public function PostConstructMetadataTag()
      {
         super();
         defaultArgName = "order";
      }
      
      public function get order() : int
      {
         return this._order;
      }
      
      override public function copyFrom(metadataTag:IMetadataTag) : void
      {
         super.copyFrom(metadataTag);
         if(hasArg("order"))
         {
            this._order = int(getArg("order").value);
         }
      }
   }
}

