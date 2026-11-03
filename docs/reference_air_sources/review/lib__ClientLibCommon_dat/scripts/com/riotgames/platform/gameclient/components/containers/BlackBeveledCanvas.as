package com.riotgames.platform.gameclient.components.containers
{
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import mx.core.ScrollPolicy;
   import mx.events.PropertyChangeEvent;
   
   public class BlackBeveledCanvas extends RiotCanvas
   {
      
      private var _enableMouseOverGlow:Boolean = true;
      
      private var glowFilter:GlowFilter = new GlowFilter(5621470,0.5,10,10);
      
      private var _selectedGlow:Boolean = false;
      
      public function BlackBeveledCanvas()
      {
         super();
      }
      
      public function onMouseOut(param1:MouseEvent) : void
      {
         this.filters = [];
      }
      
      private function set _159260547enableMouseOverGlow(param1:Boolean) : void
      {
         if(param1 == this._enableMouseOverGlow)
         {
            return;
         }
         this._enableMouseOverGlow = param1;
         if(this._enableMouseOverGlow)
         {
            this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         }
         else
         {
            this.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            this.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         }
      }
      
      public function get enableMouseOverGlow() : Boolean
      {
         return this._enableMouseOverGlow;
      }
      
      [Bindable(event="propertyChange")]
      public function set enableMouseOverGlow(param1:Boolean) : void
      {
         var _loc2_:Object = this.enableMouseOverGlow;
         if(_loc2_ !== param1)
         {
            this._159260547enableMouseOverGlow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableMouseOverGlow",_loc2_,param1));
         }
      }
      
      public function get selectedGlow() : Boolean
      {
         return this._selectedGlow;
      }
      
      override public function initialize() : void
      {
         super.initialize();
         this.horizontalScrollPolicy = ScrollPolicy.OFF;
         this.verticalScrollPolicy = ScrollPolicy.OFF;
         if(this.enableMouseOverGlow)
         {
            this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         }
      }
      
      private function set _1754851640selectedGlow(param1:Boolean) : void
      {
         this._selectedGlow = param1;
         if(this._selectedGlow)
         {
            this.filters = [this.glowFilter];
         }
         else
         {
            this.filters = [];
         }
      }
      
      public function onMouseOver(param1:MouseEvent) : void
      {
         this.filters = [this.glowFilter];
      }
      
      [Bindable(event="propertyChange")]
      public function set selectedGlow(param1:Boolean) : void
      {
         var _loc2_:Object = this.selectedGlow;
         if(_loc2_ !== param1)
         {
            this._1754851640selectedGlow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedGlow",_loc2_,param1));
         }
      }
   }
}

