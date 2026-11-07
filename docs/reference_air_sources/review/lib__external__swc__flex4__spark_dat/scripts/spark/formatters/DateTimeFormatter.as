package spark.formatters
{
   import flash.globalization.DateTimeFormatter;
   import flash.utils.getDefinitionByName;
   import mx.formatters.IFormatter;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import spark.globalization.LastOperationStatus;
   import spark.globalization.supportClasses.GlobalizationBase;
   
   [ResourceBundle("core")]
   public class DateTimeFormatter extends GlobalizationBase implements IFormatter
   {
      
      private static const DATE_STYLE:String = "dateStyle";
      
      private static const TIME_STYLE:String = "timeStyle";
      
      private static const DATE_TIME_PATTERN:String = "dateTimePattern";
      
      private static const UNDEFINED_DATE:Date = new Date(undefined);
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var timeStyleOverride:String = "long";
      
      private var dateStyleOverride:String = "long";
      
      private var dateTimePatternOverride:String = null;
      
      private var fallbackFormatter:FallbackDateTimeFormatter = null;
      
      private var _g11nWorkingInstance:flash.globalization.DateTimeFormatter = null;
      
      private var _errorText:String;
      
      private var _useUTC:Boolean = false;
      
      public function DateTimeFormatter()
      {
         super();
      }
      
      public static function getAvailableLocaleIDNames() : Vector.<String>
      {
         var locales:Vector.<String> = flash.globalization.DateTimeFormatter.getAvailableLocaleIDNames();
         return Boolean(locales) ? locales : new Vector.<String>["en-US"]();
      }
      
      private function get g11nWorkingInstance() : flash.globalization.DateTimeFormatter
      {
         if(!this._g11nWorkingInstance)
         {
            ensureStyleSource();
         }
         return this._g11nWorkingInstance;
      }
      
      private function set g11nWorkingInstance(flashFormatter:flash.globalization.DateTimeFormatter) : void
      {
         this._g11nWorkingInstance = flashFormatter;
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
      
      [Inspectable(category="General",enumeration="long,medium,short,none",defaultValue="long")]
      [Bindable("change")]
      public function get dateStyle() : String
      {
         if(Boolean(this.g11nWorkingInstance))
         {
            return this.g11nWorkingInstance.getDateStyle();
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         return this.fallbackFormatter.dateStyle;
      }
      
      public function set dateStyle(value:String) : void
      {
         var message:String = null;
         if(Boolean(this.dateStyleOverride) && this.dateStyleOverride == value)
         {
            return;
         }
         this.dateStyleOverride = value;
         if(Boolean(this.g11nWorkingInstance))
         {
            this.g11nWorkingInstance.setDateTimeStyles(value,this.timeStyleOverride);
            this.dateTimePatternOverride = null;
         }
         else
         {
            if(!FallbackDateTimeFormatter.validDateTimeStyle(value))
            {
               message = this.resourceManager.getString("core","badParameter",[this.dateStyle]);
               throw new ArgumentError(message);
            }
            if(Boolean(this.fallbackFormatter))
            {
               this.fallbackFormatter.dateStyle = value;
            }
            fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         }
         update();
      }
      
      [Bindable("change")]
      public function get dateTimePattern() : String
      {
         if(Boolean(this.g11nWorkingInstance))
         {
            return this.g11nWorkingInstance.getDateTimePattern();
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         return this.fallbackFormatter.dateTimePattern;
      }
      
      public function set dateTimePattern(value:String) : void
      {
         var message:String = null;
         if(Boolean(this.dateTimePatternOverride) && this.dateTimePatternOverride == value)
         {
            return;
         }
         this.dateTimePatternOverride = value;
         if(Boolean(this.g11nWorkingInstance))
         {
            this.g11nWorkingInstance.setDateTimePattern(value);
         }
         else
         {
            if(!value)
            {
               message = this.resourceManager.getString("core","nullParameter",[this.dateTimePattern]);
               throw new TypeError(message);
            }
            if(Boolean(this.fallbackFormatter))
            {
               this.fallbackFormatter.dateTimePattern = value;
            }
            fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         }
         update();
      }
      
      [Bindable("change")]
      public function get errorText() : String
      {
         return this._errorText;
      }
      
      public function set errorText(value:String) : void
      {
         if(this._errorText == value)
         {
            return;
         }
         this._errorText = value;
         update();
      }
      
      [Inspectable(category="General",enumeration="long,medium,short,none",defaultValue="long")]
      [Bindable("change")]
      public function get timeStyle() : String
      {
         if(Boolean(this.g11nWorkingInstance))
         {
            return this.g11nWorkingInstance.getTimeStyle();
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         return this.fallbackFormatter.timeStyle;
      }
      
      public function set timeStyle(value:String) : void
      {
         var message:String = null;
         if(Boolean(this.timeStyleOverride) && this.timeStyleOverride == value)
         {
            return;
         }
         this.timeStyleOverride = value;
         if(Boolean(this.g11nWorkingInstance))
         {
            this.g11nWorkingInstance.setDateTimeStyles(this.dateStyleOverride,value);
            this.dateTimePatternOverride = null;
         }
         else
         {
            if(!FallbackDateTimeFormatter.validDateTimeStyle(value))
            {
               message = this.resourceManager.getString("core","badParameter",[this.timeStyle]);
               throw new ArgumentError(message);
            }
            if(Boolean(this.fallbackFormatter))
            {
               this.fallbackFormatter.timeStyle = value;
            }
            fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         }
         update();
      }
      
      [Bindable("change")]
      public function get useUTC() : Boolean
      {
         return this._useUTC;
      }
      
      public function set useUTC(value:Boolean) : void
      {
         this._useUTC = value;
         update();
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
         this.g11nWorkingInstance = new flash.globalization.DateTimeFormatter(localeStyle,this.dateStyleOverride,this.timeStyleOverride);
         if(Boolean(this.g11nWorkingInstance) && this.g11nWorkingInstance.lastOperationStatus != LastOperationStatus.UNSUPPORTED_ERROR)
         {
            if(Boolean(this.dateTimePatternOverride))
            {
               this.g11nWorkingInstance.setDateTimePattern(this.dateTimePatternOverride);
            }
            properties = this.g11nWorkingInstance;
            propagateBasicProperties(this.g11nWorkingInstance);
            return;
         }
         this.fallbackInstantiate();
         this.g11nWorkingInstance = null;
         if(this.fallbackFormatter.fallbackLastOperationStatus == LastOperationStatus.NO_ERROR)
         {
            this.fallbackFormatter.fallbackLastOperationStatus = LastOperationStatus.USING_FALLBACK_WARNING;
         }
      }
      
      [Bindable("change")]
      public function format(value:Object) : String
      {
         var retVal:String = null;
         if(value == null)
         {
            return null;
         }
         var dateTime:Date = value is Date ? value as Date : new Date(value);
         if(dateTime == UNDEFINED_DATE)
         {
            if(Boolean(this.g11nWorkingInstance))
            {
               this.g11nWorkingInstance.setDateTimeStyles(null,null);
            }
            else
            {
               fallbackLastOperationStatus = LastOperationStatus.ILLEGAL_ARGUMENT_ERROR;
            }
            return this.errorText;
         }
         if(Boolean(this.g11nWorkingInstance))
         {
            retVal = this._useUTC ? this.g11nWorkingInstance.formatUTC(dateTime) : this.g11nWorkingInstance.format(dateTime);
            return Boolean(this.errorText) && LastOperationStatus.isError(this.g11nWorkingInstance.lastOperationStatus) ? this.errorText : retVal;
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return this.errorText;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return this._useUTC ? this.fallbackFormatter.formatUTC(dateTime) : this.fallbackFormatter.format(dateTime);
      }
      
      [Bindable("change")]
      public function getMonthNames(nameStyle:String = "full", context:String = "standalone") : Vector.<String>
      {
         if(Boolean(this.g11nWorkingInstance))
         {
            return this.g11nWorkingInstance.getMonthNames(nameStyle,context);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return this.fallbackFormatter.getMonthNames(nameStyle,context);
      }
      
      [Bindable("change")]
      public function getWeekdayNames(nameStyle:String = "full", context:String = "standalone") : Vector.<String>
      {
         if(Boolean(this.g11nWorkingInstance))
         {
            return this.g11nWorkingInstance.getWeekdayNames(nameStyle,context);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return this.fallbackFormatter.getWeekdayNames(nameStyle,context);
      }
      
      [Bindable("change")]
      public function getFirstWeekday() : int
      {
         if(Boolean(this.g11nWorkingInstance))
         {
            return this.g11nWorkingInstance.getFirstWeekday();
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return 0;
      }
      
      private function fallbackInstantiate() : void
      {
         this.fallbackFormatter = new FallbackDateTimeFormatter();
         if(Boolean(this.dateStyleOverride))
         {
            this.fallbackFormatter.dateStyle = this.dateStyleOverride;
         }
         if(Boolean(this.timeStyleOverride))
         {
            this.fallbackFormatter.timeStyle = this.timeStyleOverride;
         }
         if(Boolean(this.dateTimePatternOverride))
         {
            this.fallbackFormatter.dateTimePattern = this.dateTimePatternOverride;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
      }
   }
}

import flash.globalization.DateTimeNameStyle;
import flash.globalization.DateTimeStyle;
import spark.globalization.LastOperationStatus;

final class FallbackDateTimeFormatter
{
   
   private static const SHORT_DATE_PATTERN:String = "m/d/yyyy";
   
   private static const MEDIUM_DATE_PATTERN:String = "dddd, mmmm d, yyyy";
   
   private static const LONG_DATE_PATTERN:String = "dddd, mmmm d, yyyy";
   
   private static const NONE_DATE_PATTERN:String = "";
   
   private static const SHORT_TIME_PATTERN:String = "hh:mm a";
   
   private static const MEDIUM_TIME_PATTERN:String = "hh:mm:ss a";
   
   private static const LONG_TIME_PATTERN:String = "hh:mm:ss a";
   
   private static const NONE_TIME_PATTERN:String = "";
   
   private static const WEEKDAY_LABELS:Vector.<String> = new <String>["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
   
   private static const WEEKDAY_LABELS_LONG_ABB:Vector.<String> = new <String>["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
   
   private static const WEEKDAY_LABELS_SHORT_ABB:Vector.<String> = new <String>["S","M","T","W","T","F","S"];
   
   private static const MONTH_LABELS:Vector.<String> = new <String>["January","February","March","April","May","June","July","August","September","October","November","December"];
   
   private static const MONTH_LABELS_LONG_ABB:Vector.<String> = new <String>["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
   
   private static const MONTH_LABELS_SHORT_ABB:Vector.<String> = new <String>["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
   
   private var utc:Boolean;
   
   private var dateString:String;
   
   private var timeString:String;
   
   private var localTime:String;
   
   private var thisDate:Date;
   
   public var fallbackLastOperationStatus:String;
   
   private var _timeStyle:String;
   
   private var _dateStyle:String;
   
   private var _dateTimePatternString:String;
   
   public function FallbackDateTimeFormatter()
   {
      super();
   }
   
   public static function validDateTimeStyle(value:String) : Boolean
   {
      return Boolean(value) && (value == DateTimeStyle.LONG || value == DateTimeStyle.MEDIUM || value == DateTimeStyle.SHORT || value == DateTimeStyle.NONE);
   }
   
   public function set timeStyle(value:String) : void
   {
      if(Boolean(value))
      {
         this._timeStyle = value;
      }
   }
   
   public function get timeStyle() : String
   {
      return this._timeStyle;
   }
   
   public function set dateStyle(value:String) : void
   {
      if(Boolean(value))
      {
         this._dateStyle = value;
      }
   }
   
   public function get dateStyle() : String
   {
      return this._dateStyle;
   }
   
   public function get dateTimePattern() : String
   {
      switch(this.dateStyle)
      {
         case DateTimeStyle.SHORT:
            this.dateString = SHORT_DATE_PATTERN;
            break;
         case DateTimeStyle.MEDIUM:
            this.dateString = LONG_DATE_PATTERN;
            break;
         case DateTimeStyle.NONE:
            this.dateString = NONE_DATE_PATTERN;
            break;
         default:
            this.dateString = LONG_DATE_PATTERN;
      }
      switch(this.timeStyle)
      {
         case DateTimeStyle.SHORT:
            this.timeString = SHORT_TIME_PATTERN;
            break;
         case DateTimeStyle.MEDIUM:
            this.timeString = LONG_TIME_PATTERN;
            break;
         case DateTimeStyle.NONE:
            this.timeString = NONE_TIME_PATTERN;
            break;
         default:
            this.timeString = LONG_TIME_PATTERN;
      }
      return this.dateString + this.returnSpace() + this.timeString;
   }
   
   public function set dateTimePattern(value:String) : void
   {
      this._dateTimePatternString = value;
      this.fallbackLastOperationStatus = LastOperationStatus.UNSUPPORTED_ERROR;
   }
   
   public function format(dateTime:Date) : String
   {
      this.thisDate = dateTime;
      this.utc = false;
      return this.returnDate(dateTime) + this.returnSpace() + this.returnTime(dateTime);
   }
   
   public function formatUTC(dateTime:Date) : String
   {
      this.thisDate = dateTime;
      this.utc = true;
      return this.returnDate(dateTime) + this.returnSpace() + this.returnTime(dateTime);
   }
   
   public function getMonthNames(nameStyle:String = "full", context:String = "standalone") : Vector.<String>
   {
      switch(nameStyle)
      {
         case DateTimeNameStyle.SHORT_ABBREVIATION:
            return MONTH_LABELS_SHORT_ABB;
         case DateTimeNameStyle.LONG_ABBREVIATION:
            return MONTH_LABELS_LONG_ABB;
         default:
            return MONTH_LABELS;
      }
   }
   
   public function getWeekdayNames(nameStyle:String = "full", context:String = "standalone") : Vector.<String>
   {
      switch(nameStyle)
      {
         case DateTimeNameStyle.SHORT_ABBREVIATION:
            return WEEKDAY_LABELS_SHORT_ABB;
         case DateTimeNameStyle.LONG_ABBREVIATION:
            return WEEKDAY_LABELS_LONG_ABB;
         default:
            return WEEKDAY_LABELS;
      }
   }
   
   private function returnSpace() : String
   {
      var fullYearIsNaN:Boolean = Boolean(this.thisDate) && isNaN(this.thisDate.fullYear);
      var oneOfStyleIsNone:Boolean = this.dateStyle == DateTimeStyle.NONE || this.timeStyle == DateTimeStyle.NONE;
      return fullYearIsNaN || oneOfStyleIsNone ? "" : " ";
   }
   
   private function returnDate(dateTime:Date) : String
   {
      if(isNaN(dateTime.fullYear))
      {
         return "";
      }
      switch(this.dateStyle)
      {
         case DateTimeStyle.SHORT:
            return this.shortDate(dateTime);
         case DateTimeStyle.MEDIUM:
            return this.longDate(dateTime);
         case DateTimeStyle.NONE:
            return "";
         default:
            return this.longDate(dateTime);
      }
   }
   
   private function returnTime(dateTime:Date) : String
   {
      if(isNaN(dateTime.hours))
      {
         return "";
      }
      switch(this.timeStyle)
      {
         case DateTimeStyle.SHORT:
            return this.shortTime(dateTime);
         case DateTimeStyle.MEDIUM:
            return this.longTime(dateTime);
         case DateTimeStyle.NONE:
            return "";
         default:
            return this.longTime(dateTime);
      }
   }
   
   private function shortDate(dateTime:Date) : String
   {
      if(this.utc)
      {
         return dateTime.getUTCMonth() + 1 + "/" + dateTime.getUTCDate() + "/" + dateTime.getUTCFullYear();
      }
      return dateTime.getMonth() + 1 + "/" + dateTime.getDate() + "/" + dateTime.getFullYear();
   }
   
   private function longDate(dateTime:Date) : String
   {
      if(this.utc)
      {
         return WEEKDAY_LABELS[dateTime.getUTCDay()] + "," + " " + MONTH_LABELS[dateTime.getUTCMonth()] + " " + dateTime.getUTCDate() + "," + " " + dateTime.getUTCFullYear();
      }
      return WEEKDAY_LABELS[dateTime.getDay()] + "," + " " + MONTH_LABELS[dateTime.getMonth()] + " " + dateTime.getDate() + "," + " " + dateTime.getFullYear();
   }
   
   private function shortTime(dateTime:Date) : String
   {
      this.localTime = this.utc ? this.getUSClockTime(dateTime.getUTCHours(),dateTime.getUTCMinutes()) : this.getUSClockTime(dateTime.getHours(),dateTime.getMinutes());
      return this.localTime + " " + this.formatAMPM(dateTime);
   }
   
   private function longTime(dateTime:Date) : String
   {
      var seconds:Number = NaN;
      if(this.utc)
      {
         this.localTime = this.getUSClockTime(dateTime.getUTCHours(),dateTime.getUTCMinutes());
         seconds = dateTime.getUTCSeconds();
      }
      else
      {
         this.localTime = this.getUSClockTime(dateTime.getHours(),dateTime.getMinutes());
         seconds = dateTime.getSeconds();
      }
      return this.localTime + ":" + this.doubleDigitFormat(seconds) + " " + this.formatAMPM(dateTime);
   }
   
   private function getUSClockTime(hrs:uint, mins:uint) : String
   {
      var minLabel:String = this.doubleDigitFormat(mins);
      hrs %= 12;
      hrs = Boolean(hrs) ? hrs : 12;
      return hrs + ":" + minLabel;
   }
   
   private function doubleDigitFormat(num:uint) : String
   {
      return (num < 10 ? "0" : "") + String(num);
   }
   
   private function formatAMPM(dateTime:Date) : String
   {
      var hours:Number = this.utc ? dateTime.getUTCHours() : dateTime.getHours();
      return hours < 12 ? "AM" : "PM";
   }
}
