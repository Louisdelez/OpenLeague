package mx.validators
{
   import mx.core.mx_internal;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   public class StringValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var minLengthOverride:Object;
      
      private var tooShortErrorOverride:String;
      
      private var maxLengthOverride:Object;
      
      private var _tooLongError:String;
      
      private var _minLength:Object;
      
      private var _tooShortError:String;
      
      private var tooLongErrorOverride:String;
      
      private var _maxLength:Object;
      
      public function StringValidator()
      {
         super();
      }
      
      public static function validateString(validator:StringValidator, value:Object, baseField:String = null) : Array
      {
         var results:Array = [];
         var maxLength:Number = Number(validator.maxLength);
         var minLength:Number = Number(validator.minLength);
         var val:String = value != null ? String(value) : "";
         if(!isNaN(maxLength) && val.length > maxLength)
         {
            results.push(new ValidationResult(true,baseField,"tooLong",StringUtil.substitute(validator.tooLongError,maxLength)));
            return results;
         }
         if(!isNaN(minLength) && val.length < minLength)
         {
            results.push(new ValidationResult(true,baseField,"tooShort",StringUtil.substitute(validator.tooShortError,minLength)));
            return results;
         }
         return results;
      }
      
      public function set tooShortError(value:String) : void
      {
         tooShortErrorOverride = value;
         _tooShortError = value != null ? value : resourceManager.getString("validators","tooShortError");
      }
      
      public function set maxLength(value:Object) : void
      {
         maxLengthOverride = value;
         _maxLength = value != null ? Number(value) : resourceManager.getNumber("validators","maxLength");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         maxLength = maxLengthOverride;
         minLength = minLengthOverride;
         tooLongError = tooLongErrorOverride;
         tooShortError = tooShortErrorOverride;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get minLength() : Object
      {
         return _minLength;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get tooShortError() : String
      {
         return _tooShortError;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get maxLength() : Object
      {
         return _maxLength;
      }
      
      public function set tooLongError(value:String) : void
      {
         tooLongErrorOverride = value;
         _tooLongError = value != null ? value : resourceManager.getString("validators","tooLongError");
      }
      
      public function set minLength(value:Object) : void
      {
         minLengthOverride = value;
         _minLength = value != null ? Number(value) : resourceManager.getNumber("validators","minLength");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get tooLongError() : String
      {
         return _tooLongError;
      }
      
      override protected function doValidation(value:Object) : Array
      {
         var results:Array = super.doValidation(value);
         var val:String = Boolean(value) ? String(value) : "";
         if(results.length > 0 || val.length == 0 && !required)
         {
            return results;
         }
         return StringValidator.validateString(this,value,null);
      }
   }
}

