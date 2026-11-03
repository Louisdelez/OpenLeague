package mx.validators
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.core.IMXMLObject;
   import mx.core.mx_internal;
   import mx.events.ValidationResultEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   [ResourceBundle("core")]
   [Event(name="invalid",type="mx.events.ValidationResultEvent")]
   [Event(name="valid",type="mx.events.ValidationResultEvent")]
   public class Validator extends EventDispatcher implements IMXMLObject
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      protected static const ROMAN_LETTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
      
      protected static const DECIMAL_DIGITS:String = "0123456789";
      
      private var _resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _enabled:Boolean = true;
      
      private var _listener:Object;
      
      protected var subFields:Array = [];
      
      private var document:Object;
      
      [Inspectable(category="General",defaultValue="true")]
      public var required:Boolean = true;
      
      private var requiredFieldErrorOverride:String;
      
      private var _triggerEvent:String = "valueCommit";
      
      private var _source:Object;
      
      private var _property:String;
      
      private var _requiredFieldError:String;
      
      private var _trigger:IEventDispatcher;
      
      public function Validator()
      {
         super();
         resourceManager.addEventListener(Event.CHANGE,resourceManager_changeHandler,false,0,true);
         resourcesChanged();
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
               if(obj == null)
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
      
      public static function validateAll(validators:Array) : Array
      {
         var v:Validator = null;
         var resultEvent:ValidationResultEvent = null;
         var result:Array = [];
         var n:int = int(validators.length);
         for(var i:int = 0; i < n; i++)
         {
            v = Validator(validators[i]);
            if(v.enabled)
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
      
      private function triggerHandler(event:Event) : void
      {
         validate();
      }
      
      public function set enabled(value:Boolean) : void
      {
         _enabled = value;
      }
      
      public function set triggerEvent(value:String) : void
      {
         if(_triggerEvent == value)
         {
            return;
         }
         removeTriggerHandler();
         _triggerEvent = value;
         addTriggerHandler();
      }
      
      protected function getValueFromSource() : Object
      {
         var message:String = null;
         if(Boolean(_source) && Boolean(_property))
         {
            return _source[_property];
         }
         if(!_source && Boolean(_property))
         {
            message = resourceManager.getString("validators","SAttributeMissing");
            throw new Error(message);
         }
         if(Boolean(_source) && !_property)
         {
            message = resourceManager.getString("validators","PAttributeMissing");
            throw new Error(message);
         }
         return null;
      }
      
      protected function addListenerHandler() : void
      {
         var actualListener:Object = null;
         var listeners:Array = actualListeners;
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
      
      private function removeTriggerHandler() : void
      {
         if(Boolean(actualTrigger))
         {
            actualTrigger.removeEventListener(_triggerEvent,triggerHandler);
         }
      }
      
      public function validate(value:Object = null, suppressEvents:Boolean = false) : ValidationResultEvent
      {
         if(value == null)
         {
            value = getValueFromSource();
         }
         if(isRealValue(value) || required)
         {
            return processValidation(value,suppressEvents);
         }
         return new ValidationResultEvent(ValidationResultEvent.VALID);
      }
      
      [Inspectable(category="General")]
      public function get source() : Object
      {
         return _source;
      }
      
      public function set property(value:String) : void
      {
         _property = value;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get requiredFieldError() : String
      {
         return _requiredFieldError;
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
            if(subFields.length > 0)
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
               n = int(subFields.length);
               for(i = 0; i < n; i++)
               {
                  if(!errorFields[subFields[i]])
                  {
                     errorResults.push(new ValidationResult(false,subFields[i]));
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
      
      [Inspectable(category="General")]
      public function get listener() : Object
      {
         return _listener;
      }
      
      [Inspectable(category="General")]
      public function get trigger() : IEventDispatcher
      {
         return _trigger;
      }
      
      public function set source(value:Object) : void
      {
         var message:String = null;
         if(_source == value)
         {
            return;
         }
         if(value is String)
         {
            message = resourceManager.getString("validators","SAttribute",[value]);
            throw new Error(message);
         }
         removeTriggerHandler();
         removeListenerHandler();
         _source = value;
         addTriggerHandler();
         addListenerHandler();
      }
      
      [Bindable("unused")]
      protected function get resourceManager() : IResourceManager
      {
         return _resourceManager;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      private function processValidation(value:Object, suppressEvents:Boolean) : ValidationResultEvent
      {
         var resultEvent:ValidationResultEvent = null;
         var errorResults:Array = null;
         if(_enabled)
         {
            errorResults = doValidation(value);
            resultEvent = handleResults(errorResults);
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
      
      [Inspectable(category="General")]
      public function get triggerEvent() : String
      {
         return _triggerEvent;
      }
      
      protected function get actualTrigger() : IEventDispatcher
      {
         if(Boolean(_trigger))
         {
            return _trigger;
         }
         if(Boolean(_source))
         {
            return _source as IEventDispatcher;
         }
         return null;
      }
      
      protected function resourcesChanged() : void
      {
         requiredFieldError = requiredFieldErrorOverride;
      }
      
      protected function get actualListeners() : Array
      {
         var result:Array = [];
         if(Boolean(_listener))
         {
            result.push(_listener);
         }
         else if(Boolean(_source))
         {
            result.push(_source);
         }
         return result;
      }
      
      protected function removeListenerHandler() : void
      {
         var actualListener:Object = null;
         var listeners:Array = actualListeners;
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
      
      public function initialized(document:Object, id:String) : void
      {
         this.document = document;
      }
      
      [Inspectable(category="General")]
      public function get property() : String
      {
         return _property;
      }
      
      public function set requiredFieldError(value:String) : void
      {
         requiredFieldErrorOverride = value;
         _requiredFieldError = value != null ? value : resourceManager.getString("validators","requiredFieldError");
      }
      
      private function validateRequired(value:Object) : ValidationResult
      {
         var val:String = null;
         if(required)
         {
            val = value != null ? String(value) : "";
            val = trimString(val);
            if(val.length == 0)
            {
               return new ValidationResult(true,"","requiredField",requiredFieldError);
            }
         }
         return null;
      }
      
      protected function doValidation(value:Object) : Array
      {
         var results:Array = [];
         var result:ValidationResult = validateRequired(value);
         if(Boolean(result))
         {
            results.push(result);
         }
         return results;
      }
      
      public function set listener(value:Object) : void
      {
         removeListenerHandler();
         _listener = value;
         addListenerHandler();
      }
      
      protected function isRealValue(value:Object) : Boolean
      {
         return value != null;
      }
      
      public function set trigger(value:IEventDispatcher) : void
      {
         removeTriggerHandler();
         _trigger = value;
         addTriggerHandler();
      }
      
      private function addTriggerHandler() : void
      {
         if(Boolean(actualTrigger))
         {
            actualTrigger.addEventListener(_triggerEvent,triggerHandler);
         }
      }
      
      private function resourceManager_changeHandler(event:Event) : void
      {
         resourcesChanged();
      }
   }
}

