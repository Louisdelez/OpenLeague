package mx.effects
{
   import mx.effects.effectClasses.PropertyChanges;
   import mx.effects.effectClasses.RemoveChildActionInstance;
   
   [Alternative(replacement="spark.effects.RemoveAction",since="4.0")]
   [Exclude(name="duration",kind="property")]
   public class RemoveChildAction extends Effect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["parent","index"];
      
      public function RemoveChildAction(target:Object = null)
      {
         super(target);
         duration = 0;
         instanceClass = RemoveChildActionInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      private function propChangesSortHandler(first:PropertyChanges, second:PropertyChanges) : Number
      {
         if(first.start.index > second.start.index)
         {
            return 1;
         }
         if(first.start.index < second.start.index)
         {
            return -1;
         }
         return 0;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function applyStartValues(propChanges:Array, targets:Array) : void
      {
         if(Boolean(propChanges))
         {
            propChanges.sort(this.propChangesSortHandler);
         }
         super.applyStartValues(propChanges,targets);
      }
      
      override protected function getValueFromTarget(target:Object, property:String) : *
      {
         if(property == "index")
         {
            return Boolean(target.parent) ? target.parent.getChildIndex(target) : 0;
         }
         return super.getValueFromTarget(target,property);
      }
      
      override protected function applyValueToTarget(target:Object, property:String, value:*, props:Object) : void
      {
         if(property == "parent" && target.parent == null && Boolean(value))
         {
            value.addChildAt(target,Math.min(props.index,value.numChildren));
         }
      }
   }
}

