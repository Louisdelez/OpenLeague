package spark.validators.supportClasses
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import mx.events.ValidationResultEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.validators.IValidator;
   import mx.validators.IValidatorListener;
   import mx.validators.ValidationResult;
   import spark.globalization.supportClasses.GlobalizationBase;
   
   [ResourceBundle("validators")]
   [ResourceBundle("core")]
   [Event(name="invalid",type="mx.events.ValidationResultEvent")]
   [Event(name="valid",type="mx.events.ValidationResultEvent")]
   public class GlobalizationValidatorBase extends GlobalizationBase implements IValidator
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _enabled:Boolean = true;
      
      private var _listener:Object;
      
      private var _property:String;
      
      [Inspectable(category="General",defaultValue="true")]
      public var required:Boolean = true;
      
      private var _resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _source:Object;
      
      protected var subFields:Array = [];
      
      private var _trigger:IEventDispatcher;
      
      private var _triggerEvent:String = "valueCommit";
      
      private var _requiredFieldError:String;
      
      private var requiredFieldErrorOverride:String;
      
      public function GlobalizationValidatorBase()
      {
         super();
         this.resourceManager.addEventListener(Event.CHANGE,this.resourceManager_changeHandler,false,0,true);
         this.resourcesChanged();
      }
      
      public static function validateAll(validators:Array) : Array
      {
         var v:IValidator = null;
         var resultEvent:ValidationResultEvent = null;
         var result:Array = [];
         var n:int = int(validators.length);
         for(var i:int = 0; i < n; i++)
         {
            v = validators[i] as IValidator;
            if(Boolean(v) && Boolean(v.enabled))
            {
               resultEvent = v.validate();
               if(resultEvent.type != ValidationResultEvent.VALID)
               {
                  result.push(resultEvent);
               }
            }
         }
         return result;
      }
      
      private static function findObjectFromString(doc:Object, value:String) : Object
      {
         var i:int;
         var resourceManager:IResourceManager = null;
         var message:String = null;
         var obj:Object = doc;
         var parts:Array = value.split(".");
         var n:int = int(parts.length);
         for(i = 0; i < n; i++)
         {
            try
            {
               obj = obj[parts[i]];
               if(obj)
               {
               }
            }
            catch(error:Error)
            {
               if(error is TypeError && error.message.indexOf("null has no properties") != -1)
               {
                  resourceManager = ResourceManager.getInstance();
                  message = resourceManager.getString("validators","fieldNotFound",[value]);
                  throw new Error(message);
               }
               throw error;
            }
         }
         return obj;
      }
      
      private static function trimString(str:String) : String
      {
         var startIndex:int = 0;
         while(str.indexOf(" ",startIndex) == startIndex)
         {
            startIndex++;
         }
         var endIndex:int = str.length - 1;
         while(str.lastIndexOf(" ",endIndex) == endIndex)
         {
            endIndex--;
         }
         return endIndex >= startIndex ? str.slice(startIndex,endIndex + 1) : "";
      }
      
      protected function get actualTrigger() : IEventDispatcher
      {
         if(Boolean(this._trigger))
         {
            return this._trigger;
         }
         if(Boolean(this._source))
         {
            return this._source as IEventDispatcher;
         }
         return null;
      }
      
      protected function get actualListeners() : Array
      {
         var result:Array = [];
         if(Boolean(this._listener))
         {
            result.push(this._listener);
         }
         else if(Boolean(this._source))
         {
            result.push(this._source);
         }
         return result;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(value:Boolean) : void
      {
         this._enabled = value;
      }
      
      [Inspectable(category="General")]
      public function get listener() : Object
      {
         return this._listener;
      }
      
      public function set listener(value:Object) : void
      {
         this.removeListenerHandler();
         this._listener = value;
         this.addListenerHandler();
      }
      
      [Inspectable(category="General")]
      public function get property() : String
      {
         return this._property;
      }
      
      public function set property(value:String) : void
      {
         this._property = value;
      }
      
      [Bindable("unused")]
      protected function get resourceManager() : IResourceManager
      {
         return this._resourceManager;
      }
      
      [Inspectable(category="General")]
      public function get source() : Object
      {
         return this._source;
      }
      
      public function set source(value:Object) : void
      {
         var message:String = null;
         if(this._source == value)
         {
            return;
         }
         if(value is String)
         {
            message = this.resourceManager.getString("validators","SAttribute",[value]);
            throw new Error(message);
         }
         this.removeTriggerHandler();
         this.removeListenerHandler();
         this._source = value;
         this.addTriggerHandler();
         this.addListenerHandler();
      }
      
      [Inspectable(category="General")]
      public function get trigger() : IEventDispatcher
      {
         return this._trigger;
      }
      
      public function set trigger(value:IEventDispatcher) : void
      {
         this.removeTriggerHandler();
         this._trigger = value;
         this.addTriggerHandler();
      }
      
      [Inspectable(category="General")]
      public function get triggerEvent() : String
      {
         return this._triggerEvent;
      }
      
      public function set triggerEvent(value:String) : void
      {
         if(this._triggerEvent == value)
         {
            return;
         }
         this.removeTriggerHandler();
         this._triggerEvent = value;
         this.addTriggerHandler();
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get requiredFieldError() : String
      {
         return this._requiredFieldError;
      }
      
      public function set requiredFieldError(value:String) : void
      {
         this.requiredFieldErrorOverride = value;
         this._requiredFieldError = Boolean(value) ? value : this.resourceManager.getString("validators","requiredFieldError");
      }
      
      public function validate(value:Object = null, suppressEvents:Boolean = false) : ValidationResultEvent
      {
         var resultEvent:ValidationResultEvent = null;
         if(!value)
         {
            value = this.getValueFromSource();
         }
         if(this.isRealValue(value) || this.required)
         {
            return this.processValidation(value,suppressEvents);
         }
         resultEvent = new ValidationResultEvent(ValidationResultEvent.VALID);
         if(!suppressEvents && this._enabled)
         {
            dispatchEvent(resultEvent);
         }
         return resultEvent;
      }
      
      protected function resourcesChanged() : void
      {
         this.requiredFieldError = this.requiredFieldErrorOverride;
      }
      
      protected function addListenerHandler() : void
      {
         var actualListener:Object = null;
         var listeners:Array = this.actualListeners;
         var n:int = int(listeners.length);
         for(var i:int = 0; i < n; i++)
         {
            actualListener = listeners[i];
            if(actualListener is IValidatorListener)
            {
               addEventListener(ValidationResultEvent.VALID,IValidatorListener(actualListener).validationResultHandler);
               addEventListener(ValidationResultEvent.INVALID,IValidatorListener(actualListener).validationResultHandler);
            }
         }
      }
      
      protected function removeListenerHandler() : void
      {
         var actualListener:Object = null;
         var listeners:Array = this.actualListeners;
         var n:int = int(listeners.length);
         for(var i:int = 0; i < n; i++)
         {
            actualListener = listeners[i];
            if(actualListener is IValidatorListener)
            {
               removeEventListener(ValidationResultEvent.VALID,IValidatorListener(actualListener).validationResultHandler);
               removeEventListener(ValidationResultEvent.INVALID,IValidatorListener(actualListener).validationResultHandler);
            }
         }
      }
      
      protected function isRealValue(value:Object) : Boolean
      {
         return value != null;
      }
      
      protected function getValueFromSource() : Object
      {
         var message:String = null;
         if(Boolean(this._source) && Boolean(this._property))
         {
            return this._source[this._property];
         }
         if(!this._source && Boolean(this._property))
         {
            message = this.resourceManager.getString("validators","SAttributeMissing");
            throw new Error(message);
         }
         if(Boolean(this._source) && !this._property)
         {
            message = this.resourceManager.getString("validators","PAttributeMissing");
            throw new Error(message);
         }
         return null;
      }
      
      protected function doValidation(value:Object) : Array
      {
         var results:Array = [];
         var result:ValidationResult = this.validateRequired(value);
         if(Boolean(result))
         {
            results.push(result);
         }
         return results;
      }
      
      protected function handleResults(errorResults:Array) : ValidationResultEvent
      {
         var resultEvent:ValidationResultEvent = null;
         var errorFields:Object = null;
         var subField:String = null;
         var n:int = 0;
         var i:int = 0;
         if(errorResults.length > 0)
         {
            resultEvent = new ValidationResultEvent(ValidationResultEvent.INVALID);
            resultEvent.results = errorResults;
            if(this.subFields.length > 0)
            {
               errorFields = {};
               n = int(errorResults.length);
               for(i = 0; i < n; i++)
               {
                  subField = errorResults[i].subField;
                  if(Boolean(subField))
                  {
                     errorFields[subField] = true;
                  }
               }
               n = int(this.subFields.length);
               for(i = 0; i < n; i++)
               {
                  if(!errorFields[this.subFields[i]])
                  {
                     errorResults.push(new ValidationResult(false,this.subFields[i]));
                  }
               }
            }
         }
         else
         {
            resultEvent = new ValidationResultEvent(ValidationResultEvent.VALID);
         }
         return resultEvent;
      }
      
      private function addTriggerHandler() : void
      {
         if(Boolean(this.actualTrigger))
         {
            this.actualTrigger.addEventListener(this._triggerEvent,this.triggerHandler);
         }
      }
      
      private function removeTriggerHandler() : void
      {
         if(Boolean(this.actualTrigger))
         {
            this.actualTrigger.removeEventListener(this._triggerEvent,this.triggerHandler);
         }
      }
      
      private function processValidation(value:Object, suppressEvents:Boolean) : ValidationResultEvent
      {
         var resultEvent:ValidationResultEvent = null;
         var errorResults:Array = null;
         if(this._enabled)
         {
            errorResults = this.doValidation(value);
            resultEvent = this.handleResults(errorResults);
         }
         else
         {
            suppressEvents = true;
         }
         if(!suppressEvents)
         {
            dispatchEvent(resultEvent);
         }
         return resultEvent;
      }
      
      private function validateRequired(value:Object) : ValidationResult
      {
         var val:String = null;
         if(this.required)
         {
            val = value != null ? String(value) : "";
            val = trimString(val);
            if(val.length == 0)
            {
               return new ValidationResult(true,"","requiredField",this.requiredFieldError);
            }
         }
         return null;
      }
      
      private function triggerHandler(event:Event) : void
      {
         this.validate();
      }
      
      private function resourceManager_changeHandler(event:Event) : void
      {
         this.resourcesChanged();
      }
   }
}

