package mx.validators
{
   import mx.core.mx_internal;
   import mx.events.ValidationResultEvent;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   public class RegExpValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var regExp:RegExp;
      
      private var foundMatch:Boolean = false;
      
      private var _expression:String;
      
      private var _flags:String;
      
      private var _noExpressionError:String;
      
      private var noExpressionErrorOverride:String;
      
      private var _noMatchError:String;
      
      private var noMatchErrorOverride:String;
      
      public function RegExpValidator()
      {
         super();
      }
      
      [Inspectable(category="General")]
      public function get expression() : String
      {
         return this._expression;
      }
      
      public function set expression(value:String) : void
      {
         if(this._expression != value)
         {
            this._expression = value;
            this.createRegExp();
         }
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get flags() : String
      {
         return this._flags;
      }
      
      public function set flags(value:String) : void
      {
         if(this._flags != value)
         {
            this._flags = value;
            this.createRegExp();
         }
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get noExpressionError() : String
      {
         return this._noExpressionError;
      }
      
      public function set noExpressionError(value:String) : void
      {
         this.noExpressionErrorOverride = value;
         this._noExpressionError = value != null ? value : resourceManager.getString("validators","noExpressionError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get noMatchError() : String
      {
         return this._noMatchError;
      }
      
      public function set noMatchError(value:String) : void
      {
         this.noMatchErrorOverride = value;
         this._noMatchError = value != null ? value : resourceManager.getString("validators","noMatchError");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.noExpressionError = this.noExpressionErrorOverride;
         this.noMatchError = this.noMatchErrorOverride;
      }
      
      override protected function doValidation(value:Object) : Array
      {
         var results:Array = super.doValidation(value);
         var val:String = Boolean(value) ? String(value) : "";
         if(results.length > 0 || val.length == 0 && !required)
         {
            return results;
         }
         return this.validateRegExpression(value);
      }
      
      override protected function handleResults(errorResults:Array) : ValidationResultEvent
      {
         var result:ValidationResultEvent = null;
         if(this.foundMatch)
         {
            result = new ValidationResultEvent(ValidationResultEvent.VALID);
            result.results = errorResults;
         }
         else
         {
            result = super.handleResults(errorResults);
         }
         this.foundMatch = false;
         return result;
      }
      
      private function createRegExp() : void
      {
         this.regExp = new RegExp(this._expression,this._flags);
      }
      
      private function validateRegExpression(value:Object) : Array
      {
         var result:Object = null;
         var results:Array = [];
         this.foundMatch = false;
         if(Boolean(this.regExp) && this._expression != "")
         {
            result = this.regExp.exec(String(value));
            if(this.regExp.global)
            {
               while(result != null)
               {
                  results.push(new RegExpValidationResult(false,null,"","",result[0],result.index,result.slice(1)));
                  result = this.regExp.exec(String(value));
                  this.foundMatch = true;
               }
            }
            else if(result != null)
            {
               results.push(new RegExpValidationResult(false,null,"","",result[0],result.index,result.slice(1)));
               this.foundMatch = true;
            }
            if(results.length == 0)
            {
               results.push(new ValidationResult(true,null,"noMatch",this.noMatchError));
            }
         }
         else
         {
            results.push(new ValidationResult(true,null,"noExpression",this.noExpressionError));
         }
         return results;
      }
   }
}

