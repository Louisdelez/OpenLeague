package com.riotgames.platform.gameclient.init
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.watch.WatchTabProviderProxy;
   import flash.desktop.ClipboardFormats;
   import flash.desktop.NativeDragActions;
   import flash.desktop.NativeDragManager;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.NativeDragEvent;
   import flash.filesystem.File;
   
   public class DragOverlayGlue
   {
      
      private var interactiveObject:InteractiveObject;
      
      private var stage:Stage;
      
      private var dragAreaOverlayAsset:Sprite;
      
      private var dragAreaOverlay:Sprite;
      
      private var shellDispatcher:ShellDispatcher;
      
      public function DragOverlayGlue(param1:ShellDispatcher, param2:InteractiveObject, param3:Stage)
      {
         super();
         this.shellDispatcher = param1;
         this.interactiveObject = param2;
         this.stage = param3;
      }
      
      private function handleDragExitEvent(param1:NativeDragEvent) : void
      {
         this.dragAreaOverlay.visible = false;
         if(this.dragAreaOverlayAsset)
         {
            this.dragAreaOverlayAsset.visible = false;
         }
      }
      
      public function initializeDragOverlay() : void
      {
         var _loc1_:Graphics = null;
         var _loc2_:DisplayAdapter = null;
         if(this.dragAreaOverlay == null)
         {
            this.dragAreaOverlay = new Sprite();
            _loc1_ = this.dragAreaOverlay.graphics;
            _loc1_.beginFill(0,0.8);
            _loc1_.drawRect(0,0,100,100);
            _loc1_.endFill();
            this.dragAreaOverlay.visible = false;
         }
         if(Boolean(this.stage) && this.stage.numChildren > 0)
         {
            this.stage.addChildAt(this.dragAreaOverlay,1);
            this.dragAreaOverlay.width = this.stage.stageWidth;
            this.dragAreaOverlay.height = this.stage.stageHeight;
         }
         if(this.dragAreaOverlayAsset == null)
         {
            this.dragAreaOverlayAsset = new Sprite();
            this.dragAreaOverlayAsset.x = this.stage.stageWidth / 2;
            this.dragAreaOverlayAsset.y = this.stage.stageHeight / 2;
            this.dragAreaOverlayAsset.visible = false;
            this.stage.addChild(this.dragAreaOverlayAsset);
            _loc2_ = new DisplayAdapter(this.dragAreaOverlayAsset);
            WatchTabProviderProxy.instance.getDragOverlayAsset(_loc2_);
         }
         this.interactiveObject.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.handleDragEnterEvent);
         this.dragAreaOverlayAsset.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,this.handleDragExitEvent);
         this.dragAreaOverlayAsset.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.handleDragDropEvent);
      }
      
      private function handleDragEnterEvent(param1:NativeDragEvent) : void
      {
         var _loc2_:Array = null;
         if(Boolean(param1.clipboard.formats) && param1.clipboard.formats[0] == "rune")
         {
            return;
         }
         if(param1.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
         {
            _loc2_ = param1.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
            if(_loc2_.length >= 1 && (_loc2_[0] as File).extension == "rofl")
            {
               NativeDragManager.dropAction = NativeDragActions.COPY;
               if(WatchTabProviderProxy.instance.acceptDragDrop())
               {
                  NativeDragManager.acceptDragDrop(this.dragAreaOverlayAsset);
                  this.dragAreaOverlay.visible = true;
                  this.dragAreaOverlayAsset.visible = true;
               }
            }
         }
      }
      
      private function handleDragDropEvent(param1:NativeDragEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:ShellEvent = null;
         var _loc4_:File = null;
         if(param1.clipboard)
         {
            _loc2_ = param1.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc3_ = new ShellEvent(ShellEvent.FILE_DROPPED);
               for each(_loc4_ in _loc2_)
               {
                  if(_loc4_.extension == "rofl")
                  {
                     _loc3_.files.push(_loc4_);
                  }
               }
               this.shellDispatcher.dispatchEvent(_loc3_);
               this.dragAreaOverlay.visible = false;
               this.dragAreaOverlayAsset.visible = false;
            }
         }
      }
   }
}

