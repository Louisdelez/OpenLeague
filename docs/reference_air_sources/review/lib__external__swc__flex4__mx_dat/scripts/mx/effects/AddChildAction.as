package mx.effects
{
   import flash.display.DisplayObjectContainer;
   import mx.effects.effectClasses.AddChildActionInstance;
   import mx.effects.effectClasses.PropertyChanges;
   
   [Alternative(replacement="spark.effects.AddAction",since="4.0")]
   [Exclude(name="duration",kind="property")]
   public class AddChildAction extends Effect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["parent","index"];
      
      private var localPropertyChanges:Array;
      
      [Inspectable(category="General")]
      public var index:int = -1;
      
      [Inspectable(category="General")]
      public var relativeTo:DisplayObjectContainer;
      
      [Inspectable(category="General")]
      public var position:String = "index";
      
      public function AddChildAction(target:Object = null)
      {
         super(target);
         duration = 0;
         instanceClass = AddChildActionInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      private function getPropertyChanges(target:Object) : PropertyChanges
      {
         for(var i:int = 0; i < this.localPropertyChanges.length; i++)
         {
            if(this.localPropertyChanges[i].target == target)
            {
               return this.localPropertyChanges[i];
            }
         }
         return null;
      }
      
      private function targetSortHandler(first:Object, second:Object) : Number
      {
         var p1:PropertyChanges = this.getPropertyChanges(first);
         var p2:PropertyChanges = this.getPropertyChanges(second);
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
      
      override public function createInstances(targets:Array = null) : Array
      {
         if(!targets)
         {
            targets = this.targets;
         }
         if(Boolean(targets) && Boolean(propertyChangesArray))
         {
            this.localPropertyChanges = propertyChangesArray;
            targets.sort(this.targetSortHandler);
         }
         return super.createInstances(targets);
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var actionInstance:AddChildActionInstance = AddChildActionInstance(instance);
         actionInstance.relativeTo = this.relativeTo;
         actionInstance.index = this.index;
         actionInstance.position = this.position;
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
         if(Boolean(property == "parent") && Boolean(target.parent) && value == undefined)
         {
            target.parent.removeChild(target);
         }
      }
   }
}

