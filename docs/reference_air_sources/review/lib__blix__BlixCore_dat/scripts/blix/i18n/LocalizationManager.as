package blix.i18n
{
   import blix.model.TextModel;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class LocalizationManager implements ILocalizationManager
   {
      
      protected var _currentLocaleChainChanged:Signal = new Signal();
      
      private var _currentLocaleChain:Vector.<String>;
      
      protected var localizedTexts:Object = {};
      
      public function LocalizationManager(param1:Vector.<String> = null)
      {
         super();
         this.setCurrentLocaleChain(param1);
      }
      
      public function getCurrentLocaleChainChanged() : ISignal
      {
         return this._currentLocaleChainChanged;
      }
      
      public function getText(param1:String, param2:String = null) : TextModel
      {
         return this.getLocalizedText(param1).getTextModel(param2);
      }
      
      public function setText(param1:String, param2:String, param3:String) : void
      {
         this.getLocalizedText(param1).setText(param2,param3);
      }
      
      protected function getLocalizedText(param1:String) : LocalizedText
      {
         var _loc2_:LocalizedText = this.localizedTexts[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new LocalizedText(param1);
            _loc2_.setCurrentLocaleChain(this._currentLocaleChain);
            this.localizedTexts[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function getCurrentLocaleChain() : Vector.<String>
      {
         return this._currentLocaleChain;
      }
      
      public function setCurrentLocaleChain(param1:Vector.<String>) : void
      {
         var _loc3_:LocalizedText = null;
         var _loc2_:Vector.<String> = this._currentLocaleChain;
         this._currentLocaleChain = param1;
         if(this._currentLocaleChain != null)
         {
            for each(_loc3_ in this.localizedTexts)
            {
               _loc3_.setCurrentLocaleChain(this._currentLocaleChain);
            }
         }
         this._currentLocaleChainChanged.dispatch(this,_loc2_,this._currentLocaleChain);
      }
   }
}

