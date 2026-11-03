package blix.view
{
   public interface IValidatable
   {
      
      function getValidationWeight() : Number;
      
      function validate() : void;
   }
}

