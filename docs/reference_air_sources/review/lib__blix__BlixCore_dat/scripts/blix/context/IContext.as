package blix.context
{
   public interface IContext
   {
      
      function getClassName() : String;
      
      function getSuperClassName() : String;
      
      function getContextAncestry() : Vector.<IContext>;
      
      function getAncestryLength() : uint;
      
      function getRootContext() : IContext;
      
      function getParentContext() : IContext;
      
      function getFirstContext(param1:Class) : *;
      
      function getLastContext(param1:Class) : *;
      
      function getDependency(param1:Class, param2:Boolean = false) : *;
      
      function getChainToString() : String;
   }
}

