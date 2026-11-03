package spark.globalization.supportClasses
{
   import flash.globalization.Collator;
   import flash.globalization.CollatorMode;
   import flash.utils.getDefinitionByName;
   import mx.utils.ObjectUtil;
   import spark.globalization.LastOperationStatus;
   
   public class CollatorBase extends GlobalizationBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const IGNORE_CASE:String = "ignoreCase";
      
      private static const IGNORE_CHARACTER_WIDTH:String = "ignoreCharacterWidth";
      
      private static const IGNORE_DIACRITICS:String = "ignoreDiacritics";
      
      private static const IGNORE_KANA_TYPE:String = "ignoreKanaType";
      
      private static const IGNORE_SYMBOLS:String = "ignoreSymbols";
      
      private static const NUMERIC_COMPARISON:String = "numericComparison";
      
      private var _g11nWorkingInstance:Collator;
      
      private var initialMode:String = null;
      
      public function CollatorBase(initialMode:String)
      {
         super();
         this.initialMode = initialMode;
      }
      
      public static function getAvailableLocaleIDNames() : Vector.<String>
      {
         var locales:Vector.<String> = Collator.getAvailableLocaleIDNames();
         return Boolean(locales) ? locales : new Vector.<String>["en-US"]();
      }
      
      private function get g11nWorkingInstance() : Collator
      {
         if(!this._g11nWorkingInstance)
         {
            ensureStyleSource();
         }
         return this._g11nWorkingInstance;
      }
      
      private function set g11nWorkingInstance(flashCollator:Collator) : void
      {
         this._g11nWorkingInstance = flashCollator;
      }
      
      [Bindable("change")]
      override public function get actualLocaleIDName() : String
      {
         if(Boolean(this.g11nWorkingInstance))
         {
            return this.g11nWorkingInstance.actualLocaleIDName;
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return "en-US";
      }
      
      [Bindable("change")]
      override public function get lastOperationStatus() : String
      {
         return Boolean(this.g11nWorkingInstance) ? this.g11nWorkingInstance.lastOperationStatus : fallbackLastOperationStatus;
      }
      
      [Bindable("change")]
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get useFallback() : Boolean
      {
         return this.g11nWorkingInstance == null;
      }
      
      [Bindable("change")]
      public function get ignoreCase() : Boolean
      {
         return getBasicProperty(properties,IGNORE_CASE);
      }
      
      public function set ignoreCase(value:Boolean) : void
      {
         setBasicProperty(properties,IGNORE_CASE,value);
      }
      
      [Bindable("change")]
      public function get ignoreCharacterWidth() : Boolean
      {
         return getBasicProperty(properties,IGNORE_CHARACTER_WIDTH);
      }
      
      public function set ignoreCharacterWidth(value:Boolean) : void
      {
         setBasicProperty(properties,IGNORE_CHARACTER_WIDTH,value);
      }
      
      [Bindable("change")]
      public function get ignoreDiacritics() : Boolean
      {
         return getBasicProperty(properties,IGNORE_DIACRITICS);
      }
      
      public function set ignoreDiacritics(value:Boolean) : void
      {
         setBasicProperty(properties,IGNORE_DIACRITICS,value);
      }
      
      [Bindable("change")]
      public function get ignoreKanaType() : Boolean
      {
         return getBasicProperty(properties,IGNORE_KANA_TYPE);
      }
      
      public function set ignoreKanaType(value:Boolean) : void
      {
         setBasicProperty(properties,IGNORE_KANA_TYPE,value);
      }
      
      [Bindable("change")]
      public function get ignoreSymbols() : Boolean
      {
         return getBasicProperty(properties,IGNORE_SYMBOLS);
      }
      
      public function set ignoreSymbols(value:Boolean) : void
      {
         setBasicProperty(properties,IGNORE_SYMBOLS,value);
      }
      
      [Bindable("change")]
      public function get numericComparison() : Boolean
      {
         return getBasicProperty(properties,NUMERIC_COMPARISON);
      }
      
      public function set numericComparison(value:Boolean) : void
      {
         setBasicProperty(properties,NUMERIC_COMPARISON,value);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createWorkingInstance() : void
      {
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            this.g11nWorkingInstance = null;
            properties = null;
            return;
         }
         if(enforceFallback)
         {
            this.fallbackInstantiate();
            this.g11nWorkingInstance = null;
            return;
         }
         this.g11nWorkingInstance = new Collator(localeStyle,this.initialMode);
         if(Boolean(this.g11nWorkingInstance) && this.g11nWorkingInstance.lastOperationStatus != LastOperationStatus.UNSUPPORTED_ERROR)
         {
            properties = this.g11nWorkingInstance;
            propagateBasicProperties(this.g11nWorkingInstance);
            return;
         }
         this.fallbackInstantiate();
         this.g11nWorkingInstance = null;
         if(fallbackLastOperationStatus == LastOperationStatus.NO_ERROR)
         {
            fallbackLastOperationStatus = LastOperationStatus.USING_FALLBACK_WARNING;
         }
      }
      
      [Bindable("change")]
      public function compare(string1:String, string2:String) : int
      {
         if(Boolean(this.g11nWorkingInstance))
         {
            if(string1 === null && string2 === null)
            {
               return 0;
            }
            if(string1 === null)
            {
               return 1;
            }
            if(string2 === null)
            {
               return -1;
            }
            return this.g11nWorkingInstance.compare(string1,string2);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return ObjectUtil.stringCompare(string1,string2,properties.ignoreCase);
      }
      
      [Bindable("change")]
      public function equals(string1:String, string2:String) : Boolean
      {
         if(Boolean(this.g11nWorkingInstance))
         {
            if(string1 === null && string2 === null)
            {
               return true;
            }
            if(string1 === null || string2 === null)
            {
               return false;
            }
            return this.g11nWorkingInstance.equals(string1,string2);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return ObjectUtil.stringCompare(string1,string2,properties.ignoreCase) == 0;
      }
      
      private function fallbackInstantiate() : void
      {
         var validInitialMode:Boolean = this.initialMode == CollatorMode.MATCHING || this.initialMode == CollatorMode.SORTING;
         fallbackLastOperationStatus = validInitialMode ? LastOperationStatus.NO_ERROR : LastOperationStatus.INVALID_ATTR_VALUE;
         properties = {
            "ignoreCase":this.initialMode == CollatorMode.MATCHING,
            "ignoreCharacterWidth":false,
            "ignoreDiacritics":false,
            "ignoreKanaType":false,
            "ignoreSymbols":false,
            "numericComparison":false
         };
         propagateBasicProperties(properties);
      }
   }
}

