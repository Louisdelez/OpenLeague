package blix.i18n
{
   import blix.model.TextModel;
   
   public class LocalizedText
   {
      
      protected var _key:String;
      
      protected var textMap:Object = {};
      
      protected var _currentLocaleChain:Vector.<String>;
      
      protected var currentLocaleText:TextModel = new TextModel();
      
      public function LocalizedText(param1:String)
      {
         super();
         this._key = param1;
      }
      
      public function getKey() : String
      {
         return this._key;
      }
      
      public function getTextModel(param1:String = null) : TextModel
      {
         if(param1 == null)
         {
            return this.currentLocaleText;
         }
         var _loc2_:TextModel = this.textMap[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new TextModel();
            this.textMap[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function setText(param1:String, param2:String) : void
      {
         var _loc3_:TextModel = this.getTextModel(param1);
         _loc3_.setText(param2);
         this.refreshCurrentLocaleText();
      }
      
      public function getCurrentLocaleChain() : Vector.<String>
      {
         return this._currentLocaleChain;
      }
      
      public function setCurrentLocaleChain(param1:Vector.<String>) : void
      {
         if(this._currentLocaleChain == param1)
         {
            return;
         }
         this._currentLocaleChain = param1;
         this.refreshCurrentLocaleText();
      }
      
      protected function refreshCurrentLocaleText() : void
      {
         var _loc1_:TextModel = this.getLocaleTextFromChain(this._currentLocaleChain);
         this.currentLocaleText.setText(_loc1_.getText());
      }
      
      protected function getLocaleTextFromChain(param1:Vector.<String>) : TextModel
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_ in this.textMap)
            {
               return this.textMap[_loc2_];
            }
         }
         return new TextModel();
      }
   }
}

