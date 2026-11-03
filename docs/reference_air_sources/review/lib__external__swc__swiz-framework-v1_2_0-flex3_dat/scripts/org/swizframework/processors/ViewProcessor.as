package org.swizframework.processors
{
   import flash.utils.Dictionary;
   import org.swizframework.core.Bean;
   import org.swizframework.reflection.IMetadataTag;
   import org.swizframework.reflection.MetadataHostMethod;
   import org.swizframework.reflection.MethodParameter;
   
   public class ViewProcessor extends BaseMetadataProcessor implements IBeanProcessor
   {
      
      protected static const VIEW_ADDED:String = "ViewAdded";
      
      protected static const VIEW_REMOVED:String = "ViewRemoved";
      
      protected var views:Dictionary = new Dictionary();
      
      public function ViewProcessor(metadataNames:Array = null)
      {
         super(metadataNames == null ? [VIEW_ADDED,VIEW_REMOVED] : metadataNames);
      }
      
      override public function get priority() : int
      {
         return 100;
      }
      
      override public function setUpMetadataTags(metadataTags:Array, bean:Bean) : void
      {
         var tag:IMetadataTag = null;
         var viewType:Class = null;
         var arr:Array = null;
         for each(tag in metadataTags)
         {
            if(tag.host is MetadataHostMethod)
            {
               viewType = MethodParameter(MetadataHostMethod(tag.host).parameters[0]).type;
            }
            else
            {
               viewType = tag.host.type;
            }
            this.views[viewType] = this.views[viewType] || [];
            arr = this.views[viewType] as Array;
            arr.push(new ViewRef(tag,bean.source));
         }
      }
      
      override public function tearDownMetadataTags(metadataTags:Array, bean:Bean) : void
      {
         var tag:IMetadataTag = null;
         var viewType:Class = null;
         var arr:Array = null;
         var i:int = 0;
         var ref:ViewRef = null;
         for each(tag in metadataTags)
         {
            if(tag.host is MetadataHostMethod)
            {
               viewType = MethodParameter(MetadataHostMethod(tag.host).parameters[0]).type;
            }
            else
            {
               viewType = tag.host.type;
            }
            arr = this.views[viewType] as Array;
            for(i = arr.length - 1; i > -1; i--)
            {
               ref = arr[i];
               if(ref.mediator === bean.source)
               {
                  arr.splice(i,1);
               }
            }
         }
      }
      
      public function setUpBean(bean:Bean) : void
      {
         this.processViewBean(bean,VIEW_ADDED);
      }
      
      public function tearDownBean(bean:Bean) : void
      {
         this.processViewBean(bean,VIEW_REMOVED);
      }
      
      protected function processViewBean(bean:Bean, tagName:String) : void
      {
         var refs:Array = null;
         var ref:ViewRef = null;
         var f:Function = null;
         var viewType:Class = bean.typeDescriptor.type;
         if(Boolean(this.views[viewType]))
         {
            refs = this.views[viewType] as Array;
            for each(ref in refs)
            {
               if(ref.tag.name == tagName)
               {
                  if(ref.tag.host is MetadataHostMethod)
                  {
                     f = ref.mediator[ref.tag.host.name] as Function;
                     f.apply(null,[bean.source]);
                  }
                  else
                  {
                     ref.mediator[ref.tag.host.name] = bean.source;
                  }
               }
            }
         }
      }
   }
}

import org.swizframework.reflection.IMetadataTag;

class ViewRef
{
   
   public var tag:IMetadataTag;
   
   public var mediator:*;
   
   public function ViewRef(tag:IMetadataTag, mediator:*)
   {
      super();
      this.tag = tag;
      this.mediator = mediator;
   }
}
