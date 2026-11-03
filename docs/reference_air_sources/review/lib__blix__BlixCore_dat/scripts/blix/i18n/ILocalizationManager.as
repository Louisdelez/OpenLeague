package blix.i18n
{
   import blix.model.TextModel;
   import blix.signals.ISignal;
   
   public interface ILocalizationManager
   {
      
      function getText(param1:String, param2:String = null) : TextModel;
      
      function setText(param1:String, param2:String, param3:String) : void;
      
      function getCurrentLocaleChainChanged() : ISignal;
      
      function getCurrentLocaleChain() : Vector.<String>;
      
      function setCurrentLocaleChain(param1:Vector.<String>) : void;
   }
}

