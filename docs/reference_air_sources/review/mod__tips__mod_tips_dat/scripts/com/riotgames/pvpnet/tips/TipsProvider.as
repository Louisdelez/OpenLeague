package com.riotgames.pvpnet.tips
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.components.tooltip.IToolTipHandler;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.ToolTipManager;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import blix.factory.ClassFactory;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.tips.config.CustomToolTipConfig;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import com.riotgames.pvpnet.tips.views.DefaultToolTipView;
   import com.riotgames.pvpnet.tips.views.FlexStageProxy;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.errors.IllegalOperationError;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class TipsProvider extends RiotModuleView implements ITipsProvider
   {
      
      private var _nativeWindowFactory:NativeWindowFactory = new NativeWindowFactory();
      
      private var _toolTipViewCache:Dictionary = new Dictionary();
      
      private var _flexStageProxy:FlexStageProxy;
      
      public function TipsProvider()
      {
         super(null);
      }
      
      internal function setModuleInfo(param1:ProviderModuleInfo) : void
      {
         loadAssets(new URLRequest(param1.getPath() + "assets/tipsAssets.swf"));
      }
      
      private function createToolTipClassFactory(param1:Class, param2:IContext, param3:ToolTipConfig) : ClassFactory
      {
         var _loc5_:CustomToolTipConfig = null;
         if(param3 is CustomToolTipConfig)
         {
            _loc5_ = CustomToolTipConfig(param3);
            if(_loc5_.viewContext != null)
            {
               param2 = _loc5_.viewContext;
            }
         }
         var _loc4_:ClassFactory = null;
         if(param3.cacheView)
         {
            _loc4_ = this._toolTipViewCache[param1] as ClassFactory;
         }
         if(_loc4_ == null)
         {
            _loc4_ = new ToolTipViewClassFactory(param1,[param2]);
            if(param3.cacheView)
            {
               this._toolTipViewCache[param1] = _loc4_;
            }
         }
         return _loc4_;
      }
      
      public function registerDeprecatedToolTipManager(param1:Stage, param2:ToolTipConfig = null) : void
      {
         if(this._flexStageProxy != null)
         {
            throw new IllegalOperationError("You can register the stage tool tip manager only once.");
         }
         if(param2 == null)
         {
            param2 = new ToolTipConfig();
         }
         var _loc3_:IToolTipHandler = new NativeWindowToolTipHandler(this,this._nativeWindowFactory,param2,this.createToolTipClassFactory(DefaultToolTipView,this,param2));
         this._flexStageProxy = new FlexStageProxy(param1);
         this._flexStageProxy.registerToolTipManager(new ToolTipManager(this._flexStageProxy,_loc3_));
      }
      
      public function assignDeprecatedToolTip(param1:InteractiveObject, param2:String) : void
      {
         var _loc3_:InteractiveObjectProxy = new InteractiveObjectProxy(this._flexStageProxy,param1);
         var _loc4_:IToolTipManager = this._flexStageProxy.getDependency(IToolTipManager);
         if(_loc4_ != null)
         {
            _loc4_.assignToolTip(_loc3_,param2);
         }
      }
      
      public function createWindowToolTipManager(param1:DisplayObjectContainerProxy, param2:ToolTipConfig = null) : IToolTipManager
      {
         if(param2 == null)
         {
            param2 = new ToolTipConfig();
         }
         var _loc3_:IToolTipHandler = new NativeWindowToolTipHandler(this,this._nativeWindowFactory,param2,this.createToolTipClassFactory(DefaultToolTipView,this,param2));
         return new ToolTipManager(param1,_loc3_);
      }
      
      public function assignCustomToolTip(param1:InteractiveObjectProxy, param2:*, param3:Class, param4:ToolTipConfig = null) : void
      {
         var _loc6_:IToolTipManager = null;
         var _loc7_:IToolTipHandler = null;
         if(param4 == null)
         {
            _loc6_ = param1.getDependency(IToolTipManager);
            if(_loc6_ is ToolTipManager)
            {
               _loc7_ = ToolTipManager(_loc6_).getDefaultToolTipHandler();
               if(_loc7_ is NativeWindowToolTipHandler)
               {
                  param4 = NativeWindowToolTipHandler(_loc7_).toolTipConfig;
               }
            }
            if(param4 == null)
            {
               param4 = new ToolTipConfig();
            }
         }
         var _loc5_:IToolTipHandler = new NativeWindowToolTipHandler(param1,this._nativeWindowFactory,param4,this.createToolTipClassFactory(param3,param1,param4));
         assignToolTip(param1,param2,_loc5_);
      }
   }
}

