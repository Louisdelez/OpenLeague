package mx.validators
{
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   [ResourceBundle("SharedResources")]
   public class DateValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var validateAsStringOverride:Object;
      
      private var _invalidCharError:String;
      
      private var wrongDayErrorOverride:String;
      
      private var invalidCharErrorOverride:String;
      
      [Inspectable(category="General")]
      public var dayProperty:String;
      
      private var _formatError:String;
      
      private var _wrongDayError:String;
      
      private var _inputFormat:String;
      
      [Inspectable(category="General")]
      public var yearProperty:String;
      
      private var wrongYearErrorOverride:String;
      
      private var formatErrorOverride:String;
      
      private var _dayListener:IValidatorListener;
      
      private var _wrongLengthError:String;
      
      private var _wrongMonthError:String;
      
      private var wrongLengthErrorOverride:String;
      
      private var allowedFormatCharsOverride:String;
      
      private var inputFormatOverride:String;
      
      private var _monthListener:IValidatorListener;
      
      private var _daySource:Object;
      
      private var _wrongYearError:String;
      
      private var _yearSource:Object;
      
      [Inspectable(category="General")]
      public var monthProperty:String;
      
      private var _yearListener:IValidatorListener;
      
      private var _validateAsString:Object;
      
      private var wrongMonthErrorOverride:String;
      
      private var _monthSource:Object;
      
      private var _allowedFormatChars:String;
      
      public function DateValidator()
      {
         super();
         subFields = ["day","month","year"];
      }
      
      public static function validateDate(validator:DateValidator, value:Object, baseField:String) : Array
      {
         var objValue:Object = null;
         var stringValue:Object = null;
         var n:int = 0;
         var i:int = 0;
         var temp:String = null;
         var message:String = null;
         var date:Date = null;
         var baseFieldDot:String = null;
         var dayMissing:Boolean = false;
         var dayInvalid:Boolean = false;
         var dayWrong:Boolean = false;
         var dayOptional:Boolean = false;
         var result:ValidationResult = null;
         var len:Number = NaN;
         var j:int = 0;
         var mask:String = null;
         var results:Array = [];
         var allowedFormatChars:String = validator.allowedFormatChars;
         var inputFormat:String = validator.inputFormat;
         var validateAsString:Boolean = Boolean(validator.validateAsString);
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         var validInput:String = DECIMAL_DIGITS + allowedFormatChars;
         var dateObj:Object = {};
         dateObj.month = "";
         dateObj.day = "";
         dateObj.year = "";
         var dayProp:String = baseField;
         var yearProp:String = baseField;
         var monthProp:String = baseField;
         var advanceValueCounter:Boolean = true;
         var monthRequired:Boolean = false;
         var dayRequired:Boolean = false;
         var yearRequired:Boolean = false;
         var valueIsString:Boolean = false;
         var foundMonth:Boolean = false;
         var foundYear:Boolean = false;
         n = allowedFormatChars.length;
         for(i = 0; i < n; i++)
         {
            if(DECIMAL_DIGITS.indexOf(allowedFormatChars.charAt(i)) != -1)
            {
               message = resourceManager.getString("validators","invalidFormatChars");
               throw new Error(message);
            }
         }
         if(value is String)
         {
            valueIsString = true;
            stringValue = String(value);
         }
         else if(value is Number)
         {
            valueIsString = true;
            stringValue = String(value);
         }
         else if(value is Date)
         {
            date = value as Date;
            objValue = {
               "year":date.fullYear,
               "month":date.month + 1,
               "day":date.date
            };
         }
         else
         {
            objValue = value;
         }
         if(!validateAsString || !valueIsString)
         {
            baseFieldDot = Boolean(baseField) ? baseField + "." : "";
            dayProp = baseFieldDot + "day";
            yearProp = baseFieldDot + "year";
            monthProp = baseFieldDot + "month";
            if(validator.required && (!objValue.month || objValue.month == ""))
            {
               results.push(new ValidationResult(true,monthProp,"requiredField",validator.requiredFieldError));
            }
            else if(isNaN(objValue.month))
            {
               results.push(new ValidationResult(true,monthProp,"wrongMonth",validator.wrongMonthError));
            }
            else
            {
               monthRequired = true;
            }
            if(validator.required && (!objValue.year || objValue.year == ""))
            {
               results.push(new ValidationResult(true,yearProp,"requiredField",validator.requiredFieldError));
            }
            else if(isNaN(objValue.year))
            {
               results.push(new ValidationResult(true,yearProp,"wrongYear",validator.wrongYearError));
            }
            else
            {
               yearRequired = true;
            }
            dayMissing = !objValue.day || objValue.day == "";
            dayInvalid = dayMissing || isNaN(objValue.day);
            dayWrong = !dayMissing && isNaN(objValue.day);
            dayOptional = yearRequired && monthRequired;
            if(validator.required && dayMissing)
            {
               results.push(new ValidationResult(true,dayProp,"requiredField",validator.requiredFieldError));
            }
            else if(!dayInvalid)
            {
               dayRequired = true;
            }
            else if(!dayOptional || dayWrong)
            {
               results.push(new ValidationResult(true,dayProp,"wrongDay",validator.wrongDayError));
            }
            dateObj.month = Boolean(objValue.month) ? String(objValue.month) : "";
            dateObj.day = Boolean(objValue.day) ? String(objValue.day) : "";
            dateObj.year = Boolean(objValue.year) ? String(objValue.year) : "";
         }
         else
         {
            result = DateValidator.validateFormatString(validator,inputFormat,baseField);
            if(result != null)
            {
               results.push(result);
               return results;
            }
            len = Number(stringValue.length);
            if(len > inputFormat.length || len + 2 < inputFormat.length)
            {
               results.push(new ValidationResult(true,baseField,"wrongLength",validator.wrongLengthError + " " + inputFormat));
               return results;
            }
            j = 0;
            n = inputFormat.length;
            for(i = 0; i < n; i++)
            {
               temp = "" + stringValue.substring(j,j + 1);
               mask = "" + inputFormat.substring(i,i + 1);
               if(validInput.indexOf(temp) == -1)
               {
                  results.push(new ValidationResult(true,baseField,"invalidChar",validator.invalidCharError));
                  return results;
               }
               if(mask == "m" || mask == "M")
               {
                  monthRequired = true;
                  if(isNaN(Number(temp)))
                  {
                     advanceValueCounter = false;
                  }
                  else
                  {
                     dateObj.month += temp;
                  }
               }
               else if(mask == "d" || mask == "D")
               {
                  dayRequired = true;
                  if(isNaN(Number(temp)))
                  {
                     advanceValueCounter = false;
                  }
                  else
                  {
                     dateObj.day += temp;
                  }
               }
               else if(mask == "y" || mask == "Y")
               {
                  yearRequired = true;
                  if(isNaN(Number(temp)))
                  {
                     results.push(new ValidationResult(true,baseField,"wrongLength",validator.wrongLengthError + " " + inputFormat));
                     return results;
                  }
                  dateObj.year += temp;
               }
               else if(allowedFormatChars.indexOf(temp) == -1)
               {
                  results.push(new ValidationResult(true,baseField,"invalidChar",validator.invalidCharError));
                  return results;
               }
               if(advanceValueCounter)
               {
                  j++;
               }
               advanceValueCounter = true;
            }
            if(monthRequired && dateObj.month == "" || dayRequired && dateObj.day == "" || yearRequired && dateObj.year == "" || j != len)
            {
               results.push(new ValidationResult(true,baseField,"wrongLength",validator.wrongLengthError + " " + inputFormat));
               return results;
            }
         }
         n = int(dateObj.month.length);
         for(i = 0; i < n; i++)
         {
            temp = "" + dateObj.month.substring(i,i + 1);
            if(DECIMAL_DIGITS.indexOf(temp) == -1)
            {
               results.push(new ValidationResult(true,monthProp,"invalidChar",validator.invalidCharError));
            }
         }
         n = int(dateObj.day.length);
         for(i = 0; i < n; i++)
         {
            temp = "" + dateObj.day.substring(i,i + 1);
            if(DECIMAL_DIGITS.indexOf(temp) == -1)
            {
               results.push(new ValidationResult(true,dayProp,"invalidChar",validator.invalidCharError));
            }
         }
         n = int(dateObj.year.length);
         for(i = 0; i < n; i++)
         {
            temp = "" + dateObj.year.substring(i,i + 1);
            if(DECIMAL_DIGITS.indexOf(temp) == -1)
            {
               results.push(new ValidationResult(true,yearProp,"invalidChar",validator.invalidCharError));
            }
         }
         if(results.length > 0)
         {
            return results;
         }
         var monthNum:Number = Number(dateObj.month);
         var dayNum:Number = Number(dateObj.day);
         var yearNum:Number = Number(dateObj.year).valueOf();
         if(monthNum > 12 || monthNum < 1)
         {
            results.push(new ValidationResult(true,monthProp,"wrongMonth",validator.wrongMonthError));
            return results;
         }
         var maxDay:Number = 31;
         if(monthNum == 4 || monthNum == 6 || monthNum == 9 || monthNum == 11)
         {
            maxDay = 30;
         }
         else if(monthNum == 2)
         {
            if(yearNum % 4 > 0)
            {
               maxDay = 28;
            }
            else if(yearNum % 100 == 0 && yearNum % 400 > 0)
            {
               maxDay = 28;
            }
            else
            {
               maxDay = 29;
            }
         }
         if(dayRequired && (dayNum > maxDay || dayNum < 1))
         {
            results.push(new ValidationResult(true,dayProp,"wrongDay",validator.wrongDayError));
            return results;
         }
         if(yearRequired && (yearNum > 9999 || yearNum < 0))
         {
            results.push(new ValidationResult(true,yearProp,"wrongYear",validator.wrongYearError));
            return results;
         }
         return results;
      }
      
      private static function validateFormatString(validator:DateValidator, format:String, baseField:String) : ValidationResult
      {
         var mask:String = null;
         var monthCounter:Number = 0;
         var dayCounter:Number = 0;
         var yearCounter:Number = 0;
         var n:int = format.length;
         for(var i:int = 0; i < n; i++)
         {
            mask = "" + format.substring(i,i + 1);
            if(mask == "m" || mask == "M")
            {
               monthCounter++;
            }
            else if(mask == "d" || mask == "D")
            {
               dayCounter++;
            }
            else if(mask == "y" || mask == "Y")
            {
               yearCounter++;
            }
         }
         if(monthCounter == 2 && (yearCounter == 2 || yearCounter == 4) || monthCounter == 2 && dayCounter == 2 && (yearCounter == 0 || yearCounter == 2 || yearCounter == 4))
         {
            return null;
         }
         return new ValidationResult(true,baseField,"format",validator.formatError);
      }
      
      override protected function getValueFromSource() : Object
      {
         var useValue:Boolean = false;
         var value:Object = {};
         if(Boolean(daySource) && Boolean(dayProperty))
         {
            value.day = daySource[dayProperty];
            useValue = true;
         }
         if(Boolean(monthSource) && Boolean(monthProperty))
         {
            value.month = monthSource[monthProperty];
            useValue = true;
         }
         if(Boolean(yearSource) && Boolean(yearProperty))
         {
            value.year = yearSource[yearProperty];
            useValue = true;
         }
         return useValue ? value : super.getValueFromSource();
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongMonthError() : String
      {
         return _wrongMonthError;
      }
      
      [Inspectable(category="General")]
      public function get dayListener() : IValidatorListener
      {
         return _dayListener;
      }
      
      [Inspectable(category="General")]
      public function get yearListener() : IValidatorListener
      {
         return _yearListener;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get validateAsString() : Object
      {
         return _validateAsString;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return _invalidCharError;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongYearError() : String
      {
         return _wrongYearError;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongDayError() : String
      {
         return _wrongDayError;
      }
      
      public function set yearListener(value:IValidatorListener) : void
      {
         if(_yearListener == value)
         {
            return;
         }
         removeListenerHandler();
         _yearListener = value;
         addListenerHandler();
      }
      
      public function set monthListener(value:IValidatorListener) : void
      {
         if(_monthListener == value)
         {
            return;
         }
         removeListenerHandler();
         _monthListener = value;
         addListenerHandler();
      }
      
      public function set daySource(value:Object) : void
      {
         var message:String = null;
         if(_daySource == value)
         {
            return;
         }
         if(value is String)
         {
            message = resourceManager.getString("validators","DSAttribute",[value]);
            throw new Error(message);
         }
         removeListenerHandler();
         _daySource = value;
         addListenerHandler();
      }
      
      public function set invalidCharError(value:String) : void
      {
         invalidCharErrorOverride = value;
         _invalidCharError = value != null ? value : resourceManager.getString("validators","invalidCharErrorDV");
      }
      
      [Inspectable(category="General")]
      public function get yearSource() : Object
      {
         return _yearSource;
      }
      
      public function set validateAsString(value:Object) : void
      {
         validateAsStringOverride = value;
         _validateAsString = value != null ? Boolean(value) : resourceManager.getBoolean("validators","validateAsString");
      }
      
      public function set formatError(value:String) : void
      {
         formatErrorOverride = value;
         _formatError = value != null ? value : resourceManager.getString("validators","formatError");
      }
      
      [Inspectable(category="General")]
      public function get monthSource() : Object
      {
         return _monthSource;
      }
      
      public function set allowedFormatChars(value:String) : void
      {
         var n:int = 0;
         var i:int = 0;
         var message:String = null;
         if(value != null)
         {
            n = value.length;
            for(i = 0; i < n; i++)
            {
               if(DECIMAL_DIGITS.indexOf(value.charAt(i)) != -1)
               {
                  message = resourceManager.getString("validators","invalidFormatChars");
                  throw new Error(message);
               }
            }
         }
         allowedFormatCharsOverride = value;
         _allowedFormatChars = value != null ? value : resourceManager.getString("validators","dateValidatorAllowedFormatChars");
      }
      
      public function set wrongDayError(value:String) : void
      {
         wrongDayErrorOverride = value;
         _wrongDayError = value != null ? value : resourceManager.getString("validators","wrongDayError");
      }
      
      public function set inputFormat(value:String) : void
      {
         inputFormatOverride = value;
         _inputFormat = value != null ? value : resourceManager.getString("SharedResources","dateFormat");
      }
      
      public function set wrongYearError(value:String) : void
      {
         wrongYearErrorOverride = value;
         _wrongYearError = value != null ? value : resourceManager.getString("validators","wrongYearError");
      }
      
      public function set wrongLengthError(value:String) : void
      {
         wrongLengthErrorOverride = value;
         _wrongLengthError = value != null ? value : resourceManager.getString("validators","wrongLengthErrorDV");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         allowedFormatChars = allowedFormatCharsOverride;
         inputFormat = inputFormatOverride;
         validateAsString = validateAsStringOverride;
         invalidCharError = invalidCharErrorOverride;
         wrongLengthError = wrongLengthErrorOverride;
         wrongMonthError = wrongMonthErrorOverride;
         wrongDayError = wrongDayErrorOverride;
         wrongYearError = wrongYearErrorOverride;
         formatError = formatErrorOverride;
      }
      
      override protected function get actualListeners() : Array
      {
         var dayResult:Object = null;
         var monthResult:Object = null;
         var yearResult:Object = null;
         var results:Array = [];
         if(Boolean(_dayListener))
         {
            dayResult = _dayListener;
         }
         else if(Boolean(_daySource))
         {
            dayResult = _daySource;
         }
         if(Boolean(dayResult))
         {
            results.push(dayResult);
            if(dayResult is IValidatorListener)
            {
               IValidatorListener(dayResult).validationSubField = "day";
            }
         }
         if(Boolean(_monthListener))
         {
            monthResult = _monthListener;
         }
         else if(Boolean(_monthSource))
         {
            monthResult = _monthSource;
         }
         if(Boolean(monthResult))
         {
            results.push(monthResult);
            if(monthResult is IValidatorListener)
            {
               IValidatorListener(monthResult).validationSubField = "month";
            }
         }
         if(Boolean(_yearListener))
         {
            yearResult = _yearListener;
         }
         else if(Boolean(_yearSource))
         {
            yearResult = _yearSource;
         }
         if(Boolean(yearResult))
         {
            results.push(yearResult);
            if(yearResult is IValidatorListener)
            {
               IValidatorListener(yearResult).validationSubField = "year";
            }
         }
         if(results.length > 0 && Boolean(listener))
         {
            results.push(listener);
         }
         else
         {
            results = results.concat(super.actualListeners);
         }
         return results;
      }
      
      [Inspectable(category="General")]
      public function get monthListener() : IValidatorListener
      {
         return _monthListener;
      }
      
      [Inspectable(category="General")]
      public function get daySource() : Object
      {
         return _daySource;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongLengthError() : String
      {
         return _wrongLengthError;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get allowedFormatChars() : String
      {
         return _allowedFormatChars;
      }
      
      public function set dayListener(value:IValidatorListener) : void
      {
         if(_dayListener == value)
         {
            return;
         }
         removeListenerHandler();
         _dayListener = value;
         addListenerHandler();
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get inputFormat() : String
      {
         return _inputFormat;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get formatError() : String
      {
         return _formatError;
      }
      
      override protected function doValidation(value:Object) : Array
      {
         var results:Array = super.doValidation(value);
         var val:String = Boolean(value) ? String(value) : "";
         if(results.length > 0 || val.length == 0 && !required)
         {
            return results;
         }
         return DateValidator.validateDate(this,value,null);
      }
      
      public function set wrongMonthError(value:String) : void
      {
         wrongMonthErrorOverride = value;
         _wrongMonthError = value != null ? value : resourceManager.getString("validators","wrongMonthError");
      }
      
      public function set monthSource(value:Object) : void
      {
         var message:String = null;
         if(_monthSource == value)
         {
            return;
         }
         if(value is String)
         {
            message = resourceManager.getString("validators","MSAttribute",[value]);
            throw new Error(message);
         }
         removeListenerHandler();
         _monthSource = value;
         addListenerHandler();
      }
      
      public function set yearSource(value:Object) : void
      {
         var message:String = null;
         if(_yearSource == value)
         {
            return;
         }
         if(value is String)
         {
            message = resourceManager.getString("validators","YSAttribute",[value]);
            throw new Error(message);
         }
         removeListenerHandler();
         _yearSource = value;
         addListenerHandler();
      }
   }
}

