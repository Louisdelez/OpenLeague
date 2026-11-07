package blix.assets.proxy
{
   public interface IDisplayContainer
   {
      
      function addChild(param1:IDisplayChild) : void;
      
      function removeChild(param1:IDisplayChild) : Boolean;
      
      function getChildren() : Vector.<IDisplayChild>;
   }
}

