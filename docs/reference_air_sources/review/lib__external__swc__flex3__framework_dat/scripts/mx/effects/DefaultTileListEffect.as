package mx.effects
{
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
      
      private var _fadeInDuration:Number = 350;
      
      private var _moveDuration:Number = 300;
      
      private var _104087168move1:Move;
      
      private var _fadeOutDuration:Number = 350;
      
      private var _color:uint = 16777215;
      
      private var _1091442800fadeIn1:Dissolve;
      
      private var _1091442799fadeIn2:Dissolve;
      
      private var _525199167fadeOut1:Dissolve;
      
      private var _525199168fadeOut2:Dissolve;
      
      public function DefaultTileListEffect()
      {
         super();
         this.children = [_DefaultTileListEffect_Sequence1_c(),_DefaultTileListEffect_Sequence2_c()];
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeOut2() : Dissolve
      {
         return this._525199168fadeOut2;
      }
      
      private function _DefaultTileListEffect_Sequence1_c() : Sequence
      {
         var temp:Sequence = new Sequence();
         temp.children = [_DefaultTileListEffect_Dissolve1_i(),_DefaultTileListEffect_SetPropertyAction1_c(),_DefaultTileListEffect_Move1_i(),_DefaultTileListEffect_RemoveItemAction1_c(),_DefaultTileListEffect_AddItemAction1_c(),_DefaultTileListEffect_Dissolve2_i()];
         return temp;
      }
      
      private function _DefaultTileListEffect_AddItemAction2_c() : AddItemAction
      {
         var temp:AddItemAction = new AddItemAction();
         temp.filter = "replacementItem";
         return temp;
      }
      
      [Inspectable(category="General",defaultValue="300")]
      public function get moveDuration() : Number
      {
         return _moveDuration;
      }
      
      public function set color(value:Number) : void
      {
         _color = value;
         fadeOut1.color = value;
         fadeOut2.color = value;
         fadeIn1.color = value;
         fadeIn2.color = value;
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
      
      public function set moveDuration(value:Number) : void
      {
         _moveDuration = value;
         move1.duration = value;
      }
      
      private function _DefaultTileListEffect_Dissolve2_i() : Dissolve
      {
         var temp:Dissolve = new Dissolve();
         fadeIn1 = temp;
         temp.alphaFrom = 0;
         temp.alphaTo = 1;
         temp.duration = 300;
         temp.color = 16777215;
         temp.filter = "addItem";
         return temp;
      }
      
      public function set fadeOutDuration(value:Number) : void
      {
         _fadeOutDuration = value;
         fadeOut1.duration = value;
         fadeOut2.duration = value;
      }
      
      private function _DefaultTileListEffect_Dissolve4_i() : Dissolve
      {
         var temp:Dissolve = new Dissolve();
         fadeIn2 = temp;
         temp.alphaFrom = 0;
         temp.alphaTo = 1;
         temp.duration = 350;
         temp.color = 16777215;
         temp.filter = "replacementItem";
         return temp;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn1() : Dissolve
      {
         return this._1091442800fadeIn1;
      }
      
      private function _DefaultTileListEffect_Dissolve1_i() : Dissolve
      {
         var temp:Dissolve = new Dissolve();
         fadeOut1 = temp;
         temp.alphaTo = 0;
         temp.duration = 350;
         temp.filter = "removeItem";
         temp.color = 16777215;
         return temp;
      }
      
      public function set move1(param1:Move) : void
      {
         var _loc2_:Object = this._104087168move1;
         if(_loc2_ !== param1)
         {
            this._104087168move1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"move1",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get move1() : Move
      {
         return this._104087168move1;
      }
      
      private function _DefaultTileListEffect_SetPropertyAction1_c() : SetPropertyAction
      {
         var temp:SetPropertyAction = new SetPropertyAction();
         temp.name = "visible";
         temp.value = false;
         temp.filter = "removeItem";
         return temp;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn2() : Dissolve
      {
         return this._1091442799fadeIn2;
      }
      
      private function _DefaultTileListEffect_Dissolve3_i() : Dissolve
      {
         var temp:Dissolve = new Dissolve();
         fadeOut2 = temp;
         temp.alphaTo = 0;
         temp.duration = 350;
         temp.color = 16777215;
         temp.filter = "replacedItem";
         return temp;
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
      
      public function set fadeIn2(param1:Dissolve) : void
      {
         var _loc2_:Object = this._1091442799fadeIn2;
         if(_loc2_ !== param1)
         {
            this._1091442799fadeIn2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn2",_loc2_,param1));
         }
      }
      
      [Inspectable(category="General",format="Color",defaultValue="0xFFFFFF")]
      public function get color() : Number
      {
         return _color;
      }
      
      private function _DefaultTileListEffect_RemoveItemAction2_c() : RemoveItemAction
      {
         var temp:RemoveItemAction = new RemoveItemAction();
         temp.filter = "replacedItem";
         return temp;
      }
      
      public function set fadeInDuration(value:Number) : void
      {
         _fadeInDuration = value;
         fadeIn1.duration = value;
         fadeIn2.duration = value;
      }
      
      [Inspectable(category="General",defaultValue="350")]
      public function get fadeOutDuration() : Number
      {
         return _fadeOutDuration;
      }
      
      private function _DefaultTileListEffect_Move1_i() : Move
      {
         var temp:Move = new Move();
         move1 = temp;
         temp.duration = 300;
         return temp;
      }
      
      [Inspectable(category="General",defaultValue="350")]
      public function get fadeInDuration() : Number
      {
         return _fadeInDuration;
      }
      
      private function _DefaultTileListEffect_RemoveItemAction1_c() : RemoveItemAction
      {
         var temp:RemoveItemAction = new RemoveItemAction();
         temp.filter = "removeItem";
         return temp;
      }
      
      private function _DefaultTileListEffect_AddItemAction1_c() : AddItemAction
      {
         var temp:AddItemAction = new AddItemAction();
         temp.filter = "addItem";
         return temp;
      }
      
      private function _DefaultTileListEffect_Sequence2_c() : Sequence
      {
         var temp:Sequence = new Sequence();
         temp.children = [_DefaultTileListEffect_Dissolve3_i(),_DefaultTileListEffect_RemoveItemAction2_c(),_DefaultTileListEffect_AddItemAction2_c(),_DefaultTileListEffect_Dissolve4_i()];
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
      
      [Bindable(event="propertyChange")]
      public function get fadeOut1() : Dissolve
      {
         return this._525199167fadeOut1;
      }
   }
}

