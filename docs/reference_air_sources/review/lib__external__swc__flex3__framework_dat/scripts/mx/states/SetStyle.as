package mx.states
{
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.styles.IStyleClient;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class SetStyle implements IOverride
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const RELATED_PROPERTIES:Object = {
         "left":["x"],
         "top":["y"],
         "right":["x"],
         "bottom":["y"]
      };
      
      private var oldRelatedValues:Array;
      
      private var oldValue:Object;
      
      [Inspectable(category="General")]
      public var name:String;
      
      [Inspectable(category="General")]
      public var target:IStyleClient;
      
      [Inspectable(category="General")]
      public var value:Object;
      
      public function SetStyle(target:IStyleClient = null, name:String = null, value:Object = null)
      {
         super();
         this.target = target;
         this.name = name;
         this.value = value;
      }
      
      public function remove(parent:UIComponent) : void
      {
         var i:int = 0;
         var obj:IStyleClient = Boolean(target) ? target : parent;
         if(oldValue is Number)
         {
            obj.setStyle(name,Number(oldValue));
         }
         else if(oldValue is Boolean)
         {
            obj.setStyle(name,toBoolean(oldValue));
         }
         else if(oldValue === null)
         {
            obj.clearStyle(name);
         }
         else
         {
            obj.setStyle(name,oldValue);
         }
         var relatedProps:Array = Boolean(RELATED_PROPERTIES[name]) ? RELATED_PROPERTIES[name] : null;
         if(Boolean(relatedProps))
         {
            for(i = 0; i < relatedProps.length; i++)
            {
               obj[relatedProps[i]] = oldRelatedValues[i];
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
         var obj:IStyleClient = Boolean(target) ? target : parent;
         var relatedProps:Array = Boolean(RELATED_PROPERTIES[name]) ? RELATED_PROPERTIES[name] : null;
         oldValue = obj.getStyle(name);
         if(Boolean(relatedProps))
         {
            oldRelatedValues = [];
            for(i = 0; i < relatedProps.length; i++)
            {
               oldRelatedValues[i] = obj[relatedProps[i]];
            }
         }
         if(value === null)
         {
            obj.clearStyle(name);
         }
         else if(oldValue is Number)
         {
            if(name.toLowerCase().indexOf("color") != -1)
            {
               obj.setStyle(name,StyleManager.getColorName(value));
            }
            else
            {
               obj.setStyle(name,Number(value));
            }
         }
         else if(oldValue is Boolean)
         {
            obj.setStyle(name,toBoolean(value));
         }
         else
         {
            obj.setStyle(name,value);
         }
      }
      
      public function initialize() : void
      {
      }
   }
}

