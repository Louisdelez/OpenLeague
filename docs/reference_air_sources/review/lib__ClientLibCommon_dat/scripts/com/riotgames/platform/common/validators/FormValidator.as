package com.riotgames.platform.common.validators
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.events.ValidationResultEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.validators.Validator;
   
   public class FormValidator extends EventDispatcher
   {
      
      private var validators:Array;
      
      private var _validationObjects:Array;
      
      protected var _formIsValid:Boolean = false;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var validatorFactory:ValidatorFactory;
      
      protected var focussedFormControl:DisplayObject;
      
      public function FormValidator(param1:IEventDispatcher = null)
      {
         super(param1);
         this.validators = new Array();
         this.validatorFactory = new ValidatorFactory();
      }
      
      private function onValidatorChange(param1:Event) : void
      {
         var _loc2_:Validator = null;
         var _loc3_:Validator = null;
         var _loc4_:DisplayObject = null;
         this.focussedFormControl = param1.target as DisplayObject;
         this.formIsValid = true;
         for each(_loc2_ in this.validators)
         {
            _loc4_ = DisplayObject(_loc2_.source);
         }
         for each(_loc3_ in this.validators)
         {
            this.validate(_loc3_);
         }
      }
      
      [Bindable(event="formValidationChange")]
      public function get formIsValid() : Boolean
      {
         return this._formIsValid;
      }
      
      private function clearListeners() : void
      {
         var _loc1_:Validator = null;
         for each(_loc1_ in this.validators)
         {
            DisplayObject(_loc1_.source).removeEventListener(Event.CHANGE,this.onValidatorChange);
            _loc1_.source = null;
            _loc1_.trigger = null;
         }
      }
      
      public function clearValidators() : void
      {
         if(Boolean(this.validators.length))
         {
            this.clearListeners();
         }
         this.validators = new Array();
      }
      
      public function set validationObjects(param1:Array) : void
      {
         this._validationObjects = param1;
      }
      
      protected function validate(param1:Validator) : Boolean
      {
         var _loc2_:DisplayObject = param1.source as DisplayObject;
         var _loc3_:Boolean = _loc2_ != this.focussedFormControl;
         var _loc4_:ValidationResultEvent = param1.validate(null,_loc3_);
         var _loc5_:Boolean = _loc4_.type == ValidationResultEvent.VALID;
         this.formIsValid = this.formIsValid && _loc5_;
         return _loc5_;
      }
      
      public function validateForm() : void
      {
         var _loc1_:Validator = null;
         this.formIsValid = true;
         for each(_loc1_ in this.validators)
         {
            this.validate(_loc1_);
         }
      }
      
      public function get validationObjects() : Array
      {
         return this._validationObjects;
      }
      
      public function set formIsValid(param1:Boolean) : void
      {
         this._formIsValid = param1;
         dispatchEvent(new Event("formValidationChange"));
      }
      
      public function createValidators() : void
      {
         var _loc1_:ValidationObject = null;
         var _loc2_:Validator = null;
         if(Boolean(this.validators.length))
         {
            this.clearListeners();
         }
         this.validators = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < this.validationObjects.length)
         {
            _loc1_ = this.validationObjects[_loc3_] as ValidationObject;
            _loc2_ = this.validatorFactory.createValidator(_loc1_);
            _loc2_.required = _loc1_.required;
            this.validators.push(_loc2_);
            if(Boolean(_loc1_.source))
            {
               _loc1_.source.addEventListener(Event.CHANGE,this.onValidatorChange,false,0,true);
            }
            _loc3_++;
         }
      }
   }
}

