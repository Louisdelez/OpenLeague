package mx.effects.effectClasses
{
   public class SetPropertyActionInstance extends ActionEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var name:String;
      
      private var _value:*;
      
      public function SetPropertyActionInstance(target:Object)
      {
         super(target);
      }
      
      public function get value() : *
      {
         var val:* = undefined;
         if(playReversed)
         {
            val = getStartValue();
            if(val != undefined)
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
         var propName:String = null;
         var val:Object = null;
         super.play();
         if(this.value === undefined && Boolean(propertyChanges))
         {
            if(this.name in propertyChanges.end && propertyChanges.start[this.name] != propertyChanges.end[this.name])
            {
               this.value = propertyChanges.end[this.name];
            }
         }
         if(Boolean(target) && Boolean(this.name) && this.value !== undefined)
         {
            if(target[this.name] is Number)
            {
               propName = this.name;
               val = this.value;
               if(this.name == "width" || this.name == "height")
               {
                  if(val is String && val.indexOf("%") >= 0)
                  {
                     propName = this.name == "width" ? "percentWidth" : "percentHeight";
                     val = val.slice(0,val.indexOf("%"));
                  }
               }
               target[propName] = Number(val);
            }
            else if(target[this.name] is Boolean)
            {
               if(this.value is String)
               {
                  target[this.name] = this.value.toLowerCase() == "true";
               }
               else
               {
                  target[this.name] = this.value;
               }
            }
            else
            {
               target[this.name] = this.value;
            }
         }
         finishRepeat();
      }
      
      override protected function saveStartValue() : *
      {
         if(this.name != null)
         {
            try
            {
               return target[this.name];
            }
            catch(e:Error)
            {
            }
         }
         return undefined;
      }
   }
}

