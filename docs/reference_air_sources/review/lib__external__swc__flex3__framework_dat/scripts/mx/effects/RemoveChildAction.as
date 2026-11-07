package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.PropertyChanges;
   import mx.effects.effectClasses.RemoveChildActionInstance;
   
   use namespace mx_internal;
   
   [Exclude(name="duration",kind="property")]
   public class RemoveChildAction extends Effect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var AFFECTED_PROPERTIES:Array = ["parent","index"];
      
      public function RemoveChildAction(target:Object = null)
      {
         super(target);
         instanceClass = RemoveChildActionInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override protected function getValueFromTarget(target:Object, property:String) : *
      {
         if(property == "index")
         {
            return Boolean(target.parent) ? target.parent.getChildIndex(target) : 0;
         }
         return super.getValueFromTarget(target,property);
      }
      
      override mx_internal function applyStartValues(propChanges:Array, targets:Array) : void
      {
         if(Boolean(propChanges))
         {
            propChanges.sort(propChangesSortHandler);
         }
         super.mx_internal::applyStartValues(propChanges,targets);
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
      
      override protected function applyValueToTarget(target:Object, property:String, value:*, props:Object) : void
      {
         if(property == "parent" && target.parent == null && Boolean(value))
         {
            value.addChildAt(target,Math.min(props.index,value.numChildren));
         }
      }
   }
}

