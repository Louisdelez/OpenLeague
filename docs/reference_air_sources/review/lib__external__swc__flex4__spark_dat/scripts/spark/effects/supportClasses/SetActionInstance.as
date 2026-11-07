package spark.effects.supportClasses
{
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.effects.effectClasses.ActionEffectInstance;
   import mx.styles.StyleManager;
   
   public class SetActionInstance extends ActionEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var property:String;
      
      private var _value:*;
      
      public function SetActionInstance(target:Object)
      {
         super(target);
      }
      
      public function get value() : *
      {
         var val:* = undefined;
         if(playReversed)
         {
            val = getStartValue();
            if(val !== undefined)
            {
               return val;
            }
         }
         return this._value;
      }
      
      public function set value(val:*) : void
      {
         this._value = val;
      }
      
      override public function play() : void
      {
         super.play();
         if(this.value === undefined && Boolean(propertyChanges))
         {
            if(this.property in propertyChanges.end && propertyChanges.start[this.property] != propertyChanges.end[this.property])
            {
               this.value = propertyChanges.end[this.property];
            }
         }
         if(this.value !== undefined)
         {
            this.setValue(this.property,this.value);
         }
         finishRepeat();
      }
      
      private function setValue(property:String, value:Object) : void
      {
         var currentVal:Object = null;
         var moduleFactory:IFlexModuleFactory = null;
         var isStyle:Boolean = false;
         var propName:String = property;
         var val:Object = value;
         if(property == "width" || property == "height")
         {
            if(value is String && value.indexOf("%") >= 0)
            {
               propName = property == "width" ? "percentWidth" : "percentHeight";
               val = val.slice(0,val.indexOf("%"));
            }
         }
         else
         {
            currentVal = this.getValue(propName);
            if(currentVal is Boolean)
            {
               if(val is String)
               {
                  val = value.toLowerCase() == "true";
               }
            }
            else if(currentVal is Number && propName.toLowerCase().indexOf("color") != -1)
            {
               moduleFactory = null;
               if(target is IFlexModule)
               {
                  moduleFactory = target.moduleFactory;
               }
               val = StyleManager.getStyleManager(moduleFactory).getColorName(value);
            }
         }
         if(propName in target)
         {
            target[propName] = val;
         }
         else
         {
            target.setStyle(propName,val);
         }
      }
      
      private function getValue(propName:String) : *
      {
         if(propName in target)
         {
            return target[propName];
         }
         return target.getStyle(propName);
      }
      
      override protected function saveStartValue() : *
      {
         if(this.property != null)
         {
            try
            {
               return this.getValue(this.property);
            }
            catch(e:Error)
            {
            }
         }
         return undefined;
      }
   }
}

