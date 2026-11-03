package mx.core
{
   import flash.text.TextField;
   
   [ExcludeClass]
   public interface ITextFieldFactory
   {
      
      function createTextField(param1:IFlexModuleFactory) : TextField;
   }
}

