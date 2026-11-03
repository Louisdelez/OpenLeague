package blix.flex3bridge
{
   import blix.IDestructible;
   import blix.assets.proxy.IDisplayChild;
   import blix.view.ILayoutElement;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import mx.core.UIComponent;
   
   public class BlixUiComponent extends UIComponent implements IDestructible
   {
      
      protected var _view:ILayoutElement;
      
      public function BlixUiComponent()
      {
         super();
         tabChildren = true;
         tabEnabled = true;
      }
      
      public function get view() : ILayoutElement
      {
         return this._view;
      }
      
      public function set view(param1:ILayoutElement) : void
      {
         var _loc2_:IDisplayChild = null;
         if(this._view == param1)
         {
            return;
         }
         if(this._view != null)
         {
            if(this._view is IDisplayChild)
            {
               IDisplayChild(this._view).getAssetChanged().remove(this.displayChildChangedHandler);
            }
            this._view.getLayoutInvalidated().remove(invalidateSize);
         }
         this._view = param1;
         if(this._view != null)
         {
            this._view.getLayoutInvalidated().add(invalidateSize);
            if(this._view is IDisplayChild)
            {
               _loc2_ = this._view as IDisplayChild;
               _loc2_.getAssetChanged().add(this.displayChildChangedHandler);
               this.displayChildChangedHandler(_loc2_,null,_loc2_.getAsset());
            }
         }
         invalidateDisplayList();
      }
      
      private function displayChildChangedHandler(param1:IDisplayChild, param2:DisplayObject, param3:DisplayObject) : void
      {
         if(Boolean(param2))
         {
            removeChild(param2);
         }
         if(Boolean(param3))
         {
            addChild(param3);
         }
      }
      
      override protected function measure() : void
      {
         var _loc1_:Point = null;
         if(this._view != null)
         {
            _loc1_ = this._view.setExplicitSize(explicitWidth,explicitHeight);
         }
         else
         {
            _loc1_ = new Point();
         }
         measuredMinWidth = 0;
         measuredMinHeight = 0;
         measuredWidth = _loc1_.x;
         measuredHeight = _loc1_.y;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(this._view == null)
         {
            return;
         }
         this._view.setExplicitSize(param1,param2);
      }
      
      public function destroy() : void
      {
         this.view = null;
      }
   }
}

