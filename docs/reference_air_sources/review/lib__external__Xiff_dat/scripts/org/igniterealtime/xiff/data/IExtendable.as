package org.igniterealtime.xiff.data
{
   public interface IExtendable
   {
      
      function addExtension(param1:IExtension) : IExtension;
      
      function getAllExtensionsByNS(param1:String) : Array;
      
      function getAllExtensions() : Array;
      
      function removeExtension(param1:IExtension) : Boolean;
      
      function removeAllExtensions(param1:String) : void;
   }
}

