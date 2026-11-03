package org.swizframework.reflection
{
   public interface IMetadataTag
   {
      
      function get name() : String;
      
      function set name(param1:String) : void;
      
      [ArrayElementType("org.swizframework.reflection.MetadataArg")]
      function get args() : Array;
      
      function set args(param1:Array) : void;
      
      function get host() : IMetadataHost;
      
      function set host(param1:IMetadataHost) : void;
      
      function get asTag() : String;
      
      function hasArg(param1:String) : Boolean;
      
      function getArg(param1:String) : MetadataArg;
      
      function copyFrom(param1:IMetadataTag) : void;
      
      function toString() : String;
   }
}

