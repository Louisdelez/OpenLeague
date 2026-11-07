package blix.decorator
{
   public interface IDecorator
   {
      
      function getDecoratedClass() : Class;
      
      function getIsInheritable() : Boolean;
      
      function apply(param1:IDecoratable) : void;
      
      function unapply(param1:IDecoratable) : void;
   }
}

