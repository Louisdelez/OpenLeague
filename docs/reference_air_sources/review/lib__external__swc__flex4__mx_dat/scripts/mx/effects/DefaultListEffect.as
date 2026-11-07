package mx.effects
{
   import mx.binding.BindingManager;
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
      
      private var _336576992dissolve1:Dissolve;
      
      private var _1091442800fadeIn1:Dissolve;
      
      private var _1091442799fadeIn2:Dissolve;
      
      private var _525199167fadeOut1:Dissolve;
      
      private var _525199168fadeOut2:Dissolve;
      
      private var _3181587grow:Parallel;
      
      private var _903068151shrink:Parallel;
      
      private var _1351344943wipeUp1:WipeUp;
      
      private var _fadeOutDuration:Number = 300;
      
      private var _fadeInDuration:Number = 300;
      
      private var _shrinkDuration:Number = 300;
      
      private var _growDuration:Number = 300;
      
      private var _removedElementOffset:Number = 60;
      
      private var _color:uint = 16777215;
      
      public function DefaultListEffect()
      {
         super();
         this.children = [this._DefaultListEffect_Sequence1_c(),this._DefaultListEffect_Sequence2_c(),this._DefaultListEffect_Sequence3_c()];
      }
      
      [Inspectable(category="General",defaultValue="300")]
      public function get fadeOutDuration() : Number
      {
         return this._fadeOutDuration;
      }
      
      public function set fadeOutDuration(value:Number) : void
      {
         this._fadeOutDuration = value;
         this.fadeOut1.duration = value;
         this.fadeOut2.duration = value;
      }
      
      [Inspectable(category="General",defaultValue="300")]
      public function get fadeInDuration() : Number
      {
         return this._fadeInDuration;
      }
      
      public function set fadeInDuration(value:Number) : void
      {
         this._fadeInDuration = value;
         this.fadeIn1.duration = value;
         this.fadeIn2.duration = value;
      }
      
      [Inspectable(category="General",defaultValue="300")]
      public function get shrinkDuration() : Number
      {
         return this._shrinkDuration;
      }
      
      public function set shrinkDuration(value:Number) : void
      {
         this._shrinkDuration = value;
         this.shrink.duration = value;
      }
      
      [Inspectable(category="General",defaultValue="300")]
      public function get growDuration() : Number
      {
         return this._growDuration;
      }
      
      public function set growDuration(value:Number) : void
      {
         this._growDuration = value;
         this.grow.duration = value;
      }
      
      [Inspectable(category="General",defaultValue="100")]
      public function get removedElementOffset() : Number
      {
         return this._removedElementOffset;
      }
      
      public function set removedElementOffset(value:Number) : void
      {
         this._removedElementOffset = value;
         this.fadeOut1.perElementOffset = value;
      }
      
      [Inspectable(category="General",format="Color",defaultValue="0xFFFFFF")]
      public function get color() : Number
      {
         return this._color;
      }
      
      public function set color(value:Number) : void
      {
         this._color = value;
         this.fadeOut1.color = value;
         this.fadeOut2.color = value;
         this.fadeIn1.color = value;
         this.fadeIn2.color = value;
         this.dissolve1.color = value;
      }
      
      override public function createInstances(targets:Array = null) : Array
      {
         this.fadeOut1.mx_internal::persistAfterEnd = true;
         this.wipeUp1.mx_internal::persistAfterEnd = true;
         this.dissolve1.mx_internal::persistAfterEnd = true;
         return super.createInstances(targets);
      }
      
      private function _DefaultListEffect_Sequence1_c() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         _loc1_.filter = "removeItem";
         _loc1_.children = [this._DefaultListEffect_Dissolve1_i(),this._DefaultListEffect_Parallel2_i(),this._DefaultListEffect_RemoveItemAction1_c(),this._DefaultListEffect_Resize2_c()];
         return _loc1_;
      }
      
      private function _DefaultListEffect_Dissolve1_i() : Dissolve
      {
         var _loc1_:Dissolve = new Dissolve();
         _loc1_.alphaFrom = 1;
         _loc1_.alphaTo = 0;
         _loc1_.duration = 300;
         _loc1_.color = 16777215;
         _loc1_.perElementOffset = 60;
         this.fadeOut1 = _loc1_;
         BindingManager.executeBindings(this,"fadeOut1",this.fadeOut1);
         return _loc1_;
      }
      
      private function _DefaultListEffect_Parallel2_i() : Parallel
      {
         var _loc1_:Parallel = new Parallel();
         _loc1_.duration = 300;
         _loc1_.children = [this._DefaultListEffect_Resize1_c(),this._DefaultListEffect_WipeUp1_i()];
         this.shrink = _loc1_;
         BindingManager.executeBindings(this,"shrink",this.shrink);
         return _loc1_;
      }
      
      private function _DefaultListEffect_Resize1_c() : Resize
      {
         var _loc1_:Resize = new Resize();
         _loc1_.heightTo = 0;
         return _loc1_;
      }
      
      private function _DefaultListEffect_WipeUp1_i() : WipeUp
      {
         var _loc1_:WipeUp = new WipeUp();
         _loc1_.showTarget = false;
         this.wipeUp1 = _loc1_;
         BindingManager.executeBindings(this,"wipeUp1",this.wipeUp1);
         return _loc1_;
      }
      
      private function _DefaultListEffect_RemoveItemAction1_c() : RemoveItemAction
      {
         return new RemoveItemAction();
      }
      
      private function _DefaultListEffect_Resize2_c() : Resize
      {
         var _loc1_:Resize = new Resize();
         _loc1_.duration = 1;
         return _loc1_;
      }
      
      private function _DefaultListEffect_Sequence2_c() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         _loc1_.filter = "addItem";
         _loc1_.suspendBackgroundProcessing = true;
         _loc1_.children = [this._DefaultListEffect_Dissolve2_i(),this._DefaultListEffect_AddItemAction1_c(),this._DefaultListEffect_Parallel3_i(),this._DefaultListEffect_Dissolve3_i()];
         return _loc1_;
      }
      
      private function _DefaultListEffect_Dissolve2_i() : Dissolve
      {
         var _loc1_:Dissolve = new Dissolve();
         _loc1_.alphaTo = 0;
         _loc1_.duration = 1;
         _loc1_.color = 16777215;
         this.dissolve1 = _loc1_;
         BindingManager.executeBindings(this,"dissolve1",this.dissolve1);
         return _loc1_;
      }
      
      private function _DefaultListEffect_AddItemAction1_c() : AddItemAction
      {
         return new AddItemAction();
      }
      
      private function _DefaultListEffect_Parallel3_i() : Parallel
      {
         var _loc1_:Parallel = new Parallel();
         _loc1_.duration = 300;
         _loc1_.children = [this._DefaultListEffect_WipeDown1_c(),this._DefaultListEffect_Resize3_c()];
         this.grow = _loc1_;
         BindingManager.executeBindings(this,"grow",this.grow);
         return _loc1_;
      }
      
      private function _DefaultListEffect_WipeDown1_c() : WipeDown
      {
         return new WipeDown();
      }
      
      private function _DefaultListEffect_Resize3_c() : Resize
      {
         var _loc1_:Resize = new Resize();
         _loc1_.heightFrom = 0;
         return _loc1_;
      }
      
      private function _DefaultListEffect_Dissolve3_i() : Dissolve
      {
         var _loc1_:Dissolve = new Dissolve();
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.duration = 300;
         this.fadeIn1 = _loc1_;
         BindingManager.executeBindings(this,"fadeIn1",this.fadeIn1);
         return _loc1_;
      }
      
      private function _DefaultListEffect_Sequence3_c() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         _loc1_.children = [this._DefaultListEffect_Dissolve4_i(),this._DefaultListEffect_RemoveItemAction2_c(),this._DefaultListEffect_AddItemAction2_c(),this._DefaultListEffect_Dissolve5_i()];
         return _loc1_;
      }
      
      private function _DefaultListEffect_Dissolve4_i() : Dissolve
      {
         var _loc1_:Dissolve = new Dissolve();
         _loc1_.alphaTo = 0;
         _loc1_.duration = 300;
         _loc1_.color = 16777215;
         _loc1_.filter = "replacedItem";
         this.fadeOut2 = _loc1_;
         BindingManager.executeBindings(this,"fadeOut2",this.fadeOut2);
         return _loc1_;
      }
      
      private function _DefaultListEffect_RemoveItemAction2_c() : RemoveItemAction
      {
         var _loc1_:RemoveItemAction = new RemoveItemAction();
         _loc1_.filter = "replacedItem";
         return _loc1_;
      }
      
      private function _DefaultListEffect_AddItemAction2_c() : AddItemAction
      {
         var _loc1_:AddItemAction = new AddItemAction();
         _loc1_.filter = "replacementItem";
         return _loc1_;
      }
      
      private function _DefaultListEffect_Dissolve5_i() : Dissolve
      {
         var _loc1_:Dissolve = new Dissolve();
         _loc1_.alphaTo = 1;
         _loc1_.duration = 300;
         _loc1_.color = 16777215;
         _loc1_.filter = "replacementItem";
         this.fadeIn2 = _loc1_;
         BindingManager.executeBindings(this,"fadeIn2",this.fadeIn2);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get dissolve1() : Dissolve
      {
         return this._336576992dissolve1;
      }
      
      public function set dissolve1(param1:Dissolve) : void
      {
         var _loc2_:Object = this._336576992dissolve1;
         if(_loc2_ !== param1)
         {
            this._336576992dissolve1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dissolve1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn1() : Dissolve
      {
         return this._1091442800fadeIn1;
      }
      
      public function set fadeIn1(param1:Dissolve) : void
      {
         var _loc2_:Object = this._1091442800fadeIn1;
         if(_loc2_ !== param1)
         {
            this._1091442800fadeIn1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn2() : Dissolve
      {
         return this._1091442799fadeIn2;
      }
      
      public function set fadeIn2(param1:Dissolve) : void
      {
         var _loc2_:Object = this._1091442799fadeIn2;
         if(_loc2_ !== param1)
         {
            this._1091442799fadeIn2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeOut1() : Dissolve
      {
         return this._525199167fadeOut1;
      }
      
      public function set fadeOut1(param1:Dissolve) : void
      {
         var _loc2_:Object = this._525199167fadeOut1;
         if(_loc2_ !== param1)
         {
            this._525199167fadeOut1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeOut1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeOut2() : Dissolve
      {
         return this._525199168fadeOut2;
      }
      
      public function set fadeOut2(param1:Dissolve) : void
      {
         var _loc2_:Object = this._525199168fadeOut2;
         if(_loc2_ !== param1)
         {
            this._525199168fadeOut2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeOut2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get grow() : Parallel
      {
         return this._3181587grow;
      }
      
      public function set grow(param1:Parallel) : void
      {
         var _loc2_:Object = this._3181587grow;
         if(_loc2_ !== param1)
         {
            this._3181587grow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"grow",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get shrink() : Parallel
      {
         return this._903068151shrink;
      }
      
      public function set shrink(param1:Parallel) : void
      {
         var _loc2_:Object = this._903068151shrink;
         if(_loc2_ !== param1)
         {
            this._903068151shrink = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shrink",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get wipeUp1() : WipeUp
      {
         return this._1351344943wipeUp1;
      }
      
      public function set wipeUp1(param1:WipeUp) : void
      {
         var _loc2_:Object = this._1351344943wipeUp1;
         if(_loc2_ !== param1)
         {
            this._1351344943wipeUp1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wipeUp1",_loc2_,param1));
            }
         }
      }
   }
}

