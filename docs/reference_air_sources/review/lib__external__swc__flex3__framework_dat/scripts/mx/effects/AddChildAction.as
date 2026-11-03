package mx.effects
{
   import flash.display.DisplayObjectContainer;
   import mx.core.mx_internal;
   import mx.effects.effectClasses.AddChildActionInstance;
   import mx.effects.effectClasses.PropertyChanges;
   
   use namespace mx_internal;
   
   [Exclude(name="duration",kind="property")]
   public class AddChildAction extends Effect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var AFFECTED_PROPERTIES:Array = ["parent","index"];
      
      private var localPropertyChanges:Array;
      
      [Inspectable(category="General")]
      public var relativeTo:DisplayObjectContainer;
      
      [Inspectable(category="General")]
      public var position:String = "index";
      
      [Inspectable(category="General")]
      public var index:int = -1;
      
      public function AddChildAction(target:Object = null)
      {
         super(target);
         instanceClass = AddChildActionInstance;
      }
      
      override public function createInstances(targets:Array = null) : Array
      {
         if(!targets)
         {
            targets = this.targets;
         }
         if(Boolean(targets) && Boolean(mx_internal::propertyChangesArray))
         {
            localPropertyChanges = mx_internal::propertyChangesArray;
            targets.sort(targetSortHandler);
         }
         return super.createInstances(targets);
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var actionInstance:AddChildActionInstance = AddChildActionInstance(instance);
         actionInstance.relativeTo = relativeTo;
         actionInstance.index = index;
         actionInstance.position = position;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override protected function applyValueToTarget(target:Object, property:String, value:*, props:Object) : void
      {
         if(Boolean(property == "parent") && Boolean(target.parent) && value == undefined)
         {
            target.parent.removeChild(target);
         }
      }
      
      override protected function getValueFromTarget(target:Object, property:String) : *
      {
         if(property == "index")
         {
            return Boolean(target.parent) ? target.parent.getChildIndex(target) : 0;
         }
         return super.getValueFromTarget(target,property);
      }
      
      private function getPropertyChanges(target:Object) : PropertyChanges
      {
         for(var i:int = 0; i < localPropertyChanges.length; i++)
         {
            if(localPropertyChanges[i].target == target)
            {
               return localPropertyChanges[i];
            }
         }
         return null;
      }
      
      private function targetSortHandler(first:Object, second:Object) : Number
      {
         var p1:PropertyChanges = getPropertyChanges(first);
         var p2:PropertyChanges = getPropertyChanges(second);
         if(Boolean(p1) && Boolean(p2))
         {
            if(p1.start.index > p2.start.index)
            {
               return 1;
            }
            if(p1.start.index < p2.start.index)
            {
               return -1;
            }
         }
         return 0;
      }
   }
}

