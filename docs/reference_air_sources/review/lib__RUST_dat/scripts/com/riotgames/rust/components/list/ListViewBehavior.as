package com.riotgames.rust.components.list
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.components.scroll.ScrollModel;
   import blix.frame.getEnterFrame;
   import blix.signals.Signal;
   import flash.utils.Dictionary;
   
   public class ListViewBehavior
   {
      
      private const BACKGROUND_PADDING:Number = 10;
      
      public var itemPadding:Number = 2;
      
      public var maskMargin:Number = 10;
      
      public var animate:Boolean = true;
      
      public var animationCoefficient:Number = 0.7;
      
      public var animationThreshold:Number = 1;
      
      public var backgroundPadding:Number = 10;
      
      public var render:Signal = new Signal();
      
      public var layoutHelper:IListLayoutHelper;
      
      protected var _scrollModel:ScrollModel;
      
      public var viewReady:Signal = new Signal();
      
      protected var view:DisplayObjectContainerProxy;
      
      protected var listMask:DisplayObjectProxy;
      
      protected var listContent:DisplayObjectContainerProxy;
      
      protected var listBg:DisplayObjectContainerProxy;
      
      protected var _listBgResize:Boolean;
      
      protected var listContentStartPosition:Number;
      
      protected var _rendererType:Class;
      
      protected var _rendererLinkage:String;
      
      protected var inactiveItems:Array = [];
      
      protected var itemLookup:Dictionary = new Dictionary(true);
      
      public function ListViewBehavior(param1:DisplayObjectContainerProxy)
      {
         super();
         this.view = param1;
         this._scrollModel = new ScrollModel();
         this._scrollModel.getChanged().add(this.onScrollChanged);
         this.createChildren();
      }
      
      protected function createChildren() : void
      {
         if(!this.listMask)
         {
            this.listMask = this.wire("listMask",SpriteProxy);
         }
         if(!this.listContent)
         {
            this.listContent = this.wire("listContent",SpriteProxy);
         }
         this.listContent.getAssetChanged().add(this.invalidateRender);
         if(!this.listBg)
         {
            this.listBg = this.wire("listBg",SpriteProxy);
         }
         this.view.getAssetChanged().add(this.onViewAssetChanged);
         this.onViewAssetChanged();
      }
      
      public function get scrollModel() : ScrollModel
      {
         return this._scrollModel;
      }
      
      protected function onScrollChanged() : void
      {
         this.invalidateRender();
      }
      
      public function invalidateRender() : void
      {
         getEnterFrame().add(this.doRender);
      }
      
      protected function doRender() : void
      {
         if(Boolean(this.listContent) && Boolean(this.listContent.getAsset()))
         {
            if(this.animate)
            {
               this.animateToScrollTarget();
            }
            else
            {
               this.layoutHelper.setPosition(this.listContent,this.listContentStartPosition - this._scrollModel.getClampedValue());
            }
            this.render.dispatch();
         }
         if(this.layoutHelper.getPosition(this.listContent) == this.listContentStartPosition - this._scrollModel.getClampedValue())
         {
            getEnterFrame().remove(this.doRender);
         }
      }
      
      protected function animateToScrollTarget() : void
      {
         var _loc1_:Number = this.layoutHelper.getPosition(this.listContent);
         var _loc2_:Number = this.listContentStartPosition - this._scrollModel.getClampedValue();
         var _loc3_:Number = _loc2_ - _loc1_;
         if(Math.abs(_loc3_) > this.animationThreshold)
         {
            _loc3_ *= this.animationCoefficient;
            this.layoutHelper.setPosition(this.listContent,_loc1_ + _loc3_);
         }
         else
         {
            this.layoutHelper.setPosition(this.listContent,_loc2_);
         }
      }
      
      protected function onViewAssetChanged() : void
      {
         if(Boolean(this.listContent.getAsset()) && isNaN(this.listContentStartPosition))
         {
            this.listContentStartPosition = this.layoutHelper.getPosition(this.listContent);
            this.viewReady.dispatch();
         }
      }
      
      public function set rendererType(param1:Class) : void
      {
         this._rendererType = param1;
      }
      
      public function set rendererLinkage(param1:String) : void
      {
         this._rendererLinkage = param1;
      }
      
      public function getMinVisiblePosition() : Number
      {
         if(Boolean(this.listMask) && Boolean(this.listMask.getAsset()))
         {
            return this.layoutHelper.getPosition(this.listMask) - this.layoutHelper.getPosition(this.listContent) - this.maskMargin;
         }
         return int.MIN_VALUE;
      }
      
      public function getMaxVisiblePosition() : Number
      {
         if(Boolean(this.listMask) && Boolean(this.listMask.getAsset()))
         {
            return this.layoutHelper.getPosition(this.listMask) - this.layoutHelper.getPosition(this.listContent) + this.layoutHelper.getSpan(this.listMask) + this.maskMargin;
         }
         return int.MAX_VALUE;
      }
      
      public function getPageSize() : Number
      {
         return this.layoutHelper.getSpan(this.listMask) - this.listContentStartPosition;
      }
      
      public function getContentSpan() : Number
      {
         return this.layoutHelper.getSpan(this.listContent);
      }
      
      public function removeItem(param1:IDataRenderer) : void
      {
         if(Boolean(param1))
         {
            delete this.itemLookup[param1.getData()];
            param1.setData(null);
            if(param1.getParentDisplayContainer() == this.listContent)
            {
               this.listContent.removeChild(param1);
            }
            this.inactiveItems.push(param1);
         }
      }
      
      public function getItem(param1:*) : IDataRenderer
      {
         if(Boolean(this.itemLookup[param1]))
         {
            return this.itemLookup[param1] as IDataRenderer;
         }
         var _loc2_:IDataRenderer = this.inactiveItems.pop();
         if(!_loc2_)
         {
            _loc2_ = new this._rendererType(this.view);
            if(this._rendererLinkage != null && this._rendererLinkage.length > 0)
            {
               (_loc2_ as DisplayObjectProxy).setLinkage(this._rendererLinkage);
            }
         }
         _loc2_.setData(param1);
         this.itemLookup[param1] = _loc2_;
         return _loc2_;
      }
      
      public function addItem(param1:IDataRenderer, param2:Number) : void
      {
         this.listContent.addChild(param1);
         this.layoutHelper.setPosition(param1 as DisplayObjectProxy,param2);
         if(this._listBgResize)
         {
            this.listBg.setHeight(this.layoutHelper.getSpan(this.listContent) + this.listContentStartPosition + this.backgroundPadding);
            this.listMask.setHeight(this.listBg.getHeight());
         }
      }
      
      protected function wire(param1:String, param2:Class = null) : *
      {
         if(param2 == null)
         {
            param2 = SpriteProxy;
         }
         var _loc3_:DisplayObjectProxy = new param2(this.view);
         this.view.setTimelineChildByName(param1,_loc3_);
         return _loc3_;
      }
      
      public function set resizeBg(param1:Boolean) : void
      {
         this._listBgResize = param1;
      }
      
      public function setBackgroundWidth(param1:Number) : void
      {
         this.listBg.setWidth(param1);
      }
   }
}

