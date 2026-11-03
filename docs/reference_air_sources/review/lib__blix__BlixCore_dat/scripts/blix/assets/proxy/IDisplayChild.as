package blix.assets.proxy
{
   import blix.signals.ISignal;
   import flash.display.DisplayObject;
   
   public interface IDisplayChild
   {
      
      function getParentDisplayContainer() : IDisplayContainer;
      
      function setParentDisplayContainer(param1:IDisplayContainer) : void;
      
      function getIsTimelineChild() : Boolean;
      
      function setIsTimelineChild(param1:Boolean) : void;
      
      function getWeightChanged() : ISignal;
      
      function getWeight() : Number;
      
      function setWeight(param1:Number) : void;
      
      function getAssetChanged() : ISignal;
      
      function getAsset() : DisplayObject;
      
      function setAsset(param1:DisplayObject) : void;
   }
}

