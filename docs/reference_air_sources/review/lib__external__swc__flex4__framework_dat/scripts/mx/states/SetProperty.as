package mx.states
{
   import mx.core.FlexVersion;
   import mx.core.IDeferredInstance;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.utils.ObjectUtil;
   
   use namespace mx_internal;
   
   public class SetProperty extends OverrideBase
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static const PSEUDONYMS:Object = {
         "width":"explicitWidth",
         "height":"explicitHeight",
         "currentState":"currentStateDeferred"
      };
      
      private static const RELATED_PROPERTIES:Object = {
         "explicitWidth":["percentWidth"],
         "explicitHeight":["percentHeight"],
         "percentWidth":["explicitWidth"],
         "percentHeight":["explicitHeight"]
      };
      
      private var oldValue:Object;
      
      private var oldRelatedValues:Array;
      
      [Inspectable(category="General")]
      public var name:String;
      
      [Inspectable(category="General")]
      public var target:Object;
      
      private var appliedTarget:Object;
      
      [Inspectable(category="General")]
      public var _value:*;
      
      public function SetProperty(target:Object = null, name:String = null, value:* = undefined, valueFactory:IDeferredInstance = null)
      {
         super();
         this.target = target;
         this.name = name;
         this.value = value;
         this.valueFactory = valueFactory;
      }
      
      public function get value() : *
      {
         return this._value;
      }
      
      public function set value(val:*) : void
      {
         this._value = val;
         if(applied)
         {
            this.apply(parentContext);
         }
      }
      
      public function set valueFactory(factory:IDeferredInstance) : void
      {
         if(Boolean(factory))
         {
            this.value = factory.getInstance();
         }
      }
      
      private function getPseudonym(obj:*, name:String) : String
      {
         var propName:String = null;
         var tmp:* = undefined;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            return PSEUDONYMS[name] in obj ? PSEUDONYMS[name] : name;
         }
         propName = PSEUDONYMS[name];
         if(!(propName in obj))
         {
            if(ObjectUtil.isDynamicObject(obj))
            {
               propName = name;
            }
            else
            {
               try
               {
                  tmp = obj[propName];
               }
               catch(e:ReferenceError)
               {
                  propName = name;
               }
            }
         }
         return propName;
      }
      
      override public function apply(parent:UIComponent) : void
      {
         var propName:String = null;
         var relatedProps:Array = null;
         var newValue:* = undefined;
         var i:int = 0;
         parentContext = parent;
         var obj:* = getOverrideContext(this.target,parent);
         if(obj != null)
         {
            this.appliedTarget = obj;
            propName = Boolean(PSEUDONYMS[this.name]) ? this.getPseudonym(obj,this.name) : this.name;
            relatedProps = Boolean(RELATED_PROPERTIES[propName]) ? RELATED_PROPERTIES[propName] : null;
            newValue = this.value;
            if(!applied)
            {
               this.oldValue = obj[propName];
            }
            if(Boolean(relatedProps))
            {
               this.oldRelatedValues = [];
               for(i = 0; i < relatedProps.length; i++)
               {
                  this.oldRelatedValues[i] = obj[relatedProps[i]];
               }
            }
            if(this.name == "width" || this.name == "height")
            {
               if(newValue is String && newValue.indexOf("%") >= 0)
               {
                  propName = this.name == "width" ? "percentWidth" : "percentHeight";
                  newValue = newValue.slice(0,newValue.indexOf("%"));
               }
               else
               {
                  propName = this.name;
               }
            }
            this.setPropertyValue(obj,propName,newValue,this.oldValue);
            enableBindings(obj,parent,propName,false);
         }
         else if(!applied)
         {
            addContextListener(this.target);
         }
         applied = true;
      }
      
      override public function remove(parent:UIComponent) : void
      {
         var propName:String = null;
         var relatedProps:Array = null;
         var i:int = 0;
         var obj:* = getOverrideContext(this.appliedTarget,parent);
         if(obj != null && Boolean(this.appliedTarget))
         {
            propName = Boolean(PSEUDONYMS[this.name]) ? this.getPseudonym(obj,this.name) : this.name;
            relatedProps = Boolean(RELATED_PROPERTIES[propName]) ? RELATED_PROPERTIES[propName] : null;
            if((this.name == "width" || this.name == "height") && !isNaN(Number(this.oldValue)))
            {
               propName = this.name;
            }
            this.setPropertyValue(obj,propName,this.oldValue,this.oldValue);
            enableBindings(obj,parent,propName);
            if(Boolean(relatedProps))
            {
               for(i = 0; i < relatedProps.length; i++)
               {
                  this.setPropertyValue(obj,relatedProps[i],this.oldRelatedValues[i],this.oldRelatedValues[i]);
               }
            }
         }
         else
         {
            removeContextListener();
         }
         applied = false;
         parentContext = null;
         this.appliedTarget = null;
      }
      
      private function setPropertyValue(obj:Object, name:String, value:*, valueForType:Object) : void
      {
         if(value === undefined || value === null)
         {
            obj[name] = value;
         }
         else if(valueForType is Number)
         {
            obj[name] = Number(value);
         }
         else if(valueForType is Boolean)
         {
            obj[name] = this.toBoolean(value);
         }
         else
         {
            obj[name] = value;
         }
      }
      
      private function toBoolean(value:Object) : Boolean
      {
         if(value is String)
         {
            return value.toLowerCase() == "true";
         }
         return value != false;
      }
   }
}

