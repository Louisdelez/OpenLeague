package org.swizframework.reflection
{
   public class BaseMetadataHost implements IMetadataHost
   {
      
      protected var _name:*;
      
      protected var _type:Class;
      
      protected var _metadataTags:Array;
      
      public function BaseMetadataHost()
      {
         super();
         this.metadataTags = [];
      }
      
      public function get name() : *
      {
         return this._name;
      }
      
      public function set name(value:*) : void
      {
         this._name = value;
      }
      
      public function get type() : Class
      {
         return this._type;
      }
      
      public function set type(value:Class) : void
      {
         this._type = value;
      }
      
      [ArrayElementType("org.swizframework.reflection.IMetadataTag")]
      public function get metadataTags() : Array
      {
         return this._metadataTags;
      }
      
      public function set metadataTags(value:Array) : void
      {
         this._metadataTags = value;
      }
      
      public function getMetadataTagByName(name:String) : IMetadataTag
      {
         var metadataTag:IMetadataTag = null;
         for each(metadataTag in this.metadataTags)
         {
            if(metadataTag.name == name)
            {
               return metadataTag;
            }
         }
         return null;
      }
      
      public function hasMetadataTagByName(name:String) : Boolean
      {
         return this.getMetadataTagByName(name) != null;
      }
   }
}

