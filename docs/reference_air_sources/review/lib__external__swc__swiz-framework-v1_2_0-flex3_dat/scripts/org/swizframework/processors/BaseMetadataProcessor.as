package org.swizframework.processors
{
   import flash.events.EventDispatcher;
   import org.swizframework.core.Bean;
   import org.swizframework.core.IBeanFactory;
   import org.swizframework.core.ISwiz;
   import org.swizframework.reflection.IMetadataTag;
   
   public class BaseMetadataProcessor extends EventDispatcher implements IMetadataProcessor
   {
      
      protected var swiz:ISwiz;
      
      protected var beanFactory:IBeanFactory;
      
      protected var _metadataNames:Array;
      
      protected var _metadataClass:Class;
      
      public function BaseMetadataProcessor(metadataNames:Array, metadataClass:Class = null)
      {
         super();
         this._metadataNames = metadataNames;
         this._metadataClass = metadataClass;
      }
      
      public function get metadataNames() : Array
      {
         return this._metadataNames;
      }
      
      public function get metadataClass() : Class
      {
         return this._metadataClass;
      }
      
      public function get priority() : int
      {
         return ProcessorPriority.DEFAULT;
      }
      
      public function init(swiz:ISwiz) : void
      {
         this.swiz = swiz;
         this.beanFactory = swiz.beanFactory;
      }
      
      public function setUpMetadataTags(metadataTags:Array, bean:Bean) : void
      {
         var metadataTag:IMetadataTag = null;
         var i:int = 0;
         if(this.metadataClass != null)
         {
            for(i = 0; i < metadataTags.length; i++)
            {
               metadataTag = metadataTags[i] as IMetadataTag;
               metadataTags.splice(i,1,this.createMetadataTag(metadataTag));
            }
         }
         for each(metadataTag in metadataTags)
         {
            this.setUpMetadataTag(metadataTag,bean);
         }
      }
      
      public function setUpMetadataTag(metadataTag:IMetadataTag, bean:Bean) : void
      {
      }
      
      public function tearDownMetadataTags(metadataTags:Array, bean:Bean) : void
      {
         var metadataTag:IMetadataTag = null;
         var i:int = 0;
         if(this.metadataClass != null)
         {
            for(i = 0; i < metadataTags.length; i++)
            {
               metadataTag = metadataTags[i] as IMetadataTag;
               metadataTags.splice(i,1,this.createMetadataTag(metadataTag));
            }
         }
         for each(metadataTag in metadataTags)
         {
            this.tearDownMetadataTag(metadataTag,bean);
         }
      }
      
      public function tearDownMetadataTag(metadataTag:IMetadataTag, bean:Bean) : void
      {
      }
      
      protected function createMetadataTag(metadataTag:IMetadataTag) : IMetadataTag
      {
         var tag:IMetadataTag = new this.metadataClass();
         tag.copyFrom(metadataTag);
         return tag;
      }
   }
}

