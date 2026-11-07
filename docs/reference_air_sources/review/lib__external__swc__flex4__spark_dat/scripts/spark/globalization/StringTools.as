package spark.globalization
{
   import flash.globalization.Collator;
   import flash.globalization.StringTools;
   import flash.utils.getDefinitionByName;
   import spark.globalization.supportClasses.GlobalizationBase;
   
   public class StringTools extends GlobalizationBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _g11nWorkingInstance:flash.globalization.StringTools;
      
      public function StringTools()
      {
         super();
      }
      
      public static function getAvailableLocaleIDNames() : Vector.<String>
      {
         var locales:Vector.<String> = Collator.getAvailableLocaleIDNames();
         return Boolean(locales) ? locales : new Vector.<String>["en-US"]();
      }
      
      private function get g11nWorkingInstance() : flash.globalization.StringTools
      {
         if(!this._g11nWorkingInstance)
         {
            ensureStyleSource();
         }
         return this._g11nWorkingInstance;
      }
      
      private function set g11nWorkingInstance(flashStringTools:flash.globalization.StringTools) : void
      {
         this._g11nWorkingInstance = flashStringTools;
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
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createWorkingInstance() : void
      {
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            this.g11nWorkingInstance = null;
            return;
         }
         if(enforceFallback)
         {
            fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
            this.g11nWorkingInstance = null;
            return;
         }
         this.g11nWorkingInstance = new flash.globalization.StringTools(localeStyle);
         if(Boolean(this.g11nWorkingInstance) && this.g11nWorkingInstance.lastOperationStatus != LastOperationStatus.UNSUPPORTED_ERROR)
         {
            propagateBasicProperties(this.g11nWorkingInstance);
            return;
         }
         fallbackLastOperationStatus = LastOperationStatus.USING_FALLBACK_WARNING;
         this.g11nWorkingInstance = null;
      }
      
      [Bindable("change")]
      public function toLowerCase(s:String) : String
      {
         if(Boolean(this.g11nWorkingInstance))
         {
            return this.g11nWorkingInstance.toLowerCase(s);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return s.toLowerCase();
      }
      
      [Bindable("change")]
      public function toUpperCase(s:String) : String
      {
         if(Boolean(this.g11nWorkingInstance))
         {
            return this.g11nWorkingInstance.toUpperCase(s);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return s.toUpperCase();
      }
   }
}

