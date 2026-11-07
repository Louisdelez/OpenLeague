package blix.validation
{
   import blix.model.ITextModel;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class ValidatorBase implements IValidator
   {
      
      private var _validated:Signal = new Signal();
      
      private var _errors:Vector.<ValidationError> = new Vector.<ValidationError>();
      
      public function ValidatorBase()
      {
         super();
      }
      
      public function getValidated() : ISignal
      {
         return this._validated;
      }
      
      public function getErrors() : Vector.<ValidationError>
      {
         return this._errors.slice();
      }
      
      public function validate() : Vector.<ValidationError>
      {
         this._errors.length = 0;
         this.doValidation();
         this._validated.dispatch(this,this._errors);
         return this._errors.slice();
      }
      
      protected function addError(param1:ITextModel) : void
      {
         this._errors[this._errors.length] = new ValidationError(this,param1);
      }
      
      [Abstract]
      protected function doValidation() : void
      {
      }
   }
}

