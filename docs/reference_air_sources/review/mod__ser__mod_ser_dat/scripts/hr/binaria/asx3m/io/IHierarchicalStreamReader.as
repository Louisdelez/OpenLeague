package hr.binaria.asx3m.io
{
   import system.data.Iterator;
   
   public interface IHierarchicalStreamReader
   {
      
      function underlyingReader() : IHierarchicalStreamReader;
      
      function getAttributeNames() : Iterator;
      
      function getNodeName() : String;
      
      function getAttribute(param1:String) : String;
      
      function getAttributeCount() : int;
      
      function getCurrent() : *;
      
      function moveUp() : void;
      
      function hasMoreChildren() : Boolean;
      
      function getAttributeName(param1:int) : String;
      
      function moveDown() : void;
      
      function close() : void;
      
      function getValue() : String;
   }
}

