package com.riotgames.pvpnet.chrome.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.riotgames.pvpnet.chrome.ChromeController;
   import com.riotgames.pvpnet.system.cursor.CursorManager;
   import com.riotgames.pvpnet.system.cursor.NativeCursors;
   import com.riotgames.util.logging.getLogger;
   import mx.logging.ILogger;
   
   public class ResizeHandleView extends SpriteProxy
   {
      
      private var _cursorId:String;
      
      private var _edgeOrCorner:String;
      
      private var _showMouseCursor:Boolean;
      
      private var logger:ILogger = getLogger(this);
      
      public function ResizeHandleView(param1:IContext, param2:String, param3:String)
      {
         super(param1);
         this._cursorId = param2;
         this._edgeOrCorner = param3;
         getMouseIsOverChanged().add(this.refreshState);
         getMouseIsDownChanged().add(this.refreshState);
         getMouseIsDownChanged().add(this.mouseIsDownChangedHandler);
      }
      
      private function refreshState() : void
      {
         if(Boolean(getMouseIsDown()) || Boolean(getMouseIsOver()))
         {
            this.setShowMouseCursor(true);
         }
         else
         {
            this.setShowMouseCursor(false);
         }
      }
      
      private function setShowMouseCursor(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this._showMouseCursor == param1)
         {
            return;
         }
         this._showMouseCursor = param1;
         if(param1)
         {
            CursorManager.addCursor(this._cursorId,NativeCursors.RESIZE_PRIORITY);
         }
         else
         {
            _loc2_ = Boolean(CursorManager.removeCursor(this._cursorId,NativeCursors.RESIZE_PRIORITY));
            if(!_loc2_)
            {
               this.logger.warn("Could not remove the cursor with id: " + this._cursorId);
            }
         }
      }
      
      private function mouseIsDownChangedHandler() : void
      {
         var _loc1_:ChromeController = null;
         if(_mouseIsDown)
         {
            _loc1_ = getDependency(ChromeController);
            _loc1_.resize(this._edgeOrCorner);
         }
      }
   }
}

