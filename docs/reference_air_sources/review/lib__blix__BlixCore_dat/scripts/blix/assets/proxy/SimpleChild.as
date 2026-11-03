package blix.assets.proxy
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.display.DisplayObject;
   
   public class SimpleChild implements IDisplayChild
   {
      
      protected var _isTimelineChild:Boolean;
      
      protected var _asset:DisplayObject;
      
      protected var _assetChanged:Signal = new Signal();
      
      protected var _parentDisplayContainer:IDisplayContainer;
      
      protected var _weight:Number = 0;
      
      protected var _weightChanged:Signal = new Signal();
      
      public function SimpleChild(param1:DisplayObject = null)
      {
         super();
         this.setAsset(param1);
      }
      
      public function getParentDisplayContainer() : IDisplayContainer
      {
         return this._parentDisplayContainer;
      }
      
      public function setParentDisplayContainer(param1:IDisplayContainer) : void
      {
         if(this._parentDisplayContainer == param1)
         {
            return;
         }
         this._parentDisplayContainer = param1;
      }
      
      public function getIsTimelineChild() : Boolean
      {
         return this._isTimelineChild;
      }
      
      public function setIsTimelineChild(param1:Boolean) : void
      {
         this._isTimelineChild = param1;
      }
      
      public function getWeightChanged() : ISignal
      {
         return this._weightChanged;
      }
      
      public function getWeight() : Number
      {
         return this._weight;
      }
      
      public function setWeight(param1:Number) : void
      {
         if(this._weight == param1)
         {
            return;
         }
         var _loc2_:Number = this._weight;
         this._weight = param1;
         this._weightChanged.dispatch(this,_loc2_,this._weight);
      }
      
      public function getAssetChanged() : ISignal
      {
         return this._assetChanged;
      }
      
      public function getAsset() : DisplayObject
      {
         return this._asset;
      }
      
      public function setAsset(param1:DisplayObject) : void
      {
         if(this._asset == param1)
         {
            return;
         }
         var _loc2_:DisplayObject = this._asset;
         this._asset = param1;
         this._assetChanged.dispatch(this,_loc2_,this._asset);
      }
   }
}

