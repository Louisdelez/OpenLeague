package com.riotgames.pvpnet.docked.chat.view.accordion
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import blix.signals.Signal;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.effects.easing.Circular;
   
   public class AccordionView extends SpriteProxy
   {
      
      private var _data:Vector.<AccordionEntry>;
      
      private var _headers:Vector.<DisplayObjectProxy> = new Vector.<DisplayObjectProxy>();
      
      private var _layoutItems:Vector.<DisplayObjectProxy> = new Vector.<DisplayObjectProxy>();
      
      public var rendererClass:Class;
      
      private var activeIndex:int = -1;
      
      private var previousActiveIndex:int = -1;
      
      private var tweenObj:Object = {"progress":1};
      
      private var itemExpanded:Signal = new Signal();
      
      public function AccordionView(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      public function setData(param1:Vector.<AccordionEntry>) : void
      {
         if(this._data)
         {
            throw new Error("unsupported - can\'t setData twice on Accordion view.");
         }
         this._data = param1;
         if(this._data)
         {
            this.renderData();
         }
         this.activeIndex = 0;
      }
      
      private function renderData() : void
      {
         var _loc2_:AccordionEntry = null;
         var _loc3_:DisplayObjectProxy = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._data.length)
         {
            _loc2_ = this._data[_loc1_];
            _loc3_ = new this.rendererClass(this);
            if(_loc3_ is IDataRenderer)
            {
               IDataRenderer(_loc3_).setData(_loc2_.headerData);
            }
            this._headers.push(_loc3_);
            this._layoutItems.push(_loc3_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onHeaderClicked);
            addChild(_loc3_);
            this._layoutItems.push(_loc2_.content);
            addChild(_loc2_.content);
            _loc1_++;
         }
      }
      
      private function onHeaderClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._headers.length)
         {
            if(param1.currentTarget == this._headers[_loc2_])
            {
               this.expandItem(_loc2_);
               return;
            }
            _loc2_++;
         }
      }
      
      protected function expandItem(param1:int) : void
      {
         if(this.activeIndex == param1)
         {
            return;
         }
         this.previousActiveIndex = this.activeIndex;
         this.activeIndex = param1;
         TweenLite.killTweensOf(this.tweenObj);
         this.tweenObj.progress = 0;
         TweenLite.to(this.tweenObj,0.25,{
            "progress":1,
            "onUpdate":invalidateLayout,
            "ease":Circular.easeOut
         });
         invalidateLayout();
         this.itemExpanded.dispatch(this._data[param1]);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Number = NaN;
         var _loc4_:DisplayObjectProxy = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:DisplayObjectProxy = null;
         var _loc11_:Point = null;
         var _loc12_:DisplayObjectProxy = null;
         if(this._data)
         {
            if(isNaN(param2))
            {
               param2 = 300;
            }
            _loc3_ = 0;
            for each(_loc4_ in this._headers)
            {
               _loc11_ = _loc4_.setExplicitSize(NaN,NaN);
               _loc3_ += _loc11_.y;
            }
            _loc5_ = param2 - _loc3_;
            _loc6_ = this.tweenObj.progress * _loc5_;
            _loc7_ = (1 - this.tweenObj.progress) * _loc5_;
            _loc8_ = 0;
            while(_loc8_ < this._data.length)
            {
               _loc12_ = this._data[_loc8_].content;
               if(_loc8_ == this.activeIndex)
               {
                  _loc12_.setExplicitSize(param1,_loc6_);
               }
               else if(_loc8_ == this.previousActiveIndex)
               {
                  _loc12_.setExplicitSize(param1,_loc7_);
               }
               else
               {
                  _loc12_.setExplicitSize(param1,0);
               }
               _loc8_++;
            }
            _loc9_ = 0;
            for each(_loc10_ in this._layoutItems)
            {
               _loc10_.setExplicitPosition(0,_loc9_);
               _loc9_ += _loc10_.getScaledBounds().height;
            }
         }
         return new Rectangle(0,0,param1,param2);
      }
      
      public function getItemExpanded() : Signal
      {
         return this.itemExpanded;
      }
   }
}

