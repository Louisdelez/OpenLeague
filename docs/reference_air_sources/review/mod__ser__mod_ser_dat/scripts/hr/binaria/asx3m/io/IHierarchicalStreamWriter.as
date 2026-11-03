package hr.binaria.asx3m.io
{
   public interface IHierarchicalStreamWriter
   {
      
      function underlyingWriter() : IHierarchicalStreamWriter;
      
      function flush() : void;
      
      function startNode(param1:String) : void;
      
      function close() : void;
      
      function addAttribute(param1:String, param2:String) : void;
      
      function endNode() : void;
      
      function setValue(param1:String) : void;
   }
}

