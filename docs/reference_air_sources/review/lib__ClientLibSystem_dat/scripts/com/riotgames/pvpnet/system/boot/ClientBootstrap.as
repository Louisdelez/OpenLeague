package com.riotgames.pvpnet.system.boot
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import blix.action.MultiAction;
   import blix.action.QueueAction;
   import blix.action.SequenceAction;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.pvpnet.system.boot.actions.ParsePropertiesFileAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.rust.theme.ThemeConfig;
   import com.riotgames.util.logging.getLogger;
   import flash.display.LoaderInfo;
   import flash.filesystem.File;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.logging.ILogger;
   
   public class ClientBootstrap extends BasicAction
   {
      
      protected var _invokeArguments:Array;
      
      protected var _bootSequence:SequenceAction;
      
      protected var _loaderInfo:LoaderInfo;
      
      private var logger:ILogger = getLogger(this);
      
      private var timeoutId:uint;
      
      public function ClientBootstrap(param1:LoaderInfo, param2:Array = null)
      {
         super(false);
         this._loaderInfo = param1;
         this._invokeArguments = param2;
         this._bootSequence = new SequenceAction();
         this._bootSequence.getCompleted().add(this.bootSequenceCompleted);
         this._bootSequence.getErred().add(this.bootSequenceErred);
         this.setupBootSequence();
         this.timeoutId = setTimeout(this.bootSequenceTimeoutHandler,40000);
      }
      
      private function bootSequenceTimeoutHandler() : void
      {
         this.logger.warn("[Bootstrap] Client bootstrap has not completed in 40 seconds.");
         this.logAction(this._bootSequence);
      }
      
      private function logAction(param1:IAction, param2:uint = 0) : void
      {
         var _loc3_:Vector.<IAction> = null;
         var _loc6_:IAction = null;
         if(param1 is SequenceAction)
         {
            _loc3_ = SequenceAction(param1).getActions();
         }
         else if(param1 is MultiAction)
         {
            _loc3_ = MultiAction(param1).getActions();
         }
         else if(param1 is QueueAction)
         {
            _loc3_ = QueueAction(param1).getActions();
         }
         var _loc4_:String = "";
         var _loc5_:uint = param2;
         while(Boolean(_loc5_--))
         {
            _loc4_ += "\t";
         }
         this.logger.warn(_loc4_ + param1 + ": Complete: " + param1.getHasCompleted() + " Erred: " + param1.getHasErred() + " Aborted: " + param1.getHasAborted());
         if(_loc3_ != null)
         {
            for each(_loc6_ in _loc3_)
            {
               this.logAction(_loc6_,param2 + 1);
            }
         }
      }
      
      public function get invokeArguments() : Array
      {
         return this._invokeArguments;
      }
      
      override protected function doInvocation() : void
      {
         this._bootSequence.invoke();
      }
      
      protected function setupBootSequence() : void
      {
      }
      
      protected function createPopulateConfigAction() : IAction
      {
         var _loc1_:SequenceAction = new SequenceAction();
         _loc1_.then(new ParsePropertiesFileAction(File.applicationDirectory.resolvePath("theme.properties"),[ThemeConfig.instance]));
         _loc1_.then(new ParsePropertiesFileAction(File.applicationDirectory.resolvePath("lol.properties"),[ClientConfig.instance,RiotServiceConfig.instance]));
         _loc1_.then(new ParsePropertiesFileAction(File.applicationDirectory.resolvePath("locale.properties"),[ClientConfig.instance,RiotServiceConfig.instance]));
         return _loc1_;
      }
      
      private function bootSequenceCompleted() : void
      {
         clearTimeout(this.timeoutId);
         complete();
      }
      
      private function bootSequenceErred(param1:IAction) : void
      {
         clearTimeout(this.timeoutId);
         err(new Error("Boot sequence failed: " + param1.getError().message));
      }
   }
}

