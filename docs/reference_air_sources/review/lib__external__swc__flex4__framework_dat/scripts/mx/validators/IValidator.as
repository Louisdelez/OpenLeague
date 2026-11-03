package mx.validators
{
   import mx.events.ValidationResultEvent;
   
   public interface IValidator
   {
      
      function get enabled() : Boolean;
      
      function set enabled(param1:Boolean) : void;
      
      function validate(param1:Object = null, param2:Boolean = false) : ValidationResultEvent;
   }
}

