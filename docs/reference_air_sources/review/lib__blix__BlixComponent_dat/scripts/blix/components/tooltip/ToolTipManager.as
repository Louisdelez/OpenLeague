package blix.components.tooltip
{
   import blix.IDestructible;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.frame.getEnterFrame;
   import flash.desktop.NativeDragManager;
   import flash.system.Capabilities;
   import flash.utils.Dictionary;
   
   public class ToolTipManager implements IToolTipManager, IDestructible
   {
      
      protected var watched:Dictionary = new Dictionary(true);
      
      protected var root:DisplayObjectContainerProxy;
      
      protected var currentToolTipInfo:ToolTipInfo;
      
      protected var currentToolTipHandler:IToolTipHandler;
      
      protected var currentTarget:InteractiveObjectProxy;
      
      protected var isShowingToolTip:Boolean;
      
      private var _defaultToolTipHandler:IToolTipHandler;
      
      protected var timeInc:Number = 41;
      
      protected var showCounter:Number = -1;
      
      protected var hideCounter:Number = -1;
      
      public function ToolTipManager(param1:DisplayObjectContainerProxy, param2:IToolTipHandler)
      {
         super();
         this.root = param1;
         this.setDefaultToolTipHandler(param2);
      }
      
      public function getDefaultToolTipHandler() : IToolTipHandler
      {
         return this._defaultToolTipHandler;
      }
      
      public function setDefaultToolTipHandler(param1:IToolTipHandler) : void
      {
         if(param1 == null)
         {
            throw new Error("default tool tip handler may not be null.");
         }
         this._defaultToolTipHandler = param1;
      }
      
      public function assignToolTip(param1:InteractiveObjectProxy, param2:*, param3:IToolTipHandler = null) : void
      {
         this.unassignToolTip(param1);
         this.watched[param1] = new ToolTipInfo(param2,param3);
         param1.getMouseIsOverChanged().add(this.mouseIsOverChangedHandler);
         this.mouseIsOverChangedHandler(param1);
      }
      
      public function unassignToolTip(param1:InteractiveObjectProxy) : Boolean
      {
         if(!(param1 in this.watched))
         {
            return false;
         }
         delete this.watched[param1];
         param1.getMouseIsOverChanged().remove(this.mouseIsOverChangedHandler);
         if(this.currentTarget == param1)
         {
            this.setCurrentTarget(null);
         }
         return true;
      }
      
      private function mouseIsOverChangedHandler(param1:InteractiveObjectProxy) : void
      {
         if(Boolean(param1.getMouseIsOver()) || this.getPreserveToolTip())
         {
            this.setCurrentTarget(param1);
         }
      }
      
      protected function setCurrentTarget(param1:InteractiveObjectProxy) : void
      {
         if(param1 == this.currentTarget)
         {
            return;
         }
         if(this.currentTarget != null)
         {
            if(this.isShowingToolTip)
            {
               this.currentToolTipHandler.destroyToolTip();
               this.isShowingToolTip = false;
            }
            this.currentToolTipInfo = null;
            getEnterFrame().remove(this.enterFrameHandler);
         }
         this.currentTarget = param1 as InteractiveObjectProxy;
         if(this.currentTarget != null)
         {
            if(this.currentTarget.getStage() == null)
            {
               return;
            }
            this.hideCounter = -1;
            this.timeInc = 1000 / this.currentTarget.getStage().frameRate;
            this.currentToolTipInfo = this.watched[this.currentTarget] as ToolTipInfo;
            this.currentToolTipHandler = this.currentToolTipInfo.handler || this._defaultToolTipHandler;
            getEnterFrame().add(this.enterFrameHandler);
            this.enterFrameHandler();
         }
         else
         {
            this.showCounter = -1;
         }
      }
      
      private function enterFrameHandler() : void
      {
         if(this.currentTarget == null || this.currentToolTipInfo == null)
         {
            return;
         }
         var _loc1_:Number = this.currentToolTipHandler.getShowDelay();
         var _loc2_:Number = this.currentToolTipHandler.getHideDelay();
         if(Boolean(this.currentTarget.getMouseIsOver()) || this.getPreserveToolTip())
         {
            if(this.hideCounter > -1)
            {
               this.hideCounter -= this.timeInc;
            }
            if(this.showCounter < _loc1_)
            {
               this.showCounter += this.timeInc;
            }
         }
         else
         {
            if(this.showCounter > -1)
            {
               this.showCounter -= this.timeInc;
            }
            if(this.hideCounter < _loc2_)
            {
               this.hideCounter += this.timeInc;
            }
         }
         if(this.hideCounter >= _loc2_)
         {
            this.setCurrentTarget(null);
         }
         else if(this.showCounter >= _loc1_)
         {
            if(!this.isShowingToolTip)
            {
               if(Capabilities.playerType != "Desktop" || !NativeDragManager.isDragging)
               {
                  this.currentToolTipHandler.createToolTip(this.root,this.currentToolTipInfo.data,this.currentTarget);
                  this.isShowingToolTip = true;
               }
            }
         }
      }
      
      private function getPreserveToolTip() : Boolean
      {
         return this.isShowingToolTip && this.currentToolTipHandler != null && this.currentToolTipHandler.getPreserveToolTip();
      }
      
      public function destroy() : void
      {
         var _loc1_:* = undefined;
         this.setCurrentTarget(null);
         for(_loc1_ in this.watched)
         {
            this.unassignToolTip(_loc1_);
         }
      }
   }
}

import blix.components.tooltip.IToolTipHandler;

class ToolTipInfo
{
   
   public var data:*;
   
   public var handler:IToolTipHandler;
   
   public function ToolTipInfo(param1:*, param2:IToolTipHandler)
   {
      super();
      this.handler = param2;
      this.data = param1;
   }
}
