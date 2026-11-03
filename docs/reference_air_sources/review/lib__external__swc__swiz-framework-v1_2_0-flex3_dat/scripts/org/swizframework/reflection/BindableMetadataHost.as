package org.swizframework.reflection
{
   public class BindableMetadataHost extends BaseMetadataHost
   {
      
      public function BindableMetadataHost()
      {
         super();
      }
      
      public function get isBindable() : Boolean
      {
         var tag:IMetadataTag = null;
         for each(tag in metadataTags)
         {
            if(tag.name == "Bindable")
            {
               return true;
            }
         }
         return false;
      }
   }
}

