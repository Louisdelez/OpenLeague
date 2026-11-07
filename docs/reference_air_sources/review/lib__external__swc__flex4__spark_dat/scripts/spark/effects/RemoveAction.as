package spark.effects
{
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.effects.Effect;
   import mx.effects.effectClasses.PropertyChanges;
   import spark.effects.supportClasses.RemoveActionInstance;
   
   [Exclude(name="duration",kind="property")]
   public class RemoveAction extends Effect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["parent","index"];
      
      public function RemoveAction(target:Object = null)
      {
         super(target);
         duration = 0;
         instanceClass = RemoveActionInstance;
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
         var container:* = target.parent;
         if(property == "index")
         {
            return Boolean(container) ? (container is IVisualElementContainer ? IVisualElementContainer(container).getElementIndex(target as IVisualElement) : container.getChildIndex(target)) : 0;
         }
         return super.getValueFromTarget(target,property);
      }
      
      override protected function applyValueToTarget(target:Object, property:String, value:*, props:Object) : void
      {
         if(property == "parent" && Boolean(value))
         {
            if(target.parent == null)
            {
               if(value is IVisualElementContainer)
               {
                  IVisualElementContainer(value).addElementAt(target as IVisualElement,Math.min(props.index,IVisualElementContainer(value).numElements));
               }
               else
               {
                  value.addChildAt(target,Math.min(props.index,value.numChildren));
               }
            }
         }
      }
   }
}

