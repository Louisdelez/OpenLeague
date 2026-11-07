package mx.validators
{
   import mx.core.mx_internal;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   public class StringValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var _maxLength:Object;
      
      private var maxLengthOverride:Object;
      
      private var _minLength:Object;
      
      private var minLengthOverride:Object;
      
      private var _tooLongError:String;
      
      private var tooLongErrorOverride:String;
      
      private var _tooShortError:String;
      
      private var tooShortErrorOverride:String;
      
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
      
      [Inspectable(category="General",defaultValue="null")]
      public function get maxLength() : Object
      {
         return this._maxLength;
      }
      
      public function set maxLength(value:Object) : void
      {
         this.maxLengthOverride = value;
         this._maxLength = value != null ? Number(value) : resourceManager.getNumber("validators","maxLength");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get minLength() : Object
      {
         return this._minLength;
      }
      
      public function set minLength(value:Object) : void
      {
         this.minLengthOverride = value;
         this._minLength = value != null ? Number(value) : resourceManager.getNumber("validators","minLength");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get tooLongError() : String
      {
         return this._tooLongError;
      }
      
      public function set tooLongError(value:String) : void
      {
         this.tooLongErrorOverride = value;
         this._tooLongError = value != null ? value : resourceManager.getString("validators","tooLongError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get tooShortError() : String
      {
         return this._tooShortError;
      }
      
      public function set tooShortError(value:String) : void
      {
         this.tooShortErrorOverride = value;
         this._tooShortError = value != null ? value : resourceManager.getString("validators","tooShortError");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.maxLength = this.maxLengthOverride;
         this.minLength = this.minLengthOverride;
         this.tooLongError = this.tooLongErrorOverride;
         this.tooShortError = this.tooShortErrorOverride;
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

