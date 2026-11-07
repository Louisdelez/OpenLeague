package blix.decorator
{
   public interface IDecoratorManager
   {
      
      function addDecorator(param1:IDecorator) : void;
      
      function removeDecorator(param1:IDecorator) : void;
      
      function addTarget(param1:IDecoratable) : void;
      
      function removeTarget(param1:IDecoratable) : void;
   }
}

