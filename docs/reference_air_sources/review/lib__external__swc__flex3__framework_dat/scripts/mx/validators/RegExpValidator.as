package mx.validators
{
   import mx.core.mx_internal;
   import mx.events.ValidationResultEvent;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   public class RegExpValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _noMatchError:String;
      
      private var _flags:String;
      
      private var noMatchErrorOverride:String;
      
      private var _noExpressionError:String;
      
      private var foundMatch:Boolean = false;
      
      private var regExp:RegExp;
      
      private var _expression:String;
      
      private var noExpressionErrorOverride:String;
      
      public function RegExpValidator()
      {
         super();
      }
      
      private function createRegExp() : void
      {
         regExp = new RegExp(_expression,_flags);
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get flags() : String
      {
         return _flags;
      }
      
      public function set noMatchError(value:String) : void
      {
         noMatchErrorOverride = value;
         _noMatchError = value != null ? value : resourceManager.getString("validators","noMatchError");
      }
      
      public function set flags(value:String) : void
      {
         if(_flags != value)
         {
            _flags = value;
            createRegExp();
         }
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get noExpressionError() : String
      {
         return _noExpressionError;
      }
      
      [Inspectable(category="General")]
      public function get expression() : String
      {
         return _expression;
      }
      
      private function validateRegExpression(value:Object) : Array
      {
         var result:Object = null;
         var results:Array = [];
         foundMatch = false;
         if(Boolean(regExp) && _expression != "")
         {
            result = regExp.exec(String(value));
            if(regExp.global)
            {
               while(result != null)
               {
                  results.push(new RegExpValidationResult(false,null,"","",result[0],result.index,result.slice(1)));
                  result = regExp.exec(String(value));
                  foundMatch = true;
               }
            }
            else if(result != null)
            {
               results.push(new RegExpValidationResult(false,null,"","",result[0],result.index,result.slice(1)));
               foundMatch = true;
            }
            if(results.length == 0)
            {
               results.push(new ValidationResult(true,null,"noMatch",noMatchError));
            }
         }
         else
         {
            results.push(new ValidationResult(true,null,"noExpression",noExpressionError));
         }
         return results;
      }
      
      public function set noExpressionError(value:String) : void
      {
         noExpressionErrorOverride = value;
         _noExpressionError = value != null ? value : resourceManager.getString("validators","noExpressionError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get noMatchError() : String
      {
         return _noMatchError;
      }
      
      override protected function doValidation(value:Object) : Array
      {
         var results:Array = super.doValidation(value);
         var val:String = Boolean(value) ? String(value) : "";
         if(results.length > 0 || val.length == 0 && !required)
         {
            return results;
         }
         return validateRegExpression(value);
      }
      
      public function set expression(value:String) : void
      {
         if(_expression != value)
         {
            _expression = value;
            createRegExp();
         }
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         noExpressionError = noExpressionErrorOverride;
         noMatchError = noMatchErrorOverride;
      }
      
      override protected function handleResults(errorResults:Array) : ValidationResultEvent
      {
         var result:ValidationResultEvent = null;
         if(foundMatch)
         {
            result = new ValidationResultEvent(ValidationResultEvent.VALID);
            result.results = errorResults;
         }
         else
         {
            result = super.handleResults(errorResults);
         }
         foundMatch = false;
         return result;
      }
   }
}

