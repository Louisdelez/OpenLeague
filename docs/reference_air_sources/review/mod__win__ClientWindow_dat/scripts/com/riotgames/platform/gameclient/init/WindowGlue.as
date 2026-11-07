package com.riotgames.platform.gameclient.init
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.common.provider.IMainProvider;
   import com.riotgames.platform.common.provider.MainProviderProxy;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.pvpnet.system.logging.LogManager;
   import com.riotgames.pvpnet.system.maestro.MaestroProviderProxy;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import flash.desktop.NativeApplication;
   import flash.desktop.SystemTrayIcon;
   import flash.display.NativeMenu;
   import flash.display.NativeMenuItem;
   import flash.display.NativeWindowDisplayState;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getQualifiedClassName;
   import mx.core.BitmapAsset;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   
   public class WindowGlue
   {
      
      private var mackDockImage:Class = WindowGlue_mackDockImage;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var systrayImage:Class = WindowGlue_systrayImage;
      
      private var _windowCueRequested:Signal = new Signal();
      
      private var showingMain:Boolean = false;
      
      private var _windowRestoreRequested:Signal = new Signal();
      
      private var shellDispatcher:ShellDispatcher;
      
      public function WindowGlue(param1:ShellDispatcher)
      {
         super();
         this.shellDispatcher = param1;
      }
      
      private function createSystrayRootMenu() : NativeMenu
      {
         var menu:NativeMenu = new NativeMenu();
         var openNativeMenuItem:NativeMenuItem = new NativeMenuItem(ResourceManager.getInstance().getString("resources","systemTray_openMenuLabel"));
         openNativeMenuItem.addEventListener(Event.SELECT,function(param1:Event):void
         {
            restoreWindow();
         });
         menu.addItem(openNativeMenuItem);
         return menu;
      }
      
      private function handleNotifyEvent(param1:ShellEvent) : void
      {
         this._windowCueRequested.dispatch();
      }
      
      public function get windowCueRequested() : ISignal
      {
         return this._windowCueRequested;
      }
      
      public function windowDisplayStateChange(param1:String, param2:String) : void
      {
         var _loc3_:Boolean = param2 == NativeWindowDisplayState.MINIMIZED;
         if(SoundProviderProxy.instance != null)
         {
            if(_loc3_)
            {
               SoundProviderProxy.instance.applyForceMute(true);
            }
            else
            {
               SoundProviderProxy.instance.applyForceMute(false);
            }
         }
         if(param1 == NativeWindowDisplayState.MINIMIZED && param2 == NativeWindowDisplayState.NORMAL)
         {
            this.onRestore();
         }
      }
      
      public function get windowRestoreRequested() : ISignal
      {
         return this._windowRestoreRequested;
      }
      
      private function handleMinimizeEvent(param1:ShellEvent) : void
      {
         if(NativeApplication.supportsSystemTrayIcon)
         {
            NativeApplication.nativeApplication.icon.bitmaps = [new this.systrayImage()];
         }
      }
      
      private function handleExitEvent(param1:ShellEvent) : void
      {
         var _loc2_:Event = new Event(Event.EXITING,false,true);
         NativeApplication.nativeApplication.dispatchEvent(_loc2_);
         if(!_loc2_.isDefaultPrevented())
         {
            NativeApplication.nativeApplication.exit();
         }
      }
      
      private function restoreWindow() : void
      {
         this._windowRestoreRequested.dispatch();
      }
      
      private function handleMaximizeEvent(param1:ShellEvent) : void
      {
         if(NativeApplication.supportsSystemTrayIcon)
         {
            NativeApplication.nativeApplication.icon.bitmaps = [];
         }
         this.restoreWindow();
      }
      
      public function windowInit() : void
      {
         var bitmapAsset:BitmapAsset = null;
         var sysTrayIcon:SystemTrayIcon = null;
         if(NativeApplication.supportsDockIcon)
         {
            bitmapAsset = new this.mackDockImage() as BitmapAsset;
            NativeApplication.nativeApplication.icon.bitmaps = [bitmapAsset.bitmapData];
         }
         NativeApplication.nativeApplication.addEventListener(Event.EXITING,this.onExiting);
         NativeApplication.nativeApplication.autoExit = true;
         if(NativeApplication.supportsSystemTrayIcon)
         {
            sysTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
            sysTrayIcon.menu = this.createSystrayRootMenu();
            sysTrayIcon.tooltip = ResourceManager.getInstance().getString("resources","systemTray_tooltip");
            sysTrayIcon.addEventListener(MouseEvent.CLICK,function(param1:Event):void
            {
               restoreWindow();
            });
         }
         this.shellDispatcher.addEventListener(ShellEvent.EXIT,this.handleExitEvent);
         this.shellDispatcher.addEventListener(ShellEvent.NOTIFY,this.handleNotifyEvent);
         this.shellDispatcher.addEventListener(ShellEvent.RESTORE,this.handleMaximizeEvent);
         this.shellDispatcher.addEventListener(ShellEvent.MINIMIZE_TO_TRAY,this.handleMinimizeEvent);
      }
      
      public function windowClose() : void
      {
         var _loc1_:IMainProvider = null;
         if(this.showingMain)
         {
            _loc1_ = MainProviderProxy.instance;
            _loc1_.onClosing(true);
         }
         else
         {
            this.shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.EXIT));
         }
      }
      
      private function onExiting(param1:Event) : void
      {
         var _loc2_:IMainProvider = null;
         if(RiotServiceConfig.instance.startMaestro)
         {
            MaestroProviderProxy.instance.stop();
         }
         if(this.showingMain)
         {
            _loc2_ = MainProviderProxy.instance;
            _loc2_.onExiting(param1);
         }
         LogManager.instance.cleanseLogDirectory();
      }
      
      private function onRestore() : void
      {
         var _loc1_:IMainProvider = null;
         if(this.showingMain)
         {
            _loc1_ = MainProviderProxy.instance;
            _loc1_.onRestore();
         }
      }
      
      public function windowSetMainReady() : void
      {
         this.showingMain = true;
      }
   }
}

