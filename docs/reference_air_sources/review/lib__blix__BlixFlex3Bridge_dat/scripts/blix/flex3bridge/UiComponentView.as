package blix.flex3bridge
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.context.IContext;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import mx.core.Application;
   import mx.core.ApplicationGlobals;
   import mx.core.UIComponent;
   
   public class UiComponentView extends DisplayObjectProxy
   {
      
      private var _uiComponent:UIComponent;
      
      private var _container:Sprite = new Sprite();
      
      public function UiComponentView(param1:IContext)
      {
         super(param1,this._container);
      }
      
      public function get uiComponent() : UIComponent
      {
         return this._uiComponent;
      }
      
      public function set uiComponent(param1:UIComponent) : void
      {
         var _loc2_:UIComponent = null;
         var _loc3_:Application = null;
         if(this._uiComponent != null)
         {
            this._container.removeChild(this._uiComponent);
         }
         this._uiComponent = param1;
         if(this._uiComponent != null)
         {
            _loc2_ = this._uiComponent;
            _loc3_ = ApplicationGlobals.application as Application;
            _loc3_.addChild(_loc2_);
            _loc3_.removeChild(_loc2_);
            _loc2_.document = _loc3_;
            _loc2_.owner = _loc3_;
            this._container.addChild(_loc2_);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(this._uiComponent == null)
         {
            return new Rectangle();
         }
         this._uiComponent.validateSize(true);
         if(isNaN(param1))
         {
            param1 = Number(this._uiComponent.measuredWidth);
         }
         if(isNaN(param2))
         {
            param2 = Number(this._uiComponent.measuredHeight);
         }
         this._uiComponent.setActualSize(param1 / this._uiComponent.scaleX,param2 / this._uiComponent.scaleY);
         this._uiComponent.validateDisplayList();
         return new Rectangle(0,0,this._uiComponent.width * this._uiComponent.scaleX,this._uiComponent.height * this._uiComponent.scaleY);
      }
   }
}

