package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.CompositeEffectInstance;
   import mx.effects.effectClasses.PropertyChanges;
   
   use namespace mx_internal;
   
   [DefaultProperty("children")]
   public class CompositeEffect extends Effect
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var childTargets:Array;
      
      private var _affectedProperties:Array;
      
      [Inspectable(category="General",arrayType="mx.effects.Effect")]
      private var _children:Array = [];
      
      public function CompositeEffect(target:Object = null)
      {
         super(target);
         instanceClass = CompositeEffectInstance;
      }
      
      public function get children() : Array
      {
         return this._children;
      }
      
      public function set children(value:Array) : void
      {
         var i:int = 0;
         if(Boolean(this._children))
         {
            for(i = 0; i < this._children.length; i++)
            {
               if(Boolean(this._children[i]))
               {
                  Effect(this._children[i]).parentCompositeEffect = null;
               }
            }
         }
         this._children = value;
         if(Boolean(this._children))
         {
            for(i = 0; i < this._children.length; i++)
            {
               if(Boolean(this._children[i]))
               {
                  Effect(this._children[i]).parentCompositeEffect = this;
               }
            }
         }
      }
      
      public function get compositeDuration() : Number
      {
         return duration;
      }
      
      override public function getAffectedProperties() : Array
      {
         var arr:Array = null;
         var n:int = 0;
         var i:int = 0;
         if(!this._affectedProperties)
         {
            arr = [];
            n = int(this.children.length);
            for(i = 0; i < n; i++)
            {
               arr = arr.concat(this.children[i].getAffectedProperties());
            }
            this._affectedProperties = arr;
         }
         return this._affectedProperties;
      }
      
      override public function createInstance(target:Object = null) : IEffectInstance
      {
         if(!this.childTargets)
         {
            this.childTargets = [target];
         }
         var newInstance:IEffectInstance = super.createInstance(target);
         this.childTargets = null;
         return newInstance;
      }
      
      override public function createInstances(targets:Array = null) : Array
      {
         if(!targets)
         {
            targets = this.targets;
         }
         this.childTargets = targets;
         var newInstance:IEffectInstance = this.createInstance();
         this.childTargets = null;
         return Boolean(newInstance) ? [newInstance] : [];
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
               targs = this.childTargets;
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
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var n:int = 0;
         var i:int = 0;
         var childEffect:Effect = null;
         super.initInstance(instance);
         var compInst:CompositeEffectInstance = CompositeEffectInstance(instance);
         var targets:Object = this.childTargets;
         if(!(targets is Array))
         {
            targets = [targets];
         }
         if(Boolean(this.children))
         {
            n = int(this.children.length);
            for(i = 0; i < n; i++)
            {
               childEffect = this.children[i];
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
                  compInst.addChildSet(this.children[i].createInstances(targets));
               }
               else
               {
                  compInst.addChildSet(this.children[i].createInstances(childEffect.targets));
               }
            }
         }
      }
      
      override public function captureStartValues() : void
      {
         var childTargets:Array = this.getChildrenTargets();
         propertyChangesArray = [];
         var n:int = int(childTargets.length);
         for(var i:int = 0; i < n; i++)
         {
            propertyChangesArray.push(new PropertyChanges(childTargets[i]));
         }
         propertyChangesArray = this.captureValues(propertyChangesArray,true);
         endValuesCaptured = false;
      }
      
      override mx_internal function captureValues(propChanges:Array, setStartValues:Boolean, targetsToCapture:Array = null) : Array
      {
         var child:Effect = null;
         var n:int = int(this.children.length);
         for(var i:int = 0; i < n; i++)
         {
            child = this.children[i];
            propChanges = child.captureValues(propChanges,setStartValues,Boolean(child.targets) && child.targets.length > 0 ? child.targets : targetsToCapture);
         }
         return propChanges;
      }
      
      override mx_internal function applyStartValues(propChanges:Array, targets:Array) : void
      {
         var child:Effect = null;
         var childTargets:Array = null;
         var n:int = int(this.children.length);
         for(var i:int = 0; i < n; i++)
         {
            child = this.children[i];
            childTargets = child.targets.length > 0 ? child.targets : targets;
            if(child.filterObject == null && Boolean(filterObject))
            {
               child.filterObject = filterObject;
            }
            child.applyStartValues(propChanges,childTargets);
         }
      }
      
      override mx_internal function applyEndValues(propChanges:Array, targets:Array) : void
      {
         var child:Effect = null;
         var childTargets:Array = null;
         var n:int = int(this.children.length);
         for(var i:int = 0; i < n; i++)
         {
            child = this.children[i];
            childTargets = child.targets.length > 0 ? child.targets : targets;
            if(child.filterObject == null && Boolean(filterObject))
            {
               child.filterObject = filterObject;
            }
            child.applyEndValues(propChanges,childTargets);
         }
      }
      
      override mx_internal function set transitionInterruption(value:Boolean) : void
      {
         var child:Effect = null;
         super.mx_internal::transitionInterruption = value;
         var n:int = int(this.children.length);
         for(var i:int = 0; i < n; i++)
         {
            child = this.children[i];
            child.transitionInterruption = value;
         }
      }
      
      public function addChild(childEffect:IEffect) : void
      {
         this.children.push(childEffect);
         this._affectedProperties = null;
         Effect(childEffect).parentCompositeEffect = this;
      }
      
      private function getChildrenTargets() : Array
      {
         var childTargets:Array = null;
         var child:Effect = null;
         var n:int = 0;
         var i:int = 0;
         var m:int = 0;
         var j:int = 0;
         var resultsArray:Array = [];
         var results:Object = {};
         n = int(this.children.length);
         for(i = 0; i < n; i++)
         {
            child = this.children[i];
            if(child is CompositeEffect)
            {
               childTargets = CompositeEffect(child).getChildrenTargets();
               m = int(childTargets.length);
               for(j = 0; j < m; j++)
               {
                  if(childTargets[j] != null && resultsArray.indexOf(childTargets[j]) < 0)
                  {
                     resultsArray.push(childTargets[j]);
                  }
               }
            }
            else if(child.targets != null)
            {
               m = int(child.targets.length);
               for(j = 0; j < m; j++)
               {
                  if(child.targets[j] != null && resultsArray.indexOf(child.targets[j]) < 0)
                  {
                     resultsArray.push(child.targets[j]);
                  }
               }
            }
         }
         n = int(targets.length);
         for(i = 0; i < n; i++)
         {
            if(targets[i] != null && resultsArray.indexOf(targets[i]) < 0)
            {
               resultsArray.push(targets[i]);
            }
         }
         return resultsArray;
      }
   }
}

