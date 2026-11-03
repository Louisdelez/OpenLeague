package com.riotgames.pvpnet.tips
{
   import blix.IDestructible;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.components.tooltip.IToolTipHandler;
   import blix.context.IContext;
   import blix.factory.ClassFactory;
   import blix.frame.getEnterFrame;
   import blix.util.math.clamp;
   import blix.view.IView;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import com.riotgames.pvpnet.tips.utils.ToolTipUtils;
   import flash.display.NativeWindow;
   import flash.display.Stage;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class NativeWindowToolTipHandler implements IToolTipHandler, IDestructible
   {
      
      public static const TOOL_TIP_WEIGHT:Number = 1500;
      
      private var _viewContext:IContext;
      
      private var _nativeWindowFactory:NativeWindowFactory;
      
      private var _toolTipConfig:ToolTipConfig;
      
      private var _containerProxy:DisplayObjectContainerProxy;
      
      private var _containerWindow:NativeWindow;
      
      private var _toolTipViewClassFactory:ClassFactory;
      
      private var _toolTipView:DisplayObjectContainerProxy;
      
      private var _targetProxy:InteractiveObjectProxy;
      
      private var _targetBounds:Rectangle;
      
      public function NativeWindowToolTipHandler(param1:IContext, param2:NativeWindowFactory, param3:ToolTipConfig, param4:ClassFactory)
      {
         super();
         this._viewContext = param1;
         this._nativeWindowFactory = param2;
         this._toolTipConfig = param3;
         this._toolTipViewClassFactory = param4;
      }
      
      internal function get toolTipConfig() : ToolTipConfig
      {
         return this._toolTipConfig;
      }
      
      public function destroy() : void
      {
         this.destroyToolTip();
         if(this._containerProxy != null)
         {
            this._containerProxy.destroy();
         }
         this._toolTipView = null;
      }
      
      private function createToolTipView() : void
      {
         this._toolTipView = this._toolTipViewClassFactory.getInstance();
         this._toolTipView.setWeight(TOOL_TIP_WEIGHT);
         if(!(this._toolTipView is IDataRenderer))
         {
            throw new TypeError("Custom tool tip class is not an IDataRenderer");
         }
         this._containerProxy = new DisplayObjectContainerProxy(this._viewContext);
      }
      
      public function createToolTip(param1:DisplayObjectContainerProxy, param2:*, param3:InteractiveObjectProxy) : void
      {
         if(param3 != null && param3.getStage() != null && param3.getStage().focus != param3.getInteractiveAsset())
         {
            this._targetProxy = param3;
            if(this._toolTipView == null)
            {
               this.createToolTipView();
            }
            IDataRenderer(this._toolTipView).setData(param2);
            this._toolTipView.getUnscaledBoundsChanged().add(this.onBoundsUpdate);
            this._containerWindow = this._nativeWindowFactory.createToolTipWindow(param3.getStage().nativeWindow);
            this._containerProxy.addChild(this._toolTipView);
            this._containerProxy.setAsset(this._containerWindow.stage);
            this.onBoundsUpdate(null,null,this._toolTipView.getBounds());
         }
      }
      
      private function onBoundsUpdate(param1:IView, param2:Rectangle, param3:Rectangle) : void
      {
         if(this._containerWindow != null && !this._containerWindow.closed)
         {
            this._containerWindow.width = param3.width;
            this._containerWindow.height = param3.height;
            getEnterFrame().add(this.update);
         }
      }
      
      public function destroyToolTip() : void
      {
         this._targetBounds = null;
         getEnterFrame().remove(this.update);
         if(this._toolTipView != null)
         {
            this._toolTipView.getUnscaledBoundsChanged().remove(this.onBoundsUpdate);
            if(this._containerProxy != null)
            {
               this._containerProxy.removeChild(this._toolTipView);
            }
         }
         if(this._containerWindow != null && !this._containerWindow.closed)
         {
            this._containerWindow.visible = false;
         }
      }
      
      private function update() : void
      {
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         var _loc11_:Rectangle = null;
         if(this._targetProxy == null || !this._targetProxy.getIncludeInLayout() || this._containerWindow == null || Boolean(this._containerWindow.closed))
         {
            this._targetBounds = null;
            return;
         }
         getEnterFrame().remove(this.update);
         var _loc1_:Stage = this._targetProxy.getStage();
         this._targetProxy.validate();
         var _loc2_:Rectangle = this._targetProxy.getUnscaledBounds();
         var _loc3_:Point = this._targetProxy.localToGlobal(_loc2_.topLeft);
         var _loc4_:Point = this._targetProxy.localToGlobal(_loc2_.bottomRight);
         this._targetBounds = new Rectangle(_loc3_.x,_loc3_.y,_loc4_.x - _loc3_.x,_loc4_.y - _loc3_.y);
         var _loc5_:Point = _loc1_.nativeWindow.globalToScreen(new Point(this._targetBounds.x,this._targetBounds.y));
         this._targetBounds.x = _loc5_.x;
         this._targetBounds.y = _loc5_.y;
         var _loc6_:Point = this._toolTipView.setExplicitSize(NaN,NaN);
         var _loc7_:Rectangle = new Rectangle(this._targetBounds.x,this._targetBounds.y,_loc6_.x,_loc6_.y);
         var _loc8_:Point = null;
         if(this._toolTipConfig.toolTipPosition != null)
         {
            _loc9_ = this._toolTipConfig.toolTipPosition.calculateSourceOffset(_loc7_,this._targetBounds);
            _loc8_ = new Point(_loc7_.x + _loc9_.x,_loc7_.y + _loc9_.y);
            _loc8_.x += _loc9_.x < 0 ? -this._toolTipConfig.gap.x : this._toolTipConfig.gap.x;
            _loc8_.y += _loc9_.y < 0 ? -this._toolTipConfig.gap.y : this._toolTipConfig.gap.y;
            this.clampPositionToScreen(_loc8_,_loc7_);
         }
         else
         {
            _loc10_ = new Point(_loc1_.nativeWindow.x + _loc1_.mouseX,_loc1_.nativeWindow.y + _loc1_.mouseY);
            _loc8_ = _loc10_.add(this._toolTipConfig.mouseSize).add(this._toolTipConfig.gap);
            this.clampPositionToScreen(_loc8_,_loc7_);
            _loc11_ = new Rectangle(_loc8_.x,_loc8_.y,_loc7_.width,_loc7_.height);
            if(_loc11_.containsPoint(_loc10_))
            {
               _loc8_.x = _loc10_.x - _loc7_.width - this._toolTipConfig.mouseSize.x - this._toolTipConfig.gap.x;
               this.clampPositionToScreen(_loc8_,_loc7_);
               _loc11_.x = _loc8_.x;
               _loc11_.y = _loc8_.y;
               if(_loc11_.containsPoint(_loc10_))
               {
                  _loc8_.x = _loc10_.x - _loc7_.width - this._toolTipConfig.mouseSize.x - this._toolTipConfig.gap.x;
                  _loc8_.y = _loc10_.y - _loc7_.height - this._toolTipConfig.mouseSize.y - this._toolTipConfig.gap.y;
                  this.clampPositionToScreen(_loc8_,_loc7_);
               }
            }
         }
         this._containerWindow.x = _loc8_.x;
         this._containerWindow.y = _loc8_.y;
         if(!this._containerWindow.visible)
         {
            this._containerWindow.alwaysInFront = true;
            this._containerWindow.visible = true;
         }
      }
      
      private function clampPositionToScreen(param1:Point, param2:Rectangle) : void
      {
         var _loc3_:Rectangle = ToolTipUtils.getVisibleScreenBounds(param2.x,param2.y);
         param1.x = clamp(param1.x,_loc3_.left,_loc3_.right - param2.width);
         param1.y = clamp(param1.y,_loc3_.top,_loc3_.bottom - param2.height);
      }
      
      public function getShowDelay() : Number
      {
         return this._toolTipConfig.showDelay;
      }
      
      public function getHideDelay() : Number
      {
         return this._toolTipConfig.hideDelay;
      }
      
      public function getPreserveToolTip() : Boolean
      {
         return this.targetUnderCursor || Boolean(this._toolTipConfig.mouseOverToolTip) && this.toolTipUnderCursor;
      }
      
      private function get toolTipUnderCursor() : Boolean
      {
         if(this._toolTipView != null && Boolean(this._toolTipView.getIsOnStage()) && Boolean(this._toolTipView.getVisible()))
         {
            if(this._toolTipView.hitTestPoint(this._toolTipView.getStage().mouseX,this._toolTipView.getStage().mouseY,true))
            {
               return true;
            }
         }
         return false;
      }
      
      private function get targetUnderCursor() : Boolean
      {
         var _loc1_:Point = null;
         if(this._targetBounds == null)
         {
            return true;
         }
         if(this._targetProxy != null)
         {
            _loc1_ = this._containerWindow.globalToScreen(new Point(this._containerWindow.stage.mouseX,this._containerWindow.stage.mouseY));
            if(this.inflate(this._targetBounds).containsPoint(new Point(_loc1_.x,_loc1_.y)))
            {
               return true;
            }
         }
         return false;
      }
      
      private function inflate(param1:Rectangle) : Rectangle
      {
         var _loc2_:Rectangle = param1.clone();
         _loc2_.inflate(1,1);
         return _loc2_;
      }
   }
}

