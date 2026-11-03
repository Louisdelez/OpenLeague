package com.riotgames.pvpnet.navigation
{
   import blix.IDestructible;
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import flash.net.URLVariables;
   
   public class NavigationBinding implements IDestructible
   {
      
      private var _target:INavigable;
      
      private var navigationClient:NavigationClient;
      
      public function NavigationBinding(param1:INavigable)
      {
         super();
         this._target = param1;
         this.navigationClient = new NavigationClient();
         this.navigationClient.getPathChanged().add(this.pathChangedHandler);
         this.navigationClient.getParametersChanged().add(this.parametersChangedHandler);
         if(this._target is IContext)
         {
            this.navigationClient.setDepth(getContextDepth(this._target as IContext));
            if(this._target is DisplayObjectProxy)
            {
               (this._target as DisplayObjectProxy).getIsOnStageChanged().add(this.isOnStageChangedHandler);
               this.setEnabled((this._target as DisplayObjectProxy).getIsOnStage());
            }
            else
            {
               this.setEnabled(true);
            }
         }
      }
      
      public static function getContextDepth(param1:IContext) : int
      {
         var _loc3_:IContext = null;
         var _loc2_:int = -1;
         for each(_loc3_ in param1.getContextAncestry())
         {
            if(_loc3_ is INavigable)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      private function setEnabled(param1:Boolean) : void
      {
         if(this.navigationClient.getEnabled() == param1)
         {
            return;
         }
         this.navigationClient.setEnabled(param1);
         if(param1)
         {
            this.pathChangedHandler();
            this.parametersChangedHandler();
         }
      }
      
      private function parametersChangedHandler() : void
      {
         this._target.setParameters(this.navigationClient.getParameters());
      }
      
      private function isOnStageChangedHandler(param1:DisplayObjectProxy) : void
      {
         this.setEnabled(param1.getIsOnStage());
      }
      
      public function setParameters(param1:URLVariables) : void
      {
         this.navigationClient.setParameters(param1);
      }
      
      public function setPath(param1:String) : void
      {
         this.navigationClient.setPath(param1);
      }
      
      public function getParameters() : URLVariables
      {
         return this.navigationClient.getParameters();
      }
      
      public function getParametersChanged() : ISignal
      {
         return this.navigationClient.getParametersChanged();
      }
      
      public function destroy() : void
      {
         if(this._target is IContext)
         {
            if(this._target is DisplayObjectProxy)
            {
               (this._target as DisplayObjectProxy).getIsOnStageChanged().remove(this.isOnStageChangedHandler);
            }
         }
      }
      
      private function pathChangedHandler() : void
      {
         this._target.setPath(this.navigationClient.getPath());
      }
   }
}

