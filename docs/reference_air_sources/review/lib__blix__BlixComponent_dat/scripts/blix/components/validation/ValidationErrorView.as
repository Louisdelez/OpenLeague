package blix.components.validation
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.Context;
   import blix.frame.getEnterFrame;
   import blix.validation.IValidator;
   import blix.validation.ValidationError;
   
   public class ValidationErrorView extends SpriteProxy
   {
      
      private var _validators:Vector.<IValidator>;
      
      public function ValidationErrorView(param1:Context, param2:Vector.<IValidator> = null)
      {
         super(param1);
         setVisible(false);
         this.setValidators(param2);
         this.invalidateErrorsList();
      }
      
      protected function invalidateErrorsList() : void
      {
         getEnterFrame().add(this.validateErrorsList);
      }
      
      protected function validateErrorsList() : void
      {
         var _loc2_:IValidator = null;
         var _loc1_:Vector.<ValidationError> = new Vector.<ValidationError>();
         for each(_loc2_ in this._validators)
         {
            _loc1_ = _loc1_.concat(_loc2_.getErrors());
         }
         this.showErrors(_loc1_);
      }
      
      protected function showErrors(param1:Vector.<ValidationError>) : void
      {
         if(param1.length == 0)
         {
            setVisible(false);
         }
         else
         {
            setVisible(true);
         }
      }
      
      public function getValidators() : Vector.<IValidator>
      {
         return this._validators;
      }
      
      public function setValidators(param1:Vector.<IValidator>) : void
      {
         var _loc2_:IValidator = null;
         var _loc3_:IValidator = null;
         for each(_loc2_ in this._validators)
         {
            _loc2_.getValidated().remove(this.invalidateErrorsList);
         }
         this._validators = param1;
         for each(_loc3_ in this._validators)
         {
            _loc3_.getValidated().add(this.invalidateErrorsList);
         }
         this.invalidateErrorsList();
      }
   }
}

