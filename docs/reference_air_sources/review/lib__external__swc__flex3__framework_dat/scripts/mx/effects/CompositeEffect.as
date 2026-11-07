package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.CompositeEffectInstance;
   import mx.effects.effectClasses.PropertyChanges;
   
   use namespace mx_internal;
   
   [DefaultProperty("children")]
   public class CompositeEffect extends Effect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _affectedProperties:Array;
      
      private var childTargets:Array;
      
      [Inspectable(category="General",arrayType="mx.effects.Effect")]
      public var children:Array = [];
      
      public function CompositeEffect(target:Object = null)
      {
         super(target);
         instanceClass = CompositeEffectInstance;
      }
      
      override public function createInstances(targets:Array = null) : Array
      {
         if(!targets)
         {
            targets = this.targets;
         }
         childTargets = targets;
         var newInstance:IEffectInstance = createInstance();
         childTargets = null;
         return Boolean(newInstance) ? [newInstance] : [];
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var n:int = 0;
         var i:int = 0;
         var childEffect:Effect = null;
         super.initInstance(instance);
         var compInst:CompositeEffectInstance = CompositeEffectInstance(instance);
         var targets:Object = childTargets;
         if(!(targets is Array))
         {
            targets = [targets];
         }
         if(Boolean(children))
         {
            n = int(children.length);
            for(i = 0; i < n; i++)
            {
               childEffect = children[i];
               if(propertyChangesArray != null)
               {
                  childEffect.propertyChangesArray = propertyChangesArray;
               }
               if(childEffect.filterObject == null && Boolean(filterObject))
               {
                  childEffect.filterObject = filterObject;
               }
               if(Boolean(effectTargetHost))
               {
                  childEffect.effectTargetHost = effectTargetHost;
               }
               if(childEffect.targets.length == 0)
               {
                  compInst.addChildSet(children[i].createInstances(targets));
               }
               else
               {
                  compInst.addChildSet(children[i].createInstances(childEffect.targets));
               }
            }
         }
      }
      
      override mx_internal function captureValues(propChanges:Array, setStartValues:Boolean) : Array
      {
         var child:Effect = null;
         var n:int = int(children.length);
         for(var i:int = 0; i < n; i++)
         {
            child = children[i];
            propChanges = child.captureValues(propChanges,setStartValues);
         }
         return propChanges;
      }
      
      public function addChild(childEffect:IEffect) : void
      {
         children.push(childEffect);
         _affectedProperties = null;
      }
      
      override mx_internal function applyStartValues(propChanges:Array, targets:Array) : void
      {
         var child:Effect = null;
         var childTargets:Array = null;
         var n:int = int(children.length);
         for(var i:int = 0; i < n; i++)
         {
            child = children[i];
            childTargets = child.targets.length > 0 ? child.targets : targets;
            if(child.filterObject == null && Boolean(filterObject))
            {
               child.filterObject = filterObject;
            }
            child.applyStartValues(propChanges,childTargets);
         }
      }
      
      override public function createInstance(target:Object = null) : IEffectInstance
      {
         if(!childTargets)
         {
            childTargets = [target];
         }
         var newInstance:IEffectInstance = super.createInstance(target);
         childTargets = null;
         return newInstance;
      }
      
      override protected function filterInstance(propChanges:Array, targ:Object) : Boolean
      {
         var targs:Array = null;
         var n:int = 0;
         var i:int = 0;
         if(Boolean(filterObject))
         {
            targs = targets;
            if(targs.length == 0)
            {
               targs = childTargets;
            }
            n = int(targs.length);
            for(i = 0; i < n; i++)
            {
               if(filterObject.filterInstance(propChanges,effectTargetHost,targs[i]))
               {
                  return true;
               }
            }
            return false;
         }
         return true;
      }
      
      override public function captureStartValues() : void
      {
         var childTargets:Array = getChildrenTargets();
         propertyChangesArray = [];
         var n:int = int(childTargets.length);
         for(var i:int = 0; i < n; i++)
         {
            propertyChangesArray.push(new PropertyChanges(childTargets[i]));
         }
         propertyChangesArray = captureValues(propertyChangesArray,true);
         endValuesCaptured = false;
      }
      
      private function getChildrenTargets() : Array
      {
         var childTargets:Array = null;
         var child:Effect = null;
         var n:int = 0;
         var i:int = 0;
         var m:int = 0;
         var j:int = 0;
         var p:String = null;
         var resultsArray:Array = [];
         var results:Object = {};
         n = int(children.length);
         for(i = 0; i < n; i++)
         {
            child = children[i];
            if(child is CompositeEffect)
            {
               childTargets = CompositeEffect(child).getChildrenTargets();
               m = int(childTargets.length);
               for(j = 0; j < m; j++)
               {
                  if(childTargets[j] != null)
                  {
                     results[childTargets[j].toString()] = childTargets[j];
                  }
               }
            }
            else if(child.targets != null)
            {
               m = int(child.targets.length);
               for(j = 0; j < m; j++)
               {
                  if(child.targets[j] != null)
                  {
                     results[child.targets[j].toString()] = child.targets[j];
                  }
               }
            }
         }
         n = int(targets.length);
         for(i = 0; i < n; i++)
         {
            if(targets[i] != null)
            {
               results[targets[i].toString()] = targets[i];
            }
         }
         for(p in results)
         {
            resultsArray.push(results[p]);
         }
         return resultsArray;
      }
      
      override public function getAffectedProperties() : Array
      {
         var arr:Array = null;
         var n:int = 0;
         var i:int = 0;
         if(!_affectedProperties)
         {
            arr = [];
            n = int(children.length);
            for(i = 0; i < n; i++)
            {
               arr = arr.concat(children[i].getAffectedProperties());
            }
            _affectedProperties = arr;
         }
         return _affectedProperties;
      }
   }
}

