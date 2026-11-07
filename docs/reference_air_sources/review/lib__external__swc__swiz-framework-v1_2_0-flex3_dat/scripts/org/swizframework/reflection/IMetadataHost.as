package org.swizframework.reflection
{
   public interface IMetadataHost
   {
      
      function get name() : *;
      
      function set name(param1:*) : void;
      
      function get type() : Class;
      
      function set type(param1:Class) : void;
      
      [ArrayElementType("org.swizframework.reflection.IMetadataTag")]
      function get metadataTags() : Array;
      
      function set metadataTags(param1:Array) : void;
      
      function getMetadataTagByName(param1:String) : IMetadataTag;
      
      function hasMetadataTagByName(param1:String) : Boolean;
   }
}

