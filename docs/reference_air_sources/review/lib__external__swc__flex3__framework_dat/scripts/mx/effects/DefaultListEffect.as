package mx.effects
{
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   [Exclude(name="customFilter",kind="property")]
   [Exclude(name="repeatDelay",kind="property")]
   [Exclude(name="repeatCount",kind="property")]
   [Exclude(name="targets",kind="property")]
   [Exclude(name="target",kind="property")]
   [Exclude(name="dissolve1",kind="property")]
   [Exclude(name="wipeUp1",kind="property")]
   [Exclude(name="shrink",kind="property")]
   [Exclude(name="grow",kind="property")]
   [Exclude(name="fadeOut2",kind="property")]
   [Exclude(name="fadeOut1",kind="property")]
   [Exclude(name="fadeIn2",kind="property")]
   [Exclude(name="fadeIn1",kind="property")]
   [Exclude(name="children",kind="property")]
   [Exclude(name="filter",kind="property")]
   [Exclude(name="perElementOffset",kind="property")]
   [Exclude(name="effectTargetHost",kind="property")]
   [Exclude(name="duration",kind="property")]
   public class DefaultListEffect extends Parallel
   {
      
      private var _removedElementOffset:Number = 60;
      
      private var _3181587grow:Parallel;
      
      private var _fadeInDuration:Number = 300;
      
      private var _growDuration:Number = 300;
      
      private var _fadeOutDuration:Number = 300;
      
      private var _1091442799fadeIn2:Dissolve;
      
      private var _shrinkDuration:Number = 300;
      
      private var _color:uint = 16777215;
      
      private var _903068151shrink:Parallel;
      
      private var _336576992dissolve1:Dissolve;
      
      private var _1351344943wipeUp1:WipeUp;
      
      private var _1091442800fadeIn1:Dissolve;
      
      private var _525199167fadeOut1:Dissolve;
      
      private var _525199168fadeOut2:Dissolve;
      
      public function DefaultListEffect()
      {
         super();
         this.children = [_DefaultListEffect_Sequence1_c(),_DefaultListEffect_Sequence2_c(),_DefaultListEffect_Sequence3_c()];
      }
      
      private function _DefaultListEffect_Sequence3_c() : Sequence
      {
         var temp:Sequence = new Sequence();
         temp.children = [_DefaultListEffect_Dissolve4_i(),_DefaultListEffect_RemoveItemAction2_c(),_DefaultListEffect_AddItemAction2_c(),_DefaultListEffect_Dissolve5_i()];
         return temp;
      }
      
      private function _DefaultListEffect_AddItemAction2_c() : AddItemAction
      {
         var temp:AddItemAction = new AddItemAction();
         temp.filter = "replacementItem";
         return temp;
      }
      
      public function set fadeOut2(param1:Dissolve) : void
      {
         var _loc2_:Object = this._525199168fadeOut2;
         if(_loc2_ !== param1)
         {
            this._525199168fadeOut2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeOut2",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get shrink() : Parallel
      {
         return this._903068151shrink;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn1() : Dissolve
      {
         return this._1091442800fadeIn1;
      }
      
      public function set shrink(param1:Parallel) : void
      {
         var _loc2_:Object = this._903068151shrink;
         if(_loc2_ !== param1)
         {
            this._903068151shrink = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shrink",_loc2_,param1));
         }
      }
      
      private function _DefaultListEffect_Resize1_c() : Resize
      {
         var temp:Resize = new Resize();
         temp.heightTo = 0;
         return temp;
      }
      
      public function set growDuration(value:Number) : void
      {
         _growDuration = value;
         grow.duration = value;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn2() : Dissolve
      {
         return this._1091442799fadeIn2;
      }
      
      [Bindable(event="propertyChange")]
      public function get grow() : Parallel
      {
         return this._3181587grow;
      }
      
      private function _DefaultListEffect_RemoveItemAction2_c() : RemoveItemAction
      {
         var temp:RemoveItemAction = new RemoveItemAction();
         temp.filter = "replacedItem";
         return temp;
      }
      
      private function _DefaultListEffect_WipeDown1_c() : WipeDown
      {
         return new WipeDown();
      }
      
      public function set fadeIn1(param1:Dissolve) : void
      {
         var _loc2_:Object = this._1091442800fadeIn1;
         if(_loc2_ !== param1)
         {
            this._1091442800fadeIn1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn1",_loc2_,param1));
         }
      }
      
      private function _DefaultListEffect_Resize3_c() : Resize
      {
         var temp:Resize = new Resize();
         temp.heightFrom = 0;
         return temp;
      }
      
      public function set fadeIn2(param1:Dissolve) : void
      {
         var _loc2_:Object = this._1091442799fadeIn2;
         if(_loc2_ !== param1)
         {
            this._1091442799fadeIn2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn2",_loc2_,param1));
         }
      }
      
      public function set grow(param1:Parallel) : void
      {
         var _loc2_:Object = this._3181587grow;
         if(_loc2_ !== param1)
         {
            this._3181587grow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"grow",_loc2_,param1));
         }
      }
      
      private function _DefaultListEffect_Parallel2_i() : Parallel
      {
         var temp:Parallel = new Parallel();
         shrink = temp;
         temp.duration = 300;
         temp.children = [_DefaultListEffect_Resize1_c(),_DefaultListEffect_WipeUp1_i()];
         return temp;
      }
      
      [Inspectable(category="General",defaultValue="100")]
      public function get removedElementOffset() : Number
      {
         return _removedElementOffset;
      }
      
      private function _DefaultListEffect_AddItemAction1_c() : AddItemAction
      {
         return new AddItemAction();
      }
      
      private function _DefaultListEffect_Dissolve1_i() : Dissolve
      {
         var temp:Dissolve = new Dissolve();
         fadeOut1 = temp;
         temp.alphaFrom = 1;
         temp.alphaTo = 0;
         temp.duration = 300;
         temp.color = 16777215;
         temp.perElementOffset = 60;
         return temp;
      }
      
      [Inspectable(category="General",defaultValue="300")]
      public function get shrinkDuration() : Number
      {
         return _shrinkDuration;
      }
      
      private function _DefaultListEffect_Dissolve3_i() : Dissolve
      {
         var temp:Dissolve = new Dissolve();
         fadeIn1 = temp;
         temp.alphaFrom = 0;
         temp.alphaTo = 1;
         temp.duration = 300;
         return temp;
      }
      
      private function _DefaultListEffect_Sequence2_c() : Sequence
      {
         var temp:Sequence = new Sequence();
         temp.filter = "addItem";
         temp.suspendBackgroundProcessing = true;
         temp.children = [_DefaultListEffect_Dissolve2_i(),_DefaultListEffect_AddItemAction1_c(),_DefaultListEffect_Parallel3_i(),_DefaultListEffect_Dissolve3_i()];
         return temp;
      }
      
      private function _DefaultListEffect_Dissolve5_i() : Dissolve
      {
         var temp:Dissolve = new Dissolve();
         fadeIn2 = temp;
         temp.alphaTo = 1;
         temp.duration = 300;
         temp.color = 16777215;
         temp.filter = "replacementItem";
         return temp;
      }
      
      public function set color(value:Number) : void
      {
         _color = value;
         fadeOut1.color = value;
         fadeOut2.color = value;
         fadeIn1.color = value;
         fadeIn2.color = value;
         dissolve1.color = value;
      }
      
      [Inspectable(category="General",defaultValue="300")]
      public function get growDuration() : Number
      {
         return _growDuration;
      }
      
      private function _DefaultListEffect_WipeUp1_i() : WipeUp
      {
         var temp:WipeUp = new WipeUp();
         wipeUp1 = temp;
         temp.showTarget = false;
         return temp;
      }
      
      public function set dissolve1(param1:Dissolve) : void
      {
         var _loc2_:Object = this._336576992dissolve1;
         if(_loc2_ !== param1)
         {
            this._336576992dissolve1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dissolve1",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get wipeUp1() : WipeUp
      {
         return this._1351344943wipeUp1;
      }
      
      public function set fadeOutDuration(value:Number) : void
      {
         _fadeOutDuration = value;
         fadeOut1.duration = value;
         fadeOut2.duration = value;
      }
      
      private function _DefaultListEffect_Resize2_c() : Resize
      {
         var temp:Resize = new Resize();
         temp.duration = 1;
         return temp;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeOut1() : Dissolve
      {
         return this._525199167fadeOut1;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeOut2() : Dissolve
      {
         return this._525199168fadeOut2;
      }
      
      public function set removedElementOffset(value:Number) : void
      {
         _removedElementOffset = value;
         fadeOut1.perElementOffset = value;
      }
      
      [Bindable(event="propertyChange")]
      public function get dissolve1() : Dissolve
      {
         return this._336576992dissolve1;
      }
      
      private function _DefaultListEffect_RemoveItemAction1_c() : RemoveItemAction
      {
         return new RemoveItemAction();
      }
      
      override public function createInstances(targets:Array = null) : Array
      {
         fadeOut1.mx_internal::persistAfterEnd = true;
         wipeUp1.mx_internal::persistAfterEnd = true;
         dissolve1.mx_internal::persistAfterEnd = true;
         return super.createInstances(targets);
      }
      
      [Inspectable(category="General",format="Color",defaultValue="0xFFFFFF")]
      public function get color() : Number
      {
         return _color;
      }
      
      public function set wipeUp1(param1:WipeUp) : void
      {
         var _loc2_:Object = this._1351344943wipeUp1;
         if(_loc2_ !== param1)
         {
            this._1351344943wipeUp1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wipeUp1",_loc2_,param1));
         }
      }
      
      private function _DefaultListEffect_Sequence1_c() : Sequence
      {
         var temp:Sequence = new Sequence();
         temp.filter = "removeItem";
         temp.children = [_DefaultListEffect_Dissolve1_i(),_DefaultListEffect_Parallel2_i(),_DefaultListEffect_RemoveItemAction1_c(),_DefaultListEffect_Resize2_c()];
         return temp;
      }
      
      public function set fadeInDuration(value:Number) : void
      {
         _fadeInDuration = value;
         fadeIn1.duration = value;
         fadeIn2.duration = value;
      }
      
      [Inspectable(category="General",defaultValue="300")]
      public function get fadeOutDuration() : Number
      {
         return _fadeOutDuration;
      }
      
      private function _DefaultListEffect_Parallel3_i() : Parallel
      {
         var temp:Parallel = new Parallel();
         grow = temp;
         temp.duration = 300;
         temp.children = [_DefaultListEffect_WipeDown1_c(),_DefaultListEffect_Resize3_c()];
         return temp;
      }
      
      public function set shrinkDuration(value:Number) : void
      {
         _shrinkDuration = value;
         shrink.duration = value;
      }
      
      [Inspectable(category="General",defaultValue="300")]
      public function get fadeInDuration() : Number
      {
         return _fadeInDuration;
      }
      
      private function _DefaultListEffect_Dissolve2_i() : Dissolve
      {
         var temp:Dissolve = new Dissolve();
         dissolve1 = temp;
         temp.alphaTo = 0;
         temp.duration = 1;
         temp.color = 16777215;
         return temp;
      }
      
      public function set fadeOut1(param1:Dissolve) : void
      {
         var _loc2_:Object = this._525199167fadeOut1;
         if(_loc2_ !== param1)
         {
            this._525199167fadeOut1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeOut1",_loc2_,param1));
         }
      }
      
      private function _DefaultListEffect_Dissolve4_i() : Dissolve
      {
         var temp:Dissolve = new Dissolve();
         fadeOut2 = temp;
         temp.alphaTo = 0;
         temp.duration = 300;
         temp.color = 16777215;
         temp.filter = "replacedItem";
         return temp;
      }
   }
}

