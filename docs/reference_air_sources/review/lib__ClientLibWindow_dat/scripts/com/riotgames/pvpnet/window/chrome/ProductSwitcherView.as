package com.riotgames.pvpnet.window.chrome
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.pvpnet.system.product.IMultiProductProvider;
   import com.riotgames.pvpnet.system.product.IProductProvider;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class ProductSwitcherView extends StatefulView
   {
      
      private var multiProductProvider:IMultiProductProvider;
      
      private var currentSocket:ProductSocket;
      
      private var _productSocketCount:uint = 5;
      
      private var sockets:Vector.<ProductSocket>;
      
      private var buttons:Dictionary = new Dictionary();
      
      public function ProductSwitcherView(param1:IContext, param2:IMultiProductProvider, param3:uint = 5)
      {
         super(param1);
         this.multiProductProvider = param2;
         this._productSocketCount = param3;
         this.setupProductListener();
      }
      
      override protected function createChildren() : void
      {
         var _loc2_:ProductSocket = null;
         this.currentSocket = new ProductSocket(this);
         setTimelineChildByName("currentSocket",this.currentSocket);
         this.sockets = new Vector.<ProductSocket>();
         var _loc1_:int = 0;
         while(_loc1_ < this._productSocketCount)
         {
            _loc2_ = new ProductSocket(this);
            setTimelineChildByName("socket" + (_loc1_ + 1).toString(),_loc2_);
            this.sockets.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function setupProductListener() : void
      {
         var _loc1_:IProductProvider = null;
         var _loc2_:DisplayObjectProxy = null;
         this.multiProductProvider.getCurrentProductChanged().add(this.updateProductDisplay);
         if(this.multiProductProvider.getProducts().length > 1)
         {
            for each(_loc1_ in this.multiProductProvider.getProducts())
            {
               if(_loc1_ != null)
               {
                  _loc2_ = _loc1_.getProductButton();
                  if(_loc2_ != null)
                  {
                     addChild(_loc2_);
                     this.buttons[_loc1_] = _loc2_;
                     _loc2_.setTransformBehavior(new ScalingTransformBehavior());
                     _loc2_.addEventListener(MouseEvent.CLICK,this.buttonClickedHandler);
                  }
               }
            }
         }
         else
         {
            this.setVisible(false);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc4_:IProductProvider = null;
         var _loc5_:DisplayObjectProxy = null;
         var _loc6_:ProductSocket = null;
         var _loc7_:DisplayObjectProxy = null;
         var _loc8_:Rectangle = null;
         var _loc3_:int = 0;
         if(this.multiProductProvider.getProducts().length > 1)
         {
            for each(_loc4_ in this.multiProductProvider.getProducts())
            {
               _loc5_ = null;
               _loc6_ = null;
               _loc7_ = this.buttons[_loc4_];
               if(_loc7_ != null)
               {
                  if(_loc4_ == this.multiProductProvider.getCurrentProduct())
                  {
                     _loc5_ = this.currentSocket.getProductPlacement();
                     _loc6_ = this.currentSocket;
                  }
                  else if(_loc3_ < this._productSocketCount)
                  {
                     _loc5_ = this.sockets[_loc3_].getProductPlacement();
                     _loc6_ = this.sockets[_loc3_];
                     _loc6_.setVisible(true);
                     _loc3_++;
                  }
                  if(_loc5_ != null)
                  {
                     _loc8_ = _loc5_.getRect(getAsset());
                     _loc7_.setExplicitSize(_loc8_.width,_loc8_.height);
                     _loc7_.setExplicitPosition(_loc8_.x,_loc8_.y);
                     if(_loc7_.getParentDisplayContainer() != this)
                     {
                        addChild(_loc7_);
                     }
                  }
               }
            }
            while(_loc3_ < this._productSocketCount)
            {
               this.sockets[_loc3_].setVisible(false);
               _loc3_++;
            }
         }
         return super.updateLayout(param1,param2);
      }
      
      private function updateProductDisplay() : void
      {
      }
      
      private function buttonClickedHandler(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:IProductProvider = null;
         var _loc2_:DisplayObjectProxy = param1.target as DisplayObjectProxy;
         if(_loc2_ != null)
         {
            for(_loc3_ in this.buttons)
            {
               _loc4_ = _loc3_ as IProductProvider;
               if(_loc4_ != null && this.buttons[_loc4_] == _loc2_)
               {
                  this.multiProductProvider.setCurrentProduct(_loc4_);
                  _loc4_.productClickedCallback();
               }
            }
         }
      }
   }
}

