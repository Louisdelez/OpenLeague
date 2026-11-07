package blix.components.loader
{
   import blix.action.LoaderAction;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SimpleChild;
   import blix.context.Context;
   import blix.frame.getEnterFrame;
   import blix.signals.ISignal;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class LoaderX extends DisplayObjectContainerProxy
   {
      
      public var loaderAction:LoaderAction;
      
      public function LoaderX(param1:Context, param2:Sprite = null, param3:Boolean = false)
      {
         super(param1,param2 || new Sprite());
         if(!param3)
         {
            this.loaderAction.getErred().add(this.erredHandler);
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.loaderAction = new LoaderAction();
         this.loaderAction.setIsOptional(true);
         this.loaderAction.getInvoked().add(this.invokedHandler);
         this.loaderAction.getCompleted().add(this.completedHandler);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         addChild(new SimpleChild(this.loaderAction.loader));
      }
      
      private function invokedHandler() : void
      {
         this.loaderAction.loader.visible = false;
      }
      
      private function completedHandler() : void
      {
         getEnterFrame().addOnce(this.showContentHandler);
         invalidateLayout();
      }
      
      private function showContentHandler() : void
      {
         this.loaderAction.loader.visible = true;
      }
      
      public function getIsFinished() : Boolean
      {
         return this.loaderAction.getIsFinished();
      }
      
      public function getProgress() : ISignal
      {
         return this.loaderAction.getProgress();
      }
      
      public function getCompleted() : ISignal
      {
         return this.loaderAction.getCompleted();
      }
      
      public function getErred() : ISignal
      {
         return this.loaderAction.getErred();
      }
      
      protected function erredHandler() : void
      {
         _logger.logWarn(this.loaderAction.getError().message);
      }
      
      public function unload() : void
      {
         this.loaderAction.unload();
      }
      
      public function unloadAndStop(param1:Boolean = true) : void
      {
         this.loaderAction.unloadAndStop(param1);
      }
      
      public function load(param1:URLRequest, param2:LoaderContext = null) : void
      {
         this.loaderAction.reset();
         this.loaderAction.load(param1,param2);
      }
      
      public function loadBytes(param1:ByteArray, param2:LoaderContext = null) : void
      {
         this.loaderAction.reset();
         this.loaderAction.loadBytes(param1,param2);
      }
      
      public function getPercentLoaded() : Number
      {
         return this.loaderAction.getPercentLoaded();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.loaderAction.destroy();
      }
   }
}

