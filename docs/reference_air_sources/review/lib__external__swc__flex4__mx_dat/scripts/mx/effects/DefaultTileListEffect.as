package mx.effects
{
   import mx.binding.BindingManager;
   import mx.events.PropertyChangeEvent;
   
   [Exclude(name="customFilter",kind="property")]
   [Exclude(name="repeatDelay",kind="property")]
   [Exclude(name="repeatCount",kind="property")]
   [Exclude(name="targets",kind="property")]
   [Exclude(name="target",kind="property")]
   [Exclude(name="move1",kind="property")]
   [Exclude(name="fadeOut2",kind="property")]
   [Exclude(name="fadeOut1",kind="property")]
   [Exclude(name="fadeIn2",kind="property")]
   [Exclude(name="fadeIn1",kind="property")]
   [Exclude(name="children",kind="property")]
   [Exclude(name="filter",kind="property")]
   [Exclude(name="perElementOffset",kind="property")]
   [Exclude(name="effectTargetHost",kind="property")]
   [Exclude(name="duration",kind="property")]
   public class DefaultTileListEffect extends Parallel
   {
      
      private var _1091442800fadeIn1:Dissolve;
      
      private var _1091442799fadeIn2:Dissolve;
      
      private var _525199167fadeOut1:Dissolve;
      
      private var _525199168fadeOut2:Dissolve;
      
      private var _104087168move1:Move;
      
      private var _fadeOutDuration:Number = 350;
      
      private var _fadeInDuration:Number = 350;
      
      private var _moveDuration:Number = 300;
      
      private var _color:uint = 16777215;
      
      public function DefaultTileListEffect()
      {
         super();
         this.children = [this._DefaultTileListEffect_Sequence1_c(),this._DefaultTileListEffect_Sequence2_c()];
      }
      
      [Inspectable(category="General",defaultValue="350")]
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
      
      [Inspectable(category="General",defaultValue="350")]
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
      public function get moveDuration() : Number
      {
         return this._moveDuration;
      }
      
      public function set moveDuration(value:Number) : void
      {
         this._moveDuration = value;
         this.move1.duration = value;
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
      }
      
      private function _DefaultTileListEffect_Sequence1_c() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         _loc1_.children = [this._DefaultTileListEffect_Dissolve1_i(),this._DefaultTileListEffect_SetPropertyAction1_c(),this._DefaultTileListEffect_Move1_i(),this._DefaultTileListEffect_RemoveItemAction1_c(),this._DefaultTileListEffect_AddItemAction1_c(),this._DefaultTileListEffect_Dissolve2_i()];
         return _loc1_;
      }
      
      private function _DefaultTileListEffect_Dissolve1_i() : Dissolve
      {
         var _loc1_:Dissolve = new Dissolve();
         _loc1_.alphaTo = 0;
         _loc1_.duration = 350;
         _loc1_.filter = "removeItem";
         _loc1_.color = 16777215;
         this.fadeOut1 = _loc1_;
         BindingManager.executeBindings(this,"fadeOut1",this.fadeOut1);
         return _loc1_;
      }
      
      private function _DefaultTileListEffect_SetPropertyAction1_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "visible";
         _loc1_.value = false;
         _loc1_.filter = "removeItem";
         return _loc1_;
      }
      
      private function _DefaultTileListEffect_Move1_i() : Move
      {
         var _loc1_:Move = new Move();
         _loc1_.duration = 300;
         this.move1 = _loc1_;
         BindingManager.executeBindings(this,"move1",this.move1);
         return _loc1_;
      }
      
      private function _DefaultTileListEffect_RemoveItemAction1_c() : RemoveItemAction
      {
         var _loc1_:RemoveItemAction = new RemoveItemAction();
         _loc1_.filter = "removeItem";
         return _loc1_;
      }
      
      private function _DefaultTileListEffect_AddItemAction1_c() : AddItemAction
      {
         var _loc1_:AddItemAction = new AddItemAction();
         _loc1_.filter = "addItem";
         return _loc1_;
      }
      
      private function _DefaultTileListEffect_Dissolve2_i() : Dissolve
      {
         var _loc1_:Dissolve = new Dissolve();
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.duration = 300;
         _loc1_.color = 16777215;
         _loc1_.filter = "addItem";
         this.fadeIn1 = _loc1_;
         BindingManager.executeBindings(this,"fadeIn1",this.fadeIn1);
         return _loc1_;
      }
      
      private function _DefaultTileListEffect_Sequence2_c() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         _loc1_.children = [this._DefaultTileListEffect_Dissolve3_i(),this._DefaultTileListEffect_RemoveItemAction2_c(),this._DefaultTileListEffect_AddItemAction2_c(),this._DefaultTileListEffect_Dissolve4_i()];
         return _loc1_;
      }
      
      private function _DefaultTileListEffect_Dissolve3_i() : Dissolve
      {
         var _loc1_:Dissolve = new Dissolve();
         _loc1_.alphaTo = 0;
         _loc1_.duration = 350;
         _loc1_.color = 16777215;
         _loc1_.filter = "replacedItem";
         this.fadeOut2 = _loc1_;
         BindingManager.executeBindings(this,"fadeOut2",this.fadeOut2);
         return _loc1_;
      }
      
      private function _DefaultTileListEffect_RemoveItemAction2_c() : RemoveItemAction
      {
         var _loc1_:RemoveItemAction = new RemoveItemAction();
         _loc1_.filter = "replacedItem";
         return _loc1_;
      }
      
      private function _DefaultTileListEffect_AddItemAction2_c() : AddItemAction
      {
         var _loc1_:AddItemAction = new AddItemAction();
         _loc1_.filter = "replacementItem";
         return _loc1_;
      }
      
      private function _DefaultTileListEffect_Dissolve4_i() : Dissolve
      {
         var _loc1_:Dissolve = new Dissolve();
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.duration = 350;
         _loc1_.color = 16777215;
         _loc1_.filter = "replacementItem";
         this.fadeIn2 = _loc1_;
         BindingManager.executeBindings(this,"fadeIn2",this.fadeIn2);
         return _loc1_;
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
      public function get move1() : Move
      {
         return this._104087168move1;
      }
      
      public function set move1(param1:Move) : void
      {
         var _loc2_:Object = this._104087168move1;
         if(_loc2_ !== param1)
         {
            this._104087168move1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"move1",_loc2_,param1));
            }
         }
      }
   }
}

