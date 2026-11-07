package mx.states
{
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class SetProperty implements IOverride
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const PSEUDONYMS:Object = {
         "width":"explicitWidth",
         "height":"explicitHeight"
      };
      
      private static const RELATED_PROPERTIES:Object = {
         "explicitWidth":["percentWidth"],
         "explicitHeight":["percentHeight"]
      };
      
      private var oldRelatedValues:Array;
      
      private var oldValue:Object;
      
      [Inspectable(category="General")]
      public var name:String;
      
      [Inspectable(category="General")]
      public var target:Object;
      
      [Inspectable(category="General")]
      public var value:*;
      
      public function SetProperty(target:Object = null, name:String = null, value:* = undefined)
      {
         super();
         this.target = target;
         this.name = name;
         this.value = value;
      }
      
      public function remove(parent:UIComponent) : void
      {
         var i:int = 0;
         var obj:Object = Boolean(target) ? target : parent;
         var propName:String = Boolean(PSEUDONYMS[name]) ? PSEUDONYMS[name] : name;
         var relatedProps:Array = Boolean(RELATED_PROPERTIES[propName]) ? RELATED_PROPERTIES[propName] : null;
         if((name == "width" || name == "height") && !isNaN(Number(oldValue)))
         {
            propName = name;
         }
         setPropertyValue(obj,propName,oldValue,oldValue);
         if(Boolean(relatedProps))
         {
            for(i = 0; i < relatedProps.length; i++)
            {
               setPropertyValue(obj,relatedProps[i],oldRelatedValues[i],oldRelatedValues[i]);
            }
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
      
      public function apply(parent:UIComponent) : void
      {
         var i:int = 0;
         var obj:Object = Boolean(target) ? target : parent;
         var propName:String = Boolean(PSEUDONYMS[name]) ? PSEUDONYMS[name] : name;
         var relatedProps:Array = Boolean(RELATED_PROPERTIES[propName]) ? RELATED_PROPERTIES[propName] : null;
         var newValue:* = value;
         oldValue = obj[propName];
         if(Boolean(relatedProps))
         {
            oldRelatedValues = [];
            for(i = 0; i < relatedProps.length; i++)
            {
               oldRelatedValues[i] = obj[relatedProps[i]];
            }
         }
         if(name == "width" || name == "height")
         {
            if(newValue is String && newValue.indexOf("%") >= 0)
            {
               propName = name == "width" ? "percentWidth" : "percentHeight";
               newValue = newValue.slice(0,newValue.indexOf("%"));
            }
            else
            {
               propName = name;
            }
         }
         setPropertyValue(obj,propName,newValue,oldValue);
      }
      
      public function initialize() : void
      {
      }
      
      private function setPropertyValue(obj:Object, name:String, value:*, valueForType:Object) : void
      {
         if(valueForType is Number)
         {
            obj[name] = Number(value);
         }
         else if(valueForType is Boolean)
         {
            obj[name] = toBoolean(value);
         }
         else
         {
            obj[name] = value;
         }
      }
   }
}

