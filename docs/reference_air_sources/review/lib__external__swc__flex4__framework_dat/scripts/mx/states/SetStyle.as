package mx.states
{
   import mx.core.IDeferredInstance;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.styles.IStyleClient;
   import mx.styles.IStyleManager2;
   
   use namespace mx_internal;
   
   public class SetStyle extends OverrideBase
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static const RELATED_PROPERTIES:Object = {
         "left":["x"],
         "top":["y"],
         "right":["x"],
         "bottom":["y"]
      };
      
      private var oldValue:Object;
      
      private var wasInline:Boolean;
      
      private var oldRelatedValues:Array;
      
      [Inspectable(category="General")]
      public var name:String;
      
      [Inspectable(category="General")]
      public var target:Object;
      
      private var appliedTarget:Object;
      
      [Inspectable(category="General")]
      public var _value:Object;
      
      public function SetStyle(target:IStyleClient = null, name:String = null, value:Object = null, valueFactory:IDeferredInstance = null)
      {
         super();
         this.target = target;
         this.name = name;
         this.value = value;
         this.valueFactory = valueFactory;
      }
      
      public function get value() : Object
      {
         return this._value;
      }
      
      public function set value(val:Object) : void
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
      
      override public function apply(parent:UIComponent) : void
      {
         var obj:IStyleClient = null;
         var relatedProps:Array = null;
         var i:int = 0;
         var styleManager:IStyleManager2 = null;
         parentContext = parent;
         var context:Object = getOverrideContext(this.target,parent);
         if(context != null)
         {
            this.appliedTarget = context;
            obj = IStyleClient(this.appliedTarget);
            relatedProps = Boolean(RELATED_PROPERTIES[this.name]) ? RELATED_PROPERTIES[this.name] : null;
            if(!applied)
            {
               this.wasInline = Boolean(obj.styleDeclaration) && obj.styleDeclaration.getStyle(this.name) !== undefined;
               this.oldValue = this.wasInline ? obj.getStyle(this.name) : null;
            }
            if(Boolean(relatedProps))
            {
               this.oldRelatedValues = [];
               for(i = 0; i < relatedProps.length; i++)
               {
                  this.oldRelatedValues[i] = obj[relatedProps[i]];
               }
            }
            if(this.value === null)
            {
               obj.clearStyle(this.name);
            }
            else if(this.oldValue is Number)
            {
               if(this.name.toLowerCase().indexOf("color") != -1)
               {
                  if(obj is UIComponent)
                  {
                     styleManager = UIComponent(obj).styleManager;
                  }
                  else
                  {
                     styleManager = parent.styleManager;
                  }
                  obj.setStyle(this.name,styleManager.getColorName(this.value));
               }
               else if(this.value is String && String(this.value).lastIndexOf("%") == String(this.value).length - 1)
               {
                  obj.setStyle(this.name,this.value);
               }
               else
               {
                  obj.setStyle(this.name,Number(this.value));
               }
            }
            else if(this.oldValue is Boolean)
            {
               obj.setStyle(this.name,this.toBoolean(this.value));
            }
            else
            {
               obj.setStyle(this.name,this.value);
            }
            enableBindings(obj,parent,this.name,false);
         }
         else if(!applied)
         {
            addContextListener(this.target);
         }
         applied = true;
      }
      
      override public function remove(parent:UIComponent) : void
      {
         var relatedProps:Array = null;
         var i:int = 0;
         var obj:IStyleClient = IStyleClient(getOverrideContext(this.appliedTarget,parent));
         if(obj != null && Boolean(this.appliedTarget))
         {
            if(this.wasInline)
            {
               if(this.oldValue is Number)
               {
                  obj.setStyle(this.name,Number(this.oldValue));
               }
               else if(this.oldValue is Boolean)
               {
                  obj.setStyle(this.name,this.toBoolean(this.oldValue));
               }
               else if(this.oldValue === null)
               {
                  obj.clearStyle(this.name);
               }
               else
               {
                  obj.setStyle(this.name,this.oldValue);
               }
            }
            else
            {
               obj.clearStyle(this.name);
            }
            enableBindings(obj,parent,this.name);
            relatedProps = Boolean(RELATED_PROPERTIES[this.name]) ? RELATED_PROPERTIES[this.name] : null;
            if(Boolean(relatedProps))
            {
               for(i = 0; i < relatedProps.length; i++)
               {
                  obj[relatedProps[i]] = this.oldRelatedValues[i];
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

