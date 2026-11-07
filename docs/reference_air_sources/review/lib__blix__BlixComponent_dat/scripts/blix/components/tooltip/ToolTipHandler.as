package blix.components.tooltip
{
   import blix.IDestructible;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.frame.getEnterFrame;
   import blix.util.layout.MatrixUtils;
   import blix.util.math.clamp;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ToolTipHandler implements IToolTipHandler, IDestructible
   {
      
      public static const TOOL_TIP_WEIGHT:Number = 1000;
      
      public var mouseSize:Point = new Point(15,20);
      
      public var gap:Point = new Point(0,0);
      
      public var showDelay:int = 1000;
      
      public var hideDelay:int = 100;
      
      protected var parent:DisplayObjectContainerProxy;
      
      protected var parentBounds:Rectangle;
      
      protected var _view:DisplayObjectProxy;
      
      public function ToolTipHandler(param1:DisplayObjectProxy = null)
      {
         super();
         this.setView(param1);
      }
      
      public function getView() : DisplayObjectProxy
      {
         return this._view;
      }
      
      public function setView(param1:DisplayObjectProxy) : void
      {
         this._view = param1;
         if(this._view != null)
         {
            this._view.setWeight(TOOL_TIP_WEIGHT);
         }
      }
      
      public function createToolTip(param1:DisplayObjectContainerProxy, param2:*, param3:InteractiveObjectProxy) : void
      {
         if(this._view == null)
         {
            return;
         }
         this.parent = param1;
         if(this._view is IDataRenderer)
         {
            (this._view as IDataRenderer).setData(param2);
         }
         this.parentBounds = param1.getUnscaledBounds();
         param1.addChild(this._view);
         getEnterFrame().add(this.update);
         this.update();
      }
      
      public function destroyToolTip() : void
      {
         if(this.parent != null)
         {
            getEnterFrame().remove(this.update);
            this.parent.removeChild(this._view);
         }
      }
      
      protected function update() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Point = null;
         if(this.parent != null)
         {
            _loc1_ = MatrixUtils.getTranslatedBounds(this._view,this.parent);
            _loc1_.x = 0;
            _loc1_.y = 0;
            _loc2_ = new Point(this.parent.getMouseX(),this.parent.getMouseY());
            _loc3_ = _loc2_.add(this.mouseSize).add(this.gap).add(_loc1_.bottomRight);
            _loc4_ = _loc3_.x > this.parentBounds.right;
            _loc5_ = _loc3_.y > this.parentBounds.bottom;
            if(_loc4_)
            {
               if(_loc5_)
               {
                  _loc6_ = new Point(_loc2_.x - this.gap.x - _loc1_.width,_loc2_.y - this.gap.y - _loc1_.height);
               }
               else
               {
                  _loc6_ = new Point(_loc2_.x - this.gap.x - _loc1_.width,_loc2_.y + this.mouseSize.y + this.gap.y);
               }
            }
            else if(_loc5_)
            {
               _loc6_ = new Point(_loc2_.x + this.mouseSize.x + this.gap.x,_loc2_.y - this.gap.y - _loc1_.height);
            }
            else
            {
               _loc6_ = _loc2_.add(this.mouseSize).add(this.gap);
            }
            _loc6_.x = clamp(_loc6_.x,this.parentBounds.left,this.parentBounds.right - _loc1_.width);
            _loc6_.y = clamp(_loc6_.y,this.parentBounds.top,this.parentBounds.bottom - _loc1_.height);
            this._view.setExplicitPosition(_loc6_.x,_loc6_.y);
         }
      }
      
      public function getShowDelay() : Number
      {
         return this.showDelay;
      }
      
      public function getHideDelay() : Number
      {
         return this.hideDelay;
      }
      
      public function getPreserveToolTip() : Boolean
      {
         return false;
      }
      
      public function toString() : String
      {
         return "[ToolTipHandler target=" + this._view + "]";
      }
      
      public function destroy() : void
      {
         this.destroyToolTip();
         this._view = null;
      }
   }
}

